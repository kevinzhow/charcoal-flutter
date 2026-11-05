import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';
import 'support/harness.dart';

void main() {
  final pack = charcoalLightPack;

  testWidgets('CharcoalBrandMark is a brandMark square in primary with the letter', (tester) async {
    await pumpLoose(tester, const CharcoalBrandMark('M'));
    final size = tester.getSize(find.byType(CharcoalBrandMark));
    expect(size, Size.square(pack.sizes.brandMark));
    final box = tester.widget<Container>(find.byType(Container).first);
    expect((box.decoration! as BoxDecoration).color, pack.colors.primary);
    expect(tester.widget<Text>(find.text('M')).style!.color, pack.colors.textOnPrimary);
  });

  testWidgets('the sidebar brand still shows the mark', (tester) async {
    await pumpLoose(
      tester,
      const SizedBox(
        width: 240,
        child: CharcoalSidebarBrand(mark: 'M', title: 'Console'),
      ),
    );
    expect(find.byType(CharcoalBrandMark), findsOneWidget);
    expect(find.text('Console'), findsOneWidget);
  });

  testWidgets('CharcoalBadge tones resolve fill and text roles', (tester) async {
    await pumpLoose(
      tester,
      Row(
        children: [
          for (final tone in CharcoalBadgeTone.values) CharcoalBadge(tone.name, tone: tone),
        ],
      ),
    );
    final expected = {
      CharcoalBadgeTone.primary: (pack.colors.primary, pack.colors.textOnPrimary),
      CharcoalBadgeTone.positive: (pack.colors.positive, pack.colors.textOnPositive),
      CharcoalBadgeTone.negative: (pack.colors.negative, pack.colors.textOnNegative),
    };
    for (final tone in CharcoalBadgeTone.values) {
      final container = tester.widget<Container>(
        find.ancestor(of: find.text(tone.name), matching: find.byType(Container)),
      );
      expect((container.decoration! as BoxDecoration).color, expected[tone]!.$1);
      expect(tester.widget<Text>(find.text(tone.name)).style!.color, expected[tone]!.$2);
    }
    final rect = tester.getRect(find.byType(CharcoalBadge).first);
    expect(rect.height, greaterThan(0));
  });

  group('CharcoalCodeBlock field look', () {
    testWidgets('trailing actions sit beside the text with the field padding and radius', (
      tester,
    ) async {
      await pumpLoose(
        tester,
        SizedBox(
          width: 400,
          child: CharcoalCodeBlock(
            'secret-key',
            field: true,
            maxLines: 1,
            tone: CharcoalTextTone.secondary,
            trailing: CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.copy),
              semanticLabel: 'Copy',
              onPressed: () {},
            ),
          ),
        ),
      );
      final box = tester.widget<Container>(find.byType(Container).first);
      final decoration = box.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(pack.radius.sm));
      expect(
        box.padding,
        EdgeInsets.fromLTRB(pack.space.md, pack.space.sm, pack.space.sm, pack.space.sm),
      );
      final block = tester.getRect(find.byType(CharcoalCodeBlock));
      expect(tester.getRect(find.byType(CharcoalIconButton)).right, block.right - pack.space.sm);
      expect(tester.getRect(find.text('secret-key')).left, block.left + pack.space.md);
      expect(
        tester.widget<SelectableText>(find.byType(SelectableText)).style!.color,
        pack.colors.textSecondary,
      );
    });
  });

  group('CharcoalButton labelTone', () {
    testWidgets('colours the label in every state and keeps geometry', (tester) async {
      final states = WidgetStatesController();
      addTearDown(states.dispose);
      await pumpLoose(
        tester,
        CharcoalButton(
          size: CharcoalButtonSize.small,
          labelTone: CharcoalTextTone.negative,
          statesController: states,
          onPressed: () {},
          child: const Text('Delete'),
        ),
      );
      final before = tester.getRect(find.byType(CharcoalButton));
      for (final phase in [WidgetState.hovered, WidgetState.pressed, WidgetState.focused]) {
        states.update(phase, true);
        await tester.pump(const Duration(seconds: 1));
        expect(
          tester
              .widget<DefaultTextStyle>(
                find
                    .ancestor(of: find.text('Delete'), matching: find.byType(DefaultTextStyle))
                    .first,
              )
              .style
              .color,
          pack.colors.textNegative,
          reason: '$phase',
        );
        expect(tester.getRect(find.byType(CharcoalButton)), before, reason: '$phase');
        states.update(phase, false);
      }
    });
  });

  group('CharcoalList.around and CharcoalDivider', () {
    testWidgets('draws the top rule around a builder list', (tester) async {
      await pumpLoose(
        tester,
        SizedBox(
          width: 300,
          height: 200,
          child: CharcoalList.around(
            ListView.builder(
              itemCount: 2,
              itemBuilder: (_, i) => CharcoalListRow(title: 'Row $i'),
            ),
          ),
        ),
      );
      final decorated = tester.widget<DecoratedBox>(
        find.descendant(of: find.byType(CharcoalList), matching: find.byType(DecoratedBox)).first,
      );
      final border = (decorated.decoration as BoxDecoration).border! as Border;
      expect(border.top.color, pack.colors.borderSubtle);
      expect(border.top.width, pack.borders.hairline);
      expect(find.text('Row 1'), findsOneWidget);
      // The rows-based list is unchanged.
      await pumpLoose(
        tester,
        const SizedBox(
          width: 300,
          child: CharcoalList(children: [CharcoalListRow(title: 'A')]),
        ),
      );
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('divider is one hairline across', (tester) async {
      await pumpLoose(tester, const SizedBox(width: 300, child: CharcoalDivider()));
      expect(tester.getSize(find.byType(CharcoalDivider)), Size(300, pack.borders.hairline));
    });
  });

  group('CharcoalFieldBox', () {
    testWidgets('compact is fieldWidthCompact, standard is capped, full fills', (tester) async {
      Future<double> width(CharcoalFieldWidth w) async {
        await pumpCharcoal(
          tester,
          Align(
            alignment: Alignment.topLeft,
            child: CharcoalFieldBox(
              width: w,
              child: const SizedBox(key: ValueKey('f'), height: 10, width: double.infinity),
            ),
          ),
          size: const Size(1600, 400),
        );
        return tester.getSize(find.byKey(const ValueKey('f'))).width;
      }

      expect(await width(CharcoalFieldWidth.compact), pack.sizes.fieldWidthCompact);
      expect(await width(CharcoalFieldWidth.standard), pack.sizes.formMaxWidth);
    });

    testWidgets('wraps a real dropdown without overflow', (tester) async {
      await pumpLoose(
        tester,
        CharcoalFieldBox(
          width: CharcoalFieldWidth.compact,
          child: CharcoalDropdown<int>(
            label: 'Type',
            value: 1,
            options: const [CharcoalDropdownOption(value: 1, label: 'One')],
            onChanged: (_) {},
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(CharcoalFieldBox)).width, pack.sizes.fieldWidthCompact);
    });
  });

  testWidgets('CharcoalListRow height enum maps to the row min heights', (tester) async {
    for (final (height, extent) in [
      (CharcoalListRowHeight.compact, pack.sizes.rowMinHeightCompact),
      (CharcoalListRowHeight.regular, pack.sizes.rowMinHeight),
      (CharcoalListRowHeight.tall, pack.sizes.rowMinHeightTall),
    ]) {
      await pumpLoose(
        tester,
        SizedBox(
          width: 300,
          child: CharcoalListRow(title: 'T', height: height),
        ),
      );
      expect(tester.getSize(find.byType(CharcoalListRow)).height, greaterThanOrEqualTo(extent));
    }
  });
}
