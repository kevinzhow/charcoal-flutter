// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Hint text and its info glyph.
@immutable
class CharcoalHintMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalHintMetrics({
    required this.actionStackBreakpoint,
    required this.iconSize,
  });

  /// Width below which the action stacks under the text.
  final double actionStackBreakpoint;

  /// Info glyph edge (the vector art is drawn on this artboard).
  final double iconSize;

  /// A copy with the given fields replaced.
  CharcoalHintMetrics copyWith({
    double? actionStackBreakpoint,
    double? iconSize,
  }) => CharcoalHintMetrics(
    actionStackBreakpoint: actionStackBreakpoint ?? this.actionStackBreakpoint,
    iconSize: iconSize ?? this.iconSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'actionStackBreakpoint': actionStackBreakpoint,
    'iconSize': iconSize,
  };

  /// Inverse of [toMap].
  static CharcoalHintMetrics fromMap(Map<String, Object?> map) => CharcoalHintMetrics(
    actionStackBreakpoint: map['actionStackBreakpoint']! as double,
    iconSize: map['iconSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalHintMetrics &&
          other.actionStackBreakpoint == actionStackBreakpoint &&
          other.iconSize == iconSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    actionStackBreakpoint,
    iconSize,
  ]);
}
