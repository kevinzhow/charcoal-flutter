import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../../foundation/interaction_state.dart';
import '../../foundation/layout.dart';
import '../text/text_tone.dart';
import 'control_support.dart';

/// Visual weight of a [CharcoalButton] is chosen with [CharcoalButtonVariant]; this enum picks its
/// size.
enum CharcoalButtonSize {
  /// `sizes.controlSm` high.
  small,

  /// `sizes.controlMd` high.
  medium,
}

/// The Charcoal pill button.
///
/// Five variants ([CharcoalButtonVariant]: normal, primary, danger, overlay, navigation) in two
/// sizes. When [selected] is null this is a regular action; a non-null value makes it a controlled
/// toggle whose selected or unselected state is exposed through semantics, and a selected toggle
/// is painted in its pressed colours.
///
/// Pressing only adds a pressed colour layer: the button's bounds, icon centres and text baseline
/// are identical in every state. A null [onPressed] disables the button, which then fades to the
/// theme's disabled opacity (a disabled navigation button disappears).
///
/// ```dart
/// CharcoalButton(
///   variant: CharcoalButtonVariant.primary,
///   onPressed: save,
///   child: const Text('Save'),
/// )
/// ```
final class CharcoalButton extends StatelessWidget {
  /// Creates a button with [child] as its label.
  const CharcoalButton({
    required this.child,
    required this.onPressed,
    this.autofocus = false,
    this.focusNode,
    this.fullWidth = false,
    this.labelTone,
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

  /// The label, usually a `Text`; it is styled by the button.
  final Widget child;

  /// Called on activation; null disables the button.
  final VoidCallback? onPressed;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// Whether the button fills the width its parent offers.
  final bool fullWidth;

  /// Colours the label and icons in a semantic text tone (a destructive row action, say) instead
  /// of the variant's foreground. Meant for the normal variant; a disabled button still fades.
  final CharcoalTextTone? labelTone;

  /// An icon before the label.
  final Widget? leading;

  /// Replaces the fill of a [CharcoalButtonVariant.primary] button, for brand colours chosen at
  /// run time; hover and pressed layers are blended over it.
  final Color? primaryColor;

  /// Semantics label; when set it replaces the label of [child].
  final String? semanticLabel;

  /// Null for a regular action; true or false for a controlled toggle.
  final bool? selected;

  /// The button size.
  final CharcoalButtonSize size;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  /// An icon after the label.
  final Widget? trailing;

  /// The fill family.
  final CharcoalButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final small = size == CharcoalButtonSize.small;
    final height = small ? theme.sizes.controlSm : theme.sizes.controlMd;
    final horizontalPadding = small ? theme.space.lg : theme.space.xl;
    final verticalPadding = small
        ? theme.metrics.button.smallVerticalPadding
        : theme.metrics.button.mediumVerticalPadding;
    final palette = charcoalButtonColors(theme, variant);
    final duration = theme.duration(context, theme.motion.standard);

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
                ? _resolveCustomPrimaryColor(primaryColor!, visualStates, theme)
                : resolveCharcoalStateColor(
                    visualStates,
                    normal: palette.rest,
                    hovered: palette.hover,
                    pressed: palette.press,
                    disabled: palette.rest,
                  );
            final foreground =
                labelTone?.resolve(theme.colors) ??
                resolveCharcoalStateColor(
                  visualStates,
                  normal: palette.foreground,
                  hovered: palette.foregroundHover,
                  pressed: palette.foregroundPress,
                  disabled: palette.foreground,
                );
            final isDisabled = states.contains(WidgetState.disabled);
            final isFocused = states.contains(WidgetState.focused);
            final iconTheme = IconThemeData(color: foreground, size: theme.metrics.button.iconSize);

            Widget content = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  IconTheme(data: iconTheme, child: leading!),
                  CharcoalGap.horizontal(CharcoalSpace.xs),
                ],
                Flexible(
                  child: DefaultTextStyle(
                    style: theme.style(CharcoalTextRole.bodyBold, color: foreground),
                    child: child,
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  CharcoalGap.horizontal(CharcoalSpace.xs),
                  IconTheme(data: iconTheme, child: trailing!),
                ],
              ],
            );

            content = AnimatedContainer(
              duration: duration,
              curve: theme.motion.curve,
              constraints: BoxConstraints(minHeight: height),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(theme.radius.pill),
                boxShadow: charcoalHaloShadow(theme, visible: isFocused),
                color: background,
              ),
              child: content,
            );

            if (fullWidth) {
              content = SizedBox(width: double.infinity, child: content);
            }
            return CharcoalDisabledFade(
              disabled: isDisabled,
              hidden: variant == CharcoalButtonVariant.navigation,
              child: content,
            );
          },
        ),
      ),
    );
  }
}

Color _resolveCustomPrimaryColor(Color base, Set<WidgetState> states, CharcoalTheme theme) {
  if (states.contains(WidgetState.pressed)) {
    return Color.alphaBlend(theme.colors.pressOverlay, base);
  }
  if (states.contains(WidgetState.hovered)) {
    return Color.alphaBlend(theme.colors.hoverOverlay, base);
  }
  return base;
}
