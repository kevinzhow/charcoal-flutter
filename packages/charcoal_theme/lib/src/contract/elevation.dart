// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Resting elevation per surface kind. Charcoal is flat, so every step is 0; the contract keeps
/// the slots so a pack can lift dialogs and menus.
@immutable
class CharcoalElevationScale {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalElevationScale({
    required this.surface,
    required this.overlay,
  });

  /// Cards and rows.
  final double surface;

  /// Dialogs, menus and toasts.
  final double overlay;

  /// A copy with the given fields replaced.
  CharcoalElevationScale copyWith({
    double? surface,
    double? overlay,
  }) => CharcoalElevationScale(
    surface: surface ?? this.surface,
    overlay: overlay ?? this.overlay,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'surface': surface,
    'overlay': overlay,
  };

  /// Inverse of [toMap].
  static CharcoalElevationScale fromMap(Map<String, Object?> map) => CharcoalElevationScale(
    surface: map['surface']! as double,
    overlay: map['overlay']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalElevationScale && other.surface == surface && other.overlay == overlay;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    surface,
    overlay,
  ]);
}
