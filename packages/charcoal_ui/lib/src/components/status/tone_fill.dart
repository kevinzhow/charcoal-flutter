import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The solid fill of [tone] and the colours of text and icons drawn on it, as on a toned
/// `CharcoalAvatar` or a `CharcoalModeBar`.
({Color fill, Color text, Color icon}) charcoalToneFill(
  CharcoalColorRoles colors,
  CharcoalTone tone,
) => switch (tone) {
  CharcoalTone.info => (
    fill: colors.primary,
    text: colors.textOnPrimary,
    icon: colors.iconOnPrimary,
  ),
  CharcoalTone.negative => (
    fill: colors.negative,
    text: colors.textOnNegative,
    icon: colors.textOnNegative,
  ),
  CharcoalTone.positive => (
    fill: colors.positive,
    text: colors.textOnPositive,
    icon: colors.textOnPositive,
  ),
  CharcoalTone.notice => (
    fill: colors.notice,
    text: colors.textOnNotice,
    icon: colors.iconOnNotice,
  ),
  CharcoalTone.neutral => (
    fill: colors.neutral,
    text: colors.textOnPrimary,
    icon: colors.iconOnPrimary,
  ),
};
