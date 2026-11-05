import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The semantic colour of a run of text.
///
/// A tone names a text colour role of the active pack, so application code says what the text
/// means (a secondary line, an error) and never which colour it is.
enum CharcoalTextTone {
  /// `colors.text`, the default reading colour.
  primary,

  /// `colors.textSecondary`: supporting lines and descriptions.
  secondary,

  /// `colors.textTertiary`: hints, metadata and the quietest readable text.
  tertiary,

  /// `colors.textPlaceholder`: empty-field text.
  placeholder,

  /// `colors.textDisabled`: text of an unavailable control.
  disabled,

  /// `colors.textPositive`: success.
  positive,

  /// `colors.textNegative`: errors and destructive actions.
  negative,

  /// `colors.textNotice`: warnings.
  notice,

  /// `colors.textInfo`: information and links.
  info,

  /// `colors.primary`: the brand accent, for emphasised text.
  accent,

  /// `colors.textOnPrimary`: text on a primary-coloured surface.
  onPrimary,

  /// `colors.textOnNegative`: text on a negative-coloured surface.
  onNegative,

  /// `colors.textOnPositive`: text on a positive-coloured surface.
  onPositive,

  /// `colors.textOnHud`: text on a heads-up surface.
  onHud,

  /// `colors.textOnImage`: text over imagery.
  onImage;

  /// The colour this tone resolves to in [colors].
  Color resolve(CharcoalColorRoles colors) => switch (this) {
    CharcoalTextTone.primary => colors.text,
    CharcoalTextTone.secondary => colors.textSecondary,
    CharcoalTextTone.tertiary => colors.textTertiary,
    CharcoalTextTone.placeholder => colors.textPlaceholder,
    CharcoalTextTone.disabled => colors.textDisabled,
    CharcoalTextTone.positive => colors.textPositive,
    CharcoalTextTone.negative => colors.textNegative,
    CharcoalTextTone.notice => colors.textNotice,
    CharcoalTextTone.info => colors.textInfo,
    CharcoalTextTone.accent => colors.primary,
    CharcoalTextTone.onPrimary => colors.textOnPrimary,
    CharcoalTextTone.onNegative => colors.textOnNegative,
    CharcoalTextTone.onPositive => colors.textOnPositive,
    CharcoalTextTone.onHud => colors.textOnHud,
    CharcoalTextTone.onImage => colors.textOnImage,
  };
}
