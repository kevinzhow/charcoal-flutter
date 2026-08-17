import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../lumen_view_model.dart';
import '../widgets/lumen_wallet_components.dart';

final class LumenActivityPage extends StatelessWidget {
  const LumenActivityPage({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-activity-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'AUGUST',
            title: 'Every movement, in one place',
            description: 'Transfers and top-ups remain here after transient task feedback ends.',
          ),
          SizedBox(height: space.component30),
          for (final item in viewModel.activity)
            Padding(
              padding: EdgeInsets.only(bottom: space.component20),
              child: LumenActivityRow(activity: item),
            ),
        ],
      ),
    );
  }
}

final class LumenPlanPage extends StatelessWidget {
  const LumenPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-plan-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'AUGUST PLAN',
            title: 'Spend with a little more intention',
            description: 'Category context supports decisions without competing with Wallet actions.',
          ),
          SizedBox(height: space.component30),
          const AgentDemoStatus(
            message: '¥68,420 of your ¥120,000 flexible budget remains.',
          ),
          SizedBox(height: space.component25),
          for (final item in const <(String, String)>[
            ('Home and groceries', '¥31,200 left'),
            ('Creative supplies', '¥18,900 left'),
            ('Rest and play', '¥18,320 left'),
          ]) ...<Widget>[
            AgentDemoSurface(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(item.$1)),
                  Text(item.$2),
                ],
              ),
            ),
            SizedBox(height: space.component20),
          ],
        ],
      ),
    );
  }
}

final class LumenProfilePage extends StatelessWidget {
  const LumenProfilePage({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'PROFILE',
            title: 'Privacy and everyday choices',
            description: 'Control what is visible at a glance and how small card purchases are handled.',
          ),
          SizedBox(height: space.component30),
          AgentDemoProfileHeader(
            name: 'Mina Aoki',
            context: 'Personal wallet · Linked bank •••• 2418',
            summary: viewModel.balanceHidden
                ? 'Wallet balance is private'
                : 'Wallet balance is visible',
          ),
          SizedBox(height: space.component30),
          const AgentDemoSectionHeading(title: 'Privacy'),
          SizedBox(height: space.component20),
          AgentDemoPreferenceSwitch(
            key: const ValueKey<String>('agent-wallet-profile-balance'),
            description: 'Keep the amount private when Wallet opens. You can still reveal it from the balance card.',
            label: 'Hide balance by default',
            onChanged: viewModel.setBalanceHidden,
            status: viewModel.balanceHidden
                ? 'Balance is hidden on Wallet'
                : 'Balance is visible on Wallet',
            value: viewModel.balanceHidden,
          ),
          SizedBox(height: space.component30),
          const AgentDemoSectionHeading(title: 'Everyday automation'),
          SizedBox(height: space.component20),
          AgentDemoPreferenceSwitch(
            key: const ValueKey<String>('agent-wallet-profile-round-ups'),
            description: 'Set aside the small difference to the next ¥100 after future card purchases.',
            label: 'Round up card purchases',
            onChanged: viewModel.setRoundUps,
            status: viewModel.roundUps
                ? 'Round ups are active'
                : 'Round ups are paused',
            value: viewModel.roundUps,
          ),
        ],
      ),
    );
  }
}
