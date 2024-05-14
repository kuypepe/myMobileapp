class Goal {
  String? name;
  int? durationInDays;
  List<ExerciseListPerDay?>? goalList;

  Goal(String name, int durationInDays) {
    this.name = name;
    this.durationInDays = durationInDays;
    goalList = List<ExerciseListPerDay?>.filled(durationInDays, null);
  }

  void addExerciseInDay(int day, String exercise) {
    if (goalList![day] == null) {
      goalList![day] = ExerciseListPerDay();
    }
    goalList![day]!.addExercise(exercise);
  }

  void exerciseComplete(int day, String exercise) {
    goalList![day]!.exerciseList![exercise] = true;
  }

  void printExercise() {
    print("$name:");
    for (int i = 0; i < goalList!.length; i++) {
      print("\tDay ${i + 1}:");
      if (goalList![i] == null || goalList![i]!.exerciseList!.isEmpty) {
        print("\t\tRest day");
        continue;
      }
      goalList![i]!.exerciseList!.forEach((key, value) {
        print('\t\t$key: $value');
      });
    }
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

// void main() {
//   Goal myNewGoal = Goal("Nithik goal", 15);
//   myNewGoal.addExerciseInDay(0, "14 Jumping jacks");
//   myNewGoal.addExerciseInDay(0, "15 Side jacks");
//   myNewGoal.addExerciseInDay(0, "20 Jimmy jacks");
//   myNewGoal.addExerciseInDay(1, "30 Push ups");
//   myNewGoal.exerciseComplete(0, "14 Jumping jacks");
//   myNewGoal.printExercise();
// }