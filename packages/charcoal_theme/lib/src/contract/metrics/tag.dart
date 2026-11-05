// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Tag item.
@immutable
class CharcoalTagMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalTagMetrics({
    required this.maxLabelWidth,
    required this.iconSize,
    required this.translatedLabelLineHeight,
  });

  /// Label width at which the tag truncates.
  final double maxLabelWidth;

  /// Leading and trailing icon edge.
  final double iconSize;

  /// Line-height multiplier of a translated (non-Latin) label.
  final double translatedLabelLineHeight;

  /// A copy with the given fields replaced.
  CharcoalTagMetrics copyWith({
    double? maxLabelWidth,
    double? iconSize,
    double? translatedLabelLineHeight,
  }) => CharcoalTagMetrics(
    maxLabelWidth: maxLabelWidth ?? this.maxLabelWidth,
    iconSize: iconSize ?? this.iconSize,
    translatedLabelLineHeight: translatedLabelLineHeight ?? this.translatedLabelLineHeight,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'maxLabelWidth': maxLabelWidth,
    'iconSize': iconSize,
    'translatedLabelLineHeight': translatedLabelLineHeight,
  };

  /// Inverse of [toMap].
  static CharcoalTagMetrics fromMap(Map<String, Object?> map) => CharcoalTagMetrics(
    maxLabelWidth: map['maxLabelWidth']! as double,
    iconSize: map['iconSize']! as double,
    translatedLabelLineHeight: map['translatedLabelLineHeight']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTagMetrics &&
          other.maxLabelWidth == maxLabelWidth &&
          other.iconSize == iconSize &&
          other.translatedLabelLineHeight == translatedLabelLineHeight;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    maxLabelWidth,
    iconSize,
    translatedLabelLineHeight,
  ]);
}
