// GENERATED CODE - DO NOT MODIFY BY HAND.
// Generated from Charcoal V2 tokens by `dart run tool/tokens.dart generate`.

/// One named logical-pixel value exposed for catalogs and tooling.
final class CharcoalDimensionTokenEntry {
  const CharcoalDimensionTokenEntry({required this.path, required this.value});

  final String path;
  final double value;
}

/// `{border-width.*}` tokens.
final class CharcoalBorderWidthTokens {
  const CharcoalBorderWidthTokens({
    required this.focus1,
    required this.focus2,
    required this.l,
    required this.m,
  });

  /// `{border-width.focus/1}` in logical pixels.
  final double focus1;

  /// `{border-width.focus/2}` in logical pixels.
  final double focus2;

  /// `{border-width.l}` in logical pixels.
  final double l;

  /// `{border-width.m}` in logical pixels.
  final double m;

  CharcoalBorderWidthTokens copyWith({
    double? focus1,
    double? focus2,
    double? l,
    double? m,
  }) => CharcoalBorderWidthTokens(
    focus1: focus1 ?? this.focus1,
    focus2: focus2 ?? this.focus2,
    l: l ?? this.l,
    m: m ?? this.m,
  );
}

/// Enumerates `border-width` values without reflection.
extension CharcoalBorderWidthTokensCatalog on CharcoalBorderWidthTokens {
  List<CharcoalDimensionTokenEntry> get entries => <CharcoalDimensionTokenEntry>[
    CharcoalDimensionTokenEntry(path: 'border-width.focus/1', value: focus1),
    CharcoalDimensionTokenEntry(path: 'border-width.focus/2', value: focus2),
    CharcoalDimensionTokenEntry(path: 'border-width.l', value: l),
    CharcoalDimensionTokenEntry(path: 'border-width.m', value: m),
  ];
}

/// `{paragraph-width.*}` tokens.
final class CharcoalParagraphWidthTokens {
  const CharcoalParagraphWidthTokens({
    required this.l,
    required this.lCompact,
    required this.lCozy,
    required this.m,
    required this.mCompact,
    required this.mCozy,
    required this.s,
    required this.sCompact,
    required this.sCozy,
  });

  /// `{paragraph-width.l}` in logical pixels.
  final double l;

  /// `{paragraph-width.l-compact}` in logical pixels.
  final double lCompact;

  /// `{paragraph-width.l-cozy}` in logical pixels.
  final double lCozy;

  /// `{paragraph-width.m}` in logical pixels.
  final double m;

  /// `{paragraph-width.m-compact}` in logical pixels.
  final double mCompact;

  /// `{paragraph-width.m-cozy}` in logical pixels.
  final double mCozy;

  /// `{paragraph-width.s}` in logical pixels.
  final double s;

  /// `{paragraph-width.s-compact}` in logical pixels.
  final double sCompact;

  /// `{paragraph-width.s-cozy}` in logical pixels.
  final double sCozy;

  CharcoalParagraphWidthTokens copyWith({
    double? l,
    double? lCompact,
    double? lCozy,
    double? m,
    double? mCompact,
    double? mCozy,
    double? s,
    double? sCompact,
    double? sCozy,
  }) => CharcoalParagraphWidthTokens(
    l: l ?? this.l,
    lCompact: lCompact ?? this.lCompact,
    lCozy: lCozy ?? this.lCozy,
    m: m ?? this.m,
    mCompact: mCompact ?? this.mCompact,
    mCozy: mCozy ?? this.mCozy,
    s: s ?? this.s,
    sCompact: sCompact ?? this.sCompact,
    sCozy: sCozy ?? this.sCozy,
  );
}

/// Enumerates `paragraph-width` values without reflection.
extension CharcoalParagraphWidthTokensCatalog on CharcoalParagraphWidthTokens {
  List<CharcoalDimensionTokenEntry> get entries => <CharcoalDimensionTokenEntry>[
    CharcoalDimensionTokenEntry(path: 'paragraph-width.l', value: l),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.l-compact', value: lCompact),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.l-cozy', value: lCozy),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.m', value: m),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.m-compact', value: mCompact),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.m-cozy', value: mCozy),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.s', value: s),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.s-compact', value: sCompact),
    CharcoalDimensionTokenEntry(path: 'paragraph-width.s-cozy', value: sCozy),
  ];
}

