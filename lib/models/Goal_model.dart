import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Goal extends ChangeNotifier {
  late String id;
  late String? name;
  late int? durationInDays;
  late DateTime startDate; // Added field for Start Date
  late List<ExerciseListPerDay?>? goalList;

  Goal(this.name, this.durationInDays, this.startDate) : id = Uuid().v4() {
    goalList = List.generate(durationInDays!, (_) => null);
  }

  // Deserialize JSON to Goal object
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      json['name'],
      json['durationInDays'],
      DateTime.parse(json['startDate']), // Updated line to parse start date
    )
      ..id = json['id'] ?? Uuid().v4()
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
      'startDate':
          startDate.toIso8601String(), // Updated line to format start date
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

  // Get the formatted date range for the goal
  String getDateRange() {
    DateTime endDate = startDate.add(Duration(days: durationInDays! - 1));
    String startDateStr =
        "${startDate.day}/${startDate.month}/${startDate.year}";
    String endDateStr = "${endDate.day}/${endDate.month}/${endDate.year}";
    return "$startDateStr​ --> $endDateStr";
  }

  String getStartDate() {
    String startDateStr =
        "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}/${startDate.year}";
    return startDateStr;
  }

  String getEndDate() {
    DateTime endDate = startDate.add(Duration(days: durationInDays! - 1));
    String endDateStr =
        "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}";
    return endDateStr;
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
