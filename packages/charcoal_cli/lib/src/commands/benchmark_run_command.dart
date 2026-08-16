import 'dart:convert';
import 'dart:io';

import 'package:io/io.dart';
import 'package:path/path.dart' as p;

import '../benchmark.dart';
import '../benchmark_runner.dart';
import '../codex_benchmark_adapter.dart';
import '../environment.dart';
import '../runner.dart';

final class BenchmarkRunCommand extends CharcoalCommand {
  BenchmarkRunCommand(super.environment) {
    argParser
      ..addOption(
        'suite',
        defaultsTo: 'agent/benchmarks/v1.json',
        help: 'Benchmark suite JSON path.',
      )
      ..addOption(
        'configuration',
        allowed: charcoalBenchmarkConfigurations,
        help: 'Capability configuration presented to the candidate agent.',
      )
      ..addOption('model', help: 'Exact candidate model and version label.')
      ..addOption('grader', help: 'Exact independent grader and version label.')
      ..addOption(
        'adapter',
        allowed: <String>['codex', 'custom'],
        defaultsTo: 'codex',
        help: 'Use the bundled Codex adapter or external executor/grader commands.',
      )
      ..addOption(
        'codex',
        defaultsTo: 'codex',
        help: 'Codex CLI executable used by the bundled adapter.',
      )
      ..addOption(
        'candidate-reasoning',
        allowed: charcoalCodexReasoningEfforts,
        defaultsTo: 'medium',
        help: 'Candidate Codex reasoning effort.',
      )
      ..addOption(
        'grader-reasoning',
        allowed: charcoalCodexReasoningEfforts,
        defaultsTo: 'medium',
        help: 'Independent grader Codex reasoning effort.',
      )
      ..addOption(
        'executor',
        help: 'Custom candidate executor; required with --adapter custom.',
      )
      ..addMultiOption(
        'executor-arg',
        help: 'Argument passed to the candidate executor before the request path.',
      )
      ..addOption(
        'grader-command',
        help: 'Custom grader executable; required with --adapter custom.',
      )
      ..addMultiOption(
        'grader-arg',
        help: 'Argument passed to the grader before the request path.',
      )
      ..addOption('output', help: 'New directory that will receive evidence and results.json.')
      ..addMultiOption('case', help: 'Run only these case IDs. Repeat for multiple cases.')
      ..addOption(
        'agent-timeout',
        defaultsTo: '600',
        help: 'Candidate and grader timeout in seconds.',
      )
      ..addOption(
        'command-timeout',
        defaultsTo: '300',
        help: 'Flutter setup/analyze/test timeout in seconds.',
      )
      ..addOption(
        'flutter',
        help: 'Flutter executable path. Defaults to this workspace FVM SDK, then PATH.',
      );
  }

  @override
  String get description =>
      'Execute isolated Agent Ready cases and produce independently graded evidence.';

  @override
  String get name => 'benchmark-run';

