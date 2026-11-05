// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Corner radii.
@immutable
class CharcoalRadiusScale {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalRadiusScale({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.pill,
  });

  /// Meter tracks.
  final double xs;

  /// Chips, fields and the selection box.
  final double sm;

  /// Cards, banners, tooltips and square avatars.
  final double md;

  /// Focus-ring corners of rounded controls.
  final double lg;

  /// Large surfaces.
  final double xl;

  /// Largest token radius.
  final double xxl;

  /// Fully rounded: buttons, circular avatars, switch tracks.
  final double pill;

  /// A copy with the given fields replaced.
  CharcoalRadiusScale copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? pill,
  }) => CharcoalRadiusScale(
    xs: xs ?? this.xs,
    sm: sm ?? this.sm,
    md: md ?? this.md,
    lg: lg ?? this.lg,
    xl: xl ?? this.xl,
    xxl: xxl ?? this.xxl,
    pill: pill ?? this.pill,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'xs': xs,
    'sm': sm,
    'md': md,
    'lg': lg,
    'xl': xl,
    'xxl': xxl,
    'pill': pill,
  };

  /// Inverse of [toMap].
  static CharcoalRadiusScale fromMap(Map<String, Object?> map) => CharcoalRadiusScale(
    xs: map['xs']! as double,
    sm: map['sm']! as double,
    md: map['md']! as double,
    lg: map['lg']! as double,
    xl: map['xl']! as double,
    xxl: map['xxl']! as double,
    pill: map['pill']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalRadiusScale &&
          other.xs == xs &&
          other.sm == sm &&
          other.md == md &&
          other.lg == lg &&
          other.xl == xl &&
          other.xxl == xxl &&
          other.pill == pill;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    xs,
    sm,
    md,
    lg,
    xl,
    xxl,
    pill,
  ]);
}
