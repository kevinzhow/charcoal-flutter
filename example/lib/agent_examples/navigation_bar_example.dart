import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A page-level bar with hierarchical back navigation and one trailing action.
final class AgentNavigationBarExample extends StatelessWidget {
  const AgentNavigationBarExample({
    required this.onBack,
    required this.onMore,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) => CharcoalNavigationBar(
    leading: CharcoalIconButton(
      icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
      onPressed: onBack,
      semanticLabel: 'Back to messages',
      size: CharcoalIconButtonSize.small,
    ),
    semanticLabel: 'Conversation navigation',
    title: const Text('Aki Kondo'),
    trailing: CharcoalIconButton(
      icon: const CharcoalIcon(CharcoalIcons.dotsHorizontal),
      onPressed: onMore,
      semanticLabel: 'Conversation actions',
      size: CharcoalIconButtonSize.small,
    ),
  );
}
