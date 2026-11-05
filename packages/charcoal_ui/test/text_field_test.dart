import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Widget _field(Widget field, {double width = 320}) => Center(
  child: SizedBox(width: width, child: field),
);

CharcoalFieldRingPainter _ring(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(
    find.descendant(
      of: find.byType(CharcoalTextField),
      matching: find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.painter is CharcoalFieldRingPainter,
      ),
    ),
  );
  return paint.painter! as CharcoalFieldRingPainter;
}

double _ringOpacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find.descendant(of: find.byType(CharcoalFieldRing), matching: find.byType(Opacity)),
    )
    .opacity;

void main() {
  final pack = charcoalLightPack;

  testWidgets('accepts input, hides the placeholder and counts graphemes', (tester) async {
    String? changedValue;
    await pumpCharcoal(
      tester,
      _field(
        CharcoalTextField(
          label: 'Name',
          maxLength: 10,
          onChanged: (value) => changedValue = value,
          placeholder: 'Display name',
          showCount: true,
          showLabel: true,
        ),
      ),
    );

    expect(find.text('Display name'), findsOneWidget);
    expect(find.text('0/10'), findsOneWidget);

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    expect(
      container.padding,
      EdgeInsets.symmetric(
        horizontal: pack.space.sm,
        vertical: pack.metrics.textField.verticalPadding,
      ),
    );
    expect(container.padding, const EdgeInsets.symmetric(horizontal: 8, vertical: 10));
    expect((container.decoration! as BoxDecoration).borderRadius, BorderRadius.circular(4));
    expect((container.decoration! as BoxDecoration).color, pack.colors.fillSecondary);

    await tester.enterText(find.byType(EditableText), 'pixiv');
    await tester.pump();

    expect(changedValue, 'pixiv');
    expect(find.text('Display name'), findsNothing);
    expect(find.text('5/10'), findsOneWidget);
  });

  testWidgets('uses semantic invalid colours for ring and assistive text', (tester) async {
    await pumpCharcoal(
      tester,
      _field(
        const CharcoalTextField(
          assistiveText: 'Required field',
          invalid: true,
          label: 'Name',
          required: true,
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);
    expect((container.decoration! as BoxDecoration).boxShadow, isNull);
    expect(_ring(tester).color, pack.colors.borderNegative);
    expect(_ringOpacity(tester), 1);

    expect(tester.widget<Text>(find.text('Required field')).style!.color, pack.colors.textNegative);
    expect(
      tester.getSemantics(find.byType(CharcoalTextField)),
      isSemantics(
        label: 'Name',
        hint: 'Required field',
        validationResult: SemanticsValidationResult.invalid,
        isTextField: true,
        hasEnabledState: true,
        isEnabled: true,
        hasRequiredState: true,
        isRequired: true,
      ),
    );
  });

  testWidgets('disabled field ignores text input and dims by the pack opacity', (tester) async {
    final controller = TextEditingController(text: 'fixed');
    addTearDown(controller.dispose);
    await pumpCharcoal(
      tester,
      _field(CharcoalTextField(controller: controller, disabled: true, label: 'Name')),
    );

    await tester.enterText(find.byType(EditableText), 'changed');
    await tester.pump();

    expect(controller.text, 'fixed');
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      pack.metrics.clickable.disabledOpacity,
    );
  });

  testWidgets('focus changes only the ring: fill and geometry stay put', (tester) async {
    await pumpCharcoal(tester, _field(const CharcoalTextField(label: 'Name')));

    BoxDecoration decoration() =>
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
            as BoxDecoration;
    final box = find.byType(AnimatedContainer);
    final rectBefore = tester.getRect(box);
    final textRectBefore = tester.getRect(find.byType(EditableText));
    final initialColor = decoration().color;
    expect(_ringOpacity(tester), 0);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();

    expect(initialColor, pack.colors.fillSecondary);
    expect(decoration().color, initialColor);
    expect(decoration().boxShadow, isNull);
    expect(_ring(tester).color, pack.colors.focusRing);
    expect(_ring(tester).width, pack.borders.focusHalo);
    expect(_ringOpacity(tester), 1);
    // The ring is outside the box: the box and the text did not move or resize.
    expect(tester.getRect(box), rectBefore);
    expect(tester.getRect(find.byType(EditableText)), textRectBefore);
  });

  testWidgets('the ring fades in without a visible frame on the first frame of an update', (
    tester,
  ) async {
    await pumpCharcoal(tester, _field(const CharcoalTextField(label: 'Name')));
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    // First post-activation frame: the ring is on its way (not yet fully opaque, not stuck at 0).
    expect(_ringOpacity(tester), inInclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(_ringOpacity(tester), 1);
  });

  testWidgets('prefix, suffix and counter keep the pack content gap', (tester) async {
    await pumpCharcoal(
      tester,
      _field(
        const CharcoalTextField(
          prefix: SizedBox(key: ValueKey('prefix'), width: 16, height: 16),
          suffix: SizedBox(key: ValueKey('suffix'), width: 16, height: 16),
          showCount: true,
          maxLength: 20,
        ),
      ),
    );
    final gap = pack.metrics.textField.contentGap;
    final prefix = tester.getRect(find.byKey(const ValueKey('prefix')));
    final edit = tester.getRect(find.byType(EditableText));
    final suffix = tester.getRect(find.byKey(const ValueKey('suffix')));
    final count = tester.getRect(find.text('0/20'));
    expect(edit.left - prefix.right, gap);
    expect(count.left - suffix.right, gap);
  });

  for (final scale in <double>[0.8, 1, 2, 3]) {
    testWidgets('lays out at text scale $scale without overflow', (tester) async {
      await pumpCharcoal(
        tester,
        _field(
          const CharcoalTextField(
            label: 'A rather long label for the field',
            assistiveText: 'Assistive text that wraps',
            placeholder: 'Placeholder',
            required: true,
            showCount: true,
            showLabel: true,
            subLabel: Text('0/500'),
            maxLength: 500,
          ),
          width: 400,
        ),
        textScale: scale,
        size: const Size(420, 900),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a field in dark uses the dark pack roles', (tester) async {
    await pumpCharcoal(
      tester,
      _field(const CharcoalTextField(label: 'Name')),
      brightness: Brightness.dark,
    );
    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    expect((container.decoration! as BoxDecoration).color, charcoalDarkPack.colors.fillSecondary);
  });

  testWidgets('grows with accessibility text scaling', (tester) async {
    await pumpCharcoal(tester, _field(const CharcoalTextField(label: 'Name')), textScale: 2);
    expect(tester.getSize(find.byType(AnimatedContainer)).height, greaterThan(42));
  });

  testWidgets('keyboard Tab focuses the field and shows the ring', (tester) async {
    await pumpCharcoal(tester, _field(const CharcoalTextField(label: 'Name')));
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus, isTrue);
    expect(_ringOpacity(tester), 1);
  });
}
