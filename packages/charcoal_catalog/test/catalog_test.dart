import 'dart:convert';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:test/test.dart';

void main() {
  group('generated catalog', () {
    test('covers every discovered public component with unique sorted names', () {
      final names = charcoalCatalog.components.map((component) => component.name).toList();
      final sortedNames = names.toList()..sort();

      expect(charcoalCatalog.schemaVersion, 3);
      expect(charcoalCatalog.coverage.publicComponents, names.length);
      expect(names, sortedNames);
      expect(names.toSet(), hasLength(names.length));
      expect(names, containsAll(<String>['CharcoalButton', 'CharcoalTextField', 'CharcoalDialog']));
    });

    test('exposes page-design rules and reviewed composition patterns', () {
      expect(charcoalCatalog.designRules, hasLength(7));
      expect(
        charcoalCatalog.designRules.map((rule) => rule.order),
        orderedEquals(<int>[1, 2, 3, 4, 5, 6, 7]),
      );
      expect(charcoalCatalog.coverage.curatedPatterns, charcoalCatalog.patterns.length);
      final checklist = charcoalCatalog.patternNamed('daily-checklist')!;
      expect(checklist.components, contains('CharcoalCheckbox'));
      expect(checklist.interactionStates, contains('complete'));
      expect(checklist.feedback, isNotEmpty);
    });

    test('exposes curated guidance and source-derived API data', () {
      final button = charcoalCatalog.componentNamed('charcoalbutton')!;
      final constructor = button.apis.firstWhere((api) => api.name == 'CharcoalButton');
      final fullWidth = constructor.parameters.firstWhere(
        (parameter) => parameter.name == 'fullWidth',
      );

      expect(button.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(button.useWhen, isNotEmpty);
      expect(button.accessibility, isNotEmpty);
      expect(button.interactionStates, contains('disabled'));
      expect(button.feedbackResponsibilities, isNotEmpty);
      expect(button.examples.single.source, contains('CharcoalButtonVariant.primary'));
      expect(fullWidth.type, 'bool');
      expect(fullWidth.defaultValue, 'false');
    });

    test('includes companion functions and enums', () {
      final dialog = charcoalCatalog.componentNamed('CharcoalDialog')!;
      final toast = charcoalCatalog.componentNamed('CharcoalToast')!;

      expect(dialog.apis.map((api) => api.name), contains('showCharcoalModal'));
      expect(dialog.apis.map((api) => api.name), contains('CharcoalModalStyle'));
      expect(toast.apis.map((api) => api.name), contains('showCharcoalToast'));
      expect(
        toast.apis.firstWhere((api) => api.name == 'CharcoalToastVariant').enumValues,
        <String>['success', 'error'],
      );
    });

    test('round-trips through its versioned JSON model', () {
      final decoded = jsonDecode(jsonEncode(charcoalCatalog.toJson())) as Map<String, Object?>;
      final roundTripped = CharcoalCatalog.fromJson(decoded);

      expect(roundTripped.libraryVersion, charcoalCatalog.libraryVersion);
      expect(roundTripped.components.length, charcoalCatalog.components.length);
      expect(roundTripped.componentNamed('button')?.name, isNull);
      expect(roundTripped.componentNamed('CharcoalButton')?.examples, isNotEmpty);
    });

    test('indexes public tokens with semantic ownership guidance', () {
      final search = CharcoalCatalogSearch(charcoalCatalog);
      final spacing = search.exactToken('theme.dimensions.space.component20')!;
      final semanticResults = search.searchTokens(
        'primary container',
        kind: CharcoalTokenKind.color,
      );
      final primitiveResults = search.searchTokens(
        'blue 50',
        kind: CharcoalTokenKind.color,
        tier: CharcoalTokenTier.primitive,
      );

      expect(charcoalCatalog.coverage.publicTokens, charcoalCatalog.tokens.length);
      expect(charcoalCatalog.coverage.semanticTokens, greaterThan(100));
      expect(spacing.path, 'space.component/20');
      expect(spacing.lightValue, '8px');
      expect(spacing.guidance, contains('internal gaps'));
      expect(semanticResults, isNotEmpty);
      expect(
        semanticResults.every((result) => result.token.tier == CharcoalTokenTier.semantic),
        isTrue,
      );
      expect(primitiveResults, isNotEmpty);
    });
  });
}
