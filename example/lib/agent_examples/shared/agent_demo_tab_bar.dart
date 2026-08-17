import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// One top-level destination displayed by [AgentDemoTabBar].
final class AgentDemoTabItem {
  const AgentDemoTabItem(
    this.label,
    this.icon, {
    this.badgeCount = 0,
    this.semanticLabel,
  }) : assert(badgeCount >= 0),
       assert(
         badgeCount == 0 || semanticLabel != null,
         'A badged tab must describe the badge in its semantic label.',
       );

  final int badgeCount;
  final CharcoalIconData icon;
  final String label;
  final String? semanticLabel;
}

/// Shared bottom tab bar for the embedded Agent Ready applications.
///
/// Selecting a tab reports a new top-level destination. Route ownership stays
/// with the surrounding app shell, so a tab change never implies a route push.
final class AgentDemoTabBar extends StatelessWidget {
  const AgentDemoTabBar({
    required this.appKey,
    required this.items,
    required this.onSelected,
    required this.selectedIndex,
    super.key,
  }) : assert(items.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < items.length);

  final String appKey;
  final List<AgentDemoTabItem> items;
  final ValueChanged<int> onSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colors.borderSecondary)),
        color: theme.colors.backgroundDefault,
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: <Widget>[
            for (final (index, item) in items.indexed)
              Expanded(
                child: _AgentDemoTabDestination(
                  key: ValueKey<String>(
                    'agent-$appKey-nav-${item.label.toLowerCase()}',
                  ),
                  item: item,
                  onPressed: () => onSelected(index),
                  selected: selectedIndex == index,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _AgentDemoTabDestination extends StatelessWidget {
  const _AgentDemoTabDestination({
    required this.item,
    required this.onPressed,
    required this.selected,
    super.key,
  });

  final AgentDemoTabItem item;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      inMutuallyExclusiveGroup: true,
      onPressed: onPressed,
      selected: selected,
      semanticLabel: item.semanticLabel ?? item.label,
      builder: (context, states) {
        final active = selected || states.contains(WidgetState.focused);
        final highlighted =
            selected ||
            states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.focused);
        return AnimatedContainer(
          duration: CharcoalMotion.resolveDuration(
            context,
            CharcoalMotion.fast,
          ),
          color: highlighted ? theme.colors.containerSecondaryDefaultA : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  CharcoalIcon(
                    item.icon,
                    color: active
                        ? theme.colors.iconDefault
                        : theme.colors.iconTertiaryDefault,
                    size: 20,
                  ),
                  if (item.badgeCount > 0)
                    PositionedDirectional(
                      end: -10,
                      top: -7,
                      child: ExcludeSemantics(
                        child: _AgentDemoTabBadge(count: item.badgeCount),
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
                  color: active
                      ? theme.colors.textDefault
                      : theme.colors.textTertiaryDefault,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final class _AgentDemoTabBadge extends StatelessWidget {
  const _AgentDemoTabBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.backgroundDefault),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
        color: theme.colors.containerNegativeDefault,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 16, minWidth: 16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Center(
            child: Text(
              '$count',
              style: theme.textStyles.captionSmall.copyWith(
                color: theme.colors.textOnNegativeDefault,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
