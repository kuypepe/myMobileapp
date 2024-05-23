import 'package:flutter/material.dart';
import 'Goal_model.dart';

class GoalListProvider extends ChangeNotifier {
  final List<Goal> _goalList = [];

  void addGoal(String title, int durationDays) {
    _goalList.add(Goal(title, durationDays));
    notifyListeners();
  }

  void removeGoal(Goal goal) {
    _goalList.remove(goal);
    notifyListeners();
  }

  List<Goal> get goalList => _goalList;

  void addExerciseToGoal(Goal goal, int day, String exercise) {
    goal.addExerciseInDay(day, exercise);
    notifyListeners();
  }

  void updateGoal(Goal goal, String newTitle, int newDuration) {
    goal.name = newTitle;
    goal.updateDurationAndDays(newDuration);
    notifyListeners();
  }

  void setGoal(Goal goal) {
    _goalList.add(goal);
    notifyListeners();
  }
}
