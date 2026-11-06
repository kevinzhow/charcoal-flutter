import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui/testing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

/// Behaviour of the pieces added so the Agent Ready examples compose instead of styling: every
/// value comes from the pack (checked under extremePack, where no number is the default).
void main() {
  final pack = extremePack(Brightness.light);

  BoxDecoration decorationOf(WidgetTester tester, Finder finder) =>
      tester
              .widget<DecoratedBox>(
                find.descendant(of: finder, matching: find.byType(DecoratedBox)).first,
              )
              .decoration
          as BoxDecoration;

  testWidgets('a raised card fills with the page colour and paints the states it is given', (
    tester,
  ) async {
    Widget card(Set<WidgetState>? states) => Align(
      alignment: Alignment.topLeft,
      child: CharcoalCard(
        key: const ValueKey('card'),
        raised: true,
        states: states,
        child: const SizedBox(width: 10, height: 10),
      ),
    );
    await pumpCharcoal(tester, card(null), pack: pack);
    final rest = decorationOf(tester, find.byKey(const ValueKey('card')));
    expect(rest.color, pack.colors.background);
    expect((rest.border! as Border).top.color, pack.colors.borderSubtle);
    final restSize = tester.getSize(find.byKey(const ValueKey('card')));

    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: CharcoalCard(key: ValueKey('unread'), highlighted: true, child: SizedBox()),
      ),
      pack: pack,
    );
    expect(
      decorationOf(tester, find.byKey(const ValueKey('unread'))).color,
      pack.colors.surfaceSecondary,
    );

    await pumpCharcoal(tester, card(const {WidgetState.focused}), pack: pack);
    await tester.pumpAndSettle();
    final focused = decorationOf(tester, find.byKey(const ValueKey('card')));
    expect((focused.border! as Border).top.color, pack.colors.borderFocus);
    expect(tester.getSize(find.byKey(const ValueKey('card'))), restSize);

    await pumpCharcoal(tester, card(const {WidgetState.pressed}), pack: pack);
    await tester.pumpAndSettle();
    final overlay = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byKey(const ValueKey('card')),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => (box.decoration as BoxDecoration).color);
    expect(overlay, contains(pack.colors.pressOverlay));
    expect(tester.getSize(find.byKey(const ValueKey('card'))), restSize);
  });

  testWidgets('press feedback fades only while pressed', (tester) async {
    await pumpCharcoal(
      tester,
      Center(
        child: CharcoalClickable(
          onPressed: () {},
          semanticLabel: 'Open',
          builder: (context, states) => CharcoalPressFeedback(
            states: states,
            child: const SizedBox(width: 40, height: 40),
          ),
        ),
      ),
      pack: pack,
    );
    double opacity() => tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity;
    expect(opacity(), 1);
    final gesture = await tester.startGesture(tester.getCenter(find.byType(CharcoalPressFeedback)));
    await tester.pump();
    expect(opacity(), pack.metrics.clickable.pressedOpacity);
    await gesture.up();
    await tester.pump();
    expect(opacity(), 1);
  });

  testWidgets('a toned avatar shows its initials on the tone fill; extraLarge is sizes.avatarXl', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CharcoalAvatar(
              'Aki Kondo',
              key: ValueKey('toned'),
              initials: 'AK',
              tone: CharcoalTone.negative,
            ),
            CharcoalAvatar('Mina', key: ValueKey('xl'), size: CharcoalAvatarSize.extraLarge),
          ],
        ),
      ),
      pack: pack,
    );
    expect(find.text('AK'), findsOneWidget);
    final container = tester.widget<Container>(
      find.descendant(of: find.byKey(const ValueKey('toned')), matching: find.byType(Container)),
    );
    expect((container.decoration! as BoxDecoration).color, pack.colors.negative);
    expect(tester.getSize(find.byKey(const ValueKey('xl'))).width, pack.sizes.avatarXl);
    expect(find.bySemanticsLabel('Aki Kondo'), findsOneWidget);
  });

  testWidgets('an icon-button badge sits over the top end corner and stays out of semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpCharcoal(
      tester,
      Center(
        child: CharcoalIconButton(
          badge: '3',
          icon: const CharcoalIcon(CharcoalIcons.bell),
          onPressed: () {},
          semanticLabel: 'Notifications, 3 unread',
        ),
      ),
      pack: pack,
    );
    expect(find.text('3'), findsOneWidget);
    expect(find.bySemanticsLabel('Notifications, 3 unread'), findsOneWidget);
    expect(find.bySemanticsLabel('3'), findsNothing);
    final button = tester.getRect(find.byType(CharcoalClickable));
    final badge = tester.getRect(
      find.ancestor(of: find.text('3'), matching: find.byType(DecoratedBox)).first,
    );
    expect(badge.top, closeTo(button.top + pack.metrics.iconButton.badgeOffsetTop, 1e-6));
    expect(badge.right, closeTo(button.right - pack.metrics.iconButton.badgeOffsetEnd, 1e-6));
    handle.dispose();
  });

  testWidgets('placeholder artwork takes the default height in a column and fills a bounded box', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CharcoalPlaceholderArtwork(key: ValueKey('free'), seed: 1, semanticLabel: 'Study'),
            SizedBox(
              height: 90,
              child: CharcoalPlaceholderArtwork(
                key: ValueKey('bounded'),
                rounded: true,
                seed: 2,
                semanticLabel: 'Tile',
              ),
            ),
          ],
        ),
      ),
      pack: pack,
      size: const Size(400, 800),
    );
    expect(tester.getSize(find.byKey(const ValueKey('free'))).height, pack.metrics.artwork.height);
    expect(tester.getSize(find.byKey(const ValueKey('bounded'))).height, 90);
    expect(find.bySemanticsLabel('Study'), findsOneWidget);
  });

  testWidgets('a message bubble wraps at sizes.messageBubbleMaxWidth', (tester) async {
    await pumpCharcoal(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: CharcoalMessageBubble(
          List<String>.filled(40, 'word').join(' '),
          key: const ValueKey('bubble'),
          outgoing: true,
        ),
      ),
      pack: pack,
      size: const Size(800, 600),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('bubble'))).width,
      lessThanOrEqualTo(pack.sizes.messageBubbleMaxWidth),
    );
    expect(decorationOf(tester, find.byKey(const ValueKey('bubble'))).color, pack.colors.primary);
  });

  testWidgets('the progress bar reports its percentage', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpCharcoal(
      tester,
      const Center(
        child: SizedBox(
          width: 200,
          child: CharcoalProgressBar(value: 0.5, semanticLabel: 'Upload'),
        ),
      ),
      pack: pack,
    );
    expect(tester.getSemantics(find.byType(CharcoalProgressBar)).value, '50%');
    expect(tester.getSize(find.byType(CharcoalProgressBar)).height, pack.sizes.meterTrack);
    handle.dispose();
  });

  testWidgets('the inline spinner, carousel default height and secondary page come from the pack', (
    tester,
  ) async {
    await pumpCharcoal(
      tester,
      CharcoalScaffold(
        background: CharcoalPageBackground.secondary,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(child: CharcoalLoadingSpinner.inline(semanticLabel: 'Sending')),
              CharcoalCarousel(
                key: const ValueKey('carousel'),
                spacing: CharcoalSpace.sm,
                children: const [SizedBox.expand(), SizedBox.expand()],
              ),
            ],
          ),
        ),
      ),
      pack: pack,
      size: const Size(400, 800),
      settle: false,
    );
    await tester.pump();
    expect(
      tester.getSize(find.byType(CharcoalLoadingSpinner)).width,
      pack.metrics.spinner.inlineSize,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('carousel'))).height,
      pack.metrics.carousel.defaultHeight,
    );
    final page = tester.widget<ColoredBox>(
      find.descendant(of: find.byType(CharcoalScaffold), matching: find.byType(ColoredBox)).first,
    );
    expect(page.color, pack.colors.backgroundSecondary);
  });

  testWidgets('a motion step is the pack duration and zero under reduced motion', (tester) async {
    late Duration normal;
    late Duration reduced;
    late Curve curve;
    await pumpCharcoal(
      tester,
      Builder(
        builder: (context) {
          normal = CharcoalMotion.standard.resolve(context);
          curve = CharcoalMotion.curveOf(context);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: Builder(
              builder: (context) {
                reduced = CharcoalMotion.standard.resolve(context);
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
      pack: pack,
    );
    expect(normal, pack.motion.standard);
    expect(curve, pack.motion.curve);
    expect(reduced, Duration.zero);
  });
}
