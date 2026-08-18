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

      expect(results.first.component.name, 'CharcoalRadio');
      expect(
        results.map((result) => result.component.name),
        containsAll(<String>[
          'CharcoalDropdown',
          'CharcoalSegmentedControl',
        ]),
      );
    });

    test('finds the reviewed component for translated tag filters', () {
      final results = search.search('translated removable tag filter');

      expect(results.first.component.name, 'CharcoalTagItem');
    });

    test('finds reviewed field metadata and advisory guidance', () {
      expect(
        search.search('visible required field label counter').first.component.name,
        'CharcoalFieldLabel',
      );
      expect(
        search.search('persistent advisory hint action').first.component.name,
        'CharcoalHintText',
      );
    });

    test('finds reviewed asynchronous action feedback', () {
      expect(
        search.search('indeterminate named loading wait').first.component.name,
        'CharcoalLoadingSpinner',
      );
      expect(
        search.search('blocking subtree loading overlay').first.component.name,
        'CharcoalSpinnerOverlay',
      );
      expect(
        search.search('stable follow unfollow action size').first.component.name,
        'CharcoalSwitchingButton',
      );
    });

    test('finds reviewed theme and text foundations', () {
      expect(
        search.search('scoped semantic token theme').first.component.name,
        'CharcoalTheme',
      );
      expect(
        search.search('numeric component typography scale').first.component.name,
        'CharcoalTypography',
      );
      expect(
        search.search('multiline truncated text ellipsis').first.component.name,
        'CharcoalTextEllipsis',
      );
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
