import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:path/path.dart' as p;

import 'agent_instructions.dart';
import 'benchmark.dart';

const JsonEncoder _benchmarkJson = JsonEncoder.withIndent('  ');

const Map<String, int> _graderScoreLimits = charcoalBenchmarkGraderScoreLimits;

const Set<String> _platformControlIdentifiers = <String>{
  'AlertDialog',
  'Checkbox',
  'CupertinoButton',
  'CupertinoSwitch',
  'DropdownButton',
  'ElevatedButton',
  'FilledButton',
  'OutlinedButton',
  'ScaffoldMessenger',
  'SnackBar',
  'Switch',
  'TabBar',
  'TextButton',
  'TextField',
  'ToggleButtons',
};

/// One subprocess invocation used by the benchmark harness.
final class CharcoalBenchmarkInvocation {
  const CharcoalBenchmarkInvocation({
    required this.executable,
    required this.arguments,
    required this.workingDirectory,
    required this.environment,
    required this.timeout,
  });

  final String executable;
  final List<String> arguments;
  final Directory workingDirectory;
  final Map<String, String> environment;
  final Duration timeout;
}

/// Captured subprocess evidence without allowing output to leak into the CLI protocol stream.
final class CharcoalBenchmarkProcessResult {
  const CharcoalBenchmarkProcessResult({
    required this.exitCode,
    required this.stdoutText,
    required this.stderrText,
    this.timedOut = false,
  });

  final int exitCode;
  final String stdoutText;
  final String stderrText;
  final bool timedOut;
}

abstract interface class CharcoalBenchmarkProcessRunner {
  Future<CharcoalBenchmarkProcessResult> run(CharcoalBenchmarkInvocation invocation);
}

/// Real process implementation used by the CLI. Tests inject a deterministic runner.
final class SystemCharcoalBenchmarkProcessRunner implements CharcoalBenchmarkProcessRunner {
  const SystemCharcoalBenchmarkProcessRunner();

  @override
  Future<CharcoalBenchmarkProcessResult> run(CharcoalBenchmarkInvocation invocation) async {
    final process = await Process.start(
      invocation.executable,
      invocation.arguments,
      environment: invocation.environment,
      workingDirectory: invocation.workingDirectory.path,
    );
    final stdoutFuture = process.stdout.transform(utf8.decoder).join();
    final stderrFuture = process.stderr.transform(utf8.decoder).join();
    final exitFuture = process.exitCode;
    var timedOut = false;
    late int exitCode;
    try {
      exitCode = await exitFuture.timeout(invocation.timeout);
    } on TimeoutException {
      timedOut = true;
      process.kill();
      try {
        exitCode = await exitFuture.timeout(const Duration(seconds: 2));
      } on TimeoutException {
        if (!Platform.isWindows) process.kill(ProcessSignal.sigkill);
        exitCode = await exitFuture;
      }
    }
    return CharcoalBenchmarkProcessResult(
      exitCode: exitCode,
      stdoutText: await stdoutFuture,
      stderrText: await stderrFuture,
      timedOut: timedOut,
    );
  }
}

final class CharcoalBenchmarkRunOptions {
  const CharcoalBenchmarkRunOptions({
    required this.workspaceRoot,
    required this.outputDirectory,
    required this.suite,
    required this.configuration,
    required this.model,
    required this.grader,
    required this.executorCommand,
    required this.graderCommand,
    required this.flutterCommand,
    this.caseIds = const <String>{},
    this.agentTimeout = const Duration(minutes: 10),
    this.commandTimeout = const Duration(minutes: 5),
  });

  final Directory workspaceRoot;
  final Directory outputDirectory;
  final Map<String, Object?> suite;
  final String configuration;
  final String model;
  final String grader;
  final List<String> executorCommand;
  final List<String> graderCommand;
  final List<String> flutterCommand;
  final Set<String> caseIds;
  final Duration agentTimeout;
  final Duration commandTimeout;
}

final class CharcoalBenchmarkExecution {
  const CharcoalBenchmarkExecution({
    required this.resultsFile,
    required this.report,
  });

  final File resultsFile;
  final CharcoalBenchmarkReport report;
}

