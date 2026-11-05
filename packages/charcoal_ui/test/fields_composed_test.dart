import 'dart:ui' show SemanticsFlag, Tristate;

import 'package:charcoal_ui/next.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  final pack = charcoalLightPack;

  group('CharcoalSearchField', () {
    testWidgets('shows the clear button only while there is text, and clears through the caller', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var cleared = 0;
      await pumpCharcoal(
        tester,
        Center(
          child: SizedBox(
            width: 320,
            child: CharcoalSearchField(
              controller: controller,
              placeholder: 'Search',
              clearLabel: 'Clear search',
              onClear: () {
                cleared++;
                controller.clear();
              },
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Clear search'), findsNothing);
      await tester.enterText(find.byType(EditableText), 'abc');
      await tester.pump();
      expect(find.bySemanticsLabel('Clear search'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Clear search'));
      await tester.pump();
      expect(cleared, 1);
      expect(controller.text, isEmpty);
      expect(find.bySemanticsLabel('Clear search'), findsNothing);
    });

    testWidgets('keeps the field height with and without the clear affordance', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpCharcoal(
        tester,
        Center(
          child: SizedBox(
            width: 320,
            child: CharcoalSearchField(controller: controller, onClear: () {}),
          ),
        ),
      );
      final before = tester.getSize(find.byType(AnimatedContainer));
      controller.text = 'abc';
      await tester.pump();
      expect(tester.getSize(find.byType(AnimatedContainer)), before);
    });

    testWidgets('submits through the keyboard action', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? submitted;
      await pumpCharcoal(
        tester,
        Center(
          child: SizedBox(
            width: 320,
            child: CharcoalSearchField(controller: controller, onSubmitted: (v) => submitted = v),
          ),
        ),
      );
      await tester.enterText(find.byType(EditableText), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      expect(submitted, 'query');
    });
  });

  group('CharcoalDateTimeField', () {
    testWidgets('shows the empty text, picks through the picker and clears', (tester) async {
      DateTime? value;
      await pumpCharcoal(
        tester,
        Center(
          child: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: 320,
              child: CharcoalDateTimeField(
                label: 'Publish at',
                value: value,
                emptyText: 'Not set',
                clearText: 'Clear',
                hint: 'Shown to everyone',
                picker: (context, current) async => DateTime(2026, 9, 13, 14, 20),
                onChanged: (v) => setState(() => value = v),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Not set'), findsOneWidget);
      expect(find.text('Clear'), findsNothing);
      expect(find.text('Shown to everyone'), findsOneWidget);

      await tester.tap(find.text('Not set'));
      await tester.pump();
      expect(value, DateTime(2026, 9, 13, 14, 20));
      expect(find.text('2026-09-13 14:20'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);

      await tester.tap(find.text('Clear'));
      await tester.pump();
      expect(value, isNull);
      expect(find.text('Not set'), findsOneWidget);
    });

    testWidgets('a cancelled picker leaves the value alone', (tester) async {
      var calls = 0;
      await pumpCharcoal(
        tester,
        Center(
          child: CharcoalDateTimeField(
            label: 'Publish at',
            value: DateTime(2026, 1, 2, 3, 4),
            picker: (context, current) async => null,
            onChanged: (_) => calls++,
          ),
        ),
      );
      await tester.tap(find.text('2026-01-02 03:04'));
      await tester.pump();
      expect(calls, 0);
    });

    testWidgets('the default picker opens the platform date dialog', (tester) async {
      await pumpCharcoal(
        tester,
        Center(
          child: CharcoalDateTimeField(label: 'Publish at', value: null, onChanged: (_) {}),
        ),
      );
      await tester.tap(find.text('Not set'));
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a null onChanged disables it', (tester) async {
      var opened = 0;
      await pumpCharcoal(
        tester,
        Center(
          child: CharcoalDateTimeField(
            label: 'Publish at',
            value: DateTime(2026, 1, 2, 3, 4),
            picker: (context, current) async {
              opened++;
              return null;
            },
            onChanged: null,
          ),
        ),
      );
      expect(find.text('Clear'), findsNothing);
      await tester.tap(find.text('2026-01-02 03:04'));
      await tester.pump();
      expect(opened, 0);
    });

    test('formats local date and time with zero padding', () {
      expect(formatCharcoalDateTime(DateTime(2026, 9, 3, 4, 5)), '2026-09-03 04:05');
      expect(formatCharcoalDate(DateTime(2026, 9, 3, 4, 5)), '2026-09-03');
    });
  });

  group('CharcoalSwitchField', () {
    testWidgets('the whole row toggles and exposes one toggle node', (tester) async {
      var value = false;
      await pumpCharcoal(
        tester,
        Center(
          child: StatefulBuilder(
            builder: (context, setState) => CharcoalSwitchField(
              label: 'Notify me',
              value: value,
              hint: 'Once a day',
              onChanged: (v) => setState(() => value = v),
            ),
          ),
        ),
      );
      expect(find.text('Once a day'), findsOneWidget);
      await tester.tap(find.text('Notify me'));
      await tester.pump(); // atomic: the first frame after activation already shows the new value
      expect(value, isTrue);
      final toggles = find.semantics.byFlag(SemanticsFlag.hasToggledState);
      expect(toggles, findsOne);
      expect(toggles.evaluate().single.flagsCollection.isToggled, Tristate.isTrue);
    });

    testWidgets('disabled does not toggle', (tester) async {
      await pumpCharcoal(
        tester,
        const Center(child: CharcoalSwitchField(label: 'Notify me', value: false, onChanged: null)),
      );
      await tester.tap(find.text('Notify me'), warnIfMissed: false);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('CharcoalFormSection and CharcoalFormField', () {
    testWidgets('section spaces children by md and leaves xxl below', (tester) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 320,
            child: CharcoalFormSection(
              title: 'Account',
              caption: 'Visible to admins',
              children: [
                SizedBox(key: ValueKey('a'), height: 20),
                SizedBox(key: ValueKey('b'), height: 20),
              ],
            ),
          ),
        ),
      );
      final a = tester.getRect(find.byKey(const ValueKey('a')));
      final b = tester.getRect(find.byKey(const ValueKey('b')));
      expect(b.top - a.bottom, pack.space.md);
      final section = tester.getRect(find.byType(CharcoalFormSection));
      expect(section.bottom - b.bottom, pack.space.xxl);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Visible to admins'), findsOneWidget);
      expect(
        find.semantics.byPredicate((n) => n.label == 'Account' && n.flagsCollection.isHeader),
        findsOne,
      );
    });

    testWidgets('form field frames a control with label, action and assistive text', (
      tester,
    ) async {
      await pumpCharcoal(
        tester,
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 320,
            child: CharcoalFormField(
              label: 'Private key',
              required: true,
              requiredText: 'Required',
              assistiveText: 'PEM only',
              action: SizedBox(key: ValueKey('action'), width: 80, height: 28),
              child: SizedBox(key: ValueKey('control'), height: 60),
            ),
          ),
        ),
      );
      final label = tester.getRect(find.text('Private key'));
      final control = tester.getRect(find.byKey(const ValueKey('control')));
      final action = tester.getRect(find.byKey(const ValueKey('action')));
      final assistive = tester.getRect(find.text('PEM only'));
      expect(control.top - label.bottom, greaterThanOrEqualTo(pack.space.sm));
      expect(action.top - control.bottom, pack.space.xs);
      expect(action.left, control.left);
      expect(assistive.top - action.bottom, pack.space.sm);
      expect(find.text('Required'), findsOneWidget);
    });
  });

  group('CharcoalFieldRing', () {
    testWidgets('paints outside the child and never resizes it', (tester) async {
      Future<void> mount(bool visible) => pumpCharcoal(
        tester,
        Center(
          child: CharcoalFieldRing(
            color: pack.colors.focusRing,
            radius: pack.radius.sm,
            visible: visible,
            child: const SizedBox(key: ValueKey('child'), width: 100, height: 40),
          ),
        ),
      );
      await mount(false);
      final rect = tester.getRect(find.byKey(const ValueKey('child')));
      await mount(true);
      expect(tester.getRect(find.byKey(const ValueKey('child'))), rect);
      final painter = tester
          .widget<CustomPaint>(
            find.descendant(
              of: find.byType(CharcoalFieldRing),
              matching: find.byWidgetPredicate((w) => w is CustomPaint && w.painter != null),
            ),
          )
          .painter!;
      expect(painter, isA<CharcoalFieldRingPainter>());
      expect((painter as CharcoalFieldRingPainter).width, pack.borders.focusHalo);
    });

    test('repaints when its inputs change', () {
      const a = CharcoalFieldRingPainter(color: Color(0xFF000000), radius: 4, width: 4);
      expect(a.shouldRepaint(a), isFalse);
      expect(
        a.shouldRepaint(
          const CharcoalFieldRingPainter(color: Color(0xFF000000), radius: 4, width: 5),
        ),
        isTrue,
      );
    });
  });
}
