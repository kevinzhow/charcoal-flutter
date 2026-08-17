import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

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
    late final CharcoalInstructionWrite write;
    try {
      write = writeCharcoalManagedInstructions(
        projectRoot: environment.workingDirectory,
        agent: agent,
        profile: profile,
        requestedPath: argResults!.option('path'),
      );
    } on FileSystemException {
      throw CharcoalCliFailure(
        'ERR_UNSAFE_PATH',
        'The instruction file must stay inside the current project.',
        exitCode: ExitCode.usage.code,
      );
    }
    environment.result(
      'init',
      <String, Object?>{
        'agent': agent,
        'profile': profile,
        'path': write.path,
        'libraryVersion': charcoalCatalog.libraryVersion,
        'changed': write.changed,
      },
      text: '${write.changed ? 'Updated' : 'Verified'} ${write.path} for $agent ($profile).',
    );
    return ExitCode.success.code;
  }
}
