import 'dart:convert';
import 'dart:io';

import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:test/test.dart';

import '../tool/src/agent_ready_pipeline.dart';

void main() {
  test('agent benchmark is versioned and references real catalog components', () {
    final benchmark = jsonDecode(
      File('agent/benchmarks/v1.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final catalog = jsonDecode(
      File('packages/charcoal_catalog/catalog/charcoal_catalog.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final cases = benchmark['cases']! as List<Object?>;
    final suiteSchema = jsonDecode(
      File('agent/benchmarks/v1.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final resultSchema = jsonDecode(
      File('agent/results/v1.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final automatedResultSchema = jsonDecode(
      File('agent/results/v2.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final executorSchema = jsonDecode(
      File('agent/runner/executor-request-v1.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final graderRequestSchema = jsonDecode(
      File('agent/runner/grader-request-v1.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final graderResponseSchema = jsonDecode(
      File('agent/runner/grader-response-v1.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final codexGraderResponseSchema = jsonDecode(
      File('agent/adapters/codex-grader-response-v1.schema.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final catalogComponents = (catalog['components']! as List<Object?>)
        .cast<Map<String, Object?>>()
        .map((component) => component['name']! as String)
        .toSet();
    final ids = <String>{};

    expect(benchmark['schemaVersion'], 1);
    expect(benchmark['catalogSchemaVersion'], catalog['schemaVersion']);
    expect(benchmark['libraryVersion'], catalog['libraryVersion']);
    expect(suiteSchema[r'$schema'], 'https://json-schema.org/draft/2020-12/schema');
    expect(resultSchema[r'$schema'], 'https://json-schema.org/draft/2020-12/schema');
    expect(automatedResultSchema['properties'], contains('grader'));
    expect(executorSchema['properties'], contains('project'));
    expect(graderRequestSchema['properties'], contains('lockedScores'));
    expect(graderResponseSchema['properties'], contains('rationale'));
    expect(codexGraderResponseSchema['properties'], contains('rationale'));
    final codexSchemaText = jsonEncode(codexGraderResponseSchema);
    expect(codexSchemaText, isNot(contains('uniqueItems')));
    expect(codexSchemaText, isNot(contains('minLength')));
    expect(cases.length, greaterThanOrEqualTo(16));
    for (final value in cases.cast<Map<String, Object?>>()) {
      expect(ids.add(value['id']! as String), isTrue, reason: 'Duplicate benchmark id.');
      final expectedComponents = (value['expectedComponents']! as List<Object?>).cast<String>();
      expect(
        catalogComponents,
        containsAll(expectedComponents),
        reason: 'Unknown expected component in ${value['id']}.',
      );
      expect((value['requiredAssertions']! as List<Object?>), isNotEmpty);
      expect((value['forbiddenPatterns']! as List<Object?>), isNotEmpty);
    }
  });

  test('repository instructions contain exactly one managed contributor block', () {
    final instructions = File('AGENTS.md').readAsStringSync();
    final managedBlocks = charcoalManagedBlockPattern().allMatches(instructions).toList();

    expect(managedBlocks, hasLength(1));
    expect(managedBlocks.single.group(0), buildCharcoalManagedBlock('contributor'));
  });

  test('all derivable Agent Ready artifacts are synchronized', () {
    final problems = AgentReadyPipeline(Directory.current).check();

    expect(problems, isEmpty, reason: problems.join('\n'));
  });

  test('Codex grader schema is derived without unsupported constraints', () {
    final derived = deriveCodexGraderSchema(<String, Object?>{
      r'$id': 'canonical',
      'type': 'object',
      'properties': <String, Object?>{
        'label': <String, Object?>{
          'type': 'string',
          'minLength': 1,
          'maxLength': 20,
        },
      },
      'allOf': <Object?>[],
    });
    final encoded = jsonEncode(derived);

    expect(encoded, isNot(contains(r'$id')));
    expect(encoded, isNot(contains('minLength')));
    expect(encoded, isNot(contains('maxLength')));
    expect(encoded, isNot(contains('allOf')));
  });
}
