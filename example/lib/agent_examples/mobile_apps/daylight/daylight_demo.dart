import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../agent_example_navigator.dart';
import '../../shared/agent_demo_tab_bar.dart';
import '../shared/demo_shell.dart';
import 'daylight_models.dart';
import 'daylight_view_model.dart';
import 'pages/daylight_plan_pages.dart';
import 'pages/daylight_secondary_pages.dart';
import 'pages/daylight_today_page.dart';

final class DaylightDemo extends StatefulWidget {
  const DaylightDemo({this.createViewModel, super.key});

  /// Supplies deterministic state for previews while keeping the demo in
  /// charge of the model lifecycle.
  final DaylightViewModel Function()? createViewModel;

  @override
  State<DaylightDemo> createState() => _DaylightDemoState();
}

final class _DaylightDemoState extends State<DaylightDemo> {
  late final DaylightViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.createViewModel?.call() ?? DaylightViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _viewModel,
    builder: (context, _) =>
        AgentExampleNavigator(appKey: 'habits', pages: _pages()),
  );

  List<AgentExamplePage> _pages() {
    final destination = _viewModel.destination;
    final root = _page(
      destination: destination,
      pageKey: 'root-${destination.name}',
      task: DaylightTask.none,
      routeKey: 'root',
    );
    return switch (_viewModel.task) {
      DaylightTask.none => <AgentExamplePage>[root],
      DaylightTask.planTomorrow => <AgentExamplePage>[
        root,
        _page(
          destination: destination,
          pageKey: 'plan-tomorrow',
          onDidPop: () => _popIfCurrent(DaylightTask.planTomorrow),
          task: DaylightTask.planTomorrow,
        ),
      ],
      DaylightTask.planSaved => <AgentExamplePage>[
        _page(
          destination: destination,
          pageKey: 'plan-saved',
          task: DaylightTask.planSaved,
        ),
      ],
    };
  }

  AgentExamplePage _page({
    required DaylightDestination destination,
    required String pageKey,
    required DaylightTask task,
    VoidCallback? onDidPop,
    String? routeKey,
  }) => AgentExamplePage(
    builder: (context) => _shell(
      context,
      canGoBack: onDidPop != null,
      destination: destination,
      pageKey: pageKey,
      task: task,
    ),
    key: ValueKey<String>('agent-habits-route-${routeKey ?? pageKey}'),
    listenable: _viewModel,
    name: '/daylight/$pageKey',
    onDidPop: onDidPop,
  );

  Widget _shell(
    BuildContext context, {
    required bool canGoBack,
    required DaylightDestination destination,
    required String pageKey,
    required DaylightTask task,
  }) {
    final theme = CharcoalTheme.of(context);
    final title = _title(task, destination);
    return AgentDemoAppShell(
      appKey: 'habits',
      appLabel: 'Daylight wellness app demo',
      brandColor: theme.colors.containerDiscoveryDefault,
      brandForeground: theme.colors.textOnDiscoveryDefault,
      brandMark: 'D',
      tabItems: const <AgentDemoTabItem>[
        AgentDemoTabItem('Today', CharcoalIcons.sun),
        AgentDemoTabItem('Journey', CharcoalIcons.calendar),
        AgentDemoTabItem('Insights', CharcoalIcons.star),
        AgentDemoTabItem('Profile', CharcoalIcons.personCircle),
      ],
      content: _content(task, destination),
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
      selectedTabIndex: destination.index,
      showTabBar: task == DaylightTask.none,
      title: title,
      trailing: task == DaylightTask.none
          ? CharcoalIconButton(
              icon: const CharcoalIcon(CharcoalIcons.calendar),
              onPressed: _viewModel.openJourney,
              semanticLabel: 'Open Daylight journey',
              size: CharcoalIconButtonSize.small,
            )
          : null,
    );
  }

  Widget _content(
    DaylightTask task,
    DaylightDestination destination,
  ) => switch (task) {
    DaylightTask.none => switch (destination) {
      DaylightDestination.today => DaylightTodayPage(viewModel: _viewModel),
      DaylightDestination.journey => DaylightJourneyPage(viewModel: _viewModel),
      DaylightDestination.insights => DaylightInsightsPage(
        viewModel: _viewModel,
      ),
      DaylightDestination.profile => DaylightProfilePage(viewModel: _viewModel),
    },
    DaylightTask.planTomorrow => DaylightTomorrowPlanPage(
      viewModel: _viewModel,
    ),
    DaylightTask.planSaved => DaylightPlanSavedPage(viewModel: _viewModel),
  };

  String _title(DaylightTask task, DaylightDestination destination) =>
      switch (task) {
        DaylightTask.none => switch (destination) {
          DaylightDestination.today => 'Daylight',
          DaylightDestination.journey => 'Journey',
          DaylightDestination.insights => 'Insights',
          DaylightDestination.profile => 'Profile',
        },
        DaylightTask.planTomorrow => 'Plan tomorrow',
        DaylightTask.planSaved => 'Tomorrow planned',
      };

  void _popIfCurrent(DaylightTask task) {
    if (_viewModel.task == task) _viewModel.goBack();
  }
}
