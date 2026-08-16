import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:io/io.dart';

import 'commands/component_command.dart';
import 'commands/doctor_command.dart';
import 'commands/init_command.dart';
import 'commands/manifest_command.dart';
import 'commands/search_command.dart';
import 'environment.dart';

export 'environment.dart' show CharcoalCliEnvironment;

const String charcoalCliVersion = '0.1.0';

final class CharcoalCommandRunner extends CommandRunner<int> {
  CharcoalCommandRunner(this.environment)
    : super('charcoal', 'Discover, compose, and validate Charcoal UI components.') {
    argParser
      ..addFlag(
        'json',
        help: 'Emit a stable JSON envelope. This flag may appear before or after the command.',
        negatable: false,
      )
      ..addFlag('version', help: 'Print the CLI version.', negatable: false);
    addCommand(SearchCommand(environment));
    addCommand(ComponentCommand(environment));
    addCommand(ManifestCommand(environment));
    addCommand(DoctorCommand(environment));
    addCommand(InitCommand(environment));
  }

  final CharcoalCliEnvironment environment;

  Future<int> execute(List<String> arguments) async {
    try {
      return await run(arguments) ?? ExitCode.success.code;
    } on CharcoalCliFailure catch (failure) {
      environment.failure(failure);
      return failure.exitCode;
    } on UsageException catch (error) {
      environment.failure(
        CharcoalCliFailure('ERR_INVALID_ARGUMENT', error.message, exitCode: ExitCode.usage.code),
      );
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults.flag('version')) {
      environment.result(
        'version',
        <String, Object?>{'cliVersion': charcoalCliVersion},
        text: charcoalCliVersion,
      );
      return ExitCode.success.code;
    }
    return super.runCommand(topLevelResults);
  }

  @override
  void printUsage() => environment.output.write('$usage\n');
}

abstract base class CharcoalCommand extends Command<int> {
  CharcoalCommand(this.environment);

  final CharcoalCliEnvironment environment;

  @override
  void printUsage() => environment.output.write('$usage\n');
}
