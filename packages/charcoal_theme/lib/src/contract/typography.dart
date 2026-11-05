// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show TargetPlatform, immutable, kIsWeb;
import 'package:flutter/painting.dart' show FontWeight;

/// The type roles of the contract.
///
/// Application roles (`pageTitle` ... `captionMono`) come from the Myopay console. `size10` ...
/// `size20` are the numeric ladder of the Charcoal typography widget. The remaining roles are the
/// upstream typography tokens.
enum CharcoalTextRole {
  /// Page title.
  pageTitle,

  /// Dialog title and card values.
  modalTitle,

  /// Section headings.
  sectionTitle,

  /// Body text.
  body,

  /// Row titles and labels.
  bodyBold,

  /// Metadata and sub-lines.
  caption,

  /// Chip labels and status text.
  captionBold,

  /// Identifiers and keys (monospace).
  captionMono,

  /// Numeric ladder 10/18 (CharcoalTypography size10).
  size10,

  /// Numeric ladder 12/20 (CharcoalTypography size12).
  size12,

  /// Numeric ladder 14/22 (CharcoalTypography size14).
  size14,

  /// Numeric ladder 16/24 (CharcoalTypography size16).
  size16,

  /// Numeric ladder 20/28 (CharcoalTypography size20).
  size20,

  /// Upstream body token, 16/24: the default text of an app.
  bodyLarge,

  /// Upstream bold body token, 16/24.
  bodyLargeBold,

  /// Long-form paragraph, 16/28.
  paragraph,

  /// Upstream captionM token, 14/20.
  captionMedium,

  /// Upstream captionM token, bold: navigation-bar titles, checkbox labels.
  captionMediumBold,

  /// Heading 14/20.
  headingXxxs,

  /// Heading 18/24.
  headingXxs,

  /// Heading 20/28.
  headingXs,

  /// Heading 22/28.
  headingS,

  /// Heading 25/32.
  headingM,

  /// Heading 28/36.
  headingL,

  /// Heading 32/40.
  headingXl,

  /// Heading 36/44.
  headingXxl,

  /// Heading 40/52.
  headingXxxl,
}

/// Size, line height and weight of one role.
@immutable
class CharcoalTextSpec {
  /// Creates a spec.
  const CharcoalTextSpec({required this.fontSize, required this.lineHeight, required this.weight});

  /// Font size in logical pixels.
  final double fontSize;

  /// Line height in logical pixels; the style uses `lineHeight / fontSize` as its height multiplier.
  final double lineHeight;

  /// Weight when the role is not forced bold.
  final FontWeight weight;

  /// A copy with the given fields replaced.
  CharcoalTextSpec copyWith({double? fontSize, double? lineHeight, FontWeight? weight}) =>
      CharcoalTextSpec(
        fontSize: fontSize ?? this.fontSize,
        lineHeight: lineHeight ?? this.lineHeight,
        weight: weight ?? this.weight,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTextSpec &&
          other.fontSize == fontSize &&
          other.lineHeight == lineHeight &&
          other.weight == weight;

  @override
  int get hashCode => Object.hash(fontSize, lineHeight, weight);
}

/// The type scale and font families of a pack.
@immutable
class CharcoalTypeScale {
  /// Creates the full scale.
  const CharcoalTypeScale({
    required this.pageTitle,
    required this.modalTitle,
    required this.sectionTitle,
    required this.body,
    required this.bodyBold,
    required this.caption,
    required this.captionBold,
    required this.captionMono,
    required this.size10,
    required this.size12,
    required this.size14,
    required this.size16,
    required this.size20,
    required this.bodyLarge,
    required this.bodyLargeBold,
    required this.paragraph,
    required this.captionMedium,
    required this.captionMediumBold,
    required this.headingXxxs,
    required this.headingXxs,
    required this.headingXs,
    required this.headingS,
    required this.headingM,
    required this.headingL,
    required this.headingXl,
    required this.headingXxl,
    required this.headingXxxl,
    required this.weightRegular,
    required this.weightBold,
    required this.monoFamily,
    required this.appleTextFamily,
    required this.appleDisplayFamily,
    required this.appleDisplayFrom,
    this.sansFamily,
  });

  /// Page title.
  final CharcoalTextSpec pageTitle;

  /// Dialog title and card values.
  final CharcoalTextSpec modalTitle;

  /// Section headings.
  final CharcoalTextSpec sectionTitle;

  /// Body text.
  final CharcoalTextSpec body;

  /// Row titles and labels.
  final CharcoalTextSpec bodyBold;

  /// Metadata and sub-lines.
  final CharcoalTextSpec caption;

  /// Chip labels and status text.
  final CharcoalTextSpec captionBold;

  /// Identifiers and keys (monospace).
  final CharcoalTextSpec captionMono;

  /// Numeric ladder 10/18 (CharcoalTypography size10).
  final CharcoalTextSpec size10;

  /// Numeric ladder 12/20 (CharcoalTypography size12).
  final CharcoalTextSpec size12;

  /// Numeric ladder 14/22 (CharcoalTypography size14).
  final CharcoalTextSpec size14;

  /// Numeric ladder 16/24 (CharcoalTypography size16).
  final CharcoalTextSpec size16;

  /// Numeric ladder 20/28 (CharcoalTypography size20).
  final CharcoalTextSpec size20;

  /// Upstream body token, 16/24: the default text of an app.
  final CharcoalTextSpec bodyLarge;

  /// Upstream bold body token, 16/24.
  final CharcoalTextSpec bodyLargeBold;

  /// Long-form paragraph, 16/28.
  final CharcoalTextSpec paragraph;

  /// Upstream captionM token, 14/20.
  final CharcoalTextSpec captionMedium;

  /// Upstream captionM token, bold: navigation-bar titles, checkbox labels.
  final CharcoalTextSpec captionMediumBold;

  /// Heading 14/20.
  final CharcoalTextSpec headingXxxs;

  /// Heading 18/24.
  final CharcoalTextSpec headingXxs;

  /// Heading 20/28.
  final CharcoalTextSpec headingXs;

  /// Heading 22/28.
  final CharcoalTextSpec headingS;

  /// Heading 25/32.
  final CharcoalTextSpec headingM;

  /// Heading 28/36.
  final CharcoalTextSpec headingL;

  /// Heading 32/40.
  final CharcoalTextSpec headingXl;

  /// Heading 36/44.
  final CharcoalTextSpec headingXxl;

  /// Heading 40/52.
  final CharcoalTextSpec headingXxxl;

  /// Regular weight (upstream `fontWeight.regular`).
  final FontWeight weightRegular;

  /// Bold weight (upstream `fontWeight.bold`); applied when a style asks for bold.
  final FontWeight weightBold;

  /// Explicit sans family. When null the platform default applies: the Apple system families on
  /// iOS and macOS, the engine default elsewhere and on the web.
  final String? sansFamily;

  /// Family for identifiers and keys.
  final String monoFamily;

  /// System text family on Apple platforms.
  final String appleTextFamily;

  /// System display family on Apple platforms, used from [appleDisplayFrom].
  final String appleDisplayFamily;

  /// Font size at which the Apple display family takes over.
  final double appleDisplayFrom;

  /// The spec of [role].
  CharcoalTextSpec spec(CharcoalTextRole role) => switch (role) {
    CharcoalTextRole.pageTitle => pageTitle,
    CharcoalTextRole.modalTitle => modalTitle,
    CharcoalTextRole.sectionTitle => sectionTitle,
    CharcoalTextRole.body => body,
    CharcoalTextRole.bodyBold => bodyBold,
    CharcoalTextRole.caption => caption,
    CharcoalTextRole.captionBold => captionBold,
    CharcoalTextRole.captionMono => captionMono,
    CharcoalTextRole.size10 => size10,
    CharcoalTextRole.size12 => size12,
    CharcoalTextRole.size14 => size14,
    CharcoalTextRole.size16 => size16,
    CharcoalTextRole.size20 => size20,
    CharcoalTextRole.bodyLarge => bodyLarge,
    CharcoalTextRole.bodyLargeBold => bodyLargeBold,
    CharcoalTextRole.paragraph => paragraph,
    CharcoalTextRole.captionMedium => captionMedium,
    CharcoalTextRole.captionMediumBold => captionMediumBold,
    CharcoalTextRole.headingXxxs => headingXxxs,
    CharcoalTextRole.headingXxs => headingXxs,
    CharcoalTextRole.headingXs => headingXs,
    CharcoalTextRole.headingS => headingS,
    CharcoalTextRole.headingM => headingM,
    CharcoalTextRole.headingL => headingL,
    CharcoalTextRole.headingXl => headingXl,
    CharcoalTextRole.headingXxl => headingXxl,
    CharcoalTextRole.headingXxxl => headingXxxl,
  };

