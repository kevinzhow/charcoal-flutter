// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only.

import 'package:flutter/material.dart';

import 'contract/borders.dart';
import 'contract/colors.dart';
import 'contract/elevation.dart';
import 'contract/metrics/metrics.dart';
import 'contract/motion.dart';
import 'contract/radius.dart';
import 'contract/sizes.dart';
import 'contract/space.dart';
import 'contract/tones.dart';
import 'contract/typography.dart';
import 'pack.dart';

/// The theme pack, injected into `ThemeData.extensions`.
///
/// Material's `ThemeData` carries what Material has slots for; this carries the rest (status
/// tones, sizes, type roles, per-family metrics) and is how every Charcoal widget reads its
/// values. Obtain it with [CharcoalTheme.of].
class CharcoalTheme extends ThemeExtension<CharcoalTheme> {
  /// Wraps [pack]. [platform] selects the system font family for type roles.
  const CharcoalTheme(this.pack, {this.platform = TargetPlatform.android});

  /// The values.
  final CharcoalThemePack pack;

  /// Platform the type roles resolve system fonts for.
  final TargetPlatform platform;

  /// The theme in [context]; asserts when `ThemeData.extensions` has none.
  static CharcoalTheme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(theme != null, 'No CharcoalTheme in ThemeData.extensions.');
    return theme!;
  }

  /// The theme in [context], or null.
  static CharcoalTheme? maybeOf(BuildContext context) =>
      Theme.of(context).extension<CharcoalTheme>();

  /// Semantic colour roles.
  CharcoalColorRoles get colors => pack.colors;

  /// Spacing steps.
  CharcoalSpaceScale get space => pack.space;

  /// Corner radii.
  CharcoalRadiusScale get radius => pack.radius;

  /// Line widths.
  CharcoalBorderScale get borders => pack.borders;

  /// Component and layout sizes.
  CharcoalSizeScale get sizes => pack.sizes;

  /// Durations and curves.
  CharcoalMotionScale get motion => pack.motion;

  /// Resting elevations.
  CharcoalElevationScale get elevation => pack.elevation;

  /// Type roles and font families.
  CharcoalTypeScale get typography => pack.typography;

  /// Per-family component geometry.
  CharcoalMetrics get metrics => pack.metrics;

  /// Brightness of the pack.
  Brightness get brightness => pack.brightness;

  /// A [Duration] that honours the platform's reduce-motion setting.
  Duration duration(BuildContext context, Duration base) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : base;

  /// The colours for [tone].
  CharcoalToneColors tone(CharcoalTone tone) => resolveCharcoalTone(colors, tone);

  /// The colour a role uses when the caller does not pass one.
  Color defaultTextColor(CharcoalTextRole role) => switch (role) {
    CharcoalTextRole.caption ||
    CharcoalTextRole.captionBold ||
    CharcoalTextRole.captionMono => colors.textTertiary,
    _ => colors.text,
  };

  /// The [TextStyle] for [role], coloured with [color] or the role's default.
  ///
  /// [bold] forces the pack's bold weight; [mono] switches to the monospace family. Only size and
  /// a height multiplier are set, so the style follows the text scaler.
  TextStyle style(CharcoalTextRole role, {Color? color, bool bold = false, bool mono = false}) {
    final spec = typography.spec(role);
    final monospace = mono || role == CharcoalTextRole.captionMono;
    return TextStyle(
      color: color ?? defaultTextColor(role),
      fontFamily: monospace
          ? typography.monoFamily
          : typography.sansFamilyFor(spec.fontSize, platform),
      fontSize: spec.fontSize,
      fontWeight: bold ? typography.weightBold : spec.weight,
      height: monospace ? null : spec.lineHeight / spec.fontSize,
      leadingDistribution: monospace ? null : TextLeadingDistribution.even,
    );
  }

  @override
  CharcoalTheme copyWith({CharcoalThemePack? pack, TargetPlatform? platform}) =>
      CharcoalTheme(pack ?? this.pack, platform: platform ?? this.platform);

  /// Packs are not interpolated: the theme switches at the animation's midpoint, which is what
  /// Material's own discrete properties do. Colours still cross-fade because `ThemeData` lerps
  /// its `ColorScheme`.
  @override
  CharcoalTheme lerp(covariant CharcoalTheme? other, double t) =>
      other == null || t < 0.5 ? this : other;
}
