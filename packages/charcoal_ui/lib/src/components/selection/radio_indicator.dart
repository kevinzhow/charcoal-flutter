import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/interaction_state.dart';
import '../actions/control_support.dart';

/// The round indicator of a Charcoal radio option in the interaction [states] of the clickable
/// that owns it: a ring when not [selected], a filled disc with a dot when selected, and a halo
/// when focused or [invalid]. Shared by `CharcoalRadio` and `CharcoalRadioCards`.
final class CharcoalRadioIndicator extends StatelessWidget {
  /// Paints the indicator for [states].
  const CharcoalRadioIndicator({
    required this.selected,
    required this.states,
    this.invalid = false,
    super.key,
  });

  /// Whether the option is the group's value.
  final bool selected;

  /// The interaction states of the owning clickable.
  final Set<WidgetState> states;

  /// Whether the group's value is invalid.
  final bool invalid;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.radio;
    final focused = states.contains(WidgetState.focused);
    final duration = theme.duration(context, theme.motion.standard);
    final background = selected
        ? resolveCharcoalStateColor(
            states,
            normal: colors.primary,
            hovered: colors.primaryHover,
            pressed: colors.primaryPress,
          )
        : resolveCharcoalStateColor(
            states,
            normal: colors.surface,
            hovered: colors.surfaceHover,
            pressed: colors.surfacePress,
          );
    return AnimatedContainer(
      duration: duration,
      curve: theme.motion.curve,
      width: metrics.controlSize,
      height: metrics.controlSize,
      decoration: BoxDecoration(
        border: selected ? null : Border.all(color: colors.border, width: theme.borders.thick),
        borderRadius: BorderRadius.circular(theme.radius.pill),
        boxShadow: charcoalHaloShadow(
          theme,
          visible: focused || invalid,
          color: invalid ? colors.borderNegative : colors.focusRing,
        ),
        color: background,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: duration,
          width: selected ? metrics.dotSize : 0,
          height: selected ? metrics.dotSize : 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.radius.pill),
            color: colors.iconOnPrimary,
          ),
        ),
      ),
    );
  }
}
