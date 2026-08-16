import 'package:charcoal_catalog/charcoal_catalog.dart';

const Map<String, int> charcoalBenchmarkGraderScoreLimits = <String, int>{
  'apiAccuracy': 20,
  'charcoalComposition': 15,
  'tokenAndLayout': 10,
  'accessibility': 10,
  'responsiveness': 10,
  'verification': 5,
};

const Map<String, int> charcoalBenchmarkScoreLimits = <String, int>{
  'compileAndTests': 30,
  ...charcoalBenchmarkGraderScoreLimits,
};

const Map<String, String> charcoalBenchmarkGraderScoreGuidance = <String, String>{
  'apiAccuracy': 'exact installed public API, appropriate component choice, no guessed parameters',
  'charcoalComposition':
      'uses existing Charcoal controls instead of substitutes; for a genuinely missing component, '
      'an explicit no-substitution product decision can earn full credit',
  'tokenAndLayout':
      'Flutter primitives and semantic token roles respect ownership; no external recreation of '
      'component internals',
  'accessibility':
      'labels, semantics, focus/keyboard behavior, disabled behavior, and text scaling relevant to '
      'the case',
  'responsiveness': 'requested compact and desktop behavior is actually constraint-driven',
  'verification':
      'the candidate agent itself ran proportionate checks and reported them accurately; harness '
      'checks alone earn no credit here',
};

const Set<String> charcoalBenchmarkConfigurations = <String>{
  'baseline',
  'instructions',
  'cli',
  'protocol',
};

const Set<String> charcoalBenchmarkHardFailures = <String>{
  'compile_error',
  'fabricated_charcoal_api',
  'silent_platform_substitution',
  'unsafe_file_mutation',
  'agent_execution_error',
};

/// Hard failures the subjective grader may add after structural verification.
const Set<String> charcoalBenchmarkGraderHardFailures = <String>{
  'fabricated_charcoal_api',
  'silent_platform_substitution',
};

/// Artifact keys required by manually recorded v1 results.
const Set<String> charcoalBenchmarkArtifactKeys = <String>{
  'source',
  'toolTranscript',
  'analysisOutput',
  'testOutput',
};

/// Artifact keys required by harness-generated v2 results.
const Set<String> charcoalBenchmarkV2ArtifactKeys = <String>{
  ...charcoalBenchmarkArtifactKeys,
  'evaluationOutput',
};

final class CharcoalBenchmarkReport {
  const CharcoalBenchmarkReport({
    required this.suite,
    required this.configuration,
    required this.model,
    required this.grader,
    required this.totalCases,
    required this.evaluatedCases,
    required this.passedCases,
    required this.failedCases,
    required this.missingCases,
    required this.averageScore,
    required this.cases,
  });

  final String suite;
  final String configuration;
  final String model;
  final String grader;
  final int totalCases;
  final int evaluatedCases;
  final int passedCases;
  final int failedCases;
  final List<String> missingCases;
  final double averageScore;
  final List<Map<String, Object?>> cases;

  Map<String, Object?> toJson() => <String, Object?>{
    'suite': suite,
    'configuration': configuration,
    'model': model,
    'grader': grader,
    'totalCases': totalCases,
    'evaluatedCases': evaluatedCases,
    'passedCases': passedCases,
    'failedCases': failedCases,
    'missingCases': missingCases,
    'averageScore': averageScore,
    'passRate': evaluatedCases == 0 ? 0 : passedCases / evaluatedCases,
    'cases': cases,
  };
}

final class CharcoalBenchmarkFormatException implements Exception {
  const CharcoalBenchmarkFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}

