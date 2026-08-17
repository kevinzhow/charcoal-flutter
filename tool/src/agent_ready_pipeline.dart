import 'dart:convert';
import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:path/path.dart' as p;

import '../../packages/charcoal_catalog/tool/src/catalog_generator.dart';

const JsonEncoder _prettyJson = JsonEncoder.withIndent('  ');

/// Keeps every derivable Agent Ready artifact synchronized with the public package source.
final class AgentReadyPipeline {
  AgentReadyPipeline(this.root);

  final Directory root;

  List<String> check() {
    final problems = <String>[];
    final generatedCatalog = buildCatalog(root);
    _checkExactFile(
      File(catalogJsonPath(root)),
      generatedCatalog.json,
      problems,
      label: _relative(catalogJsonPath(root)),
    );
    _checkExactFile(
      File(catalogDartPath(root)),
      generatedCatalog.dartSource,
      problems,
      label: _relative(catalogDartPath(root)),
    );
    _checkExactFile(
      _file('agent/skills/charcoal-page-design/references/page-experience-spec.schema.json'),
      _file('agent/contracts/page-experience-spec-v1.schema.json').readAsStringSync(),
      problems,
      label: 'agent/skills/charcoal-page-design/references/page-experience-spec.schema.json',
    );
    _checkExactFile(
      _file('agent/skills/charcoal-page-design/assets/page-experience-spec.json'),
      _file('agent/contracts/page-experience-spec-v1.template.json').readAsStringSync(),
      problems,
      label: 'agent/skills/charcoal-page-design/assets/page-experience-spec.json',
    );
    _checkExactFile(
      _file('agent/skills/charcoal-page-design/references/app-experience-review.schema.json'),
      _file('agent/contracts/app-experience-review-v1.schema.json').readAsStringSync(),
      problems,
      label: 'agent/skills/charcoal-page-design/references/app-experience-review.schema.json',
    );
    _checkExactFile(
      _file('agent/skills/charcoal-page-design/assets/app-experience-review.json'),
      _file('agent/contracts/app-experience-review-v1.template.json').readAsStringSync(),
      problems,
      label: 'agent/skills/charcoal-page-design/assets/app-experience-review.json',
    );
    final canonicalSkill = _fileDirectory('agent/skills/charcoal-page-design');
    final repositorySkill = _fileDirectory('.agents/skills/charcoal-page-design');
    final bundledSkill = _fileDirectory(
      'packages/charcoal_cli/agent/skills/charcoal-page-design',
    );
    if (!File(p.join(canonicalSkill.path, 'SKILL.md')).existsSync()) {
      problems.add('Missing agent/skills/charcoal-page-design/SKILL.md.');
    } else if (!bundledSkill.existsSync()) {
      problems.add('Missing the charcoal_cli page-design skill bundle.');
    } else if (charcoalSkillDirectoryHash(canonicalSkill) !=
        charcoalSkillDirectoryHash(bundledSkill)) {
      problems.add('The charcoal_cli page-design skill bundle is stale.');
    }
    if (!repositorySkill.existsSync()) {
      problems.add('Missing .agents/skills/charcoal-page-design repository Skill.');
    } else if (canonicalSkill.existsSync() &&
        charcoalSkillDirectoryHash(canonicalSkill) != charcoalSkillDirectoryHash(repositorySkill)) {
      problems.add('The repository-local page-design Skill is stale.');
    }

    final pageSpecs = _fileDirectory('agent/page-specs').existsSync()
        ? (_fileDirectory('agent/page-specs').listSync()..sort((a, b) => a.path.compareTo(b.path)))
              .whereType<File>()
              .where((file) => p.extension(file.path) == '.json')
        : const <File>[];
    for (final pageSpec in pageSpecs) {
      final report = validateCharcoalPageExperienceSpec(
        _readObject(pageSpec),
        catalog: generatedCatalog.catalog,
      );
      for (final problem in report.problems) {
        problems.add('${_relative(pageSpec.path)}: $problem');
      }
    }

    final appReviews = _jsonFiles('agent/app-reviews');
    if (appReviews.isEmpty) {
      problems.add('agent/app-reviews must contain at least one App Experience Review.');
    }
    final appReviewIds = <String>{};
    for (final appReview in appReviews) {
      final report = validateCharcoalAppExperienceReview(
        _readObject(appReview),
        catalog: generatedCatalog.catalog,
        projectRoot: root,
      );
      for (final problem in report.problems) {
        problems.add('${_relative(appReview.path)}: $problem');
      }
      for (final blocker in report.blockers) {
        problems.add('${_relative(appReview.path)}: not Agent Ready: $blocker');
      }
      if (report.appId != null && !appReviewIds.add(report.appId!)) {
        problems.add('${_relative(appReview.path)}: duplicate application ID ${report.appId}.');
      }
    }
    final missingAppReviews = _requiredAppReviewIds.difference(appReviewIds);
    if (missingAppReviews.isNotEmpty) {
      problems.add(
        'Missing required App Experience Reviews: ${missingAppReviews.toList()..sort()}.',
      );
    }

    final canonicalGraderSchema = _readObject(
      _file('agent/runner/grader-response-v1.schema.json'),
    );
    final codexSchema = deriveCodexGraderSchema(canonicalGraderSchema);
    final codexSchemaFile = _file('agent/adapters/codex-grader-response-v1.schema.json');
    if (!codexSchemaFile.existsSync()) {
      problems.add('Missing ${_relative(codexSchemaFile.path)}.');
    } else {
      final actual = _readObject(codexSchemaFile);
      if (_canonicalJson(actual) != _canonicalJson(codexSchema)) {
        problems.add(
          '${_relative(codexSchemaFile.path)} is stale relative to the canonical grader schema.',
        );
      }
    }

    final instructionsFile = _file('AGENTS.md');
    if (!instructionsFile.existsSync()) {
      problems.add('Missing AGENTS.md.');
    } else {
      final instructions = instructionsFile.readAsStringSync();
      final matches = charcoalManagedBlockPattern().allMatches(instructions).toList();
      if (matches.length != 1) {
        problems.add('AGENTS.md must contain exactly one managed Charcoal block.');
      } else if (matches.single.group(0) != buildCharcoalManagedBlock('contributor')) {
        problems.add('The managed Charcoal block in AGENTS.md is stale.');
      }
    }

    for (final path in _benchmarkPaths) {
      final benchmarkFile = _file(path);
      if (!benchmarkFile.existsSync()) {
        problems.add('Missing $path.');
      } else {
        _validateBenchmark(
          _readObject(benchmarkFile),
          generatedCatalog.catalog.schemaVersion,
          generatedCatalog.catalog.libraryVersion,
          generatedCatalog.catalog.components.map((component) => component.name).toSet(),
          problems,
          label: path,
        );
      }
    }
    final contracts = <String, Map<String, Object?>>{};
    for (final path in _contractPaths) {
      final file = _file(path);
      if (!file.existsSync()) {
        problems.add('Missing $path.');
      } else {
        contracts[path] = _readObject(file);
      }
    }
    _validateRuntimeContracts(contracts, problems);
    return problems;
  }

