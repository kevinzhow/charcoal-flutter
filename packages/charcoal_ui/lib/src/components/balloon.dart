import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'tooltip.dart';

/// A persistent speech surface with a directional tail.
final class CharcoalBalloon extends StatelessWidget {
  const CharcoalBalloon({
    required this.child,
    this.position = CharcoalOverlayPosition.top,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final CharcoalOverlayPosition position;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    const tail = 8.0;
    final padding = switch (position) {
      CharcoalOverlayPosition.top => const EdgeInsets.fromLTRB(14, 18, 14, 10),
      CharcoalOverlayPosition.right => const EdgeInsets.fromLTRB(10, 10, 18, 10),
      CharcoalOverlayPosition.bottom => const EdgeInsets.fromLTRB(14, 10, 14, 18),
      CharcoalOverlayPosition.left => const EdgeInsets.fromLTRB(18, 10, 10, 10),
    };
    return Semantics(
      container: true,
      label: semanticLabel,
      child: CustomPaint(
        painter: _BalloonPainter(
          color: theme.colors.containerHudDefault,
          position: position,
          radius: theme.dimensions.radius.s,
          tail: tail,
        ),
        child: Padding(
          padding: padding,
          child: DefaultTextStyle(
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textOnHudDefault,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

final class _BalloonPainter extends CustomPainter {
  const _BalloonPainter({
    required this.color,
    required this.position,
    required this.radius,
    required this.tail,
  });

  final Color color;
  final CharcoalOverlayPosition position;
  final double radius;
  final double tail;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final body = switch (position) {
      CharcoalOverlayPosition.top => Rect.fromLTWH(0, tail, size.width, size.height - tail),
      CharcoalOverlayPosition.right => Rect.fromLTWH(0, 0, size.width - tail, size.height),
      CharcoalOverlayPosition.bottom => Rect.fromLTWH(0, 0, size.width, size.height - tail),
      CharcoalOverlayPosition.left => Rect.fromLTWH(tail, 0, size.width - tail, size.height),
    };
    canvas.drawRRect(RRect.fromRectAndRadius(body, Radius.circular(radius)), paint);

    final path = switch (position) {
      CharcoalOverlayPosition.top =>
        Path()
          ..moveTo(size.width / 2 - tail, tail)
          ..lineTo(size.width / 2, 0)
          ..lineTo(size.width / 2 + tail, tail),
      CharcoalOverlayPosition.right =>
        Path()
          ..moveTo(size.width - tail, size.height / 2 - tail)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width - tail, size.height / 2 + tail),
      CharcoalOverlayPosition.bottom =>
        Path()
          ..moveTo(size.width / 2 - tail, size.height - tail)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(size.width / 2 + tail, size.height - tail),
      CharcoalOverlayPosition.left =>
        Path()
          ..moveTo(tail, size.height / 2 - tail)
          ..lineTo(0, size.height / 2)
          ..lineTo(tail, size.height / 2 + tail),
    };
    canvas.drawPath(path..close(), paint);
  }

  @override
  bool shouldRepaint(_BalloonPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.position != position ||
      oldDelegate.radius != radius ||
      oldDelegate.tail != tail;
}
