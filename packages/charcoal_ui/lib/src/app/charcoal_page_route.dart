// The back-gesture state machine drives `TransitionRoute.controller` of routes it does not
// subclass (Material's own pages), exactly as Flutter's Cupertino transition does.
// ignore_for_file: invalid_use_of_protected_member

import 'dart:math' as math;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The axis of Charcoal's shared-axis page transition.
enum CharcoalPageTransitionAxis {
  /// Pages slide sideways; the default.
  horizontal,

  /// Pages slide up; used for full-screen dialogs.
  vertical,
}

/// An opaque, platform-adaptive route for Charcoal applications.
///
/// Normal navigation uses Charcoal shared-axis motion. On native iOS, horizontal routes also
/// support an interactive leading-edge pop gesture. On native Android, the route consumes
/// predictive-back progress so the current page reveals the destination before the gesture is
/// committed or cancelled. Fullscreen dialogs, the first route, and routes blocked by [PopScope]
/// do not start an interactive pop gesture.
///
/// Every number, curve, duration and colour comes from the active `CharcoalTheme`
/// (`metrics.pageRoute`, `motion`, `colors.pageBackdrop`).
///
/// `CharcoalApp` installs [CharcoalPageTransitionsBuilder] in `ThemeData.pageTransitionsTheme`, so
/// routes created by `MaterialApp.home`, named routes and declarative routers get the same
/// transitions and gestures without being [CharcoalPageRoute]s. Use this class directly for
/// imperative pushes that want an explicit [axis] or duration.
final class CharcoalPageRoute<T> extends PageRoute<T> {
  /// Creates a route that shows [builder].
  CharcoalPageRoute({
    required this.builder,
    this.axis = CharcoalPageTransitionAxis.horizontal,
    super.fullscreenDialog = false,
    this.maintainState = true,
    super.requestFocus,
    this._reverseTransitionDuration,
    super.settings,
    this._transitionDuration,
  }) : super(allowSnapshotting: false);

  /// Builds the page.
  final WidgetBuilder builder;

  /// The transition axis.
  final CharcoalPageTransitionAxis axis;

  @override
  final bool maintainState;

  final Duration? _reverseTransitionDuration;
  final Duration? _transitionDuration;

  late final _CharcoalBackGesture<T> _gesture = _CharcoalBackGesture<T>(this);

  CharcoalTheme get _theme => CharcoalTheme.of(navigator!.context);

  @override
  Duration get reverseTransitionDuration =>
      _reverseTransitionDuration ?? _theme.motion.routeReverse;

  @override
  Duration get transitionDuration => _transitionDuration ?? _theme.motion.routeForward;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => Semantics(scopesRoute: true, explicitChildNodes: true, child: builder(context));

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => _buildCharcoalTransitions<T>(
    route: this,
    axis: axis,
    gesture: _gesture,
    context: context,
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );

  @override
  void handleStartBackGesture({double progress = 0.0}) {
    if (!popGestureEnabled) return;
    _gesture.begin(progress: progress);
  }

  @override
  void handleUpdateBackGestureProgress({required double progress}) {
    _gesture.update(progress);
  }

  @override
  void handleCancelBackGesture() => _gesture.finish(commit: false);

  @override
  void handleCommitBackGesture() => _gesture.finish(commit: true);

