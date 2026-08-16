import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/button_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/dropdown_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/feedback_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/modal_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/segmented_control_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/text_field_example.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('button example adapts and invokes both actions', (tester) async {
    var continued = 0;
    var cancelled = 0;
    final example = AgentButtonExample(
      onCancel: () => cancelled++,
      onContinue: () => continued++,
    );

    await tester.pumpWidget(_testApp(example, width: 320));
    expect(
      tester
          .widget<CharcoalButton>(
            find.widgetWithText(CharcoalButton, 'Continue'),
          )
          .fullWidth,
      isTrue,
    );
    await tester.tap(find.text('Continue'));
    await tester.tap(find.text('Cancel'));
    expect((continued, cancelled), (1, 1));

    await tester.pumpWidget(_testApp(example, width: 640));
    expect(
      tester
          .widget<CharcoalButton>(
            find.widgetWithText(CharcoalButton, 'Continue'),
          )
          .fullWidth,
      isFalse,
    );
  });

  testWidgets('text field example updates its validation guidance', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const AgentTextFieldExample(), width: 360),
    );

    await tester.enterText(find.byType(EditableText), 'a');
    await tester.pump();

    expect(find.text('Use at least 3 characters.'), findsOneWidget);
  });

  testWidgets('selection examples render and accept interaction', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const AgentDropdownExample(), width: 360));
    expect(find.text('Everyone'), findsOneWidget);

    await tester.pumpWidget(
      _testApp(const AgentSegmentedControlExample(), width: 360),
    );
    await tester.tap(find.text('Popular'));
    await tester.pump();
    expect(find.text('Popular'), findsOneWidget);
  });

  testWidgets('modal example opens and closes an adaptive Charcoal modal', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const AgentModalExample(), width: 360));

    await tester.tap(find.text('Review changes'));
    await tester.pumpAndSettle();
    expect(find.text('Done'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Done'), findsNothing);
  });

  testWidgets(
    'feedback example inserts and removes toast and snackbar overlays',
    (tester) async {
      await tester.pumpWidget(
        _testApp(const AgentFeedbackExample(), width: 360),
      );

      await tester.tap(find.text('Show toast'));
      await tester.pump();
      expect(find.text('Changes saved'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show snackbar'));
      await tester.pump();
      expect(find.text('Draft restored'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
  );
}

Widget _testApp(Widget child, {required double width}) {
  final theme = CharcoalThemeData.light();
  return WidgetsApp(
    color: theme.colors.containerPrimaryDefault,
    home: CharcoalTheme(
      data: theme,
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
  );
}
