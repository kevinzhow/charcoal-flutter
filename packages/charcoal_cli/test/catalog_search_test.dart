import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:charcoal_cli/charcoal_cli.dart';
import 'package:test/test.dart';

void main() {
  final search = CharcoalCatalogSearch(charcoalCatalog);

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
}
