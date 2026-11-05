import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

void main() {
  testWidgets('chip paints its tone surface and text colour', (tester) async {
    for (final tone in CharcoalTone.values) {
      await pumpLoose(tester, CharcoalChip('Label', tone: tone));
      final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalChip)));
      final colors = theme.tone(tone);
      final box = tester.widget<Container>(
        find.descendant(of: find.byType(CharcoalChip), matching: find.byType(Container)),
      );
      expect((box.decoration! as BoxDecoration).color, colors.surface);
      expect(tester.widget<Text>(find.text('Label')).style!.color, colors.foreground);
    }
  });

  testWidgets('monospace uses the mono face', (tester) async {
    await pumpLoose(tester, const CharcoalChip('id-1', monospace: true));
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalChip)));
    expect(tester.widget<Text>(find.text('id-1')).style!.fontFamily, theme.typography.monoFamily);
  });

  testWidgets('status dot reserves the indicator slot like the selection box', (tester) async {
    await pumpLoose(
      tester,
      const Row(
        children: [
          CharcoalStatusDot(CharcoalTone.positive, key: ValueKey('dot')),
          CharcoalSelectionBox(selected: true, key: ValueKey('box')),
        ],
      ),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('dot'))),
      tester.getSize(find.byKey(const ValueKey('box'))),
    );
  });
}