  @override
  void dispose() {
    _gesture.dispose();
    super.dispose();
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

/// Applies Charcoal's page transition and back gestures to any [PageRoute].
///
/// `CharcoalApp` puts this in `ThemeData.pageTransitionsTheme` for every platform, so routes made
/// by Material (`MaterialPageRoute`, `go_router` pages) behave like a [CharcoalPageRoute]. The
/// platform branches (iOS edge swipe, Android predictive back, shared axis elsewhere) are the same.
class CharcoalPageTransitionsBuilder extends PageTransitionsBuilder {
  /// Creates the builder.
  const CharcoalPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route is CharcoalPageRoute<T>) {
      // Already built by the route itself (Material only asks a builder of its own route kinds).
      return child;
    }
    return _buildCharcoalTransitions<T>(
      route: route,
      axis: route.fullscreenDialog
          ? CharcoalPageTransitionAxis.vertical
          : CharcoalPageTransitionAxis.horizontal,
      gesture: null,
      context: context,
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
}

Widget _buildCharcoalTransitions<T>({
  required PageRoute<T> route,
  required CharcoalPageTransitionAxis axis,
  required _CharcoalBackGesture<T>? gesture,
  required BuildContext context,
  required Animation<double> animation,
  required Animation<double> secondaryAnimation,
  required Widget child,
}) {
  final motionDisabled = MediaQuery.disableAnimationsOf(context);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    if (axis == CharcoalPageTransitionAxis.horizontal) {
      return _CharcoalIosPageTransition<T>(
        animation: animation,
        gesture: gesture,
        motionDisabled: motionDisabled,
        route: route,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    }
    return _CharcoalSharedAxisTransition(
      animation: animation,
      axis: axis,
      linear: route.popGestureInProgress,
      motionDisabled: motionDisabled,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    return _CharcoalAndroidPredictiveBackTransition<T>(
      animation: animation,
      axis: axis,
      gesture: gesture,
      motionDisabled: motionDisabled,
      route: route,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }
  return _CharcoalSharedAxisTransition(
    animation: animation,
    axis: axis,
    linear: route.popGestureInProgress,
    motionDisabled: motionDisabled,
    secondaryAnimation: secondaryAnimation,
    child: child,
  );
}

double _clampUnit(double value) => math.max(0.0, math.min(1.0, value));

/// The user-driven pop of one route: start, drive the route's controller, settle, commit or
/// restore. Shared by [CharcoalPageRoute] and by routes that only borrow Charcoal transitions.
final class _CharcoalBackGesture<T> {
  _CharcoalBackGesture(this.route);

  final PageRoute<T> route;

  bool active = false;
  NavigatorState? _navigator;
  AnimationController? _settlingController;
  AnimationStatusListener? _settlingStatusListener;

  CharcoalTheme get _theme => CharcoalTheme.of(route.navigator!.context);

  void begin({required double progress}) {
    if (active || !route.isCurrent) return;
    final routeNavigator = route.navigator;
    if (routeNavigator == null) return;

    _removeSettlingListener();
    route.controller?.value = _clampUnit(progress);
    _navigator = routeNavigator;
    active = true;
    routeNavigator.didStartUserGesture();
  }

  void update(double progress) {
    if (!route.isCurrent || !active) return;
    route.controller?.value = _clampUnit(progress);
  }

  void startIos() => begin(progress: route.animation?.value ?? 1.0);

  void updateIos(double logicalDelta) {
    if (!route.isCurrent || !active) return;
    final routeController = route.controller;
    if (routeController == null) return;
    routeController.value = _clampUnit(routeController.value - logicalDelta);
  }

  void endIos(double logicalVelocity) {
    final routeController = route.controller;
    if (routeController == null || !active) return;
    final metrics = _theme.metrics.pageRoute;

    final bool commit;
    if (!route.isCurrent) {
      commit = !route.isActive;
    } else if (logicalVelocity.abs() >= metrics.flingVelocityThreshold) {
      commit = logicalVelocity > 0;
    } else {
      commit = routeController.value <= metrics.commitThreshold;
    }
    finish(commit: commit);
  }

  void finish({required bool commit}) {
    if (!active) return;
    final routeController = route.controller;

    if (commit && route.isCurrent) {
      switch (route.popDisposition) {
        case RoutePopDisposition.pop:
          route.navigator?.pop();
        case RoutePopDisposition.doNotPop:
          route.onPopInvokedWithResult(false, null);
        case RoutePopDisposition.bubble:
          break;
      }
    }
    final shouldRestore = route.isActive && (!commit || route.isCurrent);
    if (shouldRestore && routeController != null && !routeController.isCompleted) {
      routeController.animateTo(
        1.0,
        curve: _theme.motion.curve,
        duration: route.reverseTransitionDuration,
      );
    }

    if (routeController?.isAnimating ?? false) {
      _settlingController = routeController;
      late final AnimationStatusListener listener;
      listener = (status) {
        if (status.isAnimating) return;
        routeController!.removeStatusListener(listener);
        if (identical(_settlingStatusListener, listener)) {
          _settlingController = null;
          _settlingStatusListener = null;
        }
        _stop();
      };
      _settlingStatusListener = listener;
      routeController!.addStatusListener(listener);
    } else {
      _stop();
    }
  }

  void _stop() {
    if (!active) return;
    active = false;
    final routeNavigator = _navigator;
    _navigator = null;
    if (routeNavigator?.mounted ?? false) {
      routeNavigator!.didStopUserGesture();
    }
  }

  void _removeSettlingListener() {
    final listener = _settlingStatusListener;
    if (listener != null) {
      _settlingController?.removeStatusListener(listener);
    }
    _settlingController = null;
    _settlingStatusListener = null;
  }

  void dispose() {
    _removeSettlingListener();
    _stop();
  }
}

final class _CharcoalSharedAxisTransition extends StatelessWidget {
  const _CharcoalSharedAxisTransition({
    required this.animation,
    required this.axis,
    required this.child,
    required this.linear,
    required this.motionDisabled,
    required this.secondaryAnimation,
  });

  final Animation<double> animation;
  final CharcoalPageTransitionAxis axis;
  final Widget child;
  final bool linear;
  final bool motionDisabled;
  final Animation<double> secondaryAnimation;

  @override
  Widget build(BuildContext context) {
    if (motionDisabled) return child;

    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.pageRoute;
    final direction = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
    final incomingOffset = switch (axis) {
      CharcoalPageTransitionAxis.horizontal => Offset(metrics.horizontalEnterOffset * direction, 0),
      CharcoalPageTransitionAxis.vertical => Offset(0, metrics.verticalEnterOffset),
    };
    final outgoingOffset = switch (axis) {
      CharcoalPageTransitionAxis.horizontal => Offset(
        metrics.horizontalSecondaryOffset * direction,
        0,
      ),
      CharcoalPageTransitionAxis.vertical => Offset(0, metrics.verticalSecondaryOffset),
    };
    final incoming = Tween<Offset>(begin: incomingOffset, end: Offset.zero).animate(
      linear ? animation : animation.drive(CurveTween(curve: theme.motion.emphasizedCurve)),
    );
    final outgoing = Tween<Offset>(begin: Offset.zero, end: outgoingOffset).animate(
      linear ? secondaryAnimation : secondaryAnimation.drive(CurveTween(curve: theme.motion.curve)),
    );
    return ClipRect(
      child: SlideTransition(
        position: outgoing,
        child: SlideTransition(position: incoming, child: child),
      ),
    );
  }
}

final class _CharcoalIosPageTransition<T> extends StatelessWidget {
  const _CharcoalIosPageTransition({
    required this.animation,
    required this.child,
    required this.gesture,
    required this.motionDisabled,
    required this.route,
    required this.secondaryAnimation,
  });

  final Animation<double> animation;
  final Widget child;
  final _CharcoalBackGesture<T>? gesture;
  final bool motionDisabled;
  final PageRoute<T> route;
  final Animation<double> secondaryAnimation;

  @override
  Widget build(BuildContext context) => _CharcoalIosBackGestureDetector<T>(
    route: route,
    gesture: gesture,
    child: ClipRect(
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[animation, secondaryAnimation]),
        child: child,
        builder: (context, child) {
          final interactive = route.popGestureInProgress;
          if (motionDisabled && !interactive) return child!;

          final theme = CharcoalTheme.of(context);
          final metrics = theme.metrics.pageRoute;
          final direction = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
          final primaryValue = interactive
              ? animation.value
              : _curvedValue(
                  animation,
                  forward: theme.motion.emphasizedCurve,
                  reverse: theme.motion.curve,
                );
          final secondaryValue = interactive
              ? secondaryAnimation.value
              : _curvedValue(
                  secondaryAnimation,
                  forward: theme.motion.curve,
                  reverse: theme.motion.curve,
                );
          final primaryOffset = Offset((1.0 - primaryValue) * direction, 0);
          final secondaryOffset = Offset(metrics.secondaryParallax * secondaryValue * direction, 0);
          final scrimOpacity = metrics.secondaryScrimOpacity * secondaryValue;

          return FractionalTranslation(
            transformHitTests: false,
            translation: secondaryOffset,
            child: FractionalTranslation(
              transformHitTests: false,
              translation: primaryOffset,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  child!,
                  if (scrimOpacity > 0)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: scrimOpacity,
                          child: ColoredBox(color: theme.colors.pageBackdrop),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

double _curvedValue(
  Animation<double> animation, {
  required Curve forward,
  required Curve reverse,
}) {
  if (animation.status == AnimationStatus.reverse) {
    return 1.0 - reverse.transform(1.0 - animation.value);
  }
  return forward.transform(animation.value);
}

final class _CharcoalIosBackGestureDetector<T> extends StatefulWidget {
  const _CharcoalIosBackGestureDetector({
    required this.child,
    required this.gesture,
    required this.route,
  });

  final Widget child;

  /// The route's own gesture state, or null for a route that only borrows the transition.
  final _CharcoalBackGesture<T>? gesture;
  final PageRoute<T> route;

  @override
  State<_CharcoalIosBackGestureDetector<T>> createState() =>
      _CharcoalIosBackGestureDetectorState<T>();
}

final class _CharcoalIosBackGestureDetectorState<T>
    extends State<_CharcoalIosBackGestureDetector<T>> {
  late final HorizontalDragGestureRecognizer _recognizer;
  late final _CharcoalBackGesture<T> _gesture =
      widget.gesture ?? _CharcoalBackGesture<T>(widget.route);
  bool _gestureStarted = false;

  bool get _enabled => widget.route.popGestureEnabled;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    if (_gestureStarted) _gesture.finish(commit: false);
    if (widget.gesture == null) _gesture.dispose();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_enabled) _recognizer.addPointer(event);
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_enabled) return;
    _gestureStarted = true;
    _gesture.startIos();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_gestureStarted) return;
    final width = context.size?.width ?? 0.0;
    if (width <= 0) return;
    _gesture.updateIos(_toLogical(details.primaryDelta! / width));
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_gestureStarted) return;
    final width = context.size?.width ?? 0.0;
    final velocity = width <= 0 ? 0.0 : _toLogical(details.velocity.pixelsPerSecond.dx / width);
    _gestureStarted = false;
    _gesture.endIos(velocity);
  }

  void _handleDragCancel() {
    if (!_gestureStarted) return;
    _gestureStarted = false;
    _gesture.finish(commit: false);
  }

  double _toLogical(double value) =>
      Directionality.of(context) == TextDirection.rtl ? -value : value;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final leadingPadding = Directionality.of(context) == TextDirection.rtl
        ? padding.right
        : padding.left;
    final edgeWidth = CharcoalTheme.of(context).metrics.pageRoute.edgeGestureWidth;
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          bottom: 0,
          start: 0,
          top: 0,
          width: math.max(edgeWidth, leadingPadding),
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _handlePointerDown,
          ),
        ),
      ],
    );
  }
}

