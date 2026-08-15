import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('checkbox exposes checked semantics and toggles', (tester) async {
    bool? nextValue;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalCheckbox(
          value: false,
          onChanged: (value) => nextValue = value,
          semanticLabel: 'Accept terms',
          label: const Text('Accept terms'),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalCheckbox)),
      matchesSemantics(
        label: 'Accept terms',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.text('Accept terms'));
    expect(nextValue, isTrue);
  });

  testWidgets('radio reports its value when selected', (tester) async {
    String? nextValue;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalRadio<String>(
          value: 'public',
          groupValue: 'private',
          onChanged: (value) => nextValue = value,
          label: const Text('Public'),
        ),
      ),
    );

    await tester.tap(find.text('Public'));
    expect(nextValue, 'public');
  });

  testWidgets('switch exposes toggled semantics and toggles', (tester) async {
    bool? nextValue;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalSwitch(
          value: true,
          onChanged: (value) => nextValue = value,
          semanticLabel: 'Notifications',
          label: const Text('Notifications'),
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalSwitch)),
      matchesSemantics(
        label: 'Notifications',
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        hasToggledState: true,
        isToggled: true,
      ),
    );

    await tester.tap(find.text('Notifications'));
    expect(nextValue, isFalse);
    expect(
      tester.getCenter(find.text('Notifications')).dx,
      lessThan(tester.getCenter(find.byType(AnimatedAlign)).dx),
    );
  });

  testWidgets('checkbox pressed state uses generated recipe colors', (tester) async {
    final states = WidgetStatesController(<WidgetState>{WidgetState.pressed});
    addTearDown(states.dispose);
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalCheckbox(
          value: true,
          onChanged: (_) {},
          statesController: states,
        ),
        theme: theme,
      ),
    );

    final indicator = tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer)).first;
    final decoration = indicator.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.containerPrimaryPress);
  });
}
