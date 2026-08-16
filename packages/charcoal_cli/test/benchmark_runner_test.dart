import 'dart:convert';
import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory temporary;
  late Directory sourceWorkspace;
  late Map<String, Object?> suite;

  setUp(() {
    temporary = Directory.systemTemp.createTempSync('charcoal_runner_test_');
    sourceWorkspace = Directory(p.join(temporary.path, 'source'))..createSync();
    for (final packageName in <String>['charcoal_icons', 'charcoal_tokens', 'charcoal_ui']) {
      final package = Directory(p.join(sourceWorkspace.path, 'packages', packageName))
        ..createSync(
          recursive: true,
        );
      File(p.join(package.path, 'pubspec.yaml')).writeAsStringSync('name: $packageName\n');
      File(p.join(package.path, 'marker.txt')).writeAsStringSync(packageName);
    }
    suite = _singleCaseSuite();
  });

  tearDown(() => temporary.deleteSync(recursive: true));

  test('runs an isolated candidate and emits independently graded v2 evidence', () async {
    final output = Directory(p.join(temporary.path, 'successful-run'));
    final execution = await CharcoalBenchmarkRunner(
      processRunner: _FixtureProcessRunner(),
    ).run(_options(sourceWorkspace, output, suite));
    final results = jsonDecode(execution.resultsFile.readAsStringSync()) as Map<String, Object?>;
    final run = ((results['runs']! as List<Object?>).single as Map<String, Object?>);
    final artifacts = run['artifacts']! as Map<String, Object?>;

    expect(results['schemaVersion'], 2);
    expect(results['grader'], 'fixture-grader-1');
    expect(execution.report.evaluatedCases, 1);
    expect(execution.report.passedCases, 1);
    expect(execution.report.averageScore, 100);
    expect(run['hardFailures'], isEmpty);
    expect(artifacts.keys, charcoalBenchmarkV2ArtifactKeys);
    for (final path in artifacts.values.cast<String>()) {
      expect(File(p.join(output.path, path)).existsSync(), isTrue, reason: path);
    }
    final evaluation = jsonDecode(
      File(p.join(output.path, artifacts['evaluationOutput']! as String)).readAsStringSync(),
    ) as Map<String, Object?>;
    expect(evaluation['finalHardFailures'], isEmpty);
    final executorRequest = jsonDecode(
      File(p.join(output.path, 'responsive-actions', 'executor-request.json')).readAsStringSync(),
    ) as Map<String, Object?>;
    expect(
      (executorRequest['case']! as Map<String, Object?>).keys,
      <String>['id', 'prompt'],
      reason: 'candidate requests must not leak hidden grading expectations',
    );
  });

  test('records writes outside candidate.dart as a hard failure', () async {
    final output = Directory(p.join(temporary.path, 'unsafe-run'));
    final execution = await CharcoalBenchmarkRunner(
      processRunner: _FixtureProcessRunner(mutateOutsideCandidate: true),
    ).run(_options(sourceWorkspace, output, suite));
    final results = jsonDecode(execution.resultsFile.readAsStringSync()) as Map<String, Object?>;
    final run = ((results['runs']! as List<Object?>).single as Map<String, Object?>);

    expect(run['hardFailures'], contains('unsafe_file_mutation'));
    expect(execution.report.failedCases, 1);
  });

  test('rejects a candidate path replaced by a symbolic link', () async {
    if (Platform.isWindows) return;
    final output = Directory(p.join(temporary.path, 'linked-candidate-run'));
    final execution = await CharcoalBenchmarkRunner(
      processRunner: _FixtureProcessRunner(replaceCandidateWithLink: true),
    ).run(_options(sourceWorkspace, output, suite));
    final results = jsonDecode(execution.resultsFile.readAsStringSync()) as Map<String, Object?>;
    final run = ((results['runs']! as List<Object?>).single as Map<String, Object?>);
    final source = File(p.join(output.path, 'responsive-actions', 'source.dart'));

    expect(run['hardFailures'], contains('agent_execution_error'));
    expect(source.readAsStringSync(), contains('SizedBox.shrink'));
    expect(source.readAsStringSync(), isNot(contains('publish_to')));
  });

  test('rejects malformed grader output instead of trusting candidate scores', () async {
    final output = Directory(p.join(temporary.path, 'bad-grader-run'));
    final runner = CharcoalBenchmarkRunner(
      processRunner: _FixtureProcessRunner(invalidGraderScore: true),
    );

    await expectLater(
      runner.run(_options(sourceWorkspace, output, suite)),
      throwsA(
        isA<CharcoalBenchmarkRunException>().having(
          (error) => error.message,
          'message',
          contains('apiAccuracy'),
        ),
      ),
    );
  });

  group('automatic assessment', () {
    test('locks compile and test outcomes', () {
      final assessment = assessCharcoalBenchmarkCandidate(
        source: _validCandidate,
        analyzerOutput: '',
        analysisExitCode: 0,
        analysisTimedOut: false,
        testExitCode: 1,
        testTimedOut: false,
        executorExitCode: 0,
        executorTimedOut: false,
        candidateMissing: false,
        unsafeMutations: const <String>[],
      );

      expect(assessment.scores['compileAndTests'], 15);
      expect(assessment.hardFailures, isNot(contains('compile_error')));
    });

    test('detects fabricated APIs and platform substitutions', () {
      final assessment = assessCharcoalBenchmarkCandidate(
        source: '''
import 'package:flutter/material.dart';
Widget buildBenchmarkCandidate() => CharcoalDatePicker(child: ElevatedButton(onPressed: () {}, child: const Text('Go')));
''',
        analyzerOutput: "The function 'CharcoalDatePicker' isn't defined.",
        analysisExitCode: 1,
        analysisTimedOut: false,
        testExitCode: 1,
        testTimedOut: false,
        executorExitCode: 0,
        executorTimedOut: false,
        candidateMissing: false,
        unsafeMutations: const <String>[],
      );

      expect(
        assessment.hardFailures,
        containsAll(<String>[
          'compile_error',
          'fabricated_charcoal_api',
          'silent_platform_substitution',
        ]),
      );
    });
  });
}

