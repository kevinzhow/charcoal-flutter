import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../daylight_models.dart';
import '../daylight_view_model.dart';
import '../widgets/daylight_habit_card.dart';
import '../widgets/daylight_item_group.dart';

final class DaylightTodayPage extends StatelessWidget {
  const DaylightTodayPage({required this.viewModel, super.key});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return AgentDemoPage(
      child: Column(
        key: const ValueKey<String>('agent-habits-today-page'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const AgentDemoPageHeading(
            eyebrow: 'MONDAY, AUGUST 17',
            title: 'A gentle day is still progress.',
            description: 'Three small commitments are enough. Move through them at your own pace.',
          ),
          SizedBox(height: space.xl),
          _TodayProgress(viewModel: viewModel),
          SizedBox(height: space.xl),
          const AgentDemoSectionHeading(title: 'Your habits'),
          SizedBox(height: space.lg),
          DaylightItemGroup(
            children: <Widget>[
              for (final habit in daylightHabits)
                DaylightHabitCard(
                  key: ValueKey<String>('agent-habit-${habit.id}-row'),
                  habit: habit,
                  onChanged: (value) => viewModel.toggleHabit(habit, value),
                  showStreak: viewModel.showStreaks,
                  value: viewModel.isCompleted(habit),
                ),
            ],
          ),
          SizedBox(height: space.lg),
          if (viewModel.isTodayComplete) ...<Widget>[
            const AgentDemoStatus(
              message: 'Everything is complete. Today’s three commitments remain here if you need to undo one.',
              positive: true,
            ),
            SizedBox(height: space.md),
            CharcoalButton(
              key: const ValueKey<String>('agent-habits-plan-tomorrow'),
              fullWidth: true,
              onPressed: viewModel.startTomorrowPlan,
              variant: CharcoalButtonVariant.primary,
              child: const Text('Plan tomorrow'),
            ),
          ] else
            const AgentDemoStatus(
              icon: CharcoalIcons.bulbShine,
              message: 'Consistency grows from kindness, not pressure.',
            ),
        ],
      ),
    );
  }
}

final class _TodayProgress extends StatelessWidget {
  const _TodayProgress({required this.viewModel});

  final DaylightViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    final remaining = daylightHabits.length - viewModel.completedCount;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.lg),
        color: theme.colors.notice,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.lg),
        child: Row(
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colors.icon.withValues(alpha: 0.32),
                  width: 6,
                ),
                borderRadius: BorderRadius.circular(theme.radius.pill),
                color: theme.colors.background.withValues(alpha: 0.18),
              ),
              child: SizedBox.square(
                dimension: 60,
                child: Center(
                  child: Text(
                    '${viewModel.completedCount}/${daylightHabits.length}',
                    style: theme
                        .style(CharcoalTextRole.captionMediumBold)
                        .copyWith(color: theme.colors.text),
                  ),
                ),
              ),
            ),
            SizedBox(width: space.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Today’s rhythm',
                    style: theme
                        .style(CharcoalTextRole.captionMediumBold)
                        .copyWith(color: theme.colors.text),
                  ),
                  SizedBox(height: space.xs),
                  Text(
                    remaining == 0
                        ? 'Everything is complete.'
                        : remaining == 1
                        ? '1 small step remaining'
                        : '$remaining small steps remaining',
                    style: theme
                        .style(CharcoalTextRole.caption)
                        .copyWith(
                          color: theme.colors.text.withValues(alpha: 0.76),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
