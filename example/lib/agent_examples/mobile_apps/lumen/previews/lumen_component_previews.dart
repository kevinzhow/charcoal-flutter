import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../lumen_models.dart';
import '../lumen_view_model.dart';
import '../widgets/lumen_wallet_components.dart';

@AgentComponentPreview(
  name: 'Lumen balance and money actions',
  size: Size(390, 390),
)
Widget lumenMoneyActionsPreview() => const _LumenMoneyActionsPreview();

final class _LumenMoneyActionsPreview extends StatefulWidget {
  const _LumenMoneyActionsPreview();

  @override
  State<_LumenMoneyActionsPreview> createState() =>
      _LumenMoneyActionsPreviewState();
}

final class _LumenMoneyActionsPreviewState
    extends State<_LumenMoneyActionsPreview> {
  final LumenViewModel viewModel = LumenViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LumenBalanceCard(viewModel: viewModel),
          SizedBox(height: space.component30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              LumenQuickAction(
                icon: CharcoalIcons.arrowDown,
                label: 'Receive',
                onPressed: () {},
              ),
              LumenQuickAction(
                icon: CharcoalIcons.send,
                label: 'Send',
                onPressed: () {},
              ),
              LumenQuickAction(
                icon: CharcoalIcons.addCircle,
                label: 'Top up',
                onPressed: () {},
              ),
              LumenQuickAction(
                icon: CharcoalIcons.dotsHorizontal,
                label: 'More',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@AgentComponentPreview(name: 'Lumen activity states', size: Size(390, 290))
Widget lumenActivityStatesPreview() => const Column(
  children: <Widget>[
    LumenActivityRow(
      activity: LumenActivity(
        amount: -3200,
        kind: LumenActivityKind.sent,
        subtitle: 'Just now · Transfer',
        title: 'To Aya',
      ),
    ),
    SizedBox(height: 16),
    LumenActivityRow(
      activity: LumenActivity(
        amount: 10000,
        kind: LumenActivityKind.topUp,
        subtitle: 'Today · Linked bank',
        title: 'Bank top up',
      ),
    ),
  ],
);