  /// The sans family for [fontSize] on [platform], or null for the engine default.
  String? sansFamilyFor(double fontSize, TargetPlatform platform) {
    if (sansFamily != null) return sansFamily;
    if (kIsWeb) return null;
    if (platform != TargetPlatform.iOS && platform != TargetPlatform.macOS) return null;
    return fontSize >= appleDisplayFrom ? appleDisplayFamily : appleTextFamily;
  }

  /// A copy with every role spec transformed by [change] (used by test packs).
  CharcoalTypeScale mapSpecs(CharcoalTextSpec Function(CharcoalTextSpec spec) change) => copyWith(
    pageTitle: change(pageTitle),
    modalTitle: change(modalTitle),
    sectionTitle: change(sectionTitle),
    body: change(body),
    bodyBold: change(bodyBold),
    caption: change(caption),
    captionBold: change(captionBold),
    captionMono: change(captionMono),
    size10: change(size10),
    size12: change(size12),
    size14: change(size14),
    size16: change(size16),
    size20: change(size20),
    bodyLarge: change(bodyLarge),
    bodyLargeBold: change(bodyLargeBold),
    paragraph: change(paragraph),
    captionMedium: change(captionMedium),
    captionMediumBold: change(captionMediumBold),
    headingXxxs: change(headingXxxs),
    headingXxs: change(headingXxs),
    headingXs: change(headingXs),
    headingS: change(headingS),
    headingM: change(headingM),
    headingL: change(headingL),
    headingXl: change(headingXl),
    headingXxl: change(headingXxl),
    headingXxxl: change(headingXxxl),
  );

  /// A copy with the given fields replaced.
  CharcoalTypeScale copyWith({
    CharcoalTextSpec? pageTitle,
    CharcoalTextSpec? modalTitle,
    CharcoalTextSpec? sectionTitle,
    CharcoalTextSpec? body,
    CharcoalTextSpec? bodyBold,
    CharcoalTextSpec? caption,
    CharcoalTextSpec? captionBold,
    CharcoalTextSpec? captionMono,
    CharcoalTextSpec? size10,
    CharcoalTextSpec? size12,
    CharcoalTextSpec? size14,
    CharcoalTextSpec? size16,
    CharcoalTextSpec? size20,
    CharcoalTextSpec? bodyLarge,
    CharcoalTextSpec? bodyLargeBold,
    CharcoalTextSpec? paragraph,
    CharcoalTextSpec? captionMedium,
    CharcoalTextSpec? captionMediumBold,
    CharcoalTextSpec? headingXxxs,
    CharcoalTextSpec? headingXxs,
    CharcoalTextSpec? headingXs,
    CharcoalTextSpec? headingS,
    CharcoalTextSpec? headingM,
    CharcoalTextSpec? headingL,
    CharcoalTextSpec? headingXl,
    CharcoalTextSpec? headingXxl,
    CharcoalTextSpec? headingXxxl,
    FontWeight? weightRegular,
    FontWeight? weightBold,
    String? sansFamily,
    String? monoFamily,
    String? appleTextFamily,
    String? appleDisplayFamily,
    double? appleDisplayFrom,
  }) => CharcoalTypeScale(
    pageTitle: pageTitle ?? this.pageTitle,
    modalTitle: modalTitle ?? this.modalTitle,
    sectionTitle: sectionTitle ?? this.sectionTitle,
    body: body ?? this.body,
    bodyBold: bodyBold ?? this.bodyBold,
    caption: caption ?? this.caption,
    captionBold: captionBold ?? this.captionBold,
    captionMono: captionMono ?? this.captionMono,
    size10: size10 ?? this.size10,
    size12: size12 ?? this.size12,
    size14: size14 ?? this.size14,
    size16: size16 ?? this.size16,
    size20: size20 ?? this.size20,
    bodyLarge: bodyLarge ?? this.bodyLarge,
    bodyLargeBold: bodyLargeBold ?? this.bodyLargeBold,
    paragraph: paragraph ?? this.paragraph,
    captionMedium: captionMedium ?? this.captionMedium,
    captionMediumBold: captionMediumBold ?? this.captionMediumBold,
    headingXxxs: headingXxxs ?? this.headingXxxs,
    headingXxs: headingXxs ?? this.headingXxs,
    headingXs: headingXs ?? this.headingXs,
    headingS: headingS ?? this.headingS,
    headingM: headingM ?? this.headingM,
    headingL: headingL ?? this.headingL,
    headingXl: headingXl ?? this.headingXl,
    headingXxl: headingXxl ?? this.headingXxl,
    headingXxxl: headingXxxl ?? this.headingXxxl,
    weightRegular: weightRegular ?? this.weightRegular,
    weightBold: weightBold ?? this.weightBold,
    sansFamily: sansFamily ?? this.sansFamily,
    monoFamily: monoFamily ?? this.monoFamily,
    appleTextFamily: appleTextFamily ?? this.appleTextFamily,
    appleDisplayFamily: appleDisplayFamily ?? this.appleDisplayFamily,
    appleDisplayFrom: appleDisplayFrom ?? this.appleDisplayFrom,
  );

