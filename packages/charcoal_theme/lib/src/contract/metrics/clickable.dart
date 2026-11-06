// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Shared interaction behaviour.
@immutable
class CharcoalClickableMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalClickableMetrics({
    required this.keyboardActivationDuration,
    required this.disabledOpacity,
    required this.pressedOpacity,
  });

  /// How long a key activation shows the pressed state.
  final Duration keyboardActivationDuration;

  /// Opacity of a disabled control.
  final double disabledOpacity;

  /// Opacity of content while it is pressed (CharcoalPressFeedback).
  final double pressedOpacity;

  /// A copy with the given fields replaced.
  CharcoalClickableMetrics copyWith({
    Duration? keyboardActivationDuration,
    double? disabledOpacity,
    double? pressedOpacity,
  }) => CharcoalClickableMetrics(
    keyboardActivationDuration: keyboardActivationDuration ?? this.keyboardActivationDuration,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    pressedOpacity: pressedOpacity ?? this.pressedOpacity,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'keyboardActivationDuration': keyboardActivationDuration,
    'disabledOpacity': disabledOpacity,
    'pressedOpacity': pressedOpacity,
  };

  /// Inverse of [toMap].
  static CharcoalClickableMetrics fromMap(Map<String, Object?> map) => CharcoalClickableMetrics(
    keyboardActivationDuration: map['keyboardActivationDuration']! as Duration,
    disabledOpacity: map['disabledOpacity']! as double,
    pressedOpacity: map['pressedOpacity']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalClickableMetrics &&
          other.keyboardActivationDuration == keyboardActivationDuration &&
          other.disabledOpacity == disabledOpacity &&
          other.pressedOpacity == pressedOpacity;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    keyboardActivationDuration,
    disabledOpacity,
    pressedOpacity,
  ]);
}
