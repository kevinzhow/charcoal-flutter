import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';
import 'typography.dart';

abstract final class _FieldLabelSpec {
  static const compactBreakpoint = 240.0;
  static const lineHeight = 22.0;
}

/// Label, required marker, and trailing content shared by Charcoal form fields.
///
/// This widget owns the visible label row only. The associated form control
/// remains responsible for exposing its label, required state, validation, and
/// value through semantics. At compact widths or large text sizes, metadata
/// moves onto additional lines instead of being clipped.
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
    final labelStyle = charcoalTypographyStyle(
      context,
      color: theme.colors.textDefaultText1,
      size: CharcoalTypographySize.size14,
      weight: weight,
    );
    final requiredStyle = charcoalTypographyStyle(
      context,
      color: theme.colors.textSecondaryDefault,
      size: CharcoalTypographySize.size14,
    );
    final subLabelStyle = charcoalTypographyStyle(
      context,
      color: theme.colors.textTertiaryDefault,
      size: CharcoalTypographySize.size14,
    );
    final primaryGap = theme.dimensions.space.component10;
    final metadataGap = theme.dimensions.space.component20;
    final scaledLineHeight = MediaQuery.textScalerOf(
      context,
    ).scale(_FieldLabelSpec.lineHeight);
    final scaleFactor = (scaledLineHeight / _FieldLabelSpec.lineHeight).clamp(
      1.0,
      2.0,
    );

    Widget primaryLabel({required int maxLines}) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: primaryGap,
      children: <Widget>[
        Text(
          label,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: labelStyle,
        ),
        if (required)
          Text(
            requiredText,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: requiredStyle,
          ),
      ],
    );

    Widget secondaryLabel({required int maxLines}) => DefaultTextStyle(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: subLabelStyle,
      child: subLabel!,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            !constraints.hasBoundedWidth ||
            constraints.maxWidth < _FieldLabelSpec.compactBreakpoint * scaleFactor;
        if (compact) {
          return Column(
            crossAxisAlignment: constraints.hasBoundedWidth
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              primaryLabel(maxLines: 2),
              if (subLabel != null) ...<Widget>[
                SizedBox(height: primaryGap),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  heightFactor: 1,
                  widthFactor: constraints.hasBoundedWidth ? null : 1,
                  child: secondaryLabel(maxLines: 2),
                ),
              ],
            ],
          );
        }
        return Row(
          children: <Widget>[
            Expanded(child: primaryLabel(maxLines: 1)),
            if (subLabel != null) ...<Widget>[
              SizedBox(width: metadataGap),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.4,
                ),
                child: secondaryLabel(maxLines: 1),
              ),
            ],
          ],
        );
      },
    );
  }
}
