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

  test('hand-written component sources contain no raw color literals', () async {
    final violations = <String>[];
    for (final file in libraryFiles.where(
      (file) => file.path.contains('/src/components/') && !file.path.endsWith('.g.dart'),
    )) {
      final source = await file.readAsString();
      if (RegExp(r'\bColor\s*\(\s*0x').hasMatch(source)) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