  void generate() {
    final generatedCatalog = buildCatalog(root);
    _write(catalogJsonPath(root), generatedCatalog.json);
    _write(catalogDartPath(root), generatedCatalog.dartSource);
    _write(
      _file('agent/skills/charcoal-page-design/references/page-experience-spec.schema.json').path,
      _file('agent/contracts/page-experience-spec-v1.schema.json').readAsStringSync(),
    );
    _write(
      _file('agent/skills/charcoal-page-design/assets/page-experience-spec.json').path,
      _file('agent/contracts/page-experience-spec-v1.template.json').readAsStringSync(),
    );
    _write(
      _file('agent/skills/charcoal-page-design/references/app-experience-review.schema.json').path,
      _file('agent/contracts/app-experience-review-v1.schema.json').readAsStringSync(),
    );
    _write(
      _file('agent/skills/charcoal-page-design/assets/app-experience-review.json').path,
      _file('agent/contracts/app-experience-review-v1.template.json').readAsStringSync(),
    );
    _copyExactDirectory(
      _fileDirectory('agent/skills/charcoal-page-design'),
      _fileDirectory('packages/charcoal_cli/agent/skills/charcoal-page-design'),
    );

    for (final pageSpec in _jsonFiles('agent/page-specs')) {
      final spec = _readObject(pageSpec);
      final versionChanged =
          spec['catalogSchemaVersion'] != generatedCatalog.catalog.schemaVersion ||
          spec['libraryVersion'] != generatedCatalog.catalog.libraryVersion;
      if (versionChanged) {
        spec['catalogSchemaVersion'] = generatedCatalog.catalog.schemaVersion;
        spec['libraryVersion'] = generatedCatalog.catalog.libraryVersion;
        _write(pageSpec.path, '${_prettyJson.convert(spec)}\n');
      }
    }
    for (final appReview in _jsonFiles('agent/app-reviews')) {
      final review = _readObject(appReview);
      final versionChanged =
          review['catalogSchemaVersion'] != generatedCatalog.catalog.schemaVersion ||
          review['libraryVersion'] != generatedCatalog.catalog.libraryVersion;
      if (versionChanged) {
        review['catalogSchemaVersion'] = generatedCatalog.catalog.schemaVersion;
        review['libraryVersion'] = generatedCatalog.catalog.libraryVersion;
        _write(appReview.path, '${_prettyJson.convert(review)}\n');
      }
    }

    final canonicalGraderSchema = _readObject(
      _file('agent/runner/grader-response-v1.schema.json'),
    );
    final codexSchema = deriveCodexGraderSchema(canonicalGraderSchema);
    final codexPath = p.join(
      root.path,
      'agent',
      'adapters',
      'codex-grader-response-v1.schema.json',
    );
    final codexFile = File(codexPath);
    final codexMatches =
        codexFile.existsSync() &&
        _canonicalJson(_readObject(codexFile)) == _canonicalJson(codexSchema);
    if (!codexMatches) {
      _write(codexPath, '${_prettyJson.convert(codexSchema)}\n');
    }

    final instructionsFile = _file('AGENTS.md');
    final existingInstructions = instructionsFile.existsSync()
        ? instructionsFile.readAsStringSync()
        : '';
    final managedBlock = buildCharcoalManagedBlock('contributor');
    final pattern = charcoalManagedBlockPattern();
    final nextInstructions = pattern.hasMatch(existingInstructions)
        ? existingInstructions.replaceFirst(pattern, managedBlock)
        : '${existingInstructions.trimRight()}'
              '${existingInstructions.trim().isEmpty ? '' : '\n\n'}'
              '$managedBlock\n';
    _write(instructionsFile.path, nextInstructions);

    for (final path in _benchmarkPaths) {
      final benchmarkFile = _file(path);
      final benchmark = _readObject(benchmarkFile);
      final versionChanged =
          benchmark['catalogSchemaVersion'] != generatedCatalog.catalog.schemaVersion ||
          benchmark['libraryVersion'] != generatedCatalog.catalog.libraryVersion;
      if (versionChanged) {
        benchmark['catalogSchemaVersion'] = generatedCatalog.catalog.schemaVersion;
        benchmark['libraryVersion'] = generatedCatalog.catalog.libraryVersion;
        _write(benchmarkFile.path, '${_prettyJson.convert(benchmark)}\n');
      }
    }

    final problems = check();
    if (problems.isNotEmpty) {
      throw AgentReadyPipelineException(problems);
    }
  }

