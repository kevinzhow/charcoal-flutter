import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Future<CharcoalTheme> _mount(WidgetTester tester, Widget card, {double width = 1000}) async {
  await pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: card),
    ),
    size: Size(width + 100, 800),
  );
  return CharcoalTheme.of(tester.element(find.byType(CharcoalSectionCard)));
}

Rect _rect(WidgetTester tester, Finder finder) =>
    tester.getRect(finder).shift(-tester.getTopLeft(find.byType(CharcoalSectionCard)));

double _baseline(WidgetTester tester, Finder text) {
  final box = tester.renderObject<RenderBox>(text);
  return box.localToGlobal(Offset.zero).dy +
      box.getDryBaseline(box.constraints, TextBaseline.alphabetic)!;
}

Widget _block(String key) => SizedBox(key: Key(key), height: 40);

void main() {
  testWidgets('header: title, caption below it, actions at the end on the title baseline', (
    tester,
  ) async {
    final theme = await _mount(
      tester,
      CharcoalSectionCard(
        title: 'Rules',
        caption: 'Checked from top to bottom',
        actions: [
          CharcoalButton(
            size: CharcoalButtonSize.small,
            onPressed: () {},
            child: const Text('Add rule'),
          ),
        ],
        children: [_block('body')],
      ),
    );
    final inset = theme.space.xl;
    final title = _rect(tester, find.text('Rules'));
    final caption = _rect(tester, find.text('Checked from top to bottom'));
    final action = _rect(tester, find.byType(CharcoalButton));

    expect(title.left, inset);
    expect(caption.left, inset);
    expect(caption.top, title.bottom + theme.space.xxs);
    expect(action.right, 1000 - inset);
    expect(
      _baseline(tester, find.text('Add rule')),
      moreOrLessEquals(_baseline(tester, find.text('Rules')), epsilon: 0.5),
    );
    expect(action.top, lessThan(caption.top), reason: 'aligned with the title, not the caption');
    expect(
      tester.getSemantics(find.text('Rules')),
      matchesSemantics(label: 'Rules', isHeader: true),
    );
  });

  testWidgets('body shares the header inset; a narrow card uses the compact inset', (
    tester,
  ) async {
    for (final (width, step) in [(1000.0, CharcoalSpace.xl), (600.0, CharcoalSpace.lg)]) {
      final theme = await _mount(
        tester,
        CharcoalSectionCard(title: 'Settings', children: [_block('body')]),
        width: width,
      );
      final inset = step.of(theme.space);
      final body = _rect(tester, find.byKey(const Key('body')));
      expect(_rect(tester, find.text('Settings')).left, inset, reason: '$width');
      expect(body.left, inset, reason: '$width');
      expect(body.right, width - inset, reason: '$width');
    }
  });

  testWidgets('flush children reach the card edges and run under the outline', (tester) async {
    await _mount(
      tester,
      CharcoalSectionCard(title: 'Members', flush: true, children: [_block('table')]),
    );
    final table = _rect(tester, find.byKey(const Key('table')));
    final card = _rect(tester, find.byType(CharcoalSectionCard));
    expect(table.left, 0);
    expect(table.right, card.right);
    expect(table.bottom, card.bottom);
    expect(
      find.ancestor(of: find.byKey(const Key('table')), matching: find.byType(ClipRRect)),
      findsOneWidget,
    );
  });

  for (final flush in [false, true]) {
    testWidgets('children are separated by a gap or a divider (flush: $flush)', (tester) async {
      for (final dividers in [false, true]) {
        final theme = await _mount(
          tester,
          CharcoalSectionCard(
            title: 'Settings',
            dividers: dividers,
            flush: flush,
            children: [_block('a'), _block('b'), _block('c')],
          ),
        );
        final space = theme.space;
        final hairline = theme.borders.hairline;
        final gap =
            _rect(tester, find.byKey(const Key('b'))).top -
            _rect(tester, find.byKey(const Key('a'))).bottom;
        final expected = switch ((flush, dividers)) {
          (false, false) => space.md,
          (false, true) => space.md + hairline + space.md,
          (true, false) => 0.0,
          (true, true) => hairline,
        };
        expect(gap, expected, reason: 'dividers: $dividers');
        // One divider under the header, then one per gap.
        expect(find.byType(CharcoalDivider), findsNWidgets(dividers ? 3 : 1));
      }
    });
  }

  testWidgets('a card without children is a header alone', (tester) async {
    final theme = await _mount(
      tester,
      CharcoalSectionCard(
        title: 'Kill switch',
        caption: 'Turning it off serves the default to everyone.',
        actions: [CharcoalSwitch(value: true, onChanged: (_) {})],
        children: const [],
      ),
    );
    expect(find.byType(CharcoalDivider), findsNothing);
    final card = _rect(tester, find.byType(CharcoalSectionCard));
    final caption = _rect(tester, find.text('Turning it off serves the default to everyone.'));
    expect(card.bottom - caption.bottom, theme.space.lg);
  });

  testWidgets('danger zone: negative action that reports presses, disabled without a callback', (
    tester,
  ) async {
    var presses = 0;
    final theme = await _mount(
      tester,
      CharcoalDangerZone(
        title: 'Delete flag',
        description: 'Its 2 rules are deleted too.',
        actionLabel: 'Delete',
        onPressed: () => presses++,
      ),
    );
    expect(find.text('Its 2 rules are deleted too.'), findsOneWidget);
    expect(
      tester.widget<CharcoalButton>(find.byType(CharcoalButton)).labelTone,
      CharcoalTextTone.negative,
    );
    final label = tester.renderObject<RenderParagraph>(find.text('Delete'));
    expect(label.text.style?.color, theme.colors.textNegative);
    await tester.tap(find.text('Delete'));
    expect(presses, 1);

    await _mount(
      tester,
      const CharcoalDangerZone(
        title: 'Delete flag',
        description: 'Its 2 rules are deleted too.',
        actionLabel: 'Delete',
        onPressed: null,
      ),
    );
    expect(
      tester.getSemantics(find.byType(CharcoalButton)),
      matchesSemantics(
        label: 'Delete',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        isFocusable: false,
      ),
    );
  });
}
