import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('activates and exposes its unselected state as button semantics', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(label: '#landscape', onPressed: () => presses += 1),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalTagItem)),
      matchesSemantics(
        label: '#landscape',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasSelectedState: true,
        isSelected: false,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.text('#landscape'));
    expect(presses, 1);
  });

  testWidgets('active status uses asymmetric padding and remove icon', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(
          label: '#landscape',
          onPressed: () {},
          status: CharcoalTagItemStatus.active,
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final padding = container.padding! as EdgeInsetsDirectional;
    expect(padding.start, 16);
    expect(padding.end, 8);
    expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
    expect(
      tester.getSemantics(find.byType(CharcoalTagItem)),
      matchesSemantics(
        label: '#landscape',
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('normal status keeps the component source color', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(label: '#landscape', onPressed: () {}),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(
      (container.decoration! as BoxDecoration).color,
      const Color(0xFF7ACCB1),
    );
  });

  testWidgets('inactive status uses semantic secondary colors', (tester) async {
    final theme = CharcoalThemeData.dark();
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalTagItem(
          label: '#landscape',
          onPressed: null,
          status: CharcoalTagItemStatus.inactive,
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.containerSecondaryDefault);
    expect(
      tester.widget<Text>(find.text('#landscape')).style!.color,
      theme.colors.textSecondaryDefault,
    );
  });

  testWidgets('translated labels force the medium size', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(
          label: '#original',
          onPressed: () {},
          size: CharcoalTagItemSize.small,
          translatedLabel: 'girl',
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    expect(container.constraints!.minHeight, 40);
    expect(
      tester.getSemantics(find.byType(CharcoalTagItem)).label,
      'girl, #original',
    );
  });

  testWidgets('keyboard focus paints its ring and activates the same action', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    var activations = 0;
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(
          focusNode: focusNode,
          label: '#keyboard',
          onPressed: () => activations++,
        ),
        theme: theme,
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(activations, 1);
    final decoration =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
            as BoxDecoration;
    expect(decoration.boxShadow, hasLength(1));
    expect(decoration.boxShadow!.single.color, theme.colors.borderFocusLegacy);
  });

  testWidgets('touch press uses a transient overlay without changing geometry', (
    tester,
  ) async {
    const background = Color(0xFF7ACCB1);
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(
          backgroundColor: background,
          label: '#landscape',
          onPressed: () {},
          status: CharcoalTagItemStatus.active,
        ),
        theme: theme,
      ),
    );

    final before = tester.getRect(find.byType(AnimatedContainer));
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(CharcoalTagItem)),
    );
    await tester.pumpAndSettle();

    var decoration =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
            as BoxDecoration;
    expect(
      decoration.color,
      Color.alphaBlend(theme.colors.containerPressA, background),
    );
    expect(tester.getRect(find.byType(AnimatedContainer)), before);

    await gesture.up();
    await tester.pumpAndSettle();
    decoration =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
            as BoxDecoration;
    expect(decoration.color, background);
  });

  testWidgets('inactive status uses secondary interaction tokens', (
    tester,
  ) async {
    final states = WidgetStatesController(<WidgetState>{WidgetState.pressed});
    addTearDown(states.dispose);
    final theme = CharcoalThemeData.dark();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTagItem(
          label: '#inactive',
          onPressed: () {},
          statesController: states,
          status: CharcoalTagItemStatus.inactive,
        ),
        theme: theme,
      ),
    );

    final decoration =
        tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration!
            as BoxDecoration;
    expect(decoration.color, theme.colors.containerSecondaryPress);
    expect(
      tester.widget<Text>(find.text('#inactive')).style!.color,
      theme.colors.textSecondaryPress,
    );
  });

  testWidgets('translated labels shrink inside compact constraints', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 120,
          child: CharcoalTagItem(
            label: '#an-extremely-long-original-tag-name',
            onPressed: () {},
            status: CharcoalTagItemStatus.active,
            translatedLabel: 'an extremely long translated tag name',
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(CharcoalTagItem)).width, 120);
    expect(tester.takeException(), isNull);
  });

  testWidgets('active icon stays on the directional trailing edge', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: CharcoalTagItem(
            label: '#rtl',
            onPressed: () {},
            status: CharcoalTagItemStatus.active,
          ),
        ),
      ),
    );

    expect(
      tester.getCenter(find.byType(CharcoalIcon)).dx,
      lessThan(tester.getCenter(find.text('#rtl')).dx),
    );
  });

  testWidgets('grows vertically with accessibility text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: CharcoalTagItem(
            label: '#original',
            onPressed: _noop,
            translatedLabel: 'original work',
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      greaterThan(40),
    );
    expect(tester.takeException(), isNull);
  });
}

void _noop() {}
