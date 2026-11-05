// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Popup shape painter (tooltip and balloon outline).
@immutable
class CharcoalPopupMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalPopupMetrics({
    required this.seamOverlap,
  });

  /// Overlap that hides the seam between body and arrow.
  final double seamOverlap;

  /// A copy with the given fields replaced.
  CharcoalPopupMetrics copyWith({
    double? seamOverlap,
  }) => CharcoalPopupMetrics(
    seamOverlap: seamOverlap ?? this.seamOverlap,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'seamOverlap': seamOverlap,
  };

  /// Inverse of [toMap].
  static CharcoalPopupMetrics fromMap(Map<String, Object?> map) => CharcoalPopupMetrics(
    seamOverlap: map['seamOverlap']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CharcoalPopupMetrics && other.seamOverlap == seamOverlap;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    seamOverlap,
  ]);
}
