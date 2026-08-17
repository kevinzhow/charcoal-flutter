import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shared/demo_shell.dart';
import 'lumen_models.dart';
import 'lumen_view_model.dart';
import 'pages/lumen_secondary_pages.dart';
import 'pages/lumen_task_pages.dart';
import 'pages/lumen_wallet_page.dart';

final class LumenDemo extends StatefulWidget {
  const LumenDemo({this.createViewModel, super.key});

  /// Supplies deterministic state for previews while keeping the demo in
  /// charge of the model lifecycle.
  final LumenViewModel Function()? createViewModel;

  @override
  State<LumenDemo> createState() => _LumenDemoState();
}

final class _LumenDemoState extends State<LumenDemo> {
  late final TextEditingController _amountController;
  late final TextEditingController _recipientController;
  late final LumenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.createViewModel?.call() ?? LumenViewModel();
    _amountController = TextEditingController(text: _viewModel.sendAmount);
    _recipientController = TextEditingController(text: _viewModel.recipient);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, _) {
      final theme = CharcoalTheme.of(context);
      return AgentDemoAppShell(
        appKey: 'wallet',
        appLabel: 'Lumen personal finance app demo',
        brandColor: theme.colors.containerPositiveDefault,
        brandForeground: theme.colors.textOnPositiveDefault,
        brandMark: 'L',
        bottomItems: const <AgentDemoBottomItem>[
          AgentDemoBottomItem('Wallet', CharcoalIcons.invoice),
          AgentDemoBottomItem('Activity', CharcoalIcons.history),
          AgentDemoBottomItem('Plan', CharcoalIcons.calendar),
          AgentDemoBottomItem('Profile', CharcoalIcons.personCircle),
        ],
        content: _content(),
        leading: _viewModel.canGoBack
            ? AgentDemoBackButton(
                onPressed: _viewModel.goBack,
                semanticLabel: 'Back from ${_viewModel.title}',
              )
            : null,
        onBottomItemSelected: _viewModel.selectDestination,
        selectedBottomIndex: _viewModel.selectedBottomIndex,
        showBottomNavigation: _viewModel.showBottomNavigation,
        title: _viewModel.title,
        trailing: _viewModel.task == LumenTask.none
            ? CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.bell),
                onPressed: () => showCharcoalToast(
                  context: context,
                  message: 'No new account alerts. Everything looks calm.',
                ),
                semanticLabel: 'Lumen notifications',
                size: CharcoalIconButtonSize.small,
              )
            : null,
      );
    },
  );

  Widget _content() => switch (_viewModel.task) {
    LumenTask.none => switch (_viewModel.destination) {
      LumenDestination.wallet => LumenWalletPage(viewModel: _viewModel),
      LumenDestination.activity => LumenActivityPage(viewModel: _viewModel),
      LumenDestination.plan => const LumenPlanPage(),
      LumenDestination.profile => LumenProfilePage(viewModel: _viewModel),
    },
    LumenTask.receive => LumenReceivePage(viewModel: _viewModel),
    LumenTask.sendEdit => LumenSendEditPage(
      amountController: _amountController,
      recipientController: _recipientController,
      viewModel: _viewModel,
    ),
    LumenTask.sendReview => LumenSendReviewPage(viewModel: _viewModel),
    LumenTask.sendConfirmed => LumenSendConfirmedPage(
      onDone: _finishTask,
      onViewActivity: () {
        _viewModel.openActivity();
        _clearDraftControllers();
      },
      viewModel: _viewModel,
    ),
    LumenTask.topUpEdit => LumenTopUpPage(viewModel: _viewModel),
    LumenTask.topUpConfirmed => LumenTopUpConfirmedPage(
      onDone: _finishTask,
      viewModel: _viewModel,
    ),
  };

  void _finishTask() {
    _viewModel.finishTask();
    _clearDraftControllers();
  }

  void _clearDraftControllers() {
    _amountController.clear();
    _recipientController.clear();
  }
}
