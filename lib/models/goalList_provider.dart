import 'package:flutter/material.dart';
import 'Goal_model.dart';

class GoalListProvider extends ChangeNotifier {
  final List<Goal> _goalList = [Goal("Test", 15), Goal('Testing', 12)];

  GoalListProvider() {
    _goalList[0].addExerciseInDay(0, '100 push up');
    _goalList[0].addExerciseInDay(0, '100 jumping jacks');
  }

  void addGoal(String title, int durationDays) {
    _goalList.add(Goal(title, durationDays));
    notifyListeners();
  }

  void removeGoal(String title) {
    _goalList.removeWhere((item) => item.name == title);
    notifyListeners();
  }

  List<Goal> get goalList => _goalList;

  void addExerciseToGoal(Goal goal, int day, String exercise) {
    goal.addExerciseInDay(day, exercise);
    notifyListeners();
  }
}
