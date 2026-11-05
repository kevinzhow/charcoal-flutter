// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Scaffold and system chrome.
@immutable
class CharcoalScaffoldMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalScaffoldMetrics({
    required this.darkLuminanceThreshold,
  });

  /// Background luminance below which system icons turn light.
  final double darkLuminanceThreshold;

  /// A copy with the given fields replaced.
  CharcoalScaffoldMetrics copyWith({
    double? darkLuminanceThreshold,
  }) => CharcoalScaffoldMetrics(
    darkLuminanceThreshold: darkLuminanceThreshold ?? this.darkLuminanceThreshold,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'darkLuminanceThreshold': darkLuminanceThreshold,
  };

  /// Inverse of [toMap].
  static CharcoalScaffoldMetrics fromMap(Map<String, Object?> map) => CharcoalScaffoldMetrics(
    darkLuminanceThreshold: map['darkLuminanceThreshold']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalScaffoldMetrics && other.darkLuminanceThreshold == darkLuminanceThreshold;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    darkLuminanceThreshold,
  ]);
}
