import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:flutter/widgets.dart';

import 'charcoal_font_family.dart';

/// Precomposed text styles backed entirely by generated V2 typography tokens.
final class CharcoalTextStyles {
  const CharcoalTextStyles(this.tokens);

  final CharcoalTypographyTokens tokens;

  TextStyle get body => _style(
    fontSize: tokens.fontSize.body,
    lineHeight: tokens.lineHeight.body,
    fontWeight: tokens.fontWeight.regular,
  );

  TextStyle get bodyBold => _style(
    fontSize: tokens.fontSize.body,
    lineHeight: tokens.lineHeight.body,
    fontWeight: tokens.fontWeight.bold,
  );

  TextStyle get paragraph => _style(
    fontSize: tokens.fontSize.paragraph,
    lineHeight: tokens.lineHeight.paragraph,
    fontWeight: tokens.fontWeight.regular,
  );

  TextStyle get captionSmall => _style(
    fontSize: tokens.fontSize.captionS,
    lineHeight: tokens.lineHeight.captionS,
    fontWeight: tokens.fontWeight.regular,
  );

  TextStyle get captionMedium => _style(
    fontSize: tokens.fontSize.captionM,
    lineHeight: tokens.lineHeight.captionM,
    fontWeight: tokens.fontWeight.regular,
  );

  TextStyle get captionMediumBold => _style(
    fontSize: tokens.fontSize.captionM,
    lineHeight: tokens.lineHeight.captionM,
    fontWeight: tokens.fontWeight.bold,
  );

  TextStyle get headingXxxs => _heading(tokens.fontSize.headingXxxs, tokens.lineHeight.headingXxxs);
  TextStyle get headingXxs => _heading(tokens.fontSize.headingXxs, tokens.lineHeight.headingXxs);
  TextStyle get headingXs => _heading(tokens.fontSize.headingXs, tokens.lineHeight.headingXs);
  TextStyle get headingS => _heading(tokens.fontSize.headingS, tokens.lineHeight.headingS);
  TextStyle get headingM => _heading(tokens.fontSize.headingM, tokens.lineHeight.headingM);
  TextStyle get headingL => _heading(tokens.fontSize.headingL, tokens.lineHeight.headingL);
  TextStyle get headingXl => _heading(tokens.fontSize.headingXl, tokens.lineHeight.headingXl);
  TextStyle get headingXxl => _heading(tokens.fontSize.headingXxl, tokens.lineHeight.headingXxl);
  TextStyle get headingXxxl => _heading(tokens.fontSize.headingXxxl, tokens.lineHeight.headingXxxl);

  TextStyle _heading(double fontSize, double lineHeight) => _style(
    fontSize: fontSize,
    lineHeight: lineHeight,
    fontWeight: tokens.fontWeight.bold,
  );

  TextStyle _style({
    required double fontSize,
    required double lineHeight,
    required FontWeight fontWeight,
  }) {
    final font = resolveCharcoalSansFont(tokens, fontSize: fontSize);
    return TextStyle(
      fontFamily: font.family,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
      leadingDistribution: TextLeadingDistribution.even,
      package: font.fontPackage,
    );
  }
}
