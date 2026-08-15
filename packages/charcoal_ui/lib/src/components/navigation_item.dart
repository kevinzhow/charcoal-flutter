import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';

/// A full-width destination item for sidebars, drawers, and navigation lists.
///
/// Selection is a persistent state and therefore remains visually stable while
/// the pointer is hovered or pressed. Transient states are only applied to
/// unselected destinations.
final class CharcoalNavigationItem extends StatelessWidget {
  const CharcoalNavigationItem({
    required this.child,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.leading,
    this.selected = false,
    this.semanticLabel,
    this.statesController,
    this.trailing,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? leading;
  final bool selected;
  final String? semanticLabel;
  final WidgetStatesController? statesController;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final dimensions = theme.dimensions;
    final buttonTokens = theme.components.button;
    return CharcoalClickable(
      autofocus: autofocus,
      focusNode: focusNode,
      onPressed: onPressed,
      selected: selected,
      semanticLabel: semanticLabel,
      statesController: statesController,
      builder: (context, states) {
        final disabled = states.contains(WidgetState.disabled);
        final focused = states.contains(WidgetState.focused);
        final hovered = states.contains(WidgetState.hovered);
        final pressed = states.contains(WidgetState.pressed);
        final background = selected
            ? theme.colors.containerSecondaryDefault
            : pressed
            ? theme.colors.containerSecondaryPressA
            : hovered
            ? theme.colors.containerSecondaryHoverA
            : theme.colors.containerDefaultA;
        final foreground = selected
            ? theme.colors.textDefault
            : pressed
            ? theme.colors.textPress
            : hovered
            ? theme.colors.textHover
            : theme.colors.textSecondaryDefault;
        final iconColor = selected
            ? theme.colors.iconDefault
            : pressed
            ? theme.colors.iconPress
            : hovered
            ? theme.colors.iconHover
            : theme.colors.iconSecondaryDefault;
        final textStyle = theme.textStyles.captionMediumBold.copyWith(color: foreground);

        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
          opacity: disabled ? buttonTokens.disabledOpacity : 1,
          child: AnimatedContainer(
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
            constraints: BoxConstraints(minHeight: dimensions.space.targetM),
            padding: EdgeInsets.symmetric(horizontal: dimensions.space.component25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimensions.radius.m),
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: buttonTokens.focusRingColor,
                        spreadRadius: buttonTokens.focusRingWidth,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  SizedBox.square(
                    dimension: dimensions.space.component40,
                    child: Center(
                      child: IconTheme(
                        data: IconThemeData(
                          color: iconColor,
                          size: dimensions.space.component40,
                        ),
                        child: leading!,
                      ),
                    ),
                  ),
                  SizedBox(width: dimensions.space.component20),
                ],
                Expanded(
                  child: DefaultTextStyle(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                    child: child,
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  SizedBox(width: dimensions.space.component20),
                  IconTheme(
                    data: IconThemeData(color: iconColor, size: dimensions.space.component30),
                    child: trailing!,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
