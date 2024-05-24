import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:set_your_goal_app/models/Goal_model.dart';

class FileStorage {
  late File _file; // Declare file variable

  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _file = File('${directory.path}/goals.json');
    } catch (e) {
      // Handle error
      print("Error initializing file storage: $e");
    }
  }

  Future<List<Goal>> readGoals() async {
    try {
      if (_file.existsSync()) {
        final content = await _file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((json) => Goal.fromJson(json)).toList();
      }
    } catch (e) {
      // Handle error
      print("Error reading goals: $e");
    }
    return [];
  }

  Future<void> writeGoals(List<Goal> goals) async {
    try {
      final jsonList = goals.map((goal) => goal.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await _file.writeAsString(jsonString);
    } catch (e) {
      // Handle error
      print("Error writing goals: $e");
    }
  }
}
