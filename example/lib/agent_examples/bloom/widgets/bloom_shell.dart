part of '../bloom.dart';

final class _BloomShell extends StatelessWidget {
  const _BloomShell({
    required this.content,
    required this.contentKey,
    required this.navigationBar,
    required this.onDestinationSelected,
    required this.selectedDestination,
    required this.showBottomNavigation,
    required this.unreadMessages,
    this.scrollContent = true,
  });

  final Widget content;
  final String contentKey;
  final Widget navigationBar;
  final ValueChanged<BloomDestination> onDestinationSelected;
  final BloomDestination selectedDestination;
  final bool showBottomNavigation;
  final int unreadMessages;
  final bool scrollContent;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Bloom social app demo',
      child: ColoredBox(
        color: theme.colors.backgroundSecondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            navigationBar,
            Expanded(
              child: scrollContent
                  ? SingleChildScrollView(
                      key: PageStorageKey<String>('bloom-scroll-$contentKey'),
                      child: content,
                    )
                  : content,
            ),
            if (showBottomNavigation)
              _BloomBottomBar(
                onSelected: onDestinationSelected,
                selectedDestination: selectedDestination,
                unreadMessages: unreadMessages,
              ),
          ],
        ),
      ),
    );
  }
}

final class _BloomBottomBar extends StatelessWidget {
  const _BloomBottomBar({
    required this.onSelected,
    required this.selectedDestination,
    required this.unreadMessages,
  });

  final ValueChanged<BloomDestination> onSelected;
  final BloomDestination selectedDestination;
  final int unreadMessages;

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
            for (final destination in BloomDestination.values)
              Expanded(
                child: _BloomBottomItem(
                  badgeCount: destination == BloomDestination.messages
                      ? unreadMessages
                      : 0,
                  destination: destination,
                  onPressed: () => onSelected(destination),
                  selected: destination == selectedDestination,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _BloomBottomItem extends StatelessWidget {
  const _BloomBottomItem({
    required this.badgeCount,
    required this.destination,
    required this.onPressed,
    required this.selected,
  });

  final int badgeCount;
  final BloomDestination destination;
  final VoidCallback onPressed;
  final bool selected;

  String get _label => switch (destination) {
    BloomDestination.home => 'Home',
    BloomDestination.discover => 'Discover',
    BloomDestination.messages => 'Messages',
    BloomDestination.profile => 'Profile',
  };

  CharcoalIconData get _icon => switch (destination) {
    BloomDestination.home => CharcoalIcons.home,
    BloomDestination.discover => CharcoalIcons.compass,
    BloomDestination.messages => CharcoalIcons.message,
    BloomDestination.profile => CharcoalIcons.personCircle,
  };

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return CharcoalClickable(
      key: ValueKey<String>('agent-social-nav-${_label.toLowerCase()}'),
      onPressed: onPressed,
      selected: selected,
      semanticLabel: badgeCount > 0 ? '$_label, $badgeCount unread' : _label,
      builder: (context, states) => AnimatedContainer(
        duration: CharcoalMotion.resolveDuration(context, CharcoalMotion.fast),
        color: selected ? theme.colors.containerSecondaryDefaultA : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                CharcoalIcon(
                  _icon,
                  color: selected
                      ? theme.colors.iconDefault
                      : theme.colors.iconTertiaryDefault,
                  size: 20,
                ),
                if (badgeCount > 0)
                  PositionedDirectional(
                    end: -10,
                    top: -7,
                    child: ExcludeSemantics(
                      child: _BloomCompactBadge(count: badgeCount),
                    ),
                  ),
              ],
            ),
            SizedBox(height: theme.dimensions.space.component10),
            Text(
              _label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyles.captionSmall.copyWith(
                color: selected
                    ? theme.colors.textDefault
                    : theme.colors.textTertiaryDefault,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
