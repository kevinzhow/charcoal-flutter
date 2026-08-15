import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a generated icon through IconTheme', (tester) async {
    const color = Color(0xFF336699);
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: IconTheme(
          data: IconThemeData(color: color, size: 20),
          child: CharcoalIcon(CharcoalIcons.add),
        ),
      ),
    );
    await tester.pump();

    final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(picture.width, 20);
    expect(picture.height, 20);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adds image semantics only when requested', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: CharcoalIcon(CharcoalIcons.check, semanticLabel: 'Selected'),
      ),
    );

    expect(find.bySemanticsLabel('Selected'), findsOneWidget);
  });

  test('catalog exposes size, style, and upstream name', () {
    expect(CharcoalIcons.add.name, 'add');
    expect(CharcoalIcons.add.nativeSize, 24);
    expect(CharcoalIcons.add.style, CharcoalIconStyle.regular);
    expect(CharcoalSolidIcons.check.style, CharcoalIconStyle.solid);
    expect(CharcoalIcons16.chevronLeft.nativeSize, 16);
  });

  testWidgets('bundles every generated V2 asset', (tester) async {
    final catalog = <CharcoalIconData>[
      ...CharcoalIcons.values,
      ...CharcoalSolidIcons.values,
      ...CharcoalColorIcons.values,
      ...CharcoalIcons20.values,
      ...CharcoalSolidIcons20.values,
      ...CharcoalIcons16.values,
      ...CharcoalSolidIcons16.values,
    ];

    expect(catalog, isNotEmpty);
    expect(
      catalog.map((icon) => icon.assetName).toSet(),
      hasLength(catalog.length),
    );
    for (final icon in catalog) {
      final asset = await rootBundle.load(
        'packages/charcoal_icons/${icon.assetName}',
      );
      expect(
        asset.lengthInBytes,
        greaterThan(0),
        reason: '${icon.assetName} must be present in the Flutter asset bundle',
      );
    }
  });
}
