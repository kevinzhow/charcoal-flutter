import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/charcoal_theme_data.dart';
import '../theme/component_tokens.dart';
import 'clickable.dart';

/// A Charcoal V2 button implemented entirely with Flutter Widgets.
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
    this.selected = false,
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
  final bool selected;
  final CharcoalButtonSize size;
  final WidgetStatesController? statesController;
  final Widget? trailing;
  final CharcoalButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final buttonTokens = theme.components.button;
    final sizeTokens = buttonTokens.size(size);
    final variantTokens = buttonTokens.variant(variant);

    return CharcoalClickable(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onPressed,
      selected: selected,
      semanticLabel: semanticLabel,
      statesController: statesController,
      builder: (context, states) {
        final visualStates = selected ? <WidgetState>{...states, WidgetState.pressed} : states;
        final background = variant == CharcoalButtonVariant.primary && primaryColor != null
            ? _resolveCustomPrimaryColor(
                primaryColor!,
                visualStates,
                theme,
              )
            : variantTokens.background.resolve(visualStates);
        final foreground = variantTokens.foreground.resolve(visualStates);
        final isDisabled = states.contains(WidgetState.disabled);
        final isFocused = states.contains(WidgetState.focused);
        final textStyle = TextStyle(
          color: foreground,
          fontFamily: theme.typography.fontFamily.sans,
          fontSize: sizeTokens.fontSize,
          fontWeight: sizeTokens.fontWeight,
          height: sizeTokens.lineHeight / sizeTokens.fontSize,
          leadingDistribution: TextLeadingDistribution.even,
        );

        Widget content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: <Widget>[
            if (leading != null) ...<Widget>[
              IconTheme(
                data: IconThemeData(color: foreground, size: sizeTokens.iconSize),
                child: leading!,
              ),
              SizedBox(width: sizeTokens.gap),
            ],
            Flexible(
              child: DefaultTextStyle(style: textStyle, child: child),
            ),
            if (trailing != null) ...<Widget>[
              SizedBox(width: sizeTokens.gap),
              IconTheme(
                data: IconThemeData(color: foreground, size: sizeTokens.iconSize),
                child: trailing!,
              ),
            ],
          ],
        );

        content = AnimatedContainer(
          duration: buttonTokens.animationDuration,
          curve: CharcoalMotion.standardCurve,
          constraints: BoxConstraints(minHeight: sizeTokens.height),
          padding: EdgeInsets.symmetric(
            horizontal: sizeTokens.paddingHorizontal,
            vertical: ((sizeTokens.height - sizeTokens.lineHeight) / 2)
                .clamp(0, double.infinity)
                .toDouble(),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sizeTokens.radius),
            boxShadow: isFocused
                ? <BoxShadow>[
                    BoxShadow(
                      color: buttonTokens.focusRingColor,
                      spreadRadius: buttonTokens.focusRingWidth,
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
          duration: buttonTokens.animationDuration,
          opacity: isDisabled
              ? variant == CharcoalButtonVariant.navigation
                    ? 0
                    : buttonTokens.disabledOpacity
              : 1,
          child: content,
        );
      },
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
    final tokens = theme.components.linkButton;
    return CharcoalClickable(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      statesController: statesController,
      builder: (context, states) {
        final disabled = states.contains(WidgetState.disabled);
        final focused = states.contains(WidgetState.focused);
        final color = tokens.foreground.resolve(states);
        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: tokens.animationDuration,
          opacity: disabled ? tokens.disabledOpacity : 1,
          child: AnimatedContainer(
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            constraints: BoxConstraints(minHeight: tokens.height),
            padding: EdgeInsets.symmetric(
              horizontal: tokens.paddingHorizontal,
              vertical: ((tokens.height - tokens.lineHeight) / 2)
                  .clamp(0, double.infinity)
                  .toDouble(),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radius),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: tokens.focusRingColor,
                        spreadRadius: tokens.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
            ),
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: color,
                  fontFamily: theme.typography.fontFamily.sans,
                  fontSize: tokens.fontSize,
                  fontWeight: tokens.fontWeight,
                  height: tokens.lineHeight / tokens.fontSize,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Shows one of two registered buttons without changing the layout size.
///
/// This is the Flutter counterpart of Charcoal iOS's UIKit-only
/// `CharcoalSwitchingButton`. Both children remain laid out, and [isOn]
/// selects which one is painted and exposed to semantics.
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
  Widget build(BuildContext context) => Semantics(
    container: true,
    toggled: isOn,
    child: IndexedStack(
      alignment: Alignment.center,
      index: isOn ? 0 : 1,
      children: <Widget>[onButton, offButton],
    ),
  );
}
