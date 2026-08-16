import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

enum _Visibility { everyone, followers, private }

/// A parent-owned single selection with descriptive options.
final class AgentDropdownExample extends StatefulWidget {
  const AgentDropdownExample({super.key});

  @override
  State<AgentDropdownExample> createState() => _AgentDropdownExampleState();
}

final class _AgentDropdownExampleState extends State<AgentDropdownExample> {
  _Visibility? _value = _Visibility.everyone;

  static const _options = <CharcoalDropdownOption<_Visibility>>[
    CharcoalDropdownOption(
      value: _Visibility.everyone,
      label: 'Everyone',
      secondary: 'Visible to anyone',
    ),
    CharcoalDropdownOption(
      value: _Visibility.followers,
      label: 'Followers',
      secondary: 'Visible to your followers',
    ),
    CharcoalDropdownOption(
      value: _Visibility.private,
      label: 'Only me',
      secondary: 'Keep this private',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CharcoalDropdown<_Visibility>(
      label: 'Visibility',
      onChanged: (value) => setState(() => _value = value),
      options: _options,
      showLabel: true,
      value: _value,
    );
  }
}