final class CharcoalBenchmarkRunException implements Exception {
  const CharcoalBenchmarkRunException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Executes candidates in a disposable workspace and emits independently graded v2 evidence.
final class CharcoalBenchmarkRunner {
  const CharcoalBenchmarkRunner({
    this.processRunner = const SystemCharcoalBenchmarkProcessRunner(),
  });

  final CharcoalBenchmarkProcessRunner processRunner;

  Future<CharcoalBenchmarkExecution> run(CharcoalBenchmarkRunOptions options) async {
    _validateOptions(options);
    final cases = _selectedCases(options.suite, options.caseIds);
    options.outputDirectory.parent.createSync(recursive: true);
    options.outputDirectory.createSync();
    final sandbox = Directory.systemTemp.createTempSync('charcoal_agent_benchmark_');
    try {
      _createSandbox(sandbox, cases, options);
      final setup = await _run(
        command: <String>[...options.flutterCommand, 'pub', 'get'],
        workingDirectory: sandbox,
        timeout: options.commandTimeout,
      );
      if (setup.exitCode != 0 || setup.timedOut) {
        throw CharcoalBenchmarkRunException(
          'Could not prepare benchmark workspace.\n${_processText(setup)}',
        );
      }

      final runs = <Map<String, Object?>>[];
      for (final benchmarkCase in cases) {
        runs.add(await _runCase(sandbox, benchmarkCase, options));
      }
      final results = <String, Object?>{
        'schemaVersion': 2,
        'suite': options.suite['suite'],
        'catalogSchemaVersion': charcoalCatalog.schemaVersion,
        'libraryVersion': charcoalCatalog.libraryVersion,
        'configuration': options.configuration,
        'model': options.model,
        'grader': options.grader,
        'runs': runs,
      };
      final resultsFile = File(p.join(options.outputDirectory.path, 'results.json'))
        ..writeAsStringSync('${_benchmarkJson.convert(results)}\n');
      final allCases = options.suite['cases']! as List<Object?>;
      final report = evaluateCharcoalBenchmark(
        options.suite,
        results,
        allowPartial: cases.length != allCases.length,
      );
      return CharcoalBenchmarkExecution(resultsFile: resultsFile, report: report);
    } finally {
      if (sandbox.existsSync()) sandbox.deleteSync(recursive: true);
    }
  }

