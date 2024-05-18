import 'package:flutter/material.dart';

class Goal extends ChangeNotifier {
  String? name;
  int? durationInDays;
  List<ExerciseListPerDay?>? goalList;

  Goal(this.name, this.durationInDays) {
    goalList = List<ExerciseListPerDay?>.filled(durationInDays!, null);
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
