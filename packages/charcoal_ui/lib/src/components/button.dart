import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/charcoal_theme_data.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

enum CharcoalButtonVariant { normal, primary, overlay, danger, navigation }

enum CharcoalButtonSize { small, medium }

abstract final class _ButtonSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const focusRingWidth = 4.0;
  static const iconSize = 16.0;
  static const smallVerticalPadding = 5.0;
  static const mediumVerticalPadding = 9.0;
}

/// A Charcoal V2 button implemented entirely with Flutter Widgets.
///
/// When [selected] is null this is a regular action. A non-null value makes it
/// a controlled toggle whose selected or unselected state is exposed through
/// semantics.
final class CharcoalButton extends StatelessWidget {
  const CharcoalButton({
    required this.child,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.fullWidth = false,
    this.leading,
    this.primaryColor,
    this.semanticLabel,
    this.selected,
    this.size = CharcoalButtonSize.medium,
    this.statesController,
    this.trailing,
    this.variant = CharcoalButtonVariant.normal,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool fullWidth;
  final Widget? leading;
  final Color? primaryColor;
  final String? semanticLabel;
  final bool? selected;
  final CharcoalButtonSize size;
  final WidgetStatesController? statesController;
  final Widget? trailing;
  final CharcoalButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final sizeSpec = switch (size) {
      // CharcoalButtonSizes+Extension.swift and the explicit disabled frames in
      // CharcoalNavigationButton.swift. These component values resolve through
      // the semantic target and component spacing foundations.
      CharcoalButtonSize.small => (
        height: theme.dimensions.space.targetS,
        horizontalPadding: theme.dimensions.space.component30,
        verticalPadding: _ButtonSpec.smallVerticalPadding,
      ),
      CharcoalButtonSize.medium => (
        height: theme.dimensions.space.targetM,
        horizontalPadding: theme.dimensions.space.component40,
        verticalPadding: _ButtonSpec.mediumVerticalPadding,
      ),
    };
    final iconGap = theme.dimensions.space.component10;
    final palette = _buttonPalette(theme, variant);

    return MergeSemantics(
      child: Semantics(
        selected: selected,
        child: CharcoalClickable(
          autofocus: autofocus,
          focusNode: focusNode,
          onPressed: onPressed,
          selected: selected ?? false,
          semanticLabel: semanticLabel,
          statesController: statesController,
          builder: (context, states) {
            final visualStates = selected == true
                ? <WidgetState>{...states, WidgetState.pressed}
                : states;
            final background = variant == CharcoalButtonVariant.primary && primaryColor != null
                ? _resolveCustomPrimaryColor(
                    primaryColor!,
                    visualStates,
                    theme,
                  )
                : resolveCharcoalStateColor(
                    visualStates,
                    normal: palette.normalBackground,
                    hovered: palette.hoveredBackground,
                    pressed: palette.pressedBackground,
                    disabled: palette.normalBackground,
                  );
            final foreground = resolveCharcoalStateColor(
              visualStates,
              normal: palette.normalForeground,
              hovered: palette.hoveredForeground,
              pressed: palette.pressedForeground,
              disabled: palette.normalForeground,
            );
            final isDisabled = states.contains(WidgetState.disabled);
            final isFocused = states.contains(WidgetState.focused);
            final textStyle = charcoalTypographyStyle(
              context,
              color: foreground,
              size: CharcoalTypographySize.size14,
              weight: CharcoalTypographyWeight.bold,
            );

            Widget content = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  IconTheme(
                    data: const IconThemeData(
                      size: _ButtonSpec.iconSize,
                    ).copyWith(color: foreground),
                    child: leading!,
                  ),
                  SizedBox(width: iconGap),
                ],
                Flexible(
                  child: DefaultTextStyle(style: textStyle, child: child),
                ),
                if (trailing != null) ...<Widget>[
                  SizedBox(width: iconGap),
                  IconTheme(
                    data: const IconThemeData(
                      size: _ButtonSpec.iconSize,
                    ).copyWith(color: foreground),
                    child: trailing!,
                  ),
                ],
              ],
            );

            content = AnimatedContainer(
              duration: CharcoalMotion.resolveDuration(
                context,
                _ButtonSpec.animationDuration,
              ),
              curve: CharcoalMotion.standardCurve,
              constraints: BoxConstraints(minHeight: sizeSpec.height),
              padding: EdgeInsets.symmetric(
                horizontal: sizeSpec.horizontalPadding,
                vertical: sizeSpec.verticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
                boxShadow: isFocused
                    ? <BoxShadow>[
                        BoxShadow(
                          color: theme.colors.borderFocusLegacy,
                          spreadRadius: _ButtonSpec.focusRingWidth,
                        ),
                      ]
                    : const <BoxShadow>[],
                color: background,
              ),
              child: content,
            );

            if (fullWidth) {
              content = SizedBox(width: double.infinity, child: content);
            }
            return AnimatedOpacity(
              curve: CharcoalMotion.standardCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                _ButtonSpec.animationDuration,
              ),
              opacity: isDisabled
                  ? variant == CharcoalButtonVariant.navigation
                        ? 0
                        : charcoalDisabledOpacity
                  : 1,
              child: content,
            );
          },
        ),
      ),
    );
  }
}

Color _resolveCustomPrimaryColor(
  Color base,
  Set<WidgetState> states,
  CharcoalThemeData theme,
) {
  if (states.contains(WidgetState.pressed)) {
    return Color.alphaBlend(theme.colors.containerPressA, base);
  }
  if (states.contains(WidgetState.hovered)) {
    return Color.alphaBlend(theme.colors.containerHoverA, base);
  }
  return base;
}

