import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../environment.dart';
import '../runner.dart';

final class SearchCommand extends CharcoalCommand {
  SearchCommand(super.environment) {
    argParser.addOption('limit', defaultsTo: '10', help: 'Maximum number of results.');
  }

  @override
  String get description => 'Find components by name, purpose, category, or keyword.';

  @override
  String get name => 'search';

  @override
  String get invocation => 'charcoal search <query> [--limit 10]';

  @override
  bool get takesArguments => true;

  @override
  int run() {
    final query = argResults!.rest.join(' ').trim();
    if (query.isEmpty) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        'search requires a non-empty query.',
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
    final results = CharcoalCatalogSearch(charcoalCatalog).search(query, limit: limit);
    environment.result(
      'searchResults',
      <String, Object?>{
        'query': query,
        'count': results.length,
        'results': results
            .map(
              (result) => <String, Object?>{
                'name': result.component.name,
                'category': result.component.category,
                'summary': result.component.summary,
                'documentationLevel': result.component.documentationLevel.name,
                'score': result.score,
              },
            )
            .toList(growable: false),
      },
      text: results.isEmpty
          ? 'No Charcoal components matched "$query".'
          : results
                .map(
                  (result) =>
                      '${result.component.name}  [${result.component.category}]\n'
                      '  ${result.component.summary}',
                )
                .join('\n'),
    );
    return ExitCode.success.code;
  }
}
