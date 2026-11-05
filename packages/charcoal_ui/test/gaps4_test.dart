import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/components/fields/field_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

Widget _within(Widget child, {double width = 420}) => Align(
  alignment: Alignment.topLeft,
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: width),
    child: child,
  ),
);

Widget _top(Widget child, {double width = 420}) => Align(
  alignment: Alignment.topLeft,
  child: SizedBox(width: width, child: child),
);

void main() {
  final pack = charcoalLightPack;

  group('field labels align across families', () {
    testWidgets('same weight, label height and label-to-field gap', (tester) async {
      await pumpCharcoal(
        tester,
        SingleChildScrollView(
          child: _top(
            Column(
              children: [
                const CharcoalTextField(label: 'Label', showLabel: true),
                const CharcoalTextArea(label: 'Label', showLabel: true),
                CharcoalDropdown<int>(
                  label: 'Label',
                  showLabel: true,
                  value: 1,
                  options: const [CharcoalDropdownOption(value: 1, label: 'One')],
                  onChanged: (_) {},
                ),
                const CharcoalFormField(label: 'Label', child: SizedBox(height: 40)),
                CharcoalDateTimeField(label: 'Label', value: null, onChanged: (_) {}),
                const CharcoalText('Bold reference', role: CharcoalTextRole.size14, bold: true),
              ],
            ),
          ),
        ),
        size: const Size(500, 1400),
      );
      final frames = tester
          .widgetList<CharcoalFieldFrame>(find.byType(CharcoalFieldFrame))
          .toList();
      expect(frames, hasLength(5));
      final heights = <double>{};
      final gaps = <double>{};
      final weights = <FontWeight?>{};
      for (final frame in find.byType(CharcoalFieldFrame).evaluate()) {
        final label = find.descendant(
          of: find.byWidget(frame.widget),
          matching: find.text('Label'),
        );
        final rect = tester.getRect(label.first);
        heights.add(rect.height);
        weights.add(tester.widget<Text>(label.first).style!.fontWeight);
        final field = tester.getRect(find.byWidget((frame.widget as CharcoalFieldFrame).field));
        gaps.add(field.top - rect.bottom);
      }
      expect(heights, hasLength(1));
      expect(weights, hasLength(1));
      expect(
        weights.single,
        tester.widget<Text>(find.text('Bold reference')).style!.fontWeight,
      );
      expect(gaps, hasLength(1));
      expect(gaps.single, pack.space.sm);
    });
  });

  group('content widths', () {
    test('wide is never narrower than standard, in every pack', () {
      for (final p in [charcoalLightPack, charcoalDarkPack]) {
        expect(p.sizes.contentWideMaxWidth, greaterThanOrEqualTo(p.sizes.contentMaxWidth));
      }
    });

    testWidgets('CharcoalPageWidth.wide gives a wider column than standard', (tester) async {
      Future<double> width(CharcoalPageWidth w) async {
        await pumpCharcoal(
          tester,
          CharcoalPage(
            title: 'T',
            maxWidth: w,
            compact: false,
            showBack: false,
            child: const SizedBox(key: ValueKey('b'), height: 10),
          ),
          size: const Size(1800, 600),
        );
        return tester.getSize(find.byKey(const ValueKey('b'))).width;
      }

      expect(
        await width(CharcoalPageWidth.wide),
        greaterThan(await width(CharcoalPageWidth.standard)),
      );
    });
  });

  group('CharcoalListRow', () {
    testWidgets('details sit directly under the title without a subtitle', (tester) async {
      await pumpCharcoal(
        tester,
        _top(const CharcoalListRow(title: 'Title', details: 'Payload')),
      );
      final title = tester.getRect(find.text('Title'));
      final details = tester.getRect(find.text('Payload'));
      expect(details.top - title.bottom, lessThan(pack.space.sm));
    });

    testWidgets('details keep the gap below a subtitle', (tester) async {
      await pumpCharcoal(
        tester,
        _top(const CharcoalListRow(title: 'Title', subtitle: 'Sub', details: 'Payload')),
      );
      final sub = tester.getRect(find.text('Sub'));
      expect(
        tester.getRect(find.text('Payload')).top - sub.bottom,
        greaterThanOrEqualTo(pack.space.sm),
      );
    });

    testWidgets('title trailing chips stay together: beside when they fit, below when not', (
      tester,
    ) async {
      Widget row(double width) => _top(
        CharcoalListRow(
          title: 'Title',
          titleTrailing: const [CharcoalChip('one'), CharcoalChip('two'), CharcoalChip('three')],
        ),
        width: width,
      );
      await pumpCharcoal(tester, row(500));
      final titleWide = tester.getRect(find.text('Title'));
      expect(tester.getRect(find.text('one')).top, lessThan(titleWide.bottom));
      expect(
        tester.getRect(find.text('three')).left,
        greaterThan(tester.getRect(find.text('one')).left),
      );

      await pumpCharcoal(tester, row(150));
      final title = tester.getRect(find.text('Title'));
      final chips = [
        for (final t in ['one', 'two', 'three']) tester.getRect(find.text(t)),
      ];
      // All chips are on the same side of the title: none beside it while others wrapped below.
      final below = chips.map((c) => c.top >= title.bottom).toSet();
      expect(below, hasLength(1));
      expect(tester.takeException(), isNull);
    });
  });

  group('CharcoalSegmentedControl overflow', () {
    Widget control(int selected, ValueChanged<int> onChanged, {double width = 200}) => _within(
      CharcoalSegmentedControl<int>(
        segments: [
          for (var i = 0; i < 8; i++) CharcoalSegment(value: i, child: Text('Seg $i')),
        ],
        value: selected,
        onChanged: onChanged,
      ),
      width: width,
    );

    testWidgets('scrolls the selected segment into view, also after a change', (tester) async {
      var selected = 0;
      late StateSetter set;
      await pumpCharcoal(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            set = setState;
            return control(selected, (v) => setState(() => selected = v));
          },
        ),
        size: const Size(400, 200),
      );
      final box = tester.getRect(find.byType(CharcoalSegmentedControl<int>));
      expect(box.width, 200);
      expect(tester.getRect(find.text('Seg 0')).left, greaterThanOrEqualTo(box.left));
      set(() => selected = 6);
      await tester.pumpAndSettle();
      final r = tester.getRect(find.text('Seg 6'));
      expect(r.left, greaterThanOrEqualTo(box.left));
      expect(r.right, lessThanOrEqualTo(box.right));
    });

    testWidgets('selected segment far along is visible on first build', (tester) async {
      await pumpCharcoal(tester, control(7, (_) {}), size: const Size(400, 200));
      await tester.pumpAndSettle();
      final box = tester.getRect(find.byType(CharcoalSegmentedControl<int>));
      final r = tester.getRect(find.text('Seg 7'));
      expect(r.right, lessThanOrEqualTo(box.right));
    });

    testWidgets('scroll extents match the edges that show a fade', (tester) async {
      await pumpCharcoal(tester, control(0, (_) {}), size: const Size(400, 200));
      await tester.pumpAndSettle();
      // Start of the list: only the end has more; after scrolling to the end: only the start.
      final scrollable = find.descendant(
        of: find.byType(CharcoalSegmentedControl<int>),
        matching: find.byType(Scrollable),
      );
      final position = tester.state<ScrollableState>(scrollable).position;
      expect(position.extentBefore, 0);
      expect(position.extentAfter, greaterThan(0));
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(position.extentAfter, 0);
      expect(position.extentBefore, greaterThan(0));
    });

    testWidgets('revealing the selection does not scroll the enclosing page', (tester) async {
      final page = ScrollController();
      addTearDown(page.dispose);
      await pumpCharcoal(
        tester,
        SingleChildScrollView(
          controller: page,
          child: Column(
            children: [
              const SizedBox(height: 100),
              _within(
                CharcoalSegmentedControl<int>(
                  segments: [
                    for (var i = 0; i < 8; i++) CharcoalSegment(value: i, child: Text('Seg $i')),
                  ],
                  value: 7,
                  onChanged: (_) {},
                ),
                width: 200,
              ),
              const SizedBox(height: 2000),
            ],
          ),
        ),
        size: const Size(400, 200),
      );
      await tester.pumpAndSettle();
      expect(page.offset, 0);
    });

    testWidgets('a control that fits does not scroll and stays intrinsic', (tester) async {
      await pumpCharcoal(
        tester,
        _within(
          CharcoalSegmentedControl<int>(
            segments: const [
              CharcoalSegment(value: 0, child: Text('A')),
              CharcoalSegment(value: 1, child: Text('B')),
            ],
            value: 0,
            onChanged: (_) {},
          ),
          width: 400,
        ),
      );
      final scrollable = find.descendant(
        of: find.byType(CharcoalSegmentedControl<int>),
        matching: find.byType(Scrollable),
      );
      expect(tester.state<ScrollableState>(scrollable).position.maxScrollExtent, 0);
      expect(tester.getSize(find.byType(CharcoalSegmentedControl<int>)).width, lessThan(200));
    });
  });
}
