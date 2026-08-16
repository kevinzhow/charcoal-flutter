import 'dart:ui' show PointerDeviceKind;

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
