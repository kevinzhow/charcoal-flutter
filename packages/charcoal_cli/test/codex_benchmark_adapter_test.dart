import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory temporary;
  late Directory project;
  late File requestFile;
  late CharcoalCodexAdapterOptions options;

  setUp(() {
    temporary = Directory.systemTemp.createTempSync('charcoal_codex_adapter_test_');
    project = Directory(p.join(temporary.path, 'project'))..createSync();
    requestFile = File(p.join(project.path, 'request.json'))..writeAsStringSync('{}');
    options = CharcoalCodexAdapterOptions(
      requestFile: requestFile,
      codexExecutable: '/tools/codex',
      reasoningEffort: 'high',
    );
  });

  tearDown(() => temporary.deleteSync(recursive: true));

  test('candidate prompt remains identical when only capability exposure changes', () {
    final baseline = buildCharcoalCodexExecutorInvocation(
      _executorRequest(project, configuration: 'baseline'),
      options,
    );
    final protocol = buildCharcoalCodexExecutorInvocation(
      _executorRequest(
        project,
        configuration: 'protocol',
        mcp: const <String>['/sdk/dart', 'run', 'charcoal_mcp:charcoal_mcp'],
      ),
      options,
    );

    expect(protocol.stdinText, baseline.stdinText);
    expect(baseline.executable, '/tools/codex');
    expect(baseline.arguments, containsAllInOrder(<String>['--sandbox', 'workspace-write']));
    expect(baseline.arguments, contains('approval_policy="never"'));
    expect(baseline.arguments, contains('web_search="disabled"'));
    expect(
      baseline.arguments,
      contains('shell_environment_policy.set.FLUTTER_ALREADY_LOCKED="true"'),
    );
    expect(baseline.arguments, isNot(contains(contains('mcp_servers.charcoal'))));
    expect(protocol.arguments, contains('mcp_servers.charcoal.command="/sdk/dart"'));
    expect(
      protocol.arguments,
      contains('mcp_servers.charcoal.args=["run","charcoal_mcp:charcoal_mcp"]'),
    );
    expect(protocol.arguments, contains('mcp_servers.charcoal.required=true'));
  });

  test('grader is read-only and emits schema-constrained output', () {
    final evidence = <String, String>{
      for (final name in <String>['source', 'tools', 'analyze', 'test'])
        name: (File(p.join(temporary.path, '$name.txt'))..writeAsStringSync(name)).path,
    };
    final schema = File(p.join(temporary.path, 'response.schema.json'))..writeAsStringSync('{}');
    final response = p.join(temporary.path, 'grader-response.json');
    final invocation = buildCharcoalCodexGraderInvocation(
      <String, Object?>{
        'schemaVersion': 1,
        'grader': 'gpt-grader-exact',
        'case': <String, Object?>{
          'id': 'responsive-actions',
          'prompt': 'Build responsive actions.',
          'expectedComponents': <String>['CharcoalButton'],
          'requiredAssertions': <String>['uses constraints'],
          'forbiddenPatterns': <String>['Material Button'],
        },
        'evidence': <String, Object?>{
          'source': evidence['source'],
          'toolTranscript': evidence['tools'],
          'analysisOutput': evidence['analyze'],
          'testOutput': evidence['test'],
        },
        'lockedScores': <String, Object?>{'compileAndTests': 30},
        'lockedHardFailures': <String>[],
        'responsePath': response,
      },
      options,
      responseSchema: schema,
    );

    expect(invocation.arguments, containsAllInOrder(<String>['--sandbox', 'read-only']));
    expect(invocation.arguments, containsAllInOrder(<String>['--output-schema', schema.path]));
    expect(invocation.arguments, containsAllInOrder(<String>['--output-last-message', response]));
    expect(invocation.stdinText, contains('harness checks alone earn no credit'));
    expect(invocation.stdinText, contains('CharcoalButton'));
  });

  test('argument parser rejects unsupported reasoning effort', () {
    expect(
      () => parseCharcoalCodexAdapterArguments(<String>[
        '--reasoning-effort=extreme',
        requestFile.path,
      ]),
      throwsA(isA<CharcoalCodexAdapterException>()),
    );
  });
}

Map<String, Object?> _executorRequest(
  Directory project, {
  required String configuration,
  List<String>? mcp,
}) {
  final tools = <String, Object?>{};
  if (mcp != null) tools['mcp'] = mcp;
  return <String, Object?>{
    'schemaVersion': 1,
    'configuration': configuration,
    'model': 'gpt-candidate-exact',
    'case': <String, Object?>{
      'id': 'responsive-actions',
      'prompt': 'Build responsive actions.',
    },
    'project': <String, Object?>{
      'root': project.path,
      'candidatePath': 'lib/candidate.dart',
      'allowedWritePaths': <String>['lib/candidate.dart'],
      'verificationCommands': <List<String>>[
        <String>['flutter', 'analyze', '--no-pub'],
        <String>['flutter', 'test', '--no-pub'],
      ],
    },
    'tools': tools,
  };
}
