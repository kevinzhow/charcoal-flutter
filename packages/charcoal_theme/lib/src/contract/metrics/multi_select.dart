// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Multi-select selection box.
@immutable
class CharcoalMultiSelectMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalMultiSelectMetrics({
    required this.controlSize,
    required this.outerOffset,
    required this.checkSize,
  });

  /// Box edge.
  final double controlSize;

  /// Distance from the box to the focus ring.
  final double outerOffset;

  /// Check glyph edge.
  final double checkSize;

  /// A copy with the given fields replaced.
  CharcoalMultiSelectMetrics copyWith({
    double? controlSize,
    double? outerOffset,
    double? checkSize,
  }) => CharcoalMultiSelectMetrics(
    controlSize: controlSize ?? this.controlSize,
    outerOffset: outerOffset ?? this.outerOffset,
    checkSize: checkSize ?? this.checkSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'controlSize': controlSize,
    'outerOffset': outerOffset,
    'checkSize': checkSize,
  };

  /// Inverse of [toMap].
  static CharcoalMultiSelectMetrics fromMap(Map<String, Object?> map) => CharcoalMultiSelectMetrics(
    controlSize: map['controlSize']! as double,
    outerOffset: map['outerOffset']! as double,
    checkSize: map['checkSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalMultiSelectMetrics &&
          other.controlSize == controlSize &&
          other.outerOffset == outerOffset &&
          other.checkSize == checkSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    controlSize,
    outerOffset,
    checkSize,
  ]);
}