  Future<Map<String, Object?>> _runCase(
    Directory sandbox,
    Map<String, Object?> benchmarkCase,
    CharcoalBenchmarkRunOptions options,
  ) async {
    final caseId = benchmarkCase['id']! as String;
    final project = Directory(p.join(sandbox.path, 'fixtures', caseId));
    final caseOutput = Directory(p.join(options.outputDirectory.path, caseId))
      ..createSync(recursive: true);
    final candidate = File(p.join(project.path, 'lib', 'candidate.dart'));
    final instructions = File(p.join(project.path, 'AGENTS.md'));
    // Keep experiment metadata outside the candidate's working directory. The
    // adapter needs the configuration and tool wiring, but the implementation
    // agent should observe only the fixed prompt and capabilities it receives.
    final requestFile = File(
      p.join(sandbox.path, '.executor', caseId, 'executor-request.json'),
    )..parent.createSync(recursive: true);
    final relativeCandidate = _slash(p.relative(candidate.path, from: sandbox.path));
    final analyzerCommand = <String>[...options.flutterCommand, 'analyze', '--no-pub'];
    final testCommand = <String>[...options.flutterCommand, 'test', '--no-pub'];
    final agentVerificationCommands = _agentVerificationCommands(options.flutterCommand);
    final request = <String, Object?>{
      'schemaVersion': 1,
      'suite': options.suite['suite'],
      'configuration': options.configuration,
      'model': options.model,
      // The candidate sees only the task, never the hidden expectations or forbidden patterns.
      'case': <String, Object?>{
        'id': caseId,
        'prompt': benchmarkCase['prompt'],
      },
      'project': <String, Object?>{
        'root': project.path,
        'candidatePath': 'lib/candidate.dart',
        'instructionsPath': instructions.existsSync() ? 'AGENTS.md' : null,
        'allowedWritePaths': <String>['lib/candidate.dart'],
        'verificationCommands': agentVerificationCommands,
      },
      'tools': <String, Object?>{
        if (options.configuration == 'cli')
          'cli': <String>[Platform.resolvedExecutable, 'run', 'charcoal_cli:charcoal'],
        if (options.configuration == 'protocol')
          'mcp': <String>[Platform.resolvedExecutable, 'run', 'charcoal_mcp:charcoal_mcp'],
      },
    };
    requestFile.writeAsStringSync('${_benchmarkJson.convert(request)}\n');
    final before = _snapshot(sandbox);
    final executor = await _safeRun(
      command: <String>[...options.executorCommand, requestFile.path],
      workingDirectory: project,
      environment: <String, String>{
        'CHARCOAL_BENCHMARK_REQUEST': requestFile.path,
        'CHARCOAL_BENCHMARK_CASE_ID': caseId,
        'CHARCOAL_BENCHMARK_CONFIGURATION': options.configuration,
      },
      timeout: options.agentTimeout,
    );
    final after = _snapshot(sandbox);
    final mutations = _changedPaths(
      before,
      after,
    ).where((path) => path != relativeCandidate).toList(growable: false);
    _restorePaths(sandbox, before, mutations);

    final candidateType = FileSystemEntity.typeSync(candidate.path, followLinks: false);
    final candidateMissing = candidateType != FileSystemEntityType.file;
    if (candidateMissing) {
      _deleteEntity(candidate.path);
      candidate
        ..parent.createSync(recursive: true)
        ..writeAsStringSync(_candidateScaffold);
    }
    final source = candidate.readAsStringSync();
    final transcript = _executorTranscript(options.executorCommand, executor);
    final sourceArtifact = File(p.join(caseOutput.path, 'source.dart'))..writeAsStringSync(source);
    final transcriptArtifact = File(p.join(caseOutput.path, 'tools.txt'))
      ..writeAsStringSync(transcript);
    File(p.join(caseOutput.path, 'executor-request.json')).writeAsStringSync(
      '${_benchmarkJson.convert(request)}\n',
    );

    final analysis = await _safeRun(
      command: analyzerCommand,
      workingDirectory: project,
      timeout: options.commandTimeout,
    );
    final test = await _safeRun(
      command: testCommand,
      workingDirectory: project,
      timeout: options.commandTimeout,
    );
    final analysisArtifact = File(p.join(caseOutput.path, 'analyze.txt'))
      ..writeAsStringSync(_processText(analysis));
    final testArtifact = File(p.join(caseOutput.path, 'test.txt'))
      ..writeAsStringSync(_processText(test));
    final automatic = assessCharcoalBenchmarkCandidate(
      source: source,
      analyzerOutput: _processText(analysis),
      analysisExitCode: analysis.exitCode,
      analysisTimedOut: analysis.timedOut,
      testExitCode: test.exitCode,
      testTimedOut: test.timedOut,
      executorExitCode: executor.exitCode,
      executorTimedOut: executor.timedOut,
      candidateMissing: candidateMissing,
      unsafeMutations: mutations,
    );

    // Grade from a clean, non-project directory so repository instructions cannot bias the judge.
    final graderWorkspace = Directory(p.join(sandbox.path, '.grader', caseId))
      ..createSync(recursive: true);
    final graderSource = File(p.join(graderWorkspace.path, 'source.dart'))
      ..writeAsStringSync(source);
    final graderTranscript = File(p.join(graderWorkspace.path, 'tools.txt'))
      ..writeAsStringSync(transcript);
    final graderAnalysis = File(p.join(graderWorkspace.path, 'analyze.txt'))
      ..writeAsStringSync(_processText(analysis));
    final graderTest = File(p.join(graderWorkspace.path, 'test.txt'))
      ..writeAsStringSync(_processText(test));
    final graderResponseFile = File(p.join(graderWorkspace.path, 'grader-response.json'));
    final graderRequest = <String, Object?>{
      'schemaVersion': 1,
      'suite': options.suite['suite'],
      'configuration': options.configuration,
      'candidateModel': options.model,
      'grader': options.grader,
      'case': benchmarkCase,
      'evidence': <String, Object?>{
        'source': graderSource.path,
        'toolTranscript': graderTranscript.path,
        'analysisOutput': graderAnalysis.path,
        'testOutput': graderTest.path,
      },
      'lockedScores': automatic.scores,
      'lockedHardFailures': automatic.hardFailures,
      'responsePath': graderResponseFile.path,
    };
    final graderRequestFile = File(p.join(graderWorkspace.path, 'grader-request.json'))
      ..writeAsStringSync('${_benchmarkJson.convert(graderRequest)}\n');
    final graderProcess = await _safeRun(
      command: <String>[...options.graderCommand, graderRequestFile.path],
      workingDirectory: graderWorkspace,
      environment: <String, String>{
        'CHARCOAL_BENCHMARK_GRADER_REQUEST': graderRequestFile.path,
        'CHARCOAL_BENCHMARK_CASE_ID': caseId,
      },
      timeout: options.agentTimeout,
    );
    if (graderProcess.exitCode != 0 || graderProcess.timedOut) {
      throw CharcoalBenchmarkRunException(
        'Grader failed for $caseId.\n${_processText(graderProcess)}',
      );
    }
    if (!graderResponseFile.existsSync()) {
      throw CharcoalBenchmarkRunException(
        'Grader did not write ${graderResponseFile.path} for $caseId.',
      );
    }
    final graderResponse = _decodeObject(graderResponseFile, context: 'grader response');
    _validateGraderResponse(graderResponse, caseId);
    File(p.join(caseOutput.path, 'grader-request.json')).writeAsStringSync(
      '${_benchmarkJson.convert(<String, Object?>{
        ...graderRequest,
        'evidence': <String, Object?>{
          'source': sourceArtifact.path,
          'toolTranscript': transcriptArtifact.path,
          'analysisOutput': analysisArtifact.path,
          'testOutput': testArtifact.path,
        },
        'responsePath': p.join(caseOutput.path, 'grader-response.json'),
      })}\n',
    );
    File(p.join(caseOutput.path, 'grader-response.json')).writeAsStringSync(
      '${_benchmarkJson.convert(graderResponse)}\n',
    );
    final graderScores = graderResponse['scores']! as Map<String, Object?>;
    final graderFailures = (graderResponse['hardFailures']! as List<Object?>).cast<String>();
    final hardFailures = <String>{...automatic.hardFailures, ...graderFailures}.toList()..sort();
    final scores = <String, Object?>{
      'compileAndTests': automatic.scores['compileAndTests'],
      for (final key in _graderScoreLimits.keys) key: graderScores[key],
    };
    final evaluation = <String, Object?>{
      'schemaVersion': 1,
      'caseId': caseId,
      'automatic': automatic.toJson(),
      'grader': graderResponse,
      'graderProcess': <String, Object?>{
        'exitCode': graderProcess.exitCode,
        'timedOut': graderProcess.timedOut,
        'stdout': graderProcess.stdoutText,
        'stderr': graderProcess.stderrText,
      },
      'finalScores': scores,
      'finalHardFailures': hardFailures,
    };
    final evaluationArtifact = File(p.join(caseOutput.path, 'evaluation.json'))
      ..writeAsStringSync('${_benchmarkJson.convert(evaluation)}\n');
    return <String, Object?>{
      'caseId': caseId,
      'scores': scores,
      'hardFailures': hardFailures,
      'artifacts': <String, Object?>{
        'source': _artifactPath(options.outputDirectory, sourceArtifact),
        'toolTranscript': _artifactPath(options.outputDirectory, transcriptArtifact),
        'analysisOutput': _artifactPath(options.outputDirectory, analysisArtifact),
        'testOutput': _artifactPath(options.outputDirectory, testArtifact),
        'evaluationOutput': _artifactPath(options.outputDirectory, evaluationArtifact),
      },
    };
  }

  Future<CharcoalBenchmarkProcessResult> _safeRun({
    required List<String> command,
    required Directory workingDirectory,
    required Duration timeout,
    Map<String, String> environment = const <String, String>{},
  }) async {
    try {
      return await _run(
        command: command,
        workingDirectory: workingDirectory,
        timeout: timeout,
        environment: environment,
      );
    } on Object catch (error) {
      return CharcoalBenchmarkProcessResult(
        exitCode: 127,
        stdoutText: '',
        stderrText: error.toString(),
      );
    }
  }

  Future<CharcoalBenchmarkProcessResult> _run({
    required List<String> command,
    required Directory workingDirectory,
    required Duration timeout,
    Map<String, String> environment = const <String, String>{},
  }) {
    return processRunner.run(
      CharcoalBenchmarkInvocation(
        executable: command.first,
        arguments: command.skip(1).toList(growable: false),
        workingDirectory: workingDirectory,
        environment: environment,
        timeout: timeout,
      ),
    );
  }
}

