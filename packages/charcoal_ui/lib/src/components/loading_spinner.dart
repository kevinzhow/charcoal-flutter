import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';

/// Charcoal's expanding-dot loading indicator.
final class CharcoalLoadingSpinner extends StatefulWidget {
  const CharcoalLoadingSpinner({
    this.color,
    this.once = false,
    this.padding,
    this.semanticLabel = 'Loading',
    this.size,
    this.transparent = false,
    super.key,
  });

  final Color? color;
  final bool once;
  final double? padding;
  final String semanticLabel;
  final double? size;
  final bool transparent;

  @override
  State<CharcoalLoadingSpinner> createState() => _CharcoalLoadingSpinnerState();
}

final class _CharcoalLoadingSpinnerState extends State<CharcoalLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(CharcoalLoadingSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.once != widget.once) {
      _syncAnimation(restart: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncAnimation({bool restart = false}) {
    final tokens = CharcoalTheme.of(context).components.loadingSpinner;
    _controller.duration = tokens.animationDuration;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0.5;
      return;
    }
    if (widget.once) {
      if (restart || !_controller.isAnimating) {
        _controller.forward(from: 0);
      }
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = CharcoalTheme.of(context).components.loadingSpinner;
    final size = widget.size ?? tokens.size;
    final padding = widget.padding ?? tokens.padding;
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: Opacity(
          opacity: tokens.opacity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radius),
              color: widget.transparent
                  ? CharcoalTheme.of(context).colors.containerDefaultA
                  : tokens.backgroundColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: SizedBox.square(
                dimension: size,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final progress = CharcoalMotion.emphasizedCurve.transform(
                      _controller.value,
                    );
                    return Opacity(
                      opacity: 1 - progress,
                      child: Transform.scale(scale: progress, child: child),
                    );
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(tokens.radius),
                      color: widget.color ?? tokens.foregroundColor,
                    ),
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
