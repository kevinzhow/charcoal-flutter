import 'dart:ui' show Tristate;

import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/gestures.dart' show kPressTimeout;
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

    expect(
      _persistentTabBackground(tester, _homeKey),
      theme.colors.containerSecondaryDefaultA,
    );
    expect(
      _persistentTabBackground(tester, _messagesKey),
      theme.colors.backgroundDefault,
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_messagesKey)),
    );
    await tester.pump(kPressTimeout);
    await tester.pump(CharcoalMotion.fast);

    expect(
      _persistentTabBackground(tester, _homeKey),
      theme.colors.containerSecondaryDefaultA,
    );
    expect(
      _persistentTabBackground(tester, _messagesKey),
      theme.colors.backgroundDefault,
    );
    expect(
      _paintedTabInteractionOverlay(tester, _messagesKey),
      theme.colors.containerSecondaryPressA,
    );

    await gesture.up();
    await tester.pump();

    expect(
      _persistentTabBackground(tester, _homeKey),
      theme.colors.backgroundDefault,
    );
    expect(
      _persistentTabBackground(tester, _messagesKey),
      theme.colors.containerSecondaryDefaultA,
    );
    expect(
      tester.getSemantics(find.byKey(_homeKey)).flagsCollection.isSelected,
      Tristate.isFalse,
    );
    expect(
      tester.getSemantics(find.byKey(_messagesKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('keeps destination centers stable through press and selection', (
    tester,
  ) async {
    await tester.pumpWidget(charcoalTestApp(const _TabBarHarness()));

    final homeBefore = _tabGeometry(tester, _homeKey, 'Home');
    final messagesBefore = _tabGeometry(tester, _messagesKey, 'Messages');
    _expectCenteredTabGeometry(homeBefore);
    _expectCenteredTabGeometry(messagesBefore);
    expect(
      homeBefore.iconCenter.dy,
      moreOrLessEquals(messagesBefore.iconCenter.dy),
    );
    expect(
      homeBefore.labelCenter.dy,
      moreOrLessEquals(messagesBefore.labelCenter.dy),
    );
    expect(
      homeBefore.labelBaseline,
      moreOrLessEquals(messagesBefore.labelBaseline),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_messagesKey)),
    );
    await tester.pump(kPressTimeout);
    await tester.pump(CharcoalMotion.fast);

    _expectSameTabCenters(
      homeBefore,
      _tabGeometry(tester, _homeKey, 'Home'),
    );
    _expectSameTabCenters(
      messagesBefore,
      _tabGeometry(tester, _messagesKey, 'Messages'),
    );

    await gesture.up();
    await tester.pump();

    final homeAfter = _tabGeometry(tester, _homeKey, 'Home');
    final messagesAfter = _tabGeometry(tester, _messagesKey, 'Messages');
    _expectCenteredTabGeometry(homeAfter);
    _expectCenteredTabGeometry(messagesAfter);
    _expectSameTabCenters(homeBefore, homeAfter);
    _expectSameTabCenters(messagesBefore, messagesAfter);
  });

  testWidgets('touch cancellation clears press without changing selection', (
    tester,
  ) async {
    await tester.pumpWidget(charcoalTestApp(const _TabBarHarness()));

    final theme = CharcoalTheme.of(
      tester.element(find.byType(CharcoalTabBar<String>)),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_messagesKey)),
    );
    await tester.pump(kPressTimeout);
    await tester.pump(CharcoalMotion.fast);

    expect(
      _paintedTabInteractionOverlay(tester, _messagesKey),
      theme.colors.containerSecondaryPressA,
    );
    expect(
      tester.getSemantics(find.byKey(_homeKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );

    await gesture.cancel();
    await tester.pumpAndSettle();

    expect(
      _paintedTabInteractionOverlay(tester, _messagesKey),
      theme.colors.containerDefaultA,
    );
    expect(
      _persistentTabBackground(tester, _homeKey),
      theme.colors.containerSecondaryDefaultA,
    );
    expect(
      _persistentTabBackground(tester, _messagesKey),
      theme.colors.backgroundDefault,
    );
    expect(
      tester.getSemantics(find.byKey(_homeKey)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(
      tester.getSemantics(find.byKey(_messagesKey)).flagsCollection.isSelected,
      Tristate.isFalse,
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

Color _persistentTabBackground(WidgetTester tester, Key key) {
  final colored = find.descendant(
    of: find.byKey(key),
    matching: find.byType(ColoredBox),
  );
  return tester.widget<ColoredBox>(colored.first).color;
}

Color _paintedTabInteractionOverlay(WidgetTester tester, Key key) {
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

({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter}) _tabGeometry(
  WidgetTester tester,
  Key key,
  String label,
) {
  final item = find.byKey(key);
  final icon = find.descendant(of: item, matching: find.byType(CharcoalIcon));
  final labelText = find.descendant(of: item, matching: find.text(label));
  final labelBox = tester.renderObject<RenderBox>(labelText);
  return (
    iconCenter: tester.getCenter(icon),
    itemRect: tester.getRect(item),
    labelBaseline:
        tester.getTopLeft(labelText).dy +
        labelBox.getDryBaseline(labelBox.constraints, TextBaseline.alphabetic)!,
    labelCenter: tester.getCenter(labelText),
  );
}

void _expectCenteredTabGeometry(
  ({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter}) geometry,
) {
  expect(
    geometry.iconCenter.dx,
    moreOrLessEquals(geometry.itemRect.center.dx),
  );
  expect(
    geometry.labelCenter.dx,
    moreOrLessEquals(geometry.itemRect.center.dx),
  );
}

void _expectSameTabCenters(
  ({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter}) before,
  ({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter}) after,
) {
  expect(after.itemRect, before.itemRect);
  expect(after.iconCenter, before.iconCenter);
  expect(after.labelCenter, before.labelCenter);
  expect(after.labelBaseline, before.labelBaseline);
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
