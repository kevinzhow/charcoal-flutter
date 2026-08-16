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

    final benchmarkFile = _file('agent/benchmarks/v1.json');
    if (!benchmarkFile.existsSync()) {
      problems.add('Missing agent/benchmarks/v1.json.');
    } else {
      _validateBenchmark(
        _readObject(benchmarkFile),
        generatedCatalog.catalog.schemaVersion,
        generatedCatalog.catalog.libraryVersion,
        generatedCatalog.catalog.components.map((component) => component.name).toSet(),
        problems,
      );
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

    final benchmarkFile = _file('agent/benchmarks/v1.json');
    final benchmark = _readObject(benchmarkFile);
    final versionChanged =
        benchmark['catalogSchemaVersion'] != generatedCatalog.catalog.schemaVersion ||
        benchmark['libraryVersion'] != generatedCatalog.catalog.libraryVersion;
    if (versionChanged) {
      benchmark['catalogSchemaVersion'] = generatedCatalog.catalog.schemaVersion;
      benchmark['libraryVersion'] = generatedCatalog.catalog.libraryVersion;
      _write(benchmarkFile.path, '${_prettyJson.convert(benchmark)}\n');
    }

    final problems = check();
    if (problems.isNotEmpty) {
      throw AgentReadyPipelineException(problems);
    }
  }

  File _file(String relativePath) => File(p.join(root.path, relativePath));

  String _relative(String path) => p.relative(path, from: root.path).replaceAll('\\', '/');

  void _write(String path, String contents) {
    final file = File(path)..parent.createSync(recursive: true);
    if (!file.existsSync() || file.readAsStringSync() != contents) {
      file.writeAsStringSync(contents);
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
  List<String> problems,
) {
  if (benchmark['schemaVersion'] != 1) {
    problems.add('agent/benchmarks/v1.json has an unsupported schemaVersion.');
  }
  if (benchmark['catalogSchemaVersion'] != catalogSchemaVersion) {
    problems.add('agent/benchmarks/v1.json has a stale catalogSchemaVersion.');
  }
  if (benchmark['libraryVersion'] != libraryVersion) {
    problems.add('agent/benchmarks/v1.json has a stale libraryVersion.');
  }
  final rawCases = benchmark['cases'];
  if (rawCases is! List<Object?> || rawCases.isEmpty) {
    problems.add('agent/benchmarks/v1.json must contain cases.');
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
