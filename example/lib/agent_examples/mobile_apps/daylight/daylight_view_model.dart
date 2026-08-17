import 'package:flutter/foundation.dart';

import 'daylight_models.dart';

final class DaylightViewModel extends ChangeNotifier {
  final Set<String> _completedIds = <String>{'stretch'};
  DaylightDestination _destination = DaylightDestination.today;
  bool _reminders = true;
  bool _showStreaks = true;
  Set<String> _tomorrowHabitIds = <String>{};
  bool _tomorrowPlanned = false;
  bool _tomorrowReminder = true;
  DaylightTask _task = DaylightTask.none;

  int get completedCount => _completedIds.length;
  DaylightDestination get destination => _destination;
  bool get isTodayComplete => completedCount == daylightHabits.length;
  bool get reminders => _reminders;
  bool get showStreaks => _showStreaks;
  int get selectedBottomIndex => _destination.index;
  bool get showBottomNavigation => _task == DaylightTask.none;
  DaylightTask get task => _task;
  Set<String> get tomorrowHabitIds =>
      Set<String>.unmodifiable(_tomorrowHabitIds);
  bool get tomorrowPlanned => _tomorrowPlanned;
  bool get tomorrowReminder => _tomorrowReminder;

  bool get canGoBack => _task == DaylightTask.planTomorrow;

  String get title => switch (_task) {
    DaylightTask.none => switch (_destination) {
      DaylightDestination.today => 'Daylight',
      DaylightDestination.journey => 'Journey',
      DaylightDestination.insights => 'Insights',
      DaylightDestination.profile => 'Profile',
    },
    DaylightTask.planTomorrow => 'Plan tomorrow',
    DaylightTask.planSaved => 'Tomorrow planned',
  };

  bool isCompleted(DaylightHabit habit) => _completedIds.contains(habit.id);

  bool isPlannedForTomorrow(DaylightHabit habit) =>
      _tomorrowHabitIds.contains(habit.id);

  void selectDestination(int index) {
    _destination = DaylightDestination.values[index];
    _task = DaylightTask.none;
    notifyListeners();
  }

  void openJourney() => selectDestination(DaylightDestination.journey.index);

  void returnToToday() => selectDestination(DaylightDestination.today.index);

  void toggleHabit(DaylightHabit habit, bool value) {
    if (value) {
      _completedIds.add(habit.id);
    } else {
      _completedIds.remove(habit.id);
    }
    notifyListeners();
  }

  void startTomorrowPlan() {
    if (!isTodayComplete) return;
    _tomorrowHabitIds = daylightHabits.map((habit) => habit.id).toSet();
    _task = DaylightTask.planTomorrow;
    notifyListeners();
  }

  void toggleTomorrowHabit(DaylightHabit habit, bool value) {
    if (value) {
      _tomorrowHabitIds.add(habit.id);
    } else {
      _tomorrowHabitIds.remove(habit.id);
    }
    notifyListeners();
  }

  void setTomorrowReminder(bool value) {
    _tomorrowReminder = value;
    notifyListeners();
  }

  void saveTomorrowPlan() {
    if (_tomorrowHabitIds.isEmpty) return;
    _tomorrowPlanned = true;
    _task = DaylightTask.planSaved;
    notifyListeners();
  }

  void continueToJourney() {
    _destination = DaylightDestination.journey;
    _task = DaylightTask.none;
    notifyListeners();
  }

  void setReminders(bool value) {
    if (_reminders == value) return;
    _reminders = value;
    notifyListeners();
  }

  void setShowStreaks(bool value) {
    if (_showStreaks == value) return;
    _showStreaks = value;
    notifyListeners();
  }

  void goBack() {
    if (_task != DaylightTask.planTomorrow) return;
    _task = DaylightTask.none;
    notifyListeners();
  }
}
