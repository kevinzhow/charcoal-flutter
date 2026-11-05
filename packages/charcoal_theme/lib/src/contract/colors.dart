// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'dart:ui' show Color;

import 'package:flutter/foundation.dart' show immutable;

/// The semantic colour vocabulary every themed widget reads.
///
/// A role says what a colour is *for* (`borderSubtle`: list rules and card outlines), never
/// which hue it is. Widgets read roles; packs assign values.
@immutable
class CharcoalColorRoles {
  /// Fully transparent. A constant, not a role: no pack may change it.
  static const Color transparent = Color(0x00000000);

  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalColorRoles({
    required this.background,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.scrim,
    required this.barrier,
    required this.pageBackdrop,
    required this.surface,
    required this.surfaceHover,
    required this.surfacePress,
    required this.surfaceSecondary,
    required this.surfaceSecondaryHover,
    required this.surfaceSecondaryPress,
    required this.surfaceTertiary,
    required this.surfaceTertiaryPress,
    required this.surfaceDisabled,
    required this.fillSecondary,
    required this.fillSecondaryHover,
    required this.fillSecondaryPress,
    required this.restOverlay,
    required this.hoverOverlay,
    required this.pressOverlay,
    required this.skeleton,
    required this.fillOnImage,
    required this.fillOnImageHover,
    required this.fillOnImagePress,
    required this.hud,
    required this.hudHover,
    required this.hudPress,
    required this.border,
    required this.borderSubtle,
    required this.borderDisabled,
    required this.borderNegative,
    required this.borderSelected,
    required this.borderFocus,
    required this.borderHud,
    required this.focusRing,
    required this.focusRingInner,
    required this.primary,
    required this.primaryHover,
    required this.primaryPress,
    required this.negative,
    required this.negativeHover,
    required this.negativePress,
    required this.positive,
    required this.notice,
    required this.neutral,
    required this.neutralHover,
    required this.neutralPress,
    required this.positiveSurface,
    required this.negativeSurface,
    required this.infoSurface,
    required this.noticeSurface,
    required this.tagBackground,
    required this.shadow,
    required this.text,
    required this.textHover,
    required this.textPress,
    required this.textSecondary,
    required this.textSecondaryHover,
    required this.textSecondaryPress,
    required this.textTertiary,
    required this.textTertiaryHover,
    required this.textTertiaryPress,
    required this.textPlaceholder,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.textOnNegative,
    required this.textOnPositive,
    required this.textOnHud,
    required this.textOnImage,
    required this.textPositive,
    required this.textNegative,
    required this.textNotice,
    required this.textInfo,
    required this.icon,
    required this.iconHover,
    required this.iconPress,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconTertiaryHover,
    required this.iconTertiaryPress,
    required this.iconDisabled,
    required this.iconPositive,
    required this.iconNegative,
    required this.iconNotice,
    required this.iconOnPrimary,
    required this.iconOnImage,
    required this.textOnNotice,
    required this.iconOnNotice,
    required this.iconHint,
  });

  /// Page and dialog surface.
  final Color background;

  /// Grey card / code-block surface.
  final Color backgroundSecondary;

  /// Deepest neutral surface.
  final Color backgroundTertiary;

  /// Translucent layer over a page behind a floating surface.
  final Color scrim;

  /// Barrier behind a modal dialog.
  final Color barrier;

  /// Opaque colour under a page that is being covered or swiped away (faded by the route).
  final Color pageBackdrop;

  /// Opaque resting container fill (list rows, cards).
  final Color surface;

  /// Opaque container fill, hovered.
  final Color surfaceHover;

  /// Opaque container fill, pressed.
  final Color surfacePress;

  /// Opaque secondary container.
  final Color surfaceSecondary;

  /// Opaque secondary container, hovered.
  final Color surfaceSecondaryHover;

  /// Opaque secondary container, pressed.
  final Color surfaceSecondaryPress;

  /// Opaque tertiary container: avatar, meter track.
  final Color surfaceTertiary;

