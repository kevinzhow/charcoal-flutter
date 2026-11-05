// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only.

import 'dart:ui' show Brightness;

import 'package:flutter/foundation.dart' show immutable;

import 'contract/borders.dart';
import 'contract/colors.dart';
import 'contract/elevation.dart';
import 'contract/metrics/metrics.dart';
import 'contract/motion.dart';
import 'contract/radius.dart';
import 'contract/sizes.dart';
import 'contract/space.dart';
import 'contract/typography.dart';

/// A complete set of theme values: one look, in one brightness.
///
/// The pack is the only thing that differs between looks. Every widget reads it through
/// `CharcoalTheme`; no widget branches on a pack's name.
@immutable
class CharcoalThemePack {
  /// Creates a pack. Every group is required.
  const CharcoalThemePack({
    required this.name,
    required this.brightness,
    required this.colors,
    required this.space,
    required this.radius,
    required this.borders,
    required this.sizes,
    required this.motion,
    required this.elevation,
    required this.typography,
    required this.metrics,
  });

  /// Pack name for diagnostics. Never branch on it.
  final String name;

  /// Brightness the colours are written for.
  final Brightness brightness;

  /// Semantic colour roles.
  final CharcoalColorRoles colors;

  /// Spacing steps.
  final CharcoalSpaceScale space;

  /// Corner radii.
  final CharcoalRadiusScale radius;

  /// Line widths.
  final CharcoalBorderScale borders;

  /// Component and layout sizes.
  final CharcoalSizeScale sizes;

  /// Durations and curves.
  final CharcoalMotionScale motion;

  /// Resting elevations.
  final CharcoalElevationScale elevation;

  /// Type roles and font families.
  final CharcoalTypeScale typography;

  /// Per-family component geometry.
  final CharcoalMetrics metrics;

  /// A copy with the given groups replaced; the base for derived packs.
  CharcoalThemePack copyWith({
    String? name,
    Brightness? brightness,
    CharcoalColorRoles? colors,
    CharcoalSpaceScale? space,
    CharcoalRadiusScale? radius,
    CharcoalBorderScale? borders,
    CharcoalSizeScale? sizes,
    CharcoalMotionScale? motion,
    CharcoalElevationScale? elevation,
    CharcoalTypeScale? typography,
    CharcoalMetrics? metrics,
  }) => CharcoalThemePack(
    name: name ?? this.name,
    brightness: brightness ?? this.brightness,
    colors: colors ?? this.colors,
    space: space ?? this.space,
    radius: radius ?? this.radius,
    borders: borders ?? this.borders,
    sizes: sizes ?? this.sizes,
    motion: motion ?? this.motion,
    elevation: elevation ?? this.elevation,
    typography: typography ?? this.typography,
    metrics: metrics ?? this.metrics,
  );

  /// Every contract value under its dotted name, e.g. `colors.primary`, `space.xs`,
  /// `typography.body.fontSize`, `metrics.button.iconSize`. For tests and the role audit.
  Map<String, Object?> toFlatMap() {
    final flat = <String, Object?>{};
    void add(String group, Map<String, Object?> values) {
      for (final entry in values.entries) {
        flat['$group.${entry.key}'] = entry.value;
      }
    }

    add('colors', colors.toMap());
    add('space', space.toMap());
    add('radius', radius.toMap());
    add('borders', borders.toMap());
    add('sizes', sizes.toMap());
    add('motion', motion.toMap());
    add('elevation', elevation.toMap());
    add('typography', typography.toMap());
    for (final family in metrics.toMap().entries) {
      add('metrics.${family.key}', family.value);
    }
    return flat;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalThemePack &&
          other.name == name &&
          other.brightness == brightness &&
          other.colors == colors &&
          other.space == space &&
          other.radius == radius &&
          other.borders == borders &&
          other.sizes == sizes &&
          other.motion == motion &&
          other.elevation == elevation &&
          other.typography == typography &&
          other.metrics == metrics;

  @override
  int get hashCode => Object.hash(
    name,
    brightness,
    colors,
    space,
    radius,
    borders,
    sizes,
    motion,
    elevation,
    typography,
    metrics,
  );
}
