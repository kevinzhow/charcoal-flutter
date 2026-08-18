import 'dart:convert';
import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory workspace;
  late Map<String, Object?> nookReview;

  setUp(() {
    workspace = _workspaceRoot();
    nookReview = jsonDecode(
      File(p.join(workspace.path, 'agent', 'app-reviews', 'nook.json')).readAsStringSync(),
    ) as Map<String, Object?>;
  });

  test('checked-in app review links every surface to executable evidence', () {
    final report = validateCharcoalAppExperienceReview(
      nookReview,
      projectRoot: workspace,
    );

    expect(report.valid, isTrue, reason: report.problems.join('\n'));
    expect(report.ready, isTrue, reason: report.blockers.join('\n'));
  });

  test('app-review command reports a checked-in review as ready', () async {
    final output = StringBuffer();
    final errors = StringBuffer();

    final code = await runCharcoalCli(
      <String>[
        'app-review',
        '--validate',
        'agent/app-reviews/nook.json',
        '--json',
      ],
      output: output,
      errorOutput: errors,
      workingDirectory: workspace,
    );
    final response = jsonDecode(output.toString()) as Map<String, Object?>;
    final data = response['data']! as Map<String, Object?>;

    expect(code, 0);
    expect(errors, isEmpty);
    expect(response['type'], 'appReviewValidation');
    expect(data['ready'], isTrue);
  });

  test('changes-required is valid review data but cannot be Agent Ready', () {
    final application = nookReview['application']! as Map<String, Object?>;
    final firstSurface = (application['surfaces']! as List<Object?>).first as Map<String, Object?>;
    final review = firstSurface['review']! as Map<String, Object?>;
    review['verdict'] = 'changes-required';
    review['findings'] = <String>['Primary hierarchy needs another pass.'];

    final report = validateCharcoalAppExperienceReview(
      nookReview,
      projectRoot: workspace,
    );

    expect(report.valid, isTrue, reason: report.problems.join('\n'));
    expect(report.ready, isFalse);
    expect(report.blockers, contains(contains('Primary hierarchy needs another pass')));
  });

  test('omitting one design rule makes a surface review structurally invalid', () {
    final application = nookReview['application']! as Map<String, Object?>;
    final firstSurface = (application['surfaces']! as List<Object?>).first as Map<String, Object?>;
    final review = firstSurface['review']! as Map<String, Object?>;
    (review['rules']! as List<Object?>).removeLast();

    final report = validateCharcoalAppExperienceReview(
      nookReview,
      projectRoot: workspace,
    );

    expect(report.valid, isFalse);
    expect(report.problems, contains(contains('review.rules is missing')));
  });

  test('route enum drift cannot leave a new or existing surface unreviewed', () {
    final application = nookReview['application']! as Map<String, Object?>;
    final inventories = (application['stateInventories']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final routes = inventories.firstWhere((item) => item['enumName'] == 'NookRoute');
    (routes['mappings']! as List<Object?>).removeLast();

    final report = validateCharcoalAppExperienceReview(
      nookReview,
      projectRoot: workspace,
    );

    expect(report.valid, isFalse);
    expect(report.problems, contains(contains('does not inventory enum values: orderConfirmed')));
    expect(
      report.problems,
      contains(contains('State inventories do not map surfaces: order-receipt')),
    );
  });

  test('top-level destinations cannot declare a push stack effect', () {
    final application = nookReview['application']! as Map<String, Object?>;
    final transition = (application['transitions']! as List<Object?>).first as Map<String, Object?>;
    transition['stackEffect'] = 'push';

    final report = validateCharcoalAppExperienceReview(
      nookReview,
      projectRoot: workspace,
    );

    expect(report.valid, isFalse);
    expect(
      report.problems,
      contains(contains('must be "none" between top-level destinations')),
    );
  });

  test('top-level navigation evidence records touch phases and geometry', () {
    final application = nookReview['application']! as Map<String, Object?>;
    final scenarios = (application['runtimeScenarios']! as List<Object?>)
        .cast<Map<String, Object?>>();
    final scenario = scenarios.firstWhere(
      (item) => item['id'] == 'top-level-route-stability',
    );
    final sourcePath = scenario['sourcePath']! as String;
    final source = File(p.join(workspace.path, sourcePath)).readAsStringSync();

    expect(
      scenario['evidence'],
      allOf(
        contains('target bounds'),
        contains('text baselines'),
        contains('holds touch'),
        contains('after one pump'),
      ),
    );
    expect(source, contains(scenario['testName']));
    expect(source, contains('_paintedTabBackground'));
    expect(source, contains('cancelledGesture'));
    expect(source, contains('_expectSameTabGeometry'));
    expect(source, contains('labelBaseline'));
    expect(source, contains('await tester.pump();'));
  });

  test('every transition links executable evidence covering both surfaces', () {
    final application = nookReview['application']! as Map<String, Object?>;
    final transition = (application['transitions']! as List<Object?>).first as Map<String, Object?>;
    transition['runtimeScenarioIds'] = <String>['missing-scenario'];

    final report = validateCharcoalAppExperienceReview(
      nookReview,
      projectRoot: workspace,
    );

    expect(report.valid, isFalse);
    expect(
      report.problems,
      contains(contains('references unknown scenario "missing-scenario"')),
    );
  });
}

Directory _workspaceRoot() {
  var directory = Directory.current.absolute;
  while (directory.parent.path != directory.path) {
    if (File(p.join(directory.path, 'agent', 'app-reviews', 'nook.json')).existsSync()) {
      return directory;
    }
    directory = directory.parent;
  }
  throw StateError('Could not find the Charcoal workspace root.');
}
