import 'package:charcoal_ui/next.dart';
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
          navigationBar: bar ? const _TestBar() : null,
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
    expect(tester.getRect(find.byType(_TestBar)).top, 30);
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
    expect(tester.getRect(find.byType(_TestBar)).top, 30);
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
      await tester.pumpAndSettle();
      final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
      );
      expect(
        region.value.statusBarIconBrightness,
        brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
      expect(region.value.statusBarColor, CharcoalColorRoles.transparent);
    }
  });
}

/// A navigation bar stand-in with a context-dependent height (the real bar is ported in 2D).
final class _TestBar extends StatelessWidget
    implements PreferredSizeWidget, CharcoalContextualHeight {
  const _TestBar();

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  double heightFor(BuildContext context) => 56;

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
