import 'dart:developer';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskSource localDataSource = LocalTaskSourceImpl();

  TaskRepositoryImpl();

  @override
  Future<List<Task>> getTasks() async {
    final tasksList = await localDataSource.getTasks();
    return tasksList.toEntities();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    final updatedTasks = [...tasks, task];
    await _saveTasks(updatedTasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    final updatedTasks = List<Task>.from(tasks)..[index] = task;
    await _saveTasks(updatedTasks);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();
    await _saveTasks(updatedTasks);
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final tasksJson = tasks.toModels().map((model) => model.toJson()).toList();
    await localDataSource.saveTasks(tasksJson);
  }
}
