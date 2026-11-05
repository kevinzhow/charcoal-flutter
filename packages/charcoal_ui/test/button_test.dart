import 'dart:ui' show PointerDeviceKind, SemanticsFlag, Tristate;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

BoxDecoration _decoration(WidgetTester tester, Finder within) =>
    tester
            .widget<AnimatedContainer>(
              find.descendant(of: within, matching: find.byType(AnimatedContainer)).first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  const key = ValueKey<String>('button');

  testWidgets('exposes selection only when configured as a toggle', (tester) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalButton(key: key, onPressed: () {}, child: const Text('Continue')),
          CharcoalButton(
            key: const ValueKey('toggle'),
            onPressed: () {},
            selected: false,
            child: const Text('Follow'),
          ),
        ],
      ),
    );
    expect(tester.getSemantics(find.byKey(key)).flagsCollection.isSelected, Tristate.none);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('toggle'))).flagsCollection.isSelected,
      Tristate.isFalse,
    );
  });

  testWidgets('taps invoke onPressed; a disabled button does nothing and says so', (tester) async {
    var presses = 0;
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalButton(onPressed: () => presses++, child: const Text('Submit')),
          const CharcoalButton(key: key, onPressed: null, child: Text('Disabled')),
        ],
      ),
    );
    await tester.tap(find.text('Submit'));
    await tester.tap(find.text('Disabled'), warnIfMissed: false);
    await tester.pump();
    expect(presses, 1);
    expect(
      tester.getSemantics(find.byKey(key)),
      matchesSemantics(isButton: true, hasEnabledState: true, isEnabled: false),
    );
  });

  testWidgets('variants take their fills from the pack', (tester) async {
    for (final variant in CharcoalButtonVariant.values) {
      await pumpLoose(
        tester,
        CharcoalButton(key: key, variant: variant, onPressed: () {}, child: const Text('X')),
      );
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      expect(
        _decoration(tester, find.byKey(key)).color,
        charcoalButtonColors(theme, variant).rest,
        reason: variant.name,
      );
    }
  });

  testWidgets('sizes are 32 and 40 and the pill radius comes from the pack', (tester) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalButton(
            key: key,
            size: CharcoalButtonSize.small,
            onPressed: () {},
            child: const Text('S'),
          ),
          CharcoalButton(key: const ValueKey('m'), onPressed: () {}, child: const Text('M')),
        ],
      ),
    );
    expect(tester.getSize(find.byKey(key)).height, 32);
    expect(tester.getSize(find.byKey(const ValueKey('m'))).height, 40);
  });

  testWidgets('pressed colour comes from a controller and custom primary blends over', (
    tester,
  ) async {
    final states = WidgetStatesController();
    addTearDown(states.dispose);
    await pumpLoose(
      tester,
      CharcoalButton(
        key: key,
        variant: CharcoalButtonVariant.primary,
        statesController: states,
        onPressed: () {},
        child: const Text('P'),
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
    states.update(WidgetState.pressed, true);
    await tester.pump(const Duration(seconds: 1));
    expect(_decoration(tester, find.byKey(key)).color, theme.colors.primaryPress);

    const custom = Color(0xFF8A2BE2);
    await pumpLoose(
      tester,
      CharcoalButton(
        key: key,
        variant: CharcoalButtonVariant.primary,
        primaryColor: custom,
        onPressed: () {},
        child: const Text('P'),
      ),
    );
    expect(_decoration(tester, find.byKey(key)).color, custom);
  });

  testWidgets('geometry is stable through hover, focus, press and disabled', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpLoose(
      tester,
      CharcoalButton(
        key: key,
        focusNode: focus,
        leading: CharcoalIcon(CharcoalIcons.check),
        onPressed: () {},
        child: const Text('Label'),
      ),
    );
    final probes = [find.byKey(key), find.byType(CharcoalIcon), find.text('Label')];
    final rest = rectsOf(tester, probes);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: tester.getCenter(find.byKey(key)));
    await tester.pump(const Duration(seconds: 1));
    expect(rectsOf(tester, probes), rest, reason: 'hover');

    focus.requestFocus();
    await tester.pump(const Duration(seconds: 1));
    expect(rectsOf(tester, probes), rest, reason: 'focus');

    final gesture = await pressAndHold(tester, find.byKey(key));
    await tester.pump(const Duration(seconds: 1));
    expect(rectsOf(tester, probes), rest, reason: 'pressed');
    await gesture.up();
    await tester.pump();

    await pumpLoose(
      tester,
      CharcoalButton(
        key: key,
        leading: CharcoalIcon(CharcoalIcons.check),
        onPressed: null,
        child: const Text('Label'),
      ),
    );
    expect(rectsOf(tester, probes), rest, reason: 'disabled');
  });

  testWidgets('touch is down then cancel (no activation) or accepted tap', (tester) async {
    var presses = 0;
    final states = WidgetStatesController();
    addTearDown(states.dispose);
    await pumpLoose(
      tester,
      CharcoalButton(
        key: key,
        statesController: states,
        onPressed: () => presses++,
        child: const Text('Go'),
      ),
    );
    final down = await tester.startGesture(tester.getCenter(find.byKey(key)));
    await tester.pump();
    expect(states.value, contains(WidgetState.pressed));
    expect(presses, 0, reason: 'down never activates');
    await down.moveBy(const Offset(0, 200));
    await down.up();
    await tester.pump();
    expect(presses, 0);
    expect(states.value, isNot(contains(WidgetState.pressed)));

    await tester.tap(find.byKey(key));
    await tester.pump();
    expect(presses, 1);
  });

  testWidgets('disabled fades to 0.32; a disabled navigation button disappears', (tester) async {
    await pumpLoose(
      tester,
      Column(
        children: const [
          CharcoalButton(key: key, onPressed: null, child: Text('A')),
          CharcoalButton(
            key: ValueKey('nav'),
            variant: CharcoalButtonVariant.navigation,
            onPressed: null,
            child: Text('B'),
          ),
        ],
      ),
    );
    expect(targetOpacity(tester, find.text('A')), 0.32);
    expect(targetOpacity(tester, find.text('B')), 0);
  });

  testWidgets('keyboard activation works', (tester) async {
    var presses = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpLoose(
      tester,
      CharcoalButton(focusNode: focus, onPressed: () => presses++, child: const Text('K')),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(seconds: 1));
    expect(presses, 1);
  });

  for (final scale in [0.8, 1.0, 2.0, 3.0]) {
    testWidgets('text scale $scale grows the button without overflow', (tester) async {
      await pumpLoose(
        tester,
        const SizedBox(
          width: 300,
          child: CharcoalButton(
            key: key,
            fullWidth: true,
            onPressed: null,
            child: Text('Scaled action'),
          ),
        ),
        textScale: scale,
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byKey(key)).height, greaterThanOrEqualTo(40));
    });
  }

  testWidgets('link button is a keyboard-accessible text action', (tester) async {
    var presses = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpLoose(
      tester,
      CharcoalLinkButton(focusNode: focus, onPressed: () => presses++, child: const Text('Clear')),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(seconds: 1));
    expect(presses, 1);
    expect(tester.getSize(find.byType(CharcoalLinkButton)).height, 40);
    expect(
      tester.getSemantics(find.byType(CharcoalLinkButton)),
      matchesSemantics(
        label: 'Clear',
        isButton: true,
        isFocused: true,
        isFocusable: true,
        hasFocusAction: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('switching button reserves the larger geometry and shows one branch', (tester) async {
    await pumpLoose(
      tester,
      const CharcoalSwitchingButton(
        isOn: false,
        offButton: SizedBox(width: 80, height: 32, child: Text('Off')),
        onButton: SizedBox(width: 120, height: 40, child: Text('On')),
      ),
    );
    expect(tester.getSize(find.byType(IndexedStack)), const Size(120, 40));
    expect(tester.widget<IndexedStack>(find.byType(IndexedStack)).index, 1);
  });

  testWidgets('switching button exposes and focuses only its visible action', (tester) async {
    var isOn = false;
    late StateSetter setState;
    final onFocus = FocusNode();
    final offFocus = FocusNode();
    addTearDown(onFocus.dispose);
    addTearDown(offFocus.dispose);
    await pumpLoose(
      tester,
      StatefulBuilder(
        builder: (context, update) {
          setState = update;
          return CharcoalSwitchingButton(
            isOn: isOn,
            offButton: CharcoalButton(
              focusNode: offFocus,
              onPressed: () {},
              child: const Text('Enable'),
            ),
            onButton: CharcoalButton(
              focusNode: onFocus,
              onPressed: () {},
              child: const Text('Disable'),
            ),
          );
        },
      ),
    );
    onFocus.requestFocus();
    await tester.pump();
    expect(onFocus.hasFocus, isFalse);
    expect(find.bySemanticsLabel('Enable'), findsOneWidget);
    expect(find.bySemanticsLabel('Disable'), findsNothing);
    expect(find.semantics.byFlag(SemanticsFlag.hasToggledState), findsNothing);

    setState(() => isOn = true);
    await tester.pump();
    expect(find.bySemanticsLabel('Enable'), findsNothing);
    expect(find.bySemanticsLabel('Disable'), findsOneWidget);
    onFocus.requestFocus();
    await tester.pump();
    expect(onFocus.hasPrimaryFocus, isTrue);
  });
}
