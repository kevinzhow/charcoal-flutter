import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalOverlayPosition { top, right, bottom, left }

/// A token-driven tooltip that opens on pointer hover, keyboard focus, or a
/// long press without depending on Material or Cupertino.
final class CharcoalTooltip extends StatefulWidget {
  const CharcoalTooltip({
    required this.child,
    required this.message,
    this.position = CharcoalOverlayPosition.top,
    this.waitDuration = const Duration(milliseconds: 500),
    super.key,
  });

  final Widget child;
  final String message;
  final CharcoalOverlayPosition position;
  final Duration waitDuration;

  @override
  State<CharcoalTooltip> createState() => _CharcoalTooltipState();
}

final class _CharcoalTooltipState extends State<CharcoalTooltip> {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();
  Timer? _showTimer;

  @override
  void dispose() {
    _showTimer?.cancel();
    super.dispose();
  }

  void _scheduleShow() {
    _showTimer?.cancel();
    if (widget.waitDuration == Duration.zero) {
      _show();
      return;
    }
    _showTimer = Timer(widget.waitDuration, _show);
  }

  void _show() {
    if (mounted && widget.message.isNotEmpty) {
      _overlayController.show();
    }
  }

  void _hide() {
    _showTimer?.cancel();
    if (_overlayController.isShowing) {
      _overlayController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final placement = switch (widget.position) {
      CharcoalOverlayPosition.top => (
        target: Alignment.topCenter,
        follower: Alignment.bottomCenter,
        offset: const Offset(0, -8),
      ),
      CharcoalOverlayPosition.right => (
        target: Alignment.centerRight,
        follower: Alignment.centerLeft,
        offset: const Offset(8, 0),
      ),
      CharcoalOverlayPosition.bottom => (
        target: Alignment.bottomCenter,
        follower: Alignment.topCenter,
        offset: const Offset(0, 8),
      ),
      CharcoalOverlayPosition.left => (
        target: Alignment.centerLeft,
        follower: Alignment.centerRight,
        offset: const Offset(-8, 0),
      ),
    };

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (overlayContext) => CompositedTransformFollower(
        followerAnchor: placement.follower,
        link: _layerLink,
        offset: placement.offset,
        showWhenUnlinked: false,
        targetAnchor: placement.target,
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: 1,
          heightFactor: 1,
          child: CharcoalTheme(
            data: theme,
            child: _TooltipSurface(message: widget.message),
          ),
        ),
      ),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Semantics(
          tooltip: widget.message,
          child: MouseRegion(
            onEnter: (_) => _scheduleShow(),
            onExit: (_) => _hide(),
            child: Focus(
              onFocusChange: (focused) => focused ? _scheduleShow() : _hide(),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: _show,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _TooltipSurface extends StatelessWidget {
  const _TooltipSurface({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.dimensions.radius.s),
          color: theme.colors.containerHudDefault,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: theme.dimensions.space.component20,
              color: theme.colors.backgroundOverlay,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.dimensions.space.component30,
            vertical: theme.dimensions.space.component20,
          ),
          child: Text(
            message,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textOnHudDefault,
            ),
          ),
        ),
      ),
    );
  }
}
