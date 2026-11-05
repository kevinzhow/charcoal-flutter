import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import '../actions/control_support.dart';

/// Visual context for one [CharcoalMultiSelect] option.
enum CharcoalMultiSelectVariant {
  /// A neutral indicator on a standard application surface.
  normal,

  /// A HUD-bordered indicator painted over artwork or other media.
  overlay,
}

/// A controlled multi-selection option with a circular, borderless indicator.
///
/// Use one instance per option and keep the selected set in the parent. Place related instances
/// in one visibly and semantically named group; this widget owns no list, select-all behaviour or
/// hidden popup. [onChanged] requests the next value but does not mutate [selected]; a null
/// callback disables pointer, keyboard and assistive-technology activation. [invalid] is
/// reflected visually and through input validation semantics.
final class CharcoalMultiSelect extends StatelessWidget {
  /// Creates a multi-select option.
  const CharcoalMultiSelect({
    required this.selected,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.invalid = false,
    this.label,
    this.semanticLabel,
    this.statesController,
    this.variant = CharcoalMultiSelectVariant.normal,
    super.key,
  });

  /// Whether this option belongs to the parent-owned selected set.
  final bool selected;

  /// Requests that the caller add or remove this option from its selected set.
  final ValueChanged<bool>? onChanged;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Whether the option is part of an invalid multi-selection result.
  final bool invalid;

  /// A label after the indicator.
  final Widget? label;

  /// Semantics label; when set it replaces the label of [label].
  final String? semanticLabel;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  /// The visual surface on which the indicator is painted.
  final CharcoalMultiSelectVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.multiSelect;
    final overlay = variant == CharcoalMultiSelectVariant.overlay;
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        checked: selected,
        focusNode: focusNode,
        onPressed: onChanged == null ? null : () => onChanged!(!selected),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        validationResult: invalid
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final background = selected
              ? resolveCharcoalStateColor(
                  states,
                  normal: colors.primary,
                  hovered: colors.primaryHover,
                  pressed: colors.primaryPress,
                )
              : resolveCharcoalStateColor(
                  states,
                  normal: overlay ? colors.fillOnImage : colors.neutral,
                  hovered: colors.neutralHover,
                  pressed: colors.neutralPress,
                );
          final ringColor = invalid ? colors.borderNegative : colors.focusRing;
          final indicator = SizedBox.square(
            dimension: metrics.controlSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                AnimatedContainer(
                  duration: theme.duration(context, theme.motion.standard),
                  curve: theme.motion.curve,
                  width: metrics.controlSize,
                  height: metrics.controlSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.radius.pill),
                    boxShadow: charcoalHaloShadow(
                      theme,
                      visible: !disabled && (focused || (invalid && !overlay)),
                      color: ringColor,
                    ),
                    color: background,
                  ),
                ),
                Positioned(
                  left: -metrics.outerOffset,
                  top: -metrics.outerOffset,
                  child: IgnorePointer(
                    child: Container(
                      width: theme.sizes.controlXs,
                      height: theme.sizes.controlXs,
                      decoration: BoxDecoration(
                        border: overlay
                            ? Border.all(color: colors.borderHud, width: theme.borders.thick)
                            : null,
                        borderRadius: BorderRadius.circular(theme.radius.pill),
                        boxShadow: charcoalHaloShadow(
                          theme,
                          visible: !disabled && invalid && overlay,
                          color: colors.borderNegative,
                        ),
                      ),
                      child: Center(
                        child: CharcoalIcon(
                          CharcoalIcons.check,
                          color: colors.iconOnPrimary,
                          size: metrics.checkSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          return CharcoalDisabledFade(
            disabled: disabled,
            child: label == null
                ? indicator
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      indicator,
                      const CharcoalGap.horizontal(CharcoalSpace.xs),
                      Flexible(child: CharcoalControlLabel(child: label!)),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
