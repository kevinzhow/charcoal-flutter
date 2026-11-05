// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Geometry of the pill button beyond the shared control heights.
@immutable
class CharcoalButtonMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalButtonMetrics({
    required this.iconSize,
    required this.smallVerticalPadding,
    required this.mediumVerticalPadding,
  });

  /// Leading and trailing icon edge.
  final double iconSize;

  /// Vertical padding of a small button.
  final double smallVerticalPadding;

  /// Vertical padding of a medium button.
  final double mediumVerticalPadding;

  /// A copy with the given fields replaced.
  CharcoalButtonMetrics copyWith({
    double? iconSize,
    double? smallVerticalPadding,
    double? mediumVerticalPadding,
  }) => CharcoalButtonMetrics(
    iconSize: iconSize ?? this.iconSize,
    smallVerticalPadding: smallVerticalPadding ?? this.smallVerticalPadding,
    mediumVerticalPadding: mediumVerticalPadding ?? this.mediumVerticalPadding,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'iconSize': iconSize,
    'smallVerticalPadding': smallVerticalPadding,
    'mediumVerticalPadding': mediumVerticalPadding,
  };

  /// Inverse of [toMap].
  static CharcoalButtonMetrics fromMap(Map<String, Object?> map) => CharcoalButtonMetrics(
    iconSize: map['iconSize']! as double,
    smallVerticalPadding: map['smallVerticalPadding']! as double,
    mediumVerticalPadding: map['mediumVerticalPadding']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalButtonMetrics &&
          other.iconSize == iconSize &&
          other.smallVerticalPadding == smallVerticalPadding &&
          other.mediumVerticalPadding == mediumVerticalPadding;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    iconSize,
    smallVerticalPadding,
    mediumVerticalPadding,
  ]);
}
