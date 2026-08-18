import 'dart:ui' show SemanticsFlag, Tristate;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('button exposes selection only when configured as a toggle', (
    tester,
  ) async {
    const actionKey = ValueKey<String>('button-action');
    const toggleKey = ValueKey<String>('button-toggle');
    await tester.pumpWidget(
      charcoalTestApp(
        Column(
          children: <Widget>[
            CharcoalButton(
              key: actionKey,
              onPressed: () {},
              child: const Text('Continue'),
            ),
            CharcoalButton(
              key: toggleKey,
              onPressed: () {},
              selected: false,
              child: const Text('Follow'),
            ),
          ],
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byKey(actionKey)).flagsCollection.isSelected,
      Tristate.none,
    );
    expect(
      tester.getSemantics(find.byKey(toggleKey)).flagsCollection.isSelected,
      Tristate.isFalse,
    );
  });

  testWidgets('link button is a keyboard-accessible text action', (
    tester,
  ) async {
    var activations = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalLinkButton(
          focusNode: focusNode,
          onPressed: () => activations++,
          child: const Text('Clear filters'),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);

    expect(activations, 1);
    expect(
      tester.getSemantics(find.byType(CharcoalClickable)),
      isSemantics(
        label: 'Clear filters',
        isButton: true,
        isFocused: true,
        isFocusable: true,
        hasFocusAction: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).constraints!.minHeight,
      40,
    );
    expect(
      tester.getSize(find.byType(CharcoalLinkButton)).width,
      lessThan(800),
    );
  });

  testWidgets('invokes onPressed from a pointer tap', (tester) async {
    var pressCount = 0;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () => pressCount += 1,
          child: const Text('Submit'),
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(pressCount, 1);
  });

  testWidgets('does not invoke a disabled button', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(const CharcoalButton(onPressed: null, child: Text('Disabled'))),
    );

    await tester.tap(find.text('Disabled'));
    await tester.pump();

    expect(
      tester.getSemantics(find.byType(CharcoalButton)),
      matchesSemantics(isButton: true, hasEnabledState: true, isEnabled: false),
    );
  });

  testWidgets('semantic color overrides propagate into component surfaces', (
    tester,
  ) async {
    const replacement = Color(0xFF9C27B0);
    final colors = CharcoalGeneratedColorTokens.light.copyWith(
      containerPrimaryDefault: replacement,
    );
    final theme = CharcoalThemeData.light(colors: colors);

    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          variant: CharcoalButtonVariant.primary,
          child: const Text('Primary'),
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, replacement);
  });

  testWidgets('semantic dimension overrides resolve into component layout', (
    tester,
  ) async {
    final base = CharcoalGeneratedDimensionTokens.light;
    final dimensions = base.copyWith(
      space: base.space.copyWith(component30: 20, targetS: 36),
    );
    final theme = CharcoalThemeData.light(dimensions: dimensions);

    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          size: CharcoalButtonSize.small,
          child: const Text('Small'),
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(container.constraints!.minHeight, 36);
    expect(
      container.padding,
      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  });

  testWidgets('resolves pressed colors from WidgetStatesController', (tester) async {
    final states = WidgetStatesController();
    addTearDown(states.dispose);
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          statesController: states,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Primary'),
        ),
        theme: theme,
      ),
    );

    states.update(WidgetState.pressed, true);
    await tester.pump();

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.containerPrimaryPress);
  });

  testWidgets('supports the iOS custom primary color', (tester) async {
    const custom = Color(0xFF8A2BE2);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          primaryColor: custom,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Custom'),
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect((container.decoration! as BoxDecoration).color, custom);
  });

  testWidgets('grows vertically with accessibility text scaling', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: CharcoalButton(
            onPressed: _noop,
            child: Text('Scaled action'),
          ),
        ),
        theme: theme,
      ),
    );

    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      greaterThan(40),
    );
  });

  testWidgets('switching button keeps the larger layout and selects a child', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalSwitchingButton(
          isOn: false,
          offButton: SizedBox(width: 80, height: 32, child: Text('Off')),
          onButton: SizedBox(width: 120, height: 40, child: Text('On')),
        ),
      ),
    );

    expect(tester.getSize(find.byType(IndexedStack)), const Size(120, 40));
    final stack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(stack.index, 1);
  });

  testWidgets('switching button exposes and focuses only its visible action', (
    tester,
  ) async {
    var isOn = false;
    late StateSetter setState;
    final onFocusNode = FocusNode();
    final offFocusNode = FocusNode();
    addTearDown(onFocusNode.dispose);
    addTearDown(offFocusNode.dispose);

    await tester.pumpWidget(
      charcoalTestApp(
        StatefulBuilder(
          builder: (context, update) {
            setState = update;
            return CharcoalSwitchingButton(
              isOn: isOn,
              offButton: CharcoalButton(
                focusNode: offFocusNode,
                onPressed: () {},
                child: const Text('Enable notifications'),
              ),
              onButton: CharcoalButton(
                focusNode: onFocusNode,
                onPressed: () {},
                child: const Text('Disable notifications'),
              ),
            );
          },
        ),
      ),
    );

    onFocusNode.requestFocus();
    await tester.pump();
    expect(onFocusNode.hasFocus, isFalse);
    expect(find.bySemanticsLabel('Enable notifications'), findsOneWidget);
    expect(find.bySemanticsLabel('Disable notifications'), findsNothing);
    expect(
      find.semantics.byFlag(SemanticsFlag.hasToggledState),
      findsNothing,
    );

    offFocusNode.requestFocus();
    await tester.pump();
    expect(offFocusNode.hasPrimaryFocus, isTrue);

    setState(() => isOn = true);
    await tester.pump();
    expect(offFocusNode.hasFocus, isFalse);
    expect(find.bySemanticsLabel('Enable notifications'), findsNothing);
    expect(find.bySemanticsLabel('Disable notifications'), findsOneWidget);

    offFocusNode.requestFocus();
    await tester.pump();
    expect(offFocusNode.hasFocus, isFalse);
    onFocusNode.requestFocus();
    await tester.pump();
    expect(onFocusNode.hasPrimaryFocus, isTrue);
  });
}

void _noop() {}
