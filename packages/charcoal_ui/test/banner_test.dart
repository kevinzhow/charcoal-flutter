import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/geometry.dart';

void main() {
  const pack = charcoalLightPack;

  BoxDecoration decorationOf(WidgetTester tester) => tester
      .widgetList<Container>(
        find.descendant(of: find.byType(CharcoalBanner), matching: find.byType(Container)),
      )
      .map((c) => c.decoration)
      .whereType<BoxDecoration>()
      .first;

  testWidgets('every tone paints its surface, text and icon colour; neutral is grey', (
    tester,
  ) async {
    for (final tone in CharcoalTone.values) {
      await pumpLoose(
        tester,
        CharcoalBanner(tone: tone, icon: CharcoalIcons.alert, message: 'Message'),
      );
      final colors = CharcoalTheme(pack).tone(tone);
      final decoration = decorationOf(tester);
      expect(
        decoration.color,
        tone == CharcoalTone.neutral ? pack.colors.backgroundSecondary : colors.surface,
        reason: tone.name,
      );
      final text = tester.widget<Text>(find.text('Message'));
      expect(
        text.style!.color,
        tone == CharcoalTone.neutral ? pack.colors.textSecondary : colors.foreground,
        reason: tone.name,
      );
      expect(tester.widget<CharcoalIcon>(find.byType(CharcoalIcon)).color, colors.icon);
      expect(decoration.borderRadius, BorderRadius.circular(pack.radius.md));
    }
  });

  testWidgets('an unfilled banner is a hairline outline; a titled one is two lines', (
    tester,
  ) async {
    await pumpLoose(
      tester,
      const CharcoalBanner(title: 'Title', message: 'Detail', filled: false),
    );
    final decoration = decorationOf(tester);
    expect(decoration.color, isNull);
    final border = decoration.border! as Border;
    expect(border.top.width, pack.borders.hairline);
    expect(border.top.color, pack.colors.borderSubtle);
    expect(
      tester.getTopLeft(find.text('Detail')).dy,
      greaterThan(tester.getTopLeft(find.text('Title')).dy),
    );
  });

  testWidgets('the action stays reachable and the banner is a live region', (tester) async {
    var taps = 0;
    await pumpLoose(
      tester,
      SizedBox(
        width: 420,
        child: CharcoalBanner(
          message: 'Trial ends tomorrow',
          action: CharcoalButton(
            size: CharcoalButtonSize.small,
            onPressed: () => taps++,
            child: const Text('Upgrade'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Upgrade'));
    expect(taps, 1);
    expect(find.bySemanticsLabel('Upgrade'), findsOneWidget);
    final live = tester
        .widgetList<Semantics>(find.byType(Semantics))
        .where(
          (s) => s.properties.liveRegion == true,
        );
    expect(live, isNotEmpty);
  });

  testWidgets('a long message wraps at text scale 3 without overflow', (tester) async {
    await pumpLoose(
      tester,
      const SizedBox(
        width: 320,
        child: CharcoalBanner(
          icon: CharcoalIcons.alert,
          message: 'A long explanation that has to wrap onto several lines to fit.',
          action: Text('Act'),
        ),
      ),
      textScale: 3,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('error state offers retry only when a callback is given', (tester) async {
    var retries = 0;
    await pumpLoose(tester, const CharcoalErrorState(message: 'Boom'));
    expect(find.text('Retry'), findsNothing);
    await pumpLoose(
      tester,
      SizedBox(
        width: 400,
        child: CharcoalErrorState(message: 'Boom', retryLabel: 'Again', onRetry: () => retries++),
      ),
    );
    await tester.tap(find.text('Again'));
    expect(retries, 1);
    final decoration = decorationOf(tester);
    expect(decoration.color, CharcoalTheme(pack).tone(CharcoalTone.negative).surface);
  });

  testWidgets('empty state centres icon, message and wrapping actions', (tester) async {
    await pumpLoose(
      tester,
      SizedBox(
        width: 300,
        child: CharcoalEmptyState(
          icon: CharcoalIcons.image,
          message: 'Nothing here',
          actions: [
            for (var i = 0; i < 4; i++) CharcoalButton(onPressed: () {}, child: Text('Action $i')),
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.widget<Text>(find.text('Nothing here')).style!.color,
      pack.colors.textTertiary,
    );
    expect(tester.widget<CharcoalIcon>(find.byType(CharcoalIcon)).size, pack.sizes.iconXl);
    final message = tester.getCenter(find.text('Nothing here')).dx;
    expect(message, moreOrLessEquals(150, epsilon: 1));
  });

  testWidgets('loading state announces its label under reduced motion', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpLoose(tester, const CharcoalLoadingState(semanticLabel: 'Loading list'));
    expect(find.bySemanticsLabel('Loading list'), findsOneWidget);
    expect(
      tester.getSize(find.byType(CharcoalLoadingState)).height,
      greaterThan(pack.space.xxxl * 2),
    );
  });
}
