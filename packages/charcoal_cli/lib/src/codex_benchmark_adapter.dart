import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'benchmark.dart';

const String charcoalCodexAdapterVersion = '1';

const Set<String> charcoalCodexReasoningEfforts = <String>{
  'minimal',
  'low',
  'medium',
  'high',
  'xhigh',
};

/// Parsed command-line settings shared by the repository's Codex benchmark adapters.
final class CharcoalCodexAdapterOptions {
  const CharcoalCodexAdapterOptions({
    required this.requestFile,
    required this.codexExecutable,
    required this.reasoningEffort,
  });

  final File requestFile;
  final String codexExecutable;
  final String reasoningEffort;
}

/// A fully specified `codex exec` subprocess.
final class CharcoalCodexProcessInvocation {
  const CharcoalCodexProcessInvocation({
    required this.executable,
    required this.arguments,
    required this.workingDirectory,
    required this.stdinText,
    required this.role,
    required this.model,
    required this.reasoningEffort,
  });

  final String executable;
  final List<String> arguments;
  final Directory workingDirectory;
  final String stdinText;
  final String role;
  final String model;
  final String reasoningEffort;
}

final class CharcoalCodexAdapterException implements Exception {
  const CharcoalCodexAdapterException(this.message);

  final String message;

  @override
  String toString() => message;
}

CharcoalCodexAdapterOptions parseCharcoalCodexAdapterArguments(List<String> arguments) {
  var executable = Platform.environment['CHARCOAL_CODEX_EXECUTABLE'] ?? 'codex';
  var reasoningEffort = Platform.environment['CHARCOAL_CODEX_REASONING_EFFORT'] ?? 'medium';
  String? requestPath;
  for (var index = 0; index < arguments.length; index += 1) {
    final argument = arguments[index];
    if (argument == '--codex' || argument == '--reasoning-effort') {
      if (index + 1 >= arguments.length) {
        throw CharcoalCodexAdapterException('$argument requires a value.');
      }
      final value = arguments[index + 1];
      index += 1;
      if (argument == '--codex') {
        executable = value;
      } else {
        reasoningEffort = value;
      }
      continue;
    }
    if (argument.startsWith('--codex=')) {
      executable = argument.substring('--codex='.length);
      continue;
    }
    if (argument.startsWith('--reasoning-effort=')) {
      reasoningEffort = argument.substring('--reasoning-effort='.length);
      continue;
    }
    if (argument.startsWith('-')) {
      throw CharcoalCodexAdapterException('Unknown adapter option: $argument.');
    }
    if (requestPath != null) {
      throw const CharcoalCodexAdapterException(
        'Exactly one benchmark request JSON path is required.',
      );
    }
    requestPath = argument;
  }
  if (requestPath == null) {
    throw const CharcoalCodexAdapterException(
      'A benchmark request JSON path is required.',
    );
  }
  if (executable.trim().isEmpty) {
    throw const CharcoalCodexAdapterException('The Codex executable must not be empty.');
  }
  if (!charcoalCodexReasoningEfforts.contains(reasoningEffort)) {
    throw CharcoalCodexAdapterException(
      'Unsupported reasoning effort "$reasoningEffort"; expected '
      '${charcoalCodexReasoningEfforts.join(', ')}.',
    );
  }
  final requestFile = File(requestPath).absolute;
  if (!requestFile.existsSync()) {
    throw CharcoalCodexAdapterException(
      'Benchmark request does not exist: ${requestFile.path}.',
    );
  }
  return CharcoalCodexAdapterOptions(
    requestFile: requestFile,
    codexExecutable: executable,
    reasoningEffort: reasoningEffort,
  );
}

Map<String, Object?> readCharcoalCodexRequest(File file) {
  try {
    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is Map<String, Object?>) return decoded;
  } on FormatException catch (error) {
    throw CharcoalCodexAdapterException(
      'Invalid benchmark request JSON: ${error.message}.',
    );
  }
  throw const CharcoalCodexAdapterException(
    'The benchmark request must be a JSON object.',
  );
}

