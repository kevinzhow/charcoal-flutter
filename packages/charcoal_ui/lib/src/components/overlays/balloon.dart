import 'dart:async';

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import 'close_glyph.dart';
import 'overlay_anchor_tracker.dart';
import 'overlay_position.dart';
import 'popup_shape.dart';

/// A persistent speech surface with a directional tail.
///
/// When [onDismiss] is provided, the close affordance supports pointer and
/// keyboard activation. The caller continues to own this surface's placement
/// and visibility.
final class CharcoalBalloon extends StatelessWidget {
  const CharcoalBalloon({
    required this.child,
    this.action,
    this.arrowCenter,
    this.dismissIcon,
    this.dismissLabel = 'Close',
    this.maxWidth,
    this.onDismiss,
    this.position = CharcoalOverlayPosition.top,
    this.semanticLabel,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  final Widget? action;
  final double? arrowCenter;
  final Widget child;
  final Widget? dismissIcon;

  /// Semantics label of the dismiss button; pass the localized string.
  final String dismissLabel;
  final double? maxWidth;
  final VoidCallback? onDismiss;
  final CharcoalOverlayPosition position;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.balloon;
    final horizontalPadding = theme.space.lg;
    final verticalPadding = theme.space.md;
    final padding = switch (position) {
      CharcoalOverlayPosition.top => EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding + metrics.arrowHeight,
        horizontalPadding,
        verticalPadding,
      ),
      CharcoalOverlayPosition.right => EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding + metrics.arrowHeight,
        verticalPadding,
      ),
      CharcoalOverlayPosition.bottom => EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding + metrics.arrowHeight,
      ),
      CharcoalOverlayPosition.left => EdgeInsets.fromLTRB(
        horizontalPadding + metrics.arrowHeight,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
    };
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? metrics.defaultMaxWidth,
        ),
        child: CustomPaint(
          painter: CharcoalPopupShapePainter(
            arrowCenter: arrowCenter,
            arrowHalfWidth: metrics.arrowHalfWidth,
            arrowHeight: metrics.arrowHeight,
            color: theme.colors.primary,
            position: position,
            radius: theme.radius.xl,
            seamOverlap: theme.metrics.popup.seamOverlap,
            strokeColor: theme.colors.iconOnPrimary,
            strokeWidth: metrics.strokeWidth,
          ),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: theme.style(
                CharcoalTextRole.size14,
                color: theme.colors.textOnPrimary,
                bold: true,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(child: child),
                      if (onDismiss != null) ...<Widget>[
                        SizedBox(width: metrics.closeGap),
                        _BalloonCloseButton(
                          icon: dismissIcon,
                          label: dismissLabel,
                          onPressed: onDismiss!,
                        ),
                      ],
                    ],
                  ),
                  if (action case final action?) ...<Widget>[
                    CharcoalGap.vertical(CharcoalSpace.xs),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(theme.radius.pill),
                        color: theme.colors.fillOnImage,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: metrics.actionVerticalPadding,
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
      ),
    );
  }
}

final class _BalloonCloseButton extends StatelessWidget {
  const _BalloonCloseButton({required this.label, required this.onPressed, this.icon});