/// Charcoal's text-only link button.
///
/// It keeps the 40-pixel iOS touch target while leaving the background clear.
final class CharcoalLinkButton extends StatelessWidget {
  const CharcoalLinkButton({
    required this.child,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final WidgetStatesController? statesController;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final spec = (
      height: theme.dimensions.space.targetM,
      horizontalPadding: theme.dimensions.space.component30,
      verticalPadding: _ButtonSpec.mediumVerticalPadding,
      radius: theme.dimensions.radius.s,
    );
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        focusNode: focusNode,
        onPressed: onPressed,
        semanticLabel: semanticLabel,
        statesController: statesController,
        builder: (context, states) {
          final disabled = states.contains(WidgetState.disabled);
          final focused = states.contains(WidgetState.focused);
          final color = resolveCharcoalStateColor(
            states,
            normal: theme.colors.textDefault,
            hovered: theme.colors.textHover,
            pressed: theme.colors.textTertiaryDefault,
            disabled: theme.colors.textDefault,
          );
          return AnimatedOpacity(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(
              context,
              _ButtonSpec.animationDuration,
            ),
            opacity: disabled ? charcoalDisabledOpacity : 1,
            child: AnimatedContainer(
              duration: CharcoalMotion.resolveDuration(
                context,
                _ButtonSpec.animationDuration,
              ),
              curve: CharcoalMotion.standardCurve,
              constraints: BoxConstraints(minHeight: spec.height),
              padding: EdgeInsets.symmetric(
                horizontal: spec.horizontalPadding,
                vertical: spec.verticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spec.radius),
                boxShadow: focused
                    ? <BoxShadow>[
                        BoxShadow(
                          color: theme.colors.borderFocusLegacy,
                          spreadRadius: _ButtonSpec.focusRingWidth,
                        ),
                      ]
                    : const <BoxShadow>[],
              ),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: DefaultTextStyle(
                  style: charcoalTypographyStyle(
                    context,
                    color: color,
                    size: CharcoalTypographySize.size14,
                    weight: CharcoalTypographyWeight.bold,
                  ),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

typedef _ButtonPalette = ({
  Color normalBackground,
  Color hoveredBackground,
  Color pressedBackground,
  Color normalForeground,
  Color hoveredForeground,
  Color pressedForeground,
});

_ButtonPalette _buttonPalette(CharcoalThemeData theme, CharcoalButtonVariant variant) =>
    switch (variant) {
      CharcoalButtonVariant.normal => (
        normalBackground: theme.colors.containerSecondaryDefaultA,
        hoveredBackground: theme.colors.containerSecondaryHoverA,
        pressedBackground: theme.colors.containerSecondaryPressA,
        normalForeground: theme.colors.textSecondaryDefault,
        hoveredForeground: theme.colors.textSecondaryHover,
        pressedForeground: theme.colors.textSecondaryPress,
      ),
      CharcoalButtonVariant.primary => (
        normalBackground: theme.colors.containerPrimaryDefault,
        hoveredBackground: theme.colors.containerPrimaryHover,
        pressedBackground: theme.colors.containerPrimaryPress,
        normalForeground: theme.colors.textOnPrimaryDefault,
        hoveredForeground: theme.colors.textOnPrimaryHover,
        pressedForeground: theme.colors.textOnPrimaryPress,
      ),
      CharcoalButtonVariant.overlay => (
        normalBackground: theme.colors.containerOnImgDefault,
        hoveredBackground: theme.colors.containerOnImgHover,
        pressedBackground: theme.colors.containerOnImgPress,
        normalForeground: theme.colors.textOnOnImgDefault,
        hoveredForeground: theme.colors.textOnOnImgHover,
        pressedForeground: theme.colors.textOnOnImgPress,
      ),
      CharcoalButtonVariant.danger => (
        normalBackground: theme.colors.containerNegativeDefault,
        hoveredBackground: theme.colors.containerNegativeHover,
        pressedBackground: theme.colors.containerNegativePress,
        normalForeground: theme.colors.textOnNegativeDefault,
        hoveredForeground: theme.colors.textOnNegativeHover,
        pressedForeground: theme.colors.textOnNegativePress,
      ),
      CharcoalButtonVariant.navigation => (
        normalBackground: theme.colors.containerHudDefault,
        hoveredBackground: theme.colors.containerHudHover,
        pressedBackground: theme.colors.containerHudPress,
        normalForeground: theme.colors.textOnHudDefault,
        hoveredForeground: theme.colors.textOnHudHover,
        pressedForeground: theme.colors.textOnHudPress,
      ),
    };

/// Shows one of two registered buttons without changing the layout size.
///
/// This is the Flutter counterpart of Charcoal iOS's UIKit-only
/// `CharcoalSwitchingButton`. Both children remain laid out, and [isOn]
/// selects which one is painted, focusable, animated, and exposed to
/// semantics. Each visible button owns its own action semantics; this layout
/// wrapper does not add a separate toggle node.
final class CharcoalSwitchingButton extends StatelessWidget {
  const CharcoalSwitchingButton({
    required this.isOn,
    required this.offButton,
    required this.onButton,
    super.key,
  });

  final bool isOn;
  final Widget offButton;
  final Widget onButton;

  @override
  Widget build(BuildContext context) {
    Widget branch({required bool visible, required Widget child}) => ExcludeFocus(
      excluding: !visible,
      child: ExcludeSemantics(
        excluding: !visible,
        child: TickerMode(enabled: visible, child: child),
      ),
    );

    return IndexedStack(
      alignment: Alignment.center,
      index: isOn ? 0 : 1,
      children: <Widget>[
        branch(visible: isOn, child: onButton),
        branch(visible: !isOn, child: offButton),
      ],
    );
  }
}
