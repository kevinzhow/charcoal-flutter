// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Multi-line text area.
@immutable
class CharcoalTextAreaMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalTextAreaMetrics({
    required this.horizontalInset,
    required this.counterBottomInset,
    required this.lineHeight,
    required this.verticalChrome,
    required this.defaultRows,
  });

  /// Horizontal padding.
  final double horizontalInset;

  /// Gap under the character counter.
  final double counterBottomInset;

  /// Line height used to size the box before text scaling.
  final double lineHeight;

  /// Vertical padding plus border around the lines.
  final double verticalChrome;

  /// Rows shown when the caller passes none.
  final int defaultRows;

  /// A copy with the given fields replaced.
  CharcoalTextAreaMetrics copyWith({
    double? horizontalInset,
    double? counterBottomInset,
    double? lineHeight,
    double? verticalChrome,
    int? defaultRows,
  }) => CharcoalTextAreaMetrics(
    horizontalInset: horizontalInset ?? this.horizontalInset,
    counterBottomInset: counterBottomInset ?? this.counterBottomInset,
    lineHeight: lineHeight ?? this.lineHeight,
    verticalChrome: verticalChrome ?? this.verticalChrome,
    defaultRows: defaultRows ?? this.defaultRows,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'horizontalInset': horizontalInset,
    'counterBottomInset': counterBottomInset,
    'lineHeight': lineHeight,
    'verticalChrome': verticalChrome,
    'defaultRows': defaultRows,
  };

  /// Inverse of [toMap].
  static CharcoalTextAreaMetrics fromMap(Map<String, Object?> map) => CharcoalTextAreaMetrics(
    horizontalInset: map['horizontalInset']! as double,
    counterBottomInset: map['counterBottomInset']! as double,
    lineHeight: map['lineHeight']! as double,
    verticalChrome: map['verticalChrome']! as double,
    defaultRows: map['defaultRows']! as int,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTextAreaMetrics &&
          other.horizontalInset == horizontalInset &&
          other.counterBottomInset == counterBottomInset &&
          other.lineHeight == lineHeight &&
          other.verticalChrome == verticalChrome &&
          other.defaultRows == defaultRows;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    horizontalInset,
    counterBottomInset,
    lineHeight,
    verticalChrome,
    defaultRows,
  ]);
}
