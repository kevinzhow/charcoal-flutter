import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/src/components/text/text_input_refresh.dart';
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
