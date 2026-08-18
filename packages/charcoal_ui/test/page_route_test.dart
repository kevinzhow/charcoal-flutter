import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _homeKey = ValueKey<String>('route-home');
const _detailKey = ValueKey<String>('route-detail');

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CharcoalPageRoute uses opaque shared-axis motion', (tester) async {
    late BuildContext detailContext;
    final pushed = await _pumpPushedRoute(
      tester,
      detailBuilder: (context, child) {
        detailContext = context;
        return child;
      },
      settle: false,
    );

    expect(pushed.route.allowSnapshotting, isFalse);
    expect(pushed.route.transitionDuration, CharcoalMotion.routeForward);
    expect(pushed.route.reverseTransitionDuration, CharcoalMotion.routeReverse);

    await tester.pump(const Duration(milliseconds: 60));

    expect(find.byKey(_homeKey), findsOneWidget);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(find.byType(FadeTransition), findsNothing);
    expect(
      tester
          .widgetList<SlideTransition>(find.byType(SlideTransition))
          .any((transition) => transition.position.value != Offset.zero),
      isTrue,
    );

    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(_detailKey), findsOneWidget);

    Navigator.of(detailContext).pop();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(_homeKey), findsOneWidget);
    expect(find.byKey(_detailKey), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

  testWidgets('iOS leading-edge back gesture follows, cancels, and commits', (tester) async {
    final pushed = await _pumpPushedRoute(tester);
    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);

    final cancelledGesture = await tester.startGesture(
      Offset(1, tester.getCenter(detail).dy),
    );
    await cancelledGesture.moveBy(const Offset(240, 0));
    await tester.pump();

    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getTopLeft(detail).dx, greaterThan(initialTopLeft.dx + 100));
    expect(find.byKey(_homeKey), findsOneWidget);

    await cancelledGesture.cancel();
    await tester.pumpAndSettle();

    expect(pushed.route.popGestureInProgress, isFalse);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(detail), initialTopLeft);

    final committedGesture = await tester.startGesture(
      Offset(1, tester.getCenter(detail).dy),
    );
    await committedGesture.moveBy(const Offset(520, 0));
    await tester.pump();

    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getTopLeft(detail).dx, greaterThan(initialTopLeft.dx + 300));

    await committedGesture.up();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(_homeKey), findsOneWidget);
    expect(find.byKey(_detailKey), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('iOS edge gesture respects PopScope and fullscreen routes', (tester) async {
    var blockedAttempts = 0;
    final blocked = await _pumpPushedRoute(
      tester,
      detailBuilder: (context, child) => PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => blockedAttempts += 1,
        child: child,
      ),
    );

    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);
    final blockedGesture = await tester.startGesture(Offset(1, tester.getCenter(detail).dy));
    await blockedGesture.moveBy(const Offset(520, 0));
    await blockedGesture.up();
    await tester.pumpAndSettle();

    expect(blocked.route.popGestureEnabled, isFalse);
    expect(blockedAttempts, 0);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(detail), initialTopLeft);

    await tester.pumpWidget(const SizedBox.shrink());
    final fullscreen = await _pumpPushedRoute(tester, fullscreenDialog: true);
    final fullscreenDetail = find.byKey(_detailKey);
    final fullscreenGesture = await tester.startGesture(
      Offset(1, tester.getCenter(fullscreenDetail).dy),
    );
    await fullscreenGesture.moveBy(const Offset(520, 0));
    await fullscreenGesture.up();
    await tester.pumpAndSettle();

    expect(fullscreen.route.popGestureEnabled, isFalse);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(fullscreenDetail), Offset.zero);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('iOS edge gesture follows the leading edge in RTL', (tester) async {
    final pushed = await _pumpDirectionalRoute(tester, TextDirection.rtl);
    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);

    final wrongEdgeGesture = await tester.startGesture(
      Offset(1, tester.getCenter(detail).dy),
    );
    await wrongEdgeGesture.moveBy(const Offset(520, 0));
    await wrongEdgeGesture.up();
    await tester.pumpAndSettle();

    expect(pushed.route.popGestureInProgress, isFalse);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(detail), initialTopLeft);

    final leadingEdgeGesture = await tester.startGesture(
      Offset(799, tester.getCenter(detail).dy),
    );
    await leadingEdgeGesture.moveBy(const Offset(-520, 0));
    await tester.pump();

    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getTopLeft(detail).dx, lessThan(initialTopLeft.dx - 300));

    await leadingEdgeGesture.up();
    await tester.pumpAndSettle();

    expect(find.byKey(_homeKey), findsOneWidget);
    expect(find.byKey(_detailKey), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('iOS gesture restores when PopScope blocks during the drag', (
    tester,
  ) async {
    final canPop = ValueNotifier<bool>(true);
    addTearDown(canPop.dispose);
    var blockedAttempts = 0;
    final pushed = await _pumpPushedRoute(
      tester,
      detailBuilder: (context, child) => ValueListenableBuilder<bool>(
        valueListenable: canPop,
        builder: (context, value, _) => PopScope<void>(
          canPop: value,
          onPopInvokedWithResult: (didPop, result) => blockedAttempts += 1,
          child: child,
        ),
      ),
    );
    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);
    final gesture = await tester.startGesture(
      Offset(1, tester.getCenter(detail).dy),
    );
    await gesture.moveBy(const Offset(520, 0));
    await tester.pump();

    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getTopLeft(detail).dx, greaterThan(initialTopLeft.dx + 300));

    canPop.value = false;
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(blockedAttempts, 1);
    expect(pushed.route.popGestureInProgress, isFalse);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(detail), initialTopLeft);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('Android predictive back follows, cancels, and commits', (tester) async {
    final pushed = await _pumpPushedRoute(tester);
    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);
    final initialCenter = tester.getCenter(detail);

    await _sendBackGesture(
      binding,
      'startBackGesture',
      <String, Object>{
        'touchOffset': <double>[1, 300],
        'progress': 0.0,
        'swipeEdge': 0,
      },
    );
    await _sendBackGesture(
      binding,
      'updateBackGestureProgress',
      <String, Object>{
        'touchOffset': <double>[240, 330],
        'progress': 0.4,
        'swipeEdge': 0,
      },
    );
    await tester.pump();

    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getTopLeft(detail).dx, greaterThan(initialTopLeft.dx));
    expect(tester.getTopLeft(detail).dy, greaterThan(initialTopLeft.dy));
    expect(find.byKey(_homeKey), findsOneWidget);

    await _sendBackGesture(binding, 'cancelBackGesture');
    await tester.pumpAndSettle();

    expect(pushed.route.popGestureInProgress, isFalse);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(detail), initialTopLeft);

    await _sendBackGesture(
      binding,
      'startBackGesture',
      <String, Object>{
        'touchOffset': <double>[799, 300],
        'progress': 0.0,
        'swipeEdge': 1,
      },
    );
    await _sendBackGesture(
      binding,
      'updateBackGestureProgress',
      <String, Object>{
        'touchOffset': <double>[400, 300],
        'progress': 0.65,
        'swipeEdge': 1,
      },
    );
    await tester.pump();
    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getCenter(detail).dx, lessThan(initialCenter.dx));

    await _sendBackGesture(binding, 'commitBackGesture');
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byKey(_homeKey), findsOneWidget);
    expect(find.byKey(_detailKey), findsNothing);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('Android predictive back respects PopScope before the gesture starts', (
    tester,
  ) async {
    var blockedAttempts = 0;
    final pushed = await _pumpPushedRoute(
      tester,
      detailBuilder: (context, child) => PopScope<void>(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => blockedAttempts += 1,
        child: child,
      ),
    );
    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);

    await _sendBackGesture(
      binding,
      'startBackGesture',
      <String, Object>{
        'touchOffset': <double>[1, 300],
        'progress': 0.0,
        'swipeEdge': 0,
      },
    );
    await _sendBackGesture(
      binding,
      'updateBackGestureProgress',
      <String, Object>{
        'touchOffset': <double>[400, 300],
        'progress': 0.65,
        'swipeEdge': 0,
      },
    );
    await tester.pump();

    expect(pushed.route.popGestureEnabled, isFalse);
    expect(pushed.route.popGestureInProgress, isFalse);
    expect(tester.getTopLeft(detail), initialTopLeft);

    await _sendBackGesture(binding, 'commitBackGesture');
    await tester.pumpAndSettle();

    expect(blockedAttempts, 1);
    expect(find.byKey(_detailKey), findsOneWidget);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));

  testWidgets('Android predictive commit restores when PopScope changes mid-gesture', (
    tester,
  ) async {
    final canPop = ValueNotifier<bool>(true);
    addTearDown(canPop.dispose);
    var blockedAttempts = 0;
    final pushed = await _pumpPushedRoute(
      tester,
      detailBuilder: (context, child) => ValueListenableBuilder<bool>(
        valueListenable: canPop,
        builder: (context, value, _) => PopScope<void>(
          canPop: value,
          onPopInvokedWithResult: (didPop, result) => blockedAttempts += 1,
          child: child,
        ),
      ),
    );
    final detail = find.byKey(_detailKey);
    final initialTopLeft = tester.getTopLeft(detail);

    await _sendBackGesture(
      binding,
      'startBackGesture',
      <String, Object>{
        'touchOffset': <double>[1, 300],
        'progress': 0.0,
        'swipeEdge': 0,
      },
    );
    await _sendBackGesture(
      binding,
      'updateBackGestureProgress',
      <String, Object>{
        'touchOffset': <double>[400, 330],
        'progress': 0.65,
        'swipeEdge': 0,
      },
    );
    await tester.pump();

    expect(pushed.route.popGestureInProgress, isTrue);
    expect(tester.getTopLeft(detail).dx, greaterThan(initialTopLeft.dx));

    canPop.value = false;
    await tester.pump();
    await _sendBackGesture(binding, 'commitBackGesture');
    await tester.pumpAndSettle();

    expect(blockedAttempts, 1);
    expect(pushed.route.popGestureInProgress, isFalse);
    expect(find.byKey(_detailKey), findsOneWidget);
    expect(tester.getTopLeft(detail), initialTopLeft);
  }, variant: TargetPlatformVariant.only(TargetPlatform.android));
}

