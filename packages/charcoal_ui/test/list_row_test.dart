import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/gestures.dart' show kPressTimeout;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

const _rowKey = ValueKey<String>('row');

Widget _row({
  VoidCallback? onPressed,
  bool selected = false,
  WidgetStatesController? states,
}) => SizedBox(
  width: 360,
  child: CharcoalListRow(
    key: _rowKey,
    title: 'Alice',
    subtitle: 'alice@a.co',
    leading: const CharcoalAvatar('Alice'),
    trailing: const [CharcoalChip('admin')],
    onPressed: onPressed,
    selected: selected,
    statesController: states,
  ),
);

({Rect row, Rect title, Rect chip, Rect avatar, double baseline}) _geometry(WidgetTester tester) {
  final title = find.text('Alice');
  final box = tester.renderObject<RenderBox>(title);
  return (
    row: tester.getRect(find.byKey(_rowKey)),
    title: tester.getRect(title),
    chip: tester.getRect(find.byType(CharcoalChip)),
    avatar: tester.getRect(find.byType(CharcoalAvatar)),
    baseline:
        tester.getTopLeft(title).dy + box.getDryBaseline(box.constraints, TextBaseline.alphabetic)!,
  );
}

void main() {
  testWidgets('hover, focus, press and selection never move bounds', (tester) async {
    final states = WidgetStatesController();
    addTearDown(states.dispose);
    await pumpLoose(tester, _row(onPressed: () {}, states: states));
    final before = _geometry(tester);

    for (final phase in <Set<WidgetState>>[
      {WidgetState.hovered},
      {WidgetState.focused},
      {WidgetState.hovered, WidgetState.pressed},
      {WidgetState.focused, WidgetState.hovered, WidgetState.pressed},
    ]) {
      states.value = phase;
      await tester.pumpAndSettle();
      expect(_geometry(tester), before, reason: '$phase');
    }
    states.value = <WidgetState>{};
    await pumpLoose(tester, _row(onPressed: () {}, selected: true, states: states));
    expect(_geometry(tester), before, reason: 'selected');
    // A static row has no chevron; the text block may only differ by it.
    await pumpLoose(tester, _row());
    expect(_geometry(tester).row.height, before.row.height);
  });

  testWidgets('paints selection beneath the hover and press layer in one decoration', (
    tester,
  ) async {
    final states = WidgetStatesController();
    addTearDown(states.dispose);
    await pumpLoose(tester, _row(onPressed: () {}, selected: true, states: states));
    final theme = CharcoalTheme.of(tester.element(find.byKey(_rowKey)));
    Color? fill() =>
        ((tester.widget<AnimatedContainer>(find.byType(AnimatedContainer).first).decoration)
                as BoxDecoration)
            .color;

    final selectedFill = theme.tone(CharcoalTone.info).surface;
    expect(fill(), selectedFill);
    states.update(WidgetState.hovered, true);
    await tester.pumpAndSettle();
    expect(fill(), Color.alphaBlend(theme.colors.hoverOverlay, selectedFill));
    states.update(WidgetState.pressed, true);
    await tester.pumpAndSettle();
    expect(fill(), Color.alphaBlend(theme.colors.pressOverlay, selectedFill));
  });

  testWidgets('activates on tap and key, not on down, and a cancel does nothing', (tester) async {
    var taps = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpLoose(tester, _row(onPressed: () => taps++));
    final gesture = await tester.startGesture(tester.getCenter(find.byKey(_rowKey)));
    await tester.pump(kPressTimeout);
    expect(taps, 0);
    await gesture.cancel();
    await tester.pump();
    expect(taps, 0);
    await tester.tap(find.byKey(_rowKey));
    expect(taps, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 2);
  });

  testWidgets('a static row is not a button; an interactive row is', (tester) async {
    await pumpLoose(tester, _row());
    expect(find.byType(CharcoalClickable), findsNothing);
    expect(find.byType(CharcoalIcon), findsNothing);

    final handle = tester.ensureSemantics();
    await pumpLoose(tester, _row(onPressed: () {}, selected: true));
    expect(find.byType(CharcoalClickable), findsOneWidget);
    expect(find.byType(CharcoalIcon), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(CharcoalClickable)),
      matchesSemantics(
        label: 'Alice',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('survives text scaling up to 3x without overflow', (tester) async {
    for (final scale in <double>[0.8, 1, 2, 3]) {
      await pumpLoose(
        tester,
        _row(onPressed: () {}),
        textScale: scale,
        size: const Size(400, 800),
      );
      expect(tester.takeException(), isNull, reason: 'scale $scale');
    }
  });

  testWidgets('a list draws a top rule and nothing when empty', (tester) async {
    await pumpLoose(tester, const CharcoalList(children: []));
    expect(tester.getSize(find.byType(CharcoalList)), Size.zero);
    await pumpLoose(
      tester,
      SizedBox(
        width: 300,
        child: CharcoalList(
          children: [
            _row(),
            const CharcoalListRow(title: 'Bob'),
          ],
        ),
      ),
    );
    expect(find.byType(CharcoalListRow), findsNWidgets(2));
  });

  testWidgets('titleTrailing wraps with the title', (tester) async {
    await pumpLoose(
      tester,
      const SizedBox(
        width: 200,
        child: CharcoalListRow(
          title: 'A long project name that must wrap',
          titleTrailing: [CharcoalChip('v2')],
        ),
      ),
    );
    expect(find.byType(Wrap), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
