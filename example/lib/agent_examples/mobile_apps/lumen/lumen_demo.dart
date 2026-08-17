import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../agent_example_navigator.dart';
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
    builder: (context, _) =>
        AgentExampleNavigator(appKey: 'wallet', pages: _pages()),
  );

  List<AgentExamplePage> _pages() {
    final destination = _viewModel.destination;
    final root = _page(
      destination: destination,
      pageKey: 'root-${destination.name}',
      task: LumenTask.none,
      routeKey: 'root',
    );
    return switch (_viewModel.task) {
      LumenTask.none => <AgentExamplePage>[root],
      LumenTask.receive => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'receive',
          onDidPop: () => _popIfCurrent(LumenTask.receive),
          task: LumenTask.receive,
        ),
      ],
      LumenTask.sendEdit => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'send-edit',
          onDidPop: () => _popIfCurrent(LumenTask.sendEdit),
          task: LumenTask.sendEdit,
        ),
      ],
      LumenTask.sendReview => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'send-edit',
          task: LumenTask.sendEdit,
        ),
        _page(
          destination: destination,
          pageKey: 'send-review',
          onDidPop: () => _popIfCurrent(LumenTask.sendReview),
          task: LumenTask.sendReview,
        ),
      ],
      LumenTask.sendConfirmed => <AgentExamplePage>[
        _page(
          destination: destination,
          pageKey: 'send-confirmed',
          task: LumenTask.sendConfirmed,
        ),
      ],
      LumenTask.topUpEdit => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'top-up-edit',
          onDidPop: () => _popIfCurrent(LumenTask.topUpEdit),
          task: LumenTask.topUpEdit,
        ),
      ],
      LumenTask.topUpConfirmed => <AgentExamplePage>[
        _page(
          destination: destination,
          pageKey: 'top-up-confirmed',
          task: LumenTask.topUpConfirmed,
        ),
      ],
    };
  }

  AgentExamplePage _page({
    required LumenDestination destination,
    required String pageKey,
    required LumenTask task,
    VoidCallback? onDidPop,
    String? routeKey,
  }) {
    final sendAmount = _viewModel.parsedSendAmount;
    final recipient = _viewModel.recipient.trim();
    final balance = _viewModel.balance;
    final topUpAmount = _viewModel.topUpAmount;
    return AgentExamplePage(
      builder: (context) => _shell(
        context,
        balance: balance,
        canGoBack: onDidPop != null,
        destination: destination,
        pageKey: pageKey,
        recipient: recipient,
        sendAmount: sendAmount,
        task: task,
        topUpAmount: topUpAmount,
      ),
      key: ValueKey<String>('agent-wallet-route-${routeKey ?? pageKey}'),
      listenable: _viewModel,
      name: '/lumen/$pageKey',
      onDidPop: onDidPop,
    );
  }

  Widget _shell(
    BuildContext context, {
    required int balance,
    required bool canGoBack,
    required LumenDestination destination,
    required String pageKey,
    required String recipient,
    required int? sendAmount,
    required LumenTask task,
    required int topUpAmount,
  }) {
    final theme = CharcoalTheme.of(context);
    final title = _title(task, destination);
    return AgentDemoAppShell<LumenDestination>(
      appKey: 'wallet',
      appLabel: 'Lumen personal finance app demo',
      brandColor: theme.colors.containerPositiveDefault,
      brandForeground: theme.colors.textOnPositiveDefault,
      brandMark: 'L',
      tabItems: const <CharcoalTabItem<LumenDestination>>[
        CharcoalTabItem<LumenDestination>(
          icon: CharcoalIcon(CharcoalIcons.invoice),
          key: ValueKey<String>('agent-wallet-nav-wallet'),
          label: 'Wallet',
          value: LumenDestination.wallet,
        ),
        CharcoalTabItem<LumenDestination>(
          icon: CharcoalIcon(CharcoalIcons.history),
          key: ValueKey<String>('agent-wallet-nav-activity'),
          label: 'Activity',
          value: LumenDestination.activity,
        ),
        CharcoalTabItem<LumenDestination>(
          icon: CharcoalIcon(CharcoalIcons.calendar),
          key: ValueKey<String>('agent-wallet-nav-plan'),
          label: 'Plan',
          value: LumenDestination.plan,
        ),
        CharcoalTabItem<LumenDestination>(
          icon: CharcoalIcon(CharcoalIcons.personCircle),
          key: ValueKey<String>('agent-wallet-nav-profile'),
          label: 'Profile',
          value: LumenDestination.profile,
        ),
      ],
      content: _content(
        task,
        destination,
        balance: balance,
        recipient: recipient,
        sendAmount: sendAmount,
        topUpAmount: topUpAmount,
      ),
      leading: canGoBack
          ? AgentDemoBackButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              semanticLabel: 'Back from $title',
            )
          : null,
      onTabSelected: _viewModel.selectDestination,
      pageKey: pageKey,
      selectedTab: destination,
      showTabBar: task == LumenTask.none,
      title: title,
      trailing: task == LumenTask.none
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
  }

  Widget _content(
    LumenTask task,
    LumenDestination destination, {
    required int balance,
    required String recipient,
    required int? sendAmount,
    required int topUpAmount,
  }) => switch (task) {
    LumenTask.none => switch (destination) {
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
    LumenTask.sendReview => LumenSendReviewPage(
      amount: sendAmount!,
      balance: balance,
      onConfirm: _viewModel.confirmSend,
      recipient: recipient,
    ),
    LumenTask.sendConfirmed => LumenSendConfirmedPage(
      amount: sendAmount!,
      onDone: _finishTask,
      onViewActivity: () {
        _viewModel.openActivity();
        _clearDraftControllers();
      },
      recipient: recipient,
    ),
    LumenTask.topUpEdit => LumenTopUpPage(viewModel: _viewModel),
    LumenTask.topUpConfirmed => LumenTopUpConfirmedPage(
      amount: topUpAmount,
      balance: balance,
      onDone: _finishTask,
    ),
  };

  String _title(LumenTask task, LumenDestination destination) => switch (task) {
    LumenTask.none => switch (destination) {
      LumenDestination.wallet => 'Lumen',
      LumenDestination.activity => 'Activity',
      LumenDestination.plan => 'Plan',
      LumenDestination.profile => 'Profile',
    },
    LumenTask.receive => 'Receive money',
    LumenTask.sendEdit => 'Send money',
    LumenTask.sendReview => 'Review transfer',
    LumenTask.sendConfirmed => 'Transfer sent',
    LumenTask.topUpEdit => 'Top up',
    LumenTask.topUpConfirmed => 'Balance updated',
  };

  void _popIfCurrent(LumenTask task) {
    if (_viewModel.task == task) _viewModel.goBack();
  }

  void _finishTask() {
    _viewModel.finishTask();
    _clearDraftControllers();
  }

  void _clearDraftControllers() {
    _amountController.clear();
    _recipientController.clear();
  }
}
