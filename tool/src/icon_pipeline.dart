import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'dart_source.dart';

const _upstreamIconPath = 'packages/icon-files/v2/svg';
const _assetRoot = 'packages/charcoal_icons/assets/v2';
const _catalogPath = 'packages/charcoal_icons/lib/src/generated/charcoal_icons.g.dart';
const _manifestPath = 'icons/manifest.json';

const _catalogClasses = <String, String>{
  '24/regular': 'CharcoalIcons',
  '24/solid': 'CharcoalSolidIcons',
  '24/color': 'CharcoalColorIcons',
  '20/regular': 'CharcoalIcons20',
  '20/solid': 'CharcoalSolidIcons20',
  '16/regular': 'CharcoalIcons16',
  '16/solid': 'CharcoalSolidIcons16',
};

const _dartReservedWords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

final class IconPipeline {
  IconPipeline(this.root);

  final Directory root;

  Directory get _assets => Directory('${root.path}/$_assetRoot');
  File get _catalog => File('${root.path}/$_catalogPath');
  File get _manifest => File('${root.path}/$_manifestPath');

  Future<void> sync({required String repository, required String ref}) async {
    final parts = repository.split('/');
    if (parts.length != 2 || parts.any((part) => part.isEmpty)) {
      throw IconPipelineException('Repository must use owner/name, got "$repository".');
    }

    final client = HttpClient()..userAgent = 'charcoal-flutter-icon-pipeline/0.1.0';
    final temporary = await Directory.systemTemp.createTemp('charcoal_flutter_icons_');
    try {
      final commit = await _resolveCommit(
        client,
        repository: repository,
        ref: ref,
        githubToken: Platform.environment['GITHUB_TOKEN'],
      );
      final checkout = Directory('${temporary.path}/checkout')..createSync(recursive: true);
      await _runGit(<String>['init', '--quiet'], workingDirectory: checkout.path);
      await _runGit(
        <String>['remote', 'add', 'origin', 'https://github.com/$repository.git'],
        workingDirectory: checkout.path,
      );
      await _runGit(
        <String>['fetch', '--quiet', '--depth=1', 'origin', commit],
        workingDirectory: checkout.path,
      );
      await _runGit(<String>['checkout', '--quiet', 'FETCH_HEAD'], workingDirectory: checkout.path);

      final source = Directory('${checkout.path}/$_upstreamIconPath');
      if (!source.existsSync()) {
        throw IconPipelineException(
          'Upstream $repository@$commit has no $_upstreamIconPath directory.',
        );
      }

      final staging = Directory('${root.path}/packages/charcoal_icons/assets/.v2-staging');
      final backup = Directory('${root.path}/packages/charcoal_icons/assets/.v2-backup');
      if (staging.existsSync()) {
        staging.deleteSync(recursive: true);
      }
      if (backup.existsSync()) {
        backup.deleteSync(recursive: true);
      }
      await _copyDirectory(source, staging);
      await _readCatalog(staging);

      if (_assets.existsSync()) {
        _assets.renameSync(backup.path);
      }
      try {
        staging.renameSync(_assets.path);
        if (backup.existsSync()) {
          backup.deleteSync(recursive: true);
        }
      } catch (_) {
        if (!_assets.existsSync() && backup.existsSync()) {
          backup.renameSync(_assets.path);
        }
        rethrow;
      }

      await generate(
        upstream: <String, Object>{
          'repository': repository,
          'requestedRef': ref,
          'commit': commit,
          'path': _upstreamIconPath,
        },
      );
      stdout.writeln('Synced Charcoal V2 icons from $repository@$commit.');
    } finally {
      client.close(force: true);
      if (temporary.existsSync()) {
        temporary.deleteSync(recursive: true);
      }
    }
  }

  Future<void> generate({Map<String, Object>? upstream}) async {
    final icons = await _readCatalog(_assets);
    final generated = await _formatDart(_renderCatalog(icons));
    await _catalog.parent.create(recursive: true);
    await _catalog.writeAsString(generated);

    final existingUpstream = upstream ?? await _readUpstreamManifest();
    if (existingUpstream == null) {
      throw const IconPipelineException(
        'Missing icons/manifest.json upstream metadata. Run `dart run tool/icons.dart sync`.',
      );
    }
    await _manifest.parent.create(recursive: true);
    await _manifest.writeAsString(_renderManifest(icons, existingUpstream));
    stdout.writeln('Generated ${icons.length} Charcoal V2 icon constants.');
  }