  final String label;

  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.balloon;
    return CharcoalClickable(
      onPressed: onPressed,
      semanticLabel: label,
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final background = resolveCharcoalStateColor(
          states,
          normal: colors.fillOnImage,
          hovered: colors.fillOnImageHover,
          pressed: colors.fillOnImagePress,
        );
        final foreground = resolveCharcoalStateColor(
          states,
          normal: colors.iconOnImage,
          hovered: colors.iconOnImage,
          pressed: colors.iconOnImage,
        );
        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: focused
                ? <BoxShadow>[
                    BoxShadow(
                      color: colors.focusRing,
                      spreadRadius: theme.borders.focusRing,
                    ),
                  ]
                : const <BoxShadow>[],
            color: background,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(
            dimension: metrics.closeVisualSize,
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  color: foreground,
                  size: metrics.closeIconSize,
                ),
                child:
                    icon ??
                    CustomPaint(
                      painter: CharcoalCloseGlyphPainter(
                        color: foreground,
                        inset: metrics.closeIconInset,
                        strokeWidth: metrics.closeIconStrokeWidth,
                      ),
                      size: Size.square(metrics.closeIconSize),
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Attaches a controlled-or-uncontrolled balloon to [anchor].
///
/// Placement follows the Charcoal priority: below, above, right, then
/// left. The balloon can be toggled by pointer input on the anchor and always
/// exposes a close affordance. For an interactive anchor, prefer controlled
/// [visible] state with [showOnTap] disabled and toggle from the anchor action
/// so pointer and keyboard activation share one path. Escape dismisses while
/// focus is on the anchor or within the balloon.
final class CharcoalAnchoredBalloon extends StatefulWidget {
  const CharcoalAnchoredBalloon({
    required this.anchor,
    required this.message,
    this.action,
    this.dismissIcon,
    this.dismissLabel = 'Close',
    this.dismissAfter,
    this.dismissOnTapOutside = false,
    this.maxWidth,
    this.onVisibilityChanged,
    this.showOnTap = true,
    this.visible,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  final Widget? action;
  final Widget anchor;
  final Widget? dismissIcon;

  /// Semantics label of the dismiss button; pass the localized string.
  final String dismissLabel;
  final Duration? dismissAfter;
  final bool dismissOnTapOutside;
  final double? maxWidth;
  final String message;
  final ValueChanged<bool>? onVisibilityChanged;
  final bool showOnTap;
  final bool? visible;

  @override
  State<CharcoalAnchoredBalloon> createState() => _CharcoalAnchoredBalloonState();
}

final class _CharcoalAnchoredBalloonState extends State<CharcoalAnchoredBalloon>
    with SingleTickerProviderStateMixin {
  final GlobalKey _anchorKey = GlobalKey();
  late final AnimationController _animation;
  Timer? _dismissTimer;
  OverlayEntry? _entry;
  BuildContext? _overlayContext;
  bool _internalVisible = false;
  Rect? _targetRect;

  bool get _isVisible => widget.visible ?? _internalVisible;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
    );
    if (widget.visible == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showEntry());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = CharcoalTheme.of(context);
    _animation
      ..duration = theme.motion.standard
      ..reverseDuration = theme.motion.standard;
    _entry?.markNeedsBuild();
  }

  @override
  void didUpdateWidget(CharcoalAnchoredBalloon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible != widget.visible && widget.visible != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.visible!) {
          _showEntry();
        } else {
          _hideEntry();
        }
      });
    } else {
      _entry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _entry?.remove();
    _entry = null;
    _animation.dispose();
    super.dispose();
  }

  void _requestVisibility(bool visible) {
    if (visible && widget.message.isEmpty) return;
    if (widget.visible == null && _internalVisible != visible) {
      setState(() => _internalVisible = visible);
    }
    widget.onVisibilityChanged?.call(visible);
    if (widget.visible ?? visible) {
      _showEntry();
    } else {
      _hideEntry();
    }
  }

  void _showEntry() {
    if (!mounted || widget.message.isEmpty) return;
    _dismissTimer?.cancel();
    if (_entry == null) {
      final overlay = Overlay.of(context, rootOverlay: true);
      _overlayContext = overlay.context;
      _entry = OverlayEntry(builder: _buildOverlay);
      overlay.insert(_entry!);
    }
    if (MediaQuery.disableAnimationsOf(context)) {
      _animation.value = 1;
    } else {
      _animation.forward();
    }
    if (widget.dismissAfter case final duration? when duration > Duration.zero) {
      _dismissTimer = Timer(duration, () => _requestVisibility(false));
    }
  }

