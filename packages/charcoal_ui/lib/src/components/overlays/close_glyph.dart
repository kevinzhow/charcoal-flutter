import 'package:flutter/widgets.dart';

/// Paints the two-stroke close glyph shared by dialogs and balloons.
///
/// The glyph is drawn inside a square of the painter's size, inset by [inset] on every side. All
/// extents come from the caller (`metrics.modal` or `metrics.balloon`).
final class CharcoalCloseGlyphPainter extends CustomPainter {
  /// Creates a painter for a glyph of the given geometry.
  const CharcoalCloseGlyphPainter({
    required this.color,
    required this.inset,
    required this.strokeWidth,
  });

  /// Stroke colour.
  final Color color;

  /// Distance between the square's edge and the strokes' ends.
  final double inset;

  /// Stroke width.
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(Offset(inset, inset), Offset(size.width - inset, size.height - inset), paint)
      ..drawLine(Offset(size.width - inset, inset), Offset(inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(CharcoalCloseGlyphPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.inset != inset ||
      oldDelegate.strokeWidth != strokeWidth;
}