enum _CharcoalPredictiveBackPhase { idle, started, updating, cancelling, committing }

final class _CharcoalAndroidPredictiveBackTransition<T> extends StatefulWidget {
  const _CharcoalAndroidPredictiveBackTransition({
    required this.animation,
    required this.axis,
    required this.child,
    required this.gesture,
    required this.motionDisabled,
    required this.route,
    required this.secondaryAnimation,
  });

  final Animation<double> animation;
  final CharcoalPageTransitionAxis axis;
  final Widget child;

  /// The route's own gesture state, or null for a route that only borrows the transition.
  final _CharcoalBackGesture<T>? gesture;
  final bool motionDisabled;
  final PageRoute<T> route;
  final Animation<double> secondaryAnimation;

  @override
  State<_CharcoalAndroidPredictiveBackTransition<T>> createState() =>
      _CharcoalAndroidPredictiveBackTransitionState<T>();
}

final class _CharcoalAndroidPredictiveBackTransitionState<T>
    extends State<_CharcoalAndroidPredictiveBackTransition<T>>
    with WidgetsBindingObserver {
  _CharcoalPredictiveBackPhase _phase = _CharcoalPredictiveBackPhase.idle;
  PredictiveBackEvent? _startEvent;
  PredictiveBackEvent? _currentEvent;
  double _commitStartAnimationValue = 1.0;
  AnimationStatusListener? _settlingListener;
  late final _CharcoalBackGesture<T> _gesture =
      widget.gesture ?? _CharcoalBackGesture<T>(widget.route);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _removeSettlingListener();
    if (widget.gesture == null) _gesture.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool get _canStart =>
      _phase == _CharcoalPredictiveBackPhase.idle &&
      widget.route.isCurrent &&
      widget.route.popGestureEnabled;

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    if (backEvent.isButtonEvent || !_canStart) return false;
    _removeSettlingListener();
    _gesture.begin(progress: 1.0 - backEvent.progress);
    setState(() {
      _phase = _CharcoalPredictiveBackPhase.started;
      _startEvent = backEvent;
      _currentEvent = backEvent;
    });
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    if (_phase == _CharcoalPredictiveBackPhase.idle) return;
    _gesture.update(1.0 - backEvent.progress);
    setState(() {
      _phase = _CharcoalPredictiveBackPhase.updating;
      _currentEvent = backEvent;
    });
  }

  @override
  void handleCancelBackGesture() {
    if (_phase == _CharcoalPredictiveBackPhase.idle) return;
    setState(() => _phase = _CharcoalPredictiveBackPhase.cancelling);
    _gesture.finish(commit: false);
    _resetWhenSettled();
  }

  @override
  void handleCommitBackGesture() {
    if (_phase == _CharcoalPredictiveBackPhase.idle) return;
    setState(() {
      _phase = _CharcoalPredictiveBackPhase.committing;
      _commitStartAnimationValue = widget.animation.value;
    });
    _gesture.finish(commit: true);
    _resetWhenSettled();
  }

  void _resetWhenSettled() {
    final routeAnimation = widget.route.animation;
    if (routeAnimation == null || !routeAnimation.isAnimating) {
      _resetPhase();
      return;
    }
    late final AnimationStatusListener listener;
    listener = (status) {
      if (status.isAnimating) return;
      routeAnimation.removeStatusListener(listener);
      if (identical(_settlingListener, listener)) _settlingListener = null;
      if (mounted) _resetPhase();
    };
    _settlingListener = listener;
    routeAnimation.addStatusListener(listener);
  }

  void _removeSettlingListener() {
    final listener = _settlingListener;
    if (listener != null) widget.route.animation?.removeStatusListener(listener);
    _settlingListener = null;
  }

  void _resetPhase() {
    if (!mounted) return;
    setState(() {
      _phase = _CharcoalPredictiveBackPhase.idle;
      _startEvent = null;
      _currentEvent = null;
      _commitStartAnimationValue = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _CharcoalPredictiveBackPhase.idle) {
      return _CharcoalSharedAxisTransition(
        animation: widget.animation,
        axis: widget.axis,
        linear: widget.route.popGestureInProgress,
        motionDisabled: widget.motionDisabled,
        secondaryAnimation: widget.secondaryAnimation,
        child: widget.child,
      );
    }
    return _CharcoalPredictivePageTransition(
      animation: widget.animation,
      commitStartAnimationValue: _commitStartAnimationValue,
      currentEvent: _currentEvent,
      motionDisabled: widget.motionDisabled,
      phase: _phase,
      startEvent: _startEvent,
      child: widget.child,
    );
  }
}

