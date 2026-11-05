// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Segmented control.
@immutable
class CharcoalSegmentedMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalSegmentedMetrics({
    required this.uniformSegmentMinWidth,
  });

  /// Minimum width of a segment in uniform layout.
  final double uniformSegmentMinWidth;

  /// A copy with the given fields replaced.
  CharcoalSegmentedMetrics copyWith({
    double? uniformSegmentMinWidth,
  }) => CharcoalSegmentedMetrics(
    uniformSegmentMinWidth: uniformSegmentMinWidth ?? this.uniformSegmentMinWidth,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'uniformSegmentMinWidth': uniformSegmentMinWidth,
  };

  /// Inverse of [toMap].
  static CharcoalSegmentedMetrics fromMap(Map<String, Object?> map) => CharcoalSegmentedMetrics(
    uniformSegmentMinWidth: map['uniformSegmentMinWidth']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalSegmentedMetrics && other.uniformSegmentMinWidth == uniformSegmentMinWidth;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    uniformSegmentMinWidth,
  ]);
}
