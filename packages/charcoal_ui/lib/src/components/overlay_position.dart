/// The side of a popup body on which its arrow is drawn.
///
/// For example, [top] means that the popup is below its anchor and the arrow
/// is drawn on the popup's top edge.
enum CharcoalOverlayPosition { top, right, bottom, left }

/// Constrains one popup axis without throwing when the popup is larger than
/// the available viewport.
double constrainCharcoalOverlayOrigin({
  required double desired,
  required double inset,
  required double popupExtent,
  required double viewportExtent,
}) {
  final upper = viewportExtent - popupExtent - inset;
  if (upper < inset) {
    final centered = (viewportExtent - popupExtent) / 2;
    return centered < 0 ? 0 : centered;
  }
  return desired.clamp(inset, upper).toDouble();
}
