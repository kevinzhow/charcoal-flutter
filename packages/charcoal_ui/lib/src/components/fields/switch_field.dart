import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/material.dart' show MaterialType, Material, Switch;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';

/// A labelled switch row with an optional hint line.
///
/// The whole row is the control: tapping the label toggles, and the semantics node is a single
/// toggle. The switch itself is painted by the theme's switch style and is decorative inside the
/// row, so label and switch never disagree about the state.
class CharcoalSwitchField extends StatelessWidget {
  /// A switch field showing [label] and [value].
  const CharcoalSwitchField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    super.key,
  });

  /// The label next to the switch.
  final String label;

  /// Whether the switch is on.
  final bool value;

  /// Called with the new value; null disables the field.
  final ValueChanged<bool>? onChanged;

  /// Muted text under the row.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final enabled = onChanged != null;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            label,
            style: theme.style(
              CharcoalTextRole.body,
              color: enabled ? theme.colors.text : theme.colors.textDisabled,
            ),
          ),
        ),
        SizedBox(width: theme.space.md),
        // Decorative: the clickable above owns pointer, focus and semantics.
        ExcludeSemantics(
          child: ExcludeFocus(
            child: IgnorePointer(
              child: Material(
                type: MaterialType.transparency,
                child: Switch(value: value, onChanged: enabled ? (_) {} : null),
              ),
            ),
          ),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalClickable(
          onPressed: enabled ? () => onChanged!(!value) : null,
          semanticButton: false,
          semanticLabel: label,
          toggled: value,
          builder: (context, states) => row,
        ),
        if (hint != null) ...<Widget>[
          SizedBox(height: theme.space.xs),
          Text(hint!, style: theme.style(CharcoalTextRole.caption)),
        ],
      ],
    );
  }
}
