// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Loading spinner and its overlay.
@immutable
class CharcoalSpinnerMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalSpinnerMetrics({
    required this.rotationDuration,
    required this.shadowBlur,
    required this.inlineSize,
  });

  /// One revolution.
  final Duration rotationDuration;

  /// Blur radius of the floating shadow.
  final double shadowBlur;

  /// Edge of the inline spinner that sits beside a line of small text.
  final double inlineSize;

  /// A copy with the given fields replaced.
  CharcoalSpinnerMetrics copyWith({
    Duration? rotationDuration,
    double? shadowBlur,
    double? inlineSize,
  }) => CharcoalSpinnerMetrics(
    rotationDuration: rotationDuration ?? this.rotationDuration,
    shadowBlur: shadowBlur ?? this.shadowBlur,
    inlineSize: inlineSize ?? this.inlineSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'rotationDuration': rotationDuration,
    'shadowBlur': shadowBlur,
    'inlineSize': inlineSize,
  };

  /// Inverse of [toMap].
  static CharcoalSpinnerMetrics fromMap(Map<String, Object?> map) => CharcoalSpinnerMetrics(
    rotationDuration: map['rotationDuration']! as Duration,
    shadowBlur: map['shadowBlur']! as double,
    inlineSize: map['inlineSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalSpinnerMetrics &&
          other.rotationDuration == rotationDuration &&
          other.shadowBlur == shadowBlur &&
          other.inlineSize == inlineSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    rotationDuration,
    shadowBlur,
    inlineSize,
  ]);
}
