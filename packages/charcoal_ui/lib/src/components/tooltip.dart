import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'overlay_anchor_tracker.dart';
import 'overlay_position.dart';
import 'popup_shape.dart';
import 'typography.dart';

abstract final class _TooltipSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const defaultWaitDuration = Duration(milliseconds: 500);
  static const defaultMaxWidth = 184.0;
  static const arrowHeight = 3.0;
  static const arrowHalfWidth = 5.0;
}

/// An anchored Charcoal tooltip that supports pointer, keyboard, and touch.
///
/// With no explicit [position], placement is automatic and follows Charcoal's
/// below-then-above priority. Supplying [visible] makes
/// the tooltip controlled; otherwise it manages its own visibility. A visible
/// focus-triggered tooltip dismisses with Escape without moving anchor focus.
final class CharcoalTooltip extends StatefulWidget {
  const CharcoalTooltip({
    required this.child,
    required this.message,
    this.dismissAfter,
    this.dismissOnTapOutside = true,
    this.maxWidth,
    this.onVisibilityChanged,
    this.position,
    this.showOnFocus = true,
    this.showOnHover = true,
    this.showOnTap = true,
    this.visible,
    this.waitDuration = _TooltipSpec.defaultWaitDuration,
    super.key,
  }) : assert(maxWidth == null || maxWidth > 0);

  final Widget child;
  final Duration? dismissAfter;
  final bool dismissOnTapOutside;
  final double? maxWidth;
  final String message;
  final ValueChanged<bool>? onVisibilityChanged;

  /// Preferred placement of the tooltip relative to its anchor.
  ///
  /// When null, placement is selected automatically. This property describes
  /// where the tooltip body appears; its arrow is drawn on the opposite edge.
  final CharcoalOverlayPosition? position;
  final bool showOnFocus;
  final bool showOnHover;
  final bool showOnTap;

  /// Controlled visibility. Leave null for internally managed visibility.
  final bool? visible;
  final Duration waitDuration;

  @override
  State<CharcoalTooltip> createState() => _CharcoalTooltipState();
}

