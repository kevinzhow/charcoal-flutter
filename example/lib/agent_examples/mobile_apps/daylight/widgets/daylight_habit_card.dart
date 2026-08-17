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
    final space = theme.dimensions.space;
    return AgentDemoSurface(
      padding: EdgeInsets.symmetric(
        horizontal: space.component30,
        vertical: space.component30,
      ),
      child: SizedBox(
        width: double.infinity,
        child: CharcoalCheckbox(
          label: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CharcoalIcon(
                _habitIcon(habit.id),
                color: theme.colors.iconSecondaryDefault,
                size: 20,
              ),
              SizedBox(width: space.component25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      habit.title,
                      style: theme.textStyles.captionMediumBold.copyWith(
                        color: theme.colors.textDefault,
                      ),
                    ),
                    SizedBox(height: space.component10),
                    Text(
                      habit.cue,
                      style: theme.textStyles.captionSmall.copyWith(
                        color: theme.colors.textSecondaryDefault,
                        height: 1.35,
                      ),
                    ),
                    if (showStreak) ...<Widget>[
                      SizedBox(height: space.component20),
                      Text(
                        habit.streak,
                        style: theme.textStyles.captionSmall.copyWith(
                          color: theme.colors.textTertiaryDefault,
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
