// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Text selection toolbar placement.
@immutable
class CharcoalSelectionToolbarMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalSelectionToolbarMetrics({
    required this.edgeInset,
    required this.anchorAboveGap,
    required this.anchorBelowGap,
    required this.padding,
  });

  /// Least distance from the screen edge.
  final double edgeInset;

  /// Gap above the primary anchor.
  final double anchorAboveGap;

  /// Gap below the secondary anchor.
  final double anchorBelowGap;

  /// Padding inside the toolbar.
  final double padding;

  /// A copy with the given fields replaced.
  CharcoalSelectionToolbarMetrics copyWith({
    double? edgeInset,
    double? anchorAboveGap,
    double? anchorBelowGap,
    double? padding,
  }) => CharcoalSelectionToolbarMetrics(
    edgeInset: edgeInset ?? this.edgeInset,
    anchorAboveGap: anchorAboveGap ?? this.anchorAboveGap,
    anchorBelowGap: anchorBelowGap ?? this.anchorBelowGap,
    padding: padding ?? this.padding,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'edgeInset': edgeInset,
    'anchorAboveGap': anchorAboveGap,
    'anchorBelowGap': anchorBelowGap,
    'padding': padding,
  };

  /// Inverse of [toMap].
  static CharcoalSelectionToolbarMetrics fromMap(Map<String, Object?> map) =>
      CharcoalSelectionToolbarMetrics(
        edgeInset: map['edgeInset']! as double,
        anchorAboveGap: map['anchorAboveGap']! as double,
        anchorBelowGap: map['anchorBelowGap']! as double,
        padding: map['padding']! as double,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalSelectionToolbarMetrics &&
          other.edgeInset == edgeInset &&
          other.anchorAboveGap == anchorAboveGap &&
          other.anchorBelowGap == anchorBelowGap &&
          other.padding == padding;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    edgeInset,
    anchorAboveGap,
    anchorBelowGap,
    padding,
  ]);
}
