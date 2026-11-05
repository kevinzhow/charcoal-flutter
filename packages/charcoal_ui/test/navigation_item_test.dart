import 'dart:ui' show Tristate;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/gestures.dart' show kPressTimeout;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

void main() {
  testWidgets('exposes selected state for every controlled destination', (
    tester,
  ) async {
    await pumpLoose(
      tester,
      Column(
        children: <Widget>[
          CharcoalNavigationItem(
            selected: true,
            onPressed: () {},
            child: const Text('Home'),
          ),
          CharcoalNavigationItem(
            onPressed: () {},
            child: const Text('Discover'),
          ),
        ],
      ),
    );

    expect(
      tester.getSemantics(
        find.widgetWithText(CharcoalNavigationItem, 'Home'),
      ),
      matchesSemantics(
        label: 'Home',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        isFocusable: true,
        hasSelectedState: true,
        isSelected: true,
        hasFocusAction: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(
        find.widgetWithText(CharcoalNavigationItem, 'Discover'),
      ),
      matchesSemantics(
        label: 'Discover',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        isFocusable: true,
        hasSelectedState: true,
        isSelected: false,
        hasFocusAction: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('activates a focused destination from the keyboard', (
    tester,
  ) async {
    var activations = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpLoose(
      tester,
      CharcoalNavigationItem(
        focusNode: focusNode,
        onPressed: () => activations++,
        child: const Text('Discover'),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);

    expect(focusNode.hasFocus, isTrue);
    expect(activations, 1);
  });

  testWidgets('centers content and preserves geometry across state layers', (
    tester,
  ) async {
    const leadingKey = ValueKey<String>('navigation-leading');
    const labelKey = ValueKey<String>('navigation-label');
    const trailingKey = ValueKey<String>('navigation-trailing');
    final states = WidgetStatesController();

    await pumpLoose(
      tester,
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

    await pumpLoose(
      tester,
      CharcoalNavigationItem(
        onPressed: () {},
        selected: true,
        statesController: states,
        child: const Text('Typography'),
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
      theme.colors.surfaceSecondary,
    );
    expect(
      (interaction.decoration! as BoxDecoration).color,
      theme.colors.fillSecondaryPress,
    );
  });

  testWidgets('uses semantic hover and press token families', (tester) async {
    final states = WidgetStatesController();
    await pumpLoose(
      tester,
      CharcoalNavigationItem(
        onPressed: () {},
        statesController: states,
        child: const Text('Colors'),
      ),
    );
    final context = tester.element(find.byType(CharcoalNavigationItem));
    final theme = CharcoalTheme.of(context);

    states.update(WidgetState.hovered, true);
    await tester.pumpAndSettle();
    var decoration = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!;
    expect((decoration as BoxDecoration).color, theme.colors.fillSecondaryHover);

    states.update(WidgetState.pressed, true);
    await tester.pumpAndSettle();
    decoration = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!;
    expect((decoration as BoxDecoration).color, theme.colors.fillSecondaryPress);
  });
  testWidgets('selection moves atomically on the first frame after a tap', (tester) async {
    const homeKey = ValueKey<String>('nav-home');
    const searchKey = ValueKey<String>('nav-search');
    await pumpLoose(tester, const _NavigationHarness(homeKey: homeKey, searchKey: searchKey));
    final theme = CharcoalTheme.of(tester.element(find.byKey(homeKey)));

    Color persistent(Key key) =>
        ((tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(of: find.byKey(key), matching: find.byType(DecoratedBox))
                          .first,
                    )
                    .decoration)
                as BoxDecoration)
            .color!;
    final rectsBefore = rectsOf(tester, [find.byKey(homeKey), find.byKey(searchKey)]);
    expect(persistent(homeKey), theme.colors.surfaceSecondary);
    expect(persistent(searchKey), theme.colors.restOverlay);

    final gesture = await tester.startGesture(tester.getCenter(find.byKey(searchKey)));
    await tester.pump(kPressTimeout);
    // A held press never reads as a second selected row.
    expect(persistent(homeKey), theme.colors.surfaceSecondary);
    expect(persistent(searchKey), theme.colors.restOverlay);

    await gesture.up();
    await tester.pump();
    // The very next frame: exactly one persistent selection, none left behind, nothing moved.
    expect(persistent(homeKey), theme.colors.restOverlay);
    expect(persistent(searchKey), theme.colors.surfaceSecondary);
    expect(rectsOf(tester, [find.byKey(homeKey), find.byKey(searchKey)]), rectsBefore);
  });

  testWidgets('a cancelled press leaves the selection untouched', (tester) async {
    const homeKey = ValueKey<String>('nav-home');
    const searchKey = ValueKey<String>('nav-search');
    await pumpLoose(tester, const _NavigationHarness(homeKey: homeKey, searchKey: searchKey));
    final theme = CharcoalTheme.of(tester.element(find.byKey(homeKey)));
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(searchKey)));
    await tester.pump(kPressTimeout);
    await gesture.cancel();
    await tester.pumpAndSettle();
    final home = tester.widget<DecoratedBox>(
      find.descendant(of: find.byKey(homeKey), matching: find.byType(DecoratedBox)).first,
    );
    expect((home.decoration as BoxDecoration).color, theme.colors.surfaceSecondary);
    expect(find.byType(_NavigationHarness), findsOneWidget);
    expect(tester.state<_NavigationHarnessState>(find.byType(_NavigationHarness)).current, 'home');
  });

  testWidgets('the sidebar variant shows the current destination in the information tone', (
    tester,
  ) async {
    await pumpLoose(
      tester,
      SizedBox(
        width: 240,
        child: CharcoalNavigationItem(
          variant: CharcoalNavigationItemVariant.sidebar,
          selected: true,
          leading: const SizedBox.square(dimension: 24),
          onPressed: () {},
          child: const Text('Home'),
        ),
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalNavigationItem)));
    final persistent = tester.widget<DecoratedBox>(
      find
          .descendant(of: find.byType(CharcoalNavigationItem), matching: find.byType(DecoratedBox))
          .first,
    );
    final decoration = persistent.decoration as BoxDecoration;
    expect(decoration.color, theme.tone(CharcoalTone.info).surface);
    expect(decoration.borderRadius, BorderRadius.circular(theme.radius.sm));
    expect(tester.getSize(find.byType(CharcoalNavigationItem)).height, theme.sizes.controlMd);
  });

  testWidgets('a disabled item fades and reports itself disabled', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpLoose(
      tester,
      const CharcoalNavigationItem(onPressed: null, child: Text('Disabled')),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalNavigationItem)));
    expect(targetOpacity(tester, find.text('Disabled')), theme.metrics.clickable.disabledOpacity);
    expect(
      tester.getSemantics(find.byType(CharcoalNavigationItem)).flagsCollection.isEnabled,
      Tristate.isFalse,
    );
    handle.dispose();
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

final class _NavigationHarness extends StatefulWidget {
  const _NavigationHarness({required this.homeKey, required this.searchKey});

  final Key homeKey;
  final Key searchKey;

  @override
  State<_NavigationHarness> createState() => _NavigationHarnessState();
}

final class _NavigationHarnessState extends State<_NavigationHarness> {
  String current = 'home';

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 240,
    child: Column(
      children: <Widget>[
        CharcoalNavigationItem(
          key: widget.homeKey,
          selected: current == 'home',
          onPressed: () => setState(() => current = 'home'),
          child: const Text('Home'),
        ),
        CharcoalNavigationItem(
          key: widget.searchKey,
          selected: current == 'search',
          onPressed: () => setState(() => current = 'search'),
          child: const Text('Search'),
        ),
      ],
    ),
  );
}
