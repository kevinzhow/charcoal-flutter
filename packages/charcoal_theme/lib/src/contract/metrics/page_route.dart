// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Page transition and predictive back.
@immutable
class CharcoalPageRouteMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalPageRouteMetrics({
    required this.edgeGestureWidth,
    required this.horizontalEnterOffset,
    required this.verticalEnterOffset,
    required this.horizontalSecondaryOffset,
    required this.verticalSecondaryOffset,
    required this.secondaryParallax,
    required this.secondaryScrimOpacity,
    required this.commitThreshold,
    required this.flingVelocityThreshold,
    required this.predictiveShiftDivisor,
    required this.predictiveShiftInset,
    required this.predictiveScaleDrop,
    required this.predictiveCornerRadius,
    required this.predictiveExitOffsetFraction,
  });

  /// Width of the edge swipe-back zone.
  final double edgeGestureWidth;

  /// Entering page slide (fraction of width).
  final double horizontalEnterOffset;

  /// Entering page slide, vertical axis (fraction of height).
  final double verticalEnterOffset;

  /// Covered page slide (fraction of width, sign flips in RTL).
  final double horizontalSecondaryOffset;

  /// Covered page slide, vertical axis.
  final double verticalSecondaryOffset;

  /// Covered page parallax in the platform-style transition.
  final double secondaryParallax;

  /// Opacity of colors.pageBackdrop over the covered page.
  final double secondaryScrimOpacity;

  /// Back-gesture progress past which the pop commits.
  final double commitThreshold;

  /// Fling velocity that commits regardless of progress.
  final double flingVelocityThreshold;

  /// Window size divisor for the predictive-back drift.
  final double predictiveShiftDivisor;

  /// Margin subtracted from the predictive-back drift.
  final double predictiveShiftInset;

  /// Scale lost at full predictive-back progress.
  final double predictiveScaleDrop;

  /// Corner radius at full predictive-back progress.
  final double predictiveCornerRadius;

  /// Exit slide as a fraction of window height.
  final double predictiveExitOffsetFraction;

  /// A copy with the given fields replaced.
  CharcoalPageRouteMetrics copyWith({
    double? edgeGestureWidth,
    double? horizontalEnterOffset,
    double? verticalEnterOffset,
    double? horizontalSecondaryOffset,
    double? verticalSecondaryOffset,
    double? secondaryParallax,
    double? secondaryScrimOpacity,
    double? commitThreshold,
    double? flingVelocityThreshold,
    double? predictiveShiftDivisor,
    double? predictiveShiftInset,
    double? predictiveScaleDrop,
    double? predictiveCornerRadius,
    double? predictiveExitOffsetFraction,
  }) => CharcoalPageRouteMetrics(
    edgeGestureWidth: edgeGestureWidth ?? this.edgeGestureWidth,
    horizontalEnterOffset: horizontalEnterOffset ?? this.horizontalEnterOffset,
    verticalEnterOffset: verticalEnterOffset ?? this.verticalEnterOffset,
    horizontalSecondaryOffset: horizontalSecondaryOffset ?? this.horizontalSecondaryOffset,
    verticalSecondaryOffset: verticalSecondaryOffset ?? this.verticalSecondaryOffset,
    secondaryParallax: secondaryParallax ?? this.secondaryParallax,
    secondaryScrimOpacity: secondaryScrimOpacity ?? this.secondaryScrimOpacity,
    commitThreshold: commitThreshold ?? this.commitThreshold,
    flingVelocityThreshold: flingVelocityThreshold ?? this.flingVelocityThreshold,
    predictiveShiftDivisor: predictiveShiftDivisor ?? this.predictiveShiftDivisor,
    predictiveShiftInset: predictiveShiftInset ?? this.predictiveShiftInset,
    predictiveScaleDrop: predictiveScaleDrop ?? this.predictiveScaleDrop,
    predictiveCornerRadius: predictiveCornerRadius ?? this.predictiveCornerRadius,
    predictiveExitOffsetFraction: predictiveExitOffsetFraction ?? this.predictiveExitOffsetFraction,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'edgeGestureWidth': edgeGestureWidth,
    'horizontalEnterOffset': horizontalEnterOffset,
    'verticalEnterOffset': verticalEnterOffset,
    'horizontalSecondaryOffset': horizontalSecondaryOffset,
    'verticalSecondaryOffset': verticalSecondaryOffset,
    'secondaryParallax': secondaryParallax,
    'secondaryScrimOpacity': secondaryScrimOpacity,
    'commitThreshold': commitThreshold,
    'flingVelocityThreshold': flingVelocityThreshold,
    'predictiveShiftDivisor': predictiveShiftDivisor,
    'predictiveShiftInset': predictiveShiftInset,
    'predictiveScaleDrop': predictiveScaleDrop,
    'predictiveCornerRadius': predictiveCornerRadius,
    'predictiveExitOffsetFraction': predictiveExitOffsetFraction,
  };

  /// Inverse of [toMap].
  static CharcoalPageRouteMetrics fromMap(Map<String, Object?> map) => CharcoalPageRouteMetrics(
    edgeGestureWidth: map['edgeGestureWidth']! as double,
    horizontalEnterOffset: map['horizontalEnterOffset']! as double,
    verticalEnterOffset: map['verticalEnterOffset']! as double,
    horizontalSecondaryOffset: map['horizontalSecondaryOffset']! as double,
    verticalSecondaryOffset: map['verticalSecondaryOffset']! as double,
    secondaryParallax: map['secondaryParallax']! as double,
    secondaryScrimOpacity: map['secondaryScrimOpacity']! as double,
    commitThreshold: map['commitThreshold']! as double,
    flingVelocityThreshold: map['flingVelocityThreshold']! as double,
    predictiveShiftDivisor: map['predictiveShiftDivisor']! as double,
    predictiveShiftInset: map['predictiveShiftInset']! as double,
    predictiveScaleDrop: map['predictiveScaleDrop']! as double,
    predictiveCornerRadius: map['predictiveCornerRadius']! as double,
    predictiveExitOffsetFraction: map['predictiveExitOffsetFraction']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalPageRouteMetrics &&
          other.edgeGestureWidth == edgeGestureWidth &&
          other.horizontalEnterOffset == horizontalEnterOffset &&
          other.verticalEnterOffset == verticalEnterOffset &&
          other.horizontalSecondaryOffset == horizontalSecondaryOffset &&
          other.verticalSecondaryOffset == verticalSecondaryOffset &&
          other.secondaryParallax == secondaryParallax &&
          other.secondaryScrimOpacity == secondaryScrimOpacity &&
          other.commitThreshold == commitThreshold &&
          other.flingVelocityThreshold == flingVelocityThreshold &&
          other.predictiveShiftDivisor == predictiveShiftDivisor &&
          other.predictiveShiftInset == predictiveShiftInset &&
          other.predictiveScaleDrop == predictiveScaleDrop &&
          other.predictiveCornerRadius == predictiveCornerRadius &&
          other.predictiveExitOffsetFraction == predictiveExitOffsetFraction;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    edgeGestureWidth,
    horizontalEnterOffset,
    verticalEnterOffset,
    horizontalSecondaryOffset,
    verticalSecondaryOffset,
    secondaryParallax,
    secondaryScrimOpacity,
    commitThreshold,
    flingVelocityThreshold,
    predictiveShiftDivisor,
    predictiveShiftInset,
    predictiveScaleDrop,
    predictiveCornerRadius,
    predictiveExitOffsetFraction,
  ]);
}
