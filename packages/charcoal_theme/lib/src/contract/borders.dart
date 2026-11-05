// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Line widths.
@immutable
class CharcoalBorderScale {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalBorderScale({
    required this.hairline,
    required this.thick,
    required this.focusRing,
    required this.focusHalo,
  });

  /// List rules and card outlines.
  final double hairline;

  /// Control indicator outlines.
  final double thick;

  /// Outline drawn around a focused or invalid field.
  final double focusRing;

  /// Width of the translucent halo (colors.focusRing) around a focused control.
  final double focusHalo;

  /// A copy with the given fields replaced.
  CharcoalBorderScale copyWith({
    double? hairline,
    double? thick,
    double? focusRing,
    double? focusHalo,
  }) => CharcoalBorderScale(
    hairline: hairline ?? this.hairline,
    thick: thick ?? this.thick,
    focusRing: focusRing ?? this.focusRing,
    focusHalo: focusHalo ?? this.focusHalo,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'hairline': hairline,
    'thick': thick,
    'focusRing': focusRing,
    'focusHalo': focusHalo,
  };

  /// Inverse of [toMap].
  static CharcoalBorderScale fromMap(Map<String, Object?> map) => CharcoalBorderScale(
    hairline: map['hairline']! as double,
    thick: map['thick']! as double,
    focusRing: map['focusRing']! as double,
    focusHalo: map['focusHalo']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalBorderScale &&
          other.hairline == hairline &&
          other.thick == thick &&
          other.focusRing == focusRing &&
          other.focusHalo == focusHalo;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    hairline,
    thick,
    focusRing,
    focusHalo,
  ]);
}
