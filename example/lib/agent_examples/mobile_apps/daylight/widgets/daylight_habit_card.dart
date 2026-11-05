import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../shared/demo_components.dart';
import '../daylight_models.dart';

final class DaylightHabitCard extends StatelessWidget {
  const DaylightHabitCard({
    required this.habit,
    required this.onChanged,
    required this.value,
    this.showStreak = true,
    super.key,
  });

  final DaylightHabit habit;
  final ValueChanged<bool> onChanged;
  final bool showStreak;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return AgentDemoSurface(
      padding: EdgeInsets.symmetric(horizontal: space.lg, vertical: space.lg),
      child: SizedBox(
        width: double.infinity,
        child: CharcoalCheckbox(
          label: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CharcoalIcon(
                _habitIcon(habit.id),
                color: theme.colors.iconSecondary,
                size: 20,
              ),
              SizedBox(width: space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      habit.title,
                      style: theme
                          .style(CharcoalTextRole.captionMediumBold)
                          .copyWith(color: theme.colors.text),
                    ),
                    SizedBox(height: space.xs),
                    Text(
                      habit.cue,
                      style: theme
                          .style(CharcoalTextRole.caption)
                          .copyWith(
                            color: theme.colors.textSecondary,
                            height: 1.35,
                          ),
                    ),
                    if (showStreak) ...<Widget>[
                      SizedBox(height: space.sm),
                      Text(
                        habit.streak,
                        style: theme
                            .style(CharcoalTextRole.caption)
                            .copyWith(
                              color: theme.colors.textTertiary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          onChanged: onChanged,
          rounded: true,
          semanticLabel: habit.title,
          value: value,
        ),
      ),
    );
  }
}

CharcoalIconData _habitIcon(String id) => switch (id) {
  'stretch' => CharcoalIcons.body,
  'walk' => CharcoalIcons.location,
  _ => CharcoalIcons.book,
};
