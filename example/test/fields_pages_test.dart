import 'package:charcoal_ui/next.dart'
    show CharcoalDropdown, CharcoalTextArea, CharcoalTextField;
import 'package:charcoal_ui_showcase/showcase/app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The fields, typography and roles pages mount next.dart components inside the legacy shell
/// through the theme island; they must build without errors at phone and desktop widths.
void main() {
  for (final route in <String, String>{
    '/fields': 'Fields and menus',
    '/typography': 'Typography catalog',
    '/roles': 'Theme roles',
  }.entries) {
    for (final width in <double>[390, 1180]) {
      testWidgets('${route.key} builds at width $width', (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
        tester.platformDispatcher.defaultRouteNameTestValue = route.key;
        await tester.pumpWidget(const CharcoalShowcaseApp());
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text(route.value), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('the fields page fields accept input and the dropdown opens', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1180, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
    tester.platformDispatcher.defaultRouteNameTestValue = '/fields';
    await tester.pumpWidget(const CharcoalShowcaseApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(CharcoalTextField), findsWidgets);
    expect(find.byType(CharcoalTextArea), findsWidgets);
    expect(find.byType(CharcoalDropdown<String>), findsWidgets);

    final field = find.descendant(
      of: find.byKey(const ValueKey<String>('display-name-field')),
      matching: find.byType(EditableText),
    );
    await tester.ensureVisible(field);
    await tester.enterText(field, 'pixiv');
    await tester.pump();
    expect(find.text('5/20'), findsOneWidget);

    final dropdown = find.byKey(const ValueKey<String>('work-type-dropdown'));
    await tester.ensureVisible(dropdown);
    await tester.tap(
      find.descendant(of: dropdown, matching: find.text('Illustration')),
    );
    await tester.pump();
    expect(find.text('Multiple pages'), findsOneWidget);
    await tester.tap(find.text('Novel'));
    await tester.pump();
    expect(find.text('Multiple pages'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