CharcoalCodexProcessInvocation buildCharcoalCodexExecutorInvocation(
  Map<String, Object?> request,
  CharcoalCodexAdapterOptions options,
) {
  _requireSchemaVersion(request);
  final model = _requiredString(request, 'model');
  final benchmarkCase = _requiredObject(request, 'case');
  final caseId = _requiredString(benchmarkCase, 'id');
  final task = _requiredString(benchmarkCase, 'prompt');
  final project = _requiredObject(request, 'project');
  final root = Directory(_requiredString(project, 'root')).absolute;
  if (!root.existsSync()) {
    throw CharcoalCodexAdapterException(
      'Benchmark project does not exist: ${root.path}.',
    );
  }
  final candidatePath = _requiredString(project, 'candidatePath');
  final allowedWrites = _requiredStringList(project, 'allowedWritePaths');
  if (!allowedWrites.contains(candidatePath)) {
    throw const CharcoalCodexAdapterException(
      'The candidate path must be included in allowedWritePaths.',
    );
  }
  final verificationCommands = project['verificationCommands'];
  if (verificationCommands is! List<Object?> || verificationCommands.isEmpty) {
    throw const CharcoalCodexAdapterException(
      'verificationCommands must be a non-empty array.',
    );
  }
  final arguments = _commonArguments(
    model: model,
    reasoningEffort: options.reasoningEffort,
    root: root,
    sandbox: 'workspace-write',
  );
  final tools = _requiredObject(request, 'tools');
  final mcp = tools['mcp'];
  if (mcp != null) {
    if (mcp is! List<Object?> || mcp.isEmpty || mcp.any((value) => value is! String)) {
      throw const CharcoalCodexAdapterException('tools.mcp must be a command array.');
    }
    final command = mcp.cast<String>();
    arguments.insertAll(arguments.length - 1, <String>[
      '-c',
      'mcp_servers.charcoal.command=${jsonEncode(command.first)}',
      '-c',
      'mcp_servers.charcoal.args=${jsonEncode(command.skip(1).toList())}',
      '-c',
      'mcp_servers.charcoal.cwd=${jsonEncode(root.path)}',
      '-c',
      'mcp_servers.charcoal.required=true',
      '-c',
      'mcp_servers.charcoal.enabled=true',
      '-c',
      'mcp_servers.charcoal.default_tools_approval_mode="auto"',
    ]);
  }
  return CharcoalCodexProcessInvocation(
    executable: options.codexExecutable,
    arguments: arguments,
    workingDirectory: root,
    stdinText: _executorPrompt(
      caseId: caseId,
      task: task,
      candidatePath: candidatePath,
      allowedWrites: allowedWrites,
      verificationCommands: verificationCommands,
    ),
    role: 'executor',
    model: model,
    reasoningEffort: options.reasoningEffort,
  );
}

CharcoalCodexProcessInvocation buildCharcoalCodexGraderInvocation(
  Map<String, Object?> request,
  CharcoalCodexAdapterOptions options, {
  required File responseSchema,
}) {
  _requireSchemaVersion(request);
  final model = _requiredString(request, 'grader');
  final benchmarkCase = _requiredObject(request, 'case');
  final caseId = _requiredString(benchmarkCase, 'id');
  final responsePath = File(_requiredString(request, 'responsePath')).absolute;
  final evidence = _requiredObject(request, 'evidence');
  for (final key in <String>[
    'source',
    'toolTranscript',
    'analysisOutput',
    'testOutput',
  ]) {
    final evidenceFile = File(_requiredString(evidence, key)).absolute;
    if (!evidenceFile.existsSync()) {
      throw CharcoalCodexAdapterException(
        'Grader evidence does not exist: ${evidenceFile.path}.',
      );
    }
  }
  if (!responseSchema.existsSync()) {
    throw CharcoalCodexAdapterException(
      'Grader response schema does not exist: ${responseSchema.path}.',
    );
  }
  final root = options.requestFile.parent.absolute;
  final arguments = _commonArguments(
    model: model,
    reasoningEffort: options.reasoningEffort,
    root: root,
    sandbox: 'read-only',
  );
  arguments.insertAll(arguments.length - 1, <String>[
    '--output-schema',
    responseSchema.absolute.path,
    '--output-last-message',
    responsePath.path,
  ]);
  return CharcoalCodexProcessInvocation(
    executable: options.codexExecutable,
    arguments: arguments,
    workingDirectory: root,
    stdinText: _graderPrompt(request, caseId: caseId),
    role: 'grader',
    model: model,
    reasoningEffort: options.reasoningEffort,
  );
}

Future<int> runCharcoalCodexProcess(
  CharcoalCodexProcessInvocation invocation, {
  IOSink? output,
  IOSink? errorOutput,
}) async {
  final outputSink = output ?? stdout;
  final errorSink = errorOutput ?? stderr;
  outputSink.writeln(
    jsonEncode(<String, Object?>{
      'type': 'charcoal.adapter.started',
      'adapterVersion': charcoalCodexAdapterVersion,
      'role': invocation.role,
      'model': invocation.model,
      'reasoningEffort': invocation.reasoningEffort,
    }),
  );
  final process = await Process.start(
    invocation.executable,
    invocation.arguments,
    workingDirectory: invocation.workingDirectory.path,
  );
  process.stdin.write(invocation.stdinText);
  await process.stdin.close();
  final stdoutFuture = outputSink.addStream(process.stdout);
  final stderrFuture = errorSink.addStream(process.stderr);
  final exitCode = await process.exitCode;
  await Future.wait(<Future<void>>[stdoutFuture, stderrFuture]);
  return exitCode;
}

