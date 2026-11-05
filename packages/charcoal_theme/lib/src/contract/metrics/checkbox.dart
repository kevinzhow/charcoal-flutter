// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Checkbox box, check glyph and focus offsets.
@immutable
class CharcoalCheckboxMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalCheckboxMetrics({
    required this.controlSize,
    required this.roundedRadius,
    required this.checkSize,
    required this.roundedFocusHaloWidth,
    required this.outerOffset,
  });

  /// Box edge.
  final double controlSize;

  /// Corner radius of the rounded variant.
  final double roundedRadius;

  /// Check glyph edge.
  final double checkSize;

  /// Focus halo width of the rounded variant.
  final double roundedFocusHaloWidth;

  /// Distance from the box to the focus ring.
  final double outerOffset;

  /// A copy with the given fields replaced.
  CharcoalCheckboxMetrics copyWith({
    double? controlSize,
    double? roundedRadius,
    double? checkSize,
    double? roundedFocusHaloWidth,
    double? outerOffset,
  }) => CharcoalCheckboxMetrics(
    controlSize: controlSize ?? this.controlSize,
    roundedRadius: roundedRadius ?? this.roundedRadius,
    checkSize: checkSize ?? this.checkSize,
    roundedFocusHaloWidth: roundedFocusHaloWidth ?? this.roundedFocusHaloWidth,
    outerOffset: outerOffset ?? this.outerOffset,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'controlSize': controlSize,
    'roundedRadius': roundedRadius,
    'checkSize': checkSize,
    'roundedFocusHaloWidth': roundedFocusHaloWidth,
    'outerOffset': outerOffset,
  };

  /// Inverse of [toMap].
  static CharcoalCheckboxMetrics fromMap(Map<String, Object?> map) => CharcoalCheckboxMetrics(
    controlSize: map['controlSize']! as double,
    roundedRadius: map['roundedRadius']! as double,
    checkSize: map['checkSize']! as double,
    roundedFocusHaloWidth: map['roundedFocusHaloWidth']! as double,
    outerOffset: map['outerOffset']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalCheckboxMetrics &&
          other.controlSize == controlSize &&
          other.roundedRadius == roundedRadius &&
          other.checkSize == checkSize &&
          other.roundedFocusHaloWidth == roundedFocusHaloWidth &&
          other.outerOffset == outerOffset;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    controlSize,
    roundedRadius,
    checkSize,
    roundedFocusHaloWidth,
    outerOffset,
  ]);
}
