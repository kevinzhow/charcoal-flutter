import 'dart:io';

import 'package:io/io.dart';

import '../agent_skill.dart';
import '../environment.dart';
import '../runner.dart';

final class AgentCommand extends CharcoalCommand {
  AgentCommand(super.environment) {
    addSubcommand(AgentInstallCommand(environment));
    addSubcommand(AgentSyncCommand(environment));
  }

  @override
  String get description => 'Install or synchronize the Charcoal page-design skill.';

  @override
  String get name => 'agent';
}

abstract base class _AgentWriteCommand extends CharcoalCommand {
  _AgentWriteCommand(super.environment) {
    argParser
      ..addOption(
        'agent',
        allowed: <String>['auto', 'all', 'codex', 'claude', 'cursor'],
        defaultsTo: 'auto',
        help: 'Agent target. Auto detects existing project configuration.',
      )
      ..addOption(
        'scope',
        allowed: <String>['project', 'user'],
        defaultsTo: 'project',
        help: 'Install into the current project or current user skill directory.',
      )
      ..addOption(
        'profile',
        allowed: <String>['consumer', 'contributor'],
        defaultsTo: 'consumer',
      );
  }

  String get resultType;

  String get verb;

  @override
  int run() {
    final requestedAgent = argResults!.option('agent')!;
    final scope = argResults!.option('scope')!;
    final profile = argResults!.option('profile')!;
    final agents = resolveCharcoalAgents(
      environment.workingDirectory,
      requestedAgent,
      includeUserInstallations: scope == 'user',
    );
    late final List<CharcoalSkillInstallResult> results;
    try {
      results = installCharcoalPageDesignSkill(
        projectRoot: environment.workingDirectory,
        agents: agents,
        scope: scope,
        profile: profile,
      );
    } on FileSystemException catch (error) {
      throw CharcoalCliFailure(
        'ERR_SKILL_INSTALL',
        error.path == null ? error.message : '${error.message}: ${error.path}',
      );
    }
    environment.result(
      resultType,
      <String, Object?>{
        'agents': agents,
        'scope': scope,
        'installations': results.map((result) => result.toJson()).toList(growable: false),
      },
      text: results
          .map(
            (result) =>
                '${result.changed ? verb : 'Verified'} ${result.path} for ${result.agents.join(', ')}.',
          )
          .join('\n'),
    );
    return ExitCode.success.code;
  }
}

final class AgentInstallCommand extends _AgentWriteCommand {
  AgentInstallCommand(super.environment);

  @override
  String get description =>
      'Install the versioned Charcoal Skill and project bootstrap instructions.';

  @override
  String get name => 'install';

  @override
  String get resultType => 'agentInstall';

  @override
  String get verb => 'Installed';
}

final class AgentSyncCommand extends _AgentWriteCommand {
  AgentSyncCommand(super.environment);

  @override
  String get description => 'Refresh installed Charcoal Skills and bootstrap instructions.';

  @override
  String get name => 'sync';

  @override
  String get resultType => 'agentSync';

  @override
  String get verb => 'Synchronized';
}
