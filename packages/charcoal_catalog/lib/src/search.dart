import 'model.dart';

final class CharcoalSearchResult {
  const CharcoalSearchResult({required this.component, required this.score});

  final CharcoalComponentDoc component;
  final int score;
}

final class CharcoalTokenSearchResult {
  const CharcoalTokenSearchResult({required this.token, required this.score});

  final CharcoalTokenDoc token;
  final int score;
}

/// Deterministic component and token search shared by every agent adapter.
final class CharcoalCatalogSearch {
  const CharcoalCatalogSearch(this.catalog);

  final CharcoalCatalog catalog;

  List<CharcoalSearchResult> search(String query, {int limit = 10}) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty || limit <= 0) return const <CharcoalSearchResult>[];
    final terms = normalizedQuery.split(' ').where((term) => term.isNotEmpty).toList();
    final results = <CharcoalSearchResult>[];
    for (final component in catalog.components) {
      final score = _componentScore(component, normalizedQuery, terms);
      if (score > 0) results.add(CharcoalSearchResult(component: component, score: score));
    }
    results.sort((left, right) {
      final scoreOrder = right.score.compareTo(left.score);
      return scoreOrder != 0 ? scoreOrder : left.component.name.compareTo(right.component.name);
    });
    return results.take(limit).toList(growable: false);
  }

  List<CharcoalTokenSearchResult> searchTokens(
    String query, {
    int limit = 20,
    CharcoalTokenKind? kind,
    CharcoalTokenTier tier = CharcoalTokenTier.semantic,
  }) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty || limit <= 0) return const <CharcoalTokenSearchResult>[];
    final terms = normalizedQuery.split(' ').where((term) => term.isNotEmpty).toList();
    final results = <CharcoalTokenSearchResult>[];
    for (final token in catalog.tokens) {
      if (token.tier != tier || (kind != null && token.kind != kind)) continue;
      final score = _tokenScore(token, normalizedQuery, terms);
      if (score > 0) results.add(CharcoalTokenSearchResult(token: token, score: score));
    }
    results.sort((left, right) {
      final scoreOrder = right.score.compareTo(left.score);
      return scoreOrder != 0 ? scoreOrder : left.token.path.compareTo(right.token.path);
    });
    return results.take(limit).toList(growable: false);
  }

  CharcoalComponentDoc? exact(String query) {
    final normalizedQuery = _normalize(query);
    final compactQuery = normalizedQuery.replaceAll(' ', '');
    for (final component in catalog.components) {
      final name = _normalize(component.name);
      final shortName = _normalize(component.name.replaceFirst('Charcoal', ''));
      if (normalizedQuery == name ||
          normalizedQuery == shortName ||
          compactQuery == name.replaceAll(' ', '') ||
          compactQuery == shortName.replaceAll(' ', '')) {
        return component;
      }
    }
    return null;
  }

  CharcoalTokenDoc? exactToken(String query) {
    final normalizedQuery = _normalize(query);
    for (final token in catalog.tokens) {
      if (_normalize(token.path) == normalizedQuery ||
          _normalize(token.dartAccessor) == normalizedQuery) {
        return token;
      }
    }
    return null;
  }

  List<String> suggestions(String query, {int limit = 3}) {
    final normalizedQuery = _normalize(query);
    final ranked =
        <(String, int)>[
          for (final component in catalog.components)
            (
              component.name,
              _editDistance(
                normalizedQuery,
                _normalize(component.name.replaceFirst('Charcoal', '')),
              ),
            ),
        ]..sort((left, right) {
          final distanceOrder = left.$2.compareTo(right.$2);
          return distanceOrder != 0 ? distanceOrder : left.$1.compareTo(right.$1);
        });
    return ranked.take(limit).map((entry) => entry.$1).toList(growable: false);
  }

  int _componentScore(CharcoalComponentDoc component, String query, List<String> terms) {
    final name = _normalize(component.name);
    final shortName = _normalize(component.name.replaceFirst('Charcoal', ''));
    final keywords = component.keywords.map(_normalize).toList(growable: false);
    if (query == name || query == shortName) return 1000;
    if (name.startsWith(query) || shortName.startsWith(query)) return 900;
    if (keywords.contains(query)) return 850;

    final highSignal = <String>[name, shortName, ...keywords].join(' ');
    final descriptive = _normalize(
      <String>[
        component.category,
        component.summary,
        ...component.useWhen,
        ...component.avoidWhen,
        ...component.relatedComponents,
      ].join(' '),
    );
    var score = 0;
    if (highSignal.contains(query)) score += 500;
    if (descriptive.contains(query)) score += 300;
    for (final term in terms) {
      if (highSignal.contains(term)) score += 80;
      if (descriptive.contains(term)) score += 30;
    }
    return score;
  }

  int _tokenScore(CharcoalTokenDoc token, String query, List<String> terms) {
    final path = _normalize(token.path);
    final accessor = _normalize(token.dartAccessor);
    if (query == path || query == accessor) return 1000;
    if (path.startsWith(query) || accessor.startsWith(query)) return 900;
    final descriptive = _normalize('${token.kind.name} ${token.guidance}');
    var score = 0;
    if (path.contains(query) || accessor.contains(query)) score += 600;
    if (descriptive.contains(query)) score += 300;
    for (final term in terms) {
      if (path.contains(term) || accessor.contains(term)) score += 80;
      if (descriptive.contains(term)) score += 30;
    }
    return score;
  }
}

String _normalize(String value) => value
    .trim()
    .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (match) => '${match[1]} ${match[2]}')
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
    .trim();

int _editDistance(String left, String right) {
  if (left.isEmpty) return right.length;
  if (right.isEmpty) return left.length;
  var previous = List<int>.generate(right.length + 1, (index) => index);
  for (var leftIndex = 0; leftIndex < left.length; leftIndex++) {
    final current = <int>[leftIndex + 1];
    for (var rightIndex = 0; rightIndex < right.length; rightIndex++) {
      final substitution =
          previous[rightIndex] +
          (left.codeUnitAt(leftIndex) == right.codeUnitAt(rightIndex) ? 0 : 1);
      final insertion = current[rightIndex] + 1;
      final deletion = previous[rightIndex + 1] + 1;
      current.add(_minimum(substitution, insertion, deletion));
    }
    previous = current;
  }
  return previous.last;
}

int _minimum(int first, int second, int third) {
  var result = first < second ? first : second;
  if (third < result) result = third;
  return result;
}
