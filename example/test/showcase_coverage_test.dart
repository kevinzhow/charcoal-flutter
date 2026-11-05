import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The showcase keeps no component list of its own: the generated catalog is
/// the source of truth, and each public component must be exercised by a
/// showcase page (example/lib/showcase/pages) or by a compilable example the
/// catalog points at. A new component without either turns this test red.
void main() {
  final repoRoot = Directory.current.parent;
  final catalog = jsonDecode(
    File(
      '${repoRoot.path}/packages/charcoal_catalog/catalog/charcoal_catalog.json',
    ).readAsStringSync(),
  ) as Map<String, Object?>;
  final components = (catalog['components']! as List<Object?>)
      .cast<Map<String, Object?>>();

  final pageSources = <File>[
    for (final entity in Directory(
      '${Directory.current.path}/lib/showcase/pages',
    ).listSync(recursive: true))
      if (entity is File && entity.path.endsWith('.dart')) entity,
  ];
  final pageText = pageSources
      .map((file) => file.readAsStringSync())
      .join('\n');

  bool mentions(String source, String name) =>
      RegExp('\\b${RegExp.escape(name)}\\b').hasMatch(source);

  test('the catalog lists components', () {
    expect(components, isNotEmpty);
  });

  // Building blocks that became public when the Material API replaced the legacy one and are
  // exercised through their parents. TODO(3C): give the admin shell, progress ring and padding
  // helper their own showcase sections and shrink this list.
  const supporting = <String>{
    'CharcoalAdminShell',
    'CharcoalEditableText',
    'CharcoalFieldRing',
    'CharcoalOverlayAnchorTracker',
    'CharcoalPadding',
    'CharcoalProgressRing',
    'CharcoalSelectionBox',
    'CharcoalSelectionToolbar',
    'CharcoalTextDefaults',
  };

  test('every catalog component has a showcase page or example', () {
    final uncovered = <String>[];
    for (final component in components) {
      final name = component['name']! as String;
      if (supporting.contains(name)) continue;
      // The class itself or one of its entry points (e.g. showCharcoalToast).
      final names = <String>[
        name,
        for (final api
            in (component['apis']! as List<Object?>)
                .cast<Map<String, Object?>>())
          if (api['kind'] != 'supportingType') api['name']! as String,
      ];
      bool mentionsAny(String source) =>
          names.any((candidate) => mentions(source, candidate));
      final onPage = mentionsAny(pageText);
      final inExample = (component['examples']! as List<Object?>)
          .cast<Map<String, Object?>>()
          .any((example) {
            final file = File('${repoRoot.path}/${example['sourcePath']}');
            return file.existsSync() && mentions(file.readAsStringSync(), name);
          });
      if (!onPage && !inExample) uncovered.add(name);
    }
    expect(
      uncovered,
      isEmpty,
      reason:
          'Add the component to a page under example/lib/showcase/pages '
          '(and register it in that family\'s *_pages.dart) or to the example '
          'named in its catalog metadata.',
    );
  });

  test('every example source named by the catalog exists', () {
    for (final component in components) {
      for (final example
          in (component['examples']! as List<Object?>)
              .cast<Map<String, Object?>>()) {
        expect(
          File('${repoRoot.path}/${example['sourcePath']}').existsSync(),
          isTrue,
          reason: '${component['name']}: ${example['sourcePath']}',
        );
      }
    }
  });
}
