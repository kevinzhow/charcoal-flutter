import 'dart:convert';
import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../runner.dart';

final class DoctorCommand extends CharcoalCommand {
  DoctorCommand(super.environment);

  @override
  String get description => 'Check whether the current project is ready for Charcoal-aware agents.';

  @override
  String get name => 'doctor';

  @override
  int run() {
    final root = environment.workingDirectory.absolute;
    final pubspec = File(p.join(root.path, 'pubspec.yaml'));
    final pubspecText = pubspec.existsSync() ? pubspec.readAsStringSync() : '';
    final hasWorkspacePackage = File(
      p.join(root.path, 'packages', 'charcoal_ui', 'pubspec.yaml'),
    ).existsSync();
    final hasDependency = RegExp(r'^\s*charcoal_ui\s*:', multiLine: true).hasMatch(pubspecText);
    final installedVersion = _installedPackageVersion(root, 'charcoal_ui');
    final agentFiles = <File>[
      File(p.join(root.path, 'AGENTS.md')),
      File(p.join(root.path, 'CLAUDE.md')),
      File(p.join(root.path, '.cursor', 'rules', 'charcoal.mdc')),
    ];
    final managedFile = agentFiles.where((file) {
      return file.existsSync() && file.readAsStringSync().contains('<!-- charcoal-agent:start');
    }).firstOrNull;
    final managedVersion = managedFile == null
        ? null
        : RegExp(
            r'<!-- charcoal-agent:start\s+version=([^\s]+)',
          ).firstMatch(managedFile.readAsStringSync())?.group(1);
    final checks = <Map<String, Object?>>[
      <String, Object?>{
        'id': 'pubspec',
        'status': pubspec.existsSync() ? 'pass' : 'fail',
        'message': pubspec.existsSync()
            ? 'Found pubspec.yaml.'
            : 'No pubspec.yaml in ${root.path}.',
      },
      <String, Object?>{
        'id': 'charcoal-ui',
        'status': hasDependency || hasWorkspacePackage ? 'pass' : 'fail',
        'message': hasDependency || hasWorkspacePackage
            ? 'Found Charcoal UI in this project.'
            : 'charcoal_ui is not declared as a dependency.',
      },
      <String, Object?>{
        'id': 'agent-instructions',
        'status': managedFile == null
            ? 'warn'
            : managedVersion == charcoalCatalog.libraryVersion
            ? 'pass'
            : 'fail',
        'message': managedFile == null
            ? 'No managed Charcoal agent block. Run charcoal init.'
            : managedVersion == charcoalCatalog.libraryVersion
            ? 'Found current managed instructions in '
                  '${p.relative(managedFile.path, from: root.path)}.'
            : 'Managed instructions in ${p.relative(managedFile.path, from: root.path)} '
                  'target ${managedVersion ?? 'an unknown version'}, not '
                  '${charcoalCatalog.libraryVersion}. Run charcoal init.',
      },
      <String, Object?>{
        'id': 'catalog-version',
        'status': installedVersion == null
            ? 'warn'
            : installedVersion == charcoalCatalog.libraryVersion
            ? 'pass'
            : 'fail',
        'message': installedVersion == null
            ? 'Could not resolve the installed charcoal_ui version. Run dart pub get.'
            : installedVersion == charcoalCatalog.libraryVersion
            ? 'Catalog matches installed charcoal_ui $installedVersion.'
            : 'Catalog ${charcoalCatalog.libraryVersion} does not match installed charcoal_ui '
                  '$installedVersion.',
      },
      <String, Object?>{
        'id': 'catalog',
        'status': charcoalCatalog.components.isEmpty || charcoalCatalog.tokens.isEmpty
            ? 'fail'
            : 'pass',
        'message':
            '${charcoalCatalog.components.length} components available for '
            'charcoal_ui ${charcoalCatalog.libraryVersion}; '
            '${charcoalCatalog.coverage.semanticTokens} semantic tokens and '
            '${charcoalCatalog.coverage.publicTokens} total public tokens indexed.',
      },
    ];
    final failureCount = checks.where((check) => check['status'] == 'fail').length;
    final warningCount = checks.where((check) => check['status'] == 'warn').length;
    environment.result(
      'doctor',
      <String, Object?>{
        'healthy': failureCount == 0,
        'failures': failureCount,
        'warnings': warningCount,
        'checks': checks,
      },
      text: checks
          .map(
            (check) =>
                '[${(check['status']! as String).toUpperCase()}] ${check['id']}: ${check['message']}',
          )
          .join('\n'),
    );
    return failureCount == 0 ? ExitCode.success.code : 1;
  }
}

String? _installedPackageVersion(Directory projectRoot, String packageName) {
  final packageConfig = File(p.join(projectRoot.path, '.dart_tool', 'package_config.json'));
  if (!packageConfig.existsSync()) return null;
  try {
    final config = jsonDecode(packageConfig.readAsStringSync()) as Map<String, Object?>;
    final packages = (config['packages']! as List<Object?>).cast<Map<String, Object?>>();
    final package = packages.where((entry) => entry['name'] == packageName).firstOrNull;
    if (package == null) return null;
    final packageRoot = packageConfig.uri.resolve(package['rootUri']! as String);
    final pubspec = File(p.join(File.fromUri(packageRoot).path, 'pubspec.yaml'));
    if (!pubspec.existsSync()) return null;
    return RegExp(
      r'^version:\s*([^\s]+)\s*$',
      multiLine: true,
    ).firstMatch(pubspec.readAsStringSync())?.group(1);
  } on FormatException {
    return null;
  } on FileSystemException {
    return null;
  }
}
