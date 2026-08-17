import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../lumen_view_model.dart';
import '../widgets/lumen_wallet_components.dart';

final class LumenWalletPage extends StatelessWidget {
  const LumenWalletPage({required this.viewModel, super.key});

  final LumenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-wallet-home-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'GOOD AFTERNOON, MINA',
            title: 'Your money, clearly held',
            description: 'Available balance and recent movement lead; money actions stay close but secondary.',
          ),
          SizedBox(height: space.component30),
          LumenBalanceCard(viewModel: viewModel),
          SizedBox(height: space.component30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LumenQuickAction(
                key: const ValueKey<String>('agent-wallet-action-receive'),
                icon: CharcoalIcons.arrowDown,
                label: 'Receive',
                onPressed: viewModel.startReceive,
              ),
              LumenQuickAction(
                key: const ValueKey<String>('agent-wallet-action-send'),
                icon: CharcoalIcons.send,
                label: 'Send',
                onPressed: viewModel.startSend,
              ),
              LumenQuickAction(
                key: const ValueKey<String>('agent-wallet-action-topUp'),
                icon: CharcoalIcons.addCircle,
                label: 'Top up',
                onPressed: viewModel.startTopUp,
              ),
              LumenQuickAction(
                key: const ValueKey<String>('agent-wallet-action-more'),
                icon: CharcoalIcons.dotsHorizontal,
                label: 'More',
                onPressed: viewModel.openProfileOptions,
              ),
            ],
          ),
          SizedBox(height: space.component40),
          const AgentDemoSectionHeading(title: 'Recent activity'),
          SizedBox(height: space.component20),
          for (final item in viewModel.activity.take(3))
            Padding(
              padding: EdgeInsets.only(bottom: space.component20),
              child: LumenActivityRow(activity: item),
            ),
        ],
      ),
    );
  }
}
