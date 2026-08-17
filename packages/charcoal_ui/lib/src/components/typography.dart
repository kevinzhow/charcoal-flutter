import 'package:flutter/widgets.dart';

import '../theme/charcoal_font_family.dart';
import '../theme/charcoal_theme.dart';

enum CharcoalTypographySize { size10, size12, size14, size16, size20 }

enum CharcoalTypographyWeight { regular, bold }

/// The numeric typography scale used by Charcoal components.
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

/// Resolves a numeric Charcoal typography style.
TextStyle charcoalTypographyStyle(
  BuildContext context, {
  Color? color,
  bool monospace = false,
  CharcoalTypographySize size = CharcoalTypographySize.size14,
  CharcoalTypographyWeight weight = CharcoalTypographyWeight.regular,
}) {
  final theme = CharcoalTheme.of(context);
  final (fontSize, lineHeight) = switch (size) {
    // charcoal-ios/Sources/CharcoalSwiftUI/Components/Typographies
    CharcoalTypographySize.size10 => (10.0, 18.0),
    CharcoalTypographySize.size12 => (12.0, 20.0),
    CharcoalTypographySize.size14 => (14.0, 22.0),
    CharcoalTypographySize.size16 => (16.0, 24.0),
    CharcoalTypographySize.size20 => (20.0, 28.0),
  };
  final font = resolveCharcoalSansFont(
    theme.typography,
    fontSize: fontSize,
  );
  return TextStyle(
    color: color ?? theme.colors.textDefaultText1,
    fontFamily: monospace ? 'monospace' : font.family,
    fontFamilyFallback: monospace ? null : font.familyFallback,
    fontSize: fontSize,
    fontWeight: switch (weight) {
      CharcoalTypographyWeight.regular => theme.typography.fontWeight.regular,
      CharcoalTypographyWeight.bold => theme.typography.fontWeight.bold,
    },
    height: monospace ? null : lineHeight / fontSize,
    leadingDistribution: monospace ? null : TextLeadingDistribution.even,
  );
}
