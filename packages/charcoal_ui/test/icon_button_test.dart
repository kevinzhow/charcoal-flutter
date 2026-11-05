import 'dart:ui' show Tristate;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

void main() {
  const key = ValueKey<String>('icon');

  Widget icon() => CharcoalIcon(CharcoalIcons.heart);

  testWidgets('distinguishes regular actions from controlled toggles', (tester) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalIconButton(key: key, semanticLabel: 'Save', icon: icon(), onPressed: () {}),
          CharcoalIconButton(
            key: const ValueKey('t'),
            semanticLabel: 'Unsave',
            icon: icon(),
            selected: true,
            onPressed: () {},
          ),
        ],
      ),
    );
    expect(tester.getSemantics(find.byKey(key)).flagsCollection.isSelected, Tristate.none);
    expect(
      tester.getSemantics(find.byKey(const ValueKey('t'))).flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(tester.getSemantics(find.byKey(key)).label, 'Save');
  });

  testWidgets('sizes are 24, 32 and 40 with 16/24 px icons', (tester) async {
    await pumpLoose(
      tester,
      Column(
        children: [
          for (final size in CharcoalIconButtonSize.values)
            CharcoalIconButton(
              key: ValueKey(size),
              size: size,
              semanticLabel: 'x',
              icon: icon(),
              onPressed: () {},
            ),
        ],
      ),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey(CharcoalIconButtonSize.extraSmall))),
      const Size(20, 20),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey(CharcoalIconButtonSize.small))),
      const Size(32, 32),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey(CharcoalIconButtonSize.medium))),
      const Size(40, 40),
    );
  });

  testWidgets('keyboard activation and disabled state', (tester) async {
    var presses = 0;
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await pumpLoose(
      tester,
      Column(
        children: [
          CharcoalIconButton(
            focusNode: focus,
            semanticLabel: 'a',
            icon: icon(),
            onPressed: () => presses++,
          ),
          CharcoalIconButton(key: key, semanticLabel: 'b', icon: icon(), onPressed: null),
        ],
      ),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(seconds: 1));
    expect(presses, 1);
    expect(tester.getSemantics(find.byKey(key)).flagsCollection.isEnabled, Tristate.isFalse);
    expect(
      targetOpacity(
        tester,
        find.descendant(of: find.byKey(key), matching: find.byType(CharcoalIcon)),
      ),
      0.32,
    );
  });

  testWidgets('selected paints the pressed fill; press never moves the icon', (tester) async {
    await pumpLoose(
      tester,
      CharcoalIconButton(
        key: key,
        semanticLabel: 'x',
        icon: icon(),
        selected: true,
        onPressed: () {},
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byKey(key)));
    final deco =
        tester
                .widget<AnimatedContainer>(
                  find.descendant(of: find.byKey(key), matching: find.byType(AnimatedContainer)),
                )
                .decoration!
            as BoxDecoration;
    expect(deco.color, theme.colors.pressOverlay);

    final probes = [find.byKey(key), find.byType(CharcoalIcon)];
    final rest = rectsOf(tester, probes);
    final g = await pressAndHold(tester, find.byKey(key));
    await tester.pump(const Duration(seconds: 1));
    expect(rectsOf(tester, probes), rest);
    await g.cancel();
  });
}