CharcoalBenchmarkReport evaluateCharcoalBenchmark(
  Map<String, Object?> suite,
  Map<String, Object?> results, {
  bool allowPartial = false,
}) {
  _expectValue(suite, 'schemaVersion', 1, context: 'suite');
  final resultSchemaVersion = results['schemaVersion'];
  if (resultSchemaVersion != 1 && resultSchemaVersion != 2) {
    throw const CharcoalBenchmarkFormatException(
      'results.schemaVersion must equal 1 or 2.',
    );
  }
  final suiteName = _requiredString(suite, 'suite', context: 'suite');
  _expectValue(results, 'suite', suiteName, context: 'results');
  _expectValue(
    suite,
    'catalogSchemaVersion',
    charcoalCatalog.schemaVersion,
    context: 'suite',
  );
  _expectValue(
    suite,
    'libraryVersion',
    charcoalCatalog.libraryVersion,
    context: 'suite',
  );
  _expectValue(
    results,
    'catalogSchemaVersion',
    charcoalCatalog.schemaVersion,
    context: 'results',
  );
  _expectValue(
    results,
    'libraryVersion',
    charcoalCatalog.libraryVersion,
    context: 'results',
  );
  final configuration = _requiredString(results, 'configuration', context: 'results');
  if (!charcoalBenchmarkConfigurations.contains(configuration)) {
    throw CharcoalBenchmarkFormatException(
      'Unknown configuration "$configuration". Expected '
      '${charcoalBenchmarkConfigurations.join(', ')}.',
    );
  }
  final model = _requiredString(results, 'model', context: 'results');
  final grader = resultSchemaVersion == 2
      ? _requiredString(results, 'grader', context: 'results')
      : 'manual-v1';
  final suiteCases = _objectList(suite, 'cases', context: 'suite');
  if (suiteCases.isEmpty) {
    throw const CharcoalBenchmarkFormatException('suite.cases must not be empty.');
  }
  final caseIds = <String>[];
  for (final benchmarkCase in suiteCases) {
    final id = _requiredString(benchmarkCase, 'id', context: 'suite case');
    if (caseIds.contains(id)) {
      throw CharcoalBenchmarkFormatException('Duplicate suite case "$id".');
    }
    caseIds.add(id);
  }

  final runs = _objectList(results, 'runs', context: 'results');
  final seen = <String>{};
  final caseReports = <Map<String, Object?>>[];
  var scoreTotal = 0.0;
  var passed = 0;
  for (final run in runs) {
    final caseId = _requiredString(run, 'caseId', context: 'benchmark run');
    if (!caseIds.contains(caseId)) {
      throw CharcoalBenchmarkFormatException('Unknown benchmark case "$caseId".');
    }
    if (!seen.add(caseId)) {
      throw CharcoalBenchmarkFormatException('Duplicate benchmark run "$caseId".');
    }
    final scores = _requiredObject(run, 'scores', context: 'benchmark run $caseId');
    final unknownScores = scores.keys.where(
      (key) => !charcoalBenchmarkScoreLimits.containsKey(key),
    );
    if (unknownScores.isNotEmpty) {
      throw CharcoalBenchmarkFormatException(
        'Unknown score dimension in $caseId: ${unknownScores.join(', ')}.',
      );
    }
    var total = 0.0;
    for (final scoreLimit in charcoalBenchmarkScoreLimits.entries) {
      final score = scores[scoreLimit.key];
      if (score is! num || !score.isFinite || score < 0 || score > scoreLimit.value) {
        throw CharcoalBenchmarkFormatException(
          '${scoreLimit.key} for $caseId must be from 0 to ${scoreLimit.value}.',
        );
      }
      total += score.toDouble();
    }
    final failures = _stringList(run, 'hardFailures', context: 'benchmark run $caseId');
    if (failures.toSet().length != failures.length) {
      throw CharcoalBenchmarkFormatException(
        'hardFailures for $caseId must not contain duplicates.',
      );
    }
    final allowedFailures = resultSchemaVersion == 1
        ? charcoalBenchmarkHardFailures.difference(const <String>{'agent_execution_error'})
        : charcoalBenchmarkHardFailures;
    final unknownFailures = failures.where((failure) => !allowedFailures.contains(failure));
    if (unknownFailures.isNotEmpty) {
      throw CharcoalBenchmarkFormatException(
        'Unknown hard failure in $caseId: ${unknownFailures.join(', ')}.',
      );
    }
    final artifacts = _requiredObject(run, 'artifacts', context: 'benchmark run $caseId');
    final artifactKeys = resultSchemaVersion == 1
        ? charcoalBenchmarkArtifactKeys
        : charcoalBenchmarkV2ArtifactKeys;
    final unknownArtifacts = artifacts.keys.where(
      (key) => !artifactKeys.contains(key),
    );
    if (unknownArtifacts.isNotEmpty) {
      throw CharcoalBenchmarkFormatException(
        'Unknown artifact in $caseId: ${unknownArtifacts.join(', ')}.',
      );
    }
    for (final key in artifactKeys) {
      final artifact = artifacts[key];
      if (artifact is! String || artifact.trim().isEmpty) {
        throw CharcoalBenchmarkFormatException(
          'Artifact "$key" must be a non-empty path for $caseId.',
        );
      }
    }
    final didPass = total >= 85 && failures.isEmpty;
    if (didPass) passed++;
    scoreTotal += total;
    caseReports.add(<String, Object?>{
      'caseId': caseId,
      'score': total,
      'passed': didPass,
      'hardFailures': failures,
      'scores': scores,
    });
  }
  final missing = caseIds.where((id) => !seen.contains(id)).toList(growable: false);
  if (missing.isNotEmpty && !allowPartial) {
    throw CharcoalBenchmarkFormatException(
      'Missing ${missing.length} benchmark runs: ${missing.join(', ')}.',
    );
  }
  caseReports.sort((left, right) {
    return caseIds
        .indexOf(left['caseId']! as String)
        .compareTo(caseIds.indexOf(right['caseId']! as String));
  });
  final evaluated = caseReports.length;
  final average = evaluated == 0 ? 0.0 : double.parse((scoreTotal / evaluated).toStringAsFixed(2));
  return CharcoalBenchmarkReport(
    suite: suiteName,
    configuration: configuration,
    model: model,
    grader: grader,
    totalCases: caseIds.length,
    evaluatedCases: evaluated,
    passedCases: passed,
    failedCases: evaluated - passed,
    missingCases: missing,
    averageScore: average,
    cases: caseReports,
  );
}