List<String> _commonArguments({
  required String model,
  required String reasoningEffort,
  required Directory root,
  required String sandbox,
}) => <String>[
  'exec',
  '--ephemeral',
  '--ignore-user-config',
  '--ignore-rules',
  '--skip-git-repo-check',
  '--strict-config',
  '--json',
  '--color',
  'never',
  '--sandbox',
  sandbox,
  '--model',
  model,
  '--cd',
  root.path,
  '-c',
  'model_reasoning_effort=${jsonEncode(reasoningEffort)}',
  '-c',
  'approval_policy="never"',
  '-c',
  'web_search="disabled"',
  '-c',
  'agents.enabled=false',
  '-c',
  'shell_environment_policy.inherit="core"',
  '-c',
  'shell_environment_policy.ignore_default_excludes=false',
  '-c',
  'shell_environment_policy.set.FLUTTER_ALREADY_LOCKED="true"',
  '-c',
  'shell_environment_policy.set.CI="true"',
  '-',
];

String _executorPrompt({
  required String caseId,
  required String task,
  required String candidatePath,
  required List<String> allowedWrites,
  required List<Object?> verificationCommands,
}) =>
    '''You are the implementation agent in a controlled Flutter component benchmark.

Task [$caseId]: $task

Implement the best complete solution you can in `$candidatePath` while preserving the existing `Widget buildBenchmarkCandidate()` entry point. Inspect the installed packages and use any project instructions or discovery capabilities that are actually available. Do not assume undocumented APIs.

You may write only: ${allowedWrites.join(', ')}. Do not modify any other file. Keep the fixture independent from Material and Cupertino unless the task explicitly requires a missing-component decision. Preserve accessibility and behavior at both compact and desktop constraints.

The harness will run these commands after you finish:
${verificationCommands.map((command) => '- ${(command as List<Object?>).join(' ')}').join('\n')}

You may run proportionate verification yourself. If the requested Charcoal component does not exist or the request violates component ownership, do not fabricate or silently substitute it; leave a compiling honest result and explain the product decision in your final message.''';

String _graderPrompt(Map<String, Object?> request, {required String caseId}) {
  final benchmarkCase = _requiredObject(request, 'case');
  final evidence = _requiredObject(request, 'evidence');
  final lockedScores = _requiredObject(request, 'lockedScores');
  final lockedFailures = request['lockedHardFailures'];
  if (lockedFailures is! List<Object?> || lockedFailures.any((value) => value is! String)) {
    throw const CharcoalCodexAdapterException('lockedHardFailures must be a string array.');
  }
  return '''You are an independent, evidence-only evaluator. Do not implement or edit the candidate. Read all four evidence files before scoring. Do not award credit for intentions that are absent from source or transcript.

Case: ${const JsonEncoder.withIndent('  ').convert(benchmarkCase)}

Evidence files:
- source: ${evidence['source']}
- candidate tool transcript: ${evidence['toolTranscript']}
- harness analyzer output: ${evidence['analysisOutput']}
- harness test output: ${evidence['testOutput']}

The harness has already locked compileAndTests to ${lockedScores['compileAndTests']}/30 and detected these hard failures: ${lockedFailures.join(', ')}. You cannot change those objective values.

Score only these dimensions:
${_graderDimensionsText()}

You may add only ${charcoalBenchmarkGraderHardFailures.map((failure) => '`$failure`').join(' or ')} when the evidence proves one and the structural harness missed it. Hard failures are not stylistic penalties. Use the full numeric ranges; do not inflate incomplete work. Provide one concise, evidence-specific rationale for every dimension.

Return only the schema-conforming JSON object for caseId `$caseId`.''';
}

String _graderDimensionsText() => charcoalBenchmarkGraderScoreLimits.entries
    .map(
      (entry) =>
          '- ${entry.key} (0-${entry.value}): '
          '${charcoalBenchmarkGraderScoreGuidance[entry.key]}.',
    )
    .join('\n');

void _requireSchemaVersion(Map<String, Object?> request) {
  if (request['schemaVersion'] != 1) {
    throw const CharcoalCodexAdapterException('Unsupported request schema version.');
  }
}

Map<String, Object?> _requiredObject(Map<String, Object?> object, String key) {
  final value = object[key];
  if (value is Map<String, Object?>) return value;
  throw CharcoalCodexAdapterException('$key must be a JSON object.');
}

String _requiredString(Map<String, Object?> object, String key) {
  final value = object[key];
  if (value is String && value.trim().isNotEmpty) return value;
  throw CharcoalCodexAdapterException('$key must be a non-empty string.');
}

List<String> _requiredStringList(Map<String, Object?> object, String key) {
  final value = object[key];
  if (value is List<Object?> && value.isNotEmpty && value.every((item) => item is String)) {
    return value.cast<String>();
  }
  throw CharcoalCodexAdapterException('$key must be a non-empty string array.');
}
