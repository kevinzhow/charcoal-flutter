import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

enum _Destination { home, discover, messages, profile }

/// A controlled top-level destination selector.
///
/// Selection updates the app shell in place. Detail and task actions should
/// still use a real Navigator push, replace, or pop outside this component.
final class AgentTabBarExample extends StatefulWidget {
  const AgentTabBarExample({super.key});

  @override
  State<AgentTabBarExample> createState() => _AgentTabBarExampleState();
}

final class _AgentTabBarExampleState extends State<AgentTabBarExample> {
  _Destination destination = _Destination.home;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        height: CharcoalTheme.of(context).dimensions.space.layout60,
        child: Center(
          child: Text(
            'Current destination: ${destination.name}',
            style: CharcoalTheme.of(context).textStyles.captionMedium,
          ),
        ),
      ),
      CharcoalTabBar<_Destination>(
        items: const <CharcoalTabItem<_Destination>>[
          CharcoalTabItem<_Destination>(
            icon: CharcoalIcon(CharcoalIcons.home),
            label: 'Home',
            value: _Destination.home,
          ),
          CharcoalTabItem<_Destination>(
            icon: CharcoalIcon(CharcoalIcons.compass),
            label: 'Discover',
            value: _Destination.discover,
          ),
          CharcoalTabItem<_Destination>(
            badge: '3',
            icon: CharcoalIcon(CharcoalIcons.message),
            label: 'Messages',
            semanticLabel: 'Messages, 3 unread',
            value: _Destination.messages,
          ),
          CharcoalTabItem<_Destination>(
            icon: CharcoalIcon(CharcoalIcons.personCircle),
            label: 'Profile',
            value: _Destination.profile,
          ),
        ],
        onChanged: (value) => setState(() => destination = value),
        semanticLabel: 'Primary destinations',
        value: destination,
      ),
    ],
  );
}
