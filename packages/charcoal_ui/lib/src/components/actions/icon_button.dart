import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../status/count_badge.dart';
import 'control_support.dart';

/// Surface a [CharcoalIconButton] sits on.
enum CharcoalIconButtonVariant {
  /// An ordinary application surface.
  normal,

  /// Imagery or another authored on-image surface.
  overlay,
}

/// Size of a [CharcoalIconButton].
enum CharcoalIconButtonSize {
  /// 24 px target with a 16 px icon, for dense secondary affordances.
  extraSmall,

  /// `sizes.controlSm` target with a 24 px icon.
  small,

  /// `sizes.controlMd` target with a 24 px icon.
  medium,
}

/// A circular button for an icon-only action.
///
/// When [selected] is null this is a regular action; a non-null value makes it a controlled toggle
/// whose selected or unselected state is exposed through semantics, painted in its pressed colours
/// while selected. Pass [semanticLabel] (and update it when a toggle changes) so the action has an
/// accessible name.
///
/// A [badge] draws a small count over the button's top end corner, as on a notification bell;
/// it is decorative, so include the count in [semanticLabel].
final class CharcoalIconButton extends StatelessWidget {
  /// Creates an icon button showing [icon].
  const CharcoalIconButton({
    required this.icon,
    required this.onPressed,
    this.autofocus = false,
    this.badge,
    this.focusNode,
    this.semanticLabel,
    this.selected,
    this.size = CharcoalIconButtonSize.medium,
    this.statesController,
    this.variant = CharcoalIconButtonVariant.normal,
    super.key,
  });

  /// The icon; its size and colour come from the button.
  final Widget icon;

  /// Called on activation; null disables the button.
  final VoidCallback? onPressed;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// A short count drawn over the top end corner; null shows none. Excluded from semantics.
  final String? badge;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Semantics label of the action.
  final String? semanticLabel;

  /// Null for a regular action; true or false for a controlled toggle.
  final bool? selected;

  /// The button size.
  final CharcoalIconButtonSize size;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  /// The surface the button sits on.
  final CharcoalIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.iconButton;
    final (target, iconSize) = switch (size) {
      CharcoalIconButtonSize.extraSmall => (metrics.extraSmallSize, metrics.smallIconSize),
      CharcoalIconButtonSize.small => (theme.sizes.controlSm, metrics.regularIconSize),
      CharcoalIconButtonSize.medium => (theme.sizes.controlMd, metrics.regularIconSize),
    };
    final button = MergeSemantics(
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
            final (background, foreground) = switch (variant) {
              CharcoalIconButtonVariant.normal => (
                resolveCharcoalStateColor(
                  visualStates,
                  normal: colors.restOverlay,
                  hovered: colors.hoverOverlay,
                  pressed: colors.pressOverlay,
                ),
                resolveCharcoalStateColor(
                  visualStates,
                  normal: colors.iconTertiary,
                  hovered: colors.iconTertiaryHover,
                  pressed: colors.iconTertiaryPress,
                ),
              ),
              CharcoalIconButtonVariant.overlay => (
                resolveCharcoalStateColor(
                  visualStates,
                  normal: colors.fillOnImage,
                  hovered: colors.fillOnImageHover,
                  pressed: colors.fillOnImagePress,
                ),
                colors.iconOnImage,
              ),
            };
            return CharcoalDisabledFade(
              disabled: states.contains(WidgetState.disabled),
              child: AnimatedContainer(
                duration: theme.duration(context, theme.motion.standard),
                curve: theme.motion.curve,
                width: target,
                height: target,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(theme.radius.pill),
                  boxShadow: charcoalHaloShadow(
                    theme,
                    visible: states.contains(WidgetState.focused),
                  ),
                  color: background,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(color: foreground, size: iconSize),
                    child: icon,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    final label = badge;
    if (label == null) return button;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        button,
        PositionedDirectional(
          end: metrics.badgeOffsetEnd,
          top: metrics.badgeOffsetTop,
          child: ExcludeSemantics(child: CharcoalCountBadge(label: label)),
        ),
      ],
    );
  }
}
