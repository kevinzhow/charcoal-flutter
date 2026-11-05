// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Single-line text field.
@immutable
class CharcoalTextFieldMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalTextFieldMetrics({
    required this.verticalPadding,
    required this.contentGap,
    required this.iconSize,
  });

  /// Vertical padding inside the field.
  final double verticalPadding;

  /// Gap between prefix, input and suffix.
  final double contentGap;

  /// Affordance icon edge.
  final double iconSize;

  /// A copy with the given fields replaced.
  CharcoalTextFieldMetrics copyWith({
    double? verticalPadding,
    double? contentGap,
    double? iconSize,
  }) => CharcoalTextFieldMetrics(
    verticalPadding: verticalPadding ?? this.verticalPadding,
    contentGap: contentGap ?? this.contentGap,
    iconSize: iconSize ?? this.iconSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'verticalPadding': verticalPadding,
    'contentGap': contentGap,
    'iconSize': iconSize,
  };

  /// Inverse of [toMap].
  static CharcoalTextFieldMetrics fromMap(Map<String, Object?> map) => CharcoalTextFieldMetrics(
    verticalPadding: map['verticalPadding']! as double,
    contentGap: map['contentGap']! as double,
    iconSize: map['iconSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalTextFieldMetrics &&
          other.verticalPadding == verticalPadding &&
          other.contentGap == contentGap &&
          other.iconSize == iconSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    verticalPadding,
    contentGap,
    iconSize,
  ]);
}