final class CharcoalAutomatedAssessment {
  const CharcoalAutomatedAssessment({
    required this.scores,
    required this.hardFailures,
    required this.signals,
  });

  final Map<String, Object?> scores;
  final List<String> hardFailures;
  final Map<String, Object?> signals;

  Map<String, Object?> toJson() => <String, Object?>{
    'scores': scores,
    'hardFailures': hardFailures,
    'signals': signals,
  };
}

/// Locks objective compile/test evidence and structural hard failures before LLM grading.
CharcoalAutomatedAssessment assessCharcoalBenchmarkCandidate({
  required String source,
  required String analyzerOutput,
  required int analysisExitCode,
  required bool analysisTimedOut,
  required int testExitCode,
  required bool testTimedOut,
  required int executorExitCode,
  required bool executorTimedOut,
  required bool candidateMissing,
  required List<String> unsafeMutations,
}) {
  final analysisPassed = analysisExitCode == 0 && !analysisTimedOut;
  final testsPassed = testExitCode == 0 && !testTimedOut;
  final charcoalIdentifiers = RegExp(
    r'\bCharcoal[A-Za-z0-9_]*\b',
  ).allMatches(source).map((match) => match.group(0)!).toSet();
  final knownIdentifiers = <String>{
    for (final component in charcoalCatalog.components) component.name,
    for (final component in charcoalCatalog.components)
      for (final api in component.apis)
        ...RegExp(
          r'\bCharcoal[A-Za-z0-9_]*\b',
        ).allMatches(api.signature).map((match) => match.group(0)!),
  };
  final unknownCharcoalIdentifiers = charcoalIdentifiers.difference(knownIdentifiers).toList()
    ..sort();
  final platformIdentifiers = _platformControlIdentifiers
      .where((identifier) => RegExp('\\b${RegExp.escape(identifier)}\\b').hasMatch(source))
      .toList(growable: false);
  final analyzerReportsFabrication = RegExp(
    r"(?:undefined|isn't defined)[^\n]*Charcoal|Charcoal[^\n]*(?:undefined|isn't defined)",
    caseSensitive: false,
  ).hasMatch(analyzerOutput);
  final hardFailures = <String>{
    if (!analysisPassed) 'compile_error',
    if (unknownCharcoalIdentifiers.isNotEmpty || analyzerReportsFabrication)
      'fabricated_charcoal_api',
    if (platformIdentifiers.isNotEmpty) 'silent_platform_substitution',
    if (unsafeMutations.isNotEmpty) 'unsafe_file_mutation',
    if (executorExitCode != 0 || executorTimedOut || candidateMissing) 'agent_execution_error',
  }.toList()..sort();
  return CharcoalAutomatedAssessment(
    scores: <String, Object?>{
      'compileAndTests': (analysisPassed ? 15 : 0) + (testsPassed ? 15 : 0),
    },
    hardFailures: hardFailures,
    signals: <String, Object?>{
      'analysisExitCode': analysisExitCode,
      'analysisTimedOut': analysisTimedOut,
      'testExitCode': testExitCode,
      'testTimedOut': testTimedOut,
      'executorExitCode': executorExitCode,
      'executorTimedOut': executorTimedOut,
      'candidateMissing': candidateMissing,
      'unsafeMutations': unsafeMutations,
      'unknownCharcoalIdentifiers': unknownCharcoalIdentifiers,
      'platformControlIdentifiers': platformIdentifiers,
    },
  );
}

