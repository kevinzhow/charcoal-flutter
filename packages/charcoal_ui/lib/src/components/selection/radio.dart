import 'package:flutter/semantics.dart' show SemanticsValidationResult;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/layout.dart';
import '../actions/control_support.dart';
import 'radio_indicator.dart';

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
          final indicator = CharcoalRadioIndicator(
            selected: _selected,
            states: states,
            invalid: invalid,
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