  @override
  Future<int> run() async {
    final required = <String>[
      'configuration',
      'model',
      'grader',
      'output',
    ];
    final missing = required.where((name) => argResults!.option(name)?.trim().isEmpty != false);
    if (missing.isNotEmpty) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        'benchmark-run requires ${missing.map((name) => '--$name').join(', ')}.',
        exitCode: ExitCode.usage.code,
      );
    }
    try {
      final agentTimeout = _positiveSeconds('agent-timeout');
      final commandTimeout = _positiveSeconds('command-timeout');
      final workingRoot = _findWorkspaceRoot(environment.workingDirectory);
      final suiteFile = _resolveFile(argResults!.option('suite')!);
      if (!suiteFile.existsSync()) {
        throw CharcoalCliFailure(
          'ERR_INPUT_NOT_FOUND',
          'Benchmark suite not found: ${suiteFile.path}',
          exitCode: ExitCode.noInput.code,
        );
      }
      final suite = _decodeObject(suiteFile);
      final output = _resolveDirectory(argResults!.option('output')!);
      final commands = _adapterCommands(workingRoot);
      final flutterOption = argResults!.option('flutter');
      final flutter = flutterOption == null
          ? _workspaceFlutter(workingRoot)
          : _executable(flutterOption);
      final execution = await const CharcoalBenchmarkRunner().run(
        CharcoalBenchmarkRunOptions(
          workspaceRoot: workingRoot,
          outputDirectory: output,
          suite: suite,
          configuration: argResults!.option('configuration')!,
          model: argResults!.option('model')!,
          grader: argResults!.option('grader')!,
          executorCommand: commands.executor,
          graderCommand: commands.grader,
          flutterCommand: <String>[flutter],
          caseIds: argResults!.multiOption('case').toSet(),
          agentTimeout: Duration(seconds: agentTimeout),
          commandTimeout: Duration(seconds: commandTimeout),
        ),
      );
      final resultsPath = p.relative(
        execution.resultsFile.path,
        from: environment.workingDirectory.absolute.path,
      );
      environment.result(
        'benchmarkRun',
        <String, Object?>{
          'resultsPath': _slash(resultsPath),
          'report': execution.report.toJson(),
        },
        text:
            'Wrote $resultsPath\n'
            '${execution.report.passedCases}/${execution.report.evaluatedCases} passed; '
            'average ${execution.report.averageScore.toStringAsFixed(2)}/100.',
      );
      return execution.report.failedCases == 0 ? ExitCode.success.code : 1;
    } on CharcoalBenchmarkRunException catch (error) {
      throw CharcoalCliFailure(
        'ERR_BENCHMARK_RUN_FAILED',
        error.message,
        exitCode: ExitCode.software.code,
      );
    } on FormatException catch (error) {
      throw CharcoalCliFailure(
        'ERR_BENCHMARK_INVALID',
        'Invalid benchmark suite JSON: ${error.message}',
        exitCode: ExitCode.data.code,
      );
    }
  }

  int _positiveSeconds(String name) {
    final value = int.tryParse(argResults!.option(name)!);
    if (value == null || value < 1 || value > 86400) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        '--$name must be an integer from 1 to 86400.',
        exitCode: ExitCode.usage.code,
      );
    }
    return value;
  }

  File _resolveFile(String path) => File(
    p.normalize(
      p.isAbsolute(path) ? path : p.join(environment.workingDirectory.absolute.path, path),
    ),
  );

  Directory _resolveDirectory(String path) => Directory(
    p.normalize(
      p.isAbsolute(path) ? path : p.join(environment.workingDirectory.absolute.path, path),
    ),
  );

  String _executable(String value) {
    if (p.isAbsolute(value) || !value.contains(RegExp(r'[/\\]'))) return value;
    return p.normalize(p.join(environment.workingDirectory.absolute.path, value));
  }

  _BenchmarkAdapterCommands _adapterCommands(Directory workspaceRoot) {
    final executorArguments = argResults!.multiOption('executor-arg');
    final graderArguments = argResults!.multiOption('grader-arg');
    if (argResults!.option('adapter') == 'custom') {
      final executor = argResults!.option('executor');
      final grader = argResults!.option('grader-command');
      final missing = <String>[
        if (executor?.trim().isEmpty != false) '--executor',
        if (grader?.trim().isEmpty != false) '--grader-command',
      ];
      if (missing.isNotEmpty) {
        throw CharcoalCliFailure(
          'ERR_INVALID_ARGUMENT',
          '--adapter custom requires ${missing.join(' and ')}.',
          exitCode: ExitCode.usage.code,
        );
      }
      return _BenchmarkAdapterCommands(
        executor: <String>[_executable(executor!), ...executorArguments],
        grader: <String>[_executable(grader!), ...graderArguments],
      );
    }

    final packageConfig = File(
      p.join(workspaceRoot.path, '.dart_tool', 'package_config.json'),
    );
    if (!packageConfig.existsSync()) {
      throw const CharcoalBenchmarkRunException(
        'The bundled Codex adapter requires root package resolution; run `fvm dart pub get`.',
      );
    }
    final codex = _executable(argResults!.option('codex')!);
    List<String> adapter(String script, String reasoning, List<String> extra) => <String>[
      Platform.resolvedExecutable,
      '--packages=${packageConfig.path}',
      p.join(workspaceRoot.path, 'agent', 'adapters', script),
      '--codex',
      codex,
      '--reasoning-effort',
      reasoning,
      ...extra,
    ];
    return _BenchmarkAdapterCommands(
      executor: adapter(
        'codex_executor.dart',
        argResults!.option('candidate-reasoning')!,
        executorArguments,
      ),
      grader: adapter(
        'codex_grader.dart',
        argResults!.option('grader-reasoning')!,
        graderArguments,
      ),
    );
  }
}

final class _BenchmarkAdapterCommands {
  const _BenchmarkAdapterCommands({required this.executor, required this.grader});

  final List<String> executor;
  final List<String> grader;
}

Map<String, Object?> _decodeObject(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('${file.path} must contain a JSON object.');
  }
  return decoded;
}

Directory _findWorkspaceRoot(Directory start) {
  var current = start.absolute;
  while (current.parent.path != current.path) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('charcoal_flutter_workspace')) {
      return current;
    }
    current = current.parent;
  }
  throw const CharcoalBenchmarkRunException(
    'benchmark-run must be launched from the charcoal-flutter workspace.',
  );
}

String _workspaceFlutter(Directory root) {
  final name = Platform.isWindows ? 'flutter.bat' : 'flutter';
  final local = File(p.join(root.path, '.fvm', 'flutter_sdk', 'bin', name));
  return local.existsSync() ? local.path : name;
}

String _slash(String path) => path.replaceAll('\\', '/');
