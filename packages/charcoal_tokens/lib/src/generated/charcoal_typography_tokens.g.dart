// GENERATED CODE - DO NOT MODIFY BY HAND.
// Generated from Charcoal V2 tokens by `dart run tool/tokens.dart generate`.

import 'dart:ui' show FontWeight;

/// One named typography value exposed for catalogs and tooling.
final class CharcoalTypographyTokenEntry<T> {
  const CharcoalTypographyTokenEntry({required this.path, required this.value});

  final String path;
  final T value;
}

/// `{text.font-family/*}` tokens.
final class CharcoalFontFamilyTokens {
  const CharcoalFontFamilyTokens({
    required this.sans,
  });

  /// `{text.font-family/sans}`
  final String sans;

  CharcoalFontFamilyTokens copyWith({
    String? sans,
  }) => CharcoalFontFamilyTokens(
    sans: sans ?? this.sans,
  );
}

/// Enumerates `text.font-family` values without reflection.
extension CharcoalFontFamilyTokensCatalog on CharcoalFontFamilyTokens {
  List<CharcoalTypographyTokenEntry<String>> get entries => <CharcoalTypographyTokenEntry<String>>[
    CharcoalTypographyTokenEntry<String>(path: 'text.font-family/sans', value: sans),
  ];
}

/// `{text.font-size/*}` tokens.
final class CharcoalFontSizeTokens {
  const CharcoalFontSizeTokens({
    required this.body,
    required this.captionM,
    required this.captionS,
    required this.headingL,
    required this.headingM,
    required this.headingS,
    required this.headingXl,
    required this.headingXs,
    required this.headingXxl,
    required this.headingXxs,
    required this.headingXxxl,
    required this.headingXxxs,
    required this.paragraph,
  });

  /// `{text.font-size/body}`
  final double body;

  /// `{text.font-size/caption/m}`
  final double captionM;

  /// `{text.font-size/caption/s}`
  final double captionS;

  /// `{text.font-size/heading/l}`
  final double headingL;

  /// `{text.font-size/heading/m}`
  final double headingM;

  /// `{text.font-size/heading/s}`
  final double headingS;

  /// `{text.font-size/heading/xl}`
  final double headingXl;

  /// `{text.font-size/heading/xs}`
  final double headingXs;

  /// `{text.font-size/heading/xxl}`
  final double headingXxl;

  /// `{text.font-size/heading/xxs}`
  final double headingXxs;

  /// `{text.font-size/heading/xxxl}`
  final double headingXxxl;

  /// `{text.font-size/heading/xxxs}`
  final double headingXxxs;

  /// `{text.font-size/paragraph}`
  final double paragraph;

  CharcoalFontSizeTokens copyWith({
    double? body,
    double? captionM,
    double? captionS,
    double? headingL,
    double? headingM,
    double? headingS,
    double? headingXl,
    double? headingXs,
    double? headingXxl,
    double? headingXxs,
    double? headingXxxl,
    double? headingXxxs,
    double? paragraph,
  }) => CharcoalFontSizeTokens(
    body: body ?? this.body,
    captionM: captionM ?? this.captionM,
    captionS: captionS ?? this.captionS,
    headingL: headingL ?? this.headingL,
    headingM: headingM ?? this.headingM,
    headingS: headingS ?? this.headingS,
    headingXl: headingXl ?? this.headingXl,
    headingXs: headingXs ?? this.headingXs,
    headingXxl: headingXxl ?? this.headingXxl,
    headingXxs: headingXxs ?? this.headingXxs,
    headingXxxl: headingXxxl ?? this.headingXxxl,
    headingXxxs: headingXxxs ?? this.headingXxxs,
    paragraph: paragraph ?? this.paragraph,
  );
}

