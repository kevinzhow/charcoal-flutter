// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// The 51x31 switch (UISwitch geometry used by Charcoal SwiftUI).
@immutable
class CharcoalSwitchMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalSwitchMetrics({
    required this.trackWidth,
    required this.trackHeight,
    required this.trackInset,
    required this.thumbSize,
  });

  /// Track width.
  final double trackWidth;

  /// Track height.
  final double trackHeight;

  /// Gap between track edge and thumb.
  final double trackInset;

  /// Thumb diameter.
  final double thumbSize;

  /// A copy with the given fields replaced.
  CharcoalSwitchMetrics copyWith({
    double? trackWidth,
    double? trackHeight,
    double? trackInset,
    double? thumbSize,
  }) => CharcoalSwitchMetrics(
    trackWidth: trackWidth ?? this.trackWidth,
    trackHeight: trackHeight ?? this.trackHeight,
    trackInset: trackInset ?? this.trackInset,
    thumbSize: thumbSize ?? this.thumbSize,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'trackWidth': trackWidth,
    'trackHeight': trackHeight,
    'trackInset': trackInset,
    'thumbSize': thumbSize,
  };

  /// Inverse of [toMap].
  static CharcoalSwitchMetrics fromMap(Map<String, Object?> map) => CharcoalSwitchMetrics(
    trackWidth: map['trackWidth']! as double,
    trackHeight: map['trackHeight']! as double,
    trackInset: map['trackInset']! as double,
    thumbSize: map['thumbSize']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalSwitchMetrics &&
          other.trackWidth == trackWidth &&
          other.trackHeight == trackHeight &&
          other.trackInset == trackInset &&
          other.thumbSize == thumbSize;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    trackWidth,
    trackHeight,
    trackInset,
    thumbSize,
  ]);
}
