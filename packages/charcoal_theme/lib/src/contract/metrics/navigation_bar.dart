// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Top navigation bar.
@immutable
class CharcoalNavigationBarMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalNavigationBarMetrics({
    required this.height,
    required this.minTitleExtent,
    required this.titleScaleBase,
    required this.verticalChrome,
  });

  /// Bar height at text scale 1.
  final double height;

  /// Least title width.
  final double minTitleExtent;

  /// Title size scaled by the text scaler to grow the bar.
  final double titleScaleBase;

  /// Padding added to the scaled title to get the bar height.
  final double verticalChrome;

  /// A copy with the given fields replaced.
  CharcoalNavigationBarMetrics copyWith({
    double? height,
    double? minTitleExtent,
    double? titleScaleBase,
    double? verticalChrome,
  }) => CharcoalNavigationBarMetrics(
    height: height ?? this.height,
    minTitleExtent: minTitleExtent ?? this.minTitleExtent,
    titleScaleBase: titleScaleBase ?? this.titleScaleBase,
    verticalChrome: verticalChrome ?? this.verticalChrome,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'height': height,
    'minTitleExtent': minTitleExtent,
    'titleScaleBase': titleScaleBase,
    'verticalChrome': verticalChrome,
  };

  /// Inverse of [toMap].
  static CharcoalNavigationBarMetrics fromMap(Map<String, Object?> map) =>
      CharcoalNavigationBarMetrics(
        height: map['height']! as double,
        minTitleExtent: map['minTitleExtent']! as double,
        titleScaleBase: map['titleScaleBase']! as double,
        verticalChrome: map['verticalChrome']! as double,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalNavigationBarMetrics &&
          other.height == height &&
          other.minTitleExtent == minTitleExtent &&
          other.titleScaleBase == titleScaleBase &&
          other.verticalChrome == verticalChrome;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    height,
    minTitleExtent,
    titleScaleBase,
    verticalChrome,
  ]);
}
