import 'dart:convert';

import 'token_model.dart';

final class GeneratedArtifact {
  const GeneratedArtifact({required this.relativePath, required this.contents});

  final String relativePath;
  final String contents;
}

final class DartTokenGenerator {
  DartTokenGenerator({required this.bundle, required this.componentRecipes});

  final TokenBundle bundle;
  final Map<String, dynamic> componentRecipes;

  List<GeneratedArtifact> render() => <GeneratedArtifact>[
    GeneratedArtifact(
      relativePath: 'packages/charcoal_tokens/lib/src/generated/charcoal_color_tokens.g.dart',
      contents: _renderColors(),
    ),
    GeneratedArtifact(
      relativePath: 'packages/charcoal_tokens/lib/src/generated/charcoal_dimension_tokens.g.dart',
      contents: _renderDimensions(),
    ),
    GeneratedArtifact(
      relativePath: 'packages/charcoal_tokens/lib/src/generated/charcoal_typography_tokens.g.dart',
      contents: _renderTypography(),
    ),
    GeneratedArtifact(
      relativePath: 'packages/charcoal_ui/lib/src/generated/charcoal_component_recipes.g.dart',
      contents: _renderComponentRecipes(),
    ),
  ];

  String _renderColors() {
    final semanticKeys = _keys(bundle.lightApplied, 'color');
    final primitiveKeys = _keys(bundle.base, 'color');
    final brandKeys = _keys(bundle.base, 'brand-color');
    _validateIdentifiers(semanticKeys, context: 'semantic color');
    _validateIdentifiers(primitiveKeys, context: 'primitive color');
    _validateIdentifiers(brandKeys, context: 'brand color');

    final output = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln("import 'dart:ui' show Color;")
      ..writeln()
      ..writeln('/// One named color value exposed for catalogs and tooling.')
      ..writeln('final class CharcoalColorTokenEntry {')
      ..writeln('  const CharcoalColorTokenEntry({required this.path, required this.value});')
      ..writeln()
      ..writeln('  final String path;')
      ..writeln('  final Color value;')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Semantic Charcoal colors for one brightness mode.')
      ..writeln('final class CharcoalColorTokens {')
      ..writeln('  const CharcoalColorTokens({');
    for (final key in semanticKeys) {
      output.writeln('    required this.${tokenIdentifier(key)},');
    }
    output
      ..writeln('  });')
      ..writeln();
    for (final key in semanticKeys) {
      output
        ..writeln('  /// `{color.$key}`')
        ..writeln('  final Color ${tokenIdentifier(key)};');
    }
    output
      ..writeln()
      ..writeln('  CharcoalColorTokens copyWith({');
    for (final key in semanticKeys) {
      output.writeln('    Color? ${tokenIdentifier(key)},');
    }
    output.writeln('  }) => CharcoalColorTokens(');
    for (final key in semanticKeys) {
      final identifier = tokenIdentifier(key);
      output.writeln('    $identifier: $identifier ?? this.$identifier,');
    }
    output
      ..writeln('  );')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Enumerates semantic colors without reflection.')
      ..writeln('extension CharcoalColorTokenCatalog on CharcoalColorTokens {')
      ..writeln('  List<CharcoalColorTokenEntry> get entries => <CharcoalColorTokenEntry>[');
    for (final key in semanticKeys) {
      output.writeln(
        "    CharcoalColorTokenEntry(path: 'color.$key', value: ${tokenIdentifier(key)}),",
      );
    }
    output
      ..writeln('  ];')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Generated semantic color schemes. Do not edit by hand.')
      ..writeln('abstract final class CharcoalGeneratedColorTokens {')
      ..writeln('  static const CharcoalColorTokens light = CharcoalColorTokens(');
    _writeColorAssignments(output, semanticKeys, bundle.light['color']!);
    output
      ..writeln('  );')
      ..writeln()
      ..writeln('  static const CharcoalColorTokens dark = CharcoalColorTokens(');
    _writeColorAssignments(output, semanticKeys, bundle.dark['color']!);
    output
      ..writeln('  );')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Primitive colors. Components should use semantic colors instead.')
      ..writeln('abstract final class CharcoalPrimitiveColors {');
    for (final key in primitiveKeys) {
      output
        ..writeln('  /// `{color.$key}`')
        ..writeln(
          '  static const Color ${tokenIdentifier(key)} = '
          '${_colorExpression(bundle.light['color']![key]!, path: 'color.$key')};',
        );
    }
    output.writeln(
      '  static const List<CharcoalColorTokenEntry> entries = <CharcoalColorTokenEntry>[',
    );
    for (final key in primitiveKeys) {
      output.writeln(
        "    CharcoalColorTokenEntry(path: 'color.$key', value: ${tokenIdentifier(key)}),",
      );
    }
    output
      ..writeln('  ];')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Product brand colors from Charcoal V2.')
      ..writeln('abstract final class CharcoalBrandColors {');
    for (final key in brandKeys) {
      output
        ..writeln('  /// `{brand-color.$key}`')
        ..writeln(
          '  static const Color ${tokenIdentifier(key)} = '
          '${_colorExpression(bundle.light['brand-color']![key]!, path: 'brand-color.$key')};',
        );
    }
    output.writeln(
      '  static const List<CharcoalColorTokenEntry> entries = <CharcoalColorTokenEntry>[',
    );
    for (final key in brandKeys) {
      output.writeln(
        "    CharcoalColorTokenEntry(path: 'brand-color.$key', value: ${tokenIdentifier(key)}),",
      );
    }
    output
      ..writeln('  ];')
      ..writeln('}')
      ..writeln();
    return output.toString();
  }

  void _writeColorAssignments(StringBuffer output, List<String> keys, Map<String, Object> values) {
    for (final key in keys) {
      output.writeln(
        '    ${tokenIdentifier(key)}: ${_colorExpression(values[key]!, path: 'color.$key')},',
      );
    }
  }

  String _renderDimensions() {
    const categories = <String, String>{
      'border-width': 'BorderWidth',
      'paragraph-width': 'ParagraphWidth',
      'radius': 'Radius',
      'space': 'Space',
    };
    final output = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln('/// One named logical-pixel value exposed for catalogs and tooling.')
      ..writeln('final class CharcoalDimensionTokenEntry {')
      ..writeln('  const CharcoalDimensionTokenEntry({required this.path, required this.value});')
      ..writeln()
      ..writeln('  final String path;')
      ..writeln('  final double value;')
      ..writeln('}')
      ..writeln();

    for (final entry in categories.entries) {
      final keys = _keys(bundle.lightApplied, entry.key);
      _validateIdentifiers(keys, context: entry.key);
      _writeDoubleTokenClass(
        output,
        className: 'Charcoal${entry.value}Tokens',
        category: entry.key,
        keys: keys,
      );
    }

    output
      ..writeln('/// All generated dimensional tokens for one brightness mode.')
      ..writeln('final class CharcoalDimensionTokens {')
      ..writeln('  const CharcoalDimensionTokens({')
      ..writeln('    required this.borderWidth,')
      ..writeln('    required this.paragraphWidth,')
      ..writeln('    required this.radius,')
      ..writeln('    required this.space,')
      ..writeln('  });')
      ..writeln()
      ..writeln('  final CharcoalBorderWidthTokens borderWidth;')
      ..writeln('  final CharcoalParagraphWidthTokens paragraphWidth;')
      ..writeln('  final CharcoalRadiusTokens radius;')
      ..writeln('  final CharcoalSpaceTokens space;')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Generated light and dark dimensions. Do not edit by hand.')
      ..writeln('abstract final class CharcoalGeneratedDimensionTokens {');
    _writeDimensionMode(output, 'light', bundle.light, categories);
    output.writeln();
    _writeDimensionMode(output, 'dark', bundle.dark, categories);
    output
      ..writeln('}')
      ..writeln();
    return output.toString();
  }

