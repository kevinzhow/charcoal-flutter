// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/animation.dart' show Curve;
import 'package:flutter/foundation.dart' show immutable;

/// Animation timing and easing.
@immutable
class CharcoalMotionScale {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalMotionScale({
    required this.fast,
    required this.standard,
    required this.overlay,
    required this.routeForward,
    required this.routeReverse,
    required this.toastVisible,
    required this.curve,
    required this.emphasizedCurve,
  });

  /// Hover and press feedback.
  final Duration fast;

  /// Transitions of a control's state.
  final Duration standard;

  /// Entrance and exit of dialogs, toasts and spinner overlays.
  final Duration overlay;

  /// Page push transition.
  final Duration routeForward;

  /// Page pop transition.
  final Duration routeReverse;

  /// How long a toast stays on screen.
  final Duration toastVisible;

  /// The one easing curve.
  final Curve curve;

  /// Easing for entrances that should feel emphasised.
  final Curve emphasizedCurve;

  /// A copy with the given fields replaced.
  CharcoalMotionScale copyWith({
    Duration? fast,
    Duration? standard,
    Duration? overlay,
    Duration? routeForward,
    Duration? routeReverse,
    Duration? toastVisible,
    Curve? curve,
    Curve? emphasizedCurve,
  }) => CharcoalMotionScale(
    fast: fast ?? this.fast,
    standard: standard ?? this.standard,
    overlay: overlay ?? this.overlay,
    routeForward: routeForward ?? this.routeForward,
    routeReverse: routeReverse ?? this.routeReverse,
    toastVisible: toastVisible ?? this.toastVisible,
    curve: curve ?? this.curve,
    emphasizedCurve: emphasizedCurve ?? this.emphasizedCurve,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'fast': fast,
    'standard': standard,
    'overlay': overlay,
    'routeForward': routeForward,
    'routeReverse': routeReverse,
    'toastVisible': toastVisible,
    'curve': curve,
    'emphasizedCurve': emphasizedCurve,
  };

  /// Inverse of [toMap].
  static CharcoalMotionScale fromMap(Map<String, Object?> map) => CharcoalMotionScale(
    fast: map['fast']! as Duration,
    standard: map['standard']! as Duration,
    overlay: map['overlay']! as Duration,
    routeForward: map['routeForward']! as Duration,
    routeReverse: map['routeReverse']! as Duration,
    toastVisible: map['toastVisible']! as Duration,
    curve: map['curve']! as Curve,
    emphasizedCurve: map['emphasizedCurve']! as Curve,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalMotionScale &&
          other.fast == fast &&
          other.standard == standard &&
          other.overlay == overlay &&
          other.routeForward == routeForward &&
          other.routeReverse == routeReverse &&
          other.toastVisible == toastVisible &&
          other.curve == curve &&
          other.emphasizedCurve == emphasizedCurve;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    fast,
    standard,
    overlay,
    routeForward,
    routeReverse,
    toastVisible,
    curve,
    emphasizedCurve,
  ]);
}
