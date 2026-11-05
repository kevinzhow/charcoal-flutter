import 'package:flutter/widgets.dart';

/// Resolves a colour for a set of interaction [states].
///
/// Precedence: disabled, pressed, hovered, focused, selected, then [normal]. The caller passes the
/// theme roles for each state; this function owns only the ordering.
Color resolveCharcoalStateColor(
  Set<WidgetState> states, {
  required Color normal,
  required Color hovered,
  required Color pressed,
  Color? disabled,
  Color? focused,
  Color? selected,
}) {
  if (states.contains(WidgetState.disabled)) return disabled ?? normal;
  if (states.contains(WidgetState.pressed)) return pressed;
  if (states.contains(WidgetState.hovered)) return hovered;
  if (states.contains(WidgetState.focused) && focused != null) return focused;
  if (states.contains(WidgetState.selected) && selected != null) return selected;
  return normal;
}