  /// Every value by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'pageTitle.fontSize': pageTitle.fontSize,
    'pageTitle.lineHeight': pageTitle.lineHeight,
    'pageTitle.weight': pageTitle.weight,
    'modalTitle.fontSize': modalTitle.fontSize,
    'modalTitle.lineHeight': modalTitle.lineHeight,
    'modalTitle.weight': modalTitle.weight,
    'sectionTitle.fontSize': sectionTitle.fontSize,
    'sectionTitle.lineHeight': sectionTitle.lineHeight,
    'sectionTitle.weight': sectionTitle.weight,
    'body.fontSize': body.fontSize,
    'body.lineHeight': body.lineHeight,
    'body.weight': body.weight,
    'bodyBold.fontSize': bodyBold.fontSize,
    'bodyBold.lineHeight': bodyBold.lineHeight,
    'bodyBold.weight': bodyBold.weight,
    'caption.fontSize': caption.fontSize,
    'caption.lineHeight': caption.lineHeight,
    'caption.weight': caption.weight,
    'captionBold.fontSize': captionBold.fontSize,
    'captionBold.lineHeight': captionBold.lineHeight,
    'captionBold.weight': captionBold.weight,
    'captionMono.fontSize': captionMono.fontSize,
    'captionMono.lineHeight': captionMono.lineHeight,
    'captionMono.weight': captionMono.weight,
    'size10.fontSize': size10.fontSize,
    'size10.lineHeight': size10.lineHeight,
    'size10.weight': size10.weight,
    'size12.fontSize': size12.fontSize,
    'size12.lineHeight': size12.lineHeight,
    'size12.weight': size12.weight,
    'size14.fontSize': size14.fontSize,
    'size14.lineHeight': size14.lineHeight,
    'size14.weight': size14.weight,
    'size16.fontSize': size16.fontSize,
    'size16.lineHeight': size16.lineHeight,
    'size16.weight': size16.weight,
    'size20.fontSize': size20.fontSize,
    'size20.lineHeight': size20.lineHeight,
    'size20.weight': size20.weight,
    'bodyLarge.fontSize': bodyLarge.fontSize,
    'bodyLarge.lineHeight': bodyLarge.lineHeight,
    'bodyLarge.weight': bodyLarge.weight,
    'bodyLargeBold.fontSize': bodyLargeBold.fontSize,
    'bodyLargeBold.lineHeight': bodyLargeBold.lineHeight,
    'bodyLargeBold.weight': bodyLargeBold.weight,
    'paragraph.fontSize': paragraph.fontSize,
    'paragraph.lineHeight': paragraph.lineHeight,
    'paragraph.weight': paragraph.weight,
    'captionMedium.fontSize': captionMedium.fontSize,
    'captionMedium.lineHeight': captionMedium.lineHeight,
    'captionMedium.weight': captionMedium.weight,
    'captionMediumBold.fontSize': captionMediumBold.fontSize,
    'captionMediumBold.lineHeight': captionMediumBold.lineHeight,
    'captionMediumBold.weight': captionMediumBold.weight,
    'headingXxxs.fontSize': headingXxxs.fontSize,
    'headingXxxs.lineHeight': headingXxxs.lineHeight,
    'headingXxxs.weight': headingXxxs.weight,
    'headingXxs.fontSize': headingXxs.fontSize,
    'headingXxs.lineHeight': headingXxs.lineHeight,
    'headingXxs.weight': headingXxs.weight,
    'headingXs.fontSize': headingXs.fontSize,
    'headingXs.lineHeight': headingXs.lineHeight,
    'headingXs.weight': headingXs.weight,
    'headingS.fontSize': headingS.fontSize,
    'headingS.lineHeight': headingS.lineHeight,
    'headingS.weight': headingS.weight,
    'headingM.fontSize': headingM.fontSize,
    'headingM.lineHeight': headingM.lineHeight,
    'headingM.weight': headingM.weight,
    'headingL.fontSize': headingL.fontSize,
    'headingL.lineHeight': headingL.lineHeight,
    'headingL.weight': headingL.weight,
    'headingXl.fontSize': headingXl.fontSize,
    'headingXl.lineHeight': headingXl.lineHeight,
    'headingXl.weight': headingXl.weight,
    'headingXxl.fontSize': headingXxl.fontSize,
    'headingXxl.lineHeight': headingXxl.lineHeight,
    'headingXxl.weight': headingXxl.weight,
    'headingXxxl.fontSize': headingXxxl.fontSize,
    'headingXxxl.lineHeight': headingXxxl.lineHeight,
    'headingXxxl.weight': headingXxxl.weight,
    'weightRegular': weightRegular,
    'weightBold': weightBold,
    'sansFamily': sansFamily,
    'monoFamily': monoFamily,
    'appleTextFamily': appleTextFamily,
    'appleDisplayFamily': appleDisplayFamily,
    'appleDisplayFrom': appleDisplayFrom,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTypeScale &&
          other.pageTitle == pageTitle &&
          other.modalTitle == modalTitle &&
          other.sectionTitle == sectionTitle &&
          other.body == body &&
          other.bodyBold == bodyBold &&
          other.caption == caption &&
          other.captionBold == captionBold &&
          other.captionMono == captionMono &&
          other.size10 == size10 &&
          other.size12 == size12 &&
          other.size14 == size14 &&
          other.size16 == size16 &&
          other.size20 == size20 &&
          other.bodyLarge == bodyLarge &&
          other.bodyLargeBold == bodyLargeBold &&
          other.paragraph == paragraph &&
          other.captionMedium == captionMedium &&
          other.captionMediumBold == captionMediumBold &&
          other.headingXxxs == headingXxxs &&
          other.headingXxs == headingXxs &&
          other.headingXs == headingXs &&
          other.headingS == headingS &&
          other.headingM == headingM &&
          other.headingL == headingL &&
          other.headingXl == headingXl &&
          other.headingXxl == headingXxl &&
          other.headingXxxl == headingXxxl &&
          other.weightRegular == weightRegular &&
          other.weightBold == weightBold &&
          other.sansFamily == sansFamily &&
          other.monoFamily == monoFamily &&
          other.appleTextFamily == appleTextFamily &&
          other.appleDisplayFamily == appleDisplayFamily &&
          other.appleDisplayFrom == appleDisplayFrom;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    pageTitle,
    modalTitle,
    sectionTitle,
    body,
    bodyBold,
    caption,
    captionBold,
    captionMono,
    size10,
    size12,
    size14,
    size16,
    size20,
    bodyLarge,
    bodyLargeBold,
    paragraph,
    captionMedium,
    captionMediumBold,
    headingXxxs,
    headingXxs,
    headingXs,
    headingS,
    headingM,
    headingL,
    headingXl,
    headingXxl,
    headingXxxl,
    weightRegular,
    weightBold,
    sansFamily,
    monoFamily,
    appleTextFamily,
    appleDisplayFamily,
    appleDisplayFrom,
  ]);
}