  void _writeDoubleTokenClass(
    StringBuffer output, {
    required String className,
    required String category,
    required List<String> keys,
  }) {
    output
      ..writeln('/// `{$category.*}` tokens.')
      ..writeln('final class $className {')
      ..writeln('  const $className({');
    for (final key in keys) {
      output.writeln('    required this.${tokenIdentifier(key)},');
    }
    output
      ..writeln('  });')
      ..writeln();
    for (final key in keys) {
      output
        ..writeln('  /// `{$category.$key}` in logical pixels.')
        ..writeln('  final double ${tokenIdentifier(key)};');
    }
    output
      ..writeln()
      ..writeln('  $className copyWith({');
    for (final key in keys) {
      output.writeln('    double? ${tokenIdentifier(key)},');
    }
    output.writeln('  }) => $className(');
    for (final key in keys) {
      final identifier = tokenIdentifier(key);
      output.writeln('    $identifier: $identifier ?? this.$identifier,');
    }
    output
      ..writeln('  );')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Enumerates `$category` values without reflection.')
      ..writeln('extension ${className}Catalog on $className {')
      ..writeln(
        '  List<CharcoalDimensionTokenEntry> get entries => <CharcoalDimensionTokenEntry>[',
      );
    for (final key in keys) {
      output.writeln(
        "    CharcoalDimensionTokenEntry(path: '$category.$key', value: ${tokenIdentifier(key)}),",
      );
    }
    output
      ..writeln('  ];')
      ..writeln('}')
      ..writeln();
  }

  void _writeDimensionMode(
    StringBuffer output,
    String mode,
    TokenTree values,
    Map<String, String> categories,
  ) {
    output.writeln('  static const CharcoalDimensionTokens $mode = CharcoalDimensionTokens(');
    for (final entry in categories.entries) {
      final property = _lowerCamel(entry.value);
      output.writeln('    $property: Charcoal${entry.value}Tokens(');
      for (final key in _keys(bundle.lightApplied, entry.key)) {
        output.writeln(
          '      ${tokenIdentifier(key)}: '
          '${_doubleExpression(parsePixels(values[entry.key]![key]!, path: '$mode.${entry.key}.$key'))},',
        );
      }
      output.writeln('    ),');
    }
    output.writeln('  );');
  }

  String _renderTypography() {
    final groupKeys = <String, List<String>>{
      'font-family': _keys(bundle.base, 'text')
          .where((key) => key.startsWith('font-family/'))
          .map((key) => key.substring('font-family/'.length))
          .toList(),
      for (final prefix in <String>['font-size', 'font-weight', 'line-height'])
        prefix: _keys(bundle.lightApplied, 'text')
            .where((key) => key.startsWith('$prefix/'))
            .map((key) => key.substring(prefix.length + 1))
            .toList(),
    };
    for (final entry in groupKeys.entries) {
      _validateIdentifiers(entry.value, context: 'text.${entry.key}');
    }

    final output = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln("import 'dart:ui' show FontWeight;")
      ..writeln()
      ..writeln('/// One named typography value exposed for catalogs and tooling.')
      ..writeln('final class CharcoalTypographyTokenEntry<T> {')
      ..writeln('  const CharcoalTypographyTokenEntry({required this.path, required this.value});')
      ..writeln()
      ..writeln('  final String path;')
      ..writeln('  final T value;')
      ..writeln('}')
      ..writeln();
    _writeTypographyGroup(
      output,
      className: 'CharcoalFontFamilyTokens',
      category: 'font-family',
      dartType: 'String',
      keys: groupKeys['font-family']!,
    );
    _writeTypographyGroup(
      output,
      className: 'CharcoalFontSizeTokens',
      category: 'font-size',
      dartType: 'double',
      keys: groupKeys['font-size']!,
    );
    _writeTypographyGroup(
      output,
      className: 'CharcoalFontWeightTokens',
      category: 'font-weight',
      dartType: 'FontWeight',
      keys: groupKeys['font-weight']!,
    );
    _writeTypographyGroup(
      output,
      className: 'CharcoalLineHeightTokens',
      category: 'line-height',
      dartType: 'double',
      keys: groupKeys['line-height']!,
    );

    output
      ..writeln('/// All generated typography tokens for one brightness mode.')
      ..writeln('final class CharcoalTypographyTokens {')
      ..writeln('  const CharcoalTypographyTokens({')
      ..writeln('    required this.fontFamily,')
      ..writeln('    required this.fontSize,')
      ..writeln('    required this.fontWeight,')
      ..writeln('    required this.lineHeight,')
      ..writeln('  });')
      ..writeln()
      ..writeln('  final CharcoalFontFamilyTokens fontFamily;')
      ..writeln('  final CharcoalFontSizeTokens fontSize;')
      ..writeln('  final CharcoalFontWeightTokens fontWeight;')
      ..writeln('  final CharcoalLineHeightTokens lineHeight;')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Generated light and dark typography. Do not edit by hand.')
      ..writeln('abstract final class CharcoalGeneratedTypographyTokens {');
    _writeTypographyMode(output, 'light', bundle.light, groupKeys);
    output.writeln();
    _writeTypographyMode(output, 'dark', bundle.dark, groupKeys);
    output
      ..writeln('}')
      ..writeln();
    return output.toString();
  }

  void _writeTypographyGroup(
    StringBuffer output, {
    required String className,
    required String category,
    required String dartType,
    required List<String> keys,
  }) {
    output
      ..writeln('/// `{text.$category/*}` tokens.')
      ..writeln('final class $className {')
      ..writeln('  const $className({');
    for (final key in keys) {
      output.writeln('    required this.${tokenIdentifier(key)},');
    }
    output
      ..writeln('  });')
      ..writeln();
    for (final key in keys) {
      output
        ..writeln('  /// `{text.$category/$key}`')
        ..writeln('  final $dartType ${tokenIdentifier(key)};');
    }
    output
      ..writeln()
      ..writeln('  $className copyWith({');
    for (final key in keys) {
      output.writeln('    $dartType? ${tokenIdentifier(key)},');
    }
    output.writeln('  }) => $className(');
    for (final key in keys) {
      final identifier = tokenIdentifier(key);
      output.writeln('    $identifier: $identifier ?? this.$identifier,');
    }
    output
      ..writeln('  );')
      ..writeln('}')
      ..writeln()
      ..writeln('/// Enumerates `text.$category` values without reflection.')
      ..writeln('extension ${className}Catalog on $className {')
      ..writeln(
        '  List<CharcoalTypographyTokenEntry<$dartType>> get entries => '
        '<CharcoalTypographyTokenEntry<$dartType>>[',
      );
    for (final key in keys) {
      output.writeln(
        "    CharcoalTypographyTokenEntry<$dartType>(path: 'text.$category/$key', value: ${tokenIdentifier(key)}),",
      );
    }
    output
      ..writeln('  ];')
      ..writeln('}')
      ..writeln();
  }

