import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
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

  testWidgets('checkbox and radio expose invalid input semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        Column(
          children: <Widget>[
            CharcoalCheckbox(
              value: false,
              invalid: true,
              onChanged: (_) {},
              semanticLabel: 'Accept terms',
            ),
            CharcoalRadio<String>(
              value: 'public',
              groupValue: 'private',
              invalid: true,
              onChanged: (_) {},
              semanticLabel: 'Public',
            ),
          ],
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalCheckbox)),
      matchesSemantics(
        label: 'Accept terms',
        validationResult: SemanticsValidationResult.invalid,
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.byType(CharcoalRadio<String>)),
      matchesSemantics(
        label: 'Public',
        validationResult: SemanticsValidationResult.invalid,
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        isInMutuallyExclusiveGroup: true,
        hasTapAction: true,
      ),
    );
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

    final track = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(track.constraints!.maxWidth, 51);
    expect(track.constraints!.maxHeight, 31);
    expect(track.padding, const EdgeInsets.all(2));
    expect(
      tester.getSize(
        find
            .descendant(
              of: find.byType(AnimatedAlign),
              matching: find.byType(SizedBox),
            )
            .first,
      ),
      const Size.square(27),
    );
  });

  testWidgets('switch supports keyboard activation', (tester) async {
    bool? nextValue;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalSwitch(
          value: true,
          focusNode: focusNode,
          onChanged: (value) => nextValue = value,
          label: const Text('Notifications'),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(nextValue, isFalse);
  });

  testWidgets('switch disabled opacity applies only to the control', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalSwitch(
          value: false,
          onChanged: null,
          label: Text('Always readable'),
        ),
      ),
    );

    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0.32,
    );
    expect(
      find.ancestor(
        of: find.text('Always readable'),
        matching: find.byType(AnimatedOpacity),
      ),
      findsNothing,
    );
    expect(
      tester.getSemantics(find.byType(CharcoalSwitch)),
      matchesSemantics(
        label: 'Always readable',
        hasEnabledState: true,
        isEnabled: false,
        hasToggledState: true,
        isToggled: false,
      ),
    );
  });

  testWidgets('checkbox pressed state uses semantic source colors', (tester) async {
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

  testWidgets('unchecked checkbox keeps the 20 px transparent body', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalCheckbox(value: false, onChanged: (_) {}),
        theme: theme,
      ),
    );

    final indicator = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = indicator.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(indicator.constraints!.maxWidth, 20);
    expect(indicator.constraints!.maxHeight, 20);
    expect(decoration.color, theme.colors.containerDefaultA);
    expect(decoration.borderRadius, BorderRadius.circular(4));
    expect(border.top.color, theme.colors.borderDefault);
    expect(border.top.width, 2);
  });

  testWidgets('selected radio uses the 20 px body and 8 px dot', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalRadio<String>(
          value: 'public',
          groupValue: 'public',
          onChanged: (_) {},
        ),
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect(containers.first.constraints!.maxWidth, 20);
    expect(containers.first.constraints!.maxHeight, 20);
    expect(containers.last.constraints!.maxWidth, 8);
    expect(containers.last.constraints!.maxHeight, 8);
  });

  testWidgets('unselected radio uses the source default border', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalRadio<String>(
          value: 'public',
          groupValue: 'private',
          onChanged: (_) {},
        ),
        theme: theme,
      ),
    );

    final indicator = tester
        .widgetList<AnimatedContainer>(
          find.byType(AnimatedContainer),
        )
        .first;
    final decoration = indicator.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(border.top.color, theme.colors.borderDefault);
    expect(border.top.width, theme.dimensions.borderWidth.l);
  });
}
