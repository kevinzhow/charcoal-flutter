import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
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

  testWidgets('uses semantic interaction colors', (tester) async {
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

  testWidgets('selection changes fill without moving the check', (tester) async {
    final theme = CharcoalThemeData.light();
    Widget buildControl({required bool selected}) => charcoalTestApp(
      CharcoalMultiSelect(onChanged: (_) {}, selected: selected),
      theme: theme,
    );

    await tester.pumpWidget(buildControl(selected: false));

    final check = find.descendant(
      of: find.byType(CharcoalMultiSelect),
      matching: find.byType(CharcoalIcon),
    );
    expect(check, findsOneWidget);
    final initialRect = tester.getRect(check);
    final initialIndicator = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    expect(
      (initialIndicator.decoration! as BoxDecoration).color,
      theme.colors.containerNeutralDefault,
    );

    await tester.pumpWidget(buildControl(selected: true));
    await tester.pump();

    expect(check, findsOneWidget);
    expect(tester.getRect(check), initialRect);
    final selectedIndicator = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    expect(
      (selectedIndicator.decoration! as BoxDecoration).color,
      theme.colors.containerPrimaryDefault,
    );
  });

  testWidgets('exposes invalid input semantics', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalMultiSelect(
          invalid: true,
          onChanged: (_) {},
          selected: false,
          semanticLabel: 'Original files',
        ),
      ),
    );

    expect(
      tester.getSemantics(find.byType(CharcoalMultiSelect)),
      matchesSemantics(
        label: 'Original files',
        validationResult: SemanticsValidationResult.invalid,
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('disabled invalid controls suppress interaction rings', (
    tester,
  ) async {
    for (final variant in CharcoalMultiSelectVariant.values) {
      await tester.pumpWidget(
        charcoalTestApp(
          CharcoalMultiSelect(
            invalid: true,
            onChanged: null,
            selected: false,
            semanticLabel: 'Original files',
            variant: variant,
          ),
        ),
      );

      final indicator = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final indicatorDecoration = indicator.decoration! as BoxDecoration;
      expect(indicatorDecoration.boxShadow, isEmpty, reason: '$variant');

      final outer = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(CharcoalMultiSelect),
              matching: find.byType(Container),
            ),
          )
          .singleWhere((container) => container.constraints?.maxWidth == 24);
      final outerDecoration = outer.decoration! as BoxDecoration;
      expect(outerDecoration.boxShadow, isEmpty, reason: '$variant');

      expect(
        tester.getSemantics(find.byType(CharcoalMultiSelect)),
        matchesSemantics(
          label: 'Original files',
          validationResult: SemanticsValidationResult.invalid,
          hasCheckedState: true,
          isChecked: false,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
    }
  });

  testWidgets('keyboard activation requests but does not own the next value', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    bool? requestedValue;

    Widget buildControl({required bool selected}) => charcoalTestApp(
      CharcoalMultiSelect(
        autofocus: true,
        focusNode: focusNode,
        onChanged: (value) => requestedValue = value,
        selected: selected,
        semanticLabel: 'Original files',
      ),
    );

    await tester.pumpWidget(buildControl(selected: false));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(requestedValue, isTrue);
    expect(
      tester.getSemantics(find.byType(CharcoalMultiSelect)),
      matchesSemantics(
        label: 'Original files',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    await tester.pumpWidget(buildControl(selected: true));
    await tester.pump();
    expect(
      tester.getSemantics(find.byType(CharcoalMultiSelect)),
      matchesSemantics(
        label: 'Original files',
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('long labels wrap without resizing the indicator', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        SizedBox(
          width: 160,
          child: CharcoalMultiSelect(
            label: const Text('Include original layered source files'),
            onChanged: (_) {},
            selected: false,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(CharcoalMultiSelect)).width, 160);
    expect(
      tester.getSize(find.byType(AnimatedContainer).first),
      const Size.square(20),
    );
    expect(
      tester.getSize(find.text('Include original layered source files')).height,
      greaterThan(20),
    );
  });

  testWidgets('overlay variant uses the HUD border treatment', (tester) async {
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

    final overlay = tester
        .widgetList<Container>(find.byType(Container))
        .singleWhere((container) => (container.decoration as BoxDecoration?)?.border != null);
    expect(overlay.constraints!.maxWidth, 24);
    expect(overlay.constraints!.maxHeight, 24);
    final decoration = overlay.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(border.top.color, theme.colors.borderHud);
    expect(border.top.width, theme.dimensions.borderWidth.l);
  });
}
