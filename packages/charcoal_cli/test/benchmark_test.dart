import 'dart:convert';
import 'dart:io';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory root;
  late Map<String, Object?> pageExperienceSuite;
  late Map<String, Object?> suite;

  setUpAll(() {
    root = _workspaceRoot(Directory.current);
    suite = jsonDecode(
      File(p.join(root.path, 'agent', 'benchmarks', 'v1.json')).readAsStringSync(),
    ) as Map<String, Object?>;
    pageExperienceSuite = jsonDecode(
      File(
        p.join(root.path, 'agent', 'benchmarks', 'page-experience-v1.json'),
      ).readAsStringSync(),
    ) as Map<String, Object?>;
  });

  test('top-level navigation benchmark requires full touch lifecycle evidence', () {
    final cases = (pageExperienceSuite['cases']! as List<Object?>).cast<Map<String, Object?>>();
    final navigation = cases.firstWhere(
      (benchmarkCase) => benchmarkCase['id'] == 'stable-top-level-navigation',
    );

    expect(
      (navigation['requiredAssertions']! as List<Object?>).join(' '),
      allOf([
        contains('held touch'),
        contains('cancellation'),
        contains('target rectangle'),
        contains('text baseline'),
        contains('one pump'),
        contains('previous tab paints'),
        contains('locale-aware leading-edge drag'),
        contains('predictive-back start'),
        contains('both system edges'),
        contains('nested Navigator ownership'),
      ]),
    );
    expect(
      (navigation['forbiddenPatterns']! as List<Object?>).join(' '),
      allOf([
        contains('pointer down'),
        contains('cancelled gesture'),
        contains('loose Stack'),
        contains('target bounds'),
        contains('tester.tap-only'),
        contains('pumpAndSettle-only'),
        contains('stale selected visuals'),
        contains('handlePopRoute alone'),
        contains('page-local drag detector'),
      ]),
    );
  });

  test('scores a complete evidence record', () {
    final report = evaluateCharcoalBenchmark(suite, _results(suite));

    expect(report.totalCases, 16);
    expect(report.evaluatedCases, 16);
    expect(report.passedCases, 16);
    expect(report.averageScore, 100);
    expect(report.missingCases, isEmpty);
    expect(report.grader, 'manual-v1');
  });

  test('hard failures override an otherwise passing score', () {
    final results = _results(suite);
    final runs = (results['runs']! as List<Object?>).cast<Map<String, Object?>>();
    runs.first['hardFailures'] = <String>['fabricated_charcoal_api'];

    final report = evaluateCharcoalBenchmark(suite, results);

    expect(report.passedCases, 15);
    expect(report.failedCases, 1);
    expect(report.cases.first['score'], 100);
    expect(report.cases.first['passed'], isFalse);
  });

  test('accepts automated v2 records with grader identity and evaluation evidence', () {
    final results = _results(suite)
      ..['schemaVersion'] = 2
      ..['grader'] = 'independent-grader-1';
    for (final run in (results['runs']! as List<Object?>).cast<Map<String, Object?>>()) {
      final artifacts = run['artifacts']! as Map<String, Object?>;
      artifacts['evaluationOutput'] = 'evaluation.json';
    }

    final report = evaluateCharcoalBenchmark(suite, results);

    expect(report.grader, 'independent-grader-1');
    expect(report.passedCases, 16);
  });

  test('partial records require explicit permission', () {
    final results = _results(suite);
    (results['runs']! as List<Object?>).removeLast();

    expect(
      () => evaluateCharcoalBenchmark(suite, results),
      throwsA(isA<CharcoalBenchmarkFormatException>()),
    );
    expect(
      evaluateCharcoalBenchmark(suite, results, allowPartial: true).missingCases,
      hasLength(1),
    );
  });

  test('CLI emits a stable report and failure exit code', () async {
    final temporary = Directory.systemTemp.createTempSync('charcoal_benchmark_test_');
    addTearDown(() => temporary.deleteSync(recursive: true));
    final results = _results(suite);
    final runs = (results['runs']! as List<Object?>).cast<Map<String, Object?>>();
    runs.first['scores'] = <String, Object?>{
      ...charcoalBenchmarkScoreLimits,
      'compileAndTests': 0,
    };
    final resultsFile = File(p.join(temporary.path, 'results.json'))
      ..writeAsStringSync(jsonEncode(results));
    for (final artifact in <String>['source.dart', 'tools.jsonl', 'analyze.txt', 'test.txt']) {
      File(p.join(temporary.path, artifact)).writeAsStringSync('fixture evidence');
    }
    final output = StringBuffer();

    final exitCode = await runCharcoalCli(
      <String>[
        'benchmark',
        '--suite',
        p.join(root.path, 'agent', 'benchmarks', 'v1.json'),
        '--results',
        resultsFile.path,
        '--json',
      ],
      output: output,
      workingDirectory: root,
    );
    final response = jsonDecode(output.toString()) as Map<String, Object?>;
    final data = response['data']! as Map<String, Object?>;

    expect(exitCode, 1);
    expect(response['type'], 'benchmark');
    expect(data['failedCases'], 1);
  });

  test('CLI rejects result records whose evidence files are missing', () async {
    final temporary = Directory.systemTemp.createTempSync('charcoal_benchmark_test_');
    addTearDown(() => temporary.deleteSync(recursive: true));
    final resultsFile = File(p.join(temporary.path, 'results.json'))
      ..writeAsStringSync(jsonEncode(_results(suite)));
    final errors = StringBuffer();

    final exitCode = await runCharcoalCli(
      <String>[
        'benchmark',
        '--suite',
        p.join(root.path, 'agent', 'benchmarks', 'v1.json'),
        '--results',
        resultsFile.path,
        '--json',
      ],
      errorOutput: errors,
      output: StringBuffer(),
      workingDirectory: root,
    );

    expect(exitCode, 65);
    expect(errors.toString(), contains('does not exist'));
  });

  test('rejects stale Catalog versions', () {
    final results = _results(suite)..['catalogSchemaVersion'] = 1;

    expect(
      () => evaluateCharcoalBenchmark(suite, results),
      throwsA(
        isA<CharcoalBenchmarkFormatException>().having(
          (error) => error.message,
          'message',
          contains('catalogSchemaVersion'),
        ),
      ),
    );
  });

  test('rejects non-finite scores from programmatic callers', () {
    final results = _results(suite);
    final runs = (results['runs']! as List<Object?>).cast<Map<String, Object?>>();
    final scores = runs.first['scores']! as Map<String, Object?>;
    scores['verification'] = double.nan;

    expect(
      () => evaluateCharcoalBenchmark(suite, results),
      throwsA(
        isA<CharcoalBenchmarkFormatException>().having(
          (error) => error.message,
          'message',
          contains('verification'),
        ),
      ),
    );
  });

  test('rejects empty or duplicate evidence fields', () {
    final emptyArtifact = _results(suite);
    final emptyRuns = (emptyArtifact['runs']! as List<Object?>).cast<Map<String, Object?>>();
    final artifacts = emptyRuns.first['artifacts']! as Map<String, Object?>;
    artifacts['source'] = '';
    final duplicateFailure = _results(suite);
    final duplicateRuns = (duplicateFailure['runs']! as List<Object?>).cast<Map<String, Object?>>();
    duplicateRuns.first['hardFailures'] = <String>['compile_error', 'compile_error'];

    expect(
      () => evaluateCharcoalBenchmark(suite, emptyArtifact),
      throwsA(
        isA<CharcoalBenchmarkFormatException>().having(
          (error) => error.message,
          'message',
          contains('non-empty path'),
        ),
      ),
    );
    expect(
      () => evaluateCharcoalBenchmark(suite, duplicateFailure),
      throwsA(
        isA<CharcoalBenchmarkFormatException>().having(
          (error) => error.message,
          'message',
          contains('duplicates'),
        ),
      ),
    );
  });
}

