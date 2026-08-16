import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

abstract final class _LoadingSpinnerSpec {
  static const animationDuration = Duration(seconds: 1);
  static const shadowBlur = 8.0;
  static const overlayDuration = Duration(milliseconds: 250);
}

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

/// Centers a Charcoal spinner over [child] while [visible] is true.
///
/// By default the overlay intercepts input, matching the iOS modifier. Set
/// [interactionPassthrough] when the underlying content should remain usable.
final class CharcoalSpinnerOverlay extends StatelessWidget {
  const CharcoalSpinnerOverlay({
    required this.child,
    required this.visible,
    this.interactionPassthrough = false,
    this.spinnerSize,
    this.transparentBackground = false,
    super.key,
  });

  final Widget child;
  final bool interactionPassthrough;
  final double? spinnerSize;
  final bool transparentBackground;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: interactionPassthrough || !visible,
            child: AnimatedSwitcher(
              duration: reduceMotion ? Duration.zero : _LoadingSpinnerSpec.overlayDuration,
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: visible
                  ? Listener(
                      key: const ValueKey<String>('charcoal-spinner-overlay'),
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: (_) {},
                      child: Center(
                        child: CharcoalLoadingSpinner(
                          size: spinnerSize,
                          transparent: transparentBackground,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
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
    _controller.duration = _LoadingSpinnerSpec.animationDuration;
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
    final size = widget.size ?? theme.dimensions.space.targetL;
    final padding = widget.padding ?? theme.dimensions.space.component30;
    return Semantics(
      container: true,
      label: widget.semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                blurRadius: _LoadingSpinnerSpec.shadowBlur,
                color: Color(0x1A000000),
              ),
            ],
            color: widget.transparent ? null : theme.colors.backgroundDefault,
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: SizedBox.square(
              dimension: size,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final progress = Curves.easeOut.transform(_controller.value);
                  return Opacity(
                    opacity: 1 - progress,
                    child: Transform.scale(scale: progress, child: child),
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.color ?? theme.colors.iconTertiaryDefault,
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
