// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Dropdown trigger and menu.
@immutable
class CharcoalDropdownMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalDropdownMetrics({
    required this.menuMaxHeight,
    required this.iconSize,
  });

  /// Menu height at which it starts scrolling.
  final double menuMaxHeight;

  /// Chevron icon edge.
  final double iconSize;

  /// A copy with the given fields replaced.
  CharcoalDropdownMetrics copyWith({
    double? menuMaxHeight,
    double? iconSize,
  }) => CharcoalDropdownMetrics(
    menuMaxHeight: menuMaxHeight ?? this.menuMaxHeight,
    iconSize: iconSize ?? this.iconSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'menuMaxHeight': menuMaxHeight,
    'iconSize': iconSize,
  };

  /// Inverse of [toMap].
  static CharcoalDropdownMetrics fromMap(Map<String, Object?> map) => CharcoalDropdownMetrics(
    menuMaxHeight: map['menuMaxHeight']! as double,
    iconSize: map['iconSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalDropdownMetrics &&
          other.menuMaxHeight == menuMaxHeight &&
          other.iconSize == iconSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    menuMaxHeight,
    iconSize,
  ]);
}