  void _writeTypographyMode(
    StringBuffer output,
    String mode,
    TokenTree values,
    Map<String, List<String>> groupKeys,
  ) {
    output.writeln('  static const CharcoalTypographyTokens $mode = CharcoalTypographyTokens(');
    for (final group in <String>['font-family', 'font-size', 'font-weight', 'line-height']) {
      final property = tokenIdentifier(group);
      final classSuffix = switch (group) {
        'font-family' => 'FontFamily',
        'font-size' => 'FontSize',
        'font-weight' => 'FontWeight',
        'line-height' => 'LineHeight',
        _ => throw StateError('Unexpected typography group $group'),
      };
      output.writeln('    $property: Charcoal${classSuffix}Tokens(');
      for (final key in groupKeys[group]!) {
        final fullKey = '$group/$key';
        final value = values['text']![fullKey]!;
        final expression = switch (group) {
          'font-family' => _stringExpression(value, path: '$mode.text.$fullKey'),
          'font-size' || 'line-height' => _doubleExpression(
            parsePixels(value, path: '$mode.text.$fullKey'),
          ),
          'font-weight' => 'FontWeight.w${parseFontWeight(value, path: '$mode.text.$fullKey')}',
          _ => throw StateError('Unexpected typography group $group'),
        };
        output.writeln('      ${tokenIdentifier(key)}: $expression,');
      }
      output.writeln('    ),');
    }
    output.writeln('  );');
  }