/// `{radius.*}` tokens.
final class CharcoalRadiusTokens {
  const CharcoalRadiusTokens({
    required this.value0,
    required this.l,
    required this.m,
    required this.oval,
    required this.s,
    required this.xl,
    required this.xs,
    required this.xxl,
  });

  /// `{radius.0}` in logical pixels.
  final double value0;

  /// `{radius.l}` in logical pixels.
  final double l;

  /// `{radius.m}` in logical pixels.
  final double m;

  /// `{radius.oval}` in logical pixels.
  final double oval;

  /// `{radius.s}` in logical pixels.
  final double s;

  /// `{radius.xl}` in logical pixels.
  final double xl;

  /// `{radius.xs}` in logical pixels.
  final double xs;

  /// `{radius.xxl}` in logical pixels.
  final double xxl;

  CharcoalRadiusTokens copyWith({
    double? value0,
    double? l,
    double? m,
    double? oval,
    double? s,
    double? xl,
    double? xs,
    double? xxl,
  }) => CharcoalRadiusTokens(
    value0: value0 ?? this.value0,
    l: l ?? this.l,
    m: m ?? this.m,
    oval: oval ?? this.oval,
    s: s ?? this.s,
    xl: xl ?? this.xl,
    xs: xs ?? this.xs,
    xxl: xxl ?? this.xxl,
  );
}

/// Enumerates `radius` values without reflection.
extension CharcoalRadiusTokensCatalog on CharcoalRadiusTokens {
  List<CharcoalDimensionTokenEntry> get entries => <CharcoalDimensionTokenEntry>[
    CharcoalDimensionTokenEntry(path: 'radius.0', value: value0),
    CharcoalDimensionTokenEntry(path: 'radius.l', value: l),
    CharcoalDimensionTokenEntry(path: 'radius.m', value: m),
    CharcoalDimensionTokenEntry(path: 'radius.oval', value: oval),
    CharcoalDimensionTokenEntry(path: 'radius.s', value: s),
    CharcoalDimensionTokenEntry(path: 'radius.xl', value: xl),
    CharcoalDimensionTokenEntry(path: 'radius.xs', value: xs),
    CharcoalDimensionTokenEntry(path: 'radius.xxl', value: xxl),
  ];
}

/// `{space.*}` tokens.
final class CharcoalSpaceTokens {
  const CharcoalSpaceTokens({
    required this.component0,
    required this.component10,
    required this.component20,
    required this.component25,
    required this.component30,
    required this.component40,
    required this.component50,
    required this.layout0,
    required this.layout10,
    required this.layout100,
    required this.layout20,
    required this.layout25,
    required this.layout30,
    required this.layout40,
    required this.layout50,
    required this.layout60,
    required this.layout70,
    required this.layout80,
    required this.layout90,
    required this.paddingPaddingCard,
    required this.targetL,
    required this.targetM,
    required this.targetS,
    required this.targetXs,
  });

  /// `{space.component/0}` in logical pixels.
  final double component0;

  /// `{space.component/10}` in logical pixels.
  final double component10;

  /// `{space.component/20}` in logical pixels.
  final double component20;

  /// `{space.component/25}` in logical pixels.
  final double component25;

  /// `{space.component/30}` in logical pixels.
  final double component30;

  /// `{space.component/40}` in logical pixels.
  final double component40;

  /// `{space.component/50}` in logical pixels.
  final double component50;

  /// `{space.layout/0}` in logical pixels.
  final double layout0;

  /// `{space.layout/10}` in logical pixels.
  final double layout10;

  /// `{space.layout/100}` in logical pixels.
  final double layout100;

  /// `{space.layout/20}` in logical pixels.
  final double layout20;

  /// `{space.layout/25}` in logical pixels.
  final double layout25;

  /// `{space.layout/30}` in logical pixels.
  final double layout30;

  /// `{space.layout/40}` in logical pixels.
  final double layout40;

  /// `{space.layout/50}` in logical pixels.
  final double layout50;

  /// `{space.layout/60}` in logical pixels.
  final double layout60;

