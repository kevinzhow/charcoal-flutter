import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'agent_instructions.dart';

const String charcoalPageDesignSkillName = 'charcoal-page-design';
const int charcoalPageDesignSkillVersion = 2;
const String charcoalSkillInstallManifest = '.charcoal-install.json';

final class CharcoalSkillInstallResult {
  const CharcoalSkillInstallResult({
    required this.agents,
    required this.changed,
    required this.instructionPaths,
    required this.path,
    required this.scope,
    required this.sourceHash,
  });

  final List<String> agents;
  final bool changed;
  final List<String> instructionPaths;
  final String path;
  final String scope;
  final String sourceHash;

  Map<String, Object?> toJson() => <String, Object?>{
    'agents': agents,
    'changed': changed,
    'instructionPaths': instructionPaths,
    'path': path,
    'scope': scope,
    'sourceHash': sourceHash,
  };
}

Directory? resolveCharcoalSkillSource(Directory projectRoot) {
  final directCandidates = <Directory>[
    Directory(
      p.join(
        projectRoot.absolute.path,
        'packages',
        'charcoal_cli',
        'agent',
        'skills',
        charcoalPageDesignSkillName,
      ),
    ),
    Directory(
      p.join(projectRoot.absolute.path, 'agent', 'skills', charcoalPageDesignSkillName),
    ),
  ];
  for (final candidate in directCandidates) {
    if (_isSkillDirectory(candidate)) return candidate;
  }

  final packageConfig = File(
    p.join(projectRoot.absolute.path, '.dart_tool', 'package_config.json'),
  );
  if (packageConfig.existsSync()) {
    try {
      final decoded = jsonDecode(packageConfig.readAsStringSync()) as Map<String, Object?>;
      final packages = (decoded['packages']! as List<Object?>).cast<Map<String, Object?>>();
      final package = packages.where((entry) => entry['name'] == 'charcoal_cli').firstOrNull;
      if (package != null) {
        final packageRoot = packageConfig.uri.resolve(package['rootUri']! as String);
        final candidate = Directory(
          p.join(
            File.fromUri(packageRoot).path,
            'agent',
            'skills',
            charcoalPageDesignSkillName,
          ),
        );
        if (_isSkillDirectory(candidate)) return candidate;
      }
    } on Object {
      // Fall through to workspace discovery; installation reports a clear error if no source exists.
    }
  }

  var current = Directory.current.absolute;
  while (true) {
    final candidate = Directory(
      p.join(current.path, 'agent', 'skills', charcoalPageDesignSkillName),
    );
    if (_isSkillDirectory(candidate)) return candidate;
    if (current.parent.path == current.path) return null;
    current = current.parent;
  }
}

List<String> resolveCharcoalAgents(
  Directory projectRoot,
  String requested, {
  bool includeUserInstallations = false,
}) {
  if (requested == 'all') return const <String>['codex', 'claude', 'cursor'];
  if (requested != 'auto') return <String>[requested];
  final detected = <String>{};
  if (File(p.join(projectRoot.path, 'AGENTS.md')).existsSync()) detected.add('codex');
  if (File(p.join(projectRoot.path, 'CLAUDE.md')).existsSync() ||
      Directory(p.join(projectRoot.path, '.claude')).existsSync()) {
    detected.add('claude');
  }
  if (Directory(p.join(projectRoot.path, '.cursor')).existsSync()) detected.add('cursor');
  for (final directory in <Directory>[
    ...projectCharcoalSkillDirectories(projectRoot),
    if (includeUserInstallations) ...userCharcoalSkillDirectories(),
  ]) {
    final manifest = readCharcoalSkillManifest(directory);
    final agents = manifest?['agents'];
    if (agents is List<Object?>) {
      detected.addAll(agents.whereType<String>());
    }
  }
  if (detected.isEmpty) detected.add('codex');
  final ordered = <String>['codex', 'claude', 'cursor'];
  return ordered.where(detected.contains).toList(growable: false);
}

List<Directory> projectCharcoalSkillDirectories(Directory projectRoot) => <Directory>[
  Directory(p.join(projectRoot.path, '.agents', 'skills', charcoalPageDesignSkillName)),
  Directory(p.join(projectRoot.path, '.claude', 'skills', charcoalPageDesignSkillName)),
  Directory(p.join(projectRoot.path, '.cursor', 'skills', charcoalPageDesignSkillName)),
].where((directory) => directory.existsSync()).toList(growable: false);

List<Directory> userCharcoalSkillDirectories() {
  final userHome = _userHome();
  if (userHome == null) return const <Directory>[];
  return <Directory>[
    Directory(p.join(userHome, '.agents', 'skills', charcoalPageDesignSkillName)),
    Directory(p.join(userHome, '.claude', 'skills', charcoalPageDesignSkillName)),
    Directory(p.join(userHome, '.cursor', 'skills', charcoalPageDesignSkillName)),
  ].where((directory) => directory.existsSync()).toList(growable: false);
}

