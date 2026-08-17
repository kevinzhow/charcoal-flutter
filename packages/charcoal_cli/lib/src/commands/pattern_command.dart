import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../environment.dart';
import '../runner.dart';

final class PatternCommand extends CharcoalCommand {
  PatternCommand(super.environment) {
    argParser.addOption('limit', defaultsTo: '10', help: 'Maximum number of search results.');
  }

  @override
  String get description => 'Find a reviewed multi-component composition by name or intent.';

  @override
  String get name => 'pattern';

  @override
  String get invocation => 'charcoal pattern <name-or-intent> [--limit 10]';

  @override
  bool get takesArguments => true;

  @override
  int run() {
    final query = argResults!.rest.join(' ').trim();
    if (query.isEmpty) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        'pattern requires a name or intent.',
        exitCode: ExitCode.usage.code,
      );
    }
    final limit = int.tryParse(argResults!.option('limit')!);
    if (limit == null || limit < 1 || limit > 100) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        '--limit must be an integer from 1 to 100.',
        exitCode: ExitCode.usage.code,
      );
    }
    final search = CharcoalCatalogSearch(charcoalCatalog);
    final exact = search.exactPattern(query);
    if (exact != null) {
      environment.result('pattern', exact.toJson(), text: _patternText(exact));
      return ExitCode.success.code;
    }
    final results = search.searchPatterns(query, limit: limit);
    environment.result(
      'patternResults',
      <String, Object?>{
        'query': query,
        'count': results.length,
        'results': results
            .map(
              (result) => <String, Object?>{
                'id': result.pattern.id,
                'category': result.pattern.category,
                'summary': result.pattern.summary,
                'components': result.pattern.components,
                'score': result.score,
              },
            )
            .toList(growable: false),
      },
      text: results.isEmpty
          ? 'No Charcoal patterns matched "$query".'
          : results
                .map(
                  (result) =>
                      '${result.pattern.id} [${result.pattern.category}]\n  ${result.pattern.summary}',
                )
                .join('\n'),
    );
    return ExitCode.success.code;
  }
}

String _patternText(CharcoalPatternDoc pattern) {
  final buffer = StringBuffer()
    ..writeln('${pattern.id} [${pattern.category}]')
    ..writeln(pattern.summary)
    ..writeln()
    ..writeln('Use when:');
  for (final item in pattern.useWhen) {
    buffer.writeln('- $item');
  }
  buffer
    ..writeln()
    ..writeln('Avoid when:');
  for (final item in pattern.avoidWhen) {
    buffer.writeln('- $item');
  }
  buffer
    ..writeln()
    ..writeln('Components: ${pattern.components.join(', ')}')
    ..writeln()
    ..writeln('Composition:');
  for (final item in pattern.composition) {
    buffer.writeln('- $item');
  }
  buffer
    ..writeln()
    ..writeln('States: ${pattern.interactionStates.join(', ')}')
    ..writeln()
    ..writeln('Feedback:');
  for (final item in pattern.feedback) {
    buffer.writeln('- $item');
  }
  return buffer.toString().trimRight();
}
