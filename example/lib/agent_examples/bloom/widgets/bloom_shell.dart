part of '../bloom.dart';

final class _BloomShell extends StatelessWidget {
  const _BloomShell({
    required this.content,
    required this.contentKey,
    required this.navigationBar,
    required this.onDestinationSelected,
    required this.selectedDestination,
    required this.showTabBar,
    required this.unreadMessages,
    this.scrollContent = true,
  });

  final Widget content;
  final String contentKey;
  final Widget navigationBar;
  final ValueChanged<BloomDestination> onDestinationSelected;
  final BloomDestination selectedDestination;
  final bool showTabBar;
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
                  ? AgentExamplePageScrollView(
                      storageKey: 'bloom-scroll-$contentKey',
                      child: content,
                    )
                  : content,
            ),
            if (showTabBar)
              CharcoalTabBar<BloomDestination>(
                items: <CharcoalTabItem<BloomDestination>>[
                  const CharcoalTabItem<BloomDestination>(
                    icon: CharcoalIcon(CharcoalIcons.home),
                    key: ValueKey<String>('agent-social-nav-home'),
                    label: 'Home',
                    value: BloomDestination.home,
                  ),
                  const CharcoalTabItem<BloomDestination>(
                    icon: CharcoalIcon(CharcoalIcons.compass),
                    key: ValueKey<String>('agent-social-nav-discover'),
                    label: 'Discover',
                    value: BloomDestination.discover,
                  ),
                  CharcoalTabItem<BloomDestination>(
                    badge: unreadMessages > 0 ? '$unreadMessages' : null,
                    icon: const CharcoalIcon(CharcoalIcons.message),
                    key: const ValueKey<String>('agent-social-nav-messages'),
                    label: 'Messages',
                    semanticLabel: unreadMessages > 0
                        ? 'Messages, $unreadMessages unread'
                        : 'Messages',
                    value: BloomDestination.messages,
                  ),
                  const CharcoalTabItem<BloomDestination>(
                    icon: CharcoalIcon(CharcoalIcons.personCircle),
                    key: ValueKey<String>('agent-social-nav-profile'),
                    label: 'Profile',
                    value: BloomDestination.profile,
                  ),
                ],
                onChanged: onDestinationSelected,
                semanticLabel: 'Bloom primary destinations',
                value: selectedDestination,
              ),
          ],
        ),
      ),
    );
  }
}
