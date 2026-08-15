import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';

/// Paints a focus or validation ring entirely outside [child].
///
/// A box shadow cannot be used for this: translucent field backgrounds reveal
/// the shadow underneath and appear to change color. This painter keeps the
/// inner edge of the stroke exactly on the field boundary.
final class CharcoalFieldRing extends StatelessWidget {
  const CharcoalFieldRing({
    required this.child,
    required this.color,
    required this.duration,
    required this.radius,
    required this.visible,
    required this.width,
    super.key,
  });

  final Widget child;
  final Color color;
  final Duration duration;
  final double radius;
  final bool visible;
  final double width;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      curve: CharcoalMotion.standardCurve,
      duration: duration,
      tween: Tween<double>(end: visible ? 1 : 0),
      child: child,
      builder: (context, opacity, child) {
        return CustomPaint(
          foregroundPainter: CharcoalFieldRingPainter(
            color: color,
            opacity: opacity,
            radius: radius,
            width: width,
          ),
          child: child,
        );
      },
    );
  }
}

@visibleForTesting
final class CharcoalFieldRingPainter extends CustomPainter {
  const CharcoalFieldRingPainter({
    required this.color,
    required this.opacity,
    required this.radius,
    required this.width,
  });

  final Color color;
  final double opacity;
  final double radius;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0 || width <= 0 || size.isEmpty) {
      return;
    }

    final strokeCenter = (Offset.zero & size).inflate(width / 2);
    final paint = Paint()
      ..color = color.withValues(alpha: color.a * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        strokeCenter,
        Radius.circular(radius + width / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CharcoalFieldRingPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.radius != radius ||
        oldDelegate.width != width;
  }
}
