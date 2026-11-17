import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Future<CharcoalTheme> _mount(
  WidgetTester tester, {
  bool compact = false,
  bool back = false,
  List<Widget> meta = const [],
}) async {
  await pumpCharcoal(
    tester,
    CharcoalPage(
      compact: compact,
      showBack: back,
      title: 'transcribe.endpoint',
      subtitle: 'Which endpoint new transcriptions use',
      meta: meta,
      actions: [
        CharcoalButton(
          size: CharcoalButtonSize.small,
          onPressed: () {},
          child: const Text('Audit log'),
        ),
      ],
      child: const CharcoalText('Body'),
    ),
    size: compact ? const Size(420, 800) : const Size(1200, 800),
  );
  return CharcoalTheme.of(tester.element(find.byType(CharcoalPage)));
}

const _meta = <Widget>[
  CharcoalChip('String'),
  CharcoalChip('Server only'),
  CharcoalCopyableText(text: 'FC055F80', copyLabel: 'Copy ID', copiedMessage: 'ID copied'),
];

void main() {
  testWidgets('actions align with the top of the title, not the bottom of the subtitle', (
    tester,
  ) async {
    await _mount(tester, meta: _meta);
    expect(
      tester.getTopLeft(find.byType(CharcoalButton)).dy,
      tester.getTopLeft(find.text('transcribe.endpoint')).dy,
    );
  });

  testWidgets('with a back link the actions align with the top of the header', (tester) async {
    await _mount(tester, back: true);
    expect(
      tester.getTopLeft(find.byType(CharcoalButton)).dy,
      tester.getTopLeft(find.text('Back')).dy,
    );
  });

  testWidgets('meta wraps in one row under the subtitle', (tester) async {
    final theme = await _mount(tester, meta: _meta);
    final subtitle = tester.getRect(find.text('Which endpoint new transcriptions use'));
    final first = tester.getRect(find.text('String'));
    final id = tester.getRect(find.text('FC055F80'));
    final rowTop = [
      tester.getTopLeft(find.byType(CharcoalChip).first).dy,
      tester.getTopLeft(find.byType(CharcoalCopyableText)).dy,
    ].reduce((a, b) => a < b ? a : b);
    expect(rowTop, subtitle.bottom + theme.space.sm);
    expect(tester.getTopLeft(find.byType(CharcoalChip).first).dx, subtitle.left);
    expect(id.center.dy, moreOrLessEquals(first.center.dy, epsilon: 1), reason: 'one row');
    expect(
      tester.getTopLeft(find.text('Body')).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(find.byType(CharcoalCopyableText)).dy),
    );
  });

  testWidgets('without meta the header keeps its subtitle-to-content spacing', (tester) async {
    final theme = await _mount(tester);
    final subtitle = tester.getRect(find.text('Which endpoint new transcriptions use'));
    expect(tester.getTopLeft(find.text('Body')).dy, subtitle.bottom + theme.space.xl);
  });

  testWidgets('compact: meta wraps above the actions', (tester) async {
    final theme = await _mount(tester, compact: true, meta: _meta);
    final meta = tester.getRect(find.byType(CharcoalCopyableText));
    final action = tester.getRect(find.byType(CharcoalButton));
    expect(action.top, greaterThanOrEqualTo(meta.bottom + theme.space.md));
    expect(tester.takeException(), isNull);
  });
}
