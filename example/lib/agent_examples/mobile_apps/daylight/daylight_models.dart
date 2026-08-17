enum DaylightDestination { today, journey, insights, profile }

enum DaylightTask { none, planTomorrow, planSaved }

final class DaylightHabit {
  const DaylightHabit({
    required this.cue,
    required this.id,
    required this.streak,
    required this.title,
  });

  final String cue;
  final String id;
  final String streak;
  final String title;
}

const daylightHabits = <DaylightHabit>[
  DaylightHabit(
    cue: 'Loosen shoulders and breathe for five minutes.',
    id: 'stretch',
    streak: '7 gentle days',
    title: 'Morning stretch',
  ),
  DaylightHabit(
    cue: 'Step outside for one unhurried block.',
    id: 'walk',
    streak: '3 gentle days',
    title: 'Walk outside',
  ),
  DaylightHabit(
    cue: 'Settle in with a book for twenty minutes.',
    id: 'read',
    streak: '5 gentle days',
    title: 'Read for 20 minutes',
  ),
];
