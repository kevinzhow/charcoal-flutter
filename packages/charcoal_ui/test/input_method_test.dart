import 'dart:ui' show PointerDeviceKind;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/components/text/text_input_refresh.dart';
import 'package:flutter/semantics.dart' show SemanticsAction;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

// Input methods (Chinese, Japanese) compose marked text before committing it. On macOS a resized
// window can leave the engine's text input view without key input, and while a composition is
// open Enter, Escape and the arrows belong to the input method.

final _macOS = TargetPlatformVariant.only(TargetPlatform.macOS);

const _composing = TextEditingValue(
  text: 'nihao',
  selection: TextSelection.collapsed(offset: 5),
  composing: TextRange(start: 0, end: 5),
);

const _committed = TextEditingValue(
  text: '你好',
  selection: TextSelection.collapsed(offset: 2),
);

List<String> _calls(WidgetTester tester) => [
  for (final call in tester.testTextInput.log) call.method,
];

Future<void> _resize(WidgetTester tester) async {
  tester.view.physicalSize = const Size(900, 600);
  await tester.pump();
  await tester.pump();
}

/// Mounts [field] in an 800x600 window and focuses its editor when [focus].
Future<void> _mount(WidgetTester tester, Widget field, {bool focus = true}) async {
  await pumpCharcoal(
    tester,
    Center(child: SizedBox(width: 320, child: field)),
    size: const Size(800, 600),
  );
  if (focus) {
    await tester.tap(find.byType(EditableText));
    await tester.pump();
  }
}

/// Presses [key] as a hardware key and returns whether the framework handled it.
///
/// A key the framework leaves unhandled goes to the platform text input, where an open
/// composition takes it. The test platform has no input method, so this skips the test text
/// input's no-composition fallback (for example Escape as `cancelOperation:`).
Future<bool> _press(LogicalKeyboardKey key) async {
  final handled = await KeyEventSimulator.simulateKeyDownEvent(key);
  await KeyEventSimulator.simulateKeyUpEvent(key);
  return handled;
}

/// Puts [value] into the focused editor as the platform input method would.
Future<void> _type(WidgetTester tester, TextEditingValue value) async {
  tester.testTextInput.updateEditingValue(value);
  await tester.pump();
}

