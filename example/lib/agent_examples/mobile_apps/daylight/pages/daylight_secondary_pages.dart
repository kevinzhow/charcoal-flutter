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
          _DaylightInsight(
            label: 'This week',
            value: '${14 + viewModel.completedCount} habits completed',
          ),
          SizedBox(height: space.component20),
          const _DaylightInsight(
            label: 'Strongest rhythm',
            value: 'Morning stretch · 6 of 7 days',
          ),
          SizedBox(height: space.component20),
          const _DaylightInsight(
            label: 'Gentle consistency',
            value: '7 days with at least one small step',
          ),
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
            title: 'Shape your daily support',
            description: 'Choose how Daylight encourages you without changing the habits you committed to.',
          ),
          SizedBox(height: space.component30),
          AgentDemoProfileHeader(
            name: 'Mina Aoki',
            context: 'Daylight journey · Week 4',
            summary:
                '${14 + viewModel.completedCount} habits completed this week',
          ),
          SizedBox(height: space.component30),
          const AgentDemoSectionHeading(title: 'Support style'),
          SizedBox(height: space.component20),
          AgentDemoPreferenceSwitch(
            key: const ValueKey<String>('agent-habits-profile-reminders'),
            description: 'Receive one calm prompt when today still has an unfinished habit.',
            label: 'Gentle evening reminder',
            onChanged: viewModel.setReminders,
            status: viewModel.reminders
                ? 'Reminder scheduled for 8:30 PM'
                : 'Evening reminder is paused',
            value: viewModel.reminders,
          ),
          SizedBox(height: space.component20),
          AgentDemoPreferenceSwitch(
            key: const ValueKey<String>('agent-habits-profile-streaks'),
            description: 'Show recent consistency under each habit. Turning this off keeps progress counts intact.',
            label: 'Show streaks on Today',
            onChanged: viewModel.setShowStreaks,
            status: viewModel.showStreaks
                ? 'Streak context is visible'
                : 'Today shows cues without streaks',
            value: viewModel.showStreaks,
          ),
        ],
      ),
    );
  }
}

final class _DaylightInsight extends StatelessWidget {
  const _DaylightInsight({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return AgentDemoSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label.toUpperCase(),
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textTertiaryDefault,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            value,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
        ],
      ),
    );
  }
}
