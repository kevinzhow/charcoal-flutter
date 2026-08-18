import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('keyboard activation exposes a bounded pressed pulse', (
    tester,
  ) async {
    final focusNode = FocusNode();
    final statesController = WidgetStatesController();
    var activations = 0;
    addTearDown(focusNode.dispose);
    addTearDown(statesController.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalClickable(
          focusNode: focusNode,
          onPressed: () => activations += 1,
          semanticLabel: 'Run action',
          statesController: statesController,
          builder: (context, states) => SizedBox(
            key: const ValueKey<String>('keyboard-action'),
            width: 120,
            height: 40,
            child: Text(
              states.contains(WidgetState.pressed) ? 'Pressed' : 'Idle',
            ),
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(activations, 1);
    expect(statesController.value, contains(WidgetState.pressed));
    expect(find.text('Pressed'), findsOneWidget);

    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(milliseconds: 99));
    expect(statesController.value, contains(WidgetState.pressed));

    await tester.pump(const Duration(milliseconds: 1));
    expect(statesController.value, isNot(contains(WidgetState.pressed)));
    expect(find.text('Idle'), findsOneWidget);
  });

  testWidgets('keyboardActivationEnabled disables ambient activation', (
    tester,
  ) async {
    final focusNode = FocusNode();
    var activations = 0;
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalClickable(
          focusNode: focusNode,
          keyboardActivationEnabled: false,
          onPressed: () => activations += 1,
          semanticLabel: 'Pointer-only test action',
          builder: (context, states) => const SizedBox(
            key: ValueKey<String>('pointer-only-action'),
            width: 120,
            height: 40,
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(activations, 0);

    final pointerTarget = find.byKey(
      const ValueKey<String>('pointer-only-action'),
    );
    await tester.tapAt(tester.getCenter(pointerTarget));
    await tester.pump();
    expect(activations, 1);
  });

  testWidgets('button controls expose the web button activation intent', (
    tester,
  ) async {
    const buttonKey = ValueKey<String>('button-action');
    const nonButtonKey = ValueKey<String>('non-button-action');
    const tabKey = ValueKey<String>('tab-action');
    await tester.pumpWidget(
      charcoalTestApp(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CharcoalClickable(
              onPressed: () {},
              semanticLabel: 'Button action',
              builder: (context, states) => const SizedBox(
                key: buttonKey,
                width: 120,
                height: 40,
              ),
            ),
            CharcoalClickable(
              onPressed: () {},
              semanticButton: false,
              semanticLabel: 'Check option',
              builder: (context, states) => const SizedBox(
                key: nonButtonKey,
                width: 120,
                height: 40,
              ),
            ),
            CharcoalClickable(
              onPressed: () {},
              semanticButton: false,
              semanticLabel: 'Tab destination',
              semanticRole: SemanticsRole.tab,
              builder: (context, states) => const SizedBox(
                key: tabKey,
                width: 120,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );

    final buttonContext = tester.element(find.byKey(buttonKey));
    final nonButtonContext = tester.element(find.byKey(nonButtonKey));
    final tabContext = tester.element(find.byKey(tabKey));
    expect(
      Actions.maybeFind<ButtonActivateIntent>(buttonContext),
      isNotNull,
    );
    expect(
      Actions.maybeFind<ButtonActivateIntent>(nonButtonContext),
      isNull,
    );
    expect(Actions.maybeFind<ButtonActivateIntent>(tabContext), isNotNull);
    expect(Actions.maybeFind<ActivateIntent>(buttonContext), isNotNull);
    expect(Actions.maybeFind<ActivateIntent>(nonButtonContext), isNotNull);
  });

  testWidgets(
    'web Enter activates buttons and tabs but not check controls',
    (tester) async {
      final buttonFocus = FocusNode();
      final checkFocus = FocusNode();
      final tabFocus = FocusNode();
      var buttonActivations = 0;
      var checkActivations = 0;
      var tabActivations = 0;
      addTearDown(buttonFocus.dispose);
      addTearDown(checkFocus.dispose);
      addTearDown(tabFocus.dispose);
      await tester.pumpWidget(
        charcoalTestApp(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CharcoalClickable(
                focusNode: buttonFocus,
                onPressed: () => buttonActivations += 1,
                semanticLabel: 'Button action',
                builder: (context, states) => const SizedBox(
                  width: 120,
                  height: 40,
                ),
              ),
              CharcoalClickable(
                focusNode: checkFocus,
                onPressed: () => checkActivations += 1,
                semanticButton: false,
                semanticLabel: 'Check option',
                builder: (context, states) => const SizedBox(
                  width: 120,
                  height: 40,
                ),
              ),
              CharcoalClickable(
                focusNode: tabFocus,
                onPressed: () => tabActivations += 1,
                semanticButton: false,
                semanticLabel: 'Tab destination',
                semanticRole: SemanticsRole.tab,
                builder: (context, states) => const SizedBox(
                  width: 120,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      );

      buttonFocus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(buttonActivations, 1);

      checkFocus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(checkActivations, 0);

      tabFocus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(tabActivations, 1);

      await tester.pump(const Duration(milliseconds: 100));
    },
    skip: !kIsWeb,
  );
}
