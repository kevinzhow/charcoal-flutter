import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('activates and exposes its label as button semantics', (tester) async {
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
    expect(container.constraints!.maxHeight, 40);
  });
}
