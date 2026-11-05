// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Toast and snack bar.
@immutable
class CharcoalToastMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalToastMetrics({
    required this.maxWidth,
    required this.cornerRadius,
    required this.iconSize,
    required this.toastScreenEdgeSpacing,
    required this.snackBarScreenEdgeSpacing,
    required this.dragDismissDistance,
    required this.dragDismissVelocity,
    required this.rubberBandLimit,
  });

  /// Widest toast.
  final double maxWidth;

  /// Corner radius.
  final double cornerRadius;

  /// Leading icon edge.
  final double iconSize;

  /// Distance of a toast from the screen edge.
  final double toastScreenEdgeSpacing;

  /// Distance of a snack bar from the screen edge.
  final double snackBarScreenEdgeSpacing;

  /// Drag distance that dismisses.
  final double dragDismissDistance;

  /// Fling velocity that dismisses.
  final double dragDismissVelocity;

  /// Asymptote of the rubber-band drag.
  final double rubberBandLimit;

  /// A copy with the given fields replaced.
  CharcoalToastMetrics copyWith({
    double? maxWidth,
    double? cornerRadius,
    double? iconSize,
    double? toastScreenEdgeSpacing,
    double? snackBarScreenEdgeSpacing,
    double? dragDismissDistance,
    double? dragDismissVelocity,
    double? rubberBandLimit,
  }) => CharcoalToastMetrics(
    maxWidth: maxWidth ?? this.maxWidth,
    cornerRadius: cornerRadius ?? this.cornerRadius,
    iconSize: iconSize ?? this.iconSize,
    toastScreenEdgeSpacing: toastScreenEdgeSpacing ?? this.toastScreenEdgeSpacing,
    snackBarScreenEdgeSpacing: snackBarScreenEdgeSpacing ?? this.snackBarScreenEdgeSpacing,
    dragDismissDistance: dragDismissDistance ?? this.dragDismissDistance,
    dragDismissVelocity: dragDismissVelocity ?? this.dragDismissVelocity,
    rubberBandLimit: rubberBandLimit ?? this.rubberBandLimit,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'maxWidth': maxWidth,
    'cornerRadius': cornerRadius,
    'iconSize': iconSize,
    'toastScreenEdgeSpacing': toastScreenEdgeSpacing,
    'snackBarScreenEdgeSpacing': snackBarScreenEdgeSpacing,
    'dragDismissDistance': dragDismissDistance,
    'dragDismissVelocity': dragDismissVelocity,
    'rubberBandLimit': rubberBandLimit,
  };

  /// Inverse of [toMap].
  static CharcoalToastMetrics fromMap(Map<String, Object?> map) => CharcoalToastMetrics(
    maxWidth: map['maxWidth']! as double,
    cornerRadius: map['cornerRadius']! as double,
    iconSize: map['iconSize']! as double,
    toastScreenEdgeSpacing: map['toastScreenEdgeSpacing']! as double,
    snackBarScreenEdgeSpacing: map['snackBarScreenEdgeSpacing']! as double,
    dragDismissDistance: map['dragDismissDistance']! as double,
    dragDismissVelocity: map['dragDismissVelocity']! as double,
    rubberBandLimit: map['rubberBandLimit']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalToastMetrics &&
          other.maxWidth == maxWidth &&
          other.cornerRadius == cornerRadius &&
          other.iconSize == iconSize &&
          other.toastScreenEdgeSpacing == toastScreenEdgeSpacing &&
          other.snackBarScreenEdgeSpacing == snackBarScreenEdgeSpacing &&
          other.dragDismissDistance == dragDismissDistance &&
          other.dragDismissVelocity == dragDismissVelocity &&
          other.rubberBandLimit == rubberBandLimit;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    maxWidth,
    cornerRadius,
    iconSize,
    toastScreenEdgeSpacing,
    snackBarScreenEdgeSpacing,
    dragDismissDistance,
    dragDismissVelocity,
    rubberBandLimit,
  ]);
}
