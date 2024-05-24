import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:set_your_goal_app/models/goal_model.dart';

class Goal extends ChangeNotifier {
  String id;
  String? name;
  int? durationInDays;
  List<ExerciseListPerDay?>? goalList;

  Goal(this.name, this.durationInDays) : id = Uuid().v4() {
    goalList = [];
    for (int i = 0; i < durationInDays!; i++) {
      goalList!.add(null);
    }
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      json['name'],
      json['durationInDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationInDays': durationInDays,
    };
  }

  void updateDurationAndDays(int day) {
    if (day == durationInDays) {
      return;
    }
    if (day < durationInDays!) {
      for (int i = day; i < durationInDays!; i++) {
        goalList!.removeAt(day);
      }
    }
    if (day > durationInDays!) {
      for (int i = 0; i < day - durationInDays!; i++) {
        goalList!.add(null);
      }
    }
    durationInDays = day;

    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
    notifyListeners(); // Notify listeners when the name is updated
  }

  void addExerciseInDay(int day, String exercise) {
    if (goalList![day] == null) {
      goalList![day] = ExerciseListPerDay();
    }
    goalList![day]!.addExercise(exercise);
    notifyListeners(); // Notify listeners when an exercise is added
  }

  void exerciseComplete(int day, String exercise) {
    goalList![day]!.exerciseList![exercise] = true;
    notifyListeners(); // Notify listeners when an exercise is marked complete
  }
}

class ExerciseListPerDay {
  Map<String?, bool?>? exerciseList;

  ExerciseListPerDay() {
    exerciseList = {};
  }

  void addExercise(String exercise) {
    exerciseList![exercise] = false;
  }
}
