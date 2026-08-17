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
              AgentDemoTabBar(
                appKey: 'social',
                items: <AgentDemoTabItem>[
                  const AgentDemoTabItem('Home', CharcoalIcons.home),
                  const AgentDemoTabItem('Discover', CharcoalIcons.compass),
                  AgentDemoTabItem(
                    'Messages',
                    CharcoalIcons.message,
                    badgeCount: unreadMessages,
                    semanticLabel: unreadMessages > 0
                        ? 'Messages, $unreadMessages unread'
                        : 'Messages',
                  ),
                  const AgentDemoTabItem('Profile', CharcoalIcons.personCircle),
                ],
                onSelected: (index) =>
                    onDestinationSelected(BloomDestination.values[index]),
                selectedIndex: selectedDestination.index,
              ),
          ],
        ),
      ),
    );
  }
}
