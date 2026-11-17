import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// Label, required or optional marker and trailing content shared by Charcoal form fields.
///
/// This widget owns the visible label row only. The associated form control remains responsible
/// for exposing its label, required state, validation and value through semantics. At compact
/// widths or large text sizes, metadata moves onto additional lines instead of being clipped.
final class CharcoalFieldLabel extends StatelessWidget {
  /// Shows [label], a required or an optional marker and an optional [subLabel].
  const CharcoalFieldLabel({
    required this.label,
    this.bold = true,
    this.optionalText,
    this.required = false,
    this.requiredText = '*Required',
    this.subLabel,
    super.key,
  }) : assert(!required || optionalText == null, 'A field is required or optional, not both');

  /// The label text.
  final String label;

  /// Whether the label uses the bold weight.
  final bool bold;

  /// The marker of an optional field after the label, such as "(optional)" or "(optional,
  /// defaults to server only)"; pass the localized string. Exclusive with [required].
  final String? optionalText;

  /// Whether to show [requiredText] after the label.
  final bool required;

  /// The marker text; pass the localized string.
  final String requiredText;

  /// Trailing metadata such as a character count.
  final Widget? subLabel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final metrics = theme.metrics.field;
    final colors = theme.colors;
    final labelStyle = theme.style(CharcoalTextRole.size14, color: colors.text, bold: bold);
    final requiredStyle = theme.style(CharcoalTextRole.size14, color: colors.textSecondary);
    final subLabelStyle = theme.style(CharcoalTextRole.size14, color: colors.textTertiary);
    final primaryGap = theme.space.xs;
    final metadataGap = theme.space.sm;
    final scaledLineHeight = MediaQuery.textScalerOf(context).scale(metrics.lineHeight);
    final scaleFactor = (scaledLineHeight / metrics.lineHeight).clamp(
      1.0,
      metrics.textScaleClampMax,
    );

    Widget primaryLabel({required int maxLines}) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: primaryGap,
      children: <Widget>[
        Text(label, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: labelStyle),
        if (required)
          Text(
            requiredText,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: requiredStyle,
          ),
        if (optionalText case final optional?)
          Text(optional, maxLines: maxLines, overflow: TextOverflow.ellipsis, style: subLabelStyle),
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
            constraints.maxWidth < metrics.compactBreakpoint * scaleFactor;
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
                  maxWidth: constraints.maxWidth * metrics.secondaryMaxWidthFraction,
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