void _expectValue(
  Map<String, Object?> object,
  String key,
  Object expected, {
  required String context,
}) {
  if (object[key] != expected) {
    throw CharcoalBenchmarkFormatException('$context.$key must equal $expected.');
  }
}

String _requiredString(Map<String, Object?> object, String key, {required String context}) {
  final value = object[key];
  if (value is! String || value.trim().isEmpty) {
    throw CharcoalBenchmarkFormatException('$context.$key must be a non-empty string.');
  }
  return value;
}

Map<String, Object?> _requiredObject(
  Map<String, Object?> object,
  String key, {
  required String context,
}) {
  final value = object[key];
  if (value is! Map<String, Object?>) {
    throw CharcoalBenchmarkFormatException('$context.$key must be an object.');
  }
  return value;
}

List<Map<String, Object?>> _objectList(
  Map<String, Object?> object,
  String key, {
  required String context,
}) {
  final value = object[key];
  if (value is! List<Object?> || value.any((entry) => entry is! Map<String, Object?>)) {
    throw CharcoalBenchmarkFormatException('$context.$key must be a list of objects.');
  }
  return value.cast<Map<String, Object?>>();
}

List<String> _stringList(
  Map<String, Object?> object,
  String key, {
  required String context,
}) {
  final value = object[key];
  if (value is! List<Object?> || value.any((entry) => entry is! String)) {
    throw CharcoalBenchmarkFormatException('$context.$key must be a list of strings.');
  }
  return value.cast<String>();
}
