import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:flutter/widgets.dart';

import 'charcoal_text_styles.dart';

/// The foundation theme used by Charcoal widgets.
final class CharcoalThemeData {
  CharcoalThemeData._({
    required this.brightness,
    required this.colors,
    required this.dimensions,
    required this.typography,
  });

  factory CharcoalThemeData.light({
    CharcoalColorTokens? colors,
    CharcoalDimensionTokens? dimensions,
    CharcoalTypographyTokens? typography,
  }) => CharcoalThemeData._(
    brightness: Brightness.light,
    colors: colors ?? CharcoalGeneratedColorTokens.light,
    dimensions: dimensions ?? CharcoalGeneratedDimensionTokens.light,
    typography: typography ?? CharcoalGeneratedTypographyTokens.light,
  );

  factory CharcoalThemeData.dark({
    CharcoalColorTokens? colors,
    CharcoalDimensionTokens? dimensions,
    CharcoalTypographyTokens? typography,
  }) => CharcoalThemeData._(
    brightness: Brightness.dark,
    colors: colors ?? CharcoalGeneratedColorTokens.dark,
    dimensions: dimensions ?? CharcoalGeneratedDimensionTokens.dark,
    typography: typography ?? CharcoalGeneratedTypographyTokens.dark,
  );

  final Brightness brightness;
  final CharcoalColorTokens colors;
  final CharcoalDimensionTokens dimensions;
  final CharcoalTypographyTokens typography;

  CharcoalTextStyles get textStyles => CharcoalTextStyles(typography);

  CharcoalThemeData copyWith({
    Brightness? brightness,
    CharcoalColorTokens? colors,
    CharcoalDimensionTokens? dimensions,
    CharcoalTypographyTokens? typography,
  }) => CharcoalThemeData._(
    brightness: brightness ?? this.brightness,
    colors: colors ?? this.colors,
    dimensions: dimensions ?? this.dimensions,
    typography: typography ?? this.typography,
  );
}
