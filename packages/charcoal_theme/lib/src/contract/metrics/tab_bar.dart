// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Bottom tab bar.
@immutable
class CharcoalTabBarMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalTabBarMetrics({
    required this.badgeFontSize,
    required this.badgeMinExtent,
    required this.iconSize,
    required this.labelFontSize,
    required this.badgeOffsetEnd,
    required this.badgeOffsetTop,
  });

  /// Badge label size.
  final double badgeFontSize;

  /// Least badge edge.
  final double badgeMinExtent;

  /// Tab icon edge.
  final double iconSize;

  /// Tab label size.
  final double labelFontSize;

  /// Badge position from the icon end edge (negative: outside).
  final double badgeOffsetEnd;

  /// Badge position from the icon top edge (negative: outside).
  final double badgeOffsetTop;

  /// A copy with the given fields replaced.
  CharcoalTabBarMetrics copyWith({
    double? badgeFontSize,
    double? badgeMinExtent,
    double? iconSize,
    double? labelFontSize,
    double? badgeOffsetEnd,
    double? badgeOffsetTop,
  }) => CharcoalTabBarMetrics(
    badgeFontSize: badgeFontSize ?? this.badgeFontSize,
    badgeMinExtent: badgeMinExtent ?? this.badgeMinExtent,
    iconSize: iconSize ?? this.iconSize,
    labelFontSize: labelFontSize ?? this.labelFontSize,
    badgeOffsetEnd: badgeOffsetEnd ?? this.badgeOffsetEnd,
    badgeOffsetTop: badgeOffsetTop ?? this.badgeOffsetTop,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'badgeFontSize': badgeFontSize,
    'badgeMinExtent': badgeMinExtent,
    'iconSize': iconSize,
    'labelFontSize': labelFontSize,
    'badgeOffsetEnd': badgeOffsetEnd,
    'badgeOffsetTop': badgeOffsetTop,
  };

  /// Inverse of [toMap].
  static CharcoalTabBarMetrics fromMap(Map<String, Object?> map) => CharcoalTabBarMetrics(
    badgeFontSize: map['badgeFontSize']! as double,
    badgeMinExtent: map['badgeMinExtent']! as double,
    iconSize: map['iconSize']! as double,
    labelFontSize: map['labelFontSize']! as double,
    badgeOffsetEnd: map['badgeOffsetEnd']! as double,
    badgeOffsetTop: map['badgeOffsetTop']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTabBarMetrics &&
          other.badgeFontSize == badgeFontSize &&
          other.badgeMinExtent == badgeMinExtent &&
          other.iconSize == iconSize &&
          other.labelFontSize == labelFontSize &&
          other.badgeOffsetEnd == badgeOffsetEnd &&
          other.badgeOffsetTop == badgeOffsetTop;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    badgeFontSize,
    badgeMinExtent,
    iconSize,
    labelFontSize,
    badgeOffsetEnd,
    badgeOffsetTop,
  ]);
}