  Future<List<String>> check() async {
    final problems = <String>[];
    if (!_assets.existsSync()) {
      return <String>['Missing $_assetRoot.'];
    }
    final icons = await _readCatalog(_assets);
    final expectedCatalog = await _formatDart(_renderCatalog(icons));
    if (!_catalog.existsSync()) {
      problems.add('Missing generated file $_catalogPath.');
    } else if (await _catalog.readAsString() != expectedCatalog) {
      problems.add('Generated file is stale: $_catalogPath.');
    }

    final upstream = await _readUpstreamManifest();
    if (upstream == null) {
      problems.add('Missing or malformed $_manifestPath upstream metadata.');
    } else {
      final expectedManifest = _renderManifest(icons, upstream);
      if (await _manifest.readAsString() != expectedManifest) {
        problems.add('$_manifestPath does not match the bundled icon assets.');
      }
    }
    return problems;
  }

  Future<Map<String, Object>?> _readUpstreamManifest() async {
    if (!_manifest.existsSync()) {
      return null;
    }
    final decoded = jsonDecode(await _manifest.readAsString());
    if (decoded is! Map<String, dynamic> || decoded['upstream'] is! Map<String, dynamic>) {
      return null;
    }
    return (decoded['upstream'] as Map<String, dynamic>).cast<String, Object>();
  }
}

final class _IconSource {
  const _IconSource({
    required this.assetName,
    required this.bytes,
    required this.group,
    required this.name,
    required this.size,
    required this.style,
  });

  final String assetName;
  final Uint8List bytes;
  final String group;
  final String name;
  final int size;
  final String style;
}

Future<List<_IconSource>> _readCatalog(Directory directory) async {
  if (!directory.existsSync()) {
    throw IconPipelineException('Missing icon asset directory ${directory.path}.');
  }
  final icons = <_IconSource>[];
  await for (final entity in directory.list(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.svg')) {
      continue;
    }
    final relative = entity.path.substring(directory.path.length + 1).replaceAll('\\', '/');
    final parts = relative.split('/');
    if (parts.length != 3) {
      throw IconPipelineException('Unexpected V2 icon path "$relative".');
    }
    final size = int.tryParse(parts[0]);
    final style = parts[1];
    final group = '${parts[0]}/$style';
    if (size == null || !_catalogClasses.containsKey(group)) {
      throw IconPipelineException('Unsupported V2 icon group "$group".');
    }
    final name = parts[2].substring(0, parts[2].length - '.svg'.length);
    final bytes = await entity.readAsBytes();
    final source = utf8.decode(bytes);
    if (!source.contains('<svg') ||
        !source.contains('viewBox="0 0 $size $size"') ||
        !source.contains('width="$size"') ||
        !source.contains('height="$size"')) {
      throw IconPipelineException('$relative is not a square $size px SVG.');
    }
    icons.add(
      _IconSource(
        assetName: 'assets/v2/$relative',
        bytes: bytes,
        group: group,
        name: name,
        size: size,
        style: style,
      ),
    );
  }
  icons.sort((left, right) {
    final groupOrder = _catalogClasses.keys.toList();
    final groupComparison = groupOrder
        .indexOf(left.group)
        .compareTo(groupOrder.indexOf(right.group));
    return groupComparison != 0 ? groupComparison : left.name.compareTo(right.name);
  });
  if (icons.isEmpty) {
    throw const IconPipelineException('The V2 icon catalog is empty.');
  }
  for (final group in _catalogClasses.keys) {
    final identifiers = <String, String>{};
    for (final icon in icons.where((icon) => icon.group == group)) {
      final identifier = _identifier(icon.name);
      final previous = identifiers[identifier];
      if (previous != null) {
        throw IconPipelineException(
          'Icons "$previous" and "${icon.name}" collide as $identifier in $group.',
        );
      }
      identifiers[identifier] = icon.name;
    }
  }
  return icons;
}

String _renderCatalog(List<_IconSource> icons) {
  final output = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Generated from Charcoal Icons V2 by `dart run tool/icons.dart generate`.')
    ..writeln()
    ..writeln("import '../charcoal_icon_data.dart';")
    ..writeln();
  for (final entry in _catalogClasses.entries) {
    final groupIcons = icons.where((icon) => icon.group == entry.key).toList();
    output
      ..writeln('/// Charcoal V2 ${entry.key} icons.')
      ..writeln('abstract final class ${entry.value} {');
    for (final icon in groupIcons) {
      output
        ..writeln('  /// `${icon.name}` from the upstream ${entry.key} catalog.')
        ..writeln('  static const ${_identifier(icon.name)} = CharcoalIconData(')
        ..writeln('    assetName: ${dartStringLiteral(icon.assetName)},')
        ..writeln('    name: ${dartStringLiteral(icon.name)},')
        ..writeln('    nativeSize: ${icon.size},')
        ..writeln('    style: CharcoalIconStyle.${icon.style},')
        ..writeln('  );');
    }
    output
      ..writeln()
      ..writeln('  /// Every icon in this catalog, ordered by upstream name.')
      ..writeln('  static const values = <CharcoalIconData>[');
    for (final icon in groupIcons) {
      output.writeln('    ${_identifier(icon.name)},');
    }
    output.writeln('  ];');
    output
      ..writeln('}')
      ..writeln();
  }
  return output.toString();
}

