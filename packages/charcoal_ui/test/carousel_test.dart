import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('navigation buttons advance a medium carousel', (tester) async {
    int? page;
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 480,
          height: 180,
          child: CharcoalCarousel(
            onPageChanged: (value) => page = value,
            children: const <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
              Center(child: Text('Third slide')),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CharcoalIconButton), findsNWidgets(2));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(CharcoalCarousel)));
    await tester.pump(const Duration(milliseconds: 401));

    final navigationOpacity = tester
        .widgetList<AnimatedOpacity>(
          find.byWidgetPredicate(
            (widget) =>
                widget is AnimatedOpacity && widget.duration == const Duration(milliseconds: 400),
          ),
        )
        .map((widget) => widget.opacity)
        .toList();
    expect(navigationOpacity, <double>[0, 1]);
    await tester.tap(find.byType(CharcoalIconButton).last);
    await tester.pumpAndSettle();
    expect(page, 1);
  });

  testWidgets('small carousel indicators select an exact page', (tester) async {
    int? page;
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          height: 220,
          child: CharcoalCarousel(
            onPageChanged: (value) => page = value,
            size: CharcoalCarouselSize.small,
            children: const <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
              Center(child: Text('Third slide')),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CharcoalClickable), findsNWidgets(3));
    await tester.tap(find.byType(CharcoalClickable).last);
    await tester.pumpAndSettle();
    expect(page, 2);
  });

  testWidgets('touch swipes report the accepted page', (tester) async {
    int? page;
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          height: 220,
          child: CharcoalCarousel(
            onPageChanged: (value) => page = value,
            size: CharcoalCarouselSize.small,
            children: const <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
              Center(child: Text('Third slide')),
            ],
          ),
        ),
      ),
    );

    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();

    expect(page, 1);
  });

  testWidgets('an external controller owns the first painted page', (
    tester,
  ) async {
    final controller = PageController(initialPage: 2);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          height: 220,
          child: CharcoalCarousel(
            controller: controller,
            size: CharcoalCarouselSize.small,
            children: const <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
              Center(child: Text('Third slide')),
            ],
          ),
        ),
      ),
    );

    final indicators = tester
        .widgetList<CharcoalClickable>(find.byType(CharcoalClickable))
        .toList();
    expect(indicators.map((indicator) => indicator.selected), <bool?>[
      false,
      false,
      true,
    ]);
  });

  testWidgets('End key moves a focused carousel to its final page', (tester) async {
    int? page;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          height: 220,
          child: CharcoalCarousel(
            focusNode: focusNode,
            onPageChanged: (value) => page = value,
            size: CharcoalCarouselSize.small,
            children: const <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
              Center(child: Text('Third slide')),
            ],
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pumpAndSettle();
    expect(page, 2);
  });

  testWidgets('RTL chevrons and arrow keys follow reading direction', (
    tester,
  ) async {
    int? page;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 480,
            height: 180,
            child: CharcoalCarousel(
              focusNode: focusNode,
              initialPage: 1,
              onPageChanged: (value) => page = value,
              children: const <Widget>[
                Center(child: Text('First slide')),
                Center(child: Text('Second slide')),
                Center(child: Text('Third slide')),
              ],
            ),
          ),
        ),
      ),
    );

    final icons = tester.widgetList<CharcoalIcon>(find.byType(CharcoalIcon)).toList();
    expect(icons.first.icon, CharcoalIcons16.chevronRight);
    expect(icons.last.icon, CharcoalIcons16.chevronLeft);

    focusNode.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(page, 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(page, 1);
  });

  testWidgets('keyboard focus keeps revealed navigation visible', (
    tester,
  ) async {
    int? page;
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 480,
          height: 180,
          child: CharcoalCarousel(
            onPageChanged: (value) => page = value,
            children: const <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
              Center(child: Text('Third slide')),
            ],
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Next'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Next'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Next'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(page, 1);
  });

  testWidgets('many compact indicators remain horizontally usable', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 200,
          height: 180,
          child: CharcoalCarousel(
            size: CharcoalCarouselSize.small,
            children: <Widget>[
              for (var index = 0; index < 24; index++) Center(child: Text('Slide ${index + 1}')),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(CharcoalClickable), findsNWidgets(24));
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses token-driven indicator colors and root semantics', (tester) async {
    final theme = CharcoalThemeData.dark();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          height: 220,
          child: CharcoalCarousel(
            semanticLabel: 'Featured works',
            size: CharcoalCarouselSize.small,
            children: <Widget>[
              Center(child: Text('First slide')),
              Center(child: Text('Second slide')),
            ],
          ),
        ),
        theme: theme,
      ),
    );

    final semantics = tester.getSemantics(find.byType(CharcoalCarousel)).getSemanticsData();
    expect(semantics.label, 'Featured works');
    final indicators = find.descendant(
      of: find.byType(CharcoalClickable),
      matching: find.byType(AnimatedContainer),
    );
    final first = tester.widget<AnimatedContainer>(indicators.first);
    expect((first.decoration! as BoxDecoration).color, theme.colors.textDefault);
  });
}
