// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Tooltip bubble.
@immutable
class CharcoalTooltipMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalTooltipMetrics({
    required this.defaultWaitDuration,
    required this.defaultMaxWidth,
    required this.arrowHeight,
    required this.arrowHalfWidth,
  });

  /// Hover time before the tooltip shows.
  final Duration defaultWaitDuration;

  /// Widest tooltip.
  final double defaultMaxWidth;

  /// Arrow height.
  final double arrowHeight;

  /// Half the arrow base.
  final double arrowHalfWidth;

  /// A copy with the given fields replaced.
  CharcoalTooltipMetrics copyWith({
    Duration? defaultWaitDuration,
    double? defaultMaxWidth,
    double? arrowHeight,
    double? arrowHalfWidth,
  }) => CharcoalTooltipMetrics(
    defaultWaitDuration: defaultWaitDuration ?? this.defaultWaitDuration,
    defaultMaxWidth: defaultMaxWidth ?? this.defaultMaxWidth,
    arrowHeight: arrowHeight ?? this.arrowHeight,
    arrowHalfWidth: arrowHalfWidth ?? this.arrowHalfWidth,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'defaultWaitDuration': defaultWaitDuration,
    'defaultMaxWidth': defaultMaxWidth,
    'arrowHeight': arrowHeight,
    'arrowHalfWidth': arrowHalfWidth,
  };

  /// Inverse of [toMap].
  static CharcoalTooltipMetrics fromMap(Map<String, Object?> map) => CharcoalTooltipMetrics(
    defaultWaitDuration: map['defaultWaitDuration']! as Duration,
    defaultMaxWidth: map['defaultMaxWidth']! as double,
    arrowHeight: map['arrowHeight']! as double,
    arrowHalfWidth: map['arrowHalfWidth']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTooltipMetrics &&
          other.defaultWaitDuration == defaultWaitDuration &&
          other.defaultMaxWidth == defaultMaxWidth &&
          other.arrowHeight == arrowHeight &&
          other.arrowHalfWidth == arrowHalfWidth;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    defaultWaitDuration,
    defaultMaxWidth,
    arrowHeight,
    arrowHalfWidth,
  ]);
}
