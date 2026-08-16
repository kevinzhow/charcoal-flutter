import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/components/field_ring.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('accepts multiline input and counts code points', (tester) async {
    String? changedValue;
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          child: CharcoalTextArea(
            label: 'Biography',
            maxLength: 20,
            onChanged: (value) => changedValue = value,
            placeholder: 'Tell us about yourself',
            rows: 3,
            showCount: true,
            showLabel: true,
          ),
        ),
        theme: theme,
      ),
    );

    await tester.enterText(find.byType(EditableText), 'one\ntwo');
    await tester.pump();

    expect(changedValue, 'one\ntwo');
    expect(find.text('7/20'), findsOneWidget);
    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    const expectedHeight = 22 * 4 + 18;
    expect(container.constraints!.maxHeight, expectedHeight);
  });

  testWidgets('renders the iOS invalid field ring', (tester) async {
    final theme = CharcoalThemeData.dark();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalTextArea(invalid: true, rows: 2),
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.boxShadow, isNull);
    final ring = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.foregroundPainter is CharcoalFieldRingPainter,
      ),
    );
    final ringPainter = ring.foregroundPainter! as CharcoalFieldRingPainter;
    expect(ringPainter.color, theme.colors.borderNegative);
    expect(ringPainter.opacity, 1);
  });

  testWidgets('invalid state does not recolor the character count', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalTextArea(
            invalid: true,
            maxLength: 20,
            rows: 2,
            showCount: true,
          ),
        ),
        theme: theme,
      ),
    );

    expect(
      tester.widget<Text>(find.text('0/20')).style!.color,
      theme.colors.textTertiaryDefault,
    );
  });
}
