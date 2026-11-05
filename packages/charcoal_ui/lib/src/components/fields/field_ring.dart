import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Paints a focus or validation ring entirely outside [child], fading it in and out.
///
/// A box shadow cannot be used for this: translucent field backgrounds reveal the shadow
/// underneath and appear to change colour. This painter keeps the inner edge of the stroke exactly
/// on the field boundary, so the ring never moves or resizes the field.
final class CharcoalFieldRing extends StatelessWidget {
  /// Draws a ring of [color] around [child] while [visible].
  ///
  /// [width] defaults to `borders.focusHalo` and the fade to `motion.standard`.
  const CharcoalFieldRing({
    required this.child,
    required this.color,
    required this.radius,
    required this.visible,
    this.duration,
    this.width,
    super.key,
  });

  /// The field the ring surrounds.
  final Widget child;

  /// Ring colour.
  final Color color;

  /// Corner radius of the field; the ring's outer radius is this plus [width].
  final double radius;

  /// Whether the ring is shown (fades in and out).
  final bool visible;

  /// Fade duration; null uses the theme's standard motion (zero when animations are disabled).
  final Duration? duration;

  /// Stroke width; null uses `borders.focusHalo`.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return TweenAnimationBuilder<double>(
      curve: theme.motion.curve,
      duration: duration ?? theme.duration(context, theme.motion.standard),
      tween: Tween<double>(end: visible ? 1 : 0),
      child: child,
      builder: (context, opacity, child) => Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: <Widget>[
          child!,
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: opacity,
                child: CustomPaint(
                  painter: CharcoalFieldRingPainter(
                    color: color,
                    radius: radius,
                    width: width ?? theme.borders.focusHalo,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The painter behind [CharcoalFieldRing].
@visibleForTesting
final class CharcoalFieldRingPainter extends CustomPainter {
  /// Creates a ring painter.
  const CharcoalFieldRingPainter({
    required this.color,
    required this.radius,
    required this.width,
  });

  /// Ring colour.
  final Color color;

  /// Corner radius of the field.
  final double radius;

  /// Stroke width.
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    if (width <= 0 || size.isEmpty) return;
    final strokeCenter = (Offset.zero & size).inflate(width / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(strokeCenter, Radius.circular(radius + width / 2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(CharcoalFieldRingPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius || oldDelegate.width != width;
}
