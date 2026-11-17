import 'dart:ui' show CheckedState;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

const _columns = <CharcoalTableColumn>[
  CharcoalTableColumn(label: 'User', flex: 2),
  CharcoalTableColumn(label: 'Note', hideWhenNarrow: true),
  CharcoalTableColumn(label: 'Joined', align: CharcoalColumnAlign.end),
];

CharcoalTableRow<String> _row(
  String id, {
  VoidCallback? onPressed,
  Widget? action,
  bool selected = false,
}) => CharcoalTableRow<String>(
  id: id,
  cells: [Text('name-$id'), Text('note-$id'), Text('day-$id')],
  onPressed: onPressed,
  action: action,
  selected: selected,
);

Future<CharcoalTheme> _mount(
  WidgetTester tester,
  CharcoalDataTable<String> table, {
  double width = 1000,
}) async {
  await pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: table),
    ),
    size: Size(width + 100, 800),
  );
  return CharcoalTheme.of(tester.element(find.byType(Table)));
}

double _left(WidgetTester tester, String text) =>
    tester.getTopLeft(find.text(text)).dx - tester.getTopLeft(find.byType(Table)).dx;

double _right(WidgetTester tester, String text) =>
    tester.getTopRight(find.text(text)).dx - tester.getTopLeft(find.byType(Table)).dx;

/// The decoration of table row [index]; 0 is the header.
BoxDecoration _decoration(WidgetTester tester, int index) =>
    tester.widget<Table>(find.byType(Table)).children[index].decoration! as BoxDecoration;

