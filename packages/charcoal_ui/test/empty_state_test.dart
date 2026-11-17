import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

const _steps = <CharcoalEmptyStateStep>[
  CharcoalEmptyStateStep(title: 'Create', description: 'Only a name is needed'),
  CharcoalEmptyStateStep(title: 'Match', description: 'Add members or conditions'),
  CharcoalEmptyStateStep(title: 'Use'),
];

Future<CharcoalTheme> _mount(WidgetTester tester, {double width = 900, Widget? state}) async {
  await pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        child:
            state ??
            CharcoalEmptyState(
              icon: CharcoalIcons.persons,
              title: 'No segments yet',
              message: 'Flag rules target a segment.',
              actions: [CharcoalButton(onPressed: () {}, child: const Text('New segment'))],
              steps: _steps,
            ),
      ),
    ),
    size: Size(width + 100, 800),
  );
  return CharcoalTheme.of(tester.element(find.byType(CharcoalEmptyState)));
}

void main() {
  testWidgets('title, message, actions and numbered steps stack in order', (tester) async {
    final theme = await _mount(tester);
    final title = tester.getRect(find.text('No segments yet'));
    final message = tester.getRect(find.text('Flag rules target a segment.'));
    final action = tester.getRect(find.byType(CharcoalButton));
    final first = tester.getRect(find.text('1 Create'));
    expect(message.top, title.bottom + theme.space.xs);
    expect(action.top, greaterThan(message.bottom));
    expect(first.top, action.bottom + theme.space.xl);
    expect(find.text('2 Match'), findsOneWidget);
    expect(find.text('3 Use'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('No segments yet')),
      matchesSemantics(label: 'No segments yet', isHeader: true),
    );
    expect(
      tester.widget<Text>(find.text('No segments yet')).style,
      theme.style(CharcoalTextRole.sectionTitle),
    );
  });

  testWidgets('steps are equal columns in one centred row when they fit', (tester) async {
    final theme = await _mount(tester);
    final width = theme.sizes.fieldWidthCompact;
    final lefts = [
      for (final text in ['1 Create', '2 Match', '3 Use']) tester.getTopLeft(find.text(text)).dx,
    ];
    expect(lefts[1] - lefts[0], width + theme.space.xl);
    expect(lefts[2] - lefts[1], width + theme.space.xl);
    final row = lefts[2] + width - lefts[0];
    final center = tester.getCenter(find.byType(CharcoalEmptyState)).dx;
    expect(lefts[0] + row / 2, moreOrLessEquals(center, epsilon: 0.5));
    expect(
      tester.getTopLeft(find.text('Only a name is needed')).dx,
      lefts[0],
      reason: 'a step reads from its start edge',
    );
  });

  testWidgets('a narrow empty state stacks the steps without overflow', (tester) async {
    await _mount(tester, width: 320);
    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('2 Match')).dy,
      greaterThan(tester.getBottomLeft(find.text('Only a name is needed')).dy),
    );
  });

  testWidgets('existing callers keep the message-only layout', (tester) async {
    final theme = await _mount(
      tester,
      state: const CharcoalEmptyState(icon: CharcoalIcons.persons, message: 'Nothing here'),
    );
    final icon = tester.getRect(find.byType(CharcoalIcon));
    expect(tester.getTopLeft(find.text('Nothing here')).dy, icon.bottom + theme.space.sm);
    expect(find.byType(Wrap), findsNothing);
  });
}
