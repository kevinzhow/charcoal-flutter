import 'package:flutter/material.dart';

import '../contract/colors.dart';
import '../contract/typography.dart';
import '../theme.dart';

/// Fill families of the Charcoal button.
enum CharcoalButtonVariant {
  /// Translucent secondary fill (the default button).
  normal,

  /// Brand fill.
  primary,

  /// Negative fill.
  danger,

  /// Translucent fill for a button drawn over an image.
  overlay,

  /// Heads-up-display fill for navigation-bar buttons.
  navigation,
}

/// Fills and text colour of one [CharcoalButtonVariant]; hover and press foregrounds differ only
/// for the `normal` variant.
typedef CharcoalButtonColors = ({
  Color rest,
  Color hover,
  Color press,
  Color foreground,
  Color foregroundHover,
  Color foregroundPress,
});

/// The colours of [variant] under [theme]: the single source for Material button themes and for
/// the custom-painted `charcoal_ui` buttons.
CharcoalButtonColors charcoalButtonColors(CharcoalTheme theme, CharcoalButtonVariant variant) {
  final c = theme.colors;
  CharcoalButtonColors fixed(Color rest, Color hover, Color press, Color foreground) => (
    rest: rest,
    hover: hover,
    press: press,
    foreground: foreground,
    foregroundHover: foreground,
    foregroundPress: foreground,
  );
  return switch (variant) {
    CharcoalButtonVariant.normal => (
      rest: c.fillSecondary,
      hover: c.fillSecondaryHover,
      press: c.fillSecondaryPress,
      foreground: c.textSecondary,
      foregroundHover: c.textSecondaryHover,
      foregroundPress: c.textSecondaryPress,
    ),
    CharcoalButtonVariant.primary => fixed(
      c.primary,
      c.primaryHover,
      c.primaryPress,
      c.textOnPrimary,
    ),
    CharcoalButtonVariant.danger => fixed(
      c.negative,
      c.negativeHover,
      c.negativePress,
      c.textOnNegative,
    ),
    CharcoalButtonVariant.overlay => fixed(
      c.fillOnImage,
      c.fillOnImageHover,
      c.fillOnImagePress,
      c.textOnImage,
    ),
    CharcoalButtonVariant.navigation => fixed(c.hud, c.hudHover, c.hudPress, c.textOnHud),
  };
}

/// The one Charcoal button style: a pill, `sizes.controlMd` tall (`controlSm` when [small]),
/// filled per [variant]. Material's button themes in `buildCharcoalThemeData` use it, and
/// `charcoal_ui` buttons reuse it, so there is a single recipe.
ButtonStyle buildCharcoalButtonStyle(
  CharcoalTheme theme,
  CharcoalButtonVariant variant, {
  bool small = false,
}) {
  final c = theme.colors;
  final colors = charcoalButtonColors(theme, variant);
  final (rest, hover, press, foreground) = (
    colors.rest,
    colors.hover,
    colors.press,
    colors.foreground,
  );
  const clear = CharcoalColorRoles.transparent;
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled)
          ? c.surfaceDisabled
          : states.contains(WidgetState.pressed)
          ? press
          : states.contains(WidgetState.hovered)
          ? hover
          : rest,
    ),
    foregroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? c.textDisabled : foreground,
    ),
    iconColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? c.iconDisabled : foreground,
    ),
    overlayColor: const WidgetStatePropertyAll(clear),
    surfaceTintColor: const WidgetStatePropertyAll(clear),
    shadowColor: const WidgetStatePropertyAll(clear),
    elevation: WidgetStatePropertyAll(theme.elevation.surface),
    minimumSize: WidgetStatePropertyAll(
      Size(0, small ? theme.sizes.controlSm : theme.sizes.controlMd),
    ),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        horizontal: small ? theme.space.lg : theme.space.xl,
        vertical: small
            ? theme.metrics.button.smallVerticalPadding
            : theme.metrics.button.mediumVerticalPadding,
      ),
    ),
    iconSize: WidgetStatePropertyAll(theme.metrics.button.iconSize),
    textStyle: WidgetStatePropertyAll(theme.style(CharcoalTextRole.bodyBold)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(theme.radius.pill)),
    ),
    side: const WidgetStatePropertyAll(BorderSide.none),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.standard,
  );
}
