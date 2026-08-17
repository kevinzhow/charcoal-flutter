import 'package:flutter/semantics.dart' show SemanticsRole;
import 'package:flutter/widgets.dart';

import '../theme/charcoal_motion.dart';
import '../theme/charcoal_theme.dart';
import 'clickable.dart';
import 'interaction_state.dart';

abstract final class _TabBarSpec {
  static const badgeFontSize = 9.0;
  static const badgeMinExtent = 16.0;
  static const iconSize = 20.0;
  static const labelFontSize = 10.0;
}

/// One stable, top-level destination displayed by [CharcoalTabBar].
///
/// [value] is the destination identity and must be unique within a bar. Supply
/// a [key] when tests or automation need an app-specific destination key.
final class CharcoalTabItem<T> {
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

  /// The destination icon. It inherits a 20 logical-pixel [IconTheme].
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
/// The bar owns destination layout and interaction states. It does not own a
/// route stack: [onChanged] only reports selection intent. The surrounding app
/// shell should update its selected destination without pushing a route, while
/// details and tasks continue to use normal push, replace, and pop semantics.
/// System safe-area padding remains the responsibility of that app shell.
///
/// When [onChanged] is null, every destination is disabled. Individual items
/// can be disabled with [CharcoalTabItem.enabled].
final class CharcoalTabBar<T> extends StatelessWidget {
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

  /// Reports a selected destination without prescribing route-stack behavior.
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
            top: BorderSide(
              color: theme.colors.borderSecondary,
              width: theme.dimensions.borderWidth.m,
            ),
          ),
          color: theme.colors.backgroundDefault,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: theme.dimensions.space.layout60,
          ),
          // The bar has a 64 logical-pixel baseline but may grow with text
          // scaling. IntrinsicHeight gives the Row a finite cross-axis extent
          // so every destination paints across the resulting height.
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (final item in items)
                  Expanded(
                    child: _CharcoalTabDestination<T>(
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

final class _CharcoalTabDestination<T> extends StatelessWidget {
  const _CharcoalTabDestination({
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
    return CharcoalClickable(
      inMutuallyExclusiveGroup: true,
      onPressed: onPressed,
      selected: selected,
      semanticButton: false,
      semanticLabel: item.semanticLabel ?? item.label,
      semanticRole: SemanticsRole.tab,
      builder: (context, states) {
        final disabled = states.contains(WidgetState.disabled);
        final focused = states.contains(WidgetState.focused);
        final hovered = states.contains(WidgetState.hovered);
        final pressed = states.contains(WidgetState.pressed);
        final active = selected || focused;
        final background = selected
            ? theme.colors.containerSecondaryDefaultA
            : pressed
            ? theme.colors.containerSecondaryPressA
            : hovered || focused
            ? theme.colors.containerSecondaryHoverA
            : theme.colors.backgroundDefault;
        final iconColor = active
            ? theme.colors.iconDefault
            : pressed
            ? theme.colors.iconTertiaryPress
            : hovered
            ? theme.colors.iconTertiaryHover
            : theme.colors.iconTertiaryDefault;
        final textColor = active
            ? theme.colors.textDefault
            : pressed
            ? theme.colors.textTertiaryPress
            : hovered
            ? theme.colors.textTertiaryHover
            : theme.colors.textTertiaryDefault;

        return AnimatedOpacity(
          curve: CharcoalMotion.standardCurve,
          duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
          opacity: disabled ? charcoalDisabledOpacity : 1,
          child: AnimatedContainer(
            // Selection belongs to the controlled app-shell state and must
            // commit atomically. A new key discards the previous decoration
            // tween, while hover, focus, and press still animate within the
            // same persistent selection state.
            key: ValueKey<bool>(selected),
            curve: CharcoalMotion.standardCurve,
            duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
            decoration: BoxDecoration(
              boxShadow: focused
                  ? <BoxShadow>[
                      BoxShadow(
                        color: theme.colors.borderFocusLegacy,
                        spreadRadius: theme.dimensions.borderWidth.focus2,
                      ),
                    ]
                  : const <BoxShadow>[],
              color: background,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: theme.dimensions.space.component10,
              vertical: theme.dimensions.space.component20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    IconTheme(
                      data: IconThemeData(color: iconColor, size: _TabBarSpec.iconSize),
                      child: item.icon,
                    ),
                    if (item.badge case final badge?)
                      PositionedDirectional(
                        end: -10,
                        top: -7,
                        child: ExcludeSemantics(
                          child: _CharcoalTabBadge(label: badge),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: theme.dimensions.space.component10),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: textColor,
                    fontSize: _TabBarSpec.labelFontSize,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _CharcoalTabBadge extends StatelessWidget {
  const _CharcoalTabBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colors.backgroundDefault,
          width: theme.dimensions.borderWidth.m,
        ),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerNegativeDefault,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: _TabBarSpec.badgeMinExtent,
          minWidth: _TabBarSpec.badgeMinExtent,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.dimensions.space.component10,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textOnNegativeDefault,
                fontSize: _TabBarSpec.badgeFontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
