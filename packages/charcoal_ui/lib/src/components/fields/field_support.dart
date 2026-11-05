import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import 'field_label.dart';

/// The text a field shows in its character counter: graphemes, not UTF-16 units, so it agrees
/// with what the user sees.
String charcoalFieldCountText(String text, int? maxLength) =>
    maxLength == null ? '${text.characters.length}' : '${text.characters.length}/$maxLength';

/// The label above a field, the field, and the assistive line below it.
///
/// Shared by every Charcoal field so label gap, assistive colour and the live region behave the
/// same. The label is always the bold `CharcoalFieldLabel` and the distance to the label and to the
/// assistive line is always `space.sm`, so mixed forms line up.
class CharcoalFieldFrame extends StatelessWidget {
  /// Frames [field].
  const CharcoalFieldFrame({
    required this.field,
    this.assistiveText,
    this.invalid = false,
    this.label = '',
    this.required = false,
    this.requiredText = '*Required',
    this.showLabel = false,
    this.subLabel,
    super.key,
  });

  /// The control itself.
  final Widget field;

  /// Helper or error text below the field.
  final String? assistiveText;

  /// Whether the field is invalid; colours the assistive text and announces it.
  final bool invalid;

  /// Label text.
  final String label;

  /// Whether to show the required marker.
  final bool required;

  /// Marker text.
  final String requiredText;

  /// Whether to show the visible label.
  final bool showLabel;

  /// Trailing label metadata.
  final Widget? subLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final assistive = assistiveText;
    final gap = theme.space.sm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showLabel) ...<Widget>[
          CharcoalFieldLabel(
            label: label,
            required: required,
            requiredText: requiredText,
            subLabel: subLabel,
          ),
          SizedBox(height: gap),
        ],
        field,
        if (assistive != null && assistive.isNotEmpty) ...<Widget>[
          SizedBox(height: gap),
          Semantics(
            container: true,
            liveRegion: invalid && !MediaQuery.supportsAnnounceOf(context),
            child: Text(
              assistive,
              style: theme.style(
                CharcoalTextRole.size14,
                color: invalid ? theme.colors.textNegative : theme.colors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
