import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'dart_token_generator.dart';
import 'token_diff.dart';
import 'token_model.dart';

const _sourceFiles = <String, String>{
  'base.json': 'packages/theme/src/json/base.json',
  'pixiv-light.json': 'packages/theme/src/json/pixiv-light.json',
  'pixiv-dark.json': 'packages/theme/src/json/pixiv-dark.json',
};

final class TokenPipeline {
  TokenPipeline(this.root);

  final Directory root;

  Directory get _sourceDirectory => Directory('${root.path}/tokens/upstream');
  File get _manifestFile => File('${root.path}/tokens/manifest.json');
  File get _snapshotFile => File('${root.path}/tokens/snapshot.json');
  File get _diffFile => File('${root.path}/tokens/diff.md');

  Future<void> sync({required String repository, required String ref}) async {
    final repositoryParts = repository.split('/');
    if (repositoryParts.length != 2 || repositoryParts.any((part) => part.isEmpty)) {
      throw TokenGenerationException(
        'Repository must use the owner/name format, got "$repository".',
      );
    }

    final client = HttpClient();
    client.userAgent = 'charcoal-flutter-token-compiler/0.1.0';
    final githubToken = Platform.environment['GITHUB_TOKEN'];
    final staging = await Directory.systemTemp.createTemp('charcoal_flutter_tokens_');
    try {
      final commit = await _resolveCommit(
        client,
        repository: repository,
        ref: ref,
        githubToken: githubToken,
      );
      final sources = <String, String>{};
      for (final entry in _sourceFiles.entries) {
        final uri = Uri.https(
          'raw.githubusercontent.com',
          '/$repository/$commit/${entry.value}',
        );
        final contents = await _getText(client, uri, bearerToken: githubToken);
        sources[entry.key] = contents;
        await File('${staging.path}/${entry.key}').writeAsString(contents);
      }

      TokenBundle.parse(
        baseJson: sources['base.json']!,
        lightJson: sources['pixiv-light.json']!,
        darkJson: sources['pixiv-dark.json']!,
      );

      await _sourceDirectory.create(recursive: true);
      for (final entry in sources.entries) {
        await File('${_sourceDirectory.path}/${entry.key}').writeAsString(entry.value);
      }
      final manifest = <String, Object>{
        'schemaVersion': 1,
        'generatorVersion': '0.1.0',
        'upstream': <String, Object>{
          'repository': repository,
          'requestedRef': ref,
          'commit': commit,
          'files': <String, Object>{
            for (final entry in sources.entries)
              entry.key: <String, Object>{
                'path': _sourceFiles[entry.key]!,
                'sha256': sha256.convert(utf8.encode(entry.value)).toString(),
              },
          },
        },
      };
      await _manifestFile.writeAsString(_prettyJson(manifest));
      stdout.writeln('Synced Charcoal V2 tokens from $repository@$commit.');
    } finally {
      client.close(force: true);
      await staging.delete(recursive: true);
    }
  }

  Future<TokenDiff> generate({Map<String, Object>? previousSnapshot}) async {
    final before = previousSnapshot ?? await _readSnapshotIfPresent();
    final bundle = await loadBundle();
    final artifacts = await _renderArtifacts(bundle);
    for (final artifact in artifacts) {
      final file = File('${root.path}/${artifact.relativePath}');
      await file.parent.create(recursive: true);
      await file.writeAsString(artifact.contents);
    }
    await _formatDartFiles(
      artifacts
          .where((artifact) => artifact.relativePath.endsWith('.dart'))
          .map((artifact) => '${root.path}/${artifact.relativePath}')
          .toList(),
    );

    final snapshot = bundle.snapshot();
    await _snapshotFile.writeAsString(_prettyJson(snapshot));
    final diff = TokenDiff.between(before, snapshot);
    final commit = await _manifestCommit();
    await _diffFile.writeAsString(diff.renderMarkdown(upstreamCommit: commit));
    stdout
      ..writeln('Generated ${artifacts.length} Dart token artifacts.')
      ..writeln(
        'Token diff: +${diff.added.length} -${diff.removed.length} '
        '~${diff.changed.length}.',
      );
    return diff;
  }

  Future<List<String>> check() async {
    final problems = <String>[];
    problems.addAll(await _checkManifestHashes());

    final bundle = await loadBundle();
    final artifacts = await _renderArtifacts(bundle);
    final temporary = await Directory.systemTemp.createTemp('charcoal_flutter_check_');
    try {
      final temporaryDartFiles = <String>[];
      for (final artifact in artifacts) {
        final file = File('${temporary.path}/${artifact.relativePath}');
        await file.parent.create(recursive: true);
        await file.writeAsString(artifact.contents);
        if (artifact.relativePath.endsWith('.dart')) {
          temporaryDartFiles.add(file.path);
        }
      }
      await _formatDartFiles(temporaryDartFiles);
      for (final artifact in artifacts) {
        final expected = await File('${temporary.path}/${artifact.relativePath}').readAsString();
        final actualFile = File('${root.path}/${artifact.relativePath}');
        if (!await actualFile.exists()) {
          problems.add('Missing generated file ${artifact.relativePath}.');
        } else if (await actualFile.readAsString() != expected) {
          problems.add('Generated file is stale: ${artifact.relativePath}.');
        }
      }
    } finally {
      await temporary.delete(recursive: true);
    }

    final expectedSnapshot = _prettyJson(bundle.snapshot());
    if (!await _snapshotFile.exists()) {
      problems.add('Missing tokens/snapshot.json.');
    } else if (await _snapshotFile.readAsString() != expectedSnapshot) {
      problems.add('tokens/snapshot.json is stale.');
    }
    return problems;
  }

