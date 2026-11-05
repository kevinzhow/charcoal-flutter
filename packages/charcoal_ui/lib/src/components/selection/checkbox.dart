import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import '../actions/control_support.dart';

/// A controlled checkbox.
///
/// [onChanged] requests the next value and does not mutate [value]; a null callback disables
/// pointer, keyboard and assistive-technology activation. The whole control, label included, is
/// the tap target. [invalid] is reflected visually (negative halo) and through input validation
/// semantics. With [rounded] the indicator is a circle ringed in the inner-focus colour, for use
/// over imagery.
final class CharcoalCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  const CharcoalCheckbox({
    required this.value,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.invalid = false,
    this.label,
    this.rounded = false,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  /// Whether the box is checked.
  final bool value;

  /// Requests the next value; null disables the checkbox.
  final ValueChanged<bool>? onChanged;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Whether the value is invalid.
  final bool invalid;

  /// A label after the box.
  final Widget? label;

  /// Whether the indicator is a circle instead of a rounded square.
  final bool rounded;

  /// Semantics label; when set it replaces the label of [label].
  final String? semanticLabel;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.checkbox;
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        checked: value,
        focusNode: focusNode,
        onPressed: onChanged == null ? null : () => onChanged!(!value),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        validationResult: invalid
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        builder: (context, states) {
          final focused = states.contains(WidgetState.focused);
          final background = value
              ? resolveCharcoalStateColor(
                  states,
                  normal: colors.primary,
                  hovered: colors.primaryHover,
                  pressed: colors.primaryPress,
                )
              : rounded
              ? resolveCharcoalStateColor(
                  states,
                  normal: colors.surfaceSecondary,
                  hovered: colors.surfaceSecondaryHover,
                  pressed: colors.surfaceSecondaryPress,
                )
              : colors.restOverlay;
          final control = AnimatedContainer(
            duration: theme.duration(context, theme.motion.standard),
            curve: theme.motion.curve,
            width: metrics.controlSize,
            height: metrics.controlSize,
            decoration: BoxDecoration(
              border: rounded
                  ? Border.all(color: CharcoalColorRoles.transparent, width: theme.borders.thick)
                  : value
                  ? null
                  : Border.all(color: colors.border, width: theme.borders.thick),
              borderRadius: BorderRadius.circular(
                rounded ? metrics.roundedRadius : theme.radius.sm,
              ),
              boxShadow: charcoalHaloShadow(
                theme,
                visible: focused || invalid,
                color: invalid ? colors.borderNegative : colors.focusRing,
                spread: rounded ? metrics.roundedFocusHaloWidth : theme.borders.focusHalo,
              ),
              color: background,
            ),
            child: value
                ? Center(
                    child: CharcoalIcon(
                      CharcoalIcons.check,
                      color: colors.iconOnPrimary,
                      size: metrics.checkSize,
                    ),
                  )
                : null,
          );
          final indicator = rounded
              ? SizedBox.square(
                  dimension: metrics.controlSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      control,
                      Positioned(
                        left: -metrics.outerOffset,
                        top: -metrics.outerOffset,
                        child: IgnorePointer(
                          child: Container(
                            width: theme.sizes.controlXs,
                            height: theme.sizes.controlXs,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.focusRingInner,
                                width: theme.borders.thick,
                              ),
                              borderRadius: BorderRadius.circular(theme.radius.lg),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : control;

          return CharcoalDisabledFade(
            disabled: states.contains(WidgetState.disabled),
            child: label == null
                ? indicator
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      indicator,
                      const CharcoalGap.horizontal(CharcoalSpace.xs),
                      Flexible(
                        child: CharcoalControlLabel(
                          role: CharcoalTextRole.captionMedium,
                          child: label!,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