  String _renderComponentRecipes() {
    final recipes = _RecipeReader(componentRecipes, bundle);
    final output = StringBuffer()
      ..writeln(_generatedHeader)
      ..writeln("import 'package:charcoal_tokens/charcoal_tokens.dart';")
      ..writeln()
      ..writeln("import '../theme/component_tokens.dart';")
      ..writeln()
      ..writeln('/// Resolves component recipes against a foundation token set.')
      ..writeln('///')
      ..writeln('/// Keeping references here (instead of copied color values) means a')
      ..writeln('/// [CharcoalColorTokens.copyWith] override propagates into every component.')
      ..writeln('abstract final class CharcoalGeneratedComponentRecipes {')
      ..writeln('  static CharcoalComponentTokens resolve({')
      ..writeln('    required CharcoalColorTokens colors,')
      ..writeln('    required CharcoalDimensionTokens dimensions,')
      ..writeln('    required CharcoalTypographyTokens typography,')
      ..writeln('  }) => CharcoalComponentTokens(')
      ..write(_renderBalloonRecipe(recipes))
      ..writeln('    button: CharcoalButtonTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['button', 'animation-duration-ms'])},',
      )
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['button', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['button', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.reference(<String>['button', 'focus-ring-width'], _RecipeType.dimension)},',
      );
    for (final size in <String>['small', 'medium']) {
      output.writeln('      $size: CharcoalButtonSizeTokens(');
      for (final field in <String>[
        'gap',
        'height',
        'icon-size',
        'font-size',
        'line-height',
        'padding-horizontal',
        'radius',
      ]) {
        final type = field == 'font-size' || field == 'line-height'
            ? _RecipeType.dimension
            : _RecipeType.dimension;
        output.writeln(
          '        ${tokenIdentifier(field)}: '
          '${recipes.reference(<String>['button', 'sizes', size, field], type)},',
        );
      }
      output.writeln(
        '        fontWeight: ${recipes.reference(<String>['button', 'sizes', size, 'font-weight'], _RecipeType.fontWeight)},',
      );
      output.writeln('      ),');
    }
    for (final variant in <String>['default', 'primary', 'overlay', 'danger', 'navigation']) {
      final property = variant == 'default' ? 'normal' : variant;
      output
        ..writeln('      $property: CharcoalButtonVariantTokens(')
        ..writeln('        background: CharcoalStateColors(');
      _writeStateColors(output, recipes, <String>['button', 'variants', variant, 'background']);
      output
        ..writeln('        ),')
        ..writeln('        foreground: CharcoalStateColors(');
      _writeStateColors(output, recipes, <String>['button', 'variants', variant, 'foreground']);
      output
        ..writeln('        ),')
        ..writeln('      ),');
    }
    output
      ..writeln('    ),')
      ..write(_renderCarouselRecipe(recipes))
      ..write(_renderCheckboxRecipe(recipes))
      ..write(_renderDropdownRecipe(recipes))
      ..write(_renderHintRecipe(recipes))
      ..write(_renderIconButtonRecipe(recipes))
      ..write(_renderLinkButtonRecipe(recipes))
      ..write(_renderLoadingSpinnerRecipe(recipes))
      ..write(_renderModalRecipe(recipes))
      ..write(_renderMultiSelectRecipe(recipes))
      ..write(_renderNumericTypographyRecipe(recipes))
      ..write(_renderRadioRecipe(recipes))
      ..write(_renderSnackbarRecipe(recipes))
      ..write(_renderSwitchRecipe(recipes))
      ..write(_renderTagItemRecipe(recipes))
      ..writeln('    textField: CharcoalTextFieldTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['text-field', 'animation-duration-ms'])},',
      )
      ..writeln(
        '      assistiveTextColor: ${recipes.reference(<String>['text-field', 'assistive-text-color'], _RecipeType.color)},',
      )
      ..writeln('      background: CharcoalStateColors(');
    _writeStateColors(
      output,
      recipes,
      <String>['text-field', 'background'],
      includeFocused: true,
    );
    output
      ..writeln('      ),')
      ..writeln(
        '      counterColor: ${recipes.reference(<String>['text-field', 'counter-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      contentGap: ${recipes.dimension(<String>['text-field', 'content-gap'])},',
      )
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['text-field', 'disabled-opacity'], min: 0, max: 1)},',
      );
    for (final field in <String>[
      'focus-ring-color',
      'foreground-color',
      'invalid-assistive-text-color',
      'invalid-ring-color',
      'placeholder-color',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: '
        '${recipes.reference(<String>['text-field', field], _RecipeType.color)},',
      );
    }
    for (final field in <String>[
      'focus-ring-width',
      'font-size',
      'gap',
      'height',
      'line-height',
      'padding-horizontal',
      'radius',
      'vertical-gap',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: '
        '${recipes.reference(<String>['text-field', field], _RecipeType.dimension)},',
      );
    }
    output
      ..writeln(
        '      fontWeight: ${recipes.reference(<String>['text-field', 'font-weight'], _RecipeType.fontWeight)},',
      )
      ..writeln('    ),')
      ..write(_renderToastRecipe(recipes))
      ..write(_renderTooltipRecipe(recipes))
      ..writeln('  );')
      ..writeln('}')
      ..writeln();
    recipes.assertAllRecipesConsumed();
    return output.toString();
  }

  String _renderBalloonRecipe(_RecipeReader recipes) =>
      '''    balloon: CharcoalBalloonTokens(
      actionBackgroundColor: ${recipes.reference(<String>['balloon', 'action-background-color'], _RecipeType.color)},
      actionPaddingHorizontal: ${recipes.dimension(<String>['balloon', 'action-padding-horizontal'])},
      actionPaddingVertical: ${recipes.dimension(<String>['balloon', 'action-padding-vertical'])},
      animationDuration: ${recipes.duration(<String>['balloon', 'animation-duration-ms'])},
      arrowHalfWidth: ${recipes.dimension(<String>['balloon', 'arrow-half-width'])},
      arrowHeight: ${recipes.dimension(<String>['balloon', 'arrow-height'])},
      backgroundColor: ${recipes.reference(<String>['balloon', 'background-color'], _RecipeType.color)},
      closeIconSize: ${recipes.dimension(<String>['balloon', 'close-icon-size'])},
      closeSize: ${recipes.dimension(<String>['balloon', 'close-size'])},
      closeStrokeInset: ${recipes.dimension(<String>['balloon', 'close-stroke-inset'])},
      closeStrokeWidth: ${recipes.dimension(<String>['balloon', 'close-stroke-width'])},
      contentGap: ${recipes.dimension(<String>['balloon', 'content-gap'])},
      fontSize: ${recipes.dimension(<String>['balloon', 'font-size'])},
      fontWeight: ${recipes.reference(<String>['balloon', 'font-weight'], _RecipeType.fontWeight)},
      foregroundColor: ${recipes.reference(<String>['balloon', 'foreground-color'], _RecipeType.color)},
      gap: ${recipes.dimension(<String>['balloon', 'gap'])},
      lineHeight: ${recipes.dimension(<String>['balloon', 'line-height'])},
      maxWidth: ${recipes.dimension(<String>['balloon', 'max-width'])},
      paddingHorizontal: ${recipes.dimension(<String>['balloon', 'padding-horizontal'])},
      paddingVertical: ${recipes.dimension(<String>['balloon', 'padding-vertical'])},
      radius: ${recipes.dimension(<String>['balloon', 'radius'])},
      screenInset: ${recipes.dimension(<String>['balloon', 'screen-inset'])},
      strokeColor: ${recipes.reference(<String>['balloon', 'stroke-color'], _RecipeType.color)},
      strokeWidth: ${recipes.dimension(<String>['balloon', 'stroke-width'])},
    ),
''';

  String _renderHintRecipe(_RecipeReader recipes) =>
      '''    hint: CharcoalHintTokens(
      actionGap: ${recipes.dimension(<String>['hint', 'action-gap'])},
      backgroundColor: ${recipes.reference(<String>['hint', 'background-color'], _RecipeType.color)},
      fontSize: ${recipes.dimension(<String>['hint', 'font-size'])},
      fontWeight: ${recipes.reference(<String>['hint', 'font-weight'], _RecipeType.fontWeight)},
      foregroundColor: ${recipes.reference(<String>['hint', 'foreground-color'], _RecipeType.color)},
      gap: ${recipes.dimension(<String>['hint', 'gap'])},
      iconColor: ${recipes.reference(<String>['hint', 'icon-color'], _RecipeType.color)},
      iconSize: ${recipes.dimension(<String>['hint', 'icon-size'])},
      lineHeight: ${recipes.dimension(<String>['hint', 'line-height'])},
      paddingHorizontal: ${recipes.dimension(<String>['hint', 'padding-horizontal'])},
      paddingVertical: ${recipes.dimension(<String>['hint', 'padding-vertical'])},
      radius: ${recipes.dimension(<String>['hint', 'radius'])},
    ),
''';

  String _renderLinkButtonRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    linkButton: CharcoalLinkButtonTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['link-button', 'animation-duration-ms'])},',
      )
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['link-button', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['link-button', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['link-button', 'focus-ring-width'])},',
      )
      ..writeln(
        '      fontSize: ${recipes.dimension(<String>['link-button', 'font-size'])},',
      )
      ..writeln(
        '      fontWeight: ${recipes.reference(<String>['link-button', 'font-weight'], _RecipeType.fontWeight)},',
      )
      ..writeln('      foreground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['link-button', 'foreground']);
    output
      ..writeln('      ),')
      ..writeln('      height: ${recipes.dimension(<String>['link-button', 'height'])},')
      ..writeln(
        '      lineHeight: ${recipes.dimension(<String>['link-button', 'line-height'])},',
      )
      ..writeln(
        '      paddingHorizontal: ${recipes.dimension(<String>['link-button', 'padding-horizontal'])},',
      )
      ..writeln('      radius: ${recipes.dimension(<String>['link-button', 'radius'])},')
      ..writeln('    ),');
    return output.toString();
  }

  String _renderModalRecipe(_RecipeReader recipes) =>
      '''    modal: CharcoalModalTokens(
      actionGap: ${recipes.dimension(<String>['modal', 'action-gap'])},
      actionPadding: ${recipes.dimension(<String>['modal', 'action-padding'])},
      animationDuration: ${recipes.duration(<String>['modal', 'animation-duration-ms'])},
      backgroundColor: ${recipes.reference(<String>['modal', 'background-color'], _RecipeType.color)},
      barrierColor: ${recipes.reference(<String>['modal', 'barrier-color'], _RecipeType.color)},
      barrierOpacity: ${recipes.number(<String>['modal', 'barrier-opacity'], min: 0, max: 1)},
      bottomSheetMinBottomPadding: ${recipes.dimension(<String>['modal', 'bottom-sheet-min-bottom-padding'])},
      centerEdgePadding: ${recipes.dimension(<String>['modal', 'center-edge-padding'])},
      centerScale: ${recipes.number(<String>['modal', 'center-scale'], min: 0, max: 10)},
      closeIconSize: ${recipes.dimension(<String>['modal', 'close-icon-size'])},
      closeSize: ${recipes.dimension(<String>['modal', 'close-size'])},
      closeStrokeInset: ${recipes.dimension(<String>['modal', 'close-stroke-inset'])},
      closeStrokeWidth: ${recipes.dimension(<String>['modal', 'close-stroke-width'])},
      defaultMaxWidth: ${recipes.dimension(<String>['modal', 'default-max-width'])},
      minWidth: ${recipes.dimension(<String>['modal', 'min-width'])},
      radius: ${recipes.dimension(<String>['modal', 'radius'])},
      titleFontSize: ${recipes.dimension(<String>['modal', 'title-font-size'])},
      titleFontWeight: ${recipes.reference(<String>['modal', 'title-font-weight'], _RecipeType.fontWeight)},
      titleLineHeight: ${recipes.dimension(<String>['modal', 'title-line-height'])},
      titlePaddingHorizontal: ${recipes.dimension(<String>['modal', 'title-padding-horizontal'])},
      titlePaddingVertical: ${recipes.dimension(<String>['modal', 'title-padding-vertical'])},
    ),
''';

  String _renderNumericTypographyRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    numericTypography: CharcoalNumericTypographyTokens(')
      ..writeln(
        '      boldFontWeight: ${recipes.reference(<String>['numeric-typography', 'bold-font-weight'], _RecipeType.fontWeight)},',
      )
      ..writeln(
        '      regularFontWeight: ${recipes.reference(<String>['numeric-typography', 'regular-font-weight'], _RecipeType.fontWeight)},',
      );
    for (final size in <String>['size10', 'size12', 'size14', 'size16', 'size20']) {
      output
        ..writeln('      $size: CharcoalNumericTypographySizeTokens(')
        ..writeln(
          '        fontSize: ${recipes.dimension(<String>['numeric-typography', 'sizes', size, 'font-size'])},',
        )
        ..writeln(
          '        lineHeight: ${recipes.dimension(<String>['numeric-typography', 'sizes', size, 'line-height'])},',
        )
        ..writeln('      ),');
    }
    output.writeln('    ),');
    return output.toString();
  }

  String _renderSnackbarRecipe(_RecipeReader recipes) =>
      '''    snackbar: CharcoalSnackbarTokens(
      animationDuration: ${recipes.duration(<String>['snackbar', 'animation-duration-ms'])},
      backgroundColor: ${recipes.reference(<String>['snackbar', 'background-color'], _RecipeType.color)},
      borderColor: ${recipes.reference(<String>['snackbar', 'border-color'], _RecipeType.color)},
      borderWidth: ${recipes.dimension(<String>['snackbar', 'border-width'])},
      contentGap: ${recipes.dimension(<String>['snackbar', 'content-gap'])},
      dismissDuration: ${recipes.duration(<String>['snackbar', 'dismiss-duration-ms'])},
      fontSize: ${recipes.dimension(<String>['snackbar', 'font-size'])},
      fontWeight: ${recipes.reference(<String>['snackbar', 'font-weight'], _RecipeType.fontWeight)},
      foregroundColor: ${recipes.reference(<String>['snackbar', 'foreground-color'], _RecipeType.color)},
      maxWidth: ${recipes.dimension(<String>['snackbar', 'max-width'])},
      paddingHorizontal: ${recipes.dimension(<String>['snackbar', 'padding-horizontal'])},
      paddingVertical: ${recipes.dimension(<String>['snackbar', 'padding-vertical'])},
      radius: ${recipes.dimension(<String>['snackbar', 'radius'])},
      screenEdgeSpacing: ${recipes.dimension(<String>['snackbar', 'screen-edge-spacing'])},
      screenHorizontalInset: ${recipes.dimension(<String>['snackbar', 'screen-horizontal-inset'])},
      thumbnailSize: ${recipes.dimension(<String>['snackbar', 'thumbnail-size'])},
    ),
''';

  String _renderToastRecipe(_RecipeReader recipes) =>
      '''    toast: CharcoalToastTokens(
      animationDuration: ${recipes.duration(<String>['toast', 'animation-duration-ms'])},
      borderColor: ${recipes.reference(<String>['toast', 'border-color'], _RecipeType.color)},
      borderWidth: ${recipes.dimension(<String>['toast', 'border-width'])},
      dismissDuration: ${recipes.duration(<String>['toast', 'dismiss-duration-ms'])},
      errorBackgroundColor: ${recipes.reference(<String>['toast', 'error-background-color'], _RecipeType.color)},
      errorForegroundColor: ${recipes.reference(<String>['toast', 'error-foreground-color'], _RecipeType.color)},
      fontSize: ${recipes.dimension(<String>['toast', 'font-size'])},
      fontWeight: ${recipes.reference(<String>['toast', 'font-weight'], _RecipeType.fontWeight)},
      gap: ${recipes.dimension(<String>['toast', 'gap'])},
      maxWidth: ${recipes.dimension(<String>['toast', 'max-width'])},
      paddingHorizontal: ${recipes.dimension(<String>['toast', 'padding-horizontal'])},
      paddingVertical: ${recipes.dimension(<String>['toast', 'padding-vertical'])},
      radius: ${recipes.dimension(<String>['toast', 'radius'])},
      screenEdgeSpacing: ${recipes.dimension(<String>['toast', 'screen-edge-spacing'])},
      screenHorizontalInset: ${recipes.dimension(<String>['toast', 'screen-horizontal-inset'])},
      successBackgroundColor: ${recipes.reference(<String>['toast', 'success-background-color'], _RecipeType.color)},
      successForegroundColor: ${recipes.reference(<String>['toast', 'success-foreground-color'], _RecipeType.color)},
    ),
''';

  String _renderTooltipRecipe(_RecipeReader recipes) =>
      '''    tooltip: CharcoalTooltipTokens(
      animationDuration: ${recipes.duration(<String>['tooltip', 'animation-duration-ms'])},
      arrowHalfWidth: ${recipes.dimension(<String>['tooltip', 'arrow-half-width'])},
      arrowHeight: ${recipes.dimension(<String>['tooltip', 'arrow-height'])},
      backgroundColor: ${recipes.reference(<String>['tooltip', 'background-color'], _RecipeType.color)},
      fontSize: ${recipes.dimension(<String>['tooltip', 'font-size'])},
      fontWeight: ${recipes.reference(<String>['tooltip', 'font-weight'], _RecipeType.fontWeight)},
      foregroundColor: ${recipes.reference(<String>['tooltip', 'foreground-color'], _RecipeType.color)},
      gap: ${recipes.dimension(<String>['tooltip', 'gap'])},
      lineHeight: ${recipes.dimension(<String>['tooltip', 'line-height'])},
      maxWidth: ${recipes.dimension(<String>['tooltip', 'max-width'])},
      paddingHorizontal: ${recipes.dimension(<String>['tooltip', 'padding-horizontal'])},
      paddingVertical: ${recipes.dimension(<String>['tooltip', 'padding-vertical'])},
      radius: ${recipes.dimension(<String>['tooltip', 'radius'])},
      screenInset: ${recipes.dimension(<String>['tooltip', 'screen-inset'])},
    ),
''';

  String _renderCarouselRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    carousel: CharcoalCarouselTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['carousel', 'animation-duration-ms'])},',
      )
      ..writeln('      defaultGap: ${recipes.dimension(<String>['carousel', 'default-gap'])},')
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['carousel', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['carousel', 'focus-ring-width'])},',
      )
      ..writeln(
        '      indicatorActiveColor: ${recipes.reference(<String>['carousel', 'indicator-active-color'], _RecipeType.color)},',
      )
      ..writeln('      indicatorColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['carousel', 'indicator-color']);
    output.writeln('      ),');
    for (final field in <String>[
      'indicator-gap',
      'indicator-height',
      'indicator-radius',
      'indicator-size',
      'navigation-inset',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: ${recipes.dimension(<String>['carousel', field])},',
      );
    }
    output
      ..writeln(
        '      mediumViewportFraction: ${recipes.number(<String>['carousel', 'medium-viewport-fraction'], min: 0.1, max: 1)},',
      )
      ..writeln(
        '      scrollDuration: ${recipes.duration(<String>['carousel', 'scroll-duration-ms'])},',
      )
      ..writeln('    ),');
    return output.toString();
  }

  String _renderDropdownRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    dropdown: CharcoalDropdownTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['dropdown', 'animation-duration-ms'])},',
      )
      ..writeln(
        '      assistiveTextColor: ${recipes.reference(<String>['dropdown', 'assistive-text-color'], _RecipeType.color)},',
      )
      ..writeln('      background: CharcoalStateColors(');
    _writeStateColors(
      output,
      recipes,
      <String>['dropdown', 'background'],
      includeFocused: true,
      includeSelected: true,
    );
    output
      ..writeln('      ),')
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['dropdown', 'disabled-opacity'], min: 0, max: 1)},',
      );
    for (final field in <String>[
      'focus-ring-color',
      'foreground-color',
      'icon-color',
      'invalid-assistive-text-color',
      'invalid-ring-color',
      'menu-background-color',
      'menu-border-color',
      'option-check-color',
      'option-primary-color',
      'option-secondary-color',
      'placeholder-color',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: '
        '${recipes.reference(<String>['dropdown', field], _RecipeType.color)},',
      );
    }
    for (final field in <String>[
      'focus-ring-width',
      'font-size',
      'gap',
      'height',
      'icon-size',
      'icon-stroke-width',
      'line-height',
      'menu-border-width',
      'menu-gap',
      'menu-max-height',
      'menu-padding-vertical',
      'menu-radius',
      'option-check-width',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: ${recipes.dimension(<String>['dropdown', field])},',
      );
    }
    output.writeln('      optionBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['dropdown', 'option-background']);
    output
      ..writeln('      ),')
      ..writeln(
        '      optionDisabledOpacity: ${recipes.number(<String>['dropdown', 'option-disabled-opacity'], min: 0, max: 1)},',
      );
    for (final field in <String>[
      'option-gap',
      'option-min-height',
      'option-padding-horizontal',
      'option-secondary-font-size',
      'option-secondary-line-height',
      'padding-horizontal',
      'radius',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: ${recipes.dimension(<String>['dropdown', field])},',
      );
    }
    output
      ..writeln(
        '      fontWeight: ${recipes.reference(<String>['dropdown', 'font-weight'], _RecipeType.fontWeight)},',
      )
      ..writeln('    ),');
    return output.toString();
  }

  String _renderCheckboxRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    checkbox: CharcoalCheckboxTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['checkbox', 'animation-duration-ms'])},',
      )
      ..writeln('      borderColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['checkbox', 'border-color']);
    output
      ..writeln('      ),')
      ..writeln(
        '      borderWidth: ${recipes.dimension(<String>['checkbox', 'border-width'])},',
      )
      ..writeln('      checkedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['checkbox', 'checked-background']);
    output
      ..writeln('      ),')
      ..writeln('      checkColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['checkbox', 'check-color']);
    output
      ..writeln('      ),')
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['checkbox', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['checkbox', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['checkbox', 'focus-ring-width'])},',
      )
      ..writeln(
        '      invalidRingColor: ${recipes.reference(<String>['checkbox', 'invalid-ring-color'], _RecipeType.color)},',
      )
      ..write(_renderControlLabel(recipes, 'checkbox'))
      ..writeln('      radius: ${recipes.dimension(<String>['checkbox', 'radius'])},')
      ..writeln(
        '      roundedRadius: ${recipes.dimension(<String>['checkbox', 'rounded-radius'])},',
      )
      ..writeln('      size: ${recipes.dimension(<String>['checkbox', 'size'])},')
      ..writeln('      uncheckedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['checkbox', 'unchecked-background']);
    output
      ..writeln('      ),')
      ..writeln('    ),');
    return output.toString();
  }

  String _renderRadioRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    radio: CharcoalRadioTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['radio', 'animation-duration-ms'])},',
      )
      ..writeln('      borderColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['radio', 'border-color']);
    output
      ..writeln('      ),')
      ..writeln('      borderWidth: ${recipes.dimension(<String>['radio', 'border-width'])},')
      ..writeln('      checkedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['radio', 'checked-background']);
    output
      ..writeln('      ),')
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['radio', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln('      dotColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['radio', 'dot-color']);
    output
      ..writeln('      ),')
      ..writeln('      dotSize: ${recipes.dimension(<String>['radio', 'dot-size'])},')
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['radio', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['radio', 'focus-ring-width'])},',
      )
      ..writeln(
        '      invalidRingColor: ${recipes.reference(<String>['radio', 'invalid-ring-color'], _RecipeType.color)},',
      )
      ..write(_renderControlLabel(recipes, 'radio'))
      ..writeln('      radius: ${recipes.dimension(<String>['radio', 'radius'])},')
      ..writeln('      size: ${recipes.dimension(<String>['radio', 'size'])},')
      ..writeln('      uncheckedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['radio', 'unchecked-background']);
    output
      ..writeln('      ),')
      ..writeln('    ),');
    return output.toString();
  }

  String _renderIconButtonRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    iconButton: CharcoalIconButtonTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['icon-button', 'animation-duration-ms'])},',
      )
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['icon-button', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['icon-button', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['icon-button', 'focus-ring-width'])},',
      )
      ..writeln('      radius: ${recipes.dimension(<String>['icon-button', 'radius'])},');
    for (final size in <String>['extra-small', 'small', 'medium']) {
      output
        ..writeln('      ${tokenIdentifier(size)}: CharcoalIconButtonSizeTokens(')
        ..writeln(
          '        iconSize: ${recipes.dimension(<String>['icon-button', 'sizes', size, 'icon-size'])},',
        )
        ..writeln(
          '        size: ${recipes.dimension(<String>['icon-button', 'sizes', size, 'size'])},',
        )
        ..writeln('      ),');
    }
    for (final variant in <String>['default', 'overlay']) {
      final property = variant == 'default' ? 'normal' : variant;
      output
        ..writeln('      $property: CharcoalIconButtonVariantTokens(')
        ..writeln('        background: CharcoalStateColors(');
      _writeStateColors(
        output,
        recipes,
        <String>['icon-button', 'variants', variant, 'background'],
      );
      output
        ..writeln('        ),')
        ..writeln('        foreground: CharcoalStateColors(');
      _writeStateColors(
        output,
        recipes,
        <String>['icon-button', 'variants', variant, 'foreground'],
      );
      output
        ..writeln('        ),')
        ..writeln('      ),');
    }
    output.writeln('    ),');
    return output.toString();
  }

  String _renderLoadingSpinnerRecipe(_RecipeReader recipes) =>
      '''    loadingSpinner: CharcoalLoadingSpinnerTokens(
      animationDuration: ${recipes.duration(<String>['loading-spinner', 'animation-duration-ms'])},
      backgroundColor: ${recipes.reference(<String>['loading-spinner', 'background-color'], _RecipeType.color)},
      foregroundColor: ${recipes.reference(<String>['loading-spinner', 'foreground-color'], _RecipeType.color)},
      opacity: ${recipes.number(<String>['loading-spinner', 'opacity'], min: 0, max: 1)},
      padding: ${recipes.dimension(<String>['loading-spinner', 'padding'])},
      radius: ${recipes.dimension(<String>['loading-spinner', 'radius'])},
      shadowBlur: ${recipes.dimension(<String>['loading-spinner', 'shadow-blur'])},
      shadowOpacity: ${recipes.number(<String>['loading-spinner', 'shadow-opacity'], min: 0, max: 1)},
      size: ${recipes.dimension(<String>['loading-spinner', 'size'])},
    ),
''';

  String _renderMultiSelectRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    multiSelect: CharcoalMultiSelectTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['multi-select', 'animation-duration-ms'])},',
      )
      ..writeln('      checkedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['multi-select', 'checked-background']);
    output
      ..writeln('      ),')
      ..writeln('      checkColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['multi-select', 'check-color']);
    output
      ..writeln('      ),')
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['multi-select', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['multi-select', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['multi-select', 'focus-ring-width'])},',
      )
      ..writeln(
        '      invalidRingColor: ${recipes.reference(<String>['multi-select', 'invalid-ring-color'], _RecipeType.color)},',
      )
      ..write(_renderControlLabel(recipes, 'multi-select'))
      ..writeln(
        '      overlayBorderColor: ${recipes.reference(<String>['multi-select', 'overlay-border-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      overlayBorderWidth: ${recipes.dimension(<String>['multi-select', 'overlay-border-width'])},',
      )
      ..writeln('      overlayUncheckedBackground: CharcoalStateColors(');
    _writeStateColors(
      output,
      recipes,
      <String>['multi-select', 'overlay-unchecked-background'],
    );
    output
      ..writeln('      ),')
      ..writeln('      radius: ${recipes.dimension(<String>['multi-select', 'radius'])},')
      ..writeln('      size: ${recipes.dimension(<String>['multi-select', 'size'])},')
      ..writeln('      uncheckedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['multi-select', 'unchecked-background']);
    output
      ..writeln('      ),')
      ..writeln('    ),');
    return output.toString();
  }

  String _renderSwitchRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    switchControl: CharcoalSwitchTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['switch', 'animation-duration-ms'])},',
      )
      ..writeln('      borderWidth: ${recipes.dimension(<String>['switch', 'border-width'])},')
      ..writeln('      checkedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['switch', 'checked-background']);
    output
      ..writeln('      ),')
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['switch', 'disabled-opacity'], min: 0, max: 1)},',
      )
      ..writeln(
        '      focusRingColor: ${recipes.reference(<String>['switch', 'focus-ring-color'], _RecipeType.color)},',
      )
      ..writeln(
        '      focusRingWidth: ${recipes.dimension(<String>['switch', 'focus-ring-width'])},',
      )
      ..writeln('      height: ${recipes.dimension(<String>['switch', 'height'])},')
      ..write(_renderControlLabel(recipes, 'switch'))
      ..writeln('      radius: ${recipes.dimension(<String>['switch', 'radius'])},')
      ..writeln('      thumbColor: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['switch', 'thumb-color']);
    output
      ..writeln('      ),')
      ..writeln('      thumbSize: ${recipes.dimension(<String>['switch', 'thumb-size'])},')
      ..writeln('      uncheckedBackground: CharcoalStateColors(');
    _writeStateColors(output, recipes, <String>['switch', 'unchecked-background']);
    output
      ..writeln('      ),')
      ..writeln('      width: ${recipes.dimension(<String>['switch', 'width'])},')
      ..writeln('    ),');
    return output.toString();
  }

  String _renderTagItemRecipe(_RecipeReader recipes) {
    final output = StringBuffer()
      ..writeln('    tagItem: CharcoalTagItemTokens(')
      ..writeln(
        '      animationDuration: ${recipes.duration(<String>['tag-item', 'animation-duration-ms'])},',
      )
      ..writeln(
        '      disabledOpacity: ${recipes.number(<String>['tag-item', 'disabled-opacity'], min: 0, max: 1)},',
      );
    for (final field in <String>[
      'background-color',
      'focus-ring-color',
      'foreground-color',
      'icon-color',
      'image-background-color',
      'image-foreground-color',
      'image-icon-color',
      'inactive-background-color',
      'inactive-foreground-color',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: '
        '${recipes.reference(<String>['tag-item', field], _RecipeType.color)},',
      );
    }
    for (final field in <String>[
      'active-padding-left',
      'active-padding-right',
      'focus-ring-width',
      'gap',
      'icon-size',
      'icon-stroke-width',
      'label-font-size',
      'label-line-height',
      'max-label-width',
      'radius',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: ${recipes.dimension(<String>['tag-item', field])},',
      );
    }
    for (final size in <String>['small', 'medium']) {
      output
        ..writeln('      $size: CharcoalTagItemSizeTokens(')
        ..writeln(
          '        height: ${recipes.dimension(<String>['tag-item', 'sizes', size, 'height'])},',
        )
        ..writeln(
          '        paddingHorizontal: ${recipes.dimension(<String>['tag-item', 'sizes', size, 'padding-horizontal'])},',
        )
        ..writeln('      ),');
    }
    for (final field in <String>[
      'translated-font-size',
      'translated-label-font-size',
      'translated-label-line-height',
      'translated-line-height',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: ${recipes.dimension(<String>['tag-item', field])},',
      );
    }
    for (final field in <String>[
      'label-font-weight',
      'translated-font-weight',
      'translated-label-font-weight',
    ]) {
      output.writeln(
        '      ${tokenIdentifier(field)}: '
        '${recipes.reference(<String>['tag-item', field], _RecipeType.fontWeight)},',
      );
    }
    output.writeln('    ),');
    return output.toString();
  }

  String _renderControlLabel(_RecipeReader recipes, String component) =>
      '''      label: CharcoalControlLabelTokens(
        color: ${recipes.reference(<String>[component, 'label-color'], _RecipeType.color)},
        fontSize: ${recipes.dimension(<String>[component, 'label-font-size'])},
        fontWeight: ${recipes.reference(<String>[component, 'label-font-weight'], _RecipeType.fontWeight)},
        gap: ${recipes.dimension(<String>[component, 'label-gap'])},
        lineHeight: ${recipes.dimension(<String>[component, 'label-line-height'])},
      ),
''';

  void _writeStateColors(
    StringBuffer output,
    _RecipeReader recipes,
    List<String> path, {
    bool includeFocused = false,
    bool includeSelected = false,
  }) {
    for (final state in <String>['normal', 'hovered', 'pressed', 'disabled']) {
      output.writeln(
        '          $state: ${recipes.reference(<String>[...path, state], _RecipeType.color)},',
      );
    }
    if (includeFocused) {
      output.writeln(
        '          focused: ${recipes.reference(<String>[...path, 'focused'], _RecipeType.color)},',
      );
    }
    if (includeSelected) {
      output.writeln(
        '          selected: ${recipes.reference(<String>[...path, 'selected'], _RecipeType.color)},',
      );
    }
  }
}

