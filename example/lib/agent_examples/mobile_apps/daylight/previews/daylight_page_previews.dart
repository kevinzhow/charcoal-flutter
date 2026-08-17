import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../daylight_demo.dart';
import '../daylight_models.dart';
import '../daylight_view_model.dart';

@AgentPagePreview(app: 'Daylight', state: 'Today', includeDark: true)
Widget daylightTodayPreview() => const DaylightDemo();

@AgentPagePreview(app: 'Daylight', state: 'Day complete')
Widget daylightCompletePreview() =>
    DaylightDemo(createViewModel: createDaylightCompletePreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Plan tomorrow')
Widget daylightTomorrowPlanPreview() =>
    DaylightDemo(createViewModel: createDaylightTomorrowPlanPreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Plan saved')
Widget daylightPlanSavedPreview() =>
    DaylightDemo(createViewModel: createDaylightPlanSavedPreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Journey with tomorrow')
Widget daylightJourneyPreview() =>
    DaylightDemo(createViewModel: createDaylightJourneyPreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Journey')
Widget daylightJourneyEmptyPreview() =>
    DaylightDemo(createViewModel: createDaylightJourneyEmptyPreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Insights')
Widget daylightInsightsPreview() =>
    DaylightDemo(createViewModel: createDaylightInsightsPreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Profile')
Widget daylightProfilePreview() =>
    DaylightDemo(createViewModel: createDaylightProfilePreviewModel);

@AgentPagePreview(app: 'Daylight', state: 'Profile quiet mode')
Widget daylightProfileQuietPreview() =>
    DaylightDemo(createViewModel: createDaylightProfileQuietPreviewModel);

DaylightViewModel createDaylightCompletePreviewModel() {
  final viewModel = DaylightViewModel();
  for (final habit in daylightHabits) {
    viewModel.toggleHabit(habit, true);
  }
  return viewModel;
}

DaylightViewModel createDaylightTomorrowPlanPreviewModel() =>
    createDaylightCompletePreviewModel()..startTomorrowPlan();

DaylightViewModel createDaylightPlanSavedPreviewModel() =>
    createDaylightTomorrowPlanPreviewModel()
      ..toggleTomorrowHabit(daylightHabits.last, false)
      ..saveTomorrowPlan();

DaylightViewModel createDaylightJourneyPreviewModel() =>
    createDaylightPlanSavedPreviewModel()..continueToJourney();

DaylightViewModel createDaylightJourneyEmptyPreviewModel() =>
    DaylightViewModel()..openJourney();

DaylightViewModel createDaylightInsightsPreviewModel() =>
    DaylightViewModel()..selectDestination(DaylightDestination.insights.index);

DaylightViewModel createDaylightProfilePreviewModel() =>
    DaylightViewModel()..selectDestination(DaylightDestination.profile.index);

DaylightViewModel createDaylightProfileQuietPreviewModel() =>
    createDaylightProfilePreviewModel()
      ..setReminders(false)
      ..setShowStreaks(false);
