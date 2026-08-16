import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

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

    expect(RegExp(r'charcoal-agent:start').allMatches(instructions), hasLength(1));
    expect(RegExp(r'charcoal-agent:end').allMatches(instructions), hasLength(1));
    expect(instructions, contains('profile=contributor'));
    expect(instructions, contains('token <intent>'));
    expect(instructions, contains('benchmark --results <path>'));
    expect(instructions, contains('Do not add runtime recipe abstractions'));
  });
}
