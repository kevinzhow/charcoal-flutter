import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'field_support.dart';

/// The styled shell around any control that needs a label, a helper line and an optional action.
///
/// Use it for controls that have no label of their own, for example a secret field with a "pick a
/// file" button: the application supplies the control and the action (and any plugin such as a
/// file picker); the shell supplies label, required marker, spacing and assistive text.
class CharcoalFormField extends StatelessWidget {
  /// Frames [child] with a label and optional assistive text and [action].
  const CharcoalFormField({
    required this.label,
    required this.child,
    this.action,
    this.assistiveText,
    this.invalid = false,
    this.required = false,
    this.requiredText = '*Required',
    this.subLabel,
    super.key,
  });

  /// The label above the control.
  final String label;

  /// The control.
  final Widget child;

  /// A widget aligned to the start under the control, such as a button.
  final Widget? action;

  /// Helper or error text under the control.
  final String? assistiveText;

  /// Whether the content is invalid.
  final bool invalid;

  /// Whether to show the required marker.
  final bool required;

  /// The required marker text; pass the localized string.
  final String requiredText;

  /// Trailing label metadata.
  final Widget? subLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Semantics(
      container: true,
      child: CharcoalFieldFrame(
        assistiveText: assistiveText,
        invalid: invalid,
        label: label,
        required: required,
        requiredText: requiredText,
        showLabel: true,
        subLabel: subLabel,
        field: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            child,
            if (action != null) ...<Widget>[
              SizedBox(height: theme.space.xs),
              Align(alignment: AlignmentDirectional.centerStart, child: action),
            ],
          ],
        ),
      ),
    );
  }
}