final class _CharcoalPredictivePageTransition extends StatelessWidget {
  const _CharcoalPredictivePageTransition({
    required this.animation,
    required this.child,
    required this.commitStartAnimationValue,
    required this.currentEvent,
    required this.motionDisabled,
    required this.phase,
    required this.startEvent,
  });

  final Animation<double> animation;
  final Widget child;
  final double commitStartAnimationValue;
  final PredictiveBackEvent? currentEvent;
  final bool motionDisabled;
  final _CharcoalPredictiveBackPhase phase;
  final PredictiveBackEvent? startEvent;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    child: child,
    builder: (context, child) {
      if (motionDisabled) return child!;

      final metrics = CharcoalTheme.of(context).metrics.pageRoute;
      final size = MediaQuery.sizeOf(context);
      final swipeEdge = currentEvent?.swipeEdge ?? startEvent?.swipeEdge ?? SwipeEdge.left;
      final horizontalDirection = swipeEdge == SwipeEdge.left ? 1.0 : -1.0;
      final maxHorizontalShift = math.max(
        0.0,
        size.width / metrics.predictiveShiftDivisor - metrics.predictiveShiftInset,
      );
      final startY = startEvent?.touchOffset?.dy;
      final currentY = currentEvent?.touchOffset?.dy;
      final rawVerticalDelta = startY == null || currentY == null ? 0.0 : currentY - startY;
      final maxVerticalShift = math.max(
        0.0,
        size.height / metrics.predictiveShiftDivisor - metrics.predictiveShiftInset,
      );
      final verticalFraction = size.height <= 0
          ? 0.0
          : _clampUnit(rawVerticalDelta.abs() / size.height);
      final maxGestureVerticalShift =
          Curves.easeOut.transform(verticalFraction) * rawVerticalDelta.sign * maxVerticalShift;

      final gestureAnimationValue = phase == _CharcoalPredictiveBackPhase.committing
          ? commitStartAnimationValue
          : animation.value;
      final gestureProgress = _clampUnit(1.0 - gestureAnimationValue);
      final easedGestureProgress = Curves.easeOut.transform(gestureProgress);
      final gestureOffset = Offset(
        horizontalDirection * maxHorizontalShift * easedGestureProgress,
        maxGestureVerticalShift * gestureProgress,
      );
      final gestureScale = 1.0 - metrics.predictiveScaleDrop * easedGestureProgress;
      final gestureRadius = metrics.predictiveCornerRadius * easedGestureProgress;

      final commitProgress = phase == _CharcoalPredictiveBackPhase.committing
          ? _clampUnit(
              1.0 - animation.value / math.max(commitStartAnimationValue, double.minPositive),
            )
          : 0.0;
      final easedCommitProgress = Curves.easeInOutCubicEmphasized.transform(commitProgress);
      final exitOffset = Offset(
        horizontalDirection * size.height * metrics.predictiveExitOffsetFraction,
        0.0,
      );
      final offset = phase == _CharcoalPredictiveBackPhase.committing
          ? Offset.lerp(gestureOffset, exitOffset, easedCommitProgress)!
          : gestureOffset;
      final scale = phase == _CharcoalPredictiveBackPhase.committing
          ? _lerpDouble(gestureScale, 1.0, easedCommitProgress)
          : gestureScale;
      final radius = phase == _CharcoalPredictiveBackPhase.committing
          ? _lerpDouble(gestureRadius, 0.0, easedCommitProgress)
          : gestureRadius;
      final opacity = phase == _CharcoalPredictiveBackPhase.committing
          ? 1.0 - easedCommitProgress
          : 1.0;

      return Transform.translate(
        offset: offset,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: ClipRRect(borderRadius: BorderRadius.circular(radius), child: child),
          ),
        ),
      );
    },
  );
}

double _lerpDouble(double begin, double end, double t) => begin + (end - begin) * t;
