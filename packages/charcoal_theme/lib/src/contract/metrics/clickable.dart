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
  });

  /// How long a key activation shows the pressed state.
  final Duration keyboardActivationDuration;

  /// Opacity of a disabled control.
  final double disabledOpacity;

  /// A copy with the given fields replaced.
  CharcoalClickableMetrics copyWith({
    Duration? keyboardActivationDuration,
    double? disabledOpacity,
  }) => CharcoalClickableMetrics(
    keyboardActivationDuration: keyboardActivationDuration ?? this.keyboardActivationDuration,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'keyboardActivationDuration': keyboardActivationDuration,
    'disabledOpacity': disabledOpacity,
  };

  /// Inverse of [toMap].
  static CharcoalClickableMetrics fromMap(Map<String, Object?> map) => CharcoalClickableMetrics(
    keyboardActivationDuration: map['keyboardActivationDuration']! as Duration,
    disabledOpacity: map['disabledOpacity']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalClickableMetrics &&
          other.keyboardActivationDuration == keyboardActivationDuration &&
          other.disabledOpacity == disabledOpacity;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    keyboardActivationDuration,
    disabledOpacity,
  ]);
}