/// Enumerates `text.font-size` values without reflection.
extension CharcoalFontSizeTokensCatalog on CharcoalFontSizeTokens {
  List<CharcoalTypographyTokenEntry<double>> get entries => <CharcoalTypographyTokenEntry<double>>[
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/body', value: body),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/caption/m', value: captionM),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/caption/s', value: captionS),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/l', value: headingL),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/m', value: headingM),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/s', value: headingS),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/xl', value: headingXl),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/xs', value: headingXs),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/xxl', value: headingXxl),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/xxs', value: headingXxs),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/xxxl', value: headingXxxl),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/heading/xxxs', value: headingXxxs),
    CharcoalTypographyTokenEntry<double>(path: 'text.font-size/paragraph', value: paragraph),
  ];
}

/// `{text.font-weight/*}` tokens.
final class CharcoalFontWeightTokens {
  const CharcoalFontWeightTokens({
    required this.bold,
    required this.regular,
  });

  /// `{text.font-weight/bold}`
  final FontWeight bold;

  /// `{text.font-weight/regular}`
  final FontWeight regular;

  CharcoalFontWeightTokens copyWith({
    FontWeight? bold,
    FontWeight? regular,
  }) => CharcoalFontWeightTokens(
    bold: bold ?? this.bold,
    regular: regular ?? this.regular,
  );
}

/// Enumerates `text.font-weight` values without reflection.
extension CharcoalFontWeightTokensCatalog on CharcoalFontWeightTokens {
  List<CharcoalTypographyTokenEntry<FontWeight>> get entries =>
      <CharcoalTypographyTokenEntry<FontWeight>>[
        CharcoalTypographyTokenEntry<FontWeight>(path: 'text.font-weight/bold', value: bold),
        CharcoalTypographyTokenEntry<FontWeight>(path: 'text.font-weight/regular', value: regular),
      ];
}

/// `{text.line-height/*}` tokens.
final class CharcoalLineHeightTokens {
  const CharcoalLineHeightTokens({
    required this.body,
    required this.captionM,
    required this.captionS,
    required this.headingL,
    required this.headingM,
    required this.headingS,
    required this.headingXl,
    required this.headingXs,
    required this.headingXxl,
    required this.headingXxs,
    required this.headingXxxl,
    required this.headingXxxs,
    required this.paragraph,
  });

  /// `{text.line-height/body}`
  final double body;

  /// `{text.line-height/caption/m}`
  final double captionM;

  /// `{text.line-height/caption/s}`
  final double captionS;

  /// `{text.line-height/heading/l}`
  final double headingL;

  /// `{text.line-height/heading/m}`
  final double headingM;

  /// `{text.line-height/heading/s}`
  final double headingS;

  /// `{text.line-height/heading/xl}`
  final double headingXl;

  /// `{text.line-height/heading/xs}`
  final double headingXs;

  /// `{text.line-height/heading/xxl}`
  final double headingXxl;

  /// `{text.line-height/heading/xxs}`
  final double headingXxs;

  /// `{text.line-height/heading/xxxl}`
  final double headingXxxl;

  /// `{text.line-height/heading/xxxs}`
  final double headingXxxs;

  /// `{text.line-height/paragraph}`
  final double paragraph;

  CharcoalLineHeightTokens copyWith({
    double? body,
    double? captionM,
    double? captionS,
    double? headingL,
    double? headingM,
    double? headingS,
    double? headingXl,
    double? headingXs,
    double? headingXxl,
    double? headingXxs,
    double? headingXxxl,
    double? headingXxxs,
    double? paragraph,
  }) => CharcoalLineHeightTokens(
    body: body ?? this.body,
    captionM: captionM ?? this.captionM,
    captionS: captionS ?? this.captionS,
    headingL: headingL ?? this.headingL,
    headingM: headingM ?? this.headingM,
    headingS: headingS ?? this.headingS,
    headingXl: headingXl ?? this.headingXl,
    headingXs: headingXs ?? this.headingXs,
    headingXxl: headingXxl ?? this.headingXxl,
    headingXxs: headingXxs ?? this.headingXxs,
    headingXxxl: headingXxxl ?? this.headingXxxl,
    headingXxxs: headingXxxs ?? this.headingXxxs,
    paragraph: paragraph ?? this.paragraph,
  );
}