enum _RecipeType { color, dimension, fontWeight }

final class _RecipeReader {
  _RecipeReader(this.root, this.bundle);

  final Map<String, dynamic> root;
  final TokenBundle bundle;
  final Set<String> _consumedPaths = <String>{};

  String duration(List<String> path) {
    final value = _read(path);
    if (value is! num || value < 0 || value != value.roundToDouble()) {
      throw TokenGenerationException('${_path(path)} must be a non-negative integer duration.');
    }
    return 'Duration(milliseconds: ${value.toInt()})';
  }

  String number(List<String> path, {required double min, required double max}) {
    final value = _read(path);
    if (value is! num || value < min || value > max) {
      throw TokenGenerationException('${_path(path)} must be between $min and $max.');
    }
    return _doubleExpression(value.toDouble());
  }

  String dimension(List<String> path) {
    final value = _read(path);
    if (TokenReference.tryParse(value) != null) {
      return reference(path, _RecipeType.dimension);
    }
    return _doubleExpression(parsePixels(value, path: _path(path)));
  }

  String reference(List<String> path, _RecipeType expectedType) {
    final value = _read(path);
    final reference = TokenReference.tryParse(value);
    if (reference == null) {
      throw TokenGenerationException('${_path(path)} must be a token reference, got "$value".');
    }
    final lightValue = bundle.light[reference.category]?[reference.key];
    final darkValue = bundle.dark[reference.category]?[reference.key];
    if (lightValue == null || darkValue == null) {
      throw TokenGenerationException(
        '${_path(path)} references missing token {${reference.path}}.',
      );
    }

    switch (expectedType) {
      case _RecipeType.color:
        if (reference.category != 'color' ||
            !bundle.lightApplied['color']!.containsKey(reference.key)) {
          throw TokenGenerationException(
            '${_path(path)} must reference a semantic color, got {${reference.path}}.',
          );
        }
        return 'colors.${tokenIdentifier(reference.key)}';
      case _RecipeType.dimension:
        if (!<String>{'border-width', 'paragraph-width', 'radius', 'space'}.contains(
          reference.category,
        )) {
          if (reference.category == 'text' &&
              (reference.key.startsWith('font-size/') ||
                  reference.key.startsWith('line-height/'))) {
            final separator = reference.key.indexOf('/');
            final group = reference.key.substring(0, separator);
            final key = reference.key.substring(separator + 1);
            return 'typography.${tokenIdentifier(group)}.${tokenIdentifier(key)}';
          }
          throw TokenGenerationException(
            '${_path(path)} must reference a dimension, got {${reference.path}}.',
          );
        }
        if (!bundle.lightApplied[reference.category]!.containsKey(reference.key)) {
          throw TokenGenerationException(
            '${_path(path)} must reference an applied dimension, got {${reference.path}}.',
          );
        }
        return 'dimensions.${tokenIdentifier(reference.category)}.${tokenIdentifier(reference.key)}';
      case _RecipeType.fontWeight:
        if (reference.category != 'text' || !reference.key.startsWith('font-weight/')) {
          throw TokenGenerationException(
            '${_path(path)} must reference a font weight, got {${reference.path}}.',
          );
        }
        return 'typography.fontWeight.${tokenIdentifier(reference.key.substring('font-weight/'.length))}';
    }
  }

