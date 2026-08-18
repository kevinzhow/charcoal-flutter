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
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return SizedBox(
      height: 320,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final content = ColoredBox(
            color: theme.colors.containerSecondaryDefaultA,
            child: Center(
              child: Text(
                'Current destination: ${_destination.name}',
                style: theme.textStyles.bodyBold,
              ),
            ),
          );
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(child: content),
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

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: 240,
                child: Semantics(
                  container: true,
                  explicitChildNodes: true,
                  label: 'Primary destinations',
                  role: SemanticsRole.navigation,
                  child: Padding(
                    padding: EdgeInsets.all(space.component20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CharcoalNavigationItem(
                          leading: const CharcoalIcon(CharcoalIcons.home),
                          onPressed: () => _select(_NavigationDestination.home),
                          selected: _destination == _NavigationDestination.home,
                          child: const Text('Home'),
                        ),
                        SizedBox(height: space.component20),
                        CharcoalNavigationItem(
                          leading: const CharcoalIcon(CharcoalIcons.compass),
                          onPressed: () =>
                              _select(_NavigationDestination.discover),
                          selected:
                              _destination == _NavigationDestination.discover,
                          child: const Text('Discover'),
                        ),
                        SizedBox(height: space.component20),
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
              SizedBox(width: space.layout40),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }
}
