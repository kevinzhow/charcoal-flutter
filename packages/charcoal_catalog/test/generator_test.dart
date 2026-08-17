import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/catalog_generator.dart';

void main() {
  test('checked-in catalog artifacts match source and examples', () {
    final root = findWorkspaceRoot(Directory.current);
    final generated = buildCatalog(root);

    expect(File(catalogJsonPath(root)).readAsStringSync(), generated.json);
    expect(File(catalogDartPath(root)).readAsStringSync(), generated.dartSource);
    expect(generated.catalog.coverage.curatedComponents, 8);
    expect(generated.catalog.coverage.componentsWithExamples, 8);
    expect(generated.catalog.coverage.publicTokens, 502);
  });
}
