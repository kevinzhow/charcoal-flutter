import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

/// Label, required marker, and trailing content shared by Charcoal form fields.
final class CharcoalFieldLabel extends StatelessWidget {
  const CharcoalFieldLabel({
    required this.label,
    this.required = false,
    this.requiredText = '*Required',
    this.subLabel,
    super.key,
  });

  final String label;
  final bool required;
  final String requiredText;
  final Widget? subLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final gap = theme.components.textField.gap;
    return Row(
      children: <Widget>[
        Text(
          label,
          style: theme.textStyles.captionMedium.copyWith(
            color: theme.colors.textDefaultText1,
          ),
        ),
        if (required) ...<Widget>[
          SizedBox(width: gap),
          Text(
            requiredText,
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
        ],
        if (subLabel != null) ...<Widget>[
          const Spacer(),
          DefaultTextStyle(
            style: theme.textStyles.captionMedium.copyWith(
              color: theme.colors.textTertiaryDefault,
            ),
            child: subLabel!,
          ),
        ],
      ],
    );
  }
}