void main() {
  test('charcoalIsComposing is true only for a non-empty composing range', () {
    expect(charcoalIsComposing(_composing), isTrue);
    expect(charcoalIsComposing(_committed), isFalse);
    expect(
      charcoalIsComposing(
        const TextEditingValue(text: 'ab', composing: TextRange.collapsed(1)),
      ),
      isFalse,
    );
  });

  group('text input refresh', () {
    for (final (name, field) in <(String, Widget)>[
      ('text field', const CharcoalTextField()),
      ('text area', const CharcoalTextArea()),
      ('search field', CharcoalSearchField(controller: TextEditingController())),
    ]) {
      testWidgets('a resize shows the focused $name again, on the same client', (tester) async {
        await _mount(tester, field);
        tester.testTextInput.log.clear();
        await _resize(tester);
        expect(_calls(tester), contains('TextInput.show'));
        expect(_calls(tester), isNot(contains('TextInput.setClient')));
        expect(_calls(tester), isNot(contains('TextInput.clearClient')));
      }, variant: _macOS);
    }

    testWidgets('a composition is not disturbed by the show', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await _mount(tester, CharcoalTextField(controller: controller));
      await _type(tester, _composing);
      await _resize(tester);
      expect(controller.value, _composing);
    }, variant: _macOS);

    testWidgets('nothing is sent when no field is focused', (tester) async {
      await _mount(tester, const CharcoalTextField(), focus: false);
      tester.testTextInput.log.clear();
      await _resize(tester);
      expect(_calls(tester), isNot(contains('TextInput.show')));
    }, variant: _macOS);

    testWidgets('other platforms are left alone', (tester) async {
      await _mount(tester, const CharcoalTextField());
      tester.testTextInput.log.clear();
      await _resize(tester);
      expect(_calls(tester), isNot(contains('TextInput.show')));
    }, variant: TargetPlatformVariant.only(TargetPlatform.windows));

    testWidgets('every mounted editor holds the refresh once and releases it', (tester) async {
      expect(CharcoalTextInputRefresh.debugUsers, 0);
      await pumpCharcoal(
        tester,
        const Column(children: [CharcoalTextField(), CharcoalTextArea(), CharcoalTextField()]),
      );
      expect(CharcoalTextInputRefresh.debugUsers, 3);
      await pumpCharcoal(tester, const CharcoalTextField());
      expect(CharcoalTextInputRefresh.debugUsers, 1);
      await pumpCharcoal(tester, const SizedBox());
      expect(CharcoalTextInputRefresh.debugUsers, 0);
    });
  });

  group('search composition', () {
    testWidgets('emits each committed query once and skips interim and programmatic text', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final changes = <String>[];
      await _mount(tester, CharcoalSearchField(controller: controller, onChanged: changes.add));

      controller.text = 'prefill';
      await tester.pump();
      expect(changes, isEmpty);

      await _type(tester, _composing);
      await _type(tester, _committed.copyWith(composing: const TextRange(start: 0, end: 2)));
      expect(changes, isEmpty);
      await _type(tester, _committed);
      expect(changes, ['你好']);

      await _type(tester, _composing);
      expect(changes, ['你好']);
      const second = TextEditingValue(text: 'こんにちは', selection: TextSelection.collapsed(offset: 5));
      await _type(tester, second);
      await _type(tester, second.copyWith(selection: const TextSelection.collapsed(offset: 0)));
      expect(changes, ['你好', 'こんにちは']);

      controller.clear();
      await tester.pump();
      expect(changes, ['你好', 'こんにちは']);
      await _type(tester, const TextEditingValue(text: 'query'));
      expect(changes, ['你好', 'こんにちは', 'query']);
    });

    testWidgets('tracks composition on the current controller after a swap', (tester) async {
      final original = TextEditingController();
      final replacement = TextEditingController.fromValue(_composing);
      addTearDown(original.dispose);
      addTearDown(replacement.dispose);
      final changes = <String>[];
      Widget search(TextEditingController controller) =>
          CharcoalSearchField(controller: controller, onChanged: changes.add);
      await _mount(tester, search(original));
      await _type(tester, _composing);
      expect(changes, isEmpty);

      await _mount(tester, search(replacement), focus: false);
      original.clearComposing();
      await tester.pump();
      expect(changes, isEmpty);

      await _type(tester, _composing.copyWith(composing: TextRange.empty));
      expect(changes, ['nihao']);
      await _type(tester, _composing);
      await _type(tester, _committed);
      expect(changes, ['nihao', '你好']);
    });

    testWidgets('a commit callback can clear its controller without emitting a second query', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final changes = <String>[];
      await _mount(
        tester,
        CharcoalSearchField(
          controller: controller,
          onChanged: (query) {
            changes.add(query);
            controller.clear();
          },
        ),
      );

      await _type(tester, _composing);
      await _type(tester, _composing.copyWith(composing: TextRange.empty));
      expect(changes, ['nihao']);
      expect(controller.text, isEmpty);
    });

    testWidgets('drops a pending same-text commit after a controller write or a new composition', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final changes = <String>[];
      await _mount(tester, CharcoalSearchField(controller: controller, onChanged: changes.add));

      await _type(tester, _composing);
      controller.clearComposing();
      controller.text = 'replacement';
      await tester.pump();
      expect(changes, isEmpty);

      await _type(tester, _composing);
      controller.clearComposing();
      controller.value = _composing;
      controller.clearComposing();
      controller.selection = const TextSelection.collapsed(offset: 0);
      await tester.pump();
      expect(changes, ['nihao']);
    });

    testWidgets('blocks a pending clear tap as soon as composing begins', (tester) async {
      final controller = TextEditingController(text: 'previous');
      addTearDown(controller.dispose);
      var clears = 0;
      final changes = <String>[];
      await _mount(
        tester,
        CharcoalSearchField(
          controller: controller,
          onChanged: changes.add,
          onClear: () {
            clears++;
            controller.clear();
          },
        ),
      );

      final clear = find.bySemanticsLabel('Clear');
      final tap = await tester.startGesture(tester.getCenter(clear));
      tester.testTextInput.updateEditingValue(_composing);
      // Pointer up arrives before the clear affordance can rebuild.
      await tap.up();
      await tester.pump();
      expect(clears, 0);
      expect(controller.value, _composing);
      expect(changes, isEmpty);

      expect(tester.getSemantics(clear).getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      await tester.tap(clear, kind: PointerDeviceKind.mouse);
      await tester.pump();
      expect(controller.value, _composing);
      expect(clears, 0);

      await _type(tester, _committed);
      await tester.tap(clear);
      await tester.pump();
      expect(clears, 1);
      expect(controller.text, isEmpty);
      expect(changes, ['你好']);
    });
  });

  group('text input configuration', () {
    testWidgets('obscured input retains password autofill without suggestions', (tester) async {
      await _mount(
        tester,
        const CharcoalTextField(
          obscureText: true,
          autofillHints: [AutofillHints.password],
          textInputAction: TextInputAction.done,
        ),
      );
      final config = tester.testTextInput.setClientArgs!;
      expect(config['autofill'], containsPair('hints', [AutofillHints.password]));
      expect(config['obscureText'], isTrue);
      expect(config['autocorrect'], isFalse);
      expect(config['enableSuggestions'], isFalse);
      expect(config['inputAction'], 'TextInputAction.done');
    });

    testWidgets('autofill infers the keyboard unless the caller specifies one', (tester) async {
      await _mount(tester, const CharcoalTextField(autofillHints: [AutofillHints.email]));
      expect(
        tester.testTextInput.setClientArgs!['inputType'],
        TextInputType.emailAddress.toJson(),
      );
      await _mount(
        tester,
        const CharcoalTextField(
          key: ValueKey('explicit keyboard'),
          autofillHints: [AutofillHints.email],
          keyboardType: TextInputType.visiblePassword,
        ),
      );
      expect(
        tester.testTextInput.setClientArgs!['inputType'],
        TextInputType.visiblePassword.toJson(),
      );
    });

    testWidgets('a bare app honors controlled focus and controller replacement', (tester) async {
      final blocked = FocusNode(canRequestFocus: false);
      final focus = FocusNode();
      final original = TextEditingController(text: 'old');
      final replacement = TextEditingController(text: 'new');
      addTearDown(blocked.dispose);
      addTearDown(focus.dispose);
      addTearDown(original.dispose);
      addTearDown(replacement.dispose);

      Future<void> mount(
        TextEditingController controller,
        FocusNode node, {
        bool disabled = false,
      }) => tester.pumpWidget(
        CharcoalApp(
          home: Center(
            child: SizedBox(
              width: 320,
              child: CharcoalTextField(
                controller: controller,
                focusNode: node,
                disabled: disabled,
              ),
            ),
          ),
        ),
      );

      await mount(original, blocked);
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(blocked.canRequestFocus, isFalse);
      expect(blocked.hasFocus, isFalse);

      await mount(replacement, focus, disabled: true);
      await tester.tap(find.byType(EditableText), warnIfMissed: false);
      await tester.pump();
      expect(focus.hasFocus, isFalse);

      await mount(replacement, focus);
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(focus.hasPrimaryFocus, isTrue);
      await _type(tester, _committed);
      expect(replacement.text, '你好');
      expect(original.text, 'old');

      await tester.pumpWidget(const SizedBox());
      replacement.clear();
      expect(replacement.text, isEmpty);
      expect(focus.canRequestFocus, isTrue);
    });
  });

  group('composing keys', () {
    testWidgets('Escape cancels the composition instead of closing a modal', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpCharcoal(
        tester,
        Builder(
          builder: (context) => CharcoalButton(
            onPressed: () => showCharcoalModal<void>(
              context: context,
              title: 'Rename',
              child: CharcoalTextField(controller: controller, label: 'Name'),
            ),
            child: const Text('Open'),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(EditableText));
      await tester.pump();

      await _type(tester, _composing);
      expect(await _press(LogicalKeyboardKey.escape), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsOneWidget, reason: 'the input method owns Escape');

      await _type(tester, _committed);
      expect(await _press(LogicalKeyboardKey.escape), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Rename'), findsNothing, reason: 'Escape closes the modal again');
    }, variant: _macOS);

    for (final multiline in [false, true]) {
      final name = multiline ? 'text area' : 'text field';
      testWidgets('Enter confirms the composition instead of submitting ($name)', (
        tester,
      ) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);
        var submits = 0;
        await _mount(
          tester,
          CallbackShortcuts(
            bindings: {const SingleActivator(LogicalKeyboardKey.enter): () => submits++},
            child: multiline
                ? CharcoalTextArea(controller: controller)
                : CharcoalTextField(controller: controller),
          ),
        );

        await _type(tester, _composing);
        expect(await _press(LogicalKeyboardKey.enter), isFalse);
        expect(await _press(LogicalKeyboardKey.numpadEnter), isFalse);
        expect(submits, 0);
        expect(controller.value, _composing);

        await _type(tester, _committed);
        expect(await _press(LogicalKeyboardKey.enter), isTrue);
        expect(submits, 1);
      }, variant: _macOS);
    }

    testWidgets('arrow keys pick a candidate instead of moving a list', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final moves = <LogicalKeyboardKey>[];
      const arrows = [
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.arrowUp,
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.arrowRight,
      ];
      await _mount(
        tester,
        Focus(
          onKeyEvent: (node, event) {
            if (event is! KeyDownEvent || !arrows.contains(event.logicalKey)) {
              return KeyEventResult.ignored;
            }
            moves.add(event.logicalKey);
            return KeyEventResult.handled;
          },
          child: CharcoalSearchField(controller: controller),
        ),
      );

      await _type(tester, _composing);
      for (final arrow in arrows) {
        expect(await _press(arrow), isFalse);
      }
      expect(moves, isEmpty);
      expect(controller.value, _composing, reason: 'the caret stays for the input method');

      await _type(tester, _committed);
      expect(await _press(LogicalKeyboardKey.arrowDown), isTrue);
      expect(moves, [LogicalKeyboardKey.arrowDown]);
    }, variant: _macOS);

    testWidgets('other keys still reach the handlers above while composing', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      var saves = 0;
      await _mount(
        tester,
        CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () => saves++},
          child: CharcoalTextField(controller: controller),
        ),
      );
      await _type(tester, _composing);
      await KeyEventSimulator.simulateKeyDownEvent(LogicalKeyboardKey.metaLeft);
      expect(await _press(LogicalKeyboardKey.keyS), isTrue);
      await KeyEventSimulator.simulateKeyUpEvent(LogicalKeyboardKey.metaLeft);
      expect(saves, 1);
    }, variant: _macOS);
  });
}