  File _file(String relativePath) => File(p.join(root.path, relativePath));

  Directory _fileDirectory(String relativePath) => Directory(p.join(root.path, relativePath));

  List<File> _jsonFiles(String relativePath) {
    final directory = _fileDirectory(relativePath);
    if (!directory.existsSync()) return const <File>[];
    return (directory.listSync()..sort((left, right) => left.path.compareTo(right.path)))
        .whereType<File>()
        .where((file) => p.extension(file.path) == '.json')
        .toList(growable: false);
  }

  String _relative(String path) => p.relative(path, from: root.path).replaceAll('\\', '/');

  void _write(String path, String contents) {
    final file = File(path)..parent.createSync(recursive: true);
    if (!file.existsSync() || file.readAsStringSync() != contents) {
      file.writeAsStringSync(contents);
    }
  }

  void _copyExactDirectory(Directory source, Directory target) {
    if (target.existsSync()) target.deleteSync(recursive: true);
    target.createSync(recursive: true);
    for (final entity in source.listSync(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final relative = p.relative(entity.path, from: source.path);
      final destination = File(p.join(target.path, relative));
      destination.parent.createSync(recursive: true);
      destination.writeAsBytesSync(entity.readAsBytesSync());
    }
  }
}

final class AgentReadyPipelineException implements Exception {
  const AgentReadyPipelineException(this.problems);

  final List<String> problems;