final class _CharcoalTooltipState extends State<CharcoalTooltip>
    with SingleTickerProviderStateMixin {
  final GlobalKey _targetKey = GlobalKey();
  OverlayEntry? _entry;
  Timer? _dismissTimer;
  Timer? _showTimer;
  late final AnimationController _animation;
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
    _animation
      ..duration = _TooltipSpec.animationDuration
      ..reverseDuration = _TooltipSpec.animationDuration;
    _entry?.markNeedsBuild();
  }

  @override
  void didUpdateWidget(CharcoalTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.isEmpty) {
      _requestVisibility(false);
    } else if (oldWidget.visible != widget.visible && widget.visible != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.visible!) {
          _showEntry();
        } else {
          _hideEntry();
        }
      });
    } else if (_entry != null &&
        (oldWidget.message != widget.message ||
            oldWidget.position != widget.position ||
            oldWidget.maxWidth != widget.maxWidth)) {
      _entry!.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _showTimer?.cancel();
    _entry?.remove();
    _entry = null;
    _animation.dispose();
    super.dispose();
  }

  void _scheduleShow() {
    _showTimer?.cancel();
    if (widget.waitDuration == Duration.zero) {
      _requestVisibility(true);
      return;
    }
    _showTimer = Timer(widget.waitDuration, () => _requestVisibility(true));
  }

  void _requestVisibility(bool visible) {
    _showTimer?.cancel();
    if (visible && widget.message.isEmpty) return;
    if (widget.visible == null && _internalVisible != visible) {
      setState(() => _internalVisible = visible);
    }
    widget.onVisibilityChanged?.call(visible);
    final effectiveVisible = widget.visible ?? visible;
    if (effectiveVisible) {
      _showEntry();
    } else {
      _hideEntry();
    }
  }

  void _showEntry() {
    if (!mounted || (!_isVisible && widget.visible != null) || widget.message.isEmpty) {
      return;
    }
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
    final dismissAfter = widget.dismissAfter;
    if (dismissAfter != null && dismissAfter > Duration.zero) {
      _dismissTimer = Timer(dismissAfter, () => _requestVisibility(false));
    }
  }

  Future<void> _hideEntry() async {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    final entry = _entry;
    if (entry == null) return;
    if (!MediaQuery.disableAnimationsOf(context) && _animation.value > 0) {
      await _animation.reverse();
    }
    if (!mounted || !identical(entry, _entry) || _isVisible) return;
    entry.remove();
    _entry = null;
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    final targetContext = _targetKey.currentContext;
    if (targetContext == null) return const SizedBox.shrink();
    final targetBox = targetContext.findRenderObject() as RenderBox?;
    if (targetBox == null || !targetBox.attached || !targetBox.hasSize) {
      return const SizedBox.shrink();
    }
    final targetOrigin = targetBox.localToGlobal(Offset.zero);
    final targetRect = _targetRect ?? (targetOrigin & targetBox.size);
    final theme = CharcoalTheme.of(context);
    final maxWidth = widget.maxWidth ?? _TooltipSpec.defaultMaxWidth;
    return CharcoalTheme(
      data: theme,
      child: _TooltipOverlay(
        animation: _animation,
        dismissOnTapOutside: widget.dismissOnTapOutside,
        maxWidth: maxWidth,
        message: widget.message,
        onDismiss: () => _requestVisibility(false),
        preferredPosition: widget.position,
        targetRect: targetRect,
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
      child: Semantics(
        tooltip: widget.message,
        child: MouseRegion(
          onEnter: widget.showOnHover ? (_) => _scheduleShow() : null,
          onExit: widget.showOnHover ? (_) => _requestVisibility(false) : null,
          child: Focus(
            canRequestFocus: false,
            onFocusChange: widget.showOnFocus
                ? (focused) => focused ? _scheduleShow() : _requestVisibility(false)
                : null,
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: widget.showOnTap
                  ? (event) {
                      if (event.buttons == kPrimaryButton ||
                          event.kind == PointerDeviceKind.touch ||
                          event.kind == PointerDeviceKind.stylus) {
                        _requestVisibility(true);
                      }
                    }
                  : null,
              child: CharcoalOverlayAnchorTracker(
                onRectChanged: _handleTargetRectChanged,
                child: KeyedSubtree(key: _targetKey, child: widget.child),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

final class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.animation,
    required this.dismissOnTapOutside,
    required this.maxWidth,
    required this.message,
    required this.onDismiss,
    required this.preferredPosition,
    required this.targetRect,
  });

  final Animation<double> animation;
  final bool dismissOnTapOutside;
  final double maxWidth;
  final String message;
  final VoidCallback onDismiss;
  final CharcoalOverlayPosition? preferredPosition;
  final Rect targetRect;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final media = MediaQuery.of(context);
    final viewport = Offset.zero & media.size;
    final horizontalPadding = theme.dimensions.space.component25;
    final verticalPadding = theme.dimensions.space.component10;
    final targetGap = theme.dimensions.space.component10;
    final screenInset = theme.dimensions.space.layout30;
    final textStyle = charcoalTypographyStyle(
      context,
      color: theme.colors.textOnHudDefault,
      size: CharcoalTypographySize.size12,
    );
    final painter =
        TextPainter(
          maxLines: null,
          text: TextSpan(text: message, style: textStyle),
          textAlign: TextAlign.center,
          textDirection: Directionality.of(context),
          textScaler: media.textScaler,
        )..layout(
          maxWidth: (maxWidth - horizontalPadding * 2).clamp(0, double.infinity).toDouble(),
        );
    final bodySize = Size(
      (painter.width + horizontalPadding * 2).clamp(0, maxWidth).toDouble(),
      painter.height + verticalPadding * 2,
    );
    final placement =
        preferredPosition ??
        _automaticPlacement(
          viewport,
          bodySize,
          arrow: _TooltipSpec.arrowHeight,
          gap: targetGap,
          inset: screenInset,
        );
    final tailPosition = _opposite(placement);
    final popupSize = switch (tailPosition) {
      CharcoalOverlayPosition.top || CharcoalOverlayPosition.bottom => Size(
        bodySize.width,
        bodySize.height + _TooltipSpec.arrowHeight,
      ),
      CharcoalOverlayPosition.right || CharcoalOverlayPosition.left => Size(
        bodySize.width + _TooltipSpec.arrowHeight,
        bodySize.height,
      ),
    };

    var origin = switch (placement) {
      CharcoalOverlayPosition.top => Offset(
        targetRect.center.dx - popupSize.width / 2,
        targetRect.top - targetGap - popupSize.height,
      ),
      CharcoalOverlayPosition.right => Offset(
        targetRect.right + targetGap,
        targetRect.center.dy - popupSize.height / 2,
      ),
      CharcoalOverlayPosition.bottom => Offset(
        targetRect.center.dx - popupSize.width / 2,
        targetRect.bottom + targetGap,
      ),
      CharcoalOverlayPosition.left => Offset(
        targetRect.left - targetGap - popupSize.width,
        targetRect.center.dy - popupSize.height / 2,
      ),
    };
    origin = Offset(
      constrainCharcoalOverlayOrigin(
        desired: origin.dx,
        inset: screenInset,
        popupExtent: popupSize.width,
        viewportExtent: viewport.width,
      ),
      constrainCharcoalOverlayOrigin(
        desired: origin.dy,
        inset: screenInset,
        popupExtent: popupSize.height,
        viewportExtent: viewport.height,
      ),
    );
    final arrowCenter = switch (tailPosition) {
      CharcoalOverlayPosition.top ||
      CharcoalOverlayPosition.bottom => targetRect.center.dx - origin.dx,
      CharcoalOverlayPosition.right ||
      CharcoalOverlayPosition.left => targetRect.center.dy - origin.dy,
    };
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          if (dismissOnTapOutside)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                excludeFromSemantics: true,
                onPanStart: (_) => onDismiss(),
                onTap: onDismiss,
              ),
            ),
          Positioned(
            left: origin.dx,
            top: origin.dy,
            child: IgnorePointer(
              child: FadeTransition(
                opacity: curvedAnimation,
                child: _TooltipSurface(
                  arrowCenter: arrowCenter,
                  message: message,
                  position: tailPosition,
                  size: popupSize,
                  textStyle: textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CharcoalOverlayPosition _automaticPlacement(
    Rect viewport,
    Size bodySize, {
    required double arrow,
    required double gap,
    required double inset,
  }) {
    final needsVertical = bodySize.height + arrow + gap;
    if (viewport.bottom - targetRect.bottom - inset >= needsVertical) {
      return CharcoalOverlayPosition.bottom;
    }
    if (targetRect.top - viewport.top - inset >= needsVertical) {
      return CharcoalOverlayPosition.top;
    }
    final below = viewport.bottom - targetRect.bottom;
    final above = targetRect.top - viewport.top;
    return below >= above ? CharcoalOverlayPosition.bottom : CharcoalOverlayPosition.top;
  }
}

CharcoalOverlayPosition _opposite(CharcoalOverlayPosition value) => switch (value) {
  CharcoalOverlayPosition.top => CharcoalOverlayPosition.bottom,
  CharcoalOverlayPosition.right => CharcoalOverlayPosition.left,
  CharcoalOverlayPosition.bottom => CharcoalOverlayPosition.top,
  CharcoalOverlayPosition.left => CharcoalOverlayPosition.right,
};

final class _TooltipSurface extends StatelessWidget {
  const _TooltipSurface({
    required this.arrowCenter,
    required this.message,
    required this.position,
    required this.size,
    required this.textStyle,
  });

  final double arrowCenter;
  final String message;
  final CharcoalOverlayPosition position;
  final Size size;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final horizontalPadding = theme.dimensions.space.component25;
    final verticalPadding = theme.dimensions.space.component10;
    final padding = switch (position) {
      CharcoalOverlayPosition.top => EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding + _TooltipSpec.arrowHeight,
        horizontalPadding,
        verticalPadding,
      ),
      CharcoalOverlayPosition.right => EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding + _TooltipSpec.arrowHeight,
        verticalPadding,
      ),
      CharcoalOverlayPosition.bottom => EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding + _TooltipSpec.arrowHeight,
      ),
      CharcoalOverlayPosition.left => EdgeInsets.fromLTRB(
        horizontalPadding + _TooltipSpec.arrowHeight,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
    };
    return SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: CharcoalPopupShapePainter(
          arrowCenter: arrowCenter,
          arrowHalfWidth: _TooltipSpec.arrowHalfWidth,
          arrowHeight: _TooltipSpec.arrowHeight,
          color: theme.colors.containerHudDefault,
          position: position,
          radius: theme.dimensions.radius.s,
        ),
        child: Padding(
          padding: padding,
          child: Text(message, textAlign: TextAlign.center, style: textStyle),
        ),
      ),
    );
  }
}
