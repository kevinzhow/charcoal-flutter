import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'typography.dart';

enum CharcoalToastVariant { success, error }

enum CharcoalPopupEdge { top, bottom }

abstract final class _ToastSpec {
  static const maxWidth = 312.0;
  static const cornerRadius = 32.0;
  static const iconSize = 16.0;
  static const toastScreenEdgeSpacing = 96.0;
  static const snackBarScreenEdgeSpacing = 120.0;
  static const dismissDuration = Duration(seconds: 2);
  static const transitionDuration = Duration(milliseconds: 250);
  static const dragDismissDistance = 50.0;
  static const dragDismissVelocity = 100.0;
  static const rubberBandLimit = 60.0;
}

/// Controls the edge movement used when a toast or snackbar is presented.
final class CharcoalToastAnimationConfiguration {
  const CharcoalToastAnimationConfiguration({
    this.enablePositionAnimation = true,
    this.opacityCurve = Curves.easeInOut,
    this.positionCurve = Curves.easeOutBack,
  });

  final bool enablePositionAnimation;
  final Curve opacityCurve;
  final Curve positionCurve;

  static const defaultConfiguration = CharcoalToastAnimationConfiguration();
}

/// A compact, colored Charcoal notification surface.
final class CharcoalToast extends StatelessWidget {
  const CharcoalToast({
    required this.message,
    this.action,
    this.leading,
    this.maxWidth,
    this.semanticLabel,
    this.variant = CharcoalToastVariant.success,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  final Widget? action;
  final Widget? leading;
  final double? maxWidth;
  final String message;
  final String? semanticLabel;
  final CharcoalToastVariant variant;

  bool get _isError => variant == CharcoalToastVariant.error;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final background = _isError
        ? theme.colors.containerNegativeDefault
        : theme.colors.containerPositiveDefault;
    final foreground = _isError
        ? theme.colors.textOnNegativeDefault
        : theme.colors.textOnPositiveDefault;
    final contentGap = theme.dimensions.space.component20;
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? _ToastSpec.maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colors.backgroundDefault,
              width: theme.dimensions.borderWidth.l,
            ),
            borderRadius: BorderRadius.circular(_ToastSpec.cornerRadius),
            color: background,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.dimensions.space.component40,
              vertical: theme.dimensions.space.component20,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leading case final leading?) ...<Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: foreground,
                      size: _ToastSpec.iconSize,
                    ),
                    child: leading,
                  ),
                  SizedBox(width: contentGap),
                ],
                Flexible(
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: charcoalTypographyStyle(
                      context,
                      color: foreground,
                      size: CharcoalTypographySize.size14,
                      weight: CharcoalTypographyWeight.bold,
                    ),
                  ),
                ),
                if (action case final action?) ...<Widget>[
                  SizedBox(width: contentGap),
                  IconTheme(
                    data: IconThemeData(
                      color: foreground,
                      size: _ToastSpec.iconSize,
                    ),
                    child: DefaultTextStyle(
                      style: charcoalTypographyStyle(
                        context,
                        color: foreground,
                        size: CharcoalTypographySize.size14,
                        weight: CharcoalTypographyWeight.bold,
                      ),
                      child: action,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A bordered Charcoal snackbar, optionally with a 64-pixel thumbnail.
final class CharcoalSnackBar extends StatelessWidget {
  const CharcoalSnackBar({
    required this.message,
    this.action,
    this.maxWidth,
    this.semanticLabel,
    this.thumbnail,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  final Widget? action;
  final double? maxWidth;
  final String message;
  final String? semanticLabel;
  final Widget? thumbnail;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final radius = BorderRadius.circular(_ToastSpec.cornerRadius);
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? _ToastSpec.maxWidth),
        child: ClipRRect(
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colors.borderDefault,
                width: theme.dimensions.borderWidth.m,
              ),
              borderRadius: radius,
              color: theme.colors.backgroundDefault,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (thumbnail case final thumbnail?)
                  SizedBox.square(
                    dimension: theme.dimensions.space.layout60,
                    child: FittedBox(fit: BoxFit.cover, child: thumbnail),
                  ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.dimensions.space.component30,
                      vertical: theme.dimensions.space.component25,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: charcoalTypographyStyle(
                              context,
                              color: theme.colors.textDefault,
                              size: CharcoalTypographySize.size14,
                              weight: CharcoalTypographyWeight.bold,
                            ),
                          ),
                        ),
                        if (action case final action?) ...<Widget>[
                          SizedBox(
                            width: theme.dimensions.space.component30,
                          ),
                          action,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Handle returned by [showCharcoalToast] and [showCharcoalSnackBar].
final class CharcoalToastController {
  CharcoalToastController._(this._entry, this._presentationKey);

  OverlayEntry? _entry;
  final GlobalKey<_CharcoalPopupPresentationState> _presentationKey;

  bool get isShowing => _entry?.mounted ?? false;

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

/// Inserts a [CharcoalToast] into an overlay.
///
/// Set [useRootOverlay] to false when [context] belongs to a deliberately
/// bounded nested overlay, such as an embedded app preview.
CharcoalToastController showCharcoalToast({
  required BuildContext context,
  required String message,
  Widget? action,
  CharcoalToastAnimationConfiguration animationConfiguration =
      CharcoalToastAnimationConfiguration.defaultConfiguration,
  Duration? duration,
  CharcoalPopupEdge edge = CharcoalPopupEdge.bottom,
  Widget? leading,
  double? maxWidth,
  String? semanticLabel,
  double? screenEdgeSpacing,
  CharcoalToastVariant variant = CharcoalToastVariant.success,
  bool useRootOverlay = true,
}) {
  return _showCharcoalPopup(
    animationConfiguration: animationConfiguration,
    context: context,
    draggable: false,
    duration: duration ?? _ToastSpec.dismissDuration,
    edge: edge,
    screenEdgeSpacing: screenEdgeSpacing ?? _ToastSpec.toastScreenEdgeSpacing,
    screenHorizontalInset: CharcoalTheme.of(
      context,
    ).dimensions.space.layout30,
    transitionDuration: _ToastSpec.transitionDuration,
    useRootOverlay: useRootOverlay,
    child: CharcoalToast(
      action: action,
      leading: leading,
      maxWidth: maxWidth,
      message: message,
      semanticLabel: semanticLabel,
      variant: variant,
    ),
  );
}

/// Inserts a draggable [CharcoalSnackBar] into an overlay.
///
/// Set [useRootOverlay] to false when [context] belongs to a deliberately
/// bounded nested overlay, such as an embedded app preview.
CharcoalToastController showCharcoalSnackBar({
  required BuildContext context,
  required String message,
  Widget? action,
  CharcoalToastAnimationConfiguration animationConfiguration =
      CharcoalToastAnimationConfiguration.defaultConfiguration,
  Duration? duration,
  CharcoalPopupEdge edge = CharcoalPopupEdge.bottom,
  double? maxWidth,
  String? semanticLabel,
  double? screenEdgeSpacing,
  Widget? thumbnail,
  bool useRootOverlay = true,
}) {
  return _showCharcoalPopup(
    animationConfiguration: animationConfiguration,
    context: context,
    draggable: true,
    duration: duration ?? _ToastSpec.dismissDuration,
    edge: edge,
    screenEdgeSpacing: screenEdgeSpacing ?? _ToastSpec.snackBarScreenEdgeSpacing,
    screenHorizontalInset: CharcoalTheme.of(
      context,
    ).dimensions.space.layout30,
    transitionDuration: _ToastSpec.transitionDuration,
    useRootOverlay: useRootOverlay,
    child: CharcoalSnackBar(
      action: action,
      maxWidth: maxWidth,
      message: message,
      semanticLabel: semanticLabel,
      thumbnail: thumbnail,
    ),
  );
}

CharcoalToastController _showCharcoalPopup({
  required CharcoalToastAnimationConfiguration animationConfiguration,
  required Widget child,
  required BuildContext context,
  required bool draggable,
  required Duration duration,
  required CharcoalPopupEdge edge,
  required double screenEdgeSpacing,
  required double screenHorizontalInset,
  required Duration transitionDuration,
  required bool useRootOverlay,
}) {
  final overlay = Overlay.of(context, rootOverlay: useRootOverlay);
  final theme = CharcoalTheme.of(context);
  final presentationKey = GlobalKey<_CharcoalPopupPresentationState>();
  late final CharcoalToastController controller;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) => CharcoalTheme(
      data: theme,
      child: _CharcoalPopupPresentation(
        key: presentationKey,
        animationConfiguration: animationConfiguration,
        draggable: draggable,
        duration: duration,
        edge: edge,
        onDismissed: controller._remove,
        screenEdgeSpacing: screenEdgeSpacing,
        screenHorizontalInset: screenHorizontalInset,
        transitionDuration: transitionDuration,
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
    _rawDragOffset += details.delta.dy;
    final translationInDirection = _rawDragOffset * _edgeDirection;
    final nextOffset = translationInDirection < 0
        ? _rawDragOffset
        : _rawDragOffset / (_rawDragOffset.abs() / _ToastSpec.rubberBandLimit + 1);
    setState(() => _dragOffset = nextOffset);
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocityInDirection = (details.primaryVelocity ?? 0) * _edgeDirection;
    final offsetInDirection = _dragOffset * _edgeDirection;
    if (offsetInDirection < -_ToastSpec.dragDismissDistance ||
        velocityInDirection < -_ToastSpec.dragDismissVelocity) {
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
          duration: _dragging ? Duration.zero : _ToastSpec.transitionDuration,
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
      child: Align(
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
