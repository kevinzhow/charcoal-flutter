/// Test support: packs that prove widgets read the theme instead of hard-coding values.
///
/// Placeholder from batch 1.1; batch 1B wires it into the extreme-theme scenes.
library;

import 'dart:ui' show Brightness, Color;

import 'package:flutter/animation.dart' show Curve, Curves;
import 'package:flutter/painting.dart' show FontWeight, HSVColor;

import 'charcoal_theme.dart';

/// A pack whose every colour role is a distinct, opaque, highly saturated colour and whose numbers
/// are ones no real pack uses.
///
/// Numbers are scaled (x1.37 for sizes, x0.77 for fractions, +2 for counts, x1.37 ms for
/// durations); zero elevations become 3. A widget that renders a colour outside this set, or a
/// size that did not move, is reading something other than the theme.
///
/// [base] defaults to the temporary pack of [brightness].
CharcoalThemePack extremePack(Brightness brightness, {CharcoalThemePack? base}) {
  final source = base ?? (brightness == Brightness.dark ? temporaryDarkPack : temporaryLightPack);
  final roleNames = source.colors.toMap().keys.toList();
  return CharcoalThemePack(
    name: 'extreme',
    brightness: brightness,
    colors: CharcoalColorRoles.fromMap(<String, Object?>{
      for (var i = 0; i < roleNames.length; i++) roleNames[i]: _extremeColor(i),
    }),
    space: CharcoalSpaceScale.fromMap(_perturb(source.space.toMap())),
    radius: CharcoalRadiusScale.fromMap(_perturb(source.radius.toMap())),
    borders: CharcoalBorderScale.fromMap(_perturb(source.borders.toMap())),
    sizes: CharcoalSizeScale.fromMap(_perturb(source.sizes.toMap())),
    motion: CharcoalMotionScale.fromMap(_perturb(source.motion.toMap())),
    elevation: CharcoalElevationScale.fromMap(_perturb(source.elevation.toMap())),
    typography: source.typography
        .mapSpecs(
          (spec) => spec.copyWith(
            fontSize: spec.fontSize * 1.37,
            lineHeight: spec.lineHeight * 1.37 + 3,
            weight: spec.weight == FontWeight.w700 ? FontWeight.w900 : FontWeight.w300,
          ),
        )
        .copyWith(
          weightRegular: FontWeight.w300,
          weightBold: FontWeight.w900,
          appleDisplayFrom: source.typography.appleDisplayFrom * 1.37,
        ),
    metrics: CharcoalMetrics.fromMap(<String, Map<String, Object?>>{
      for (final family in source.metrics.toMap().entries) family.key: _perturb(family.value),
    }),
  );
}

Color _extremeColor(int index) {
  // Golden-ratio hue steps keep neighbours far apart; two brightness levels separate the wrap-around.
  final hue = (index * 137.50776405) % 360;
  return HSVColor.fromAHSV(1, hue, 1, index.isEven ? 0.95 : 0.6).toColor();
}

Map<String, Object?> _perturb(Map<String, Object?> values) => <String, Object?>{
  for (final entry in values.entries) entry.key: _perturbValue(entry.value),
};

Object? _perturbValue(Object? value) {
  if (value is Duration) {
    return Duration(microseconds: (value.inMicroseconds * 1.37).round());
  }
  if (value is Curve) {
    return value == Curves.easeInOutCubic ? Curves.decelerate : Curves.easeInOutCubic;
  }
  if (value is int) return value + 2;
  if (value is double) {
    if (value == 0) return 3.0;
    return value.abs() < 1 ? value * 0.77 : value * 1.37;
  }
  return value;
}
