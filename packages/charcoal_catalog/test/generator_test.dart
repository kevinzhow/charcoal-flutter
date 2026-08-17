import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/catalog_generator.dart';

void main() {
  test('checked-in catalog artifacts match source and examples', () {
    final root = findWorkspaceRoot(Directory.current);
    final generated = buildCatalog(root);

    expect(File(catalogJsonPath(root)).readAsStringSync(), generated.json);
    expect(File(catalogDartPath(root)).readAsStringSync(), generated.dartSource);
    expect(generated.catalog.coverage.curatedComponents, 9);
    expect(generated.catalog.coverage.componentsWithExamples, 9);
    expect(generated.catalog.coverage.curatedPatterns, 6);
    expect(generated.catalog.coverage.publicTokens, 502);

    final tabBar = generated.catalog.componentNamed('CharcoalTabBar')!;
    expect(
      tabBar.feedbackResponsibilities.join(' '),
      allOf(contains('atomically'), contains('transient')),
    );
    final appShell = generated.catalog.patternNamed('adaptive-app-shell')!;
    expect(
      appShell.composition.join(' '),
      allOf(contains('first painted frame'), contains('one state owner')),
    );
  });
}
