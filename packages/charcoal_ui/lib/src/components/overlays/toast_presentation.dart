import 'dart:async';

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The screen edge a toast or snack bar slides in from.
enum CharcoalPopupEdge {
  /// The top edge.
  top,

  /// The bottom edge.
  bottom,
}

/// Controls the edge movement used when a toast or snack bar is presented.
final class CharcoalToastAnimationConfiguration {
  /// Creates a configuration; the defaults are Charcoal's.
  const CharcoalToastAnimationConfiguration({
    this.enablePositionAnimation = true,
    this.opacityCurve = Curves.easeInOut,
    this.positionCurve = Curves.easeOutBack,
  });

  /// Whether the popup slides in from its edge as well as fading.
  final bool enablePositionAnimation;

  /// Curve of the fade.
  final Curve opacityCurve;

  /// Curve of the slide.
  final Curve positionCurve;

  /// Charcoal's default animation.
  static const defaultConfiguration = CharcoalToastAnimationConfiguration();
}

/// Handle returned by `showCharcoalToast` and `showCharcoalSnackBar`.
final class CharcoalToastController {
  CharcoalToastController._(this._entry, this._presentationKey);

  OverlayEntry? _entry;
  final GlobalKey<_CharcoalPopupPresentationState> _presentationKey;

  /// Whether the popup is still on screen.
  bool get isShowing => _entry?.mounted ?? false;

  /// Dismisses the popup with its exit animation.
  void dismiss() {
    final state = _presentationKey.currentState;
    if (state != null) {
      state.dismiss();
      return;
    }
    _remove();
  }

  void _remove() {
    final entry = _entry;
    _entry = null;
    if (entry?.mounted ?? false) entry!.remove();
  }
}

/// Inserts [child] as a timed, optionally draggable popup in the overlay of [context].
///
/// Shared by toasts and snack bars. [duration] of zero keeps the popup until it is dismissed.
/// Returns a handle to dismiss it early.
CharcoalToastController insertCharcoalPopup({
  required BuildContext context,
  required Widget child,
  required bool draggable,
  required Duration duration,
  required CharcoalPopupEdge edge,
  required double screenEdgeSpacing,
  required bool useRootOverlay,
  CharcoalToastAnimationConfiguration animationConfiguration =
      CharcoalToastAnimationConfiguration.defaultConfiguration,
}) {
  final overlay = Overlay.of(context, rootOverlay: useRootOverlay);
  final theme = CharcoalTheme.of(context);
  final themes = InheritedTheme.capture(from: context, to: overlay.context);
  final presentationKey = GlobalKey<_CharcoalPopupPresentationState>();
  late final CharcoalToastController controller;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) => themes.wrap(
      _CharcoalPopupPresentation(
        key: presentationKey,
        animationConfiguration: animationConfiguration,
        draggable: draggable,
        duration: duration,
        edge: edge,
        onDismissed: controller._remove,
        screenEdgeSpacing: screenEdgeSpacing,
        screenHorizontalInset: theme.space.lg,
        transitionDuration: theme.motion.overlay,
        child: child,
      ),
    ),
  );
  controller = CharcoalToastController._(entry, presentationKey);
  overlay.insert(entry);
  return controller;
}

final class _CharcoalPopupPresentation extends StatefulWidget {
  const _CharcoalPopupPresentation({
    required this.animationConfiguration,
    required this.child,
    required this.draggable,
    required this.duration,
    required this.edge,
    required this.onDismissed,
    required this.screenEdgeSpacing,
    required this.screenHorizontalInset,
    required this.transitionDuration,
    super.key,
  });

  final CharcoalToastAnimationConfiguration animationConfiguration;
  final Widget child;
  final bool draggable;
  final Duration duration;
  final CharcoalPopupEdge edge;
  final VoidCallback onDismissed;
  final double screenEdgeSpacing;
  final double screenHorizontalInset;
  final Duration transitionDuration;

  @override
  State<_CharcoalPopupPresentation> createState() => _CharcoalPopupPresentationState();
}

final class _CharcoalPopupPresentationState extends State<_CharcoalPopupPresentation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  Timer? _timer;
  double _dragOffset = 0;
  double _rawDragOffset = 0;
  bool _dragging = false;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: widget.transitionDuration,
      reverseDuration: widget.transitionDuration,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        _animation.value = 1;
      } else {
        _animation.forward();
      }
      _scheduleDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animation.dispose();
    super.dispose();
  }

  Future<void> dismiss() async {
    if (_dismissing) return;
    _dismissing = true;
    _timer?.cancel();
    if (!MediaQuery.disableAnimationsOf(context)) {
      await _animation.reverse();
    }
    if (mounted) widget.onDismissed();
  }

  void _scheduleDismiss() {
    _timer?.cancel();
    if (widget.duration > Duration.zero) {
      _timer = Timer(widget.duration, dismiss);
    }
  }

  double get _edgeDirection => widget.edge == CharcoalPopupEdge.top ? 1 : -1;

  void _handleDragStart(DragStartDetails details) {
    _timer?.cancel();
    setState(() {
      _dragging = true;
      _dragOffset = 0;
      _rawDragOffset = 0;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final toast = CharcoalTheme.of(context).metrics.toast;
    _rawDragOffset += details.delta.dy;
    final translationInDirection = _rawDragOffset * _edgeDirection;
    final nextOffset = translationInDirection < 0
        ? _rawDragOffset
        : _rawDragOffset / (_rawDragOffset.abs() / toast.rubberBandLimit + 1);
    setState(() => _dragOffset = nextOffset);
  }

  void _handleDragEnd(DragEndDetails details) {
    final toast = CharcoalTheme.of(context).metrics.toast;
    final velocityInDirection = (details.primaryVelocity ?? 0) * _edgeDirection;
    final offsetInDirection = _dragOffset * _edgeDirection;
    if (offsetInDirection < -toast.dragDismissDistance ||
        velocityInDirection < -toast.dragDismissVelocity) {
      _dragging = false;
      dismiss();
      return;
    }
    setState(() {
      _dragging = false;
      _dragOffset = 0;
      _rawDragOffset = 0;
    });
    _scheduleDismiss();
  }

  void _handleDragCancel() {
    setState(() {
      _dragging = false;
      _dragOffset = 0;
      _rawDragOffset = 0;
    });
    _scheduleDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final from = widget.animationConfiguration.enablePositionAnimation
        ? widget.edge == CharcoalPopupEdge.top
              ? const Offset(0, -1)
              : const Offset(0, 1)
        : Offset.zero;
    Widget content = FadeTransition(
      opacity: CurvedAnimation(
        parent: _animation,
        curve: widget.animationConfiguration.opacityCurve,
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: from, end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animation,
            curve: widget.animationConfiguration.positionCurve,
          ),
        ),
        child: widget.child,
      ),
    );
    if (widget.draggable) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragCancel: _handleDragCancel,
        onVerticalDragEnd: _handleDragEnd,
        onVerticalDragStart: _handleDragStart,
        onVerticalDragUpdate: _handleDragUpdate,
        child: AnimatedContainer(
          duration: _dragging ? Duration.zero : widget.transitionDuration,
          curve: Curves.easeOutBack,
          transform: Matrix4.translationValues(0, _dragOffset, 0),
          child: content,
        ),
      );
    }
    return Positioned(
      left: widget.screenHorizontalInset,
      right: widget.screenHorizontalInset,
      top: widget.edge == CharcoalPopupEdge.top ? widget.screenEdgeSpacing : null,
      bottom: widget.edge == CharcoalPopupEdge.bottom ? widget.screenEdgeSpacing : null,
      child: Align(child: content),
    );
  }
}