/// Enumerates `text.line-height` values without reflection.
extension CharcoalLineHeightTokensCatalog on CharcoalLineHeightTokens {
  List<CharcoalTypographyTokenEntry<double>> get entries => <CharcoalTypographyTokenEntry<double>>[
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/body', value: body),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/caption/m', value: captionM),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/caption/s', value: captionS),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/l', value: headingL),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/m', value: headingM),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/s', value: headingS),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/xl', value: headingXl),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/xs', value: headingXs),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/xxl', value: headingXxl),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/xxs', value: headingXxs),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/xxxl', value: headingXxxl),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/heading/xxxs', value: headingXxxs),
    CharcoalTypographyTokenEntry<double>(path: 'text.line-height/paragraph', value: paragraph),
  ];
}

/// All generated typography tokens for one brightness mode.
final class CharcoalTypographyTokens {
  const CharcoalTypographyTokens({
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
  });

  final CharcoalFontFamilyTokens fontFamily;
  final CharcoalFontSizeTokens fontSize;
  final CharcoalFontWeightTokens fontWeight;
  final CharcoalLineHeightTokens lineHeight;

  CharcoalTypographyTokens copyWith({
    CharcoalFontFamilyTokens? fontFamily,
    CharcoalFontSizeTokens? fontSize,
    CharcoalFontWeightTokens? fontWeight,
    CharcoalLineHeightTokens? lineHeight,
  }) => CharcoalTypographyTokens(
    fontFamily: fontFamily ?? this.fontFamily,
    fontSize: fontSize ?? this.fontSize,
    fontWeight: fontWeight ?? this.fontWeight,
    lineHeight: lineHeight ?? this.lineHeight,
  );
}

/// Generated light and dark typography. Do not edit by hand.
abstract final class CharcoalGeneratedTypographyTokens {
  static const CharcoalTypographyTokens light = CharcoalTypographyTokens(
    fontFamily: CharcoalFontFamilyTokens(
      sans: 'Sarasa UI J',
    ),
    fontSize: CharcoalFontSizeTokens(
      body: 16.0,
      captionM: 14.0,
      captionS: 12.0,
      headingL: 28.0,
      headingM: 25.0,
      headingS: 22.0,
      headingXl: 32.0,
      headingXs: 20.0,
      headingXxl: 36.0,
      headingXxs: 18.0,
      headingXxxl: 40.0,
      headingXxxs: 14.0,
      paragraph: 16.0,
    ),
    fontWeight: CharcoalFontWeightTokens(
      bold: FontWeight.w700,
      regular: FontWeight.w400,
    ),
    lineHeight: CharcoalLineHeightTokens(
      body: 24.0,
      captionM: 20.0,
      captionS: 18.0,
      headingL: 36.0,
      headingM: 32.0,
      headingS: 28.0,
      headingXl: 40.0,
      headingXs: 28.0,
      headingXxl: 44.0,
      headingXxs: 24.0,
      headingXxxl: 52.0,
      headingXxxs: 20.0,
      paragraph: 28.0,
    ),
  );

  static const CharcoalTypographyTokens dark = CharcoalTypographyTokens(
    fontFamily: CharcoalFontFamilyTokens(
      sans: 'Sarasa UI J',
    ),
    fontSize: CharcoalFontSizeTokens(
      body: 16.0,
      captionM: 14.0,
      captionS: 12.0,
      headingL: 28.0,
      headingM: 25.0,
      headingS: 22.0,
      headingXl: 32.0,
      headingXs: 20.0,
      headingXxl: 36.0,
      headingXxs: 18.0,
      headingXxxl: 40.0,
      headingXxxs: 14.0,
      paragraph: 16.0,
    ),
    fontWeight: CharcoalFontWeightTokens(
      bold: FontWeight.w700,
      regular: FontWeight.w400,
    ),
    lineHeight: CharcoalLineHeightTokens(
      body: 24.0,
      captionM: 20.0,
      captionS: 18.0,
      headingL: 36.0,
      headingM: 32.0,
      headingS: 28.0,
      headingXl: 40.0,
      headingXs: 28.0,
      headingXxl: 44.0,
      headingXxs: 24.0,
      headingXxxl: 52.0,
      headingXxxs: 20.0,
      paragraph: 28.0,
    ),
  );
}
