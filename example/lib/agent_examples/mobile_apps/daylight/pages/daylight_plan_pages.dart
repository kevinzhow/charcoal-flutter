import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../daylight_models.dart';
import '../daylight_view_model.dart';
import '../widgets/daylight_habit_card.dart';

final class DaylightTomorrowPlanPage extends StatelessWidget {
  const DaylightTomorrowPlanPage({required this.viewModel, super.key});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-habits-tomorrow-plan-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'TUESDAY, AUGUST 18',
            title: 'Choose tomorrow’s gentle rhythm',
            description: 'Keep what still feels useful. Nothing is carried over until you save.',
          ),
          SizedBox(height: space.component40),
          for (final habit in daylightHabits) ...<Widget>[
            DaylightHabitCard(
              habit: habit,
              onChanged: (value) => viewModel.toggleTomorrowHabit(habit, value),
              showStreak: false,
              value: viewModel.isPlannedForTomorrow(habit),
            ),
            SizedBox(height: space.component30),
          ],
          CharcoalSwitch(
            label: const Text('Gentle reminder at 8:30 PM'),
            onChanged: viewModel.setTomorrowReminder,
            value: viewModel.tomorrowReminder,
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            key: const ValueKey<String>('agent-habits-save-tomorrow'),
            fullWidth: true,
            onPressed: viewModel.tomorrowHabitIds.isEmpty
                ? null
                : viewModel.saveTomorrowPlan,
            variant: CharcoalButtonVariant.primary,
            child: Text(
              viewModel.tomorrowHabitIds.isEmpty
                  ? 'Choose at least one habit'
                  : 'Save ${viewModel.tomorrowHabitIds.length} habits',
            ),
          ),
        ],
      ),
    );
  }
}

final class DaylightPlanSavedPage extends StatelessWidget {
  const DaylightPlanSavedPage({required this.viewModel, super.key});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    final count = viewModel.tomorrowHabitIds.length;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-habits-plan-saved-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'TUESDAY IS READY',
            title: 'Tomorrow has room to breathe',
            description:
                'The plan is saved locally and now appears in your Journey.',
          ),
          SizedBox(height: space.component40),
          AgentDemoStatus(
            message:
                '$count ${count == 1 ? 'habit is' : 'habits are'} planned${viewModel.tomorrowReminder ? ' with a gentle evening reminder' : ''}.',
            positive: true,
          ),
          SizedBox(height: space.component30),
          CharcoalButton(
            key: const ValueKey<String>('agent-habits-continue-journey'),
            fullWidth: true,
            onPressed: viewModel.continueToJourney,
            variant: CharcoalButtonVariant.primary,
            child: const Text('Continue to journey'),
          ),
        ],
      ),
    );
  }
}
