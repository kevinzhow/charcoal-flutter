import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'overlay_anchor_tracker.dart';
import 'overlay_position.dart';
import 'popup_shape.dart';

/// A persistent speech surface with a directional tail.
final class CharcoalBalloon extends StatelessWidget {
  const CharcoalBalloon({
    required this.child,
    this.action,
    this.arrowCenter,
    this.dismissIcon,
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
  final double? maxWidth;
  final VoidCallback? onDismiss;
  final CharcoalOverlayPosition position;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.balloon;
    final tail = tokens.arrowHeight;
    final padding = switch (position) {
      CharcoalOverlayPosition.top => EdgeInsets.fromLTRB(
        tokens.paddingHorizontal,
        tokens.paddingVertical + tail,
        tokens.paddingHorizontal,
        tokens.paddingVertical,
      ),
      CharcoalOverlayPosition.right => EdgeInsets.fromLTRB(
        tokens.paddingHorizontal,
        tokens.paddingVertical,
        tokens.paddingHorizontal + tail,
        tokens.paddingVertical,
      ),
      CharcoalOverlayPosition.bottom => EdgeInsets.fromLTRB(
        tokens.paddingHorizontal,
        tokens.paddingVertical,
        tokens.paddingHorizontal,
        tokens.paddingVertical + tail,
      ),
      CharcoalOverlayPosition.left => EdgeInsets.fromLTRB(
        tokens.paddingHorizontal + tail,
        tokens.paddingVertical,
        tokens.paddingHorizontal,
        tokens.paddingVertical,
      ),
    };
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? tokens.maxWidth),
        child: CustomPaint(
          painter: CharcoalPopupShapePainter(
            arrowCenter: arrowCenter,
            arrowHalfWidth: tokens.arrowHalfWidth,
            arrowHeight: tail,
            color: tokens.backgroundColor,
            position: position,
            radius: tokens.radius,
            strokeColor: tokens.strokeColor,
            strokeWidth: tokens.strokeWidth,
          ),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: TextStyle(
                color: tokens.foregroundColor,
                fontFamily: theme.typography.fontFamily.sans,
                fontSize: tokens.fontSize,
                fontWeight: tokens.fontWeight,
                height: tokens.lineHeight / tokens.fontSize,
                leadingDistribution: TextLeadingDistribution.even,
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
                        SizedBox(width: tokens.contentGap),
                        _BalloonCloseButton(
                          icon: dismissIcon,
                          onPressed: onDismiss!,
                        ),
                      ],
                    ],
                  ),
                  if (action case final action?) ...<Widget>[
                    SizedBox(height: tokens.gap),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          theme.dimensions.radius.oval,
                        ),
                        color: tokens.actionBackgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.actionPaddingHorizontal,
                          vertical: tokens.actionPaddingVertical,
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
  const _BalloonCloseButton({required this.onPressed, this.icon});

  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = CharcoalTheme.of(context).components.balloon;
    return Semantics(
      button: true,
      label: 'Close',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: tokens.actionBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: tokens.closeSize,
              child: Center(
                child: IconTheme(
                  data: IconThemeData(
                    color: tokens.foregroundColor,
                    size: tokens.closeIconSize,
                  ),
                  child:
                      icon ??
                      CustomPaint(
                        painter: _BalloonClosePainter(
                          color: tokens.foregroundColor,
                          inset: tokens.closeStrokeInset,
                          strokeWidth: tokens.closeStrokeWidth,
                        ),
                        size: Size.square(tokens.closeIconSize),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _BalloonClosePainter extends CustomPainter {
  const _BalloonClosePainter({
    required this.color,
    required this.inset,
    required this.strokeWidth,
  });

  final Color color;
  final double inset;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
    canvas
      ..drawLine(
        Offset(inset, inset),
        Offset(size.width - inset, size.height - inset),
        paint,
      )
      ..drawLine(
        Offset(size.width - inset, inset),
        Offset(inset, size.height - inset),
        paint,
      );
  }

  @override
  bool shouldRepaint(_BalloonClosePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.inset != inset ||
      oldDelegate.strokeWidth != strokeWidth;
}

/// Attaches an iOS-style, controlled-or-uncontrolled balloon to [anchor].
///
/// Placement follows the Charcoal iOS priority: below, above, right, then
/// left. The balloon can be toggled by tapping the anchor and always exposes a
/// close affordance.
final class CharcoalAnchoredBalloon extends StatefulWidget {
  const CharcoalAnchoredBalloon({
    required this.anchor,
    required this.message,
    this.action,
    this.dismissIcon,
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
    final duration = CharcoalTheme.of(context).components.balloon.animationDuration;
    _animation
      ..duration = duration
      ..reverseDuration = duration;
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
    if (widget.visible == null) _internalVisible = visible;
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
    final maxWidth = widget.maxWidth ?? theme.components.balloon.maxWidth;
    return CharcoalTheme(
      data: theme,
      child: _BalloonOverlay(
        action: widget.action,
        animation: _animation,
        dismissOnTapOutside: widget.dismissOnTapOutside,
        dismissIcon: widget.dismissIcon,
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
  Widget build(BuildContext context) => Listener(
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
  );
}

final class _BalloonOverlay extends StatefulWidget {
  const _BalloonOverlay({
    required this.action,
    required this.animation,
    required this.dismissOnTapOutside,
    required this.dismissIcon,
    required this.maxWidth,
    required this.message,
    required this.onDismiss,
    required this.targetRect,
  });

  final Widget? action;
  final Animation<double> animation;
  final bool dismissOnTapOutside;
  final Widget? dismissIcon;
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
    final viewport = Offset.zero & media.size;
    final tokens = CharcoalTheme.of(context).components.balloon;
    final placement = _placement(viewport);
    final gap = tokens.gap;
    final inset = tokens.screenInset;
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
      child: Stack(
        children: <Widget>[
          if (widget.dismissOnTapOutside)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
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
    );
  }

  CharcoalOverlayPosition _placement(Rect viewport) {
    final tokens = CharcoalTheme.of(context).components.balloon;
    final arrowAndGap = tokens.arrowHeight + tokens.gap;
    final inset = tokens.screenInset;
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