  /// Opaque tertiary container, pressed (pagination current page).
  final Color surfaceTertiaryPress;

  /// Disabled container fill.
  final Color surfaceDisabled;

  /// Translucent field / secondary button fill.
  final Color fillSecondary;

  /// Secondary fill, hovered.
  final Color fillSecondaryHover;

  /// Secondary fill, pressed.
  final Color fillSecondaryPress;

  /// Row overlay at rest (fully transparent, but a real colour so it can cross-fade to the hover and press overlays).
  final Color restOverlay;

  /// Row hover overlay.
  final Color hoverOverlay;

  /// Row press overlay.
  final Color pressOverlay;

  /// Loading placeholder fill.
  final Color skeleton;

  /// Translucent control fill drawn over an image.
  final Color fillOnImage;

  /// Over-image control fill, hovered.
  final Color fillOnImageHover;

  /// Over-image control fill, pressed.
  final Color fillOnImagePress;

  /// Toast / HUD fill.
  final Color hud;

  /// HUD fill, hovered.
  final Color hudHover;

  /// HUD fill, pressed.
  final Color hudPress;

  /// Control indicator outline (checkbox, radio).
  final Color border;

  /// Structural separators: list rules, card outlines.
  final Color borderSubtle;

  /// Outline of a disabled control.
  final Color borderDisabled;

  /// Outline of an invalid control.
  final Color borderNegative;

  /// Outline of a selected control.
  final Color borderSelected;

  /// Keyboard focus outline on rows.
  final Color borderFocus;

  /// Outline of a control drawn over an image or HUD (multi-select overlay variant).
  final Color borderHud;

  /// Translucent ring (borders.focusHalo wide) around a focused field or button.
  final Color focusRing;

  /// Inner separator drawn between a control and its focus ring.
  final Color focusRingInner;

  /// Primary action fill.
  final Color primary;

  /// Primary action fill, hovered.
  final Color primaryHover;

  /// Primary action fill, pressed.
  final Color primaryPress;

  /// Destructive action fill.
  final Color negative;

  /// Destructive action fill, hovered.
  final Color negativeHover;

  /// Destructive action fill, pressed.
  final Color negativePress;

  /// Positive status fill (dots, success toast).
  final Color positive;

  /// Notice status fill.
  final Color notice;

  /// Neutral status fill (dots, switch track at rest).
  final Color neutral;

  /// Neutral fill, hovered.
  final Color neutralHover;

  /// Neutral fill, pressed.
  final Color neutralPress;

  /// Pale positive chip / banner surface (product tint, not an upstream token).
  final Color positiveSurface;

  /// Pale negative chip / banner surface (product tint).
  final Color negativeSurface;

  /// Pale info chip / banner surface; selected row (product tint).
  final Color infoSurface;

  /// Pale notice chip / banner surface (product tint).
  final Color noticeSurface;

  /// Tag fill when the caller passes no colour (authored by Charcoal iOS).
  final Color tagBackground;

  /// Soft drop shadow under a floating spinner.
  final Color shadow;

  /// Default text.
  final Color text;

  /// Default text, hovered.
  final Color textHover;

  /// Default text, pressed.
  final Color textPress;

  /// Secondary text.
  final Color textSecondary;

  /// Secondary text, hovered.
  final Color textSecondaryHover;

  /// Secondary text, pressed.
  final Color textSecondaryPress;

  /// Metadata and captions.
  final Color textTertiary;

  /// Tertiary text, hovered.
  final Color textTertiaryHover;

  /// Tertiary text, pressed.
  final Color textTertiaryPress;

  /// Field placeholder.
  final Color textPlaceholder;

  /// Disabled text.
  final Color textDisabled;

  /// Text on a primary fill.
  final Color textOnPrimary;

  /// Text on a negative fill.
  final Color textOnNegative;

  /// Text on a positive fill (success toast).
  final Color textOnPositive;

  /// Text on a HUD fill.
  final Color textOnHud;

  /// Text on an over-image fill.
  final Color textOnImage;

  /// Positive status text.
  final Color textPositive;

