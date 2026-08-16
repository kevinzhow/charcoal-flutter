import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../agent_instructions.dart';
import '../environment.dart';
import '../runner.dart';

final class InitCommand extends CharcoalCommand {
  InitCommand(super.environment) {
    argParser
      ..addOption(
        'agent',
        allowed: <String>['codex', 'claude', 'cursor'],
        defaultsTo: 'codex',
        help: 'Agent whose project instruction file should be initialized.',
      )
      ..addOption(
        'profile',
        allowed: <String>['consumer', 'contributor'],
        defaultsTo: 'consumer',
        help: 'Consumer app rules or Charcoal repository contributor rules.',
      )
      ..addOption('path', help: 'Override the instruction file path inside this project.');
  }

  @override
  String get description => 'Add or refresh a versioned Charcoal block in agent instructions.';

  @override
  String get name => 'init';

  @override
  int run() {
    final agent = argResults!.option('agent')!;
    final profile = argResults!.option('profile')!;
    final requestedPath = argResults!.option('path') ?? _defaultPath(agent);
    final root = p.normalize(environment.workingDirectory.absolute.path);
    final targetPath = p.normalize(
      p.isAbsolute(requestedPath) ? requestedPath : p.join(root, requestedPath),
    );
    if (!p.isWithin(root, targetPath)) {
      throw CharcoalCliFailure(
        'ERR_UNSAFE_PATH',
        'The instruction file must stay inside the current project.',
        exitCode: ExitCode.usage.code,
      );
    }

    final target = File(targetPath);
    final existing = target.existsSync() ? target.readAsStringSync() : '';
    final block = buildCharcoalManagedBlock(profile);
    final markerPattern = charcoalManagedBlockPattern();
    late final String next;
    if (markerPattern.hasMatch(existing)) {
      next = existing.replaceFirst(markerPattern, block);
    } else {
      final prefix = existing.trimRight();
      final cursorFrontMatter = agent == 'cursor' && prefix.isEmpty
          ? '---\ndescription: Charcoal UI component guidance\nalwaysApply: true\n---\n\n'
          : '';
      next = '$cursorFrontMatter${prefix.isEmpty ? '' : '$prefix\n\n'}$block\n';
    }
    target.parent.createSync(recursive: true);
    target.writeAsStringSync(next);
    final relativePath = p.relative(target.path, from: root);
    environment.result(
      'init',
      <String, Object?>{
        'agent': agent,
        'profile': profile,
        'path': relativePath,
        'libraryVersion': charcoalCatalog.libraryVersion,
        'changed': next != existing,
      },
      text: '${next == existing ? 'Verified' : 'Updated'} $relativePath for $agent ($profile).',
    );
    return ExitCode.success.code;
  }
}

String _defaultPath(String agent) => switch (agent) {
  'codex' => 'AGENTS.md',
  'claude' => 'CLAUDE.md',
  'cursor' => p.join('.cursor', 'rules', 'charcoal.mdc'),
  _ => throw StateError('Unsupported agent: $agent'),
};