final class _PushedRoute {
  const _PushedRoute(this.route);

  final CharcoalPageRoute<void> route;
}

Future<_PushedRoute> _pumpPushedRoute(
  WidgetTester tester, {
  Widget Function(BuildContext context, Widget child)? detailBuilder,
  bool fullscreenDialog = false,
  bool settle = true,
}) async {
  late BuildContext homeContext;
  await tester.pumpWidget(
    CharcoalApp(
      home: Builder(
        builder: (context) {
          homeContext = context;
          return const ColoredBox(
            key: _homeKey,
            color: Color(0xFFFFFFFF),
            child: Center(child: Text('Home')),
          );
        },
      ),
    ),
  );

  final route = CharcoalPageRoute<void>(
    builder: (context) {
      const child = ColoredBox(
        key: _detailKey,
        color: Color(0xFFFFFFFF),
        child: Center(child: Text('Detail')),
      );
      return detailBuilder?.call(context, child) ?? child;
    },
    fullscreenDialog: fullscreenDialog,
  );
  Navigator.of(homeContext).push<void>(route);
  await tester.pump();
  if (settle) await tester.pumpAndSettle();
  return _PushedRoute(route);
}

Future<_PushedRoute> _pumpDirectionalRoute(
  WidgetTester tester,
  TextDirection textDirection,
) async {
  final navigatorKey = GlobalKey<NavigatorState>();
  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: Directionality(
        textDirection: textDirection,
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) => CharcoalPageRoute<void>(
            builder: (context) => const ColoredBox(
              key: _homeKey,
              color: Color(0xFFFFFFFF),
              child: Center(child: Text('Home')),
            ),
            settings: settings,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final route = CharcoalPageRoute<void>(
    builder: (context) => const ColoredBox(
      key: _detailKey,
      color: Color(0xFFFFFFFF),
      child: Center(child: Text('Detail')),
    ),
  );
  navigatorKey.currentState!.push<void>(route);
  await tester.pumpAndSettle();
  return _PushedRoute(route);
}

Future<void> _sendBackGesture(
  TestWidgetsFlutterBinding binding,
  String method, [
  Object? arguments,
]) async {
  final message = const StandardMethodCodec().encodeMethodCall(MethodCall(method, arguments));
  await binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    message,
    (data) {},
  );
}
