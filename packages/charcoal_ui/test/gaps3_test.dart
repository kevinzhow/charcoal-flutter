import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  final pack = charcoalLightPack;

  testWidgets('CharcoalSelectable is exported', (tester) async {
    await pumpCharcoal(tester, const CharcoalSelectable(child: Text('copy me')));
    expect(find.byType(SelectableRegion), findsOneWidget);
  });

  group('form dialog required marker', () {
    Future<void> open(WidgetTester tester, {String? requiredText}) async {
      await pumpCharcoal(
        tester,
        Builder(
          builder: (context) => CharcoalButton(
            onPressed: () => requiredText == null
                ? showCharcoalFormDialog(
                    context,
                    title: 'Add',
                    fields: const [
                      CharcoalFormDialogField(key: 'a', label: 'Name', required: true),
                    ],
                  )
                : showCharcoalFormDialog(
                    context,
                    title: 'Add',
                    requiredText: requiredText,
                    fields: const [
                      CharcoalFormDialogField(key: 'a', label: 'Name', required: true),
                      CharcoalFormDialogField(
                        key: 'b',
                        label: 'Note',
                        required: true,
                        multiline: true,
                      ),
                    ],
                  ),
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('defaults to English', (tester) async {
      await open(tester);
      expect(find.text('*Required'), findsOneWidget);
    });

    testWidgets('is localisable for text fields and text areas', (tester) async {
      await open(tester, requiredText: '*必填');
      expect(find.text('*必填'), findsNWidgets(2));
      expect(find.text('*Required'), findsNothing);
    });
  });

  testWidgets('balloon dismiss label is a parameter', (tester) async {
    await pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalBalloon(dismissLabel: '关闭', onDismiss: () {}, child: const Text('Tip')),
      ),
    );
    final labels = tester
        .widgetList<CharcoalClickable>(find.byType(CharcoalClickable))
        .map((c) => c.semanticLabel);
    expect(labels, contains('关闭'));
    expect(labels, isNot(contains('Close')));
  });

  group('CharcoalDateTimeField mode', () {
    testWidgets('date mode shows a date only and picks midnight', (tester) async {
      DateTime? changed;
      await pumpCharcoal(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 400,
            child: CharcoalDateTimeField(
              label: 'Day',
              mode: CharcoalDateTimeMode.date,
              value: DateTime(2026, 9, 13, 14, 20),
              onChanged: (v) => changed = v,
              picker: (_, current) async => DateTime(2027, 1, 2),
            ),
          ),
        ),
      );
      expect(find.text('2026-09-13'), findsOneWidget);
      await tester.tap(find.text('2026-09-13'));
      await tester.pump();
      expect(changed, DateTime(2027, 1, 2));
    });

    testWidgets('time mode shows HH:mm and dateTime mode both', (tester) async {
      final value = DateTime(2026, 9, 13, 4, 5);
      for (final (mode, text) in [
        (CharcoalDateTimeMode.time, '04:05'),
        (CharcoalDateTimeMode.dateTime, '2026-09-13 04:05'),
      ]) {
        await pumpCharcoal(
          tester,
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              child: CharcoalDateTimeField(label: 'T', mode: mode, value: value, onChanged: (_) {}),
            ),
          ),
        );
        expect(find.text(text), findsOneWidget, reason: '$mode');
      }
    });

    testWidgets('the default picker of date mode opens the date dialog only', (tester) async {
      await pumpCharcoal(
        tester,
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 400,
            child: CharcoalDateTimeField(
              label: 'Day',
              mode: CharcoalDateTimeMode.date,
              value: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.tap(find.text('Not set'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.byType(TimePickerDialog), findsNothing);
    });
  });

  testWidgets('accent tones resolve to the primary role', (tester) async {
    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            CharcoalText('x', tone: CharcoalTextTone.accent),
            CharcoalIconView(CharcoalIcons.lock, tone: CharcoalIconTone.accent),
          ],
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('x')).style!.color, pack.colors.primary);
    expect(tester.widget<CharcoalIcon>(find.byType(CharcoalIcon)).color, pack.colors.primary);
  });

  group('CharcoalGrid', () {
    Widget cells(int n) => CharcoalGrid(
      children: [for (var i = 0; i < n; i++) SizedBox(key: ValueKey('c$i'), height: 20)],
    );

    testWidgets('three columns wide, one compact, without a shell', (tester) async {
      await pumpCharcoal(
        tester,
        Align(alignment: Alignment.topLeft, child: cells(4)),
        size: const Size(1200, 600),
      );
      final a = tester.getRect(find.byKey(const ValueKey('c0')));
      final b = tester.getRect(find.byKey(const ValueKey('c1')));
      final d = tester.getRect(find.byKey(const ValueKey('c3')));
      expect(b.left - a.right, pack.space.md);
      expect(a.width, b.width);
      expect(d.top - a.bottom, pack.space.md);
      expect(d.left, a.left);

      await pumpCharcoal(
        tester,
        Align(alignment: Alignment.topLeft, child: cells(4)),
        size: const Size(400, 600),
      );
      expect(
        tester.getRect(find.byKey(const ValueKey('c1'))).top >
            tester.getRect(find.byKey(const ValueKey('c0'))).bottom,
        isTrue,
      );
    });

    testWidgets('follows the admin shell and custom counts and spacing', (tester) async {
      await pumpCharcoal(
        tester,
        CharcoalAdminShell(
          sidebar: const SizedBox(width: 240),
          bottomBar: const SizedBox(height: 40),
          body: Align(
            alignment: Alignment.topLeft,
            child: CharcoalGrid(
              columns: const CharcoalGridColumns(wide: 2, compact: 2),
              spacing: CharcoalSpace.lg,
              runSpacing: CharcoalSpace.xs,
              children: [for (var i = 0; i < 3; i++) SizedBox(key: ValueKey('c$i'), height: 20)],
            ),
          ),
        ),
        size: const Size(420, 600),
      );
      final a = tester.getRect(find.byKey(const ValueKey('c0')));
      expect(tester.getRect(find.byKey(const ValueKey('c1'))).left - a.right, pack.space.lg);
      expect(tester.getRect(find.byKey(const ValueKey('c2'))).top - a.bottom, pack.space.xs);
    });

    testWidgets('an empty grid renders nothing, few children clamp the count', (tester) async {
      await pumpCharcoal(
        tester,
        Align(alignment: Alignment.topLeft, child: cells(2)),
        size: const Size(1200, 600),
      );
      expect(tester.getRect(find.byKey(const ValueKey('c0'))).width, greaterThan(500));
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: CharcoalGrid(children: []),
        ),
        size: const Size(1200, 600),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('CharcoalInfoRows', () {
    testWidgets('mono values use the monospace family', (tester) async {
      Future<String?> family(bool mono) async {
        await pumpCharcoal(
          tester,
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 400, child: CharcoalInfoRows([('Id', 'abc')], mono: mono)),
          ),
        );
        return tester.widget<Text>(find.text('abc')).style!.fontFamily;
      }

      expect(await family(true), isNot(await family(false)));
    });

    testWidgets('extraWide label column is infoLabelWidthExtraWide', (tester) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            child: CharcoalInfoRows([
              ('Label', 'value'),
            ], labelWidth: CharcoalInfoLabelWidth.extraWide),
          ),
        ),
      );
      expect(pack.sizes.infoLabelWidthExtraWide, 128);
      expect(
        tester.getTopLeft(find.text('value')).dx - tester.getTopLeft(find.text('Label')).dx,
        pack.sizes.infoLabelWidthExtraWide + pack.space.lg,
      );
    });
  });
}