  /// `{space.layout/70}` in logical pixels.
  final double layout70;

  /// `{space.layout/80}` in logical pixels.
  final double layout80;

  /// `{space.layout/90}` in logical pixels.
  final double layout90;

  /// `{space.padding/padding-card}` in logical pixels.
  final double paddingPaddingCard;

  /// `{space.target/l}` in logical pixels.
  final double targetL;

  /// `{space.target/m}` in logical pixels.
  final double targetM;

  /// `{space.target/s}` in logical pixels.
  final double targetS;

  /// `{space.target/xs}` in logical pixels.
  final double targetXs;

  CharcoalSpaceTokens copyWith({
    double? component0,
    double? component10,
    double? component20,
    double? component25,
    double? component30,
    double? component40,
    double? component50,
    double? layout0,
    double? layout10,
    double? layout100,
    double? layout20,
    double? layout25,
    double? layout30,
    double? layout40,
    double? layout50,
    double? layout60,
    double? layout70,
    double? layout80,
    double? layout90,
    double? paddingPaddingCard,
    double? targetL,
    double? targetM,
    double? targetS,
    double? targetXs,
  }) => CharcoalSpaceTokens(
    component0: component0 ?? this.component0,
    component10: component10 ?? this.component10,
    component20: component20 ?? this.component20,
    component25: component25 ?? this.component25,
    component30: component30 ?? this.component30,
    component40: component40 ?? this.component40,
    component50: component50 ?? this.component50,
    layout0: layout0 ?? this.layout0,
    layout10: layout10 ?? this.layout10,
    layout100: layout100 ?? this.layout100,
    layout20: layout20 ?? this.layout20,
    layout25: layout25 ?? this.layout25,
    layout30: layout30 ?? this.layout30,
    layout40: layout40 ?? this.layout40,
    layout50: layout50 ?? this.layout50,
    layout60: layout60 ?? this.layout60,
    layout70: layout70 ?? this.layout70,
    layout80: layout80 ?? this.layout80,
    layout90: layout90 ?? this.layout90,
    paddingPaddingCard: paddingPaddingCard ?? this.paddingPaddingCard,
    targetL: targetL ?? this.targetL,
    targetM: targetM ?? this.targetM,
    targetS: targetS ?? this.targetS,
    targetXs: targetXs ?? this.targetXs,
  );
}

/// Enumerates `space` values without reflection.
extension CharcoalSpaceTokensCatalog on CharcoalSpaceTokens {
  List<CharcoalDimensionTokenEntry> get entries => <CharcoalDimensionTokenEntry>[
    CharcoalDimensionTokenEntry(path: 'space.component/0', value: component0),
    CharcoalDimensionTokenEntry(path: 'space.component/10', value: component10),
    CharcoalDimensionTokenEntry(path: 'space.component/20', value: component20),
    CharcoalDimensionTokenEntry(path: 'space.component/25', value: component25),
    CharcoalDimensionTokenEntry(path: 'space.component/30', value: component30),
    CharcoalDimensionTokenEntry(path: 'space.component/40', value: component40),
    CharcoalDimensionTokenEntry(path: 'space.component/50', value: component50),
    CharcoalDimensionTokenEntry(path: 'space.layout/0', value: layout0),
    CharcoalDimensionTokenEntry(path: 'space.layout/10', value: layout10),
    CharcoalDimensionTokenEntry(path: 'space.layout/100', value: layout100),
    CharcoalDimensionTokenEntry(path: 'space.layout/20', value: layout20),
    CharcoalDimensionTokenEntry(path: 'space.layout/25', value: layout25),
    CharcoalDimensionTokenEntry(path: 'space.layout/30', value: layout30),
    CharcoalDimensionTokenEntry(path: 'space.layout/40', value: layout40),
    CharcoalDimensionTokenEntry(path: 'space.layout/50', value: layout50),
    CharcoalDimensionTokenEntry(path: 'space.layout/60', value: layout60),
    CharcoalDimensionTokenEntry(path: 'space.layout/70', value: layout70),
    CharcoalDimensionTokenEntry(path: 'space.layout/80', value: layout80),
    CharcoalDimensionTokenEntry(path: 'space.layout/90', value: layout90),
    CharcoalDimensionTokenEntry(path: 'space.padding/padding-card', value: paddingPaddingCard),
    CharcoalDimensionTokenEntry(path: 'space.target/l', value: targetL),
    CharcoalDimensionTokenEntry(path: 'space.target/m', value: targetM),
    CharcoalDimensionTokenEntry(path: 'space.target/s', value: targetS),
    CharcoalDimensionTokenEntry(path: 'space.target/xs', value: targetXs),
  ];
}

