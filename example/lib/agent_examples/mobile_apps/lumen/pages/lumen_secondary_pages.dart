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
            title: 'Mina’s Lumen',
            description: 'Preferences stay here instead of opening an unrelated “More” action panel on Wallet.',
          ),
          SizedBox(height: space.component30),
          CharcoalSwitch(
            label: const Text('Round up card purchases'),
            onChanged: viewModel.setRoundUps,
            value: viewModel.roundUps,
          ),
          SizedBox(height: space.component25),
          AgentDemoStatus(
            message: viewModel.roundUps
                ? 'Round ups are active for future card purchases.'
                : 'Round ups are paused.',
          ),
        ],
      ),
    );
  }
}
