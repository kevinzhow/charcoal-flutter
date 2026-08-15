import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/components/field_ring.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('accepts input and renders the generated count', (tester) async {
    String? changedValue;
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          child: CharcoalTextField(
            label: 'Name',
            maxLength: 10,
            onChanged: (value) => changedValue = value,
            placeholder: 'Display name',
            showCount: true,
            showLabel: true,
          ),
        ),
      ),
    );

    expect(find.text('Display name'), findsOneWidget);
    expect(find.text('0/10'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'pixiv');
    await tester.pump();

    expect(changedValue, 'pixiv');
    expect(find.text('Display name'), findsNothing);
    expect(find.text('5/10'), findsOneWidget);
  });

  testWidgets('uses invalid tokens for ring and assistive text', (tester) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalTextField(
            assistiveText: 'Required field',
            invalid: true,
            label: 'Name',
          ),
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.boxShadow, isNull);
    final ring = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.foregroundPainter is CharcoalFieldRingPainter,
      ),
    );
    final ringPainter = ring.foregroundPainter! as CharcoalFieldRingPainter;
    expect(ringPainter.color, theme.components.textField.invalidRingColor);
    expect(ringPainter.opacity, 1);

    final assistive = tester.widget<Text>(find.text('Required field'));
    expect(assistive.style!.color, theme.components.textField.invalidAssistiveTextColor);
  });

  testWidgets('disabled field ignores text input', (tester) async {
    final controller = TextEditingController(text: 'fixed');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 320,
          child: CharcoalTextField(controller: controller, disabled: true, label: 'Name'),
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), 'changed');
    await tester.pump();

    expect(controller.text, 'fixed');
  });

  testWidgets('focus changes only the border and preserves the background', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: CharcoalTextField(label: 'Name'),
        ),
        theme: theme,
      ),
    );

    BoxDecoration decoration() =>
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
            as BoxDecoration;
    final initialColor = decoration().color;
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
    await tester.tap(find.byType(EditableText));
    await tester.pumpAndSettle();

    expect(initialColor, theme.components.textField.background.normal);
    expect(decoration().color, initialColor);
    expect(decoration().boxShadow, isNull);
    final ring = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.foregroundPainter is CharcoalFieldRingPainter,
      ),
    );
    final ringPainter = ring.foregroundPainter! as CharcoalFieldRingPainter;
    expect(ringPainter.color, theme.components.textField.focusRingColor);
    expect(ringPainter.opacity, 1);
  });

  testWidgets('grows with accessibility text scaling', (tester) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        const SizedBox(
          width: 320,
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: CharcoalTextField(label: 'Name'),
          ),
        ),
        theme: theme,
      ),
    );

    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      greaterThan(theme.components.textField.height),
    );
  });
}
