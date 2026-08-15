import 'package:charcoal_tokens/charcoal_tokens.dart';
import 'package:flutter/widgets.dart';

import '../generated/charcoal_component_recipes.g.dart';
import 'charcoal_text_styles.dart';
import 'component_tokens.dart';

/// The complete foundation and component theme used by Charcoal widgets.
final class CharcoalThemeData {
  CharcoalThemeData._({
    required this.brightness,
    required this.colors,
    required this.dimensions,
    required this.typography,
    required this.components,
  });

  factory CharcoalThemeData.light({
    CharcoalColorTokens? colors,
    CharcoalDimensionTokens? dimensions,
    CharcoalTypographyTokens? typography,
    CharcoalComponentTokens? components,
  }) => CharcoalThemeData._from(
    brightness: Brightness.light,
    colors: colors ?? CharcoalGeneratedColorTokens.light,
    dimensions: dimensions ?? CharcoalGeneratedDimensionTokens.light,
    typography: typography ?? CharcoalGeneratedTypographyTokens.light,
    components: components,
  );

  factory CharcoalThemeData.dark({
    CharcoalColorTokens? colors,
    CharcoalDimensionTokens? dimensions,
    CharcoalTypographyTokens? typography,
    CharcoalComponentTokens? components,
  }) => CharcoalThemeData._from(
    brightness: Brightness.dark,
    colors: colors ?? CharcoalGeneratedColorTokens.dark,
    dimensions: dimensions ?? CharcoalGeneratedDimensionTokens.dark,
    typography: typography ?? CharcoalGeneratedTypographyTokens.dark,
    components: components,
  );

  factory CharcoalThemeData._from({
    required Brightness brightness,
    required CharcoalColorTokens colors,
    required CharcoalDimensionTokens dimensions,
    required CharcoalTypographyTokens typography,
    required CharcoalComponentTokens? components,
  }) => CharcoalThemeData._(
    brightness: brightness,
    colors: colors,
    dimensions: dimensions,
    typography: typography,
    components:
        components ??
        CharcoalGeneratedComponentRecipes.resolve(
          colors: colors,
          dimensions: dimensions,
          typography: typography,
        ),
  );

  final Brightness brightness;
  final CharcoalColorTokens colors;
  final CharcoalDimensionTokens dimensions;
  final CharcoalTypographyTokens typography;
  final CharcoalComponentTokens components;

  CharcoalTextStyles get textStyles => CharcoalTextStyles(typography);

  CharcoalThemeData copyWith({
    Brightness? brightness,
    CharcoalColorTokens? colors,
    CharcoalDimensionTokens? dimensions,
    CharcoalTypographyTokens? typography,
    CharcoalComponentTokens? components,
  }) {
    final nextBrightness = brightness ?? this.brightness;
    final nextColors = colors ?? this.colors;
    final nextDimensions = dimensions ?? this.dimensions;
    final nextTypography = typography ?? this.typography;
    final foundationChanged = colors != null || dimensions != null || typography != null;
    return CharcoalThemeData._from(
      brightness: nextBrightness,
      colors: nextColors,
      dimensions: nextDimensions,
      typography: nextTypography,
      components: components ?? (foundationChanged ? null : this.components),
    );
  }
}
