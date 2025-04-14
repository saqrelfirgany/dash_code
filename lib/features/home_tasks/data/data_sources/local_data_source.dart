import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

abstract class LocalTaskSource {
  Future<List<TaskModel>> getTasks();

  Future<void> saveTasks(List<Map<String, dynamic>> tasksJson);
}

class LocalTaskSourceImpl implements LocalTaskSource {
  static const String _tasksKey = 'tasks_key';

  LocalTaskSourceImpl();

  @override
  Future<List<TaskModel>> getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final taskStrings = prefs.getStringList(_tasksKey) ?? [];
    return taskStrings
        .map((str) => TaskModel.fromJson(json.decode(str)))
        .toList();
  }

  @override
  Future<void> saveTasks(List<Map<String, dynamic>> tasksJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final taskStrings = tasksJson.map((json) => jsonEncode(json)).toList();
    await prefs.setStringList(_tasksKey, taskStrings);
  }
}
