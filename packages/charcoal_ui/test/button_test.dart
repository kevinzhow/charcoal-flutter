import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('invokes onPressed from a pointer tap', (tester) async {
    var pressCount = 0;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () => pressCount += 1,
          child: const Text('Submit'),
        ),
      ),
    );

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(pressCount, 1);
  });

  testWidgets('does not invoke a disabled button', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(const CharcoalButton(onPressed: null, child: Text('Disabled'))),
    );

    await tester.tap(find.text('Disabled'));
    await tester.pump();

    expect(
      tester.getSemantics(find.byType(CharcoalButton)),
      matchesSemantics(isButton: true, hasEnabledState: true, isEnabled: false),
    );
  });

  testWidgets('semantic color overrides propagate into generated component recipes', (
    tester,
  ) async {
    const replacement = Color(0xFF9C27B0);
    final colors = CharcoalGeneratedColorTokens.light.copyWith(
      containerPrimaryDefault: replacement,
    );
    final theme = CharcoalThemeData.light(colors: colors);

    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          variant: CharcoalButtonVariant.primary,
          child: const Text('Primary'),
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, replacement);
  });

  testWidgets('resolves pressed colors from WidgetStatesController', (tester) async {
    final states = WidgetStatesController();
    addTearDown(states.dispose);
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          statesController: states,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Primary'),
        ),
        theme: theme,
      ),
    );

    states.update(WidgetState.pressed, true);
    await tester.pump();

    final container = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.containerPrimaryPress);
  });

  testWidgets('supports the iOS custom primary color', (tester) async {
    const custom = Color(0xFF8A2BE2);
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalButton(
          onPressed: () {},
          primaryColor: custom,
          variant: CharcoalButtonVariant.primary,
          child: const Text('Custom'),
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect((container.decoration! as BoxDecoration).color, custom);
  });

  testWidgets('grows vertically with accessibility text scaling', (
    tester,
  ) async {
    final theme = CharcoalThemeData.light();
    await tester.pumpWidget(
      charcoalTestApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: CharcoalButton(
            onPressed: _noop,
            child: Text('Scaled action'),
          ),
        ),
        theme: theme,
      ),
    );

    expect(
      tester.getSize(find.byType(AnimatedContainer)).height,
      greaterThan(theme.components.button.medium.height),
    );
  });

  testWidgets('switching button keeps the larger layout and selects a child', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const CharcoalSwitchingButton(
          isOn: false,
          offButton: SizedBox(width: 80, height: 32, child: Text('Off')),
          onButton: SizedBox(width: 120, height: 40, child: Text('On')),
        ),
      ),
    );

    expect(tester.getSize(find.byType(IndexedStack)), const Size(120, 40));
    final stack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(stack.index, 1);
  });
}

void _noop() {}
