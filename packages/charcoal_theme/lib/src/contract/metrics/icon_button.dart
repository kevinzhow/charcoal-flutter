// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Icon-button hit areas and glyph sizes.
@immutable
class CharcoalIconButtonMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalIconButtonMetrics({
    required this.extraSmallSize,
    required this.smallIconSize,
    required this.regularIconSize,
  });

  /// Edge of the extra-small icon button.
  final double extraSmallSize;

  /// Glyph size of the small icon button.
  final double smallIconSize;

  /// Glyph size of the regular icon button.
  final double regularIconSize;

  /// A copy with the given fields replaced.
  CharcoalIconButtonMetrics copyWith({
    double? extraSmallSize,
    double? smallIconSize,
    double? regularIconSize,
  }) => CharcoalIconButtonMetrics(
    extraSmallSize: extraSmallSize ?? this.extraSmallSize,
    smallIconSize: smallIconSize ?? this.smallIconSize,
    regularIconSize: regularIconSize ?? this.regularIconSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'extraSmallSize': extraSmallSize,
    'smallIconSize': smallIconSize,
    'regularIconSize': regularIconSize,
  };

  /// Inverse of [toMap].
  static CharcoalIconButtonMetrics fromMap(Map<String, Object?> map) => CharcoalIconButtonMetrics(
    extraSmallSize: map['extraSmallSize']! as double,
    smallIconSize: map['smallIconSize']! as double,
    regularIconSize: map['regularIconSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalIconButtonMetrics &&
          other.extraSmallSize == extraSmallSize &&
          other.smallIconSize == smallIconSize &&
          other.regularIconSize == regularIconSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    extraSmallSize,
    smallIconSize,
    regularIconSize,
  ]);
}
