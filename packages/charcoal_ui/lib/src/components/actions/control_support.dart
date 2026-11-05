import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

/// The translucent halo around a focused (or invalid) control.
///
/// Returns an empty list when not [visible], so the decoration keeps the same shape in every state
/// and the control's bounds never move.
List<BoxShadow> charcoalHaloShadow(
  CharcoalTheme theme, {
  required bool visible,
  Color? color,
  double? spread,
}) => visible
    ? <BoxShadow>[
        BoxShadow(
          color: color ?? theme.colors.focusRing,
          spreadRadius: spread ?? theme.borders.focusHalo,
        ),
      ]
    : const <BoxShadow>[];

/// Fades [child] to the theme's disabled opacity (or hides it) when [disabled].
///
/// The fade is the only disabled treatment of a Charcoal control: colours stay those of the
/// enabled control, so geometry and hit-testing do not change.
class CharcoalDisabledFade extends StatelessWidget {
  /// Creates a fade; [hidden] makes the disabled state fully transparent (navigation buttons).
  const CharcoalDisabledFade({
    required this.disabled,
    required this.child,
    this.hidden = false,
    super.key,
  });

  /// Whether the control is disabled.
  final bool disabled;

  /// Whether the disabled state is invisible instead of dimmed.
  final bool hidden;

  /// The control to fade.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return AnimatedOpacity(
      curve: theme.motion.curve,
      duration: theme.duration(context, theme.motion.standard),
      opacity: disabled ? (hidden ? 0 : theme.metrics.clickable.disabledOpacity) : 1,
      child: child,
    );
  }
}

/// A control's text label in a 14 px style with the theme's text colour.
class CharcoalControlLabel extends StatelessWidget {
  /// Creates a label wrapper for [child]; [role] picks the line height.
  const CharcoalControlLabel({
    required this.child,
    this.role = CharcoalTextRole.size14,
    super.key,
  });

  /// The text role of the label.
  final CharcoalTextRole role;

  /// The label content, usually a `Text`.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DefaultTextStyle(
      style: theme.style(role),
      child: child,
    );
  }
}