  void assertAllRecipesConsumed() {
    final unknown = root.keys.where(
      (key) => !<String>{
        r'$schema',
        'balloon',
        'button',
        'carousel',
        'checkbox',
        'dropdown',
        'hint',
        'icon-button',
        'link-button',
        'loading-spinner',
        'modal',
        'multi-select',
        'numeric-typography',
        'radio',
        'snackbar',
        'switch',
        'tag-item',
        'text-field',
        'toast',
        'tooltip',
      }.contains(key),
    );
    if (unknown.isNotEmpty) {
      throw TokenGenerationException('Unknown component recipe keys: ${unknown.join(', ')}.');
    }
    final leafPaths = <String>{};
    _collectLeafPaths(root, <String>[], leafPaths);
    leafPaths.remove(r'$schema');
    final unconsumed = leafPaths.difference(_consumedPaths).toList()..sort();
    if (unconsumed.isNotEmpty) {
      throw TokenGenerationException(
        'Unconsumed component recipe values: ${unconsumed.join(', ')}.',
      );
    }
  }

  Object _read(List<String> path) {
    Object? current = root;
    for (final segment in path) {
      if (current is! Map<String, dynamic> || !current.containsKey(segment)) {
        throw TokenGenerationException('Missing component recipe ${_path(path)}.');
      }
      current = current[segment];
    }
    if (current == null) {
      throw TokenGenerationException('Component recipe ${_path(path)} cannot be null.');
    }
    _consumedPaths.add(_path(path));
    return current;
  }

