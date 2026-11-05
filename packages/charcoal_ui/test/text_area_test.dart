import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_ui/next.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Widget _area(Widget area, {double width = 320}) => Center(
  child: SizedBox(width: width, child: area),
);

CharcoalFieldRingPainter _ring(WidgetTester tester) =>
    tester
            .widget<CustomPaint>(
              find.descendant(
                of: find.byType(CharcoalTextArea),
                matching: find.byWidgetPredicate(
                  (widget) => widget is CustomPaint && widget.painter is CharcoalFieldRingPainter,
                ),
              ),
            )
            .painter!
        as CharcoalFieldRingPainter;

void main() {
  final pack = charcoalLightPack;

  testWidgets('accepts multiline input, counts characters and sizes by 22 x rows + 18', (
    tester,
  ) async {
    String? changedValue;
    await pumpCharcoal(
      tester,
      _area(
        CharcoalTextArea(
          label: 'Biography',
          maxLength: 20,
          onChanged: (value) => changedValue = value,
          placeholder: 'Tell us about yourself',
          rows: 3,
          showCount: true,
          showLabel: true,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), 'one\ntwo');
    await tester.pump();

    expect(changedValue, 'one\ntwo');
    expect(find.text('7/20'), findsOneWidget);
    const expectedHeight = 22 * 4 + 18; // three rows plus the counter line
    expect(tester.getSize(find.byType(AnimatedContainer)).height, expectedHeight);
  });

  testWidgets('defaults to the pack row count', (tester) async {
    await pumpCharcoal(tester, _area(const CharcoalTextArea()));
    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      pack.metrics.textArea.lineHeight * pack.metrics.textArea.defaultRows +
          pack.metrics.textArea.verticalChrome,
    );
    expect(pack.metrics.textArea.defaultRows, 4);
  });

  testWidgets('renders the invalid ring and semantics in dark', (tester) async {
    await pumpCharcoal(
      tester,
      _area(
        const CharcoalTextArea(
          assistiveText: 'Describe the issue',
          invalid: true,
          label: 'Report details',
          required: true,
          rows: 2,
        ),
      ),
      brightness: Brightness.dark,
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    expect((container.decoration! as BoxDecoration).boxShadow, isNull);
    expect(_ring(tester).color, charcoalDarkPack.colors.borderNegative);
    expect(
      tester.getSemantics(find.byType(CharcoalTextArea)),
      isSemantics(
        label: 'Report details',
        hint: 'Describe the issue',
        validationResult: SemanticsValidationResult.invalid,
        isTextField: true,
        isMultiline: true,
        hasEnabledState: true,
        isEnabled: true,
        hasRequiredState: true,
        isRequired: true,
      ),
    );
  });

  testWidgets('invalid state does not recolor the character count', (tester) async {
    await pumpCharcoal(
      tester,
      _area(const CharcoalTextArea(invalid: true, maxLength: 20, rows: 2, showCount: true)),
    );
    expect(tester.widget<Text>(find.text('0/20')).style!.color, pack.colors.textTertiary);
  });

  testWidgets('counter sits at the pack inset from the bottom right', (tester) async {
    await pumpCharcoal(
      tester,
      _area(const CharcoalTextArea(maxLength: 20, rows: 2, showCount: true)),
    );
    final box = tester.getRect(find.byType(AnimatedContainer));
    final count = tester.getRect(find.text('0/20'));
    expect(box.right - count.right, pack.space.sm);
    expect(box.bottom - count.bottom, pack.metrics.textArea.counterBottomInset);
  });

  testWidgets('hover and press change only the fill; geometry stays put', (tester) async {
    await pumpCharcoal(tester, _area(const CharcoalTextArea(rows: 2)));
    final box = find.byType(AnimatedContainer);
    Color? fill() => ((tester.widget<AnimatedContainer>(box)).decoration! as BoxDecoration).color;
    final rect = tester.getRect(box);
    final textRect = tester.getRect(find.byType(EditableText));
    expect(fill(), pack.colors.fillSecondary);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(box));
    await tester.pumpAndSettle();
    expect(fill(), pack.colors.fillSecondaryHover);
    expect(tester.getRect(box), rect);

    await mouse.down(tester.getCenter(box));
    await tester.pumpAndSettle();
    expect(fill(), pack.colors.fillSecondaryPress);
    await mouse.up();
    await tester.pumpAndSettle();
    expect(tester.getRect(box), rect);
    expect(tester.getRect(find.byType(EditableText)), textRect);
  });

  for (final scale in <double>[0.8, 1, 2, 3]) {
    testWidgets('lays out at text scale $scale without overflow', (tester) async {
      await pumpCharcoal(
        tester,
        _area(
          const CharcoalTextArea(
            label: 'Description',
            placeholder: 'Placeholder',
            assistiveText: 'Wraps nicely',
            showCount: true,
            showLabel: true,
            maxLength: 500,
            subLabel: Text('0/500'),
          ),
          width: 400,
        ),
        textScale: scale,
        size: const Size(420, 1400),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a disabled area cannot be focused and is dimmed', (tester) async {
    await pumpCharcoal(tester, _area(const CharcoalTextArea(disabled: true, rows: 2)));
    await tester.tap(find.byType(EditableText), warnIfMissed: false);
    await tester.pump();
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isFalse);
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      pack.metrics.clickable.disabledOpacity,
    );
  });
}
