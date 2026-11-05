// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Text editing chrome shared by fields: cursor, handles, magnifier.
@immutable
class CharcoalTextEditingMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalTextEditingMetrics({
    required this.scrollPadding,
    required this.cursorRadius,
    required this.handleSize,
    required this.handleAnchorX,
    required this.handleInnerSize,
    required this.magnifierWidth,
    required this.magnifierHeight,
    required this.magnifierFocalOffset,
    required this.magnifierScale,
  });

  /// Padding kept visible around the caret when scrolling into view.
  final double scrollPadding;

  /// Cursor corner radius on Apple platforms.
  final double cursorRadius;

  /// Selection handle edge.
  final double handleSize;

  /// Horizontal anchor of the handle.
  final double handleAnchorX;

  /// Edge of the visible handle dot.
  final double handleInnerSize;

  /// Magnifier width.
  final double magnifierWidth;

  /// Magnifier height.
  final double magnifierHeight;

  /// Distance of the magnifier above the touch point.
  final double magnifierFocalOffset;

  /// Magnification factor.
  final double magnifierScale;

  /// A copy with the given fields replaced.
  CharcoalTextEditingMetrics copyWith({
    double? scrollPadding,
    double? cursorRadius,
    double? handleSize,
    double? handleAnchorX,
    double? handleInnerSize,
    double? magnifierWidth,
    double? magnifierHeight,
    double? magnifierFocalOffset,
    double? magnifierScale,
  }) => CharcoalTextEditingMetrics(
    scrollPadding: scrollPadding ?? this.scrollPadding,
    cursorRadius: cursorRadius ?? this.cursorRadius,
    handleSize: handleSize ?? this.handleSize,
    handleAnchorX: handleAnchorX ?? this.handleAnchorX,
    handleInnerSize: handleInnerSize ?? this.handleInnerSize,
    magnifierWidth: magnifierWidth ?? this.magnifierWidth,
    magnifierHeight: magnifierHeight ?? this.magnifierHeight,
    magnifierFocalOffset: magnifierFocalOffset ?? this.magnifierFocalOffset,
    magnifierScale: magnifierScale ?? this.magnifierScale,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'scrollPadding': scrollPadding,
    'cursorRadius': cursorRadius,
    'handleSize': handleSize,
    'handleAnchorX': handleAnchorX,
    'handleInnerSize': handleInnerSize,
    'magnifierWidth': magnifierWidth,
    'magnifierHeight': magnifierHeight,
    'magnifierFocalOffset': magnifierFocalOffset,
    'magnifierScale': magnifierScale,
  };

  /// Inverse of [toMap].
  static CharcoalTextEditingMetrics fromMap(Map<String, Object?> map) => CharcoalTextEditingMetrics(
    scrollPadding: map['scrollPadding']! as double,
    cursorRadius: map['cursorRadius']! as double,
    handleSize: map['handleSize']! as double,
    handleAnchorX: map['handleAnchorX']! as double,
    handleInnerSize: map['handleInnerSize']! as double,
    magnifierWidth: map['magnifierWidth']! as double,
    magnifierHeight: map['magnifierHeight']! as double,
    magnifierFocalOffset: map['magnifierFocalOffset']! as double,
    magnifierScale: map['magnifierScale']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTextEditingMetrics &&
          other.scrollPadding == scrollPadding &&
          other.cursorRadius == cursorRadius &&
          other.handleSize == handleSize &&
          other.handleAnchorX == handleAnchorX &&
          other.handleInnerSize == handleInnerSize &&
          other.magnifierWidth == magnifierWidth &&
          other.magnifierHeight == magnifierHeight &&
          other.magnifierFocalOffset == magnifierFocalOffset &&
          other.magnifierScale == magnifierScale;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    scrollPadding,
    cursorRadius,
    handleSize,
    handleAnchorX,
    handleInnerSize,
    magnifierWidth,
    magnifierHeight,
    magnifierFocalOffset,
    magnifierScale,
  ]);
}
