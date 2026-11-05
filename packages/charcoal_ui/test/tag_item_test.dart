import 'dart:ui' show Tristate;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

BoxDecoration _deco(WidgetTester tester, Finder tag) =>
    tester
            .widget<AnimatedContainer>(
              find.descendant(of: tag, matching: find.byType(AnimatedContainer)).first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  const key = ValueKey<String>('tag');

  testWidgets('activates and exposes its unselected state as button semantics', (tester) async {
    var presses = 0;
    await pumpLoose(tester, CharcoalTagItem(key: key, label: '#sky', onPressed: () => presses++));
    expect(
      tester.getSemantics(find.byKey(key)),
      matchesSemantics(
        label: '#sky',
        isButton: true,
        hasSelectedState: true,
        isSelected: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.byKey(key));
    expect(presses, 1);
  });

  testWidgets('active status is selected, pads asymmetrically and shows the remove icon', (
    tester,
  ) async {
    await pumpLoose(
      tester,
      CharcoalTagItem(
        key: key,
        label: '#sky',
        status: CharcoalTagItemStatus.active,
        onPressed: () {},
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
    final container = tester.widget<AnimatedContainer>(
      find.descendant(of: find.byKey(key), matching: find.byType(AnimatedContainer)),
    );
    expect(
      container.padding,
      EdgeInsetsDirectional.only(start: theme.space.lg, end: theme.space.sm),
    );
    expect(find.byType(CharcoalIcon), findsOneWidget);
    expect(tester.getSemantics(find.byKey(key)).flagsCollection.isSelected, Tristate.isTrue);
  });

  testWidgets('status colours come from the pack', (tester) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalTagItem(key: key, label: 'a', onPressed: () {}),
          CharcoalTagItem(
            key: const ValueKey('i'),
            label: 'b',
            status: CharcoalTagItemStatus.inactive,
            onPressed: () {},
          ),
          CharcoalTagItem(
            key: const ValueKey('c'),
            label: 'c',
            backgroundColor: const Color(0xFF123456),
            onPressed: () {},
          ),
        ],
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
    expect(_deco(tester, find.byKey(key)).color, theme.colors.tagBackground);
    expect(_deco(tester, find.byKey(const ValueKey('i'))).color, theme.colors.surfaceSecondary);
    expect(_deco(tester, find.byKey(const ValueKey('c'))).color, const Color(0xFF123456));
  });

  testWidgets('translated labels force the medium size and shrink in compact constraints', (
    tester,
  ) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalTagItem(
            key: key,
            label: '#とても長いオリジナルタグ',
            size: CharcoalTagItemSize.small,
            translatedLabel: 'a very long translated tag',
            onPressed: () {},
          ),
          CharcoalTagItem(
            key: const ValueKey('s'),
            label: '#s',
            size: CharcoalTagItemSize.small,
            onPressed: () {},
          ),
        ],
      ),
      size: const Size(240, 400),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byKey(key)).height, greaterThanOrEqualTo(40));
    expect(tester.getSize(find.byKey(const ValueKey('s'))).height, 32);
    expect(tester.getSemantics(find.byKey(key)).label, contains('a very long translated tag'));
  });

  testWidgets('focus, hover and press never change geometry; keyboard activates', (tester) async {
    var presses = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpLoose(
      tester,
      CharcoalTagItem(
        key: key,
        focusNode: focus,
        label: '#sky',
        status: CharcoalTagItemStatus.active,
        onPressed: () => presses++,
      ),
    );
    final probes = [find.byKey(key), find.byType(CharcoalIcon), find.text('#sky')];
    final rest = rectsOf(tester, probes);
    focus.requestFocus();
    await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump(const Duration(seconds: 1));
    expect(rectsOf(tester, probes), rest);
    expect(_deco(tester, find.byKey(key)).boxShadow, isNotEmpty);
    final g = await pressAndHold(tester, find.byKey(key));
    await tester.pump(const Duration(seconds: 1));
    expect(rectsOf(tester, probes), rest);
    await g.cancel();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(seconds: 1));
    expect(presses, 1);
  });

  testWidgets('the active icon sits on the directional trailing edge', (tester) async {
    for (final direction in TextDirection.values) {
      await pumpLoose(
        tester,
        Directionality(
          textDirection: direction,
          child: CharcoalTagItem(
            key: key,
            label: '#sky',
            status: CharcoalTagItemStatus.active,
            onPressed: () {},
          ),
        ),
      );
      final icon = tester.getCenter(find.byType(CharcoalIcon)).dx;
      final text = tester.getCenter(find.text('#sky')).dx;
      expect(direction == TextDirection.ltr ? icon > text : icon < text, isTrue);
    }
  });

  for (final scale in [0.8, 1.0, 2.0, 3.0]) {
    testWidgets('text scale $scale does not overflow', (tester) async {
      await pumpLoose(
        tester,
        SizedBox(
          width: 200,
          child: CharcoalTagItem(
            key: key,
            label: '#landscape',
            translatedLabel: 'scenery',
            onPressed: () {},
          ),
        ),
        textScale: scale,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('disabled fades to 0.32', (tester) async {
    await pumpLoose(tester, const CharcoalTagItem(key: key, label: 'x', onPressed: null));
    expect(targetOpacity(tester, find.text('x')), 0.32);
  });
}
