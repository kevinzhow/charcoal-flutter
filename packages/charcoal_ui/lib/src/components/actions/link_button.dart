import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import 'control_support.dart';

/// Charcoal's text-only link button.
///
/// It keeps the `sizes.controlMd` touch target while leaving the background clear. Hover and
/// pressed change the text colour only; a null [onPressed] disables it.
final class CharcoalLinkButton extends StatelessWidget {
  /// Creates a link button with [child] as its label.
  const CharcoalLinkButton({
    required this.child,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.statesController,
    super.key,
  });

  /// The label, usually a `Text`; it is styled by the button.
  final Widget child;

  /// Called on activation; null disables the button.
  final VoidCallback? onPressed;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Semantics label; when set it replaces the label of [child].
  final String? semanticLabel;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return MergeSemantics(
      child: CharcoalClickable(
        autofocus: autofocus,
        focusNode: focusNode,
        onPressed: onPressed,
        semanticLabel: semanticLabel,
        statesController: statesController,
        builder: (context, states) {
          final color = resolveCharcoalStateColor(
            states,
            normal: theme.colors.text,
            hovered: theme.colors.textHover,
            pressed: theme.colors.textTertiary,
            disabled: theme.colors.text,
          );
          return CharcoalDisabledFade(
            disabled: states.contains(WidgetState.disabled),
            child: AnimatedContainer(
              duration: theme.duration(context, theme.motion.standard),
              curve: theme.motion.curve,
              constraints: BoxConstraints(minHeight: theme.sizes.controlMd),
              padding: EdgeInsets.symmetric(
                horizontal: theme.space.lg,
                vertical: theme.metrics.button.mediumVerticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.radius.sm),
                boxShadow: charcoalHaloShadow(theme, visible: states.contains(WidgetState.focused)),
              ),
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: DefaultTextStyle(
                  style: theme.style(CharcoalTextRole.bodyBold, color: color),
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
