import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

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
