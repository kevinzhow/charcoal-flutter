// Part of the frozen Charcoal theme contract. Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Placeholder artwork (CharcoalPlaceholderArtwork).
@immutable
class CharcoalArtworkMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalArtworkMetrics({
    required this.height,
    required this.discDiameter,
    required this.discOffsetStart,
    required this.discOffsetBottom,
    required this.tileEdge,
    required this.tileOffsetEnd,
    required this.tileOffsetTop,
    required this.tileAngle,
    required this.tileTint,
  });

  /// Height of placeholder artwork whose parent leaves the height unbounded (a feed post).
  final double height;

  /// Diameter of the disc in the lower start corner.
  final double discDiameter;

  /// Disc position from the start edge (negative: partly outside).
  final double discOffsetStart;

  /// Disc position from the bottom edge (negative: partly outside).
  final double discOffsetBottom;

  /// Edge of the tilted tile in the upper end corner.
  final double tileEdge;

  /// Tile position from the end edge.
  final double tileOffsetEnd;

  /// Tile position from the top edge.
  final double tileOffsetTop;

  /// Rotation of the tile, in radians.
  final double tileAngle;

  /// How much of the gradient's end colour tints the tile (0: pure accent).
  final double tileTint;

  /// A copy with the given fields replaced.
  CharcoalArtworkMetrics copyWith({
    double? height,
    double? discDiameter,
    double? discOffsetStart,
    double? discOffsetBottom,
    double? tileEdge,
    double? tileOffsetEnd,
    double? tileOffsetTop,
    double? tileAngle,
    double? tileTint,
  }) => CharcoalArtworkMetrics(
    height: height ?? this.height,
    discDiameter: discDiameter ?? this.discDiameter,
    discOffsetStart: discOffsetStart ?? this.discOffsetStart,
    discOffsetBottom: discOffsetBottom ?? this.discOffsetBottom,
    tileEdge: tileEdge ?? this.tileEdge,
    tileOffsetEnd: tileOffsetEnd ?? this.tileOffsetEnd,
    tileOffsetTop: tileOffsetTop ?? this.tileOffsetTop,
    tileAngle: tileAngle ?? this.tileAngle,
    tileTint: tileTint ?? this.tileTint,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'height': height,
    'discDiameter': discDiameter,
    'discOffsetStart': discOffsetStart,
    'discOffsetBottom': discOffsetBottom,
    'tileEdge': tileEdge,
    'tileOffsetEnd': tileOffsetEnd,
    'tileOffsetTop': tileOffsetTop,
    'tileAngle': tileAngle,
    'tileTint': tileTint,
  };

  /// Inverse of [toMap].
  static CharcoalArtworkMetrics fromMap(Map<String, Object?> map) => CharcoalArtworkMetrics(
    height: map['height']! as double,
    discDiameter: map['discDiameter']! as double,
    discOffsetStart: map['discOffsetStart']! as double,
    discOffsetBottom: map['discOffsetBottom']! as double,
    tileEdge: map['tileEdge']! as double,
    tileOffsetEnd: map['tileOffsetEnd']! as double,
    tileOffsetTop: map['tileOffsetTop']! as double,
    tileAngle: map['tileAngle']! as double,
    tileTint: map['tileTint']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalArtworkMetrics &&
          other.height == height &&
          other.discDiameter == discDiameter &&
          other.discOffsetStart == discOffsetStart &&
          other.discOffsetBottom == discOffsetBottom &&
          other.tileEdge == tileEdge &&
          other.tileOffsetEnd == tileOffsetEnd &&
          other.tileOffsetTop == tileOffsetTop &&
          other.tileAngle == tileAngle &&
          other.tileTint == tileTint;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    height,
    discDiameter,
    discOffsetStart,
    discOffsetBottom,
    tileEdge,
    tileOffsetEnd,
    tileOffsetTop,
    tileAngle,
    tileTint,
  ]);
}
