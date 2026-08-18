import 'dart:ui' show Tristate;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/action_controls_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/async_action_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/button_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/carousel_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/clickable_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/dropdown_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/feedback_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/form_guidance_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/modal_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/multi_select_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/navigation_item_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/overlay_controls_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/pagination_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/selection_controls_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/segmented_control_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/tag_item_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/text_field_example.dart';
import 'package:charcoal_ui_showcase/agent_examples/theme_typography_example.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('scoped theme updates semantic and truncated typography', (
    tester,
  ) async {
    const example = AgentThemeTypographyExample();
    const fullTitle =
        'Complete project title: Moonlit Garden Archive for the Northern Collection';
    Widget specimen() => const SingleChildScrollView(
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: example,
      ),
    );
    await tester.pumpWidget(_testApp(specimen(), width: 240));

    expect(
      CharcoalTheme.of(tester.element(find.text('Project typography')))
          .brightness,
      Brightness.light,
    );
    expect(find.semantics.byLabel(fullTitle), findsOne);
    expect(find.text('Previewing light theme.'), findsOneWidget);

    final previewDark = find.bySemanticsLabel('Preview dark theme');
    await tester.ensureVisible(previewDark);
    await tester.pump();
    await tester.tap(previewDark);
    await tester.pump();

    expect(
      CharcoalTheme.of(tester.element(find.text('Project typography')))
          .brightness,
      Brightness.dark,
    );
    expect(find.text('Previewing dark theme.'), findsOneWidget);

    await tester.pumpWidget(_testApp(specimen(), width: 520));
    await tester.pump();
    expect(find.text('Previewing dark theme.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('async action blocks stale input and records each result', (
    tester,
  ) async {
    const example = AgentAsyncActionExample();
    await tester.pumpWidget(_testApp(example, width: 240));

    await tester.tap(find.bySemanticsLabel('Publish draft'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.semantics.byLabel('Publishing draft'), findsOne);
    expect(find.semantics.byLabel('Publish draft'), findsNothing);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(find.text('Draft published.'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Return published item to draft'),
      findsOneWidget,
    );

    await tester.pumpWidget(_testApp(example, width: 520));
    await tester.pump();
    expect(find.text('Draft published.'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Return published item to draft'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.semantics.byLabel('Returning draft to private'), findsOne);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump();
    expect(find.text('Draft returned to private.'), findsOneWidget);
    expect(find.bySemanticsLabel('Publish draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('action controls distinguish one-shot and toggle semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const AgentActionControlsExample(), width: 360),
    );

    final regularAction = find.bySemanticsLabel('Search related items');
    final saveAction = find.bySemanticsLabel('Save item');
    expect(
      tester.getSemantics(regularAction).flagsCollection.isSelected,
      Tristate.none,
    );
    expect(
      tester.getSemantics(saveAction).flagsCollection.isSelected,
      Tristate.isFalse,
    );

    await tester.tap(saveAction);
    await tester.pump();

    final removeAction = find.bySemanticsLabel('Remove saved item');
    expect(find.text('Item saved'), findsOneWidget);
    expect(
      tester.getSemantics(removeAction).flagsCollection.isSelected,
      Tristate.isTrue,
    );

    await tester.tap(find.text('Clear filters'));
    await tester.pump();
    expect(find.text('Filters cleared'), findsOneWidget);
  });

  testWidgets('overlay example shares controlled state across keyboard paths', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const AgentOverlayControlsExample(), width: 360),
    );

    expect(
      find.text('Drafts remain private until you publish.'),
      findsOneWidget,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(
      find.text('Only workspace owners can publish this draft.'),
      findsOneWidget,
    );
    expect(find.text('Publishing details open'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(
      find.text('Only workspace owners can publish this draft.'),
      findsNothing,
    );
    expect(find.text('Publishing details closed'), findsOneWidget);
  });

  testWidgets('whole-surface action preserves geometry during keyboard press', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const AgentClickableSurfaceExample(), width: 360),
    );

    final action = find.bySemanticsLabel('Open Moonlit Lake project');
    final initialRect = tester.getRect(action);
    expect(find.text('No project opened'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
    await tester.pump();

    expect(find.text('Moonlit Lake opened'), findsOneWidget);
    expect(tester.getRect(action), initialRect);

    await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
    await tester.pump(const Duration(milliseconds: 100));
  });

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

  testWidgets('selection control example keeps all values parent-owned', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const AgentSelectionControlsExample(), width: 360),
    );

    expect(
      tester.widget<CharcoalCheckbox>(find.byType(CharcoalCheckbox)).value,
      isTrue,
    );
    await tester.tap(find.text('Save drafts automatically'));
    await tester.pump();
    expect(
      tester.widget<CharcoalCheckbox>(find.byType(CharcoalCheckbox)).value,
      isFalse,
    );

    await tester.tap(find.text('Only me'));
    await tester.pump();
    final radioFinder = find.byWidgetPredicate(
      (widget) => widget is CharcoalRadio<dynamic>,
    );
    final radios = tester
        .widgetList<CharcoalRadio<dynamic>>(radioFinder)
        .toList();
    expect(radios, hasLength(3));
    expect(
      radios.where((radio) => radio.value == radio.groupValue),
      hasLength(1),
    );
    expect(radios.last.value, radios.last.groupValue);

    expect(
      tester.widget<CharcoalSwitch>(find.byType(CharcoalSwitch)).value,
      isTrue,
    );
    await tester.tap(find.text('Release notifications'));
    await tester.pump();
    expect(
      tester.widget<CharcoalSwitch>(find.byType(CharcoalSwitch)).value,
      isFalse,
    );
  });

  testWidgets('multi-select group owns one set and actionable validation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const AgentMultiSelectExample(), width: 360),
    );

    List<CharcoalMultiSelect> controls() => tester
        .widgetList<CharcoalMultiSelect>(find.byType(CharcoalMultiSelect))
        .toList();

    expect(controls().where((control) => control.selected), hasLength(1));
    await tester.tap(find.text('Original files'));
    await tester.pump();
    expect(controls().where((control) => control.selected), isEmpty);

    await tester.tap(find.text('Prepare export'));
    await tester.pump();
    expect(find.text('Select at least one content type.'), findsOneWidget);
    for (var index = 0; index < controls().length; index++) {
      expect(
        tester
            .getSemantics(find.byType(CharcoalMultiSelect).at(index))
            .validationResult,
        SemanticsValidationResult.invalid,
      );
    }

    await tester.tap(find.text('Source metadata'));
    await tester.pump();
    expect(find.text('Select at least one content type.'), findsNothing);
    expect(controls().where((control) => control.selected), hasLength(1));

    await tester.tap(find.text('Prepare export'));
    await tester.pump();
    expect(find.text('Export prepared with 1 content type.'), findsOneWidget);
  });

  testWidgets('pagination adapts and keeps page state parent-owned', (
    tester,
  ) async {
    const example = AgentPaginationExample();
    await tester.pumpWidget(_testApp(example, width: 320));

    expect(
      tester
          .widget<CharcoalPagination>(find.byType(CharcoalPagination))
          .currentPage,
      8,
    );
    expect(find.text('Results 71–80 of 194. Page 8 of 20.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      Navigator.of(tester.element(find.byType(AgentPaginationExample)))
          .canPop(),
      isFalse,
    );

    await tester.tap(find.bySemanticsLabel('Next result page'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<CharcoalPagination>(find.byType(CharcoalPagination))
          .currentPage,
      9,
    );
    expect(find.text('Results 81–90 of 194. Page 9 of 20.'), findsOneWidget);

    await tester.pumpWidget(_testApp(example, width: 640));
    await tester.pump();
    expect(
      tester
          .widget<CharcoalPagination>(find.byType(CharcoalPagination))
          .currentPage,
      9,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('carousel preserves reported page across responsive modes', (
    tester,
  ) async {
    const example = AgentCarouselExample();
    await tester.pumpWidget(_testApp(example, width: 320));

    expect(
      tester.widget<CharcoalCarousel>(find.byType(CharcoalCarousel)).size,
      CharcoalCarouselSize.small,
    );
    expect(find.text('Guide 1 of 4: Build a calm first run'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(CharcoalCarousel)).label,
      'Featured guides',
    );
    expect(
      Navigator.of(tester.element(find.byType(AgentCarouselExample))).canPop(),
      isFalse,
    );

    await tester.drag(find.byType(PageView), const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(find.text('Guide 2 of 4: Keep navigation truthful'), findsOneWidget);

    await tester.pumpWidget(_testApp(example, width: 640));
    await tester.pumpAndSettle();
    expect(
      tester.widget<CharcoalCarousel>(find.byType(CharcoalCarousel)).size,
      CharcoalCarouselSize.medium,
    );
    expect(find.text('Guide 2 of 4: Keep navigation truthful'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tag filters keep selection in one parent at compact width', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const AgentTagItemExample(), width: 240));

    expect(find.byType(CharcoalTagItem), findsNWidgets(4));
    expect(find.text('1 filter selected'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('landscape tag filter'))
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    expect(
      Navigator.of(tester.element(find.byType(AgentTagItemExample))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.bySemanticsLabel('original tag filter'));
    await tester.pumpAndSettle();

    expect(find.text('2 filters selected'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('original tag filter'))
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );

    await tester.tap(find.bySemanticsLabel('landscape tag filter'));
    await tester.pumpAndSettle();
    expect(find.text('1 filter selected'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('landscape tag filter'))
          .flagsCollection
          .isSelected,
      Tristate.isFalse,
    );
  });

  testWidgets('form guidance separates visible metadata from input semantics', (
    tester,
  ) async {
    const example = AgentFormGuidanceExample();
    await tester.pumpWidget(_testApp(example, width: 240));

    expect(find.byType(CharcoalFieldLabel), findsOneWidget);
    expect(find.byType(CharcoalHintText), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Public'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      tester.getSemantics(find.byType(CharcoalTextField)),
      isSemantics(
        label: 'Portfolio URL',
        isTextField: true,
        hasEnabledState: true,
        isEnabled: true,
        hasRequiredState: true,
        isRequired: true,
      ),
    );
    expect(
      Navigator.of(tester.element(find.byType(AgentFormGuidanceExample)))
          .canPop(),
      isFalse,
    );

    await tester.tap(find.text('Use example'));
    await tester.pumpAndSettle();

    expect(find.byType(CharcoalHintText), findsOneWidget);
    expect(find.text('Use example'), findsNothing);
    expect(find.text('Add a complete URL including https://.'), findsNothing);
    expect(find.text('Example portfolio URL applied.'), findsOneWidget);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      'https://example.com/portfolio',
    );

    await tester.pumpWidget(_testApp(example, width: 640));
    await tester.pump();
    expect(find.text('Example portfolio URL applied.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adaptive destinations share state without pushing a route', (
    tester,
  ) async {
    const example = AgentNavigationItemExample();
    await tester.pumpWidget(_testApp(example, width: 720));

    expect(find.byType(CharcoalNavigationItem), findsNWidgets(3));
    expect(
      Navigator.of(tester.element(find.byType(AgentNavigationItemExample)))
          .canPop(),
      isFalse,
    );

    await tester.tap(find.text('Discover'));
    await tester.pump();

    expect(find.text('Current destination: discover'), findsOneWidget);
    expect(
      tester
          .getSemantics(find.widgetWithText(CharcoalNavigationItem, 'Home'))
          .flagsCollection
          .isSelected,
      Tristate.isFalse,
    );
    expect(
      tester
          .getSemantics(find.widgetWithText(CharcoalNavigationItem, 'Discover'))
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    expect(
      Navigator.of(tester.element(find.byType(AgentNavigationItemExample)))
          .canPop(),
      isFalse,
    );

    await tester.pumpWidget(_testApp(example, width: 390));

    expect(find.byType(CharcoalNavigationItem), findsNothing);
    expect(
      find.byWidgetPredicate((widget) => widget is CharcoalTabBar<dynamic>),
      findsOneWidget,
    );
    expect(find.text('Current destination: discover'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(find.text('Current destination: home'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(AgentNavigationItemExample)))
          .canPop(),
      isFalse,
    );
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
