import 'package:flutter/widgets.dart';

/// Disabled opacity shared by Charcoal components.
///
/// This is a component behavior value, not a foundation design token.
const double charcoalDisabledOpacity = 0.32;

/// Resolves semantic colors for Flutter interaction states.
///
/// Hover and focus extend the source behavior for pointer and keyboard
/// platforms.
Color resolveCharcoalStateColor(
  Set<WidgetState> states, {
  required Color normal,
  required Color hovered,
  required Color pressed,
  Color? disabled,
  Color? focused,
  Color? selected,
}) {
  if (states.contains(WidgetState.disabled)) {
    return disabled ?? normal;
  }
  if (states.contains(WidgetState.pressed)) {
    return pressed;
  }
  if (states.contains(WidgetState.hovered)) {
    return hovered;
  }
  if (states.contains(WidgetState.focused) && focused != null) {
    return focused;
  }
  if (states.contains(WidgetState.selected) && selected != null) {
    return selected;
  }
  return normal;
}