  Future<TokenDiff> diff() async {
    final bundle = await loadBundle();
    return TokenDiff.between(await _readSnapshotIfPresent(), bundle.snapshot());
  }

  Future<TokenBundle> loadBundle() async {
    for (final fileName in _sourceFiles.keys) {
      final file = File('${_sourceDirectory.path}/$fileName');
      if (!await file.exists()) {
        throw TokenGenerationException(
          'Missing ${file.path}. Run `dart run tool/tokens.dart sync --ref main` first.',
        );
      }
    }
    return TokenBundle.parse(
      baseJson: await File('${_sourceDirectory.path}/base.json').readAsString(),
      lightJson: await File('${_sourceDirectory.path}/pixiv-light.json').readAsString(),
      darkJson: await File('${_sourceDirectory.path}/pixiv-dark.json').readAsString(),
    );
  }

  Future<List<GeneratedArtifact>> _renderArtifacts(TokenBundle bundle) async =>
      DartTokenGenerator(bundle: bundle).render();

  Future<List<String>> _checkManifestHashes() async {
    if (!await _manifestFile.exists()) {
      return <String>['Missing tokens/manifest.json.'];
    }
    final decoded = jsonDecode(await _manifestFile.readAsString());
    if (decoded is! Map<String, dynamic>) {
      return <String>['tokens/manifest.json is malformed.'];
    }
    final upstream = decoded['upstream'];
    if (upstream is! Map<String, dynamic>) {
      return <String>['tokens/manifest.json has no upstream metadata.'];
    }
    final files = upstream['files'];
    if (files is! Map<String, dynamic>) {
      return <String>['tokens/manifest.json has no file hashes.'];
    }

    final problems = <String>[];
    for (final fileName in _sourceFiles.keys) {
      final metadata = files[fileName];
      if (metadata is! Map<String, dynamic> || metadata['sha256'] is! String) {
        problems.add('tokens/manifest.json has no SHA-256 for $fileName.');
        continue;
      }
      final file = File('${_sourceDirectory.path}/$fileName');
      if (!await file.exists()) {
        problems.add('Missing ${file.path}.');
        continue;
      }
      final actualHash = sha256.convert(await file.readAsBytes()).toString();
      if (metadata['sha256'] != actualHash) {
        problems.add('$fileName does not match its manifest SHA-256.');
      }
    }
    return problems;
  }

  Future<Map<String, Object>?> _readSnapshotIfPresent() async {
    if (!await _snapshotFile.exists()) {
      return null;
    }
    return decodeSnapshot(await _snapshotFile.readAsString());
  }

  Future<String?> _manifestCommit() async {
    if (!await _manifestFile.exists()) {
      return null;
    }
    final decoded = jsonDecode(await _manifestFile.readAsString());
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    final upstream = decoded['upstream'];
    if (upstream is! Map<String, dynamic>) {
      return null;
    }
    return upstream['commit'] as String?;
  }
}

Future<String> _resolveCommit(
  HttpClient client, {
  required String repository,
  required String ref,
  required String? githubToken,
}) async {
  final uri = Uri.https('api.github.com', '/repos/$repository/commits/$ref');
  final body = await _getText(
    client,
    uri,
    accept: 'application/vnd.github+json',
    bearerToken: githubToken,
  );
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic> || decoded['sha'] is! String) {
    throw TokenGenerationException('GitHub returned no commit SHA for $repository@$ref.');
  }
  return decoded['sha'] as String;
}

Future<String> _getText(
  HttpClient client,
  Uri uri, {
  String? accept,
  String? bearerToken,
}) async {
  final request = await client.getUrl(uri);
  if (accept != null) {
    request.headers.set(HttpHeaders.acceptHeader, accept);
  }
  if (bearerToken != null && bearerToken.isNotEmpty) {
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $bearerToken');
  }
  final response = await request.close();
  final body = await utf8.decoder.bind(response).join();
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw TokenGenerationException(
      'GET $uri failed with HTTP ${response.statusCode}: '
      '${body.substring(0, body.length < 300 ? body.length : 300)}',
    );
  }
  return body;
}

Future<void> _formatDartFiles(List<String> paths) async {
  if (paths.isEmpty) {
    return;
  }
  final result = await Process.run(Platform.resolvedExecutable, <String>[
    'format',
    '--language-version',
    '3.13',
    '--page-width',
    '100',
    '--trailing-commas',
    'preserve',
    ...paths,
  ]);
  if (result.exitCode != 0) {
    throw TokenGenerationException('dart format failed:\n${result.stdout}\n${result.stderr}');
  }
}

String _prettyJson(Map<String, Object> value) =>
    '${const JsonEncoder.withIndent('  ').convert(value)}\n';