  String _path(List<String> path) => path.join('.');

  void _collectLeafPaths(Object? value, List<String> path, Set<String> output) {
    if (value is Map<String, dynamic>) {
      for (final entry in value.entries) {
        _collectLeafPaths(entry.value, <String>[...path, entry.key], output);
      }
      return;
    }
    output.add(_path(path));
  }
}

Map<String, dynamic> decodeComponentRecipes(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map<String, dynamic>) {
    throw const TokenGenerationException('tokens/components.json must contain a JSON object.');
  }
  return decoded;
}

List<String> _keys(TokenTree tree, String category) {
  final values = tree[category];
  if (values == null) {
    throw TokenGenerationException('Missing required token category $category.');
  }
  return values.keys.toList()..sort();
}

void _validateIdentifiers(List<String> keys, {required String context}) {
  final identifiers = <String, String>{};
  for (final key in keys) {
    final identifier = tokenIdentifier(key);
    final previous = identifiers[identifier];
    if (previous != null) {
      throw TokenGenerationException(
        '$context tokens "$previous" and "$key" both map to Dart identifier "$identifier".',
      );
    }
    identifiers[identifier] = key;
  }
}

String tokenIdentifier(String tokenKey) {
  final withMinusNames = tokenKey.replaceAllMapped(
    RegExp(r'(^|/)-(\d)'),
    (match) => '${match.group(1)}minus-${match.group(2)}',
  );
  final parts = withMinusNames.split(RegExp('[^A-Za-z0-9]+')).where((part) => part.isNotEmpty);
  if (parts.isEmpty) {
    throw TokenGenerationException('Cannot create a Dart identifier from token key "$tokenKey".');
  }
  final list = parts.toList();
  var identifier = _lowerCamel(list.first);
  for (final part in list.skip(1)) {
    identifier += _upperCamel(part);
  }
  if (RegExp(r'^\d').hasMatch(identifier)) {
    identifier = 'value$identifier';
  }
  if (_dartKeywords.contains(identifier)) {
    identifier = '${identifier}Value';
  }
  return identifier;
}

String _lowerCamel(String value) {
  if (value.isEmpty) {
    return value;
  }
  return '${value.substring(0, 1).toLowerCase()}${value.substring(1)}';
}

String _upperCamel(String value) {
  if (value.isEmpty) {
    return value;
  }
  return '${value.substring(0, 1).toUpperCase()}${value.substring(1).toLowerCase()}';
}

String _colorExpression(Object value, {required String path}) {
  final rgba = parseRgba(value, path: path);
  final argb = (rgba.alpha << 24) | (rgba.red << 16) | (rgba.green << 8) | rgba.blue;
  return 'Color(0x${argb.toRadixString(16).padLeft(8, '0').toUpperCase()})';
}

String _doubleExpression(double value) {
  if (value == value.roundToDouble()) {
    return '${value.toInt()}.0';
  }
  return value.toString();
}

String _stringExpression(Object value, {required String path}) {
  if (value is! String) {
    throw TokenGenerationException('$path must be a string.');
  }
  return "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";
}

const _generatedHeader = '''// GENERATED CODE - DO NOT MODIFY BY HAND.
// Generated from Charcoal V2 tokens by `dart run tool/tokens.dart generate`.
''';

const _dartKeywords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'type',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};
