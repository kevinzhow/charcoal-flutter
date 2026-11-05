import 'dart:ui' show CheckedState, Tristate;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

BoxDecoration _decorationOf(WidgetTester tester, Finder within) =>
    tester
            .widget<AnimatedContainer>(
              find.descendant(of: within, matching: find.byType(AnimatedContainer)).first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  const key = ValueKey<String>('control');

  group('checkbox', () {
    testWidgets('exposes checked semantics and requests the next value', (tester) async {
      bool? next;
      await pumpLoose(
        tester,
        CharcoalCheckbox(
          key: key,
          value: false,
          label: const Text('Agree'),
          semanticLabel: 'Agree',
          onChanged: (v) => next = v,
        ),
      );
      final node = tester.getSemantics(find.byKey(key));
      expect(node.label, 'Agree');
      expect(node.flagsCollection.isChecked, CheckedState.isFalse);
      expect(node.flagsCollection.isEnabled, Tristate.isTrue);
      await tester.tap(find.text('Agree'));
      expect(next, isTrue, reason: 'the label is part of the tap target');
    });

    testWidgets('the unchecked body is 20 px with a thick border; checked is filled', (
      tester,
    ) async {
      await pumpLoose(tester, CharcoalCheckbox(key: key, value: false, onChanged: (_) {}));
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      expect(tester.getSize(find.byKey(key)), const Size(20, 20));
      final off = _decorationOf(tester, find.byKey(key));
      expect((off.border! as Border).top.width, theme.borders.thick);
      expect(off.color, theme.colors.restOverlay);

      await pumpLoose(tester, CharcoalCheckbox(key: key, value: true, onChanged: (_) {}));
      expect(_decorationOf(tester, find.byKey(key)).color, theme.colors.primary);
    });

    testWidgets('invalid is exposed through semantics and a negative halo', (tester) async {
      await pumpLoose(
        tester,
        CharcoalCheckbox(key: key, value: false, invalid: true, onChanged: (_) {}),
      );
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      expect(
        tester.getSemantics(find.byKey(key)).validationResult,
        SemanticsValidationResult.invalid,
      );
      expect(
        _decorationOf(tester, find.byKey(key)).boxShadow!.single.color,
        theme.colors.borderNegative,
      );
    });

    testWidgets('rounded keeps the 20 px footprint', (tester) async {
      await pumpLoose(
        tester,
        CharcoalCheckbox(key: key, value: true, rounded: true, onChanged: (_) {}),
      );
      expect(tester.getSize(find.byKey(key)), const Size(20, 20));
    });

    testWidgets('pressed uses the pressed fill and does not move the body', (tester) async {
      final states = WidgetStatesController();
      addTearDown(states.dispose);
      await pumpLoose(
        tester,
        CharcoalCheckbox(
          key: key,
          value: true,
          statesController: states,
          label: const Text('A'),
          onChanged: (_) {},
        ),
      );
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      final rest = rectsOf(tester, [find.byKey(key), find.text('A')]);
      states.update(WidgetState.pressed, true);
      await tester.pump(const Duration(seconds: 1));
      expect(_decorationOf(tester, find.byKey(key)).color, theme.colors.primaryPress);
      expect(rectsOf(tester, [find.byKey(key), find.text('A')]), rest);
    });
  });

  group('radio', () {
    testWidgets('selection moves between options in one frame', (tester) async {
      var group = 1;
      late StateSetter setState;
      await pumpLoose(
        tester,
        StatefulBuilder(
          builder: (context, update) {
            setState = update;
            return Column(
              children: [
                CharcoalRadio<int>(
                  key: key,
                  value: 1,
                  groupValue: group,
                  onChanged: (v) => setState(() => group = v),
                  label: const Text('One'),
                ),
                CharcoalRadio<int>(
                  key: const ValueKey('two'),
                  value: 2,
                  groupValue: group,
                  onChanged: (v) => setState(() => group = v),
                  label: const Text('Two'),
                ),
              ],
            );
          },
        ),
      );
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      await tester.tap(find.text('Two'));
      await tester.pump(); // first post-activation frame only
      expect(group, 2);
      // The widget tree already targets the new state: exactly one filled option, no overlap.
      final fills = [
        _decorationOf(tester, find.byKey(key)).color,
        _decorationOf(tester, find.byKey(const ValueKey('two'))).color,
      ];
      expect(fills[1], isNot(fills[0]));
      expect(fills[1], theme.colors.primary);
      expect(
        tester.getSemantics(find.byKey(const ValueKey('two'))).flagsCollection.isChecked,
        CheckedState.isTrue,
      );
      expect(
        tester.getSemantics(find.byKey(key)).flagsCollection.isChecked,
        CheckedState.isFalse,
      );
    });

    testWidgets('selected body is 20 px with an 8 px dot; unselected has a border', (tester) async {
      await pumpLoose(
        tester,
        Column(
          children: [
            CharcoalRadio<int>(key: key, value: 1, groupValue: 1, onChanged: (_) {}),
            CharcoalRadio<int>(
              key: const ValueKey('off'),
              value: 2,
              groupValue: 1,
              onChanged: (_) {},
            ),
          ],
        ),
      );
      expect(tester.getSize(find.byKey(key)), const Size(20, 20));
      final dot = find
          .descendant(of: find.byKey(key), matching: find.byType(AnimatedContainer))
          .last;
      expect(tester.getSize(dot), const Size(8, 8));
      expect(_decorationOf(tester, find.byKey(const ValueKey('off'))).border, isNotNull);
      expect(_decorationOf(tester, find.byKey(key)).border, isNull);
    });

    testWidgets('invalid and disabled semantics', (tester) async {
      await pumpLoose(
        tester,
        const Column(
          children: [
            CharcoalRadio<int>(key: key, value: 1, groupValue: 1, invalid: true, onChanged: null),
          ],
        ),
      );
      final node = tester.getSemantics(find.byKey(key));
      expect(node.validationResult, SemanticsValidationResult.invalid);
      expect(node.flagsCollection.isEnabled, Tristate.isFalse);
    });
  });

  group('switch', () {
    testWidgets('keeps the 51x31 track and 27 px thumb and toggles', (tester) async {
      var value = false;
      await pumpLoose(
        tester,
        StatefulBuilder(
          builder: (context, setState) => CharcoalSwitch(
            key: key,
            value: value,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      );
      final track = find.descendant(of: find.byKey(key), matching: find.byType(AnimatedContainer));
      expect(tester.getSize(track), const Size(51, 31));
      final thumb = find.descendant(of: find.byKey(key), matching: find.byType(DecoratedBox)).last;
      expect(tester.getSize(thumb), const Size(27, 27));
      expect(tester.getSemantics(find.byKey(key)).flagsCollection.isToggled, Tristate.isFalse);

      final offLeft = tester.getRect(thumb).left;
      await tester.tap(find.byKey(key));
      await tester.pump();
      expect(value, isTrue);
      expect(tester.getSemantics(find.byKey(key)).flagsCollection.isToggled, Tristate.isTrue);
      await tester.pumpAndSettle();
      expect(tester.getRect(thumb).left, greaterThan(offLeft));
      expect(tester.getSize(track), const Size(51, 31));
    });

    testWidgets('keyboard activation toggles', (tester) async {
      var value = false;
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await pumpLoose(
        tester,
        CharcoalSwitch(focusNode: focus, value: value, onChanged: (v) => value = v),
      );
      focus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump(const Duration(seconds: 1));
      expect(value, isTrue);
    });

    testWidgets('disabled opacity applies to the control, not to the label', (tester) async {
      await pumpLoose(
        tester,
        const CharcoalSwitch(key: key, value: true, onChanged: null, label: Text('Label')),
      );
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      final track = find.descendant(of: find.byKey(key), matching: find.byType(AnimatedContainer));
      expect(targetOpacity(tester, track), theme.metrics.clickable.disabledOpacity);
      final labelFades = find.ancestor(
        of: find.text('Label'),
        matching: find.byType(AnimatedOpacity),
      );
      expect(labelFades, findsNothing);
    });

    testWidgets('pressed does not move the track or label', (tester) async {
      await pumpLoose(
        tester,
        CharcoalSwitch(key: key, value: false, onChanged: (_) {}, label: const Text('Wi-Fi')),
      );
      final probes = [find.byKey(key), find.text('Wi-Fi')];
      final rest = rectsOf(tester, probes);
      final g = await pressAndHold(tester, find.byKey(key));
      await tester.pump(const Duration(seconds: 1));
      expect(rectsOf(tester, probes), rest);
      await g.cancel();
    });
  });

  group('segmented control', () {
    Widget build(int value, ValueChanged<int>? onChanged, {bool uniform = false}) =>
        CharcoalSegmentedControl<int>(
          key: key,
          value: value,
          onChanged: onChanged,
          uniformSegmentWidth: uniform,
          segments: const [
            CharcoalSegment(value: 1, child: Text('One')),
            CharcoalSegment(value: 2, child: Text('Two')),
            CharcoalSegment(value: 3, child: Text('Off'), enabled: false),
          ],
        );

    testWidgets('selection is atomic: the first frame after a tap shows only the new segment', (
      tester,
    ) async {
      var value = 1;
      late StateSetter setState;
      await pumpLoose(
        tester,
        StatefulBuilder(
          builder: (context, update) {
            setState = update;
            return build(value, (v) => setState(() => value = v));
          },
        ),
      );
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      Finder segment(String label) =>
          find.ancestor(of: find.text(label), matching: find.byType(CharcoalClickable));
      Color? fill(String label) {
        final box = find.ancestor(of: find.text(label), matching: find.byType(Container)).first;
        return (tester.widget<Container>(box).decoration as BoxDecoration?)?.color;
      }

      expect(fill('One'), theme.colors.primary);
      await tester.tap(find.text('Two'));
      await tester.pump();
      expect(value, 2);
      expect(fill('One'), isNull, reason: 'no double highlight');
      expect(fill('Two'), theme.colors.primary);
      expect(
        tester.getSemantics(segment('Two')).flagsCollection.isChecked,
        CheckedState.isTrue,
      );
      expect(tester.getSemantics(segment('One')).flagsCollection.isChecked, CheckedState.isFalse);
    });

    testWidgets('selection and press do not move segments', (tester) async {
      await pumpLoose(tester, build(1, (_) {}));
      final probes = [find.text('One'), find.text('Two'), find.byKey(key)];
      final rest = rectsOf(tester, probes);
      final g = await pressAndHold(tester, find.text('Two'));
      await tester.pump(const Duration(seconds: 1));
      expect(rectsOf(tester, probes), rest);
      await g.cancel();
      await pumpLoose(tester, build(2, (_) {}));
      expect(rectsOf(tester, probes), rest);
    });

    testWidgets('a disabled segment and a null callback do not report', (tester) async {
      var reports = 0;
      await pumpLoose(tester, build(1, (_) => reports++));
      await tester.tap(find.text('Off'));
      expect(reports, 0);
      await pumpLoose(tester, build(1, null));
      await tester.tap(find.text('Two'));
      expect(reports, 0);
    });

    testWidgets('uniform segments share the minimum width and height is 32', (tester) async {
      await pumpLoose(tester, build(1, (_) {}, uniform: true));
      final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
      final min = theme.metrics.segmented.uniformSegmentMinWidth;
      expect(tester.getSize(find.byKey(key)), Size(min * 3, theme.sizes.controlSm));
    });

    for (final scale in [0.8, 1.0, 2.0, 3.0]) {
      testWidgets('text scale $scale does not overflow when full width', (tester) async {
        await pumpLoose(
          tester,
          SizedBox(
            width: 320,
            child: CharcoalSegmentedControl<int>(
              fullWidth: true,
              value: 1,
              onChanged: (_) {},
              segments: const [
                CharcoalSegment(value: 1, child: Text('Overview')),
                CharcoalSegment(value: 2, child: Text('Details')),
              ],
            ),
          ),
          textScale: scale,
        );
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('selection box fills the indicator slot in both states', (tester) async {
    await pumpLoose(
      tester,
      const Column(
        children: [
          CharcoalSelectionBox(key: key, selected: false),
          CharcoalSelectionBox(key: ValueKey('on'), selected: true),
        ],
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
    expect(tester.getSize(find.byKey(key)), Size.square(theme.sizes.indicatorSlot));
    expect(
      tester.getSize(find.byKey(const ValueKey('on'))),
      Size.square(theme.sizes.indicatorSlot),
    );
  });
}
