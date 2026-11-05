import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  const sizes = <String, Size>{'compact': Size(420, 900), 'wide': Size(1280, 900)};

  for (final entry in sizes.entries) {
    for (final scale in <double>[1, 2]) {
      testWidgets('cards in a row are equal in width and height (${entry.key}, x$scale)', (
        tester,
      ) async {
        await pumpCharcoal(
          tester,
          SingleChildScrollView(
            child: CharcoalGrid(
              columns: const CharcoalGridColumns(wide: 3, compact: 2),
              children: [
                const CharcoalStatCard(key: ValueKey('c0'), label: 'Revenue', value: r'$1,200'),
                const CharcoalStatCard(
                  key: ValueKey('c1'),
                  label: 'A much longer label that wraps onto several lines',
                  value: '42',
                  status: 'Up 12%',
                  footnote: 'Compared with the same period last month, across every region',
                ),
                CharcoalActionTile(
                  key: const ValueKey('c2'),
                  icon: CharcoalIcons.add,
                  label: 'New',
                  onPressed: () {},
                ),
                CharcoalActionTile(
                  key: const ValueKey('c3'),
                  icon: CharcoalIcons.add,
                  label: 'A long quick action label',
                  onPressed: () {},
                ),
                const CharcoalCard(key: ValueKey('c4'), child: CharcoalText('Short')),
                const CharcoalCard(key: ValueKey('c5'), child: CharcoalText('Tall\n\n\ncard')),
              ],
            ),
          ),
          size: entry.value,
          textScale: scale,
        );
        expect(tester.takeException(), isNull);
        final columns = entry.key == 'wide' ? 3 : 2;
        // Each key sits on the card itself, so equal rects mean the card fills its cell.
        final rects = [for (var i = 0; i < 6; i++) tester.getRect(find.byKey(ValueKey('c$i')))];
        for (var start = 0; start < rects.length; start += columns) {
          final row = rects.sublist(start, start + columns);
          for (final r in row) {
            expect(r.top, row.first.top);
            expect(r.height, row.first.height);
            expect(r.width, moreOrLessEquals(row.first.width, epsilon: 0.01));
          }
        }
        // The short stat card grew to the height of the tall one beside it.
        expect(rects[0].height, rects[1].height);
        expect(rects[1].height, greaterThan(100));
      });
    }
  }

  testWidgets('rowHeight content keeps content heights', (tester) async {
    await pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalGrid(
          columns: const CharcoalGridColumns(wide: 2, compact: 2),
          rowHeight: CharcoalGridRowHeight.content,
          children: const [
            SizedBox(key: ValueKey('a'), height: 20),
            SizedBox(key: ValueKey('b'), height: 60),
          ],
        ),
      ),
      size: const Size(800, 400),
    );
    expect(tester.getSize(find.byKey(const ValueKey('a'))).height, 20);
    expect(tester.getSize(find.byKey(const ValueKey('b'))).height, 60);
  });
}