CharcoalBenchmarkRunOptions _options(
  Directory sourceWorkspace,
  Directory output,
  Map<String, Object?> suite,
) {
  return CharcoalBenchmarkRunOptions(
    workspaceRoot: sourceWorkspace,
    outputDirectory: output,
    suite: suite,
    configuration: 'instructions',
    model: 'fixture-candidate-1',
    grader: 'fixture-grader-1',
    executorCommand: const <String>['fixture-agent'],
    graderCommand: const <String>['fixture-grader'],
    flutterCommand: const <String>['fixture-flutter'],
    caseIds: const <String>{'responsive-actions'},
  );
}

Map<String, Object?> _singleCaseSuite() => <String, Object?>{
  'schemaVersion': 1,
  'catalogSchemaVersion': charcoalCatalog.schemaVersion,
  'libraryVersion': charcoalCatalog.libraryVersion,
  'suite': 'charcoal-agent-ready-v1',
  'cases': <Map<String, Object?>>[
    <String, Object?>{
      'id': 'responsive-actions',
      'prompt': 'Build responsive actions.',
      'expectedComponents': <String>['CharcoalButton'],
      'requiredAssertions': <String>['uses responsive constraints'],
      'forbiddenPatterns': <String>['Material Button'],
    },
  ],
};

const String _validCandidate = '''
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

Widget buildBenchmarkCandidate() => CharcoalButton(
  onPressed: () {},
  variant: CharcoalButtonVariant.primary,
  child: const Text('Continue'),
);
''';

final class _FixtureProcessRunner implements CharcoalBenchmarkProcessRunner {
  _FixtureProcessRunner({
    this.mutateOutsideCandidate = false,
    this.invalidGraderScore = false,
    this.replaceCandidateWithLink = false,
  });

  final bool mutateOutsideCandidate;
  final bool invalidGraderScore;
  final bool replaceCandidateWithLink;

  @override
  Future<CharcoalBenchmarkProcessResult> run(CharcoalBenchmarkInvocation invocation) async {
    if (invocation.executable == 'fixture-agent') {
      final request = _readRequest(invocation.arguments.last);
      final project = (request['project']! as Map<String, Object?>)['root']! as String;
      expect(
        p.isWithin(project, invocation.arguments.last),
        isFalse,
        reason: 'experiment metadata must stay outside the candidate workspace',
      );
      final candidate = File(p.join(project, 'lib', 'candidate.dart'));
      if (replaceCandidateWithLink) {
        candidate.deleteSync();
        Link(candidate.path).createSync(p.join(project, 'pubspec.yaml'));
      } else {
        candidate.writeAsStringSync(_validCandidate);
      }
      if (mutateOutsideCandidate) {
        File(p.join(project, 'pubspec.yaml')).writeAsStringSync('unsafe: true\n');
      }
      return const CharcoalBenchmarkProcessResult(
        exitCode: 0,
        stdoutText: 'fvm flutter analyze\nfvm flutter test\n',
        stderrText: '',
      );
    }
    if (invocation.executable == 'fixture-grader') {
      final request = _readRequest(invocation.arguments.last);
      final responsePath = request['responsePath']! as String;
      final caseId = (request['case']! as Map<String, Object?>)['id']! as String;
      final scores = <String, Object?>{
        'apiAccuracy': invalidGraderScore ? 21 : 20,
        'charcoalComposition': 15,
        'tokenAndLayout': 10,
        'accessibility': 10,
        'responsiveness': 10,
        'verification': 5,
      };
      File(responsePath).writeAsStringSync(
        jsonEncode(<String, Object?>{
          'schemaVersion': 1,
          'caseId': caseId,
          'scores': scores,
          'hardFailures': <String>[],
          'rationale': <String, Object?>{
            for (final key in scores.keys) key: 'Fixture rationale for $key.',
          },
        }),
      );
      return const CharcoalBenchmarkProcessResult(
        exitCode: 0,
        stdoutText: 'graded',
        stderrText: '',
      );
    }
    return const CharcoalBenchmarkProcessResult(
      exitCode: 0,
      stdoutText: 'ok',
      stderrText: '',
    );
  }
}

Map<String, Object?> _readRequest(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
