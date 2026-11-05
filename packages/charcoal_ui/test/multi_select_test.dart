import 'dart:ui' show CheckedState;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

BoxDecoration _indicator(WidgetTester tester) =>
    tester
            .widget<AnimatedContainer>(
              find
                  .descendant(
                    of: find.byType(CharcoalMultiSelect),
                    matching: find.byType(AnimatedContainer),
                  )
                  .first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  testWidgets('exposes checked semantics and requests the next value', (tester) async {
    bool? next;
    await pumpLoose(
      tester,
      CharcoalMultiSelect(
        label: const Text('Landscape'),
        onChanged: (v) => next = v,
        selected: false,
        semanticLabel: 'Landscape',
      ),
    );
    expect(
      tester.getSemantics(find.byType(CharcoalMultiSelect)),
      matchesSemantics(
        label: 'Landscape',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.text('Landscape'));
    expect(next, isTrue);
  });

  testWidgets('selection is atomic: the first frame already targets the new fill', (tester) async {
    var selected = false;
    late StateSetter setState;
    await pumpLoose(
      tester,
      StatefulBuilder(
        builder: (context, update) {
          setState = update;
          return CharcoalMultiSelect(
            selected: selected,
            onChanged: (v) => setState(() => selected = v),
          );
        },
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalMultiSelect)));
    expect(_indicator(tester).color, theme.colors.neutral);
    final check = find.byType(CharcoalIcon);
    final rect = tester.getRect(check);
    await tester.tap(find.byType(CharcoalMultiSelect));
    await tester.pump();
    expect(selected, isTrue);
    expect(_indicator(tester).color, theme.colors.primary);
    expect(
      tester.getSemantics(find.byType(CharcoalMultiSelect)).flagsCollection.isChecked,
      CheckedState.isTrue,
    );
    expect(tester.getRect(check), rect, reason: 'the check does not move');
  });

  testWidgets('pressed uses the neutral pressed fill without moving anything', (tester) async {
    final states = WidgetStatesController(<WidgetState>{});
    addTearDown(states.dispose);
    await pumpLoose(
      tester,
      CharcoalMultiSelect(
        selected: false,
        onChanged: (_) {},
        statesController: states,
        label: const Text('L'),
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalMultiSelect)));
    final probes = [find.byType(CharcoalMultiSelect), find.byType(CharcoalIcon), find.text('L')];
    final rest = rectsOf(tester, probes);
    states.update(WidgetState.pressed, true);
    await tester.pump(const Duration(seconds: 1));
    expect(_indicator(tester).color, theme.colors.neutralPress);
    expect(rectsOf(tester, probes), rest);
  });

  testWidgets('invalid is exposed and a disabled invalid control suppresses the halo', (
    tester,
  ) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalMultiSelect(selected: false, invalid: true, onChanged: (_) {}),
        ],
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalMultiSelect)));
    expect(
      tester.getSemantics(find.byType(CharcoalMultiSelect)).validationResult,
      SemanticsValidationResult.invalid,
    );
    expect(_indicator(tester).boxShadow!.single.color, theme.colors.borderNegative);

    await pumpLoose(
      tester,
      const CharcoalMultiSelect(selected: false, invalid: true, onChanged: null),
    );
    expect(_indicator(tester).boxShadow, isEmpty);
    expect(
      targetOpacity(tester, find.byType(CharcoalIcon)),
      theme.metrics.clickable.disabledOpacity,
    );
  });

  testWidgets('keyboard activation requests but does not own the value', (tester) async {
    final values = <bool>[];
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpLoose(
      tester,
      CharcoalMultiSelect(focusNode: focus, selected: false, onChanged: values.add),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(seconds: 1));
    expect(values, [true]);
    expect(
      _indicator(tester).color,
      isNot(CharcoalTheme.of(tester.element(find.byType(CharcoalMultiSelect))).colors.primary),
    );
  });

  testWidgets('overlay variant uses the HUD border and long labels wrap', (tester) async {
    await pumpLoose(
      tester,
      SizedBox(
        width: 160,
        child: CharcoalMultiSelect(
          selected: true,
          variant: CharcoalMultiSelectVariant.overlay,
          onChanged: (_) {},
          label: const Text('A very long label that must wrap onto several lines'),
        ),
      ),
      textScale: 2,
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalMultiSelect)));
    expect(tester.takeException(), isNull);
    final ring = find
        .descendant(of: find.byType(CharcoalMultiSelect), matching: find.byType(Container))
        .evaluate()
        .map((e) => (e.widget as Container).decoration)
        .whereType<BoxDecoration>()
        .where((d) => d.border != null);
    expect((ring.single.border! as Border).top.color, theme.colors.borderHud);
  });
}
