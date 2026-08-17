import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

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
    builder: (context, _) {
      final theme = CharcoalTheme.of(context);
      return AgentDemoAppShell(
        appKey: 'habits',
        appLabel: 'Daylight wellness app demo',
        brandColor: theme.colors.containerDiscoveryDefault,
        brandForeground: theme.colors.textOnDiscoveryDefault,
        brandMark: 'D',
        bottomItems: const <AgentDemoBottomItem>[
          AgentDemoBottomItem('Today', CharcoalIcons.sun),
          AgentDemoBottomItem('Journey', CharcoalIcons.calendar),
          AgentDemoBottomItem('Insights', CharcoalIcons.star),
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
        trailing: _viewModel.task == DaylightTask.none
            ? CharcoalIconButton(
                icon: const CharcoalIcon(CharcoalIcons.calendar),
                onPressed: _viewModel.openJourney,
                semanticLabel: 'Open Daylight journey',
                size: CharcoalIconButtonSize.small,
              )
            : null,
      );
    },
  );

  Widget _content() => switch (_viewModel.task) {
    DaylightTask.none => switch (_viewModel.destination) {
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
}
