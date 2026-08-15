import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('exposes checked semantics and changes its selection', (tester) async {
    bool? nextValue;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalMultiSelect(
          label: const Text('Landscape'),
          onChanged: (value) => nextValue = value,
          selected: false,
          semanticLabel: 'Landscape',
        ),
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
    expect(nextValue, isTrue);
  });

  testWidgets('uses generated interaction colors', (tester) async {
    final states = WidgetStatesController(<WidgetState>{WidgetState.pressed});
    addTearDown(states.dispose);
    final theme = CharcoalThemeData.dark();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalMultiSelect(
          onChanged: (_) {},
          selected: false,
          statesController: states,
        ),
        theme: theme,
      ),
    );

    final indicator = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);
    final decoration = indicator.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.containerNeutralPress);
  });

  testWidgets('overlay variant uses the HUD border recipe', (tester) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalMultiSelect(
          onChanged: (_) {},
          selected: false,
          variant: CharcoalMultiSelectVariant.overlay,
        ),
        theme: theme,
      ),
    );

    final indicator = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first);
    final decoration = indicator.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(border.top.color, theme.colors.borderHud);
    expect(border.top.width, theme.dimensions.borderWidth.l);
  });
}