/// All generated dimensional tokens for one brightness mode.
final class CharcoalDimensionTokens {
  const CharcoalDimensionTokens({
    required this.borderWidth,
    required this.paragraphWidth,
    required this.radius,
    required this.space,
  });

  final CharcoalBorderWidthTokens borderWidth;
  final CharcoalParagraphWidthTokens paragraphWidth;
  final CharcoalRadiusTokens radius;
  final CharcoalSpaceTokens space;
}

/// Generated light and dark dimensions. Do not edit by hand.
abstract final class CharcoalGeneratedDimensionTokens {
  static const CharcoalDimensionTokens light = CharcoalDimensionTokens(
    borderWidth: CharcoalBorderWidthTokens(
      focus1: 1.0,
      focus2: 2.0,
      l: 2.0,
      m: 1.0,
    ),
    paragraphWidth: CharcoalParagraphWidthTokens(
      l: 672.0,
      lCompact: 588.0,
      lCozy: 924.0,
      m: 448.0,
      mCompact: 392.0,
      mCozy: 616.0,
      s: 320.0,
      sCompact: 280.0,
      sCozy: 588.0,
    ),
    radius: CharcoalRadiusTokens(
      value0: 0.0,
      l: 12.0,
      m: 8.0,
      oval: 999999.0,
      s: 4.0,
      xl: 16.0,
      xs: 2.0,
      xxl: 24.0,
    ),
    space: CharcoalSpaceTokens(
      component0: 0.0,
      component10: 4.0,
      component20: 8.0,
      component25: 12.0,
      component30: 16.0,
      component40: 24.0,
      component50: 40.0,
      layout0: 0.0,
      layout10: 4.0,
      layout100: 440.0,
      layout20: 8.0,
      layout25: 12.0,
      layout30: 16.0,
      layout40: 24.0,
      layout50: 40.0,
      layout60: 64.0,
      layout70: 104.0,
      layout80: 168.0,
      layout90: 272.0,
      paddingPaddingCard: 24.0,
      targetL: 48.0,
      targetM: 40.0,
      targetS: 32.0,
      targetXs: 24.0,
    ),
  );

  static const CharcoalDimensionTokens dark = CharcoalDimensionTokens(
    borderWidth: CharcoalBorderWidthTokens(
      focus1: 1.0,
      focus2: 2.0,
      l: 2.0,
      m: 1.0,
    ),
    paragraphWidth: CharcoalParagraphWidthTokens(
      l: 672.0,
      lCompact: 588.0,
      lCozy: 924.0,
      m: 448.0,
      mCompact: 392.0,
      mCozy: 616.0,
      s: 320.0,
      sCompact: 280.0,
      sCozy: 588.0,
    ),
    radius: CharcoalRadiusTokens(
      value0: 0.0,
      l: 12.0,
      m: 8.0,
      oval: 999999.0,
      s: 4.0,
      xl: 16.0,
      xs: 2.0,
      xxl: 24.0,
    ),
    space: CharcoalSpaceTokens(
      component0: 0.0,
      component10: 4.0,
      component20: 8.0,
      component25: 12.0,
      component30: 16.0,
      component40: 24.0,
      component50: 40.0,
      layout0: 0.0,
      layout10: 4.0,
      layout100: 440.0,
      layout20: 8.0,
      layout25: 12.0,
      layout30: 16.0,
      layout40: 24.0,
      layout50: 40.0,
      layout60: 64.0,
      layout70: 104.0,
      layout80: 168.0,
      layout90: 272.0,
      paddingPaddingCard: 24.0,
      targetL: 48.0,
      targetM: 40.0,
      targetS: 32.0,
      targetXs: 24.0,
    ),
  );
}
