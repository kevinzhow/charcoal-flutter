import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';
import 'typography.dart';

abstract final class _NavigationItemSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const focusRingWidth = 4.0;
  static const leadingIconSize = 24.0;
  static const trailingIconSize = 16.0;
}

/// A full-width destination item for sidebars, drawers, and navigation lists.
///
/// Selection is a persistent state and therefore remains visually stable while
/// hover, focus, and press feedback is painted on an independent transient
/// layer. A cancelled pointer gesture never changes [selected].
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
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        child: CharcoalClickable(
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
            final persistentBackground = selected
                ? theme.colors.containerSecondaryDefault
                : theme.colors.containerDefaultA;
            final interactionOverlay = pressed
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
            final textStyle = charcoalTypographyStyle(
              context,
              color: foreground,
              size: CharcoalTypographySize.size14,
              weight: CharcoalTypographyWeight.bold,
            );

            return AnimatedOpacity(
              curve: CharcoalMotion.standardCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                _NavigationItemSpec.animationDuration,
              ),
              opacity: disabled ? charcoalDisabledOpacity : 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.m,
                  ),
                  color: persistentBackground,
                ),
                child: AnimatedContainer(
                  // The transient layer also carries the component's constraints
                  // and padding so its Row remains vertically centered. A loose
                  // Stack here would let the content collapse to intrinsic height.
                  curve: CharcoalMotion.standardCurve,
                  duration: CharcoalMotion.resolveDuration(
                    context,
                    _NavigationItemSpec.animationDuration,
                  ),
                  constraints: BoxConstraints(
                    minHeight: theme.dimensions.space.targetM,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.dimensions.space.component25,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
                    boxShadow: focused
                        ? <BoxShadow>[
                            BoxShadow(
                              color: theme.colors.borderFocusLegacy,
                              spreadRadius: _NavigationItemSpec.focusRingWidth,
                            ),
                          ]
                        : const <BoxShadow>[],
                    color: interactionOverlay,
                  ),
                  child: Row(
                    children: <Widget>[
                      if (leading != null) ...<Widget>[
                        SizedBox.square(
                          dimension: theme.dimensions.space.targetXs,
                          child: Center(
                            child: IconTheme(
                              data: IconThemeData(
                                color: iconColor,
                                size: _NavigationItemSpec.leadingIconSize,
                              ),
                              child: leading!,
                            ),
                          ),
                        ),
                        SizedBox(width: theme.dimensions.space.component20),
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
                        SizedBox(width: theme.dimensions.space.component20),
                        IconTheme(
                          data: IconThemeData(
                            color: iconColor,
                            size: _NavigationItemSpec.trailingIconSize,
                          ),
                          child: trailing!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
