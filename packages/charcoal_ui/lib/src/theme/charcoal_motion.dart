import 'package:flutter/widgets.dart';

/// Shared motion values for Charcoal interactions.
///
/// Component implementations own their source-backed durations. These curves
/// and route timings provide one motion language for composition behavior.
abstract final class CharcoalMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 200);
  static const Duration routeForward = Duration(milliseconds: 220);
  static const Duration routeReverse = Duration(milliseconds: 180);

  static const Curve standardCurve = Cubic(0.2, 0, 0, 1);
  static const Curve emphasizedCurve = Cubic(0.16, 1, 0.3, 1);

  static Duration resolveDuration(BuildContext context, Duration duration) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : duration;
}
