import 'package:flutter/widgets.dart';

import 'overlay_position.dart';

/// Paints a rounded popup body and its arrow as one continuous path.
///
/// Keeping both pieces in a single path avoids the anti-aliased hairline that
/// appears when a triangle and rounded rectangle are painted separately.
final class CharcoalPopupShapePainter extends CustomPainter {
  const CharcoalPopupShapePainter({
    required this.arrowHalfWidth,
    required this.arrowHeight,
    required this.color,
    required this.position,
    required this.radius,
    this.arrowCenter,
    this.strokeColor,
    this.strokeWidth = 0,
  });

  final double arrowHalfWidth;
  final double arrowHeight;
  final double? arrowCenter;
  final Color color;
  final CharcoalOverlayPosition position;
  final double radius;
  final Color? strokeColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final path = charcoalPopupPath(
      arrowCenter: arrowCenter,
      arrowHalfWidth: arrowHalfWidth,
      arrowHeight: arrowHeight,
      position: position,
      radius: radius,
      size: size,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    if (strokeColor case final strokeColor? when strokeWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = strokeColor
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CharcoalPopupShapePainter oldDelegate) =>
      oldDelegate.arrowCenter != arrowCenter ||
      oldDelegate.arrowHalfWidth != arrowHalfWidth ||
      oldDelegate.arrowHeight != arrowHeight ||
      oldDelegate.color != color ||
      oldDelegate.position != position ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeColor != strokeColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

Path charcoalPopupPath({
  required double arrowHalfWidth,
  required double arrowHeight,
  required CharcoalOverlayPosition position,
  required double radius,
  required Size size,
  double? arrowCenter,
}) {
  final body = switch (position) {
    CharcoalOverlayPosition.top => Rect.fromLTWH(
      0,
      arrowHeight,
      size.width,
      size.height - arrowHeight,
    ),
    CharcoalOverlayPosition.right => Rect.fromLTWH(
      0,
      0,
      size.width - arrowHeight,
      size.height,
    ),
    CharcoalOverlayPosition.bottom => Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height - arrowHeight,
    ),
    CharcoalOverlayPosition.left => Rect.fromLTWH(
      arrowHeight,
      0,
      size.width - arrowHeight,
      size.height,
    ),
  };
  final safeRadius = radius.clamp(0, body.shortestSide / 2).toDouble();
  final bodyPath = Path()
    ..addRRect(
      RRect.fromRectAndRadius(body, Radius.circular(safeRadius)),
    );

  final vertical =
      position == CharcoalOverlayPosition.top || position == CharcoalOverlayPosition.bottom;
  final mainExtent = vertical ? body.width : body.height;
  final requestedCenter = arrowCenter ?? mainExtent / 2;
  final minCenter = safeRadius + arrowHalfWidth;
  final maxCenter = mainExtent - safeRadius - arrowHalfWidth;
  final center = maxCenter < minCenter
      ? mainExtent / 2
      : requestedCenter.clamp(minCenter, maxCenter).toDouble();

  // The base overlaps the body by a fraction of a pixel before the paths are
  // unioned. This prevents rasterization from exposing the background at the
  // join on fractional device-pixel ratios.
  const overlap = 0.5;
  final arrowPath = switch (position) {
    CharcoalOverlayPosition.top =>
      Path()
        ..moveTo(center - arrowHalfWidth, body.top + overlap)
        ..lineTo(center, 0)
        ..lineTo(center + arrowHalfWidth, body.top + overlap)
        ..close(),
    CharcoalOverlayPosition.right =>
      Path()
        ..moveTo(body.right - overlap, center - arrowHalfWidth)
        ..lineTo(size.width, center)
        ..lineTo(body.right - overlap, center + arrowHalfWidth)
        ..close(),
    CharcoalOverlayPosition.bottom =>
      Path()
        ..moveTo(center - arrowHalfWidth, body.bottom - overlap)
        ..lineTo(center, size.height)
        ..lineTo(center + arrowHalfWidth, body.bottom - overlap)
        ..close(),
    CharcoalOverlayPosition.left =>
      Path()
        ..moveTo(body.left + overlap, center - arrowHalfWidth)
        ..lineTo(0, center)
        ..lineTo(body.left + overlap, center + arrowHalfWidth)
        ..close(),
  };
  return Path.combine(PathOperation.union, bodyPath, arrowPath);
}
