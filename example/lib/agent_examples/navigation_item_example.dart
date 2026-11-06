import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/semantics.dart' show SemanticsRole;
import 'package:flutter/widgets.dart';

enum _NavigationDestination { home, discover, messages }

/// One destination owner shared by wide sidebar and compact tab-bar layouts.
///
/// Top-level selection updates content in place. Details and transient tasks
/// still belong on the Navigator stack outside this example.
final class AgentNavigationItemExample extends StatefulWidget {
  const AgentNavigationItemExample({super.key});

  @override
  State<AgentNavigationItemExample> createState() =>
      _AgentNavigationItemExampleState();
}

final class _AgentNavigationItemExampleState
    extends State<AgentNavigationItemExample> {
  _NavigationDestination _destination = _NavigationDestination.home;

  void _select(_NavigationDestination destination) {
    setState(() => _destination = destination);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = CharcoalCard(
          padding: const CharcoalInset.symmetric(
            horizontal: CharcoalSpace.lg,
            vertical: CharcoalSpace.xxxl,
          ),
          child: Center(
            child: CharcoalText(
              'Current destination: ${_destination.name}',
              role: CharcoalTextRole.bodyLargeBold,
            ),
          ),
        );
        if (constraints.maxWidth < 600) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              content,
              CharcoalTabBar<_NavigationDestination>(
                items: const <CharcoalTabItem<_NavigationDestination>>[
                  CharcoalTabItem<_NavigationDestination>(
                    icon: CharcoalIcon(CharcoalIcons.home),
                    label: 'Home',
                    value: _NavigationDestination.home,
                  ),
                  CharcoalTabItem<_NavigationDestination>(
                    icon: CharcoalIcon(CharcoalIcons.compass),
                    label: 'Discover',
                    value: _NavigationDestination.discover,
                  ),
                  CharcoalTabItem<_NavigationDestination>(
                    badge: '3',
                    icon: CharcoalIcon(CharcoalIcons.message),
                    label: 'Messages',
                    semanticLabel: 'Messages, 3 unread',
                    value: _NavigationDestination.messages,
                  ),
                ],
                onChanged: _select,
                semanticLabel: 'Primary destinations',
                value: _destination,
              ),
            ],
          );
        }

        // The destination list takes a third of the width; the content takes the rest.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  label: 'Primary destinations',
                  role: SemanticsRole.navigation,
                  child: CharcoalPadding.all(
                    CharcoalSpace.sm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CharcoalNavigationItem(
                          leading: const CharcoalIcon(CharcoalIcons.home),
                          onPressed: () => _select(_NavigationDestination.home),
                          selected: _destination == _NavigationDestination.home,
                          child: const Text('Home'),
                        ),
                        const CharcoalGap(CharcoalSpace.sm),
                        CharcoalNavigationItem(
                          leading: const CharcoalIcon(CharcoalIcons.compass),
                          onPressed: () =>
                              _select(_NavigationDestination.discover),
                          selected:
                              _destination == _NavigationDestination.discover,
                          child: const Text('Discover'),
                        ),
                        const CharcoalGap(CharcoalSpace.sm),
                        CharcoalNavigationItem(
                          leading: const CharcoalIcon(CharcoalIcons.message),
                          onPressed: () =>
                              _select(_NavigationDestination.messages),
                          selected:
                              _destination == _NavigationDestination.messages,
                          semanticLabel: 'Messages, 3 unread',
                          trailing: const Text('3'),
                          child: const Text('Messages'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const CharcoalGap(CharcoalSpace.xl),
              Expanded(flex: 2, child: content),
            ],
          ),
        );
      },
    );
  }
}
