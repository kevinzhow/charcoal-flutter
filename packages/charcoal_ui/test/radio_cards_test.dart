import 'dart:ui' show CheckedState, Tristate;

import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

const _options = <CharcoalRadioCardOption<String>>[
  CharcoalRadioCardOption(value: 'none', title: 'Not set', description: 'Keep the current route'),
  CharcoalRadioCardOption(value: 'large', title: 'Whisper large', description: 'x3k9wq'),
  CharcoalRadioCardOption(
    value: 'old',
    title: 'Old cluster',
    description: 'Stopped',
    enabled: false,
  ),
  CharcoalRadioCardOption(value: 'turbo', title: 'Turbo', description: 'b8n2r5'),
];

/// Mounts the cards with a value the test can read back; returns the change log.
Future<List<String>> _mount(WidgetTester tester, {String? initial}) async {
  final changes = <String>[];
  var value = initial;
  await pumpCharcoal(
    tester,
    Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 480,
        child: Column(
          children: [
            StatefulBuilder(
              builder: (context, setState) => CharcoalRadioCards<String>(
                value: value,
                options: _options,
                onChanged: (next) => setState(() {
                  changes.add(next);
                  value = next;
                }),
              ),
            ),
            CharcoalButton(onPressed: () {}, child: const Text('After')),
          ],
        ),
      ),
    ),
  );
  return changes;
}

Finder _card(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(CharcoalClickable));

BoxDecoration _decoration(WidgetTester tester, String title) =>
    tester
            .widget<AnimatedContainer>(
              find.descendant(of: _card(title), matching: find.byType(AnimatedContainer)).first,
            )
            .decoration!
        as BoxDecoration;

void main() {
  testWidgets('tapping a card chooses it; a disabled card is readable but inert', (tester) async {
    final changes = await _mount(tester, initial: 'none');
    final theme = CharcoalTheme.of(tester.element(find.byType(CharcoalRadioCards<String>)));
    final colors = theme.colors;
    expect(_decoration(tester, 'Not set').color, theme.tone(CharcoalTone.info).surface);
    expect((_decoration(tester, 'Not set').border! as Border).top.color, colors.borderSelected);
    expect((_decoration(tester, 'Turbo').border! as Border).top.color, colors.borderSubtle);

    await tester.tap(find.text('Turbo'));
    await tester.pump();
    await tester.tap(find.text('Stopped'));
    await tester.pump();
    expect(changes, ['turbo']);
    expect(_decoration(tester, 'Turbo').color, theme.tone(CharcoalTone.info).surface);
    expect(_decoration(tester, 'Not set').color, colors.background);

    final disabled = tester.widget<Text>(find.text('Old cluster')).style!;
    expect(disabled.color, colors.textTertiary);
    expect(tester.widget<Text>(find.text('Turbo')).style!.color, colors.text);
  });

  testWidgets('each card is one radio node with its title and description', (tester) async {
    await _mount(tester, initial: 'large');
    final chosen = tester.getSemantics(_card('Whisper large')).getSemanticsData();
    expect(chosen.label, 'Whisper large\nx3k9wq');
    expect(chosen.flagsCollection.isChecked, CheckedState.isTrue);
    expect(chosen.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
    expect(tester.getSemantics(_card('Turbo')).flagsCollection.isChecked, CheckedState.isFalse);
    expect(
      tester.getSemantics(_card('Old cluster')).flagsCollection.isEnabled,
      Tristate.isFalse,
    );
  });

  testWidgets('one tab stop; arrows move the choice over enabled options and wrap', (
    tester,
  ) async {
    final changes = await _mount(tester, initial: 'large');
    bool focused(String title) =>
        tester.widget<CharcoalClickable>(_card(title)).focusNode!.hasPrimaryFocus;

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(focused('Whisper large'), isTrue, reason: 'Tab enters at the chosen option');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(changes, ['turbo'], reason: 'the disabled option is skipped');
    expect(focused('Turbo'), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(changes.last, 'none', reason: 'wraps to the top');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(changes, ['turbo', 'none', 'turbo', 'large']);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(
      ['Not set', 'Whisper large', 'Turbo'].any(focused),
      isFalse,
      reason: 'Tab leaves the group',
    );
  });

  testWidgets('without a value the first enabled option takes focus and Space chooses it', (
    tester,
  ) async {
    final changes = await _mount(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(changes, ['none']);
  });

  testWidgets('the indicator sits on the title line', (tester) async {
    await _mount(tester, initial: 'none');
    final indicator = tester.getCenter(
      find.descendant(of: _card('Turbo'), matching: find.byType(AnimatedContainer)).at(1),
    );
    final title = tester.getRect(find.text('Turbo'));
    expect(indicator.dy, moreOrLessEquals(title.center.dy, epsilon: 0.5));
  });

  testWidgets('a null onChanged disables every card', (tester) async {
    await pumpCharcoal(
      tester,
      const CharcoalRadioCards<String>(value: 'none', options: _options),
    );
    for (final option in _options) {
      expect(
        tester.getSemantics(_card(option.title)).flagsCollection.isEnabled,
        Tristate.isFalse,
      );
    }
  });
}
