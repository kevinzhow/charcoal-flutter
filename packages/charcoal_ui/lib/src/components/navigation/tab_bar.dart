import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/semantics.dart' show SemanticsRole;
import 'package:flutter/widgets.dart';

import '../../foundation/charcoal_clickable.dart';
import '../actions/control_support.dart';
import '../status/count_badge.dart';

/// One stable, top-level destination displayed by [CharcoalTabBar].
///
/// [value] is the destination identity and must be unique within a bar. Supply a [key] when tests
/// or automation need an app-specific destination key.
final class CharcoalTabItem<T> {
  /// Creates a destination.
  const CharcoalTabItem({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
    this.enabled = true,
    this.key,
    this.semanticLabel,
  }) : assert(
         badge == null || semanticLabel != null,
         'A badged tab must describe the badge in its semantic label.',
       ),
       assert(badge == null || badge != '', 'A tab badge cannot be empty.');

  /// A short badge value such as an unread count.
  final String? badge;

  /// Whether this destination can be selected.
  final bool enabled;

  /// The destination icon. It inherits an `IconTheme` of `metrics.tabBar.iconSize`.
  final Widget icon;

  /// An optional stable key for this destination's interactive target.
  final Key? key;

  /// A concise, visible destination label.
  final String label;

  /// The full accessible label. Required when [badge] is present.
  final String? semanticLabel;

  /// The stable destination identity owned by the surrounding app shell.
  final T value;
}

/// A controlled bottom bar for switching between top-level destinations.
///
/// The bar owns destination layout and interaction states. It does not own a route stack:
/// [onChanged] only reports selection intent. The surrounding app shell should update its selected
/// destination without pushing a route, while details and tasks continue to use normal push,
/// replace and pop semantics. System safe-area padding remains the responsibility of that shell.
///
/// A pointer down only produces transient pressed feedback. Selection is reported after the tap
/// gesture is accepted, while a cancelled gesture keeps [value] and its controlled content
/// unchanged. The selected destination is painted from [value] on the first frame after it
/// changes: the previous destination is never still highlighted, and nothing shifts.
///
/// When [onChanged] is null, every destination is disabled. Individual items can be disabled with
/// [CharcoalTabItem.enabled].
final class CharcoalTabBar<T> extends StatelessWidget {
  /// Creates a bar of two to five destinations.
  const CharcoalTabBar({
    required this.items,
    required this.onChanged,
    required this.value,
    this.semanticLabel,
    super.key,
  }) : assert(
         items.length > 1 && items.length <= 5,
         'A tab bar requires two to five destinations.',
       );

  /// The destinations in visual and traversal order.
  final List<CharcoalTabItem<T>> items;

  /// Reports a selected destination without prescribing route-stack behaviour.
  final ValueChanged<T>? onChanged;

  /// An optional accessible label for the destination group.
  final String? semanticLabel;

  /// The currently selected destination identity.
  final T value;

  @override
  Widget build(BuildContext context) {
    assert(
      items.map((item) => item.value).toSet().length == items.length,
      'Every CharcoalTabItem value must be unique.',
    );
    assert(
      items.any((item) => item.value == value),
      'CharcoalTabBar.value must match one item.',
    );

    final theme = CharcoalTheme.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      role: SemanticsRole.tabBar,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colors.borderSubtle, width: theme.borders.hairline),
          ),
          color: theme.colors.background,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: theme.space.xxxl),
          // The bar has a baseline height but may grow with text scaling. IntrinsicHeight gives the
          // Row a finite cross-axis extent so every destination paints across the resulting height.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (final item in items)
                  Expanded(
                    child: _Destination<T>(
                      key: item.key ?? ValueKey<T>(item.value),
                      item: item,
                      onPressed: onChanged == null || !item.enabled
                          ? null
                          : () => onChanged!(item.value),
                      selected: item.value == value,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _sized(
  CharcoalTheme theme,
  CharcoalTextRole role,
  double size, {
  Color? color,
  bool bold = false,
}) {
  final base = theme.style(role, color: color, bold: bold);
  return base.apply(fontSizeFactor: size / base.fontSize!);
}

final class _Destination<T> extends StatelessWidget {
  const _Destination({
    required this.item,
    required this.onPressed,
    required this.selected,
    super.key,
  });

  final CharcoalTabItem<T> item;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final metrics = theme.metrics.tabBar;
    final duration = theme.duration(context, theme.motion.fast);
    return CharcoalClickable(
      inMutuallyExclusiveGroup: true,
      onPressed: onPressed,
      selected: selected,
      semanticButton: false,
      semanticLabel: item.semanticLabel ?? item.label,
      semanticRole: SemanticsRole.tab,
      builder: (context, states) {
        final focused = states.contains(WidgetState.focused);
        final hovered = states.contains(WidgetState.hovered);
        final pressed = states.contains(WidgetState.pressed);
        final active = selected || focused;
        final persistentBackground = selected ? colors.fillSecondary : colors.background;
        final interactionOverlay = pressed
            ? colors.fillSecondaryPress
            : hovered || focused
            ? colors.fillSecondaryHover
            : colors.restOverlay;
        final iconColor = active
            ? colors.icon
            : pressed
            ? colors.iconTertiaryPress
            : hovered
            ? colors.iconTertiaryHover
            : colors.iconTertiary;
        final textColor = active
            ? colors.text
            : pressed
            ? colors.textTertiaryPress
            : hovered
            ? colors.textTertiaryHover
            : colors.textTertiary;

        return CharcoalDisabledFade(
          disabled: states.contains(WidgetState.disabled),
          child: ColoredBox(
            // Persistent selection is painted directly from the controlled value. It never shares
            // an implicit colour tween with a pointer state, so selection and content commit in
            // one frame.
            color: persistentBackground,
            child: AnimatedContainer(
              // Press, hover and focus use an independent paint layer in the normal box chain, so
              // the tight width and stretched height of the destination Row are preserved.
              curve: theme.motion.curve,
              duration: duration,
              decoration: BoxDecoration(
                boxShadow: charcoalHaloShadow(
                  theme,
                  visible: focused,
                  spread: theme.borders.focusRing,
                ),
                color: interactionOverlay,
              ),
              padding: EdgeInsets.symmetric(horizontal: theme.space.xs, vertical: theme.space.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      IconTheme(
                        data: IconThemeData(color: iconColor, size: metrics.iconSize),
                        child: item.icon,
                      ),
                      if (item.badge case final badge?)
                        PositionedDirectional(
                          end: metrics.badgeOffsetEnd,
                          top: metrics.badgeOffsetTop,
                          child: ExcludeSemantics(child: CharcoalCountBadge(label: badge)),
                        ),
                    ],
                  ),
                  SizedBox(height: theme.space.xs),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _sized(
                      theme,
                      CharcoalTextRole.size10,
                      metrics.labelFontSize,
                      color: textColor,
                      bold: active,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