  Future<void> _hideEntry() async {
    _dismissTimer?.cancel();
    final entry = _entry;
    if (entry == null) return;
    if (!MediaQuery.disableAnimationsOf(context)) await _animation.reverse();
    if (!mounted || !identical(entry, _entry) || _isVisible) return;
    entry.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final anchorBox = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.attached || !anchorBox.hasSize) {
      return const SizedBox.shrink();
    }
    final origin = anchorBox.localToGlobal(Offset.zero);
    final theme = CharcoalTheme.of(context);
    final maxWidth = widget.maxWidth ?? theme.metrics.balloon.defaultMaxWidth;
    return InheritedTheme.capture(from: context, to: _overlayContext!).wrap(
      _BalloonOverlay(
        action: widget.action,
        animation: _animation,
        dismissOnTapOutside: widget.dismissOnTapOutside,
        dismissIcon: widget.dismissIcon,
        dismissLabel: widget.dismissLabel,
        maxWidth: maxWidth,
        message: widget.message,
        onDismiss: () => _requestVisibility(false),
        targetRect: _targetRect ?? (origin & anchorBox.size),
      ),
    );
  }

  void _handleTargetRectChanged(Rect rect) {
    if (_targetRect == rect) return;
    _targetRect = rect;
    _entry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{
        if (_isVisible)
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              _requestVisibility(false);
              return null;
            },
          ),
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: widget.showOnTap
            ? (event) {
                if (event.buttons == kPrimaryButton ||
                    event.kind == PointerDeviceKind.touch ||
                    event.kind == PointerDeviceKind.stylus) {
                  _requestVisibility(!_isVisible);
                }
              }
            : null,
        child: CharcoalOverlayAnchorTracker(
          onRectChanged: _handleTargetRectChanged,
          child: KeyedSubtree(key: _anchorKey, child: widget.anchor),
        ),
      ),
    ),
  );
}

final class _BalloonOverlay extends StatefulWidget {
  const _BalloonOverlay({
    required this.action,
    required this.animation,
    required this.dismissOnTapOutside,
    required this.dismissIcon,
    required this.dismissLabel,
    required this.maxWidth,
    required this.message,
    required this.onDismiss,
    required this.targetRect,
  });

  final Widget? action;
  final Animation<double> animation;
  final bool dismissOnTapOutside;
  final Widget? dismissIcon;
  final String dismissLabel;
  final double maxWidth;
  final String message;
  final VoidCallback onDismiss;
  final Rect targetRect;

  @override
  State<_BalloonOverlay> createState() => _BalloonOverlayState();
}

final class _BalloonOverlayState extends State<_BalloonOverlay> {
  final GlobalKey _surfaceKey = GlobalKey();
  late Size _surfaceSize;

  @override
  void initState() {
    super.initState();
    _surfaceSize = Size(widget.maxWidth, 0);
  }

