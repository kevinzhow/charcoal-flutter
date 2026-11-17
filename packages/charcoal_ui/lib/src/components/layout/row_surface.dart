import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The fill of a list or table row in [states]: the info surface when [selected], the page colour
/// otherwise, with the hover or press overlay blended on top, so a held row never reads as a
/// second selected row.
Color charcoalRowFill(CharcoalTheme theme, Set<WidgetState> states, {required bool selected}) {
  final colors = theme.colors;
  final base = selected ? theme.tone(CharcoalTone.info).surface : colors.background;
  final overlay = states.contains(WidgetState.pressed)
      ? colors.pressOverlay
      : states.contains(WidgetState.hovered)
      ? colors.hoverOverlay
      : null;
  return overlay == null ? base : Color.alphaBlend(overlay, base);
}