void _validateOptions(CharcoalBenchmarkRunOptions options) {
  if (options.outputDirectory.existsSync()) {
    throw CharcoalBenchmarkRunException(
      'Output directory already exists: ${options.outputDirectory.path}.',
    );
  }
  if (!charcoalBenchmarkConfigurations.contains(options.configuration)) {
    throw CharcoalBenchmarkRunException(
      'Unknown configuration "${options.configuration}".',
    );
  }
  if (options.model.trim().isEmpty || options.grader.trim().isEmpty) {
    throw const CharcoalBenchmarkRunException('Model and grader names must not be empty.');
  }
  if (options.executorCommand.isEmpty ||
      options.graderCommand.isEmpty ||
      options.flutterCommand.isEmpty) {
    throw const CharcoalBenchmarkRunException(
      'Executor, grader, and Flutter commands must not be empty.',
    );
  }
  if (options.suite['schemaVersion'] != 1 ||
      options.suite['catalogSchemaVersion'] != charcoalCatalog.schemaVersion ||
      options.suite['libraryVersion'] != charcoalCatalog.libraryVersion) {
    throw const CharcoalBenchmarkRunException(
      'Benchmark suite does not match the installed Catalog and library.',
    );
  }
}

List<Map<String, Object?>> _selectedCases(Map<String, Object?> suite, Set<String> selectedIds) {
  final rawCases = suite['cases'];
  if (rawCases is! List<Object?> || rawCases.any((value) => value is! Map<String, Object?>)) {
    throw const CharcoalBenchmarkRunException('Benchmark suite cases are malformed.');
  }
  final cases = rawCases.cast<Map<String, Object?>>();
  final knownIds = cases.map((value) => value['id']).whereType<String>().toSet();
  final unknown = selectedIds.difference(knownIds).toList()..sort();
  if (unknown.isNotEmpty) {
    throw CharcoalBenchmarkRunException('Unknown benchmark cases: ${unknown.join(', ')}.');
  }
  final selected = selectedIds.isEmpty
      ? cases
      : cases.where((value) => selectedIds.contains(value['id'])).toList(growable: false);
  if (selected.isEmpty) {
    throw const CharcoalBenchmarkRunException('At least one benchmark case is required.');
  }
  return selected;
}

