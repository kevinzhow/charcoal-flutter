import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'typography.dart';

/// Label, required marker, and trailing content shared by Charcoal form fields.
final class CharcoalFieldLabel extends StatelessWidget {
  const CharcoalFieldLabel({
    required this.label,
    this.required = false,
    this.requiredText = '*Required',
    this.subLabel,
    this.weight = CharcoalTypographyWeight.bold,
    super.key,
  });

  final String label;
  final bool required;
  final String requiredText;
  final Widget? subLabel;
  final CharcoalTypographyWeight weight;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: charcoalTypographyStyle(
                      context,
                      color: theme.colors.textDefaultText1,
                      size: CharcoalTypographySize.size14,
                      weight: weight,
                    ),
                  ),
                ),
                if (required) ...<Widget>[
                  SizedBox(width: theme.dimensions.space.component10),
                  Text(
                    requiredText,
                    maxLines: 1,
                    style: charcoalTypographyStyle(
                      context,
                      color: theme.colors.textSecondaryDefault,
                      size: CharcoalTypographySize.size14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (subLabel != null) ...<Widget>[
            SizedBox(width: theme.dimensions.space.component20),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.4,
              ),
              child: DefaultTextStyle(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: charcoalTypographyStyle(
                  context,
                  color: theme.colors.textTertiaryDefault,
                  size: CharcoalTypographySize.size14,
                ),
                child: subLabel!,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