  /// Negative status text and errors.
  final Color textNegative;

  /// Notice status text.
  final Color textNotice;

  /// Info status text and links.
  final Color textInfo;

  /// Default icon.
  final Color icon;

  /// Default icon, hovered.
  final Color iconHover;

  /// Default icon, pressed.
  final Color iconPress;

  /// Secondary icon.
  final Color iconSecondary;

  /// Tertiary icon: chevrons.
  final Color iconTertiary;

  /// Tertiary icon, hovered.
  final Color iconTertiaryHover;

  /// Tertiary icon, pressed.
  final Color iconTertiaryPress;

  /// Disabled icon, empty-state art.
  final Color iconDisabled;

  /// Positive icon.
  final Color iconPositive;

  /// Negative icon.
  final Color iconNegative;

  /// Notice icon.
  final Color iconNotice;

  /// Icon or switch thumb on a primary fill.
  final Color iconOnPrimary;

  /// Icon on an over-image fill.
  final Color iconOnImage;

  /// Text on a notice fill (appended after the freeze).
  final Color textOnNotice;

  /// Icon on a notice fill (appended after the freeze).
  final Color iconOnNotice;

  /// Fill of the hint-text info glyph (authored by Charcoal iOS 16/Info.pdf).
  final Color iconHint;

  /// A copy with the given fields replaced.
  CharcoalColorRoles copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? scrim,
    Color? barrier,
    Color? pageBackdrop,
    Color? surface,
    Color? surfaceHover,
    Color? surfacePress,
    Color? surfaceSecondary,
    Color? surfaceSecondaryHover,
    Color? surfaceSecondaryPress,
    Color? surfaceTertiary,
    Color? surfaceTertiaryPress,
    Color? surfaceDisabled,
    Color? fillSecondary,
    Color? fillSecondaryHover,
    Color? fillSecondaryPress,
    Color? restOverlay,
    Color? hoverOverlay,
    Color? pressOverlay,
    Color? skeleton,
    Color? fillOnImage,
    Color? fillOnImageHover,
    Color? fillOnImagePress,
    Color? hud,
    Color? hudHover,
    Color? hudPress,
    Color? border,
    Color? borderSubtle,
    Color? borderDisabled,
    Color? borderNegative,
    Color? borderSelected,
    Color? borderFocus,
    Color? borderHud,
    Color? focusRing,
    Color? focusRingInner,
    Color? primary,
    Color? primaryHover,
    Color? primaryPress,
    Color? negative,
    Color? negativeHover,
    Color? negativePress,
    Color? positive,
    Color? notice,
    Color? neutral,
    Color? neutralHover,
    Color? neutralPress,
    Color? positiveSurface,
    Color? negativeSurface,
    Color? infoSurface,
    Color? noticeSurface,
    Color? tagBackground,
    Color? shadow,
    Color? text,
    Color? textHover,
    Color? textPress,
    Color? textSecondary,
    Color? textSecondaryHover,
    Color? textSecondaryPress,
    Color? textTertiary,
    Color? textTertiaryHover,
    Color? textTertiaryPress,
    Color? textPlaceholder,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? textOnNegative,
    Color? textOnPositive,
    Color? textOnHud,
    Color? textOnImage,
    Color? textPositive,
    Color? textNegative,
    Color? textNotice,
    Color? textInfo,
    Color? icon,
    Color? iconHover,
    Color? iconPress,
    Color? iconSecondary,
    Color? iconTertiary,
    Color? iconTertiaryHover,
    Color? iconTertiaryPress,
    Color? iconDisabled,
    Color? iconPositive,
    Color? iconNegative,
    Color? iconNotice,
    Color? iconOnPrimary,
    Color? iconOnImage,
    Color? textOnNotice,
    Color? iconOnNotice,
    Color? iconHint,
  }) => CharcoalColorRoles(
    background: background ?? this.background,
    backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
    backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
    scrim: scrim ?? this.scrim,
    barrier: barrier ?? this.barrier,
    pageBackdrop: pageBackdrop ?? this.pageBackdrop,
    surface: surface ?? this.surface,
    surfaceHover: surfaceHover ?? this.surfaceHover,
    surfacePress: surfacePress ?? this.surfacePress,
    surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
    surfaceSecondaryHover: surfaceSecondaryHover ?? this.surfaceSecondaryHover,
    surfaceSecondaryPress: surfaceSecondaryPress ?? this.surfaceSecondaryPress,
    surfaceTertiary: surfaceTertiary ?? this.surfaceTertiary,
    surfaceTertiaryPress: surfaceTertiaryPress ?? this.surfaceTertiaryPress,
    surfaceDisabled: surfaceDisabled ?? this.surfaceDisabled,
    fillSecondary: fillSecondary ?? this.fillSecondary,
    fillSecondaryHover: fillSecondaryHover ?? this.fillSecondaryHover,
    fillSecondaryPress: fillSecondaryPress ?? this.fillSecondaryPress,
    restOverlay: restOverlay ?? this.restOverlay,
    hoverOverlay: hoverOverlay ?? this.hoverOverlay,
    pressOverlay: pressOverlay ?? this.pressOverlay,
    skeleton: skeleton ?? this.skeleton,
    fillOnImage: fillOnImage ?? this.fillOnImage,
    fillOnImageHover: fillOnImageHover ?? this.fillOnImageHover,
    fillOnImagePress: fillOnImagePress ?? this.fillOnImagePress,
    hud: hud ?? this.hud,
    hudHover: hudHover ?? this.hudHover,
    hudPress: hudPress ?? this.hudPress,
    border: border ?? this.border,
    borderSubtle: borderSubtle ?? this.borderSubtle,
    borderDisabled: borderDisabled ?? this.borderDisabled,
    borderNegative: borderNegative ?? this.borderNegative,
    borderSelected: borderSelected ?? this.borderSelected,
    borderFocus: borderFocus ?? this.borderFocus,
    borderHud: borderHud ?? this.borderHud,
    focusRing: focusRing ?? this.focusRing,
    focusRingInner: focusRingInner ?? this.focusRingInner,
    primary: primary ?? this.primary,
    primaryHover: primaryHover ?? this.primaryHover,
    primaryPress: primaryPress ?? this.primaryPress,
    negative: negative ?? this.negative,
    negativeHover: negativeHover ?? this.negativeHover,
    negativePress: negativePress ?? this.negativePress,
    positive: positive ?? this.positive,
    notice: notice ?? this.notice,
    neutral: neutral ?? this.neutral,
    neutralHover: neutralHover ?? this.neutralHover,
    neutralPress: neutralPress ?? this.neutralPress,
    positiveSurface: positiveSurface ?? this.positiveSurface,
    negativeSurface: negativeSurface ?? this.negativeSurface,
    infoSurface: infoSurface ?? this.infoSurface,
    noticeSurface: noticeSurface ?? this.noticeSurface,
    tagBackground: tagBackground ?? this.tagBackground,
    shadow: shadow ?? this.shadow,
    text: text ?? this.text,
    textHover: textHover ?? this.textHover,
    textPress: textPress ?? this.textPress,
    textSecondary: textSecondary ?? this.textSecondary,
    textSecondaryHover: textSecondaryHover ?? this.textSecondaryHover,
    textSecondaryPress: textSecondaryPress ?? this.textSecondaryPress,
    textTertiary: textTertiary ?? this.textTertiary,
    textTertiaryHover: textTertiaryHover ?? this.textTertiaryHover,
    textTertiaryPress: textTertiaryPress ?? this.textTertiaryPress,
    textPlaceholder: textPlaceholder ?? this.textPlaceholder,
    textDisabled: textDisabled ?? this.textDisabled,
    textOnPrimary: textOnPrimary ?? this.textOnPrimary,
    textOnNegative: textOnNegative ?? this.textOnNegative,
    textOnPositive: textOnPositive ?? this.textOnPositive,
    textOnHud: textOnHud ?? this.textOnHud,
    textOnImage: textOnImage ?? this.textOnImage,
    textPositive: textPositive ?? this.textPositive,
    textNegative: textNegative ?? this.textNegative,
    textNotice: textNotice ?? this.textNotice,
    textInfo: textInfo ?? this.textInfo,
    icon: icon ?? this.icon,
    iconHover: iconHover ?? this.iconHover,
    iconPress: iconPress ?? this.iconPress,
    iconSecondary: iconSecondary ?? this.iconSecondary,
    iconTertiary: iconTertiary ?? this.iconTertiary,
    iconTertiaryHover: iconTertiaryHover ?? this.iconTertiaryHover,
    iconTertiaryPress: iconTertiaryPress ?? this.iconTertiaryPress,
    iconDisabled: iconDisabled ?? this.iconDisabled,
    iconPositive: iconPositive ?? this.iconPositive,
    iconNegative: iconNegative ?? this.iconNegative,
    iconNotice: iconNotice ?? this.iconNotice,
    iconOnPrimary: iconOnPrimary ?? this.iconOnPrimary,
    iconOnImage: iconOnImage ?? this.iconOnImage,
    textOnNotice: textOnNotice ?? this.textOnNotice,
    iconOnNotice: iconOnNotice ?? this.iconOnNotice,
    iconHint: iconHint ?? this.iconHint,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'background': background,
    'backgroundSecondary': backgroundSecondary,
    'backgroundTertiary': backgroundTertiary,
    'scrim': scrim,
    'barrier': barrier,
    'pageBackdrop': pageBackdrop,
    'surface': surface,
    'surfaceHover': surfaceHover,
    'surfacePress': surfacePress,
    'surfaceSecondary': surfaceSecondary,
    'surfaceSecondaryHover': surfaceSecondaryHover,
    'surfaceSecondaryPress': surfaceSecondaryPress,
    'surfaceTertiary': surfaceTertiary,
    'surfaceTertiaryPress': surfaceTertiaryPress,
    'surfaceDisabled': surfaceDisabled,
    'fillSecondary': fillSecondary,
    'fillSecondaryHover': fillSecondaryHover,
    'fillSecondaryPress': fillSecondaryPress,
    'restOverlay': restOverlay,
    'hoverOverlay': hoverOverlay,
    'pressOverlay': pressOverlay,
    'skeleton': skeleton,
    'fillOnImage': fillOnImage,
    'fillOnImageHover': fillOnImageHover,
    'fillOnImagePress': fillOnImagePress,
    'hud': hud,
    'hudHover': hudHover,
    'hudPress': hudPress,
    'border': border,
    'borderSubtle': borderSubtle,
    'borderDisabled': borderDisabled,
    'borderNegative': borderNegative,
    'borderSelected': borderSelected,
    'borderFocus': borderFocus,
    'borderHud': borderHud,
    'focusRing': focusRing,
    'focusRingInner': focusRingInner,
    'primary': primary,
    'primaryHover': primaryHover,
    'primaryPress': primaryPress,
    'negative': negative,
    'negativeHover': negativeHover,
    'negativePress': negativePress,
    'positive': positive,
    'notice': notice,
    'neutral': neutral,
    'neutralHover': neutralHover,
    'neutralPress': neutralPress,
    'positiveSurface': positiveSurface,
    'negativeSurface': negativeSurface,
    'infoSurface': infoSurface,
    'noticeSurface': noticeSurface,
    'tagBackground': tagBackground,
    'shadow': shadow,
    'text': text,
    'textHover': textHover,
    'textPress': textPress,
    'textSecondary': textSecondary,
    'textSecondaryHover': textSecondaryHover,
    'textSecondaryPress': textSecondaryPress,
    'textTertiary': textTertiary,
    'textTertiaryHover': textTertiaryHover,
    'textTertiaryPress': textTertiaryPress,
    'textPlaceholder': textPlaceholder,
    'textDisabled': textDisabled,
    'textOnPrimary': textOnPrimary,
    'textOnNegative': textOnNegative,
    'textOnPositive': textOnPositive,
    'textOnHud': textOnHud,
    'textOnImage': textOnImage,
    'textPositive': textPositive,
    'textNegative': textNegative,
    'textNotice': textNotice,
    'textInfo': textInfo,
    'icon': icon,
    'iconHover': iconHover,
    'iconPress': iconPress,
    'iconSecondary': iconSecondary,
    'iconTertiary': iconTertiary,
    'iconTertiaryHover': iconTertiaryHover,
    'iconTertiaryPress': iconTertiaryPress,
    'iconDisabled': iconDisabled,
    'iconPositive': iconPositive,
    'iconNegative': iconNegative,
    'iconNotice': iconNotice,
    'iconOnPrimary': iconOnPrimary,
    'iconOnImage': iconOnImage,
    'textOnNotice': textOnNotice,
    'iconOnNotice': iconOnNotice,
    'iconHint': iconHint,
  };

  /// Inverse of [toMap].
  static CharcoalColorRoles fromMap(Map<String, Object?> map) => CharcoalColorRoles(
    background: map['background']! as Color,
    backgroundSecondary: map['backgroundSecondary']! as Color,
    backgroundTertiary: map['backgroundTertiary']! as Color,
    scrim: map['scrim']! as Color,
    barrier: map['barrier']! as Color,
    pageBackdrop: map['pageBackdrop']! as Color,
    surface: map['surface']! as Color,
    surfaceHover: map['surfaceHover']! as Color,
    surfacePress: map['surfacePress']! as Color,
    surfaceSecondary: map['surfaceSecondary']! as Color,
    surfaceSecondaryHover: map['surfaceSecondaryHover']! as Color,
    surfaceSecondaryPress: map['surfaceSecondaryPress']! as Color,
    surfaceTertiary: map['surfaceTertiary']! as Color,
    surfaceTertiaryPress: map['surfaceTertiaryPress']! as Color,
    surfaceDisabled: map['surfaceDisabled']! as Color,
    fillSecondary: map['fillSecondary']! as Color,
    fillSecondaryHover: map['fillSecondaryHover']! as Color,
    fillSecondaryPress: map['fillSecondaryPress']! as Color,
    restOverlay: map['restOverlay']! as Color,
    hoverOverlay: map['hoverOverlay']! as Color,
    pressOverlay: map['pressOverlay']! as Color,
    skeleton: map['skeleton']! as Color,
    fillOnImage: map['fillOnImage']! as Color,
    fillOnImageHover: map['fillOnImageHover']! as Color,
    fillOnImagePress: map['fillOnImagePress']! as Color,
    hud: map['hud']! as Color,
    hudHover: map['hudHover']! as Color,
    hudPress: map['hudPress']! as Color,
    border: map['border']! as Color,
    borderSubtle: map['borderSubtle']! as Color,
    borderDisabled: map['borderDisabled']! as Color,
    borderNegative: map['borderNegative']! as Color,
    borderSelected: map['borderSelected']! as Color,
    borderFocus: map['borderFocus']! as Color,
    borderHud: map['borderHud']! as Color,
    focusRing: map['focusRing']! as Color,
    focusRingInner: map['focusRingInner']! as Color,
    primary: map['primary']! as Color,
    primaryHover: map['primaryHover']! as Color,
    primaryPress: map['primaryPress']! as Color,
    negative: map['negative']! as Color,
    negativeHover: map['negativeHover']! as Color,
    negativePress: map['negativePress']! as Color,
    positive: map['positive']! as Color,
    notice: map['notice']! as Color,
    neutral: map['neutral']! as Color,
    neutralHover: map['neutralHover']! as Color,
    neutralPress: map['neutralPress']! as Color,
    positiveSurface: map['positiveSurface']! as Color,
    negativeSurface: map['negativeSurface']! as Color,
    infoSurface: map['infoSurface']! as Color,
    noticeSurface: map['noticeSurface']! as Color,
    tagBackground: map['tagBackground']! as Color,
    shadow: map['shadow']! as Color,
    text: map['text']! as Color,
    textHover: map['textHover']! as Color,
    textPress: map['textPress']! as Color,
    textSecondary: map['textSecondary']! as Color,
    textSecondaryHover: map['textSecondaryHover']! as Color,
    textSecondaryPress: map['textSecondaryPress']! as Color,
    textTertiary: map['textTertiary']! as Color,
    textTertiaryHover: map['textTertiaryHover']! as Color,
    textTertiaryPress: map['textTertiaryPress']! as Color,
    textPlaceholder: map['textPlaceholder']! as Color,
    textDisabled: map['textDisabled']! as Color,
    textOnPrimary: map['textOnPrimary']! as Color,
    textOnNegative: map['textOnNegative']! as Color,
    textOnPositive: map['textOnPositive']! as Color,
    textOnHud: map['textOnHud']! as Color,
    textOnImage: map['textOnImage']! as Color,
    textPositive: map['textPositive']! as Color,
    textNegative: map['textNegative']! as Color,
    textNotice: map['textNotice']! as Color,
    textInfo: map['textInfo']! as Color,
    icon: map['icon']! as Color,
    iconHover: map['iconHover']! as Color,
    iconPress: map['iconPress']! as Color,
    iconSecondary: map['iconSecondary']! as Color,
    iconTertiary: map['iconTertiary']! as Color,
    iconTertiaryHover: map['iconTertiaryHover']! as Color,
    iconTertiaryPress: map['iconTertiaryPress']! as Color,
    iconDisabled: map['iconDisabled']! as Color,
    iconPositive: map['iconPositive']! as Color,
    iconNegative: map['iconNegative']! as Color,
    iconNotice: map['iconNotice']! as Color,
    iconOnPrimary: map['iconOnPrimary']! as Color,
    iconOnImage: map['iconOnImage']! as Color,
    textOnNotice: map['textOnNotice']! as Color,
    iconOnNotice: map['iconOnNotice']! as Color,
    iconHint: map['iconHint']! as Color,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalColorRoles &&
          other.background == background &&
          other.backgroundSecondary == backgroundSecondary &&
          other.backgroundTertiary == backgroundTertiary &&
          other.scrim == scrim &&
          other.barrier == barrier &&
          other.pageBackdrop == pageBackdrop &&
          other.surface == surface &&
          other.surfaceHover == surfaceHover &&
          other.surfacePress == surfacePress &&
          other.surfaceSecondary == surfaceSecondary &&
          other.surfaceSecondaryHover == surfaceSecondaryHover &&
          other.surfaceSecondaryPress == surfaceSecondaryPress &&
          other.surfaceTertiary == surfaceTertiary &&
          other.surfaceTertiaryPress == surfaceTertiaryPress &&
          other.surfaceDisabled == surfaceDisabled &&
          other.fillSecondary == fillSecondary &&
          other.fillSecondaryHover == fillSecondaryHover &&
          other.fillSecondaryPress == fillSecondaryPress &&
          other.restOverlay == restOverlay &&
          other.hoverOverlay == hoverOverlay &&
          other.pressOverlay == pressOverlay &&
          other.skeleton == skeleton &&
          other.fillOnImage == fillOnImage &&
          other.fillOnImageHover == fillOnImageHover &&
          other.fillOnImagePress == fillOnImagePress &&
          other.hud == hud &&
          other.hudHover == hudHover &&
          other.hudPress == hudPress &&
          other.border == border &&
          other.borderSubtle == borderSubtle &&
          other.borderDisabled == borderDisabled &&
          other.borderNegative == borderNegative &&
          other.borderSelected == borderSelected &&
          other.borderFocus == borderFocus &&
          other.borderHud == borderHud &&
          other.focusRing == focusRing &&
          other.focusRingInner == focusRingInner &&
          other.primary == primary &&
          other.primaryHover == primaryHover &&
          other.primaryPress == primaryPress &&
          other.negative == negative &&
          other.negativeHover == negativeHover &&
          other.negativePress == negativePress &&
          other.positive == positive &&
          other.notice == notice &&
          other.neutral == neutral &&
          other.neutralHover == neutralHover &&
          other.neutralPress == neutralPress &&
          other.positiveSurface == positiveSurface &&
          other.negativeSurface == negativeSurface &&
          other.infoSurface == infoSurface &&
          other.noticeSurface == noticeSurface &&
          other.tagBackground == tagBackground &&
          other.shadow == shadow &&
          other.text == text &&
          other.textHover == textHover &&
          other.textPress == textPress &&
          other.textSecondary == textSecondary &&
          other.textSecondaryHover == textSecondaryHover &&
          other.textSecondaryPress == textSecondaryPress &&
          other.textTertiary == textTertiary &&
          other.textTertiaryHover == textTertiaryHover &&
          other.textTertiaryPress == textTertiaryPress &&
          other.textPlaceholder == textPlaceholder &&
          other.textDisabled == textDisabled &&
          other.textOnPrimary == textOnPrimary &&
          other.textOnNegative == textOnNegative &&
          other.textOnPositive == textOnPositive &&
          other.textOnHud == textOnHud &&
          other.textOnImage == textOnImage &&
          other.textPositive == textPositive &&
          other.textNegative == textNegative &&
          other.textNotice == textNotice &&
          other.textInfo == textInfo &&
          other.icon == icon &&
          other.iconHover == iconHover &&
          other.iconPress == iconPress &&
          other.iconSecondary == iconSecondary &&
          other.iconTertiary == iconTertiary &&
          other.iconTertiaryHover == iconTertiaryHover &&
          other.iconTertiaryPress == iconTertiaryPress &&
          other.iconDisabled == iconDisabled &&
          other.iconPositive == iconPositive &&
          other.iconNegative == iconNegative &&
          other.iconNotice == iconNotice &&
          other.iconOnPrimary == iconOnPrimary &&
          other.iconOnImage == iconOnImage &&
          other.textOnNotice == textOnNotice &&
          other.iconOnNotice == iconOnNotice &&
          other.iconHint == iconHint;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    background,
    backgroundSecondary,
    backgroundTertiary,
    scrim,
    barrier,
    pageBackdrop,
    surface,
    surfaceHover,
    surfacePress,
    surfaceSecondary,
    surfaceSecondaryHover,
    surfaceSecondaryPress,
    surfaceTertiary,
    surfaceTertiaryPress,
    surfaceDisabled,
    fillSecondary,
    fillSecondaryHover,
    fillSecondaryPress,
    restOverlay,
    hoverOverlay,
    pressOverlay,
    skeleton,
    fillOnImage,
    fillOnImageHover,
    fillOnImagePress,
    hud,
    hudHover,
    hudPress,
    border,
    borderSubtle,
    borderDisabled,
    borderNegative,
    borderSelected,
    borderFocus,
    borderHud,
    focusRing,
    focusRingInner,
    primary,
    primaryHover,
    primaryPress,
    negative,
    negativeHover,
    negativePress,
    positive,
    notice,
    neutral,
    neutralHover,
    neutralPress,
    positiveSurface,
    negativeSurface,
    infoSurface,
    noticeSurface,
    tagBackground,
    shadow,
    text,
    textHover,
    textPress,
    textSecondary,
    textSecondaryHover,
    textSecondaryPress,
    textTertiary,
    textTertiaryHover,
    textTertiaryPress,
    textPlaceholder,
    textDisabled,
    textOnPrimary,
    textOnNegative,
    textOnPositive,
    textOnHud,
    textOnImage,
    textPositive,
    textNegative,
    textNotice,
    textInfo,
    icon,
    iconHover,
    iconPress,
    iconSecondary,
    iconTertiary,
    iconTertiaryHover,
    iconTertiaryPress,
    iconDisabled,
    iconPositive,
    iconNegative,
    iconNotice,
    iconOnPrimary,
    iconOnImage,
    textOnNotice,
    iconOnNotice,
    iconHint,
  ]);
}
