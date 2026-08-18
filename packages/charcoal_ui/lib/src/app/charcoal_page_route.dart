import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';

enum CharcoalPageTransitionAxis { horizontal, vertical }

/// An opaque, platform-adaptive route for Charcoal applications.
///
/// Normal navigation uses Charcoal shared-axis motion. On native iOS,
/// horizontal routes also support an interactive leading-edge pop gesture. On
/// native Android, the route consumes predictive-back progress so the current
/// page reveals the destination before the gesture is committed or cancelled.
/// Fullscreen dialogs, the first route, and routes blocked by [PopScope] do not
/// start an interactive pop gesture.
///
/// The implementation stays in Flutter's Widgets layer and does not depend on
/// Material or Cupertino route classes.
final class CharcoalPageRoute<T> extends PageRoute<T> {
  CharcoalPageRoute({
    required this.builder,
    this.axis = CharcoalPageTransitionAxis.horizontal,
    super.fullscreenDialog = false,
    this.maintainState = true,
    super.requestFocus,
    this.reverseTransitionDuration = CharcoalMotion.routeReverse,
    super.settings,
    this.transitionDuration = CharcoalMotion.routeForward,
  }) : super(allowSnapshotting: false);

  final WidgetBuilder builder;

  final CharcoalPageTransitionAxis axis;

  @override
  final bool maintainState;

  @override
  final Duration reverseTransitionDuration;

  @override
  final Duration transitionDuration;

