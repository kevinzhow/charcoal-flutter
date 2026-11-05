// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Field label and secondary label.
@immutable
class CharcoalFieldMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalFieldMetrics({
    required this.compactBreakpoint,
    required this.lineHeight,
    required this.textScaleClampMax,
    required this.secondaryMaxWidthFraction,
  });

  /// Width below which the label stacks.
  final double compactBreakpoint;

  /// Label line height before text scaling.
  final double lineHeight;

  /// Largest text-scale factor applied to label gaps.
  final double textScaleClampMax;

  /// Share of the row the secondary label may take.
  final double secondaryMaxWidthFraction;

  /// A copy with the given fields replaced.
  CharcoalFieldMetrics copyWith({
    double? compactBreakpoint,
    double? lineHeight,
    double? textScaleClampMax,
    double? secondaryMaxWidthFraction,
  }) => CharcoalFieldMetrics(
    compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
    lineHeight: lineHeight ?? this.lineHeight,
    textScaleClampMax: textScaleClampMax ?? this.textScaleClampMax,
    secondaryMaxWidthFraction: secondaryMaxWidthFraction ?? this.secondaryMaxWidthFraction,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'compactBreakpoint': compactBreakpoint,
    'lineHeight': lineHeight,
    'textScaleClampMax': textScaleClampMax,
    'secondaryMaxWidthFraction': secondaryMaxWidthFraction,
  };

  /// Inverse of [toMap].
  static CharcoalFieldMetrics fromMap(Map<String, Object?> map) => CharcoalFieldMetrics(
    compactBreakpoint: map['compactBreakpoint']! as double,
    lineHeight: map['lineHeight']! as double,
    textScaleClampMax: map['textScaleClampMax']! as double,
    secondaryMaxWidthFraction: map['secondaryMaxWidthFraction']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalFieldMetrics &&
          other.compactBreakpoint == compactBreakpoint &&
          other.lineHeight == lineHeight &&
          other.textScaleClampMax == textScaleClampMax &&
          other.secondaryMaxWidthFraction == secondaryMaxWidthFraction;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    compactBreakpoint,
    lineHeight,
    textScaleClampMax,
    secondaryMaxWidthFraction,
  ]);
}
