import 'dart:io';

import 'package:test/test.dart';

void main() {
  final libraryFiles = Directory('packages/charcoal_ui/lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  // charcoal_ui is built on Material, but only the files below touch Material widgets; everything
  // else composes Charcoal widgets and Flutter's widgets layer. Cupertino is never imported (the
  // guard in packages/charcoal_ui/test/source_guard_test.dart enforces that as well).
  const materialImporters = <String>[
    // The app shell: MaterialApp.router with the pack-built ThemeData.
    '/src/app/charcoal_app.dart',
    // A themed Material Slider.
    '/src/components/selection/slider.dart',
    // Material surface for dialogs (a Material ancestor for the inputs inside), the dialog route,
    // and selectable text in the code viewer.
    '/src/components/overlays/dialog.dart',
    '/src/components/overlays/modal.dart',
    '/src/components/overlays/code_block.dart',
    // The only fields file that wraps Material pickers.
    '/src/components/fields/date_time_field.dart',
  ];

  test('only the listed charcoal_ui files import Material; none import Cupertino', () async {
    for (final allowed in materialImporters) {
      expect(
        libraryFiles.any((file) => file.path.endsWith(allowed)),
        isTrue,
        reason: '$allowed no longer exists; remove it from materialImporters',
      );
    }
    final violations = <String>[];
    for (final file in libraryFiles) {
      final source = await file.readAsString();
      if (source.contains('package:flutter/cupertino.dart') ||
          source.contains('package:cupertino_ui/')) {
        violations.add('${file.path} imports Cupertino');
      }
      if (materialImporters.any(file.path.endsWith)) continue;
      if (source.contains('package:flutter/material.dart') ||
          source.contains('package:material_ui/')) {
        violations.add('${file.path} imports Material');
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('charcoal_ui source contains no colour constants', () async {
    final actual = <String, Set<String>>{};
    for (final file in libraryFiles.where((file) => !file.path.endsWith('.g.dart'))) {
      final source = await file.readAsString();
      final values = RegExp(
        r'\bColor\s*\(\s*(0x[0-9A-Fa-f]{8})',
      ).allMatches(source).map((match) => match.group(1)!).toSet();
      if (values.isNotEmpty) {
        actual[file.uri.pathSegments.last] = values;
      }
    }
    expect(actual, isEmpty);
  });

  test('charcoal_ui does not bundle runtime fonts', () async {
    final fontDirectory = Directory('packages/charcoal_ui/assets/fonts');
    final pubspec = await File('packages/charcoal_ui/pubspec.yaml').readAsString();

    expect(fontDirectory.existsSync(), isFalse);
    expect(pubspec, isNot(contains('fonts:')));
    expect(pubspec, isNot(contains('.ttf')));
  });

  test('agent tooling stays outside the charcoal_ui runtime dependency graph', () async {
    final uiPubspec = await File('packages/charcoal_ui/pubspec.yaml').readAsString();
    final catalogPubspec = await File('packages/charcoal_catalog/pubspec.yaml').readAsString();
    final cliPubspec = await File('packages/charcoal_cli/pubspec.yaml').readAsString();
    final mcpPubspec = await File('packages/charcoal_mcp/pubspec.yaml').readAsString();

    expect(uiPubspec, isNot(contains('charcoal_catalog:')));
    expect(uiPubspec, isNot(contains('charcoal_cli:')));
    expect(uiPubspec, isNot(contains('charcoal_mcp:')));
    expect(catalogPubspec, isNot(contains('flutter:')));
    expect(cliPubspec, isNot(contains('flutter:')));
    expect(mcpPubspec, isNot(contains('flutter:')));
    expect(cliPubspec, contains('charcoal_catalog:'));
    expect(mcpPubspec, contains('charcoal_catalog:'));
    expect(cliPubspec, isNot(contains('charcoal_ui:')));
    expect(mcpPubspec, isNot(contains('charcoal_ui:')));
  });
}
