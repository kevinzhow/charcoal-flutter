import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// A step of the theme's motion scale, for an animation the application starts itself (for
/// example scrolling a conversation to its newest message).
///
/// Code names a step; the duration and the easing curve come from the active pack, and the
/// duration is zero when the platform asks for reduced motion. Components animate on their own
/// and need no step.
enum CharcoalMotion {
  /// `motion.fast`: hover and press feedback.
  fast,

  /// `motion.standard`: a change of state or position.
  standard,

  /// `motion.overlay`: an overlay entering or leaving.
  overlay;

  /// This step's duration in [scale].
  Duration of(CharcoalMotionScale scale) => switch (this) {
    CharcoalMotion.fast => scale.fast,
    CharcoalMotion.standard => scale.standard,
    CharcoalMotion.overlay => scale.overlay,
  };

  /// This step's duration under the theme in [context]; zero when animations are disabled.
  Duration resolve(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return theme.duration(context, of(theme.motion));
  }

  /// The pack's easing curve, shared by every step.
  static Curve curveOf(BuildContext context) => CharcoalTheme.of(context).motion.curve;
}
