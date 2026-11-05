// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Radio button.
@immutable
class CharcoalRadioMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalRadioMetrics({
    required this.controlSize,
    required this.dotSize,
  });

  /// Outer circle diameter.
  final double controlSize;

  /// Selected dot diameter.
  final double dotSize;

  /// A copy with the given fields replaced.
  CharcoalRadioMetrics copyWith({
    double? controlSize,
    double? dotSize,
  }) => CharcoalRadioMetrics(
    controlSize: controlSize ?? this.controlSize,
    dotSize: dotSize ?? this.dotSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'controlSize': controlSize,
    'dotSize': dotSize,
  };

  /// Inverse of [toMap].
  static CharcoalRadioMetrics fromMap(Map<String, Object?> map) => CharcoalRadioMetrics(
    controlSize: map['controlSize']! as double,
    dotSize: map['dotSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalRadioMetrics && other.controlSize == controlSize && other.dotSize == dotSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    controlSize,
    dotSize,
  ]);
}
