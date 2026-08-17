import 'dart:io';

import 'package:test/test.dart';

void main() {
  final libraryFiles = Directory('packages/charcoal_ui/lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  test('charcoal_ui has no Material or Cupertino imports', () async {
    final violations = <String>[];
    for (final file in libraryFiles) {
      final source = await file.readAsString();
      if (source.contains("package:flutter/material.dart") ||
          source.contains("package:flutter/cupertino.dart") ||
          source.contains("package:material_ui/") ||
          source.contains("package:cupertino_ui/")) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('raw component colors are limited to audited source constants', () async {
    const allowed = <String, Set<String>>{
      'checkbox.dart': <String>{'0x00000000', '0xFFFFFFFF'},
      // Authored fill from Charcoal iOS 16/Info.pdf.
      'hint_text.dart': <String>{'0xFF858585'},
      'loading_spinner.dart': <String>{'0x1A000000'},
      'modal.dart': <String>{'0x99000000'},
      'tag_item.dart': <String>{'0xFF7ACCB1'},
    };
    final actual = <String, Set<String>>{};
    for (final file in libraryFiles.where(
      (file) => file.path.contains('/src/components/') && !file.path.endsWith('.g.dart'),
    )) {
      final source = await file.readAsString();
      final values = RegExp(
        r'\bColor\s*\(\s*(0x[0-9A-Fa-f]{8})',
      ).allMatches(source).map((match) => match.group(1)!).toSet();
      if (values.isNotEmpty) {
        actual[file.uri.pathSegments.last] = values;
      }
    }
    expect(actual, allowed);
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
