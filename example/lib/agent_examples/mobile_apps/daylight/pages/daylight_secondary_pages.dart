import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../daylight_models.dart';
import '../daylight_view_model.dart';

final class DaylightJourneyPage extends StatelessWidget {
  const DaylightJourneyPage({required this.viewModel, super.key});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    final days = <(String, String)>[
      (
        'Monday',
        '${viewModel.completedCount} of ${daylightHabits.length} complete',
      ),
      if (viewModel.tomorrowPlanned)
        ('Tuesday', 'Planned · ${viewModel.tomorrowHabitIds.length} habits'),
      ('Sunday', '3 of 3 complete'),
      ('Saturday', '2 of 3 complete'),
      ('Friday', '3 of 3 complete'),
    ];
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-habits-journey-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'YOUR JOURNEY',
            title: 'A week made from small moments',
            description:
                'Completed days and future plans share one calm timeline.',
          ),
          SizedBox(height: space.component30),
          for (final day in days) ...<Widget>[
            AgentDemoSurface(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final dayLabel = Text(
                    day.$1,
                    style: theme.textStyles.captionMediumBold.copyWith(
                      color: theme.colors.textDefault,
                    ),
                  );
                  final statusLabel = Text(
                    day.$2,
                    style: theme.textStyles.captionSmall.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  );
                  if (constraints.maxWidth < 300) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        dayLabel,
                        SizedBox(height: space.component10),
                        statusLabel,
                      ],
                    );
                  }
                  return Row(
                    children: <Widget>[
                      Expanded(child: dayLabel),
                      SizedBox(width: space.component20),
                      Flexible(child: statusLabel),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: space.component20),
          ],
          CharcoalButton(
            key: const ValueKey<String>('agent-habits-return-today'),
            fullWidth: true,
            onPressed: viewModel.returnToToday,
            child: const Text('Return to today'),
          ),
        ],
      ),
    );
  }
}

final class DaylightInsightsPage extends StatelessWidget {
  const DaylightInsightsPage({required this.viewModel, super.key});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-habits-insights-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'INSIGHTS',
            title: 'Notice what is already working',
            description: 'Signals support reflection; they never compete with today’s checklist.',
          ),
          SizedBox(height: space.component30),
          AgentDemoStatus(
            message:
                'This week: ${14 + viewModel.completedCount} habits completed',
          ),
          SizedBox(height: space.component20),
          const AgentDemoStatus(message: 'Strongest rhythm: Morning stretch'),
          SizedBox(height: space.component20),
          const AgentDemoStatus(message: 'Kindest streak: 7 gentle days'),
        ],
      ),
    );
  }
}

final class DaylightProfilePage extends StatelessWidget {
  const DaylightProfilePage({required this.viewModel, super.key});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-habits-profile-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'PROFILE',
            title: 'Make Daylight feel like yours',
            description: 'Reminder preferences live here, away from the daily completion flow.',
          ),
          SizedBox(height: space.component30),
          CharcoalSwitch(
            label: const Text('Gentle evening reminder'),
            onChanged: viewModel.setReminders,
            value: viewModel.reminders,
          ),
          SizedBox(height: space.component25),
          AgentDemoStatus(
            message: viewModel.reminders
                ? 'Evening reminders arrive at 8:30 PM.'
                : 'Evening reminders are paused.',
          ),
        ],
      ),
    );
  }
}
