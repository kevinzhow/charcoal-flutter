import 'dart:ui' show Tristate;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

const _homeKey = ValueKey<String>('home-tab');
const _messagesKey = ValueKey<String>('messages-tab');

void main() {
  testWidgets('reports selection and updates controlled selected semantics', (tester) async {
    await tester.pumpWidget(charcoalTestApp(const _TabBarHarness()));

    expect(
      tester.getSemantics(find.byKey(_homeKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(
      tester.getSemantics(find.byKey(_messagesKey)).flagsCollection.isSelected,
      Tristate.isFalse,
    );

    await tester.tap(find.byKey(_messagesKey));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(_homeKey)).flagsCollection.isSelected,
      Tristate.isFalse,
    );
    expect(
      tester.getSemantics(find.byKey(_messagesKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('switches persistent selection in one painted frame', (
    tester,
  ) async {
    await tester.pumpWidget(charcoalTestApp(const _TabBarHarness()));

    final theme = CharcoalTheme.of(
      tester.element(find.byType(CharcoalTabBar<String>)),
    );
    Color paintedBackground(Key key) {
      final animated = find.descendant(
        of: find.byKey(key),
        matching: find.byType(AnimatedContainer),
      );
      final decorated = find.descendant(
        of: animated,
        matching: find.byType(DecoratedBox),
      );
      return (tester.widget<DecoratedBox>(decorated.first).decoration as BoxDecoration).color!;
    }

    expect(
      paintedBackground(_homeKey),
      theme.colors.containerSecondaryDefaultA,
    );
    expect(
      paintedBackground(_messagesKey),
      theme.colors.backgroundDefault,
    );

    await tester.tap(find.byKey(_messagesKey));
    await tester.pump();

    expect(paintedBackground(_homeKey), theme.colors.backgroundDefault);
    expect(
      paintedBackground(_messagesKey),
      theme.colors.containerSecondaryDefaultA,
    );
  });

  testWidgets('exposes tab and tab-bar semantic roles with badge context', (tester) async {
    await tester.pumpWidget(charcoalTestApp(const _TabBarHarness()));

    final bar = tester.getSemantics(find.byType(CharcoalTabBar<String>));
    final messages = tester.getSemantics(find.byKey(_messagesKey));
    expect(bar.role, SemanticsRole.tabBar);
    expect(messages.role, SemanticsRole.tab);
    expect(messages.label, 'Messages, 3 unread');
    expect(messages.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
  });

  testWidgets('disabled destinations do not report selection', (tester) async {
    var changes = 0;
    await tester.pumpWidget(
      charcoalTestApp(
        CharcoalTabBar<String>(
          items: const <CharcoalTabItem<String>>[
            CharcoalTabItem<String>(
              icon: CharcoalIcon(CharcoalIcons.home),
              label: 'Home',
              value: 'home',
            ),
            CharcoalTabItem<String>(
              enabled: false,
              icon: CharcoalIcon(CharcoalIcons.personCircle),
              key: ValueKey<String>('disabled-tab'),
              label: 'Profile',
              value: 'profile',
            ),
          ],
          onChanged: (_) => changes += 1,
          value: 'home',
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('disabled-tab')));
    expect(changes, 0);
    expect(
      tester
          .getSemantics(find.byKey(const ValueKey<String>('disabled-tab')))
          .flagsCollection
          .isEnabled,
      Tristate.isFalse,
    );
  });

  testWidgets('supports keyboard focus and activation in destination order', (
    tester,
  ) async {
    await tester.pumpWidget(charcoalTestApp(const _TabBarHarness()));

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(_messagesKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('removes interaction motion when animations are disabled', (tester) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: _TabBarHarness(),
        ),
      ),
    );

    for (final container in tester.widgetList<AnimatedContainer>(find.byType(AnimatedContainer))) {
      expect(container.duration, Duration.zero);
    }
    for (final opacity in tester.widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))) {
      expect(opacity.duration, Duration.zero);
    }
  });

  testWidgets('grows beyond its baseline for accessibility text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      charcoalTestApp(
        const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(3)),
          child: SizedBox(width: 320, child: _TabBarHarness()),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(CharcoalTabBar<String>)).height,
      greaterThan(64),
    );
    expect(tester.takeException(), isNull);
  });

  test('requires a full semantic label when a badge is visible', () {
    expect(
      () => CharcoalTabItem<String>(
        badge: '3',
        icon: const SizedBox(),
        label: 'Messages',
        value: 'messages',
      ),
      throwsAssertionError,
    );
  });
}

final class _TabBarHarness extends StatefulWidget {
  const _TabBarHarness();

  @override
  State<_TabBarHarness> createState() => _TabBarHarnessState();
}

final class _TabBarHarnessState extends State<_TabBarHarness> {
  String destination = 'home';

  @override
  Widget build(BuildContext context) => CharcoalTabBar<String>(
    items: const <CharcoalTabItem<String>>[
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.home),
        key: _homeKey,
        label: 'Home',
        value: 'home',
      ),
      CharcoalTabItem<String>(
        badge: '3',
        icon: CharcoalIcon(CharcoalIcons.message),
        key: _messagesKey,
        label: 'Messages',
        semanticLabel: 'Messages, 3 unread',
        value: 'messages',
      ),
    ],
    onChanged: (value) => setState(() => destination = value),
    semanticLabel: 'Primary destinations',
    value: destination,
  );
}