void main() {
  testWidgets('cells line up with their header across rows; edges use the section inset', (
    tester,
  ) async {
    final theme = await _mount(
      tester,
      CharcoalDataTable<String>(columns: _columns, rows: [_row('a'), _row('bb')]),
    );
    for (final id in ['a', 'bb']) {
      expect(_left(tester, 'name-$id'), _left(tester, 'User'));
      expect(_left(tester, 'note-$id'), _left(tester, 'Note'));
      expect(_right(tester, 'day-$id'), _right(tester, 'Joined'), reason: 'end-aligned');
    }
    expect(_left(tester, 'User'), theme.space.xl);
    expect(_right(tester, 'Joined'), 1000 - theme.space.xl);
    // Flex 2 against flex 1: the User column is twice as wide as the Note column.
    final user = _left(tester, 'Note') - _left(tester, 'User');
    final note = _left(tester, 'Joined') - _left(tester, 'Note');
    expect(user, greaterThan(note));
  });

  testWidgets('a narrow table drops hideWhenNarrow columns and uses the compact inset', (
    tester,
  ) async {
    final theme = await _mount(
      tester,
      CharcoalDataTable<String>(columns: _columns, rows: [_row('a')]),
      width: 600,
    );
    expect(find.text('Note'), findsNothing);
    expect(find.text('note-a'), findsNothing);
    expect(find.text('day-a'), findsOneWidget);
    expect(_left(tester, 'User'), theme.space.lg);
  });

  testWidgets('a fit column is as wide as its widest cell', (tester) async {
    await _mount(
      tester,
      CharcoalDataTable<String>(
        columns: const [
          CharcoalTableColumn.fit(label: 'S'),
          CharcoalTableColumn(label: 'Name'),
        ],
        rows: const [
          CharcoalTableRow(id: 'a', cells: [Text('on'), Text('x')]),
          CharcoalTableRow(id: 'b', cells: [Text('paused for now'), Text('y')]),
        ],
      ),
    );
    final theme = CharcoalTheme.of(tester.element(find.byType(Table)));
    expect(_left(tester, 'x'), _left(tester, 'Name'));
    expect(_left(tester, 'y'), _left(tester, 'Name'));
    expect(_left(tester, 'Name') - _right(tester, 'paused for now'), theme.space.xl);
  });

  for (final (height, size) in [
    (CharcoalListRowHeight.compact, (CharcoalSizeScale s) => s.rowMinHeightCompact),
    (CharcoalListRowHeight.regular, (CharcoalSizeScale s) => s.rowMinHeight),
    (CharcoalListRowHeight.tall, (CharcoalSizeScale s) => s.rowMinHeightTall),
  ]) {
    testWidgets('rows are at least the ${height.name} row height', (tester) async {
      final theme = await _mount(
        tester,
        CharcoalDataTable<String>(columns: _columns, rows: [_row('a')], rowHeight: height),
      );
      final table = tester.getRect(find.byType(Table));
      final header = tester.getRect(find.text('User'));
      final headerHeight = header.height + theme.space.sm * 2;
      expect(table.height - headerHeight, size(theme.sizes));
    });
  }

  testWidgets('a pressed row reports once; its action is separate; a chevron otherwise', (
    tester,
  ) async {
    final pressed = <String>[];
    var removed = 0;
    await _mount(
      tester,
      CharcoalDataTable<String>(
        columns: _columns,
        rows: [
          _row('a', onPressed: () => pressed.add('a')),
          _row(
            'b',
            onPressed: () => pressed.add('b'),
            action: CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.x),
              semanticLabel: 'Remove',
              onPressed: () => removed++,
            ),
          ),
          _row('c'),
        ],
      ),
    );
    await tester.tap(find.text('name-a'));
    await tester.tap(find.text('day-a'));
    await tester.tap(find.text('note-b'));
    await tester.tap(find.byType(CharcoalIconButton));
    await tester.tap(find.text('name-c'));
    expect(pressed, ['a', 'a', 'b']);
    expect(removed, 1);
    expect(find.byType(CharcoalIcon), findsNWidgets(2), reason: "row a's chevron + b's icon");
  });

  testWidgets('hovering any cell tints the whole row; selected rows use the info surface', (
    tester,
  ) async {
    final theme = await _mount(
      tester,
      CharcoalDataTable<String>(
        columns: _columns,
        rows: [
          _row('a', onPressed: () {}),
          _row('b', onPressed: () {}, selected: true),
        ],
      ),
    );
    final colors = theme.colors;
    expect(_decoration(tester, 1).color, colors.background);
    expect(_decoration(tester, 2).color, theme.tone(CharcoalTone.info).surface);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('day-a')));
    await tester.pump();
    expect(_decoration(tester, 1).color, Color.alphaBlend(colors.hoverOverlay, colors.background));
    await mouse.moveTo(tester.getCenter(find.text('name-a')));
    await tester.pump();
    expect(_decoration(tester, 1).color, Color.alphaBlend(colors.hoverOverlay, colors.background));
    await mouse.moveTo(tester.getCenter(find.text('name-b')));
    await tester.pump();
    expect(_decoration(tester, 1).color, colors.background);
  });

  testWidgets('keyboard focus outlines the row and Enter activates it', (tester) async {
    final pressed = <String>[];
    final theme = await _mount(
      tester,
      CharcoalDataTable<String>(
        columns: _columns,
        rows: [_row('a', onPressed: () => pressed.add('a'))],
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final border = _decoration(tester, 1).border! as Border;
    expect(border.top.color, theme.colors.borderFocus);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(pressed, ['a']);
    // ignore: avoid_print
    expect(
      tester.getSemantics(find.text('name-a')),
      matchesSemantics(
        label: 'name-a',
        isButton: true,
        hasTapAction: true,
        hasFocusAction: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        isFocused: true,
      ),
    );
  });

  group('selection', () {
    Future<List<Set<String>>> mountSelection(WidgetTester tester, Set<String> selected) async {
      final reports = <Set<String>>[];
      await _mount(
        tester,
        CharcoalDataTable<String>(
          columns: _columns,
          rows: [_row('a'), _row('b')],
          selection: CharcoalTableSelection<String>(
            selected: selected,
            onChanged: reports.add,
          ),
        ),
      );
      return reports;
    }

    CharcoalCheckbox header(WidgetTester tester) =>
        tester.widget<CharcoalCheckbox>(find.byType(CharcoalCheckbox).first);

    testWidgets('a row box adds or removes its id', (tester) async {
      final reports = await mountSelection(tester, {'a', 'other'});
      await tester.tap(find.byType(CharcoalCheckbox).at(2));
      await tester.tap(find.byType(CharcoalCheckbox).at(1));
      expect(reports, [
        {'a', 'other', 'b'},
        {'other'},
      ]);
    });

    testWidgets('the header box is empty, mixed or checked and selects all or none', (
      tester,
    ) async {
      var reports = await mountSelection(tester, {});
      expect((header(tester).value, header(tester).mixed), (false, false));
      await tester.tap(find.byType(CharcoalCheckbox).first);
      expect(reports.single, {'a', 'b'});

      reports = await mountSelection(tester, {'a', 'other'});
      expect((header(tester).value, header(tester).mixed), (false, true));
      final box = tester.getSemantics(find.byType(CharcoalCheckbox).first);
      expect(box.label, 'Select all');
      expect(box.flagsCollection.isChecked, CheckedState.mixed);
      await tester.tap(find.byType(CharcoalCheckbox).first);
      expect(reports.single, {'a', 'b', 'other'});

      reports = await mountSelection(tester, {'a', 'b', 'other'});
      expect((header(tester).value, header(tester).mixed), (true, false));
      await tester.tap(find.byType(CharcoalCheckbox).first);
      expect(reports.single, {'other'}, reason: 'ids of rows not shown are kept');
    });

    testWidgets('the selection boxes sit before the first column, closer than a column gap', (
      tester,
    ) async {
      await mountSelection(tester, {});
      final theme = CharcoalTheme.of(tester.element(find.byType(Table)));
      final box = tester.getRect(find.byType(CharcoalCheckbox).at(1));
      final table = tester.getTopLeft(find.byType(Table));
      expect(box.left - table.dx, theme.space.xl);
      expect(tester.getTopLeft(find.text('name-a')).dx - box.right, theme.space.md);
      expect(_left(tester, 'name-a'), _left(tester, 'User'));
    });
  });

  testWidgets('removing a row while it is hovered leaves no stale state', (tester) async {
    await _mount(
      tester,
      CharcoalDataTable<String>(
        columns: _columns,
        rows: [_row('a', onPressed: () {})],
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('name-a')));
    await tester.pump();
    await _mount(
      tester,
      CharcoalDataTable<String>(
        columns: _columns,
        rows: [_row('b', onPressed: () {})],
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('name-b'), findsOneWidget);
  });
}
