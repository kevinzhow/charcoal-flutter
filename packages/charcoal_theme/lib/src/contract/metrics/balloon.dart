// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Balloon (popover with arrow and close).
@immutable
class CharcoalBalloonMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalBalloonMetrics({
    required this.defaultMaxWidth,
    required this.arrowHeight,
    required this.arrowHalfWidth,
    required this.strokeWidth,
    required this.closeGap,
    required this.closeVisualSize,
    required this.closeIconSize,
    required this.closeIconInset,
    required this.closeIconStrokeWidth,
    required this.actionVerticalPadding,
  });

  /// Widest balloon.
  final double defaultMaxWidth;

  /// Arrow height.
  final double arrowHeight;

  /// Half the arrow base.
  final double arrowHalfWidth;

  /// Outline width.
  final double strokeWidth;

  /// Gap before the close button.
  final double closeGap;

  /// Close button visual edge.
  final double closeVisualSize;

  /// Close glyph edge.
  final double closeIconSize;

  /// Inset of the close glyph.
  final double closeIconInset;

  /// Close glyph stroke.
  final double closeIconStrokeWidth;

  /// Vertical padding of the action link.
  final double actionVerticalPadding;

  /// A copy with the given fields replaced.
  CharcoalBalloonMetrics copyWith({
    double? defaultMaxWidth,
    double? arrowHeight,
    double? arrowHalfWidth,
    double? strokeWidth,
    double? closeGap,
    double? closeVisualSize,
    double? closeIconSize,
    double? closeIconInset,
    double? closeIconStrokeWidth,
    double? actionVerticalPadding,
  }) => CharcoalBalloonMetrics(
    defaultMaxWidth: defaultMaxWidth ?? this.defaultMaxWidth,
    arrowHeight: arrowHeight ?? this.arrowHeight,
    arrowHalfWidth: arrowHalfWidth ?? this.arrowHalfWidth,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    closeGap: closeGap ?? this.closeGap,
    closeVisualSize: closeVisualSize ?? this.closeVisualSize,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    closeIconInset: closeIconInset ?? this.closeIconInset,
    closeIconStrokeWidth: closeIconStrokeWidth ?? this.closeIconStrokeWidth,
    actionVerticalPadding: actionVerticalPadding ?? this.actionVerticalPadding,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'defaultMaxWidth': defaultMaxWidth,
    'arrowHeight': arrowHeight,
    'arrowHalfWidth': arrowHalfWidth,
    'strokeWidth': strokeWidth,
    'closeGap': closeGap,
    'closeVisualSize': closeVisualSize,
    'closeIconSize': closeIconSize,
    'closeIconInset': closeIconInset,
    'closeIconStrokeWidth': closeIconStrokeWidth,
    'actionVerticalPadding': actionVerticalPadding,
  };

  /// Inverse of [toMap].
  static CharcoalBalloonMetrics fromMap(Map<String, Object?> map) => CharcoalBalloonMetrics(
    defaultMaxWidth: map['defaultMaxWidth']! as double,
    arrowHeight: map['arrowHeight']! as double,
    arrowHalfWidth: map['arrowHalfWidth']! as double,
    strokeWidth: map['strokeWidth']! as double,
    closeGap: map['closeGap']! as double,
    closeVisualSize: map['closeVisualSize']! as double,
    closeIconSize: map['closeIconSize']! as double,
    closeIconInset: map['closeIconInset']! as double,
    closeIconStrokeWidth: map['closeIconStrokeWidth']! as double,
    actionVerticalPadding: map['actionVerticalPadding']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalBalloonMetrics &&
          other.defaultMaxWidth == defaultMaxWidth &&
          other.arrowHeight == arrowHeight &&
          other.arrowHalfWidth == arrowHalfWidth &&
          other.strokeWidth == strokeWidth &&
          other.closeGap == closeGap &&
          other.closeVisualSize == closeVisualSize &&
          other.closeIconSize == closeIconSize &&
          other.closeIconInset == closeIconInset &&
          other.closeIconStrokeWidth == closeIconStrokeWidth &&
          other.actionVerticalPadding == actionVerticalPadding;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    defaultMaxWidth,
    arrowHeight,
    arrowHalfWidth,
    strokeWidth,
    closeGap,
    closeVisualSize,
    closeIconSize,
    closeIconInset,
    closeIconStrokeWidth,
    actionVerticalPadding,
  ]);
}