void _createSandbox(
  Directory sandbox,
  List<Map<String, Object?>> cases,
  CharcoalBenchmarkRunOptions options,
) {
  final packageNames = <String>[
    'charcoal_icons',
    'charcoal_tokens',
    'charcoal_ui',
    if (options.configuration == 'cli') ...<String>['charcoal_catalog', 'charcoal_cli'],
    if (options.configuration == 'protocol') ...<String>['charcoal_catalog', 'charcoal_mcp'],
  ];
  for (final packageName in packageNames) {
    _copyDirectory(
      Directory(p.join(options.workspaceRoot.path, 'packages', packageName)),
      Directory(p.join(sandbox.path, 'packages', packageName)),
    );
  }
  final workspacePaths = <String>[
    for (final packageName in packageNames) 'packages/$packageName',
    for (final benchmarkCase in cases) 'fixtures/${benchmarkCase['id']}',
  ];
  File(p.join(sandbox.path, 'pubspec.yaml')).writeAsStringSync(
    '''
name: charcoal_agent_benchmark_workspace
publish_to: none
environment:
  sdk: ^3.13.0
workspace:
${workspacePaths.map((path) => '  - $path').join('\n')}
'''
        .trimLeft(),
  );
  for (final benchmarkCase in cases) {
    _createFixture(
      Directory(p.join(sandbox.path, 'fixtures', benchmarkCase['id']! as String)),
      configuration: options.configuration,
    );
  }
}

void _createFixture(Directory project, {required String configuration}) {
  project.createSync(recursive: true);
  final packageName = 'charcoal_benchmark_${p.basename(project.path).replaceAll('-', '_')}';
  File(p.join(project.path, 'pubspec.yaml')).writeAsStringSync(
    '''
name: $packageName
publish_to: none
environment:
  sdk: ^3.13.0
resolution: workspace
dependencies:
  charcoal_ui:
    path: ../../packages/charcoal_ui
  flutter:
    sdk: flutter
${configuration == 'cli'
            ? '''dev_dependencies:
  charcoal_cli:
    path: ../../packages/charcoal_cli
  flutter_test:
    sdk: flutter
'''
            : configuration == 'protocol'
            ? '''dev_dependencies:
  charcoal_mcp:
    path: ../../packages/charcoal_mcp
  flutter_test:
    sdk: flutter
'''
            : '''dev_dependencies:
  flutter_test:
    sdk: flutter
'''}'''
        .trimLeft(),
  );
  File(p.join(project.path, 'lib', 'candidate.dart'))
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(_candidateScaffold);
  File(p.join(project.path, 'lib', 'main.dart')).writeAsStringSync(_fixtureMain);
  File(p.join(project.path, 'test', 'candidate_test.dart'))
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(_fixtureTest);
  if (configuration != 'baseline') {
    File(p.join(project.path, 'AGENTS.md')).writeAsStringSync(
      '${buildCharcoalManagedBlock('consumer')}\n',
    );
  }
}

