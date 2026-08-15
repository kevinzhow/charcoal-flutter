import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('selection stays stable across hover and press states', (tester) async {
    final states = WidgetStatesController(<WidgetState>{
      WidgetState.hovered,
      WidgetState.pressed,
    });

    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalNavigationItem(
          onPressed: () {},
          selected: true,
          statesController: states,
          child: const Text('Typography'),
        ),
      ),
    );

    final context = tester.element(find.byType(CharcoalNavigationItem));
    final theme = CharcoalTheme.of(context);
    final animated = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = animated.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.containerSecondaryDefault);
  });

  testWidgets('uses generated hover and press token families', (tester) async {
    final states = WidgetStatesController();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalNavigationItem(
          onPressed: () {},
          statesController: states,
          child: const Text('Colors'),
        ),
      ),
    );
    final context = tester.element(find.byType(CharcoalNavigationItem));
    final theme = CharcoalTheme.of(context);

    states.update(WidgetState.hovered, true);
    await tester.pumpAndSettle();
    var decoration = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!;
    expect((decoration as BoxDecoration).color, theme.colors.containerSecondaryHoverA);

    states.update(WidgetState.pressed, true);
    await tester.pumpAndSettle();
    decoration = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!;
    expect((decoration as BoxDecoration).color, theme.colors.containerSecondaryPressA);
  });
}
