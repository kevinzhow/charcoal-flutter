import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../selection/switch.dart';

/// A labelled switch with an optional hint line.
///
/// The label and the switch are one control ([CharcoalSwitch]), so tapping the label toggles and
/// the semantics expose a single toggle; the hint sits muted underneath.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalSwitch(
          label: Text(label),
          semanticLabel: label,
          value: value,
          onChanged: onChanged,
        ),
        if (hint != null) ...<Widget>[
          SizedBox(height: theme.space.xs),
          Text(hint!, style: theme.style(CharcoalTextRole.caption)),
        ],
      ],
    );
  }
}
