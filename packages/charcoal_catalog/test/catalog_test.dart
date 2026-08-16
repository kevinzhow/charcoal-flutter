import 'dart:convert';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:test/test.dart';

void main() {
  group('generated catalog', () {
    test('covers every discovered public component with unique sorted names', () {
      final names = charcoalCatalog.components.map((component) => component.name).toList();
      final sortedNames = names.toList()..sort();

      expect(charcoalCatalog.schemaVersion, 1);
      expect(charcoalCatalog.coverage.publicComponents, names.length);
      expect(names, sortedNames);
      expect(names.toSet(), hasLength(names.length));
      expect(names, containsAll(<String>['CharcoalButton', 'CharcoalTextField', 'CharcoalDialog']));
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
  });
}