List<CharcoalSkillInstallResult> installCharcoalPageDesignSkill({
  required Directory projectRoot,
  required List<String> agents,
  required String scope,
  required String profile,
}) {
  final source = resolveCharcoalSkillSource(projectRoot);
  if (source == null) {
    throw const FileSystemException(
      'The charcoal-page-design skill bundle is missing from charcoal_cli.',
    );
  }
  final sourceHash = charcoalSkillDirectoryHash(source);
  final targetGroups = <String, Set<String>>{};
  for (final agent in agents) {
    final target = _skillTarget(projectRoot, agent: agent, scope: scope);
    targetGroups.putIfAbsent(target.path, () => <String>{}).add(agent);
  }
  for (final targetPath in targetGroups.keys) {
    final target = Directory(targetPath);
    if (target.existsSync() &&
        readCharcoalSkillManifest(target) == null &&
        target.listSync().isNotEmpty) {
      throw FileSystemException(
        'Refusing to overwrite an unmanaged skill directory.',
        target.path,
      );
    }
  }
  final instructionWrites = <String, CharcoalInstructionWrite>{};
  if (scope == 'project') {
    for (final agent in agents) {
      instructionWrites[agent] = writeCharcoalManagedInstructions(
        projectRoot: projectRoot,
        agent: agent,
        profile: profile,
      );
    }
  }
  final results = <CharcoalSkillInstallResult>[];
  for (final entry in targetGroups.entries) {
    final target = Directory(entry.key);
    final beforeHash = target.existsSync() ? charcoalSkillDirectoryHash(target) : null;
    final manifestFile = File(p.join(target.path, charcoalSkillInstallManifest));
    final beforeManifest = manifestFile.existsSync() ? manifestFile.readAsStringSync() : null;
    _copySkill(source, target);
    final targetAgents = entry.value.toList()..sort();
    final manifest = <String, Object?>{
      'schemaVersion': 1,
      'skill': charcoalPageDesignSkillName,
      'skillVersion': charcoalPageDesignSkillVersion,
      'libraryVersion': charcoalCatalog.libraryVersion,
      'catalogSchemaVersion': charcoalCatalog.schemaVersion,
      'sourceHash': sourceHash,
      'agents': targetAgents,
      'scope': scope,
    };
    final nextManifest = '${const JsonEncoder.withIndent('  ').convert(manifest)}\n';
    final manifestChanged = beforeManifest != nextManifest;
    manifestFile.writeAsStringSync(nextManifest);
    final afterHash = charcoalSkillDirectoryHash(target);
    results.add(
      CharcoalSkillInstallResult(
        agents: targetAgents,
        changed: beforeHash != afterHash || manifestChanged,
        instructionPaths: <String>[
          for (final agent in targetAgents)
            if (instructionWrites[agent] case final write?) write.path,
        ],
        path: scope == 'project' ? p.relative(target.path, from: projectRoot.path) : target.path,
        scope: scope,
        sourceHash: sourceHash,
      ),
    );
  }
  return results;
}

Map<String, Object?>? readCharcoalSkillManifest(Directory directory) {
  final file = File(p.join(directory.path, charcoalSkillInstallManifest));
  if (!file.existsSync()) return null;
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    return decoded is Map<String, Object?> ? decoded : null;
  } on FormatException {
    return null;
  }
}

String charcoalSkillDirectoryHash(Directory directory) {
  if (!directory.existsSync()) return '';
  final files =
      directory
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => p.basename(file.path) != charcoalSkillInstallManifest)
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  final bytes = BytesBuilder(copy: false);
  for (final file in files) {
    final relative = p.relative(file.path, from: directory.path).replaceAll('\\', '/');
    bytes
      ..add(utf8.encode(relative))
      ..addByte(0)
      ..add(file.readAsBytesSync())
      ..addByte(0);
  }
  return sha256.convert(bytes.takeBytes()).toString();
}

bool _isSkillDirectory(Directory directory) =>
    directory.existsSync() && File(p.join(directory.path, 'SKILL.md')).existsSync();

Directory _skillTarget(Directory projectRoot, {required String agent, required String scope}) {
  late final String base;
  if (scope == 'project') {
    base = projectRoot.absolute.path;
  } else {
    final userHome = _userHome();
    if (userHome == null || userHome.trim().isEmpty) {
      throw const FileSystemException('Could not resolve the current user directory.');
    }
    base = userHome;
  }
  return switch (agent) {
    'codex' => Directory(
      p.join(base, '.agents', 'skills', charcoalPageDesignSkillName),
    ),
    'claude' => Directory(
      p.join(base, '.claude', 'skills', charcoalPageDesignSkillName),
    ),
    'cursor' => Directory(
      p.join(base, '.cursor', 'skills', charcoalPageDesignSkillName),
    ),
    _ => throw ArgumentError.value(agent, 'agent', 'Unsupported agent.'),
  };
}

String? _userHome() {
  final value = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  return value == null || value.trim().isEmpty ? null : p.normalize(value);
}

void _copySkill(Directory source, Directory target) {
  if (target.existsSync()) {
    target.deleteSync(recursive: true);
  }
  target.createSync(recursive: true);
  final sourceFiles = source
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((file) => p.basename(file.path) != charcoalSkillInstallManifest)
      .toList(growable: false);
  for (final sourceFile in sourceFiles) {
    final relative = p.relative(sourceFile.path, from: source.path);
    final targetFile = File(p.join(target.path, relative));
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsBytesSync(sourceFile.readAsBytesSync());
  }
}
