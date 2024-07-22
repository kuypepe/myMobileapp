import 'package:flutter/material.dart';
import 'package:set_your_goal_app/models/Goal_model.dart';
import 'package:set_your_goal_app/models/file_storage.dart'; // Import FileStorage
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class GoalListProvider extends ChangeNotifier {
  final List<Goal> _goalList = [];
  late FileStorage _fileStorage; // Initialize FileStorage

  GoalListProvider() {
    _fileStorage = FileStorage(); // Initialize FileStorage
    _loadGoals(); // Load goals when provider is initialized
  }

  Future<void> _loadGoals() async {
    try {
      await _fileStorage.init();
      List<Goal> goals = await _fileStorage.readGoals();
      _goalList.addAll(goals);
      notifyListeners();
      print("Goals loaded successfully: $_goalList"); // Add this line
    } catch (e) {
      print("Error loading goals: $e");
    }
  }

  Future<void> _saveGoals() async {
    try {
      await _fileStorage.writeGoals(_goalList);
      print("Goals saved successfully: $_goalList"); // Add this line
    } catch (e) {
      print("Error saving goals: $e");
    }
  }

  void addGoal(String title, int durationDays) {
    _goalList.add(Goal(title, durationDays));
    _saveGoals(); // Save goals after adding
    notifyListeners();
  }

  void removeGoal(Goal goal) {
    _goalList.remove(goal);
    _saveGoals(); // Save goals after removing
    notifyListeners();
  }

  List<Goal> get goalList => _goalList;

  void addExerciseToGoal(Goal goal, int day, String exercise) {
    goal.addExerciseInDay(day, exercise);
    _saveGoals(); // Save goals after adding exercise
    notifyListeners();
  }

  void updateGoal(Goal goal, String newTitle, int newDuration) {
    goal.name = newTitle;
    goal.updateDurationAndDays(newDuration);
    _saveGoals(); // Save goals after updating
    notifyListeners();
  }

  void setGoal(Goal goal) {
    _goalList.add(goal);
    _saveGoals(); // Save goals after setting
    notifyListeners();
  }
}
