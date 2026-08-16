import 'dart_source.dart';
import 'token_model.dart';

final class GeneratedArtifact {
  const GeneratedArtifact({required this.relativePath, required this.contents});

  final String relativePath;
  final String contents;
}

/// Generates only the public Charcoal foundation token APIs.
final class DartTokenGenerator {
  DartTokenGenerator({required this.bundle});

  final TokenBundle bundle;

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
        '    CharcoalColorTokenEntry('
        'path: ${dartStringLiteral('color.$key')}, value: ${tokenIdentifier(key)}),',
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
        '    CharcoalColorTokenEntry('
        'path: ${dartStringLiteral('color.$key')}, value: ${tokenIdentifier(key)}),',
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
        '    CharcoalColorTokenEntry('
        'path: ${dartStringLiteral('brand-color.$key')}, value: ${tokenIdentifier(key)}),',
      );
    }
    output
      ..writeln('  ];')
      ..writeln('}')
      ..writeln();
    return output.toString();
  }

  void _writeColorAssignments(
    StringBuffer output,
    List<String> keys,
    Map<String, Object> values,
  ) {
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
      ..writeln()
      ..writeln('  CharcoalDimensionTokens copyWith({')
      ..writeln('    CharcoalBorderWidthTokens? borderWidth,')
      ..writeln('    CharcoalParagraphWidthTokens? paragraphWidth,')
      ..writeln('    CharcoalRadiusTokens? radius,')
      ..writeln('    CharcoalSpaceTokens? space,')
      ..writeln('  }) => CharcoalDimensionTokens(')
      ..writeln('    borderWidth: borderWidth ?? this.borderWidth,')
      ..writeln('    paragraphWidth: paragraphWidth ?? this.paragraphWidth,')
      ..writeln('    radius: radius ?? this.radius,')
      ..writeln('    space: space ?? this.space,')
      ..writeln('  );')
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
        '    CharcoalDimensionTokenEntry('
        'path: ${dartStringLiteral('$category.$key')}, value: ${tokenIdentifier(key)}),',
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
      ..writeln()
      ..writeln('  CharcoalTypographyTokens copyWith({')
      ..writeln('    CharcoalFontFamilyTokens? fontFamily,')
      ..writeln('    CharcoalFontSizeTokens? fontSize,')
      ..writeln('    CharcoalFontWeightTokens? fontWeight,')
      ..writeln('    CharcoalLineHeightTokens? lineHeight,')
      ..writeln('  }) => CharcoalTypographyTokens(')
      ..writeln('    fontFamily: fontFamily ?? this.fontFamily,')
      ..writeln('    fontSize: fontSize ?? this.fontSize,')
      ..writeln('    fontWeight: fontWeight ?? this.fontWeight,')
      ..writeln('    lineHeight: lineHeight ?? this.lineHeight,')
      ..writeln('  );')
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
        '    CharcoalTypographyTokenEntry<$dartType>('
        'path: ${dartStringLiteral('text.$category/$key')}, '
        'value: ${tokenIdentifier(key)}),',
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
  if (value.isEmpty) return value;
  return '${value.substring(0, 1).toLowerCase()}${value.substring(1)}';
}

String _upperCamel(String value) {
  if (value.isEmpty) return value;
  return '${value.substring(0, 1).toUpperCase()}${value.substring(1).toLowerCase()}';
}

String _colorExpression(Object value, {required String path}) {
  final rgba = parseRgba(value, path: path);
  final argb = (rgba.alpha << 24) | (rgba.red << 16) | (rgba.green << 8) | rgba.blue;
  return 'Color(0x${argb.toRadixString(16).padLeft(8, '0').toUpperCase()})';
}

String _doubleExpression(double value) {
  if (value == value.roundToDouble()) return '${value.toInt()}.0';
  return value.toString();
}

String _stringExpression(Object value, {required String path}) {
  if (value is! String) {
    throw TokenGenerationException('$path must be a string.');
  }
  return dartStringLiteral(value);
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
