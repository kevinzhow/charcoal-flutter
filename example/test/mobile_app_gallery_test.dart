import 'dart:ui' show Tristate;

import 'package:charcoal_icons/charcoal_icons.dart' show CharcoalIcon;
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:charcoal_ui_showcase/agent_examples/agent_example_navigator.dart';
import 'package:charcoal_ui_showcase/agent_examples/mobile_app_gallery.dart';
import 'package:charcoal_ui_showcase/agent_examples/mobile_apps/daylight/widgets/daylight_item_group.dart';
import 'package:charcoal_ui_showcase/agent_examples/mobile_apps/nook/nook_models.dart';
import 'package:flutter/gestures.dart' show kPressTimeout;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tileKeys = <String>[
    'agent-app-tile-social',
    'agent-app-tile-commerce',
    'agent-app-tile-wallet',
    'agent-app-tile-habits',
  ];

  testWidgets('lays out independent Agent Ready tiles on desktop', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 1080, child: _tileCatalog()));

    final topEdges = <double>[];
    for (final key in tileKeys) {
      final tile = find.byKey(ValueKey<String>(key));
      expect(tile, findsOneWidget);
      topEdges.add(tester.getTopLeft(tile).dy);
      expect(tester.getSize(tile).width, lessThan(360));
    }
    expect(topEdges.take(3).toSet(), hasLength(1));
    expect(topEdges.last, greaterThan(topEdges.first));
    expect(find.text('MADE WITH AGENT READY'), findsNWidgets(4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stacks all app tiles on a compact surface', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(width: 320, child: _tileCatalog()));

    var previousTop = -1.0;
    for (final key in tileKeys) {
      final tile = find.byKey(ValueKey<String>(key));
      expect(tile, findsOneWidget);
      expect(tester.getSize(tile).width, 320);
      final top = tester.getTopLeft(tile).dy;
      expect(top, greaterThan(previousTop));
      previousTop = top;
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('all apps share the Bloom-style top-level tab bar', (
    tester,
  ) async {
    for (final app in AgentMobileApp.values) {
      await _pumpSimulator(tester, app);
      final tabBar = find.byWidgetPredicate(
        (widget) => widget is CharcoalTabBar<Object?>,
      );
      expect(tabBar, findsOneWidget, reason: app.name);
      expect(tester.getSize(tabBar).height, 64, reason: app.name);
      if (app == AgentMobileApp.social) {
        final messages = tester
            .widget<CharcoalTabBar<Object?>>(tabBar)
            .items
            .singleWhere((item) => item.label == 'Messages');
        expect(messages.badge, isNotNull);
        expect(messages.semanticLabel, 'Messages, ${messages.badge} unread');
        expect(find.bySemanticsLabel(messages.semanticLabel!), findsOneWidget);
      }
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Daylight keeps repeated items on one visual rhythm', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.habits);

    expect(
      tester.widget<DaylightItemGroup>(find.byType(DaylightItemGroup)).children,
      hasLength(3),
    );
    final firstHabit = find.byKey(
      const ValueKey<String>('agent-habit-stretch-row'),
    );
    final secondHabit = find.byKey(
      const ValueKey<String>('agent-habit-walk-row'),
    );
    expect(
      tester.getTopLeft(secondHabit).dy - tester.getBottomLeft(firstHabit).dy,
      closeTo(8, 0.01),
    );

    for (final (tab, itemCount) in <(String, int)>[
      ('journey', 4),
      ('insights', 3),
      ('profile', 2),
    ]) {
      await _tapVisible(
        tester,
        find.byKey(ValueKey<String>('agent-habits-nav-$tab')),
      );
      expect(
        tester
            .widget<DaylightItemGroup>(find.byType(DaylightItemGroup))
            .children,
        hasLength(itemCount),
        reason: tab,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('embedded details use a real route stack and system back', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.commerce);

    expect(_nestedNavigator(tester, 'commerce').pages, hasLength(1));
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('agent-commerce-product-ripple-cup')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('agent-commerce-product-ripple-cup')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    final navigator = _nestedNavigator(tester, 'commerce');
    expect(navigator.pages, hasLength(2));
    expect(navigator.pages, everyElement(isA<AgentExamplePage>()));
    expect(navigator.pages.map((page) => page.name), <String>[
      '/nook/root-shop',
      '/nook/product-ripple-cup',
    ]);
    expect(
      find.byKey(const ValueKey<String>('agent-commerce-shop-page')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-commerce-product-detail')),
      findsOneWidget,
    );
    expect(
      tester
          .widgetList<SlideTransition>(
            find.descendant(
              of: find.byKey(
                const ValueKey<String>('agent-commerce-navigator'),
              ),
              matching: find.byType(SlideTransition),
            ),
          )
          .any((transition) => transition.position.value != Offset.zero),
      isTrue,
    );
    await tester.pumpAndSettle();

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(_nestedNavigator(tester, 'commerce').pages, hasLength(1));
    expect(
      find.byKey(const ValueKey<String>('agent-commerce-shop-page')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-commerce-product-detail')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('system back guards an unsaved fullscreen route', (tester) async {
    await _pumpSimulator(tester, AgentMobileApp.social);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-new-post')),
    );
    expect(_nestedNavigator(tester, 'social').pages, hasLength(2));
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-social-post-field')),
        matching: find.byType(EditableText),
      ),
      'Keep this thought',
    );
    await tester.pump();
    expect(
      tester
          .widget<CharcoalButton>(
            find.byKey(const ValueKey<String>('agent-social-publish-post')),
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widgetList<PopScope<void>>(find.byType(PopScope<void>))
          .any((scope) => !scope.canPop),
      isTrue,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Leave this post?'), findsOneWidget);
    expect(_nestedNavigator(tester, 'social').pages, hasLength(2));
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-keep-editing-post')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-social-composer-page')),
      findsOneWidget,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-save-draft')),
    );

    expect(_nestedNavigator(tester, 'social').pages, hasLength(1));
    expect(
      find.byKey(const ValueKey<String>('agent-social-composer-page')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a durable completion replaces the task stack', (tester) async {
    await _pumpSimulator(tester, AgentMobileApp.wallet);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-action-topUp')),
    );
    expect(_nestedNavigator(tester, 'wallet').pages, hasLength(2));
    final confirm = find.byKey(
      const ValueKey<String>('agent-wallet-confirm-top-up'),
    );
    await tester.ensureVisible(confirm);
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(_nestedNavigator(tester, 'wallet').pages, hasLength(1));
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-top-up')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-top-up-confirmed')),
      findsOneWidget,
    );
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-top-up-confirmed')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('route motion is removed when animations are disabled', (
    tester,
  ) async {
    await _pumpSimulator(
      tester,
      AgentMobileApp.commerce,
      disableAnimations: true,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('agent-commerce-product-ripple-cup')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('agent-commerce-product-ripple-cup')),
    );
    await tester.pump();

    expect(_nestedNavigator(tester, 'commerce').pages, hasLength(2));
    expect(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-commerce-navigator')),
        matching: find.byType(SlideTransition),
      ),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('agent-commerce-product-detail')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'top-level destinations update one route atomically without push motion',
    (tester) async {
      await _pumpSimulator(tester, AgentMobileApp.commerce);

      final theme = CharcoalTheme.of(
        tester.element(find.byType(CharcoalTabBar<NookDestination>)),
      );
      final shopPage = find.byKey(
        const ValueKey<String>('agent-commerce-shop-page'),
      );
      final rootRoute = ModalRoute.of(tester.element(shopPage));
      final rootPageKey = _nestedNavigator(tester, 'commerce').pages.single.key;
      expect(
        _paintedTabBackground(
          tester,
          const ValueKey<String>('agent-commerce-nav-shop'),
        ),
        theme.colors.containerSecondaryDefaultA,
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('agent-commerce-nav-search')),
      );
      await tester.pump();

      expect(
        _paintedTabBackground(
          tester,
          const ValueKey<String>('agent-commerce-nav-shop'),
        ),
        theme.colors.backgroundDefault,
      );
      expect(
        _paintedTabBackground(
          tester,
          const ValueKey<String>('agent-commerce-nav-search'),
        ),
        theme.colors.containerSecondaryDefaultA,
      );
      final searchPage = find.byKey(
        const ValueKey<String>('agent-commerce-search-page'),
      );
      expect(searchPage, findsOneWidget);
      expect(ModalRoute.of(tester.element(searchPage)), same(rootRoute));
      final navigator = _nestedNavigator(tester, 'commerce');
      expect(navigator.pages, hasLength(1));
      expect(navigator.pages.single.key, rootPageKey);
      expect(navigator.pages.single.name, '/nook/root-search');
      expect(
        tester
            .widgetList<SlideTransition>(
              find.descendant(
                of: find.byKey(
                  const ValueKey<String>('agent-commerce-navigator'),
                ),
                matching: find.byType(SlideTransition),
              ),
            )
            .every((transition) => transition.position.value == Offset.zero),
        isTrue,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('every app keeps its root route stable across tab selection', (
    tester,
  ) async {
    const scenarios =
        <
          ({
            AgentMobileApp app,
            String appKey,
            String initialPageKey,
            String initialTabKey,
            String tabKey,
            String targetPageKey,
          })
        >[
          (
            app: AgentMobileApp.social,
            appKey: 'social',
            initialPageKey: 'agent-social-feed-following',
            initialTabKey: 'agent-social-nav-home',
            tabKey: 'agent-social-nav-discover',
            targetPageKey: 'agent-social-discover-page',
          ),
          (
            app: AgentMobileApp.commerce,
            appKey: 'commerce',
            initialPageKey: 'agent-commerce-shop-page',
            initialTabKey: 'agent-commerce-nav-shop',
            tabKey: 'agent-commerce-nav-search',
            targetPageKey: 'agent-commerce-search-page',
          ),
          (
            app: AgentMobileApp.wallet,
            appKey: 'wallet',
            initialPageKey: 'agent-wallet-home-page',
            initialTabKey: 'agent-wallet-nav-wallet',
            tabKey: 'agent-wallet-nav-activity',
            targetPageKey: 'agent-wallet-activity-page',
          ),
          (
            app: AgentMobileApp.habits,
            appKey: 'habits',
            initialPageKey: 'agent-habits-today-page',
            initialTabKey: 'agent-habits-nav-today',
            tabKey: 'agent-habits-nav-journey',
            targetPageKey: 'agent-habits-journey-page',
          ),
        ];

    for (final scenario in scenarios) {
      await _pumpSimulator(tester, scenario.app);
      final initialPage = find.byKey(ValueKey<String>(scenario.initialPageKey));
      final initialTab = find.byKey(ValueKey<String>(scenario.initialTabKey));
      final targetTab = find.byKey(ValueKey<String>(scenario.tabKey));
      final theme = CharcoalTheme.of(tester.element(initialTab));
      final rootRoute = ModalRoute.of(tester.element(initialPage));
      final rootPageKey = _nestedNavigator(
        tester,
        scenario.appKey,
      ).pages.single.key;
      final initialGeometry = _tabGeometry(
        tester,
        ValueKey<String>(scenario.initialTabKey),
      );
      final targetGeometry = _tabGeometry(
        tester,
        ValueKey<String>(scenario.tabKey),
      );
      _expectCenteredTabGeometry(initialGeometry, reason: scenario.app.name);
      _expectCenteredTabGeometry(targetGeometry, reason: scenario.app.name);
      expect(
        initialGeometry.iconCenter.dy,
        moreOrLessEquals(targetGeometry.iconCenter.dy),
        reason: scenario.app.name,
      );
      expect(
        initialGeometry.labelBaseline,
        moreOrLessEquals(targetGeometry.labelBaseline),
        reason: scenario.app.name,
      );
      expect(
        _paintedTabBackground(tester, ValueKey<String>(scenario.initialTabKey)),
        theme.colors.containerSecondaryDefaultA,
        reason: scenario.app.name,
      );
      expect(
        _paintedTabBackground(tester, ValueKey<String>(scenario.tabKey)),
        theme.colors.backgroundDefault,
        reason: scenario.app.name,
      );

      final cancelledGesture = await tester.startGesture(
        tester.getCenter(targetTab),
      );
      await tester.pump(kPressTimeout);
      await tester.pump(CharcoalMotion.fast);

      expect(
        _paintedTabInteractionOverlay(
          tester,
          ValueKey<String>(scenario.tabKey),
        ),
        theme.colors.containerSecondaryPressA,
        reason: scenario.app.name,
      );
      expect(
        _paintedTabBackground(tester, ValueKey<String>(scenario.initialTabKey)),
        theme.colors.containerSecondaryDefaultA,
        reason: scenario.app.name,
      );
      expect(
        _paintedTabBackground(tester, ValueKey<String>(scenario.tabKey)),
        theme.colors.backgroundDefault,
        reason: scenario.app.name,
      );
      expect(
        tester.getSemantics(initialTab).flagsCollection.isSelected,
        Tristate.isTrue,
        reason: scenario.app.name,
      );
      expect(
        tester.getSemantics(targetTab).flagsCollection.isSelected,
        Tristate.isFalse,
        reason: scenario.app.name,
      );
      expect(initialPage, findsOneWidget, reason: scenario.app.name);
      expect(
        find.byKey(ValueKey<String>(scenario.targetPageKey)),
        findsNothing,
        reason: scenario.app.name,
      );
      expect(
        _nestedNavigator(tester, scenario.appKey).pages.single.key,
        rootPageKey,
        reason: scenario.app.name,
      );
      _expectSameTabGeometry(
        initialGeometry,
        _tabGeometry(tester, ValueKey<String>(scenario.initialTabKey)),
        reason: scenario.app.name,
      );
      _expectSameTabGeometry(
        targetGeometry,
        _tabGeometry(tester, ValueKey<String>(scenario.tabKey)),
        reason: scenario.app.name,
      );

      await cancelledGesture.cancel();
      await tester.pumpAndSettle();

      expect(
        _paintedTabInteractionOverlay(
          tester,
          ValueKey<String>(scenario.tabKey),
        ),
        theme.colors.containerDefaultA,
        reason: scenario.app.name,
      );
      expect(
        tester.getSemantics(initialTab).flagsCollection.isSelected,
        Tristate.isTrue,
        reason: scenario.app.name,
      );
      expect(initialPage, findsOneWidget, reason: scenario.app.name);
      _expectSameTabGeometry(
        initialGeometry,
        _tabGeometry(tester, ValueKey<String>(scenario.initialTabKey)),
        reason: scenario.app.name,
      );
      _expectSameTabGeometry(
        targetGeometry,
        _tabGeometry(tester, ValueKey<String>(scenario.tabKey)),
        reason: scenario.app.name,
      );

      final acceptedGesture = await tester.startGesture(
        tester.getCenter(targetTab),
      );
      await tester.pump(kPressTimeout);
      await tester.pump(CharcoalMotion.fast);
      await acceptedGesture.up();
      await tester.pump();

      expect(
        _paintedTabBackground(tester, ValueKey<String>(scenario.initialTabKey)),
        theme.colors.backgroundDefault,
        reason: scenario.app.name,
      );
      expect(
        _paintedTabBackground(tester, ValueKey<String>(scenario.tabKey)),
        theme.colors.containerSecondaryDefaultA,
        reason: scenario.app.name,
      );
      expect(
        tester.getSemantics(initialTab).flagsCollection.isSelected,
        Tristate.isFalse,
        reason: scenario.app.name,
      );
      expect(
        tester.getSemantics(targetTab).flagsCollection.isSelected,
        Tristate.isTrue,
        reason: scenario.app.name,
      );

      final targetPage = find.byKey(ValueKey<String>(scenario.targetPageKey));
      expect(targetPage, findsOneWidget, reason: scenario.app.name);
      expect(
        ModalRoute.of(tester.element(targetPage)),
        same(rootRoute),
        reason: scenario.app.name,
      );
      final navigator = _nestedNavigator(tester, scenario.appKey);
      expect(navigator.pages, hasLength(1), reason: scenario.app.name);
      expect(
        navigator.pages.single.key,
        rootPageKey,
        reason: scenario.app.name,
      );
      _expectSameTabGeometry(
        initialGeometry,
        _tabGeometry(tester, ValueKey<String>(scenario.initialTabKey)),
        reason: scenario.app.name,
      );
      _expectSameTabGeometry(
        targetGeometry,
        _tabGeometry(tester, ValueKey<String>(scenario.tabKey)),
        reason: scenario.app.name,
      );
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('top-level destinations restore their own scroll position', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.commerce);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-commerce-nav-search')),
    );
    const searchScrollKey = PageStorageKey<String>(
      'agent-commerce-page-scroll-root-search',
    );
    final searchScroll = find.descendant(
      of: find.byKey(searchScrollKey),
      matching: find.byType(Scrollable),
    );
    final searchScrollState = _verticalScrollState(tester, searchScroll);
    await tester.drag(
      find.byWidget(searchScrollState.widget),
      const Offset(0, -260),
    );
    await tester.pumpAndSettle();
    final savedOffset = searchScrollState.position.pixels;
    expect(savedOffset, greaterThan(0));

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-commerce-nav-shop')),
    );
    final shopScroll = find.descendant(
      of: find.byKey(
        const PageStorageKey<String>('agent-commerce-page-scroll-root-shop'),
      ),
      matching: find.byType(Scrollable),
    );
    expect(
      tester
          .stateList<ScrollableState>(shopScroll)
          .where((state) => state.position.axis == Axis.vertical)
          .first
          .position
          .pixels,
      0,
    );

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-commerce-nav-search')),
    );
    final restoredSearchScroll = find.descendant(
      of: find.byKey(searchScrollKey),
      matching: find.byType(Scrollable),
    );
    expect(
      _verticalScrollState(tester, restoredSearchScroll).position.pixels,
      closeTo(savedOffset, 0.1),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bloom completes feed, reaction, save, and message flows', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.social);

    final like = find.byKey(
      const ValueKey<String>('agent-social-like-post-aki-rain'),
    );
    await _tapVisible(tester, like);
    expect(tester.widget<CharcoalIconButton>(like).selected, isTrue);
    expect(find.text('129'), findsOneWidget);

    final save = find.byKey(
      const ValueKey<String>('agent-social-save-post-aki-rain'),
    );
    await _tapVisible(tester, save);
    expect(tester.widget<CharcoalIconButton>(save).selected, isTrue);

    await _tapVisible(
      tester,
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-social-feed-control')),
        matching: find.text('For you'),
      ),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-social-feed-forYou')),
      findsOneWidget,
    );
    expect(find.text('Noa Watanabe'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-nav-messages')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-social-messages-page')),
      findsOneWidget,
    );
    await _tapVisible(tester, find.text('Aki Kondo'));
    final messageField = find.descendant(
      of: find.byKey(const ValueKey<String>('agent-social-message-field')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(messageField, 'Love this palette');
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-social-send-message')),
    );
    expect(find.text('Love this palette'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Nook completes search, category, save, bag, and checkout flows',
    (tester) async {
      await _pumpSimulator(tester, AgentMobileApp.commerce);

      expect(
        find.byKey(const ValueKey<String>('agent-commerce-shop-page')),
        findsOneWidget,
      );

      final search = find.descendant(
        of: find.byKey(const ValueKey<String>('agent-commerce-search')),
        matching: find.byType(EditableText),
      );
      await _tapVisible(tester, find.text('Home'));
      expect(find.text('Paper lamp'), findsOneWidget);
      expect(find.text('Ripple cup'), findsNothing);

      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-nav-search')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-search-page')),
        findsOneWidget,
      );

      await tester.enterText(search, 'moon');
      await tester.pump();
      expect(find.text('No matching products'), findsOneWidget);
      await _tapVisible(tester, find.text('Clear search'));
      expect(find.text('Paper lamp'), findsOneWidget);

      await tester.enterText(search, 'lamp');
      await tester.pump();
      expect(find.text('Paper lamp'), findsOneWidget);
      expect(find.text('Ripple cup'), findsNothing);

      await _tapVisible(tester, find.bySemanticsLabel('Open Paper lamp'));
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-product-detail')),
        findsOneWidget,
      );
      await _tapVisible(tester, find.text('Save for later'));
      expect(find.widgetWithText(CharcoalButton, 'Saved'), findsOneWidget);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-add-to-bag')),
      );
      expect(find.text('Added to bag'), findsOneWidget);

      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-bag')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-bag-page')),
        findsOneWidget,
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-checkout')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-checkout-review')),
        findsOneWidget,
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-place-order')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-order-confirmed')),
        findsOneWidget,
      );
      expect(find.text('Your order is confirmed'), findsOneWidget);

      await _tapVisible(tester, find.text('Continue shopping'));
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-nav-saved')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-saved-page')),
        findsOneWidget,
      );
      expect(find.text('Paper lamp'), findsOneWidget);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-nav-profile')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-profile-page')),
        findsOneWidget,
      );
      expect(find.textContaining('NK-817'), findsOneWidget);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey<String>('agent-commerce-view-latest-order')),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-order-confirmed')),
        findsOneWidget,
      );
      await _tapVisible(
        tester,
        find.bySemanticsLabel('Back from Order confirmed'),
      );
      expect(
        find.byKey(const ValueKey<String>('agent-commerce-profile-page')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Lumen completes privacy, top-up, and transfer flows', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.wallet);

    expect(
      find.byKey(const ValueKey<String>('agent-wallet-home-page')),
      findsOneWidget,
    );

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-action-receive')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-receive-page')),
      findsOneWidget,
    );
    await _tapVisible(tester, find.text('Copy payment link'));
    expect(find.text('Payment link copied'), findsOneWidget);
    await _tapVisible(tester, find.bySemanticsLabel('Back from Receive money'));

    final visibility = find.byKey(
      const ValueKey<String>('agent-wallet-visibility'),
    );
    await _tapVisible(tester, visibility);
    expect(find.text('¥ ••••••'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-action-topUp')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-top-up')),
      findsOneWidget,
    );
    await _tapVisible(tester, find.text('Add ¥ 10,000'));
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-top-up-confirmed')),
      findsOneWidget,
    );
    await _tapVisible(tester, find.text('Done'));
    await _tapVisible(tester, visibility);
    expect(find.text('¥ 1,294,600'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-action-send')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-send-edit')),
      findsOneWidget,
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-wallet-recipient')),
        matching: find.byType(EditableText),
      ),
      'Hana',
    );
    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-wallet-amount')),
        matching: find.byType(EditableText),
      ),
      '99999999',
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-review-transfer')),
    );
    expect(find.text('This exceeds your available balance.'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-wallet-amount')),
        matching: find.byType(EditableText),
      ),
      '8000',
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-review-transfer')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-send-review')),
      findsOneWidget,
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-confirm-transfer')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-send-confirmed')),
      findsOneWidget,
    );
    expect(find.text('¥ 8,000 was sent to Hana.'), findsOneWidget);

    await _tapVisible(tester, find.text('View activity'));
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-activity-page')),
      findsOneWidget,
    );
    expect(find.text('To Hana'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-nav-plan')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-plan-page')),
      findsOneWidget,
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-wallet-nav-profile')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-wallet-profile-page')),
      findsOneWidget,
    );
    await _tapVisible(
      tester,
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-wallet-profile-balance')),
        matching: find.byType(CharcoalSwitch),
      ),
    );
    expect(find.text('Balance is hidden on Wallet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Daylight completes a day and continues into the journey', (
    tester,
  ) async {
    await _pumpSimulator(tester, AgentMobileApp.habits);

    expect(
      find.byKey(const ValueKey<String>('agent-habits-today-page')),
      findsOneWidget,
    );

    final walkRow = find.byKey(const ValueKey<String>('agent-habit-walk-row'));
    final walkCheckbox = find.descendant(
      of: walkRow,
      matching: find.byType(CharcoalCheckbox),
    );
    await _tapVisible(tester, walkCheckbox);
    expect(tester.widget<CharcoalCheckbox>(walkCheckbox).value, isTrue);
    expect(find.text('2/3'), findsOneWidget);

    final readCheckbox = find.descendant(
      of: find.byKey(const ValueKey<String>('agent-habit-read-row')),
      matching: find.byType(CharcoalCheckbox),
    );
    await _tapVisible(tester, readCheckbox);
    expect(find.text('3/3'), findsOneWidget);
    expect(find.text('Everything is complete.'), findsOneWidget);

    await _tapVisible(tester, walkCheckbox);
    expect(find.text('2/3'), findsOneWidget);
    expect(find.text('Plan tomorrow'), findsNothing);
    await _tapVisible(tester, walkCheckbox);

    await _tapVisible(tester, find.text('Plan tomorrow'));
    expect(
      find.byKey(const ValueKey<String>('agent-habits-tomorrow-plan-page')),
      findsOneWidget,
    );
    expect(_nestedNavigator(tester, 'habits').pages, hasLength(2));
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-habits-save-tomorrow')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-habits-plan-saved-page')),
      findsOneWidget,
    );
    expect(_nestedNavigator(tester, 'habits').pages, hasLength(1));
    expect(
      find.byKey(const ValueKey<String>('agent-habits-tomorrow-plan-page')),
      findsNothing,
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-habits-continue-journey')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-habits-journey-page')),
      findsOneWidget,
    );
    expect(_nestedNavigator(tester, 'habits').pages, hasLength(1));
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('Planned · 3 habits'), findsOneWidget);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-habits-nav-insights')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-habits-insights-page')),
      findsOneWidget,
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey<String>('agent-habits-nav-profile')),
    );
    expect(
      find.byKey(const ValueKey<String>('agent-habits-profile-page')),
      findsOneWidget,
    );
    await _tapVisible(
      tester,
      find.descendant(
        of: find.byKey(const ValueKey<String>('agent-habits-profile-streaks')),
        matching: find.byType(CharcoalSwitch),
      ),
    );
    expect(find.text('Today shows cues without streaks'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpSimulator(
  WidgetTester tester,
  AgentMobileApp app, {
  bool disableAnimations = false,
}) async {
  await tester.binding.setSurfaceSize(const Size(320, 760));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    _testApp(
      width: 320,
      child: AgentMobileAppSimulator(app: app),
      disableAnimations: disableAnimations,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Navigator _nestedNavigator(WidgetTester tester, String appKey) =>
    tester.widget<Navigator>(
      find.descendant(
        of: find.byKey(ValueKey<String>('agent-$appKey-navigator')),
        matching: find.byType(Navigator),
      ),
    );

Color _paintedTabBackground(WidgetTester tester, Key key) {
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
  return (tester.widget<DecoratedBox>(decorated.first).decoration
          as BoxDecoration)
      .color!;
}

({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter})
_tabGeometry(WidgetTester tester, Key key) {
  final item = find.byKey(key);
  final icon = find.descendant(of: item, matching: find.byType(CharcoalIcon));
  final label = find.descendant(of: item, matching: find.byType(Text)).first;
  final labelBox = tester.renderObject<RenderBox>(label);
  return (
    iconCenter: tester.getCenter(icon),
    itemRect: tester.getRect(item),
    labelBaseline:
        tester.getTopLeft(label).dy +
        labelBox.getDryBaseline(labelBox.constraints, TextBaseline.alphabetic)!,
    labelCenter: tester.getCenter(label),
  );
}

void _expectCenteredTabGeometry(
  ({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter})
  geometry, {
  required String reason,
}) {
  expect(
    geometry.iconCenter.dx,
    moreOrLessEquals(geometry.itemRect.center.dx),
    reason: reason,
  );
  expect(
    geometry.labelCenter.dx,
    moreOrLessEquals(geometry.itemRect.center.dx),
    reason: reason,
  );
}

void _expectSameTabGeometry(
  ({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter})
  before,
  ({Offset iconCenter, Rect itemRect, double labelBaseline, Offset labelCenter})
  after, {
  required String reason,
}) {
  expect(after.itemRect, before.itemRect, reason: reason);
  expect(after.iconCenter, before.iconCenter, reason: reason);
  expect(after.labelCenter, before.labelCenter, reason: reason);
  expect(after.labelBaseline, before.labelBaseline, reason: reason);
}

ScrollableState _verticalScrollState(WidgetTester tester, Finder finder) =>
    tester
        .stateList<ScrollableState>(finder)
        .firstWhere(
          (state) =>
              state.position.axis == Axis.vertical &&
              state.position.maxScrollExtent > 0,
        );

Widget _tileCatalog() => AgentExampleTileGrid(
  children: <Widget>[
    for (final app in AgentMobileApp.values)
      AgentMobileAppTile(app: app, onPressed: () {}),
  ],
);

Widget _testApp({
  required double width,
  required Widget child,
  bool disableAnimations = false,
}) => CharcoalApp(
  themeMode: CharcoalThemeMode.light,
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(disableAnimations: disableAnimations),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(width: width, child: child),
        ),
      ),
    ),
  ),
);
