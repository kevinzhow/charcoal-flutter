import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const bodyKey = ValueKey('body');
  const bottomKey = ValueKey('bottom');
  Future<void> mount(
    WidgetTester tester, {
    double keyboard = 0,
    bool fullBleed = false,
    bool extend = false,
    bool resize = true,
    bool bottom = true,
    bool bar = true,
  }) => tester.pumpWidget(
    CharcoalApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          padding: EdgeInsets.fromLTRB(12, 30, 16, keyboard == 0 ? 20 : 0),
          viewPadding: const EdgeInsets.fromLTRB(12, 30, 16, 20),
          viewInsets: EdgeInsets.only(bottom: keyboard),
        ),
        child: CharcoalScaffold(
          bodySafeArea: !fullBleed,
          extendBodyBehindNavigationBar: extend,
          resizeToAvoidBottomInset: resize,
          navigationBar: bar ? const CharcoalNavigationBar(title: Text('Editor')) : null,
          bottomBar: bottom
              ? const SizedBox(key: bottomKey, height: 48, width: double.infinity)
              : null,
          body: const SizedBox.expand(key: bodyKey),
        ),
      ),
    ),
  );

  testWidgets('page consumes safe insets once and reserves navigation and bottom controls', (
    tester,
  ) async {
    await mount(tester);
    expect(tester.getRect(find.byKey(bodyKey)), const Rect.fromLTRB(12, 86, 784, 532));
    expect(tester.getRect(find.byKey(bottomKey)).bottom, 580);
    expect(tester.getRect(find.byType(CharcoalNavigationBar)).top, 30);
  });

  testWidgets('keyboard moves the bottom controls and shrinks the body without double insets', (
    tester,
  ) async {
    await mount(tester, keyboard: 240);
    expect(tester.getRect(find.byKey(bodyKey)).bottom, 312);
    expect(tester.getRect(find.byKey(bottomKey)).bottom, 360);
    final context = tester.element(find.byKey(bodyKey));
    expect(MediaQuery.viewInsetsOf(context).bottom, 0);
    await mount(tester);
    expect(tester.getRect(find.byKey(bottomKey)).bottom, 580);
  });

  testWidgets('resize opt-out preserves keyboard information for custom layouts', (tester) async {
    await mount(tester, keyboard: 240, resize: false);
    expect(tester.getRect(find.byKey(bottomKey)).bottom, 600);
    expect(MediaQuery.viewInsetsOf(tester.element(find.byKey(bodyKey))).bottom, 240);
  });

  testWidgets('full bleed paints to all edges while controls stay safe', (tester) async {
    await mount(tester, fullBleed: true, extend: true);
    expect(tester.getRect(find.byKey(bodyKey)), const Rect.fromLTRB(0, 0, 800, 532));
    expect(tester.getRect(find.byType(CharcoalNavigationBar)).top, 30);
    expect(MediaQuery.paddingOf(tester.element(find.byKey(bodyKey))).top, 86);
  });

  testWidgets('plain page applies all safe edges to content', (tester) async {
    await mount(tester, bottom: false, bar: false);
    expect(tester.getRect(find.byKey(bodyKey)), const Rect.fromLTRB(12, 30, 784, 580));
  });

  testWidgets('system bar icon contrast follows page background', (tester) async {
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        CharcoalApp(
          themeMode: brightness == Brightness.dark
              ? CharcoalThemeMode.dark
              : CharcoalThemeMode.light,
          home: const CharcoalScaffold(body: SizedBox()),
        ),
      );
      final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
      );
      expect(
        region.value.statusBarIconBrightness,
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
      expect(region.value.statusBarColor, const Color(0x00000000));
    }
  });

  testWidgets('dialog remains scrollable above keyboard and system safe area', (tester) async {
    await tester.pumpWidget(
      const CharcoalApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(800, 600),
            padding: EdgeInsets.only(top: 30),
            viewInsets: EdgeInsets.only(bottom: 260),
          ),
          child: CharcoalDialog(child: SizedBox(height: 600, child: Text('Long form'))),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final viewport = tester.getRect(find.byType(SingleChildScrollView));
    expect(viewport.top, greaterThanOrEqualTo(30));
    expect(viewport.bottom, lessThanOrEqualTo(340));
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
