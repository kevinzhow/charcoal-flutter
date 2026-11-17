import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// A break-glass super-user mode: its sign-in card is headed by a title-only mode bar; once in,
/// the whole page sits on the notice surface under a full-width mode bar whose action leaves the
/// mode.
final class AgentModeBarExample extends StatefulWidget {
  const AgentModeBarExample({super.key});

  @override
  State<AgentModeBarExample> createState() => _AgentModeBarExampleState();
}

final class _AgentModeBarExampleState extends State<AgentModeBarExample> {
  bool _superUser = false;

  @override
  Widget build(BuildContext context) {
    return CharcoalScaffold(
      background: _superUser
          ? CharcoalPageBackground.notice
          : CharcoalPageBackground.secondary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_superUser)
              CharcoalModeBar(
                title: 'Super-user mode',
                message: 'Every action here is recorded as the super user.',
                actions: <Widget>[
                  CharcoalButton(
                    size: CharcoalButtonSize.small,
                    leading: const CharcoalIcon(CharcoalIcons.logout),
                    onPressed: () => setState(() => _superUser = false),
                    child: const Text('Exit super user'),
                  ),
                ],
              ),
            CharcoalPadding.all(
              CharcoalSpace.lg,
              child: _superUser ? _grantCard() : _signInCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInCard() => CharcoalSectionCard(
    flush: true,
    children: <Widget>[
      const CharcoalModeBar(title: 'Super user (break-glass)'),
      CharcoalPadding.all(
        CharcoalSpace.xl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const CharcoalText(
              'Sign in with the shared credentials of this deployment. '
              'This mode only grants or revokes the admin role.',
              tone: CharcoalTextTone.secondary,
            ),
            const CharcoalGap(CharcoalSpace.lg),
            CharcoalButton(
              variant: CharcoalButtonVariant.primary,
              onPressed: () => setState(() => _superUser = true),
              child: const Text('Enter super-user mode'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _grantCard() => const CharcoalSectionCard(
    title: 'Grant the admin role',
    caption: 'Find a user by e-mail, user ID or phone number',
    children: <Widget>[
      CharcoalText('No user selected yet.', tone: CharcoalTextTone.secondary),
    ],
  );
}
