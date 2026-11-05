// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Dialog and bottom sheet.
@immutable
class CharcoalModalMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalModalMetrics({
    required this.initialScale,
    required this.minWidth,
    required this.cornerRadius,
    required this.titleHorizontalPadding,
    required this.actionPadding,
    required this.bottomSheetMinimumBottomPadding,
    required this.closeIconSize,
    required this.closeIconInset,
    required this.closeIconStrokeWidth,
    required this.exitFadeDuration,
    required this.smallWidth,
    required this.mediumWidth,
    required this.largeWidth,
  });

  /// Scale a dialog enters from.
  final double initialScale;

  /// Narrowest dialog.
  final double minWidth;

  /// Dialog corner radius.
  final double cornerRadius;

  /// Title padding that clears the close button.
  final double titleHorizontalPadding;

  /// Padding around the action row.
  final double actionPadding;

  /// Least bottom padding of a bottom sheet.
  final double bottomSheetMinimumBottomPadding;

  /// Close glyph edge.
  final double closeIconSize;

  /// Inset of the close glyph within its hit area.
  final double closeIconInset;

  /// Stroke width of the close glyph.
  final double closeIconStrokeWidth;

  /// Fade-out of a dismissed dialog.
  final Duration exitFadeDuration;

  /// Width of a small dialog.
  final double smallWidth;

  /// Width of a medium dialog.
  final double mediumWidth;

  /// Width of a large dialog.
  final double largeWidth;

  /// A copy with the given fields replaced.
  CharcoalModalMetrics copyWith({
    double? initialScale,
    double? minWidth,
    double? cornerRadius,
    double? titleHorizontalPadding,
    double? actionPadding,
    double? bottomSheetMinimumBottomPadding,
    double? closeIconSize,
    double? closeIconInset,
    double? closeIconStrokeWidth,
    Duration? exitFadeDuration,
    double? smallWidth,
    double? mediumWidth,
    double? largeWidth,
  }) => CharcoalModalMetrics(
    initialScale: initialScale ?? this.initialScale,
    minWidth: minWidth ?? this.minWidth,
    cornerRadius: cornerRadius ?? this.cornerRadius,
    titleHorizontalPadding: titleHorizontalPadding ?? this.titleHorizontalPadding,
    actionPadding: actionPadding ?? this.actionPadding,
    bottomSheetMinimumBottomPadding:
        bottomSheetMinimumBottomPadding ?? this.bottomSheetMinimumBottomPadding,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    closeIconInset: closeIconInset ?? this.closeIconInset,
    closeIconStrokeWidth: closeIconStrokeWidth ?? this.closeIconStrokeWidth,
    exitFadeDuration: exitFadeDuration ?? this.exitFadeDuration,
    smallWidth: smallWidth ?? this.smallWidth,
    mediumWidth: mediumWidth ?? this.mediumWidth,
    largeWidth: largeWidth ?? this.largeWidth,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'initialScale': initialScale,
    'minWidth': minWidth,
    'cornerRadius': cornerRadius,
    'titleHorizontalPadding': titleHorizontalPadding,
    'actionPadding': actionPadding,
    'bottomSheetMinimumBottomPadding': bottomSheetMinimumBottomPadding,
    'closeIconSize': closeIconSize,
    'closeIconInset': closeIconInset,
    'closeIconStrokeWidth': closeIconStrokeWidth,
    'exitFadeDuration': exitFadeDuration,
    'smallWidth': smallWidth,
    'mediumWidth': mediumWidth,
    'largeWidth': largeWidth,
  };

  /// Inverse of [toMap].
  static CharcoalModalMetrics fromMap(Map<String, Object?> map) => CharcoalModalMetrics(
    initialScale: map['initialScale']! as double,
    minWidth: map['minWidth']! as double,
    cornerRadius: map['cornerRadius']! as double,
    titleHorizontalPadding: map['titleHorizontalPadding']! as double,
    actionPadding: map['actionPadding']! as double,
    bottomSheetMinimumBottomPadding: map['bottomSheetMinimumBottomPadding']! as double,
    closeIconSize: map['closeIconSize']! as double,
    closeIconInset: map['closeIconInset']! as double,
    closeIconStrokeWidth: map['closeIconStrokeWidth']! as double,
    exitFadeDuration: map['exitFadeDuration']! as Duration,
    smallWidth: map['smallWidth']! as double,
    mediumWidth: map['mediumWidth']! as double,
    largeWidth: map['largeWidth']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalModalMetrics &&
          other.initialScale == initialScale &&
          other.minWidth == minWidth &&
          other.cornerRadius == cornerRadius &&
          other.titleHorizontalPadding == titleHorizontalPadding &&
          other.actionPadding == actionPadding &&
          other.bottomSheetMinimumBottomPadding == bottomSheetMinimumBottomPadding &&
          other.closeIconSize == closeIconSize &&
          other.closeIconInset == closeIconInset &&
          other.closeIconStrokeWidth == closeIconStrokeWidth &&
          other.exitFadeDuration == exitFadeDuration &&
          other.smallWidth == smallWidth &&
          other.mediumWidth == mediumWidth &&
          other.largeWidth == largeWidth;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    initialScale,
    minWidth,
    cornerRadius,
    titleHorizontalPadding,
    actionPadding,
    bottomSheetMinimumBottomPadding,
    closeIconSize,
    closeIconInset,
    closeIconStrokeWidth,
    exitFadeDuration,
    smallWidth,
    mediumWidth,
    largeWidth,
  ]);
}