const String _candidateScaffold = '''
import 'package:flutter/widgets.dart';

/// Replace only this file while preserving this entry-point contract.
Widget buildBenchmarkCandidate() => const SizedBox.shrink();
''';

const String _fixtureMain = '''
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import 'candidate.dart';

void main() {
  runApp(CharcoalApp(home: buildBenchmarkCandidate()));
}
''';

const String _fixtureTest = '''
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/candidate.dart';

void main() {
  testWidgets('candidate builds at compact and desktop sizes', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final size in <Size>[const Size(390, 844), const Size(1024, 768)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        CharcoalApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: size.width, child: buildBenchmarkCandidate()),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });
}
''';

void _copyDirectory(Directory source, Directory destination) {
  if (!source.existsSync()) {
    throw CharcoalBenchmarkRunException('Required package does not exist: ${source.path}.');
  }
  destination.createSync(recursive: true);
  for (final entity in source.listSync(followLinks: false)) {
    final name = p.basename(entity.path);
    if (name == '.dart_tool' || name == 'build') continue;
    final target = p.join(destination.path, name);
    if (entity is Directory) {
      _copyDirectory(entity, Directory(target));
    } else if (entity is File) {
      File(target)
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(entity.readAsBytesSync());
    } else {
      throw CharcoalBenchmarkRunException('Unsupported package entry: ${entity.path}.');
    }
  }
}

Map<String, String> _snapshot(Directory root) {
  final result = <String, String>{};
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    final relative = _slash(p.relative(entity.path, from: root.path));
    final segments = p.split(relative);
    if (segments.contains('.dart_tool') || segments.contains('build')) continue;
    final type = FileSystemEntity.typeSync(entity.path, followLinks: false);
    result[relative] = switch (type) {
      FileSystemEntityType.file => 'file:${base64Encode(File(entity.path).readAsBytesSync())}',
      FileSystemEntityType.directory => 'directory',
      FileSystemEntityType.link =>
        'link:${base64Encode(utf8.encode(Link(entity.path).targetSync()))}',
      _ => 'other:$type',
    };
  }
  return result;
}

List<String> _changedPaths(Map<String, String> before, Map<String, String> after) {
  final paths = <String>{...before.keys, ...after.keys};
  final changed = paths.where((path) => before[path] != after[path]).toList()..sort();
  return changed;
}

void _restorePaths(Directory root, Map<String, String> before, List<String> paths) {
  final deepestFirst = paths.toList()
    ..sort((left, right) => p.split(right).length.compareTo(p.split(left).length));
  for (final relative in deepestFirst) {
    _deleteEntity(p.join(root.path, relative));
  }
  final originals = paths.where(before.containsKey).toList()
    ..sort((left, right) => p.split(left).length.compareTo(p.split(right).length));
  for (final relative in originals) {
    final path = p.join(root.path, relative);
    final original = before[relative]!;
    if (original == 'directory') {
      Directory(path).createSync(recursive: true);
    } else if (original.startsWith('file:')) {
      final file = File(path)..parent.createSync(recursive: true);
      file.writeAsBytesSync(base64Decode(original.substring('file:'.length)));
    } else if (original.startsWith('link:')) {
      Link(path)
        ..parent.createSync(recursive: true)
        ..createSync(utf8.decode(base64Decode(original.substring('link:'.length))));
    } else {
      throw CharcoalBenchmarkRunException('Cannot restore unsupported entry: $relative.');
    }
  }
}

