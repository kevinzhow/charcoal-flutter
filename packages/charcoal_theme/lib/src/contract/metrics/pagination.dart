// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Pagination.
@immutable
class CharcoalPaginationMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalPaginationMetrics({
    required this.cornerRadius,
    required this.defaultMaxVisiblePages,
  });

  /// Page-button corner radius.
  final double cornerRadius;

  /// Pages shown when the caller passes no limit (odd, >= 3).
  final int defaultMaxVisiblePages;

  /// A copy with the given fields replaced.
  CharcoalPaginationMetrics copyWith({
    double? cornerRadius,
    int? defaultMaxVisiblePages,
  }) => CharcoalPaginationMetrics(
    cornerRadius: cornerRadius ?? this.cornerRadius,
    defaultMaxVisiblePages: defaultMaxVisiblePages ?? this.defaultMaxVisiblePages,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'cornerRadius': cornerRadius,
    'defaultMaxVisiblePages': defaultMaxVisiblePages,
  };

  /// Inverse of [toMap].
  static CharcoalPaginationMetrics fromMap(Map<String, Object?> map) => CharcoalPaginationMetrics(
    cornerRadius: map['cornerRadius']! as double,
    defaultMaxVisiblePages: map['defaultMaxVisiblePages']! as int,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalPaginationMetrics &&
          other.cornerRadius == cornerRadius &&
          other.defaultMaxVisiblePages == defaultMaxVisiblePages;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    cornerRadius,
    defaultMaxVisiblePages,
  ]);
}