  @override
  String toString() => problems.join('\n');
}

/// Derives the OpenAI Structured Outputs subset from the canonical grader contract.
Map<String, Object?> deriveCodexGraderSchema(Map<String, Object?> canonical) {
  final derived = _stripUnsupportedSchemaKeywords(canonical) as Map<String, Object?>;
  derived
    ..remove(r'$id')
    ..['title'] = 'Charcoal Codex grader structured output';
  return derived;
}

Object? _stripUnsupportedSchemaKeywords(Object? value) {
  if (value is List<Object?>) {
    return value.map(_stripUnsupportedSchemaKeywords).toList(growable: false);
  }
  if (value is Map<String, Object?>) {
    return <String, Object?>{
      for (final entry in value.entries)
        if (!_codexUnsupportedSchemaKeywords.contains(entry.key))
          entry.key: _stripUnsupportedSchemaKeywords(entry.value),
    };
  }
  return value;
}

const Set<String> _codexUnsupportedSchemaKeywords = <String>{
  r'$id',
  'allOf',
  'dependentRequired',
  'dependentSchemas',
  'else',
  'if',
  'maxLength',
  'minLength',
  'not',
  'patternProperties',
  'then',
  'uniqueItems',
};

const Set<String> _requiredAppReviewIds = <String>{'nook', 'lumen', 'daylight'};

void _checkExactFile(
  File file,
  String expected,
  List<String> problems, {
  required String label,
}) {
  if (!file.existsSync()) {
    problems.add('Missing $label.');
  } else if (file.readAsStringSync() != expected) {
    problems.add('$label is stale.');
  }
}

void _validateBenchmark(
  Map<String, Object?> benchmark,
  int catalogSchemaVersion,
  String libraryVersion,
  Set<String> catalogComponents,
  List<String> problems, {
  required String label,
}) {
  if (benchmark['schemaVersion'] != 1) {
    problems.add('$label has an unsupported schemaVersion.');
  }
  if (benchmark['catalogSchemaVersion'] != catalogSchemaVersion) {
    problems.add('$label has a stale catalogSchemaVersion.');
  }
  if (benchmark['libraryVersion'] != libraryVersion) {
    problems.add('$label has a stale libraryVersion.');
  }
  final rawCases = benchmark['cases'];
  if (rawCases is! List<Object?> || rawCases.isEmpty) {
    problems.add('$label must contain cases.');
    return;
  }
  final ids = <String>{};
  for (final (index, rawCase) in rawCases.indexed) {
    if (rawCase is! Map<String, Object?>) {
      problems.add('Benchmark case $index is not a JSON object.');
      continue;
    }
    final id = rawCase['id'];
    if (id is! String || id.trim().isEmpty || !ids.add(id)) {
      problems.add('Benchmark case $index has a missing or duplicate ID.');
    }
    final expected = rawCase['expectedComponents'];
    if (expected is! List<Object?> || expected.any((value) => value is! String)) {
      problems.add('Benchmark case ${id ?? index} has malformed expectedComponents.');
    } else {
      final unknown = expected.cast<String>().where((name) => !catalogComponents.contains(name));
      if (unknown.isNotEmpty) {
        problems.add(
          'Benchmark case ${id ?? index} references unknown components: ${unknown.join(', ')}.',
        );
      }
    }
    for (final key in <String>['requiredAssertions', 'forbiddenPatterns']) {
      final values = rawCase[key];
      if (values is! List<Object?> || values.isEmpty || values.any((value) => value is! String)) {
        problems.add('Benchmark case ${id ?? index} has malformed $key.');
      }
    }
  }
}

void _validateRuntimeContracts(
  Map<String, Map<String, Object?>> contracts,
  List<String> problems,
) {
  final guidanceKeys = charcoalBenchmarkGraderScoreGuidance.keys.toSet();
  final graderScoreKeys = charcoalBenchmarkGraderScoreLimits.keys.toSet();
  if (guidanceKeys.difference(graderScoreKeys).isNotEmpty ||
      graderScoreKeys.difference(guidanceKeys).isNotEmpty) {
    problems.add('Runtime grader score guidance does not match its score dimensions.');
  }
  final resultV1 = contracts['agent/results/v1.schema.json'];
  if (resultV1 != null) {
    _validateResultContract(
      resultV1,
      version: 1,
      expectedArtifacts: charcoalBenchmarkArtifactKeys,
      expectedFailures: charcoalBenchmarkHardFailures.difference(
        const <String>{'agent_execution_error'},
      ),
      problems: problems,
    );
  }
  final resultV2 = contracts['agent/results/v2.schema.json'];
  if (resultV2 != null) {
    _validateResultContract(
      resultV2,
      version: 2,
      expectedArtifacts: charcoalBenchmarkV2ArtifactKeys,
      expectedFailures: charcoalBenchmarkHardFailures,
      problems: problems,
    );
  }
  final grader = contracts['agent/runner/grader-response-v1.schema.json'];
  if (grader != null) {
    final properties = _object(grader, 'properties');
    _validateScoreProperties(
      _object(_object(properties, 'scores'), 'properties'),
      charcoalBenchmarkGraderScoreLimits,
      'agent/runner/grader-response-v1.schema.json',
      problems,
    );
    final graderFailures = _stringSet(
      _object(_object(properties, 'hardFailures'), 'items')['enum'],
    );
    if (graderFailures.difference(charcoalBenchmarkGraderHardFailures).isNotEmpty ||
        charcoalBenchmarkGraderHardFailures.difference(graderFailures).isNotEmpty) {
      problems.add('The grader response hard-failure enum is out of sync with runtime policy.');
    }
  }
  final executor = contracts['agent/runner/executor-request-v1.schema.json'];
  if (executor != null) {
    final configuration = _object(_object(executor, 'properties'), 'configuration');
    final configured = _stringSet(configuration['enum']);
    if (configured.difference(charcoalBenchmarkConfigurations).isNotEmpty ||
        charcoalBenchmarkConfigurations.difference(configured).isNotEmpty) {
      problems.add('The executor configuration enum is out of sync with runtime policy.');
    }
  }
}

void _validateResultContract(
  Map<String, Object?> schema, {
  required int version,
  required Set<String> expectedArtifacts,
  required Set<String> expectedFailures,
  required List<String> problems,
}) {
  final run = _object(_object(schema, r'$defs'), 'run');
  final properties = _object(run, 'properties');
  _validateScoreProperties(
    _object(_object(properties, 'scores'), 'properties'),
    charcoalBenchmarkScoreLimits,
    'agent/results/v$version.schema.json',
    problems,
  );
  final artifacts = _object(properties, 'artifacts');
  final artifactKeys = _stringSet(artifacts['required']);
  if (artifactKeys.difference(expectedArtifacts).isNotEmpty ||
      expectedArtifacts.difference(artifactKeys).isNotEmpty) {
    problems.add('Result v$version artifact keys are out of sync with runtime policy.');
  }
  final failures = _stringSet(_object(_object(properties, 'hardFailures'), 'items')['enum']);
  if (failures.difference(expectedFailures).isNotEmpty ||
      expectedFailures.difference(failures).isNotEmpty) {
    problems.add('Result v$version hard-failure enum is out of sync with runtime policy.');
  }
}

void _validateScoreProperties(
  Map<String, Object?> properties,
  Map<String, int> expected,
  String context,
  List<String> problems,
) {
  if (properties.keys.toSet().difference(expected.keys.toSet()).isNotEmpty ||
      expected.keys.toSet().difference(properties.keys.toSet()).isNotEmpty) {
    problems.add('$context score dimensions are out of sync with runtime policy.');
    return;
  }
  for (final entry in expected.entries) {
    final score = _object(properties, entry.key);
    if (score['minimum'] != 0 || score['maximum'] != entry.value) {
      problems.add('$context has a stale range for ${entry.key}.');
    }
  }
}

Map<String, Object?> _object(Map<String, Object?> value, String key) {
  final nested = value[key];
  if (nested is Map<String, Object?>) return nested;
  throw FormatException('$key must be a JSON object.');
}

Set<String> _stringSet(Object? value) {
  if (value is List<Object?> && value.every((item) => item is String)) {
    return value.cast<String>().toSet();
  }
  throw const FormatException('Expected a JSON string array.');
}

Map<String, Object?> _readObject(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw FormatException('${file.path} must contain a JSON object.');
  }
  return decoded;
}

String _canonicalJson(Object? value) {
  Object? sorted(Object? current) {
    if (current is List<Object?>) return current.map(sorted).toList(growable: false);
    if (current is Map<String, Object?>) {
      final keys = current.keys.toList()..sort();
      return <String, Object?>{for (final key in keys) key: sorted(current[key])};
    }
    return current;
  }

  return jsonEncode(sorted(value));
}

const List<String> _contractPaths = <String>[
  'agent/benchmarks/v1.schema.json',
  'agent/results/v1.schema.json',
  'agent/results/v2.schema.json',
  'agent/runner/executor-request-v1.schema.json',
  'agent/runner/grader-request-v1.schema.json',
  'agent/runner/grader-response-v1.schema.json',
];

const List<String> _benchmarkPaths = <String>[
  'agent/benchmarks/v1.json',
  'agent/benchmarks/page-experience-v1.json',
];
