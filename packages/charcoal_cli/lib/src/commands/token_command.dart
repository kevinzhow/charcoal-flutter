import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:io/io.dart';

import '../environment.dart';
import '../runner.dart';

final class TokenCommand extends CharcoalCommand {
  TokenCommand(super.environment) {
    argParser
      ..addOption(
        'tier',
        allowed: CharcoalTokenTier.values.map((value) => value.name),
        defaultsTo: CharcoalTokenTier.semantic.name,
        help: 'Semantic roles by default; primitive values require explicit opt-in.',
      )
      ..addOption(
        'kind',
        allowed: CharcoalTokenKind.values.map((value) => value.name),
        help: 'Restrict results to color, dimension, or typography tokens.',
      )
      ..addOption('limit', defaultsTo: '20', help: 'Maximum number of results.');
  }

  @override
  String get description => 'Find exact generated token accessors by role or token path.';

  @override
  String get name => 'token';

  @override
  String get invocation =>
      'charcoal token <query> [--kind color|dimension|typography] '
      '[--tier semantic|primitive] [--limit 20]';

  @override
  bool get takesArguments => true;

  @override
  int run() {
    final query = argResults!.rest.join(' ').trim();
    if (query.isEmpty) {
      throw CharcoalCliFailure(
        'ERR_INVALID_ARGUMENT',
        'token requires a non-empty query.',
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
    final tier = CharcoalTokenTier.values.byName(argResults!.option('tier')!);
    final rawKind = argResults!.option('kind');
    final kind = rawKind == null ? null : CharcoalTokenKind.values.byName(rawKind);
    final results = CharcoalCatalogSearch(
      charcoalCatalog,
    ).searchTokens(query, kind: kind, tier: tier, limit: limit);
    environment.result(
      'tokenResults',
      <String, Object?>{
        'query': query,
        'kind': kind?.name,
        'tier': tier.name,
        'count': results.length,
        'results': results
            .map(
              (result) => <String, Object?>{
                ...result.token.toJson(),
                'score': result.score,
              },
            )
            .toList(growable: false),
      },
      text: results.isEmpty
          ? 'No ${tier.name} Charcoal tokens matched "$query".'
          : results
                .map(
                  (result) =>
                      '${result.token.path}  '
                      '[${result.token.kind.name}/${result.token.tier.name}]\n'
                      '  ${result.token.dartAccessor}\n'
                      '  light: ${result.token.lightValue}; dark: ${result.token.darkValue}\n'
                      '  ${result.token.guidance}',
                )
                .join('\n'),
    );
    return ExitCode.success.code;
  }
}
