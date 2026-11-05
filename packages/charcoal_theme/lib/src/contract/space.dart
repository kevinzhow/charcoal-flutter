// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Spacing scale. Widgets pick a step; they never write a number.
@immutable
class CharcoalSpaceScale {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalSpaceScale({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// Hairline gaps: between adjacent navigation items.
  final double xxs;

  /// Tight gaps: icon and label, title and subtitle.
  final double xs;

  /// Gaps between sibling controls; inside chips and fields.
  final double sm;

  /// Gaps between form fields; around banner content.
  final double md;

  /// Card padding; viewport margin of floating surfaces.
  final double lg;

  /// Dialog padding; gaps between form sections.
  final double xl;

  /// Section separation; empty-state padding.
  final double xxl;

  /// Page-level breathing room; tab-bar baseline height.
  final double xxxl;

  /// A copy with the given fields replaced.
  CharcoalSpaceScale copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) => CharcoalSpaceScale(
    xxs: xxs ?? this.xxs,
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
    xxl: xxl ?? this.xxl,
    xxxl: xxxl ?? this.xxxl,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'xxs': xxs,
    'xs': xs,
    'sm': sm,
    'md': md,
    'lg': lg,
    'xl': xl,
    'xxl': xxl,
    'xxxl': xxxl,
  };

  /// Inverse of [toMap].
  static CharcoalSpaceScale fromMap(Map<String, Object?> map) => CharcoalSpaceScale(
    xxs: map['xxs']! as double,
    xs: map['xs']! as double,
    sm: map['sm']! as double,
    md: map['md']! as double,
    lg: map['lg']! as double,
    xl: map['xl']! as double,
    xxl: map['xxl']! as double,
    xxxl: map['xxxl']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalSpaceScale &&
          other.xxs == xxs &&
          other.xs == xs &&
          other.sm == sm &&
          other.md == md &&
          other.lg == lg &&
          other.xl == xl &&
          other.xxl == xxl &&
          other.xxxl == xxxl;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    xxs,
    xs,
    sm,
    md,
    lg,
    xl,
    xxl,
    xxxl,
  ]);
}