void _deleteEntity(String path) {
  switch (FileSystemEntity.typeSync(path, followLinks: false)) {
    case FileSystemEntityType.file:
      File(path).deleteSync();
    case FileSystemEntityType.directory:
      Directory(path).deleteSync(recursive: true);
    case FileSystemEntityType.link:
      Link(path).deleteSync();
    case FileSystemEntityType.notFound:
      break;
    default:
      File(path).deleteSync();
  }
}

void _validateGraderResponse(Map<String, Object?> response, String caseId) {
  if (response['schemaVersion'] != 1 || response['caseId'] != caseId) {
    throw CharcoalBenchmarkRunException(
      'Grader response for $caseId has the wrong schema version or case ID.',
    );
  }
  final scores = response['scores'];
  if (scores is! Map<String, Object?> ||
      scores.keys.toSet().difference(_graderScoreLimits.keys.toSet()).isNotEmpty ||
      scores.length != _graderScoreLimits.length) {
    throw CharcoalBenchmarkRunException('Grader scores for $caseId are malformed.');
  }
  for (final limit in _graderScoreLimits.entries) {
    final value = scores[limit.key];
    if (value is! num || !value.isFinite || value < 0 || value > limit.value) {
      throw CharcoalBenchmarkRunException(
        'Grader score ${limit.key} for $caseId must be from 0 to ${limit.value}.',
      );
    }
  }
  final failures = response['hardFailures'];
  if (failures is! List<Object?> || failures.any((value) => value is! String)) {
    throw CharcoalBenchmarkRunException('Grader hard failures for $caseId are malformed.');
  }
  final failureStrings = failures.cast<String>();
  if (failureStrings.toSet().length != failureStrings.length ||
      failureStrings.any((value) => !charcoalBenchmarkGraderHardFailures.contains(value))) {
    throw CharcoalBenchmarkRunException('Grader hard failures for $caseId are invalid.');
  }
  final rationale = response['rationale'];
  if (rationale is! Map<String, Object?> ||
      rationale.keys.toSet().difference(_graderScoreLimits.keys.toSet()).isNotEmpty ||
      rationale.length != _graderScoreLimits.length ||
      rationale.values.any((value) => value is! String || value.trim().isEmpty)) {
    throw CharcoalBenchmarkRunException('Grader rationale for $caseId is malformed.');
  }
}

Map<String, Object?> _decodeObject(File file, {required String context}) {
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is Map<String, Object?>) return decoded;
  } on FormatException catch (error) {
    throw CharcoalBenchmarkRunException('Invalid $context JSON: ${error.message}.');
  }
  throw CharcoalBenchmarkRunException('$context must be a JSON object.');
}

String _executorTranscript(
  List<String> command,
  CharcoalBenchmarkProcessResult result,
) =>
    '''command: ${command.join(' ')}
exitCode: ${result.exitCode}
timedOut: ${result.timedOut}

--- stdout ---
${result.stdoutText}
--- stderr ---
${result.stderrText}''';

String _processText(CharcoalBenchmarkProcessResult result) =>
    '''exitCode: ${result.exitCode}
timedOut: ${result.timedOut}

--- stdout ---
${result.stdoutText}
--- stderr ---
${result.stderrText}''';

String _artifactPath(Directory output, File artifact) =>
    _slash(p.relative(artifact.path, from: output.path));

List<List<String>> _agentVerificationCommands(List<String> flutterCommand) {
  if (flutterCommand.length == 1 && p.isAbsolute(flutterCommand.single)) {
    final flutterBin = File(flutterCommand.single).parent;
    final snapshot = File(p.join(flutterBin.path, 'cache', 'flutter_tools.snapshot'));
    if (snapshot.existsSync()) {
      final prefix = <String>[
        Platform.resolvedExecutable,
        snapshot.path,
        '--suppress-analytics',
      ];
      return <List<String>>[
        <String>[...prefix, 'analyze', '--no-pub'],
        <String>[...prefix, 'test', '--no-pub'],
      ];
    }
  }
  return <List<String>>[
    <String>[...flutterCommand, 'analyze', '--no-pub'],
    <String>[...flutterCommand, 'test', '--no-pub'],
  ];
}

String _slash(String path) => path.replaceAll('\\', '/');
