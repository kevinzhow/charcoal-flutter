import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../actions/control_support.dart';

/// The visual family of a [CharcoalNavigationItem].
enum CharcoalNavigationItemVariant {
  /// The filled destination row for drawers and navigation lists.
  standard,

  /// The tighter sidebar row of an admin shell: smaller corners, and the current destination is
  /// shown in the information tone.
  sidebar,
}

/// A full-width destination item for sidebars, drawers, and navigation lists.
///
/// Selection is a persistent state and is painted directly from [selected] on the very frame the
/// controlled value changes. Hover, focus and press feedback is painted on an independent transient
/// layer, so a held row never reads as a second selected row, and none of the states moves the
/// item's bounds, icon centres or text baseline. A cancelled pointer gesture never changes
/// [selected].
///
/// ```dart
/// CharcoalNavigationItem(
///   selected: section == Section.home,
///   leading: const CharcoalIcon(CharcoalIcons.home),
///   onPressed: () => setState(() => section = Section.home),
///   child: const Text('Home'),
/// )
/// ```
final class CharcoalNavigationItem extends StatelessWidget {
  /// Creates a destination item with [child] as its label.
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
    this.variant = CharcoalNavigationItemVariant.standard,
    super.key,
  });

  /// The label, usually a `Text`; it is styled by the item and ellipsised on one line.
  final Widget child;

  /// Called on activation; null disables the item.
  final VoidCallback? onPressed;

  /// Whether to take focus when first built.
  final bool autofocus;

  /// Focus node to use instead of an internal one.
  final FocusNode? focusNode;

  /// An icon before the label.
  final Widget? leading;

  /// Whether this is the current destination.
  final bool selected;

  /// Semantics label; when set it replaces the label of [child].
  final String? semanticLabel;

  /// Controller to observe or drive the interaction states from outside.
  final WidgetStatesController? statesController;

  /// A widget after the label, such as a chevron or a lock.
  final Widget? trailing;

  /// The visual family.
  final CharcoalNavigationItemVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.navigationItem;
    final sidebar = variant == CharcoalNavigationItemVariant.sidebar;
    final radius = BorderRadius.circular(sidebar ? theme.radius.sm : theme.radius.md);
    final selectedFill = sidebar ? theme.tone(CharcoalTone.info).surface : colors.surfaceSecondary;
    final leadingExtent = sidebar ? theme.sizes.iconLg : theme.sizes.controlXs;
    final leadingIconSize = sidebar ? theme.sizes.iconLg : metrics.leadingIconSize;
    final duration = theme.duration(context, theme.motion.standard);

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
            // Persistent layer: follows the controlled value only, never tweened.
            final persistentBackground = selected ? selectedFill : colors.restOverlay;
            // Transient layer: hover and press, animated on their own.
            final interactionOverlay = pressed
                ? (sidebar ? colors.pressOverlay : colors.fillSecondaryPress)
                : hovered
                ? (sidebar ? colors.hoverOverlay : colors.fillSecondaryHover)
                : colors.restOverlay;
            final foreground = selected
                ? colors.text
                : pressed
                ? colors.textPress
                : hovered
                ? colors.textHover
                : colors.textSecondary;
            final iconColor = selected
                ? colors.icon
                : pressed
                ? colors.iconPress
                : hovered
                ? colors.iconHover
                : colors.iconSecondary;

            return CharcoalDisabledFade(
              disabled: disabled,
              child: DecoratedBox(
                decoration: BoxDecoration(borderRadius: radius, color: persistentBackground),
                child: AnimatedContainer(
                  // The transient layer also carries the constraints and padding so the Row stays
                  // vertically centred; a loose Stack would let the content collapse.
                  curve: theme.motion.curve,
                  duration: duration,
                  constraints: BoxConstraints(minHeight: theme.sizes.controlMd),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.space.md,
                    vertical: sidebar ? theme.space.sm : 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    boxShadow: charcoalHaloShadow(theme, visible: focused),
                    color: interactionOverlay,
                  ),
                  child: Row(
                    children: <Widget>[
                      if (leading != null) ...<Widget>[
                        SizedBox.square(
                          dimension: leadingExtent,
                          child: Center(
                            child: IconTheme(
                              data: IconThemeData(color: iconColor, size: leadingIconSize),
                              child: leading!,
                            ),
                          ),
                        ),
                        SizedBox(width: theme.space.sm),
                      ],
                      Expanded(
                        child: DefaultTextStyle(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.style(CharcoalTextRole.bodyBold, color: foreground),
                          child: child,
                        ),
                      ),
                      if (trailing != null) ...<Widget>[
                        SizedBox(width: theme.space.sm),
                        IconTheme(
                          data: IconThemeData(color: iconColor, size: metrics.trailingIconSize),
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
