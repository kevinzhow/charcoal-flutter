import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Pushes a real detail route with Charcoal's platform-adaptive back gesture.
final class AgentPageRouteExample extends StatelessWidget {
  const AgentPageRouteExample({super.key});

  @override
  Widget build(BuildContext context) => CharcoalButton(
    onPressed: () => Navigator.of(context).push<void>(
      CharcoalPageRoute<void>(builder: (_) => const _AccountDetailPage()),
    ),
    variant: CharcoalButtonVariant.primary,
    child: const Text('Open account details'),
  );
}

final class _AccountDetailPage extends StatelessWidget {
  const _AccountDetailPage();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ColoredBox(
      color: theme.colors.backgroundDefault,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CharcoalNavigationBar(
              leading: CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.chevronLeft),
                onPressed: () => Navigator.of(context).pop(),
                semanticLabel: 'Back to account',
                size: CharcoalIconButtonSize.small,
              ),
              title: const Text('Account details'),
            ),
            Padding(
              padding: EdgeInsets.all(theme.dimensions.space.layout40),
              child: const Text(
                'Your profile and security settings are up to date.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