  bool _userGestureActive = false;
  NavigatorState? _gestureNavigator;
  AnimationController? _settlingController;
  AnimationStatusListener? _settlingStatusListener;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  bool get _iosBackGestureEnabled =>
      axis == CharcoalPageTransitionAxis.horizontal && popGestureEnabled;

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
  ) {
    final motionDisabled = MediaQuery.disableAnimationsOf(context);
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      if (axis == CharcoalPageTransitionAxis.horizontal) {
        return _CharcoalIosPageTransition<T>(
          animation: animation,
          motionDisabled: motionDisabled,
          route: this,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      }
      return _CharcoalSharedAxisTransition(
        animation: animation,
        axis: axis,
        linear: popGestureInProgress,
        motionDisabled: motionDisabled,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return _CharcoalAndroidPredictiveBackTransition<T>(
        animation: animation,
        axis: axis,
        motionDisabled: motionDisabled,
        route: this,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    }
    return _CharcoalSharedAxisTransition(
      animation: animation,
      axis: axis,
      linear: popGestureInProgress,
      motionDisabled: motionDisabled,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
  }

  @override
  void handleStartBackGesture({double progress = 0.0}) {
    if (!popGestureEnabled) return;
    _beginUserGesture(progress: progress);
  }

  @override
  void handleUpdateBackGestureProgress({required double progress}) {
    if (!isCurrent || !_userGestureActive) return;
    controller?.value = _clampUnit(progress);
  }

  @override
  void handleCancelBackGesture() {
    _finishUserGesture(commit: false);
  }

  @override
  void handleCommitBackGesture() {
    _finishUserGesture(commit: true);
  }

  void _startIosBackGesture() {
    _beginUserGesture(progress: animation?.value ?? 1.0);
  }

  void _updateIosBackGesture(double logicalDelta) {
    if (!isCurrent || !_userGestureActive) return;
    final routeController = controller;
    if (routeController == null) return;
    routeController.value = _clampUnit(routeController.value - logicalDelta);
  }

  void _endIosBackGesture(double logicalVelocity) {
    final routeController = controller;
    if (routeController == null || !_userGestureActive) return;

    final bool commit;
    if (!isCurrent) {
      commit = !isActive;
    } else if (logicalVelocity.abs() >= 1.0) {
      commit = logicalVelocity > 0;
    } else {
      commit = routeController.value <= 0.5;
    }
    _finishUserGesture(commit: commit);
  }

  void _cancelIosBackGesture() {
    _finishUserGesture(commit: false);
  }

  void _beginUserGesture({required double progress}) {
    if (_userGestureActive || !isCurrent) return;
    final routeNavigator = navigator;
    if (routeNavigator == null) return;

    _removeSettlingListener();
    controller?.value = _clampUnit(progress);
    _gestureNavigator = routeNavigator;
    _userGestureActive = true;
    routeNavigator.didStartUserGesture();
  }

  void _finishUserGesture({required bool commit}) {
    if (!_userGestureActive) return;
    final routeController = controller;

    if (commit && isCurrent) {
      switch (popDisposition) {
        case RoutePopDisposition.pop:
          navigator?.pop();
        case RoutePopDisposition.doNotPop:
          onPopInvokedWithResult(false, null);
        case RoutePopDisposition.bubble:
          break;
      }
    }
    final shouldRestore = isActive && (!commit || isCurrent);
    if (shouldRestore && routeController != null && !routeController.isCompleted) {
      routeController.animateTo(
        1.0,
        curve: CharcoalMotion.standardCurve,
        duration: reverseTransitionDuration,
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
        _stopUserGesture();
      };
      _settlingStatusListener = listener;
      routeController!.addStatusListener(listener);
    } else {
      _stopUserGesture();
    }
  }

  void _stopUserGesture() {
    if (!_userGestureActive) return;
    _userGestureActive = false;
    final routeNavigator = _gestureNavigator;
    _gestureNavigator = null;
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

  @override
  void dispose() {
    _removeSettlingListener();
    _stopUserGesture();
    super.dispose();
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

double _clampUnit(double value) => math.max(0.0, math.min(1.0, value));

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

    final textDirection = Directionality.of(context);
    final direction = textDirection == TextDirection.rtl ? -1.0 : 1.0;
    final incomingOffset = switch (axis) {
      CharcoalPageTransitionAxis.horizontal => Offset(0.035 * direction, 0),
      CharcoalPageTransitionAxis.vertical => const Offset(0, 0.025),
    };
    final outgoingOffset = switch (axis) {
      CharcoalPageTransitionAxis.horizontal => Offset(-0.012 * direction, 0),
      CharcoalPageTransitionAxis.vertical => const Offset(0, -0.008),
    };
    final incoming = Tween<Offset>(begin: incomingOffset, end: Offset.zero).animate(
      linear ? animation : animation.drive(CurveTween(curve: CharcoalMotion.emphasizedCurve)),
    );
    final outgoing = Tween<Offset>(begin: Offset.zero, end: outgoingOffset).animate(
      linear
          ? secondaryAnimation
          : secondaryAnimation.drive(CurveTween(curve: CharcoalMotion.standardCurve)),
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
    required this.motionDisabled,
    required this.route,
    required this.secondaryAnimation,
  });

  final Animation<double> animation;
  final Widget child;
  final bool motionDisabled;
  final CharcoalPageRoute<T> route;
  final Animation<double> secondaryAnimation;

  @override
  Widget build(BuildContext context) => _CharcoalIosBackGestureDetector<T>(
    route: route,
    child: ClipRect(
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[animation, secondaryAnimation]),
        child: child,
        builder: (context, child) {
          final interactive = route.popGestureInProgress;
          if (motionDisabled && !interactive) return child!;

          final direction = Directionality.of(context) == TextDirection.rtl ? -1.0 : 1.0;
          final primaryValue = interactive
              ? animation.value
              : _curvedValue(
                  animation,
                  forward: CharcoalMotion.emphasizedCurve,
                  reverse: CharcoalMotion.standardCurve,
                );
          final secondaryValue = interactive
              ? secondaryAnimation.value
              : _curvedValue(
                  secondaryAnimation,
                  forward: CharcoalMotion.standardCurve,
                  reverse: CharcoalMotion.standardCurve,
                );
          final primaryOffset = Offset((1.0 - primaryValue) * direction, 0);
          final secondaryOffset = Offset(-0.28 * secondaryValue * direction, 0);
          final scrimOpacity = 0.10 * secondaryValue;

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
                          child: const ColoredBox(color: Color(0xFF000000)),
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
  const _CharcoalIosBackGestureDetector({required this.child, required this.route});

  final Widget child;
  final CharcoalPageRoute<T> route;

  @override
  State<_CharcoalIosBackGestureDetector<T>> createState() =>
      _CharcoalIosBackGestureDetectorState<T>();
}

final class _CharcoalIosBackGestureDetectorState<T>
    extends State<_CharcoalIosBackGestureDetector<T>> {
  static const _edgeWidth = 20.0;

  late final HorizontalDragGestureRecognizer _recognizer;
  bool _gestureStarted = false;

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
    if (_gestureStarted) widget.route._cancelIosBackGesture();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.route._iosBackGestureEnabled) {
      _recognizer.addPointer(event);
    }
  }

  void _handleDragStart(DragStartDetails details) {
    if (!widget.route._iosBackGestureEnabled) return;
    _gestureStarted = true;
    widget.route._startIosBackGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_gestureStarted) return;
    final width = context.size?.width ?? 0.0;
    if (width <= 0) return;
    widget.route._updateIosBackGesture(_toLogical(details.primaryDelta! / width));
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_gestureStarted) return;
    final width = context.size?.width ?? 0.0;
    final velocity = width <= 0 ? 0.0 : _toLogical(details.velocity.pixelsPerSecond.dx / width);
    _gestureStarted = false;
    widget.route._endIosBackGesture(velocity);
  }

  void _handleDragCancel() {
    if (!_gestureStarted) return;
    _gestureStarted = false;
    widget.route._cancelIosBackGesture();
  }

  double _toLogical(double value) =>
      Directionality.of(context) == TextDirection.rtl ? -value : value;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final leadingPadding = Directionality.of(context) == TextDirection.rtl
        ? padding.right
        : padding.left;
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          bottom: 0,
          start: 0,
          top: 0,
          width: math.max(_edgeWidth, leadingPadding),
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
    required this.motionDisabled,
    required this.route,
    required this.secondaryAnimation,
  });

  final Animation<double> animation;
  final CharcoalPageTransitionAxis axis;
  final Widget child;
  final bool motionDisabled;
  final CharcoalPageRoute<T> route;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _removeSettlingListener();
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
    widget.route.handleStartBackGesture(progress: 1.0 - backEvent.progress);
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
    widget.route.handleUpdateBackGestureProgress(progress: 1.0 - backEvent.progress);
    setState(() {
      _phase = _CharcoalPredictiveBackPhase.updating;
      _currentEvent = backEvent;
    });
  }

  @override
  void handleCancelBackGesture() {
    if (_phase == _CharcoalPredictiveBackPhase.idle) return;
    setState(() => _phase = _CharcoalPredictiveBackPhase.cancelling);
    widget.route.handleCancelBackGesture();
    _resetWhenSettled();
  }

  @override
  void handleCommitBackGesture() {
    if (_phase == _CharcoalPredictiveBackPhase.idle) return;
    setState(() {
      _phase = _CharcoalPredictiveBackPhase.committing;
      _commitStartAnimationValue = widget.animation.value;
    });
    widget.route.handleCommitBackGesture();
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

      final size = MediaQuery.sizeOf(context);
      final swipeEdge = currentEvent?.swipeEdge ?? startEvent?.swipeEdge ?? SwipeEdge.left;
      final horizontalDirection = swipeEdge == SwipeEdge.left ? 1.0 : -1.0;
      final maxHorizontalShift = math.max(0.0, size.width / 20.0 - 8.0);
      final startY = startEvent?.touchOffset?.dy;
      final currentY = currentEvent?.touchOffset?.dy;
      final rawVerticalDelta = startY == null || currentY == null ? 0.0 : currentY - startY;
      final maxVerticalShift = math.max(0.0, size.height / 20.0 - 8.0);
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
      final gestureScale = 1.0 - 0.10 * easedGestureProgress;
      final gestureRadius = 32.0 * easedGestureProgress;

      final commitProgress = phase == _CharcoalPredictiveBackPhase.committing
          ? _clampUnit(
              1.0 - animation.value / math.max(commitStartAnimationValue, 0.0001),
            )
          : 0.0;
      final easedCommitProgress = Curves.easeInOutCubicEmphasized.transform(commitProgress);
      final exitOffset = Offset(horizontalDirection * size.height * 0.10, 0.0);
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
