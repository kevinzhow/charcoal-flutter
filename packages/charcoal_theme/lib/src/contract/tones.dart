// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'dart:ui' show Color;

import 'package:flutter/foundation.dart' show immutable;

import 'colors.dart';

/// Semantic status tone shared by every chip, dot, banner and toast.
enum CharcoalTone {
  /// Success.
  positive,

  /// Error or destructive.
  negative,

  /// Information.
  info,

  /// Warning.
  notice,

  /// No status.
  neutral,
}

/// The colours one [CharcoalTone] resolves to.
@immutable
class CharcoalToneColors {
  /// Creates a resolved tone.
  const CharcoalToneColors({
    required this.surface,
    required this.foreground,
    required this.dot,
    required this.icon,
  });

  /// Pale chip / banner background.
  final Color surface;

  /// Text on [surface].
  final Color foreground;

  /// Solid status dot.
  final Color dot;

  /// Banner icon.
  final Color icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalToneColors &&
          other.surface == surface &&
          other.foreground == foreground &&
          other.dot == dot &&
          other.icon == icon;

  @override
  int get hashCode => Object.hash(surface, foreground, dot, icon);
}

/// Tones are resolved from colour roles, never stored: a pack cannot give a tone its own colours.
CharcoalToneColors resolveCharcoalTone(CharcoalColorRoles colors, CharcoalTone tone) =>
    switch (tone) {
      CharcoalTone.positive => CharcoalToneColors(
        surface: colors.positiveSurface,
        foreground: colors.textPositive,
        dot: colors.positive,
        icon: colors.iconPositive,
      ),
      CharcoalTone.negative => CharcoalToneColors(
        surface: colors.negativeSurface,
        foreground: colors.textNegative,
        dot: colors.negative,
        icon: colors.iconNegative,
      ),
      CharcoalTone.info => CharcoalToneColors(
        surface: colors.infoSurface,
        foreground: colors.textInfo,
        dot: colors.primary,
        icon: colors.textInfo,
      ),
      CharcoalTone.notice => CharcoalToneColors(
        surface: colors.noticeSurface,
        foreground: colors.textNotice,
        dot: colors.iconNotice,
        icon: colors.iconNotice,
      ),
      CharcoalTone.neutral => CharcoalToneColors(
        surface: colors.surfaceSecondary,
        foreground: colors.textSecondary,
        dot: colors.neutral,
        icon: colors.iconSecondary,
      ),
    };