String _renderManifest(List<_IconSource> icons, Map<String, Object> upstream) {
  final groups = <String, int>{
    for (final group in _catalogClasses.keys)
      group: icons.where((icon) => icon.group == group).length,
  };
  final bytes = BytesBuilder(copy: false);
  for (final icon in icons) {
    bytes
      ..add(utf8.encode(icon.assetName))
      ..addByte(0)
      ..add(icon.bytes)
      ..addByte(0);
  }
  return _prettyJson(<String, Object>{
    'schemaVersion': 1,
    'generatorVersion': '0.1.0',
    'upstream': upstream,
    'catalog': <String, Object>{
      'iconCount': icons.length,
      'sha256': sha256.convert(bytes.takeBytes()).toString(),
      'groups': groups,
    },
  });
}

String _identifier(String name) {
  final parts = name.split(RegExp(r'[^A-Za-z0-9]+')).where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) {
    throw IconPipelineException('Icon name "$name" cannot become a Dart identifier.');
  }
  var identifier = parts.first.toLowerCase();
  for (final part in parts.skip(1)) {
    identifier += '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
  }
  if (RegExp(r'^[0-9]').hasMatch(identifier)) {
    identifier = 'icon$identifier';
  }
  if (_dartReservedWords.contains(identifier)) {
    identifier = '${identifier}Icon';
  }
  return identifier;
}

Future<String> _formatDart(String source) async {
  final temporary = await Directory.systemTemp.createTemp('charcoal_icon_format_');
  try {
    final file = File('${temporary.path}/catalog.dart');
    await file.writeAsString(source);
    final result = await Process.run(
      Platform.resolvedExecutable,
      dartFormatArguments(<String>[file.path]),
    );
    if (result.exitCode != 0) {
      throw IconPipelineException('dart format failed: ${result.stderr}');
    }
    return await file.readAsString();
  } finally {
    temporary.deleteSync(recursive: true);
  }
}

Future<void> _copyDirectory(Directory source, Directory destination) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(recursive: false, followLinks: false)) {
    final targetPath =
        '${destination.path}/${entity.uri.pathSegments.lastWhere((part) => part.isNotEmpty)}';
    if (entity is Directory) {
      await _copyDirectory(entity, Directory(targetPath));
    } else if (entity is File) {
      await entity.copy(targetPath);
    }
  }
}

Future<void> _runGit(List<String> arguments, {required String workingDirectory}) async {
  final result = await Process.run('git', arguments, workingDirectory: workingDirectory);
  if (result.exitCode != 0) {
    throw IconPipelineException('git ${arguments.first} failed: ${result.stderr}');
  }
}

Future<String> _resolveCommit(
  HttpClient client, {
  required String repository,
  required String ref,
  required String? githubToken,
}) async {
  final request = await client.getUrl(
    Uri.https('api.github.com', '/repos/$repository/commits/$ref'),
  );
  request.headers
    ..set(HttpHeaders.acceptHeader, 'application/vnd.github+json')
    ..set('X-GitHub-Api-Version', '2022-11-28');
  if (githubToken != null && githubToken.isNotEmpty) {
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $githubToken');
  }
  final response = await request.close();
  final body = await response.transform(utf8.decoder).join();
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw IconPipelineException(
      'GitHub could not resolve $repository@$ref (${response.statusCode}): $body',
    );
  }
  final decoded = jsonDecode(body);
  if (decoded is! Map<String, dynamic> || decoded['sha'] is! String) {
    throw IconPipelineException('GitHub returned no commit SHA for $repository@$ref.');
  }
  return decoded['sha'] as String;
}

String _prettyJson(Object value) => '${const JsonEncoder.withIndent('  ').convert(value)}\n';

final class IconPipelineException implements Exception {
  const IconPipelineException(this.message);

  final String message;

  @override
  String toString() => message;
}
