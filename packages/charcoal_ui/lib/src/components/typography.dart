import 'package:flutter/widgets.dart';

import '../theme/charcoal_theme.dart';

enum CharcoalTypographySize { size10, size12, size14, size16, size20 }

enum CharcoalTypographyWeight { regular, bold }

/// The typography scale exposed by Charcoal iOS.
///
/// Flutter's ambient [MediaQuery.textScalerOf] is intentionally left intact,
/// so these styles participate in Dynamic Type/accessibility text scaling.
final class CharcoalTypography extends StatelessWidget {
  const CharcoalTypography({
    required this.child,
    this.color,
    this.monospace = false,
    this.singleLine = false,
    this.size = CharcoalTypographySize.size14,
    this.textAlign,
    this.weight = CharcoalTypographyWeight.regular,
    super.key,
  });

  final Widget child;
  final Color? color;
  final bool monospace;
  final bool singleLine;
  final CharcoalTypographySize size;
  final TextAlign? textAlign;
  final CharcoalTypographyWeight weight;

  @override
  Widget build(BuildContext context) => DefaultTextStyle.merge(
    maxLines: singleLine || monospace ? 1 : null,
    overflow: singleLine || monospace ? TextOverflow.ellipsis : null,
    style: charcoalTypographyStyle(
      context,
      color: color,
      monospace: monospace,
      size: size,
      weight: weight,
    ),
    textAlign: textAlign,
    child: child,
  );
}

/// Resolves an iOS-compatible Charcoal typography style.
TextStyle charcoalTypographyStyle(
  BuildContext context, {
  Color? color,
  bool monospace = false,
  CharcoalTypographySize size = CharcoalTypographySize.size14,
  CharcoalTypographyWeight weight = CharcoalTypographyWeight.regular,
}) {
  final theme = CharcoalTheme.of(context);
  final tokens = theme.components.numericTypography;
  final sizeTokens = switch (size) {
    CharcoalTypographySize.size10 => tokens.size10,
    CharcoalTypographySize.size12 => tokens.size12,
    CharcoalTypographySize.size14 => tokens.size14,
    CharcoalTypographySize.size16 => tokens.size16,
    CharcoalTypographySize.size20 => tokens.size20,
  };
  return TextStyle(
    color: color ?? theme.colors.textDefaultText1,
    fontFamily: monospace ? 'monospace' : theme.typography.fontFamily.sans,
    fontSize: sizeTokens.fontSize,
    fontWeight: switch (weight) {
      CharcoalTypographyWeight.regular => tokens.regularFontWeight,
      CharcoalTypographyWeight.bold => tokens.boldFontWeight,
    },
    height: monospace ? null : sizeTokens.lineHeight / sizeTokens.fontSize,
    leadingDistribution: monospace ? null : TextLeadingDistribution.even,
  );
}
