import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:set_your_goal_app/models/Goal_model.dart';

class FileStorage {
  late File _goalsFile;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    _goalsFile = File('$path/goals.json');
    if (!_goalsFile.existsSync()) {
      await _goalsFile.create();
    }
  }

  Future<List<Goal>> readGoals() async {
    try {
      final jsonContent = await _goalsFile.readAsString();
      final List<dynamic> jsonList = json.decode(jsonContent);
      return jsonList.map((item) => Goal.fromJson(item)).toList();
    } catch (e) {
      print("Error reading goals: $e");
      return [];
    }
  }

  Future<void> writeGoals(List<Goal> goals) async {
    final jsonString = json.encode(goals.map((goal) => goal.toJson()).toList());
    await _goalsFile.writeAsString(jsonString);
  }
}
