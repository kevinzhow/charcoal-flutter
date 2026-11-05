import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

/// Mounts a button that runs [open] with its own context, and returns the tap-to-open finder.
Future<void> pumpOpener(
  WidgetTester tester,
  Future<void> Function(BuildContext context) open, {
  Size? size,
  double textScale = 1,
}) => pumpCharcoal(
  tester,
  Align(
    alignment: Alignment.topLeft,
    child: Builder(
      builder: (context) =>
          CharcoalButton(onPressed: () => open(context), child: const Text('Open')),
    ),
  ),
  size: size,
  textScale: textScale,
);

Future<void> openIt(WidgetTester tester) async {
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  const pack = charcoalLightPack;

  group('modal route', () {
    testWidgets('shows a titled dialog on a Material DialogRoute and closes on the close button', (
      tester,
    ) async {
      bool? result = true;
      await pumpOpener(tester, (context) async {
        result = await showCharcoalModal<bool>(
          context: context,
          title: 'Heading',
          child: const Text('Body'),
        );
      });
      await openIt(tester);

      expect(find.text('Heading'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(ModalRoute.of(tester.element(find.text('Body'))), isA<DialogRoute<bool>>());
      expect(find.bySemanticsLabel('Close'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Heading'), findsNothing);
      expect(result, isNull);
    });

    testWidgets(
      'barrier tap, Escape and platform back dismiss; a non-dismissible modal ignores them',
      (
        tester,
      ) async {
        await pumpOpener(tester, (context) async {
          await showCharcoalModal<void>(context: context, title: 'T', child: const Text('Body'));
        });
        await openIt(tester);
        await tester.tapAt(const Offset(2, 590));
        await tester.pumpAndSettle();
        expect(find.text('Body'), findsNothing);

        await openIt(tester);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Body'), findsNothing);

        await openIt(tester);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.text('Body'), findsNothing);

        await pumpOpener(tester, (context) async {
          await showCharcoalModal<void>(
            context: context,
            barrierDismissible: false,
            child: const Text('Sticky'),
          );
        });
        await openIt(tester);
        expect(find.bySemanticsLabel('Close'), findsNothing);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.tapAt(const Offset(2, 590));
        await tester.pumpAndSettle();
        expect(find.text('Sticky'), findsOneWidget);
      },
    );

    testWidgets('uses the pack barrier colour, radius and exit duration', (tester) async {
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(context: context, title: 'T', child: const Text('Body'));
      });
      await openIt(tester);
      final barrier = tester.widget<ModalBarrier>(find.byType(ModalBarrier).last);
      expect(barrier.color, pack.colors.barrier);
      final material = tester.widget<Material>(
        find.ancestor(of: find.text('Body'), matching: find.byType(Material)).first,
      );
      expect(
        material.borderRadius,
        BorderRadius.circular(pack.metrics.modal.cornerRadius),
      );
      final route = ModalRoute.of(tester.element(find.text('Body')))! as CharcoalDialogRoute<void>;
      expect(route.transitionDuration, pack.motion.overlay);
      expect(route.reverseTransitionDuration, pack.metrics.modal.exitFadeDuration);
    });

    testWidgets('a centred dialog enters scaled from initialScale; a sheet slides up', (
      tester,
    ) async {
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(context: context, title: 'T', child: const Text('Body'));
      });
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(pack.motion.overlay ~/ 5);
      final scale = tester.widget<ScaleTransition>(
        find.ancestor(of: find.text('Body'), matching: find.byType(ScaleTransition)).first,
      );
      expect(scale.scale.value, inExclusiveRange(1, pack.metrics.modal.initialScale));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(2, 590));
      await tester.pumpAndSettle();
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(
          context: context,
          style: CharcoalModalStyle.bottomSheet,
          title: 'Sheet',
          child: const Text('Body'),
        );
      }, size: const Size(400, 600));
      await openIt(tester);
      final surface = tester.getRect(
        find.ancestor(of: find.text('Sheet'), matching: find.byType(Material)).first,
      );
      expect(surface.bottom, 600);
    });

    testWidgets('reduced motion removes the scale', (tester) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
        disableAnimations: true,
      );
      addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(context: context, child: const Text('Body'));
      });
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
      expect(
        find.ancestor(of: find.text('Body'), matching: find.byType(ScaleTransition)),
        findsNothing,
      );
    });
  });

  group('dialog surface', () {
    testWidgets('keeps title and actions in place and scrolls a tall body under a short window', (
      tester,
    ) async {
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(
          context: context,
          title: 'Long',
          actions: [CharcoalButton(onPressed: () {}, child: const Text('Done'))],
          child: Column(children: [for (var i = 0; i < 60; i++) Text('Row $i')]),
        );
      }, size: const Size(400, 420));
      await openIt(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('Long'), findsOneWidget);
      final done = find.text('Done');
      expect(done, findsOneWidget);
      expect(tester.getRect(done).bottom, lessThanOrEqualTo(420));
      final before = tester.getTopLeft(find.text('Row 0'));
      await tester.drag(find.text('Row 0'), const Offset(0, -200));
      await tester.pump();
      expect(tester.getTopLeft(find.text('Row 0')).dy, lessThan(before.dy));
      expect(tester.getRect(done).bottom, lessThanOrEqualTo(420));
    });

    testWidgets('lifts above the keyboard and respects the safe area', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 200);
      tester.view.padding = const FakeViewPadding(top: 40, bottom: 30);
      addTearDown(tester.view.resetViewInsets);
      addTearDown(tester.view.resetPadding);
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(
          context: context,
          title: 'Form',
          actions: [CharcoalButton(onPressed: () {}, child: const Text('Save'))],
          child: const SizedBox(height: 600),
        );
      }, size: const Size(400, 700));
      await openIt(tester);

      expect(tester.takeException(), isNull);
      final surface = tester.getRect(
        find.ancestor(of: find.text('Form'), matching: find.byType(Material)).first,
      );
      expect(surface.bottom, lessThanOrEqualTo(700 - 200));
      expect(surface.top, greaterThanOrEqualTo(40));
    });

    testWidgets('a bottom sheet pads its actions by the home-indicator inset', (tester) async {
      tester.view.padding = const FakeViewPadding(bottom: 50);
      addTearDown(tester.view.resetPadding);
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(
          context: context,
          style: CharcoalModalStyle.bottomSheet,
          actions: [CharcoalButton(onPressed: () {}, child: const Text('Go'))],
          child: const SizedBox(height: 20),
        );
      }, size: const Size(400, 700));
      await openIt(tester);
      final button = tester.getRect(find.text('Go'));
      expect(700 - button.bottom, greaterThanOrEqualTo(50));
    });

    testWidgets('lays out without overflow at text scale 3 and exposes route semantics', (
      tester,
    ) async {
      await pumpOpener(
        tester,
        (context) async {
          await showCharcoalModal<void>(
            context: context,
            title: 'A rather long dialog title that must ellipsize',
            actions: [CharcoalButton(onPressed: () {}, child: const Text('OK'))],
            child: const Text('Body text of the dialog'),
          );
        },
        size: const Size(400, 800),
        textScale: 3,
      );
      await openIt(tester);
      expect(tester.takeException(), isNull);
      expect(
        tester.getSemantics(find.byType(CharcoalDialog)).label,
        'A rather long dialog title that must ellipsize',
      );
    });

    testWidgets('the close button is focusable and keeps its size across states', (tester) async {
      await pumpOpener(tester, (context) async {
        await showCharcoalModal<void>(context: context, title: 'T', child: const Text('Body'));
      });
      await openIt(tester);
      final close = find.bySemanticsLabel('Close');
      final rest = tester.getRect(close);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(tester.getRect(close), rest);
      expect(rest.size, Size.square(pack.sizes.controlLg));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });
  });

  group('prebuilt dialogs', () {
    testWidgets('confirm resolves true on the primary action and false on cancel or dismiss', (
      tester,
    ) async {
      bool? result;
      await pumpOpener(tester, (context) async {
        result = await showCharcoalConfirm(
          context,
          title: 'Delete key',
          message: 'Apps stop working.',
          danger: true,
        );
      });
      await openIt(tester);
      expect(find.text('Delete'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(result, isTrue);

      await openIt(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isFalse);

      result = true;
      await openIt(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });

    testWidgets('form blocks submit while a required field is empty, then returns trimmed values', (
      tester,
    ) async {
      Map<String, String>? result;
      await pumpOpener(tester, (context) async {
        result = await showCharcoalFormDialog(
          context,
          title: 'New key',
          fields: [
            CharcoalFormDialogField(key: 'name', label: 'Name', required: true),
            CharcoalFormDialogField(
              key: 'note',
              label: 'Note',
              validator: (value) => value == 'bad' ? 'Note is bad' : null,
            ),
          ],
        );
      });
      await openIt(tester);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Please fill in Name'), findsOneWidget);
      expect(result, isNull);

      await tester.enterText(find.byType(EditableText).first, '  Alice ');
      await tester.enterText(find.byType(EditableText).last, 'bad');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Note is bad'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).last, 'ok');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(result, <String, String>{'name': 'Alice', 'note': 'ok'});
    });

    testWidgets('form accepts custom inputs and an initial value, and cancel resolves null', (
      tester,
    ) async {
      Map<String, String>? result = <String, String>{};
      await pumpOpener(tester, (context) async {
        result = await showCharcoalFormDialog(
          context,
          title: 'Edit',
          fields: [
            CharcoalFormDialogField(
              key: 'kind',
              label: 'Kind',
              initialValue: 'a',
              builder: (context, controller, submit) => CharcoalButton(
                onPressed: () => controller.text = 'b',
                child: const Text('Pick b'),
              ),
            ),
          ],
        );
      });
      await openIt(tester);
      await tester.tap(find.text('Pick b'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(result, <String, String>{'kind': 'b'});

      await openIt(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isNull);
    });

    testWidgets('form survives the keyboard and a short window', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      addTearDown(tester.view.resetViewInsets);
      await pumpOpener(tester, (context) async {
        await showCharcoalFormDialog(
          context,
          title: 'Many',
          fields: [
            for (var i = 0; i < 6; i++)
              CharcoalFormDialogField(key: 'f$i', label: 'Field $i', placeholder: 'p$i'),
          ],
        );
      }, size: const Size(400, 640));
      await openIt(tester);
      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.text('Save')).bottom, lessThanOrEqualTo(640 - 260));
    });

    testWidgets('code dialog filters lines, copies what is shown and toasts', (tester) async {
      String? clip;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (
        call,
      ) async {
        if (call.method == 'Clipboard.setData') {
          clip = (call.arguments as Map)['text'] as String;
        }
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpOpener(tester, (context) async {
        await showCharcoalCodeDialog(
          context,
          title: 'Log',
          code: 'INFO start\nERROR boom\nINFO end',
          filterable: true,
          primaryLabel: 'Retry',
        );
      });
      await openIt(tester);
      expect(find.textContaining('INFO start'), findsOneWidget);

      await tester.tap(find.text('Copy all'));
      await tester.pump();
      expect(clip, 'INFO start\nERROR boom\nINFO end');
      expect(find.text('Copied'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final filter = find.descendant(
        of: find.byType(CharcoalSearchField),
        matching: find.byType(EditableText),
      );
      await tester.enterText(filter, 'error');
      await tester.pump();
      expect(find.textContaining('INFO start'), findsNothing);
      expect(find.textContaining('ERROR boom'), findsOneWidget);
      await tester.tap(find.text('Copy filtered'));
      await tester.pump();
      expect(clip, 'ERROR boom');

      await tester.enterText(filter, 'zzz');
      await tester.pump();
      expect(find.text('No matching lines'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('code dialog resolves true on the primary action', (tester) async {
      bool? result;
      await pumpOpener(tester, (context) async {
        result = await showCharcoalCodeDialog(
          context,
          title: 'Config',
          code: '{}',
          primaryLabel: 'Apply',
        );
      });
      await openIt(tester);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(result, isTrue);
    });

    testWidgets('choice dialog resolves the tapped value and activates from the keyboard', (
      tester,
    ) async {
      String? result;
      await pumpOpener(tester, (context) async {
        result = await showCharcoalChoiceDialog<String>(
          context,
          title: 'Add app',
          description: 'Pick a platform',
          choices: const [
            CharcoalChoice(label: 'Apple', value: 'apple'),
            CharcoalChoice(
              label: 'Google',
              value: 'google',
              leading: CharcoalIcon(CharcoalIcons.image),
            ),
          ],
        );
      });
      await openIt(tester);
      expect(find.text('Pick a platform'), findsOneWidget);
      await tester.tap(find.text('Google'));
      await tester.pumpAndSettle();
      expect(result, 'google');

      await openIt(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab); // close button
      await tester.sendKeyEvent(LogicalKeyboardKey.tab); // Apple
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(result, 'apple');
    });
  });
}
