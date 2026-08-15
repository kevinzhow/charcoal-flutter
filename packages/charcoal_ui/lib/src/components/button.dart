import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
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
        final background = variantTokens.background.resolve(visualStates);
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
          height: sizeTokens.height,
          padding: EdgeInsets.symmetric(horizontal: sizeTokens.paddingHorizontal),
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
          opacity: isDisabled ? buttonTokens.disabledOpacity : 1,
          child: content,
        );
      },
    );
  }
}
