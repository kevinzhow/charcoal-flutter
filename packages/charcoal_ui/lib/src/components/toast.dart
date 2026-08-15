import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalToastVariant {
  success,
  error,

  /// Backwards-compatible alias for [success].
  normal,

  /// Backwards-compatible alias for [error].
  negative,
}

enum CharcoalPopupEdge { top, bottom }

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

/// The compact, colored Charcoal iOS notification surface.
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

  bool get _isError =>
      variant == CharcoalToastVariant.error || variant == CharcoalToastVariant.negative;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.toast;
    final background = _isError ? tokens.errorBackgroundColor : tokens.successBackgroundColor;
    final foreground = _isError ? tokens.errorForegroundColor : tokens.successForegroundColor;
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? tokens.maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: tokens.borderColor,
              width: tokens.borderWidth,
            ),
            borderRadius: BorderRadius.circular(tokens.radius),
            color: background,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: tokens.paddingHorizontal,
              vertical: tokens.paddingVertical,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leading case final leading?) ...<Widget>[
                  IconTheme(
                    data: IconThemeData(
                      color: foreground,
                      size: theme.dimensions.space.component30,
                    ),
                    child: leading,
                  ),
                  SizedBox(width: tokens.gap),
                ],
                Flexible(
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foreground,
                      fontFamily: theme.typography.fontFamily.sans,
                      fontSize: tokens.fontSize,
                      fontWeight: tokens.fontWeight,
                      height: theme.typography.lineHeight.captionM / tokens.fontSize,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
                  ),
                ),
                if (action case final action?) ...<Widget>[
                  SizedBox(width: tokens.gap),
                  IconTheme(
                    data: IconThemeData(
                      color: foreground,
                      size: theme.dimensions.space.component30,
                    ),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: foreground,
                        fontFamily: theme.typography.fontFamily.sans,
                        fontSize: tokens.fontSize,
                        fontWeight: tokens.fontWeight,
                        height: theme.typography.lineHeight.captionM / tokens.fontSize,
                        leadingDistribution: TextLeadingDistribution.even,
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

/// The bordered Charcoal iOS snackbar, optionally with a 64-pixel thumbnail.
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
    final tokens = theme.components.snackbar;
    return Semantics(
      container: true,
      label: semanticLabel ?? message,
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? tokens.maxWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(tokens.radius),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: tokens.borderColor,
                width: tokens.borderWidth,
              ),
              borderRadius: BorderRadius.circular(tokens.radius),
              color: tokens.backgroundColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (thumbnail case final thumbnail?)
                  SizedBox.square(
                    dimension: tokens.thumbnailSize,
                    child: FittedBox(fit: BoxFit.cover, child: thumbnail),
                  ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.paddingHorizontal,
                      vertical: tokens.paddingVertical,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: tokens.foregroundColor,
                              fontFamily: theme.typography.fontFamily.sans,
                              fontSize: tokens.fontSize,
                              fontWeight: tokens.fontWeight,
                              height: theme.typography.lineHeight.captionM / tokens.fontSize,
                              leadingDistribution: TextLeadingDistribution.even,
                            ),
                          ),
                        ),
                        if (action case final action?) ...<Widget>[
                          SizedBox(width: tokens.contentGap),
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

/// Inserts an iOS-compatible [CharcoalToast] into the root overlay.
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
}) {
  final tokens = CharcoalTheme.of(context).components.toast;
  return _showCharcoalPopup(
    animationConfiguration: animationConfiguration,
    context: context,
    draggable: false,
    duration: duration ?? tokens.dismissDuration,
    edge: edge,
    screenEdgeSpacing: screenEdgeSpacing ?? tokens.screenEdgeSpacing,
    screenHorizontalInset: tokens.screenHorizontalInset,
    transitionDuration: tokens.animationDuration,
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

/// Inserts a draggable iOS-compatible [CharcoalSnackBar] into the root overlay.
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
}) {
  final tokens = CharcoalTheme.of(context).components.snackbar;
  return _showCharcoalPopup(
    animationConfiguration: animationConfiguration,
    context: context,
    draggable: true,
    duration: duration ?? tokens.dismissDuration,
    edge: edge,
    screenEdgeSpacing: screenEdgeSpacing ?? tokens.screenEdgeSpacing,
    screenHorizontalInset: tokens.screenHorizontalInset,
    transitionDuration: tokens.animationDuration,
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
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
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
      if (widget.duration > Duration.zero) {
        _timer = Timer(widget.duration, dismiss);
      }
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
      content = Dismissible(
        key: ObjectKey(this),
        direction: widget.edge == CharcoalPopupEdge.top
            ? DismissDirection.up
            : DismissDirection.down,
        onDismissed: (_) {
          _timer?.cancel();
          widget.onDismissed();
        },
        child: content,
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
