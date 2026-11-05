import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import '../actions/control_support.dart';

/// A controlled radio option.
///
/// One instance per option; the parent owns [groupValue] and updates it from [onChanged], so the
/// previous and next options change together in one frame. A null [onChanged] disables the option.
/// [invalid] is reflected visually and through input validation semantics.
final class CharcoalRadio<T> extends StatelessWidget {
  /// Creates a radio option for [value].
  const CharcoalRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.autofocus = false,
    this.focusNode,
    this.invalid = false,
    this.label,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  /// The value this option represents.
  final T value;

  /// The currently selected value of the group.
  final T? groupValue;

  /// Reports this option's value when chosen; null disables it.
  final ValueChanged<T>? onChanged;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Whether the group's value is invalid.
  final bool invalid;

  /// A label after the indicator.
  final Widget? label;

  /// Semantics label; when set it replaces the label of [label].
  final String? semanticLabel;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.radio;
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        checked: _selected,
        focusNode: focusNode,
        inMutuallyExclusiveGroup: true,
        onPressed: onChanged == null ? null : () => onChanged!(value),
        semanticButton: false,
        semanticLabel: semanticLabel,
        statesController: statesController,
        validationResult: invalid
            ? SemanticsValidationResult.invalid
            : SemanticsValidationResult.none,
        builder: (context, states) {
          final focused = states.contains(WidgetState.focused);
          final duration = theme.duration(context, theme.motion.standard);
          final background = _selected
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
          final indicator = AnimatedContainer(
            duration: duration,
            curve: theme.motion.curve,
            width: metrics.controlSize,
            height: metrics.controlSize,
            decoration: BoxDecoration(
              border: _selected
                  ? null
                  : Border.all(color: colors.border, width: theme.borders.thick),
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
                width: _selected ? metrics.dotSize : 0,
                height: _selected ? metrics.dotSize : 0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.radius.pill),
                  color: colors.iconOnPrimary,
                ),
              ),
            ),
          );
          return CharcoalDisabledFade(
            disabled: states.contains(WidgetState.disabled),
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