Map<String, Object?> _results(Map<String, Object?> suite) {
  final cases = (suite['cases']! as List<Object?>).cast<Map<String, Object?>>();
  return <String, Object?>{
    'schemaVersion': 1,
    'suite': suite['suite'],
    'catalogSchemaVersion': charcoalCatalog.schemaVersion,
    'libraryVersion': charcoalCatalog.libraryVersion,
    'configuration': 'protocol',
    'model': 'fixture-model-1',
    'runs': <Map<String, Object?>>[
      for (final benchmarkCase in cases)
        <String, Object?>{
          'caseId': benchmarkCase['id'],
          'scores': <String, Object?>{...charcoalBenchmarkScoreLimits},
          'hardFailures': <String>[],
          'artifacts': <String, Object?>{
            'source': 'source.dart',
            'toolTranscript': 'tools.jsonl',
            'analysisOutput': 'analyze.txt',
            'testOutput': 'test.txt',
          },
        },
    ],
  };
}

Directory _workspaceRoot(Directory start) {
  var current = start.absolute;
  while (current.parent.path != current.path) {
    final pubspec = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspec.existsSync() && pubspec.readAsStringSync().contains('charcoal_flutter_workspace')) {
      return current;
    }
    current = current.parent;
  }
  throw StateError('Workspace root not found.');
}
