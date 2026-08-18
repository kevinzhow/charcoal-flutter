import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';

enum CharcoalIconButtonVariant { normal, overlay }

enum CharcoalIconButtonSize { extraSmall, small, medium }

abstract final class _IconButtonSpec {
  static const animationDuration = Duration(milliseconds: 200);
  static const extraSmallSize = 20.0;
  static const smallIconSize = 16.0;
  static const regularIconSize = 24.0;
  static const focusRingWidth = 4.0;
}

/// A circular Charcoal V2 button for an icon-only action.
///
/// When [selected] is null this is a regular action. A non-null value makes it
/// a controlled toggle whose selected or unselected state is exposed through
/// semantics.
final class CharcoalIconButton extends StatelessWidget {
  const CharcoalIconButton({
    required this.icon,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.selected,
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
  final bool? selected;
  final CharcoalIconButtonSize size;
  final WidgetStatesController? statesController;
  final CharcoalIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final sizeSpec = switch (size) {
      CharcoalIconButtonSize.extraSmall => (
        button: _IconButtonSpec.extraSmallSize,
        icon: _IconButtonSpec.smallIconSize,
      ),
      CharcoalIconButtonSize.small => (
        button: theme.dimensions.space.targetS,
        icon: _IconButtonSpec.regularIconSize,
      ),
      CharcoalIconButtonSize.medium => (
        button: theme.dimensions.space.targetM,
        icon: _IconButtonSpec.regularIconSize,
      ),
    };
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
            final disabled = states.contains(WidgetState.disabled);
            final focused = states.contains(WidgetState.focused);
            final background = switch (variant) {
              CharcoalIconButtonVariant.normal => resolveCharcoalStateColor(
                visualStates,
                normal: theme.colors.containerDefaultA,
                hovered: theme.colors.containerHoverA,
                pressed: theme.colors.containerPressA,
              ),
              CharcoalIconButtonVariant.overlay => resolveCharcoalStateColor(
                visualStates,
                normal: theme.colors.containerOnImgDefault,
                hovered: theme.colors.containerOnImgHover,
                pressed: theme.colors.containerOnImgPress,
              ),
            };
            final foreground = switch (variant) {
              CharcoalIconButtonVariant.normal => resolveCharcoalStateColor(
                visualStates,
                normal: theme.colors.iconTertiaryDefault,
                hovered: theme.colors.iconTertiaryHover,
                pressed: theme.colors.iconTertiaryPress,
              ),
              CharcoalIconButtonVariant.overlay => resolveCharcoalStateColor(
                visualStates,
                normal: theme.colors.iconOnOnImgDefault,
                hovered: theme.colors.iconOnOnImgHover,
                pressed: theme.colors.iconOnOnImgPress,
              ),
            };
            return AnimatedOpacity(
              curve: CharcoalMotion.standardCurve,
              duration: CharcoalMotion.resolveDuration(
                context,
                _IconButtonSpec.animationDuration,
              ),
              opacity: disabled ? charcoalDisabledOpacity : 1,
              child: AnimatedContainer(
                duration: CharcoalMotion.resolveDuration(
                  context,
                  _IconButtonSpec.animationDuration,
                ),
                curve: CharcoalMotion.standardCurve,
                width: sizeSpec.button,
                height: sizeSpec.button,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    theme.dimensions.radius.oval,
                  ),
                  boxShadow: focused
                      ? <BoxShadow>[
                          BoxShadow(
                            color: theme.colors.borderFocusLegacy,
                            spreadRadius: _IconButtonSpec.focusRingWidth,
                          ),
                        ]
                      : const <BoxShadow>[],
                  color: background,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(color: foreground, size: sizeSpec.icon),
                    child: icon,
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
