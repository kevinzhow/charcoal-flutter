import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../../../previews/preview_support.dart';
import '../daylight_models.dart';
import '../widgets/daylight_habit_card.dart';

@AgentComponentPreview(name: 'Daylight habit states', size: Size(390, 520))
Widget daylightHabitStatesPreview() => const _DaylightHabitStatesPreview();

final class _DaylightHabitStatesPreview extends StatefulWidget {
  const _DaylightHabitStatesPreview();

  @override
  State<_DaylightHabitStatesPreview> createState() =>
      _DaylightHabitStatesPreviewState();
}

final class _DaylightHabitStatesPreviewState
    extends State<_DaylightHabitStatesPreview> {
  bool firstCompleted = false;
  bool secondCompleted = true;

  @override
  Widget build(BuildContext context) {
    final gap = CharcoalTheme.of(context).dimensions.space.component30;
    return Column(
      children: <Widget>[
        DaylightHabitCard(
          habit: daylightHabits[0],
          onChanged: (value) => setState(() => firstCompleted = value),
          value: firstCompleted,
        ),
        SizedBox(height: gap),
        DaylightHabitCard(
          habit: daylightHabits[1],
          onChanged: (value) => setState(() => secondCompleted = value),
          value: secondCompleted,
        ),
      ],
    );
  }
}
