import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsRole;
import 'package:flutter/widgets.dart';

/// Charcoal's expanding-circle loading indicator.
///
/// The circle grows from the center while fading out over one second, matching
/// the Charcoal iOS spinner. The surrounding surface is 16 logical pixels from
/// the circle, has an 8-pixel radius, and can be made transparent.
final class CharcoalLoadingSpinner extends StatefulWidget {
  const CharcoalLoadingSpinner({
    this.color,
    this.once = false,
    this.padding,
    this.semanticLabel = 'Loading',
    this.size,
    this.transparent = false,
    super.key,
  }) : assert(size == null || size > 0),
       assert(padding == null || padding >= 0),
       assert(semanticLabel != ''),
       _inline = false;

  /// A `metrics.spinner.inlineSize` spinner with no surface or padding, to sit beside a line of
  /// small text such as a "Sending…" delivery status.
  const CharcoalLoadingSpinner.inline({this.semanticLabel = 'Loading', super.key})
    : assert(semanticLabel != ''),
      color = null,
      once = false,
      padding = 0,
      size = null,
      transparent = true,
      _inline = true;

  final Color? color;
  final bool once;
  final double? padding;
  final String semanticLabel;
  final double? size;
  final bool transparent;
  final bool _inline;

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
    _controller.duration = CharcoalTheme.of(context).metrics.spinner.rotationDuration;
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
    final theme = CharcoalTheme.of(context);
    final size = widget._inline
        ? theme.metrics.spinner.inlineSize
        : widget.size ?? theme.sizes.controlLg;
    final padding = widget.padding ?? theme.space.lg;
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      liveRegion: true,
      role: SemanticsRole.loadingSpinner,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.radius.md),
            boxShadow: <BoxShadow>[
              BoxShadow(blurRadius: theme.metrics.spinner.shadowBlur, color: theme.colors.shadow),
            ],
            color: widget.transparent ? null : theme.colors.background,
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: SizedBox.square(
              dimension: size,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final progress = Curves.easeOut.transform(_controller.value);
                  final remaining = 1 - progress;
                  return Opacity(
                    opacity: remaining,
                    child: Transform.scale(scale: progress, child: child),
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.color ?? theme.colors.iconTertiary,
                    shape: BoxShape.circle,
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
