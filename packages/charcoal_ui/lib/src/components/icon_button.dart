import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import '../theme/component_tokens.dart';
import 'clickable.dart';

/// A circular Charcoal V2 button for an icon-only action.
final class CharcoalIconButton extends StatelessWidget {
  const CharcoalIconButton({
    required this.icon,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.selected = false,
    this.size = CharcoalIconButtonSize.medium,
    this.statesController,
    this.variant = CharcoalIconButtonVariant.normal,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final bool selected;
  final CharcoalIconButtonSize size;
  final WidgetStatesController? statesController;
  final CharcoalIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final tokens = theme.components.iconButton;
    final sizeTokens = tokens.size(size);
    final variantTokens = tokens.variant(variant);
    return CharcoalClickable(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onPressed,
      selected: selected,
      semanticLabel: semanticLabel,
      statesController: statesController,
      builder: (context, states) {
        final visualStates = selected ? <WidgetState>{...states, WidgetState.pressed} : states;
        final disabled = states.contains(WidgetState.disabled);
        final focused = states.contains(WidgetState.focused);
        final background = variantTokens.background.resolve(visualStates);
        final foreground = variantTokens.foreground.resolve(visualStates);
        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: tokens.animationDuration,
          opacity: disabled ? tokens.disabledOpacity : 1,
          child: AnimatedContainer(
            duration: tokens.animationDuration,
            curve: CharcoalMotion.standardCurve,
            width: sizeTokens.size,
            height: sizeTokens.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tokens.radius),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(color: tokens.focusRingColor, spreadRadius: tokens.focusRingWidth),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(color: foreground, size: sizeTokens.iconSize),
                child: icon,
              ),
            ),
          ),
        );
      },
    );
  }
}