  @override
  void didUpdateWidget(_BalloonOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxWidth != widget.maxWidth && _surfaceSize.height == 0) {
      _surfaceSize = Size(widget.maxWidth, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = CharcoalTheme.of(context);
    final viewport = Offset.zero & media.size;
    final placement = _placement(viewport);
    final gap = theme.space.xs;
    final inset = theme.space.lg;
    var origin = switch (placement) {
      CharcoalOverlayPosition.top => Offset(
        widget.targetRect.center.dx - _surfaceSize.width / 2,
        widget.targetRect.top - gap - _surfaceSize.height,
      ),
      CharcoalOverlayPosition.right => Offset(
        widget.targetRect.right + gap,
        widget.targetRect.center.dy - _surfaceSize.height / 2,
      ),
      CharcoalOverlayPosition.bottom => Offset(
        widget.targetRect.center.dx - _surfaceSize.width / 2,
        widget.targetRect.bottom + gap,
      ),
      CharcoalOverlayPosition.left => Offset(
        widget.targetRect.left - gap - _surfaceSize.width,
        widget.targetRect.center.dy - _surfaceSize.height / 2,
      ),
    };
    origin = Offset(
      constrainCharcoalOverlayOrigin(
        desired: origin.dx,
        inset: inset,
        popupExtent: _surfaceSize.width,
        viewportExtent: viewport.width,
      ),
      constrainCharcoalOverlayOrigin(
        desired: origin.dy,
        inset: inset,
        popupExtent: _surfaceSize.height,
        viewportExtent: viewport.height,
      ),
    );
    final tailPosition = _oppositeBalloonSide(placement);
    final arrowCenter = switch (tailPosition) {
      CharcoalOverlayPosition.top ||
      CharcoalOverlayPosition.bottom => widget.targetRect.center.dx - origin.dx,
      CharcoalOverlayPosition.right ||
      CharcoalOverlayPosition.left => widget.targetRect.center.dy - origin.dy,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    return Positioned.fill(
      child: Shortcuts(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                widget.onDismiss();
                return null;
              },
            ),
          },
          child: Stack(
            children: <Widget>[
              if (widget.dismissOnTapOutside)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    excludeFromSemantics: true,
                    onPanStart: (_) => widget.onDismiss(),
                    onTap: widget.onDismiss,
                  ),
                ),
              Positioned(
                left: origin.dx,
                top: origin.dy,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: widget.animation,
                    curve: Curves.easeInOut,
                  ),
                  child: KeyedSubtree(
                    key: _surfaceKey,
                    child: CharcoalBalloon(
                      action: widget.action,
                      arrowCenter: arrowCenter,
                      dismissIcon: widget.dismissIcon,
                      dismissLabel: widget.dismissLabel,
                      maxWidth: widget.maxWidth,
                      onDismiss: widget.onDismiss,
                      position: tailPosition,
                      child: Text(widget.message),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CharcoalOverlayPosition _placement(Rect viewport) {
    final theme = CharcoalTheme.of(context);
    final inset = theme.space.lg;
    final arrowAndGap = theme.metrics.balloon.arrowHeight + theme.space.xs;
    final bottomSpace = viewport.bottom - widget.targetRect.bottom - inset;
    final topSpace = widget.targetRect.top - viewport.top - inset;
    final rightSpace = viewport.right - widget.targetRect.right - inset;
    final leftSpace = widget.targetRect.left - viewport.left - inset;
    if (bottomSpace >= _surfaceSize.height + arrowAndGap) {
      return CharcoalOverlayPosition.bottom;
    }
    if (topSpace >= _surfaceSize.height + arrowAndGap) {
      return CharcoalOverlayPosition.top;
    }
    if (rightSpace >= _surfaceSize.width + arrowAndGap) {
      return CharcoalOverlayPosition.right;
    }
    if (leftSpace >= _surfaceSize.width + arrowAndGap) {
      return CharcoalOverlayPosition.left;
    }

    final verticalWidth = (viewport.width - inset * 2)
        .clamp(
          0,
          double.infinity,
        )
        .toDouble();
    final horizontalHeight = (viewport.height - inset * 2)
        .clamp(
          0,
          double.infinity,
        )
        .toDouble();
    final areas = <CharcoalOverlayPosition, double>{
      CharcoalOverlayPosition.bottom:
          bottomSpace.clamp(0, double.infinity).toDouble() * verticalWidth,
      CharcoalOverlayPosition.top: topSpace.clamp(0, double.infinity).toDouble() * verticalWidth,
      CharcoalOverlayPosition.right:
          rightSpace.clamp(0, double.infinity).toDouble() * horizontalHeight,
      CharcoalOverlayPosition.left:
          leftSpace.clamp(0, double.infinity).toDouble() * horizontalHeight,
    };
    return areas.entries.reduce((best, next) => best.value >= next.value ? best : next).key;
  }

  void _measure() {
    if (!mounted) return;
    final box = _surfaceKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size == _surfaceSize) return;
    setState(() => _surfaceSize = box.size);
  }
}

CharcoalOverlayPosition _oppositeBalloonSide(
  CharcoalOverlayPosition placement,
) => switch (placement) {
  CharcoalOverlayPosition.top => CharcoalOverlayPosition.bottom,
  CharcoalOverlayPosition.right => CharcoalOverlayPosition.left,
  CharcoalOverlayPosition.bottom => CharcoalOverlayPosition.top,
  CharcoalOverlayPosition.left => CharcoalOverlayPosition.right,
};
