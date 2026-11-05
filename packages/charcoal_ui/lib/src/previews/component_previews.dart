import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Composed UI', size: Size(520, 360))
Widget charcoalComposedUiPreview() => const _ComposedUiPreview();

final class _ComposedUiPreview extends StatefulWidget {
  const _ComposedUiPreview();

  @override
  State<_ComposedUiPreview> createState() => _ComposedUiPreviewState();
}

@CharcoalComponentPreview(name: 'Tab bar', size: Size(420, 180))
Widget charcoalTabBarPreview() => const _TabBarPreview();

final class _TabBarPreview extends StatefulWidget {
  const _TabBarPreview();

  @override
  State<_TabBarPreview> createState() => _TabBarPreviewState();
}

final class _TabBarPreviewState extends State<_TabBarPreview> {
  String destination = 'home';

  @override
  Widget build(BuildContext context) => CharcoalTabBar<String>(
    items: const <CharcoalTabItem<String>>[
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.home),
        label: 'Home',
        value: 'home',
      ),
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.compass),
        label: 'Discover',
        value: 'discover',
      ),
      CharcoalTabItem<String>(
        badge: '3',
        icon: CharcoalIcon(CharcoalIcons.message),
        label: 'Messages',
        semanticLabel: 'Messages, 3 unread',
        value: 'messages',
      ),
      CharcoalTabItem<String>(
        icon: CharcoalIcon(CharcoalIcons.personCircle),
        label: 'Profile',
        value: 'profile',
      ),
    ],
    onChanged: (value) => setState(() => destination = value),
    semanticLabel: 'Primary destinations',
    value: destination,
  );
}

final class _ComposedUiPreviewState extends State<_ComposedUiPreview> {
  String layout = 'grid';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalSegmentedControl<String>(
          fullWidth: true,
          value: layout,
          onChanged: (value) => setState(() => layout = value),
          segments: const <CharcoalSegment<String>>[
            CharcoalSegment<String>(value: 'grid', child: Text('Grid')),
            CharcoalSegment<String>(value: 'list', child: Text('List')),
          ],
        ),
        const SizedBox(height: 24),
        const CharcoalHintText(child: Text('Changes are saved automatically.')),
        const SizedBox(height: 24),
        CharcoalButton(
          variant: CharcoalButtonVariant.primary,
          onPressed: () => showCharcoalDialog<void>(
            context: context,
            builder: (dialogContext) => CharcoalDialog(
              title: 'Charcoal dialog',
              actions: <Widget>[
                CharcoalButton(
                  fullWidth: true,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Close'),
                ),
              ],
              child: const Text('This surface is built without Material or Cupertino.'),
            ),
          ),
          child: const Text('Open dialog'),
        ),
      ],
    );
  }
}
