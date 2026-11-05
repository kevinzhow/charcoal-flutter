// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Carousel.
@immutable
class CharcoalCarouselMetrics {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalCarouselMetrics({
    required this.navigationFadeDuration,
    required this.scrollDuration,
    required this.mediumViewportFraction,
    required this.navigationZoneWidth,
  });

  /// Fade of the previous/next zones.
  final Duration navigationFadeDuration;

  /// Animated page change.
  final Duration scrollDuration;

  /// Viewport fraction of the medium size.
  final double mediumViewportFraction;

  /// Width of each navigation zone.
  final double navigationZoneWidth;

  /// A copy with the given fields replaced.
  CharcoalCarouselMetrics copyWith({
    Duration? navigationFadeDuration,
    Duration? scrollDuration,
    double? mediumViewportFraction,
    double? navigationZoneWidth,
  }) => CharcoalCarouselMetrics(
    navigationFadeDuration: navigationFadeDuration ?? this.navigationFadeDuration,
    scrollDuration: scrollDuration ?? this.scrollDuration,
    mediumViewportFraction: mediumViewportFraction ?? this.mediumViewportFraction,
    navigationZoneWidth: navigationZoneWidth ?? this.navigationZoneWidth,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'navigationFadeDuration': navigationFadeDuration,
    'scrollDuration': scrollDuration,
    'mediumViewportFraction': mediumViewportFraction,
    'navigationZoneWidth': navigationZoneWidth,
  };

  /// Inverse of [toMap].
  static CharcoalCarouselMetrics fromMap(Map<String, Object?> map) => CharcoalCarouselMetrics(
    navigationFadeDuration: map['navigationFadeDuration']! as Duration,
    scrollDuration: map['scrollDuration']! as Duration,
    mediumViewportFraction: map['mediumViewportFraction']! as double,
    navigationZoneWidth: map['navigationZoneWidth']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalCarouselMetrics &&
          other.navigationFadeDuration == navigationFadeDuration &&
          other.scrollDuration == scrollDuration &&
          other.mediumViewportFraction == mediumViewportFraction &&
          other.navigationZoneWidth == navigationZoneWidth;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    navigationFadeDuration,
    scrollDuration,
    mediumViewportFraction,
    navigationZoneWidth,
  ]);
}
