import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:set_your_goal_app/models/goal_model.dart';
import 'dart:collection';

class Goal extends ChangeNotifier {
  late String id;
  late String? name;
  late int? durationInDays;
  late List<ExerciseListPerDay?>? goalList;

  Goal(this.name, this.durationInDays) : id = Uuid().v4() {
    goalList = List.generate(durationInDays!, (_) => null);
  }

  // Deserialize JSON to Goal object
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      json['name'],
      json['durationInDays'],
    )..id = json['id'] ?? Uuid().v4()
     ..goalList = (json['goalList'] as List<dynamic>)
        .map((dayData) =>
            dayData != null ? ExerciseListPerDay.fromJson(dayData) : null)
        .toList();
  }

  // Serialize Goal object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationInDays': durationInDays,
      'goalList': goalList?.map((day) => day?.toJson()).toList(),
    };
  }

  // Update duration and days
  void updateDurationAndDays(int day) {
    if (day == durationInDays) return;
    
    if (day < durationInDays!) {
      goalList!.removeRange(day, durationInDays!);
    } else {
      goalList!.addAll(List.generate(day - durationInDays!, (_) => null));
    }
    durationInDays = day;
    notifyListeners();
  }

  // Add exercise to a specific day
  void addExerciseInDay(int day, String exercise) {
    if (goalList![day] == null) {
      goalList![day] = ExerciseListPerDay();
    }
    goalList![day]!.addExercise(exercise);
    notifyListeners();
  }
}

class ExerciseListPerDay {
  late Map<String?, bool?> exerciseList;

  ExerciseListPerDay() {
    exerciseList = {};
  }

  // Deserialize JSON to ExerciseListPerDay object
  factory ExerciseListPerDay.fromJson(Map<String, dynamic> json) {
    return ExerciseListPerDay()
      ..exerciseList = Map<String?, bool?>.from(json['exerciseList']);
  }

  // Serialize ExerciseListPerDay object to JSON
  Map<String, dynamic> toJson() {
    return {
      'exerciseList': exerciseList,
    };
  }

  // Add exercise to the list
  void addExercise(String exercise) {
    exerciseList[exercise] = false;
  }
}