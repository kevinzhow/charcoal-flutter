import 'dart:ui' show Tristate;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

const _summary = 'Visibility: server only · No description';

Future<void> _mount(
  WidgetTester tester, {
  bool initiallyExpanded = false,
  bool reducedMotion = false,
  TextEditingController? controller,
}) => pumpCharcoal(
  tester,
  MediaQuery(
    data: MediaQueryData(disableAnimations: reducedMotion),
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 480,
        child: CharcoalDisclosure(
          title: 'More options',
          summary: _summary,
          initiallyExpanded: initiallyExpanded,
          child: CharcoalTextField(controller: controller, label: 'Description'),
        ),
      ),
    ),
  ),
);

Finder get _header =>
    find.ancestor(of: find.text('More options'), matching: find.byType(CharcoalClickable));

Tristate _expanded(WidgetTester tester) =>
    tester.getSemantics(_header).getSemanticsData().flagsCollection.isExpanded;

void main() {
  testWidgets('collapsed: title, chevron and summary on one line; the content is hidden', (
    tester,
  ) async {
    await _mount(tester);
    expect(find.text(_summary), findsOneWidget);
    expect(find.byType(CharcoalTextField), findsNothing);
    expect(
      tester.getCenter(find.text(_summary)).dy,
      moreOrLessEquals(tester.getCenter(find.text('More options')).dy, epsilon: 1),
    );
    expect(
      tester.widget<CharcoalIcon>(find.byType(CharcoalIcon)).icon,
      CharcoalIcons16.chevronRight,
    );
    expect(_expanded(tester), Tristate.isFalse);
    final data = tester.getSemantics(_header).getSemanticsData();
    expect(data.label, 'More options\n$_summary');
    expect(data.flagsCollection.isButton, isTrue);
  });

  testWidgets('pressing the line shows the content and hides the summary, and back', (
    tester,
  ) async {
    await _mount(tester);
    await tester.tap(find.text('More options'));
    await tester.pumpAndSettle();
    expect(find.byType(CharcoalTextField), findsOneWidget);
    expect(find.text(_summary), findsNothing);
    expect(
      tester.widget<CharcoalIcon>(find.byType(CharcoalIcon).first).icon,
      CharcoalIcons16.chevronDown,
    );
    expect(_expanded(tester), Tristate.isTrue);
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalDisclosure)));
    expect(
      tester.getTopLeft(find.byType(CharcoalTextField)).dy -
          tester.getBottomLeft(find.text('More options')).dy,
      greaterThanOrEqualTo(theme.space.md),
    );

    await tester.enterText(find.byType(EditableText), 'kept');
    await tester.tap(find.text('More options'));
    await tester.pumpAndSettle();
    expect(find.byType(CharcoalTextField), findsNothing);
    expect(find.text(_summary), findsOneWidget);
    await tester.tap(find.text('More options'));
    await tester.pumpAndSettle();
    expect(find.text('kept'), findsOneWidget, reason: 'collapsing keeps the content state');
  });

  testWidgets('collapsed content cannot take focus', (tester) async {
    await _mount(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(
      tester
          .state<EditableTextState>(find.byType(EditableText, skipOffstage: false))
          .widget
          .focusNode
          .hasFocus,
      isFalse,
    );
  });

  testWidgets('opening animates the height, or jumps under reduced motion', (tester) async {
    for (final reduced in [false, true]) {
      await pumpCharcoal(tester, const SizedBox());
      await _mount(tester, reducedMotion: reduced);
      final closed = tester.getSize(find.byType(CharcoalDisclosure)).height;
      await tester.tap(find.text('More options'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 16));
      final early = tester.getSize(find.byType(CharcoalDisclosure)).height;
      await tester.pumpAndSettle();
      final open = tester.getSize(find.byType(CharcoalDisclosure)).height;
      expect(open, greaterThan(closed));
      if (reduced) {
        expect(early, open, reason: 'reduced motion');
      } else {
        expect(early, lessThan(open), reason: 'animated');
      }
    }
  });

  testWidgets('initiallyExpanded shows the content from the start', (tester) async {
    await _mount(tester, initiallyExpanded: true);
    expect(find.byType(CharcoalTextField), findsOneWidget);
    expect(find.text(_summary), findsNothing);
    expect(_expanded(tester), Tristate.isTrue);
  });
}
