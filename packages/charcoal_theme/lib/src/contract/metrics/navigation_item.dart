// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Navigation row.
@immutable
class CharcoalNavigationItemMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalNavigationItemMetrics({
    required this.leadingIconSize,
    required this.trailingIconSize,
  });

  /// Leading icon edge.
  final double leadingIconSize;

  /// Trailing chevron edge.
  final double trailingIconSize;

  /// A copy with the given fields replaced.
  CharcoalNavigationItemMetrics copyWith({
    double? leadingIconSize,
    double? trailingIconSize,
  }) => CharcoalNavigationItemMetrics(
    leadingIconSize: leadingIconSize ?? this.leadingIconSize,
    trailingIconSize: trailingIconSize ?? this.trailingIconSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'leadingIconSize': leadingIconSize,
    'trailingIconSize': trailingIconSize,
  };

  /// Inverse of [toMap].
  static CharcoalNavigationItemMetrics fromMap(Map<String, Object?> map) =>
      CharcoalNavigationItemMetrics(
        leadingIconSize: map['leadingIconSize']! as double,
        trailingIconSize: map['trailingIconSize']! as double,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalNavigationItemMetrics &&
          other.leadingIconSize == leadingIconSize &&
          other.trailingIconSize == trailingIconSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    leadingIconSize,
    trailingIconSize,
  ]);
}
