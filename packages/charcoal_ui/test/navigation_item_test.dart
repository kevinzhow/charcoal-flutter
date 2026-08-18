import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('centers content and preserves geometry across state layers', (
    tester,
  ) async {
    const leadingKey = ValueKey<String>('navigation-leading');
    const labelKey = ValueKey<String>('navigation-label');
    const trailingKey = ValueKey<String>('navigation-trailing');
    final states = WidgetStatesController();

    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 240,
          child: CharcoalNavigationItem(
            leading: const SizedBox.square(
              key: leadingKey,
              dimension: 24,
            ),
            onPressed: () {},
            statesController: states,
            trailing: const SizedBox.square(
              key: trailingKey,
              dimension: 16,
            ),
            child: const Text('Typography', key: labelKey),
          ),
        ),
      ),
    );

    final before = _navigationGeometry(
      tester,
      leadingKey: leadingKey,
      labelKey: labelKey,
      trailingKey: trailingKey,
    );
    _expectNavigationContentCentered(before);

    states.update(WidgetState.hovered, true);
    await tester.pumpAndSettle();
    expect(
      _navigationGeometry(
        tester,
        leadingKey: leadingKey,
        labelKey: labelKey,
        trailingKey: trailingKey,
      ),
      before,
    );

    states.update(WidgetState.pressed, true);
    await tester.pumpAndSettle();
    expect(
      _navigationGeometry(
        tester,
        leadingKey: leadingKey,
        labelKey: labelKey,
        trailingKey: trailingKey,
      ),
      before,
    );
  });

  testWidgets('selection stays stable beneath hover and press feedback', (tester) async {
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
    final persistent = tester.widget<DecoratedBox>(
      find
          .descendant(
            of: find.byType(CharcoalNavigationItem),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final interaction = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(CharcoalNavigationItem),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(
      (persistent.decoration as BoxDecoration).color,
      theme.colors.containerSecondaryDefault,
    );
    expect(
      (interaction.decoration! as BoxDecoration).color,
      theme.colors.containerSecondaryPressA,
    );
  });

  testWidgets('uses semantic hover and press token families', (tester) async {
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

({
  Rect itemRect,
  double labelBaseline,
  Offset labelCenter,
  Offset leadingCenter,
  Offset trailingCenter,
})
_navigationGeometry(
  WidgetTester tester, {
  required Key leadingKey,
  required Key labelKey,
  required Key trailingKey,
}) {
  final label = find.byKey(labelKey);
  final labelBox = tester.renderObject<RenderBox>(label);
  return (
    itemRect: tester.getRect(find.byType(CharcoalNavigationItem)),
    labelBaseline:
        tester.getTopLeft(label).dy +
        labelBox.getDryBaseline(labelBox.constraints, TextBaseline.alphabetic)!,
    labelCenter: tester.getCenter(label),
    leadingCenter: tester.getCenter(find.byKey(leadingKey)),
    trailingCenter: tester.getCenter(find.byKey(trailingKey)),
  );
}

void _expectNavigationContentCentered(
  ({
    Rect itemRect,
    double labelBaseline,
    Offset labelCenter,
    Offset leadingCenter,
    Offset trailingCenter,
  })
  geometry,
) {
  for (final center in <Offset>[
    geometry.leadingCenter,
    geometry.labelCenter,
    geometry.trailingCenter,
  ]) {
    expect(center.dy, moreOrLessEquals(geometry.itemRect.center.dy));
  }
}
