import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

const _title = 'Super-user mode';
const _message = 'Every action is recorded as the super user.';

Widget _bar({CharcoalTone tone = CharcoalTone.notice, bool message = true}) => CharcoalModeBar(
  title: _title,
  message: message ? _message : null,
  tone: tone,
  actions: [
    CharcoalButton(size: CharcoalButtonSize.small, onPressed: () {}, child: const Text('Exit')),
  ],
);

Future<CharcoalTheme> _mount(WidgetTester tester, Widget bar, {double width = 1400}) async {
  await pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: bar),
    ),
    size: Size(width, 600),
  );
  return CharcoalTheme.of(tester.element(find.byType(CharcoalModeBar)));
}

Rect _rect(WidgetTester tester, Finder finder) =>
    tester.getRect(finder).shift(-tester.getTopLeft(find.byType(CharcoalModeBar)));

Color _textColor(WidgetTester tester, String text) => tester
    .widget<RichText>(find.descendant(of: find.text(text), matching: find.byType(RichText)).first)
    .text
    .style!
    .color!;

void main() {
  testWidgets('spans its parent in the tone fill: icon, title, message, then the actions', (
    tester,
  ) async {
    final theme = await _mount(tester, _bar());
    final colors = theme.colors;
    final bar = _rect(tester, find.byType(CharcoalModeBar));
    expect(bar.width, 1400);
    expect(
      tester
          .widget<ColoredBox>(
            find
                .descendant(of: find.byType(CharcoalModeBar), matching: find.byType(ColoredBox))
                .first,
          )
          .color,
      colors.notice,
    );
    expect(_textColor(tester, _title), colors.textOnNotice);
    expect(_textColor(tester, _message), colors.textOnNotice);
    expect(tester.widget<CharcoalIcon>(find.byType(CharcoalIcon).first).color, colors.iconOnNotice);

    final icon = _rect(tester, find.byType(CharcoalIcon).first);
    final title = _rect(tester, find.text(_title));
    final message = _rect(tester, find.text(_message));
    final exit = _rect(tester, find.byType(CharcoalButton));
    expect(icon.left, theme.space.xl);
    expect(title.left - icon.right, theme.space.md);
    expect(message.left - title.right, theme.space.md, reason: 'the message follows the title');
    expect(exit.right, 1400 - theme.space.xl);
    expect(bar.height, theme.sizes.rowMinHeightCompact);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a narrow bar uses the compact inset and wraps the message under the title', (
    tester,
  ) async {
    final theme = await _mount(tester, _bar(), width: 420);
    final title = _rect(tester, find.text(_title));
    final message = _rect(tester, find.text(_message));
    final exit = _rect(tester, find.byType(CharcoalButton));
    expect(_rect(tester, find.byType(CharcoalIcon).first).left, theme.space.lg);
    expect(exit.right, 420 - theme.space.lg);
    expect(message.left, title.left);
    expect(message.top, greaterThanOrEqualTo(title.bottom));
    expect(message.right, lessThanOrEqualTo(exit.left - theme.space.md));
    expect(tester.takeException(), isNull);
  });

  testWidgets('at a phone width and double text the actions shorten instead of overflowing', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalModeBar(
          title: _title,
          message: _message,
          actions: [
            CharcoalButton(
              size: CharcoalButtonSize.small,
              onPressed: () {},
              child: const Text('Exit super-user mode'),
            ),
          ],
        ),
      ),
      size: const Size(320, 600),
      textScale: 2,
    );
    final exit = tester.getRect(find.byType(CharcoalButton));
    expect(exit.right, lessThanOrEqualTo(320));
    expect(tester.takeException(), isNull);
  });

  testWidgets('one container named by the title; the message and the action stay inside it', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _mount(tester, _bar());
    final node = tester.getSemantics(find.byType(CharcoalModeBar));
    expect(node.label, _title);
    final children = <SemanticsNode>[];
    node.visitChildren((child) {
      children.add(child);
      return true;
    });
    final labels = [
      for (final child in children) ...[child.label, ..._labels(child)],
    ];
    expect(labels, contains(_message));
    expect(labels, contains('Exit'));
    expect(labels.where((label) => label == _title), isEmpty, reason: 'the title is read once');
    handle.dispose();
  });

  testWidgets('the tone picks the solid fill and the colour on it', (tester) async {
    final theme = await _mount(tester, _bar(tone: CharcoalTone.info, message: false));
    expect(
      tester
          .widget<ColoredBox>(
            find
                .descendant(of: find.byType(CharcoalModeBar), matching: find.byType(ColoredBox))
                .first,
          )
          .color,
      theme.colors.primary,
    );
    expect(_textColor(tester, _title), theme.colors.textOnPrimary);
    expect(
      tester.widget<CharcoalIcon>(find.byType(CharcoalIcon).first).icon,
      CharcoalIcons.warnTriangle,
    );
  });

  testWidgets('a notice page under the bar takes the notice surface', (tester) async {
    await pumpCharcoal(
      tester,
      CharcoalScaffold(
        background: CharcoalPageBackground.notice,
        body: Column(
          children: [
            _bar(),
            const Expanded(child: SizedBox.expand()),
          ],
        ),
      ),
      size: const Size(1200, 600),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalModeBar)));
    final page = tester.widget<ColoredBox>(
      find.descendant(of: find.byType(CharcoalScaffold), matching: find.byType(ColoredBox)).first,
    );
    expect(page.color, theme.colors.noticeSurface);
  });

  testWidgets('a CharcoalPage under the bar paints the notice background, not its own', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      Column(
        children: [
          _bar(),
          const Expanded(
            child: CharcoalPage(
              title: 'Grant console-admin',
              background: CharcoalPageBackground.notice,
              child: SizedBox(height: 40),
            ),
          ),
        ],
      ),
      size: const Size(1200, 600),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalModeBar)));
    final fills = tester
        .widgetList<ColoredBox>(
          find.descendant(of: find.byType(CharcoalPage), matching: find.byType(ColoredBox)),
        )
        .map((box) => box.color);
    expect(fills, contains(theme.colors.noticeSurface));
    expect(fills, isNot(contains(theme.colors.background)));
  });
}

List<String> _labels(SemanticsNode node) {
  final labels = <String>[];
  node.visitChildren((child) {
    labels
      ..add(child.label)
      ..addAll(_labels(child));
    return true;
  });
  return labels;
}
