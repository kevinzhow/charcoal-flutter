import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:test/test.dart';

void main() {
  final search = CharcoalCatalogSearch(charcoalCatalog);

  group('component search', () {
    test('resolves canonical, short, and compact component names', () {
      expect(search.exact('CharcoalButton')?.name, 'CharcoalButton');
      expect(search.exact('button')?.name, 'CharcoalButton');
      expect(search.exact('segmented control')?.name, 'CharcoalSegmentedControl');
      expect(search.exact('segmentedcontrol')?.name, 'CharcoalSegmentedControl');
    });

    test('finds components from user intent', () {
      final results = search.search('single choice');

      expect(results.first.component.name, 'CharcoalSegmentedControl');
      expect(results.map((result) => result.component.name), contains('CharcoalDropdown'));
    });

    test('provides deterministic typo suggestions', () {
      expect(search.suggestions('buton').first, 'CharcoalButton');
    });
  });

  group('token search', () {
    test('defaults to semantic roles and supports kind filters', () {
      final results = search.searchTokens('layout spacing', kind: CharcoalTokenKind.dimension);

      expect(results, isNotEmpty);
      expect(results.every((result) => result.token.kind == CharcoalTokenKind.dimension), isTrue);
      expect(results.every((result) => result.token.tier == CharcoalTokenTier.semantic), isTrue);
    });

    test('requires an explicit primitive tier', () {
      expect(search.searchTokens('blue 50', kind: CharcoalTokenKind.color), isEmpty);
      expect(
        search.searchTokens(
          'blue 50',
          kind: CharcoalTokenKind.color,
          tier: CharcoalTokenTier.primitive,
        ),
        isNotEmpty,
      );
    });
  });

  group('pattern search', () {
    test('resolves exact IDs and intent language', () {
      expect(search.exactPattern('daily checklist')?.id, 'daily-checklist');
      final results = search.searchPatterns('send money safely');
      expect(results.first.pattern.id, 'financial-action-flow');
    });
  });
}
