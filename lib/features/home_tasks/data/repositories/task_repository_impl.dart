import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    final tasksJson = await localDataSource.getTasks();
    return tasksJson.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await getTasks();
    final updatedTasks = [...tasks, TaskModel.fromEntity(task)];
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
    final tasksJson = tasks.map((task) => TaskModel.fromEntity(task).toJson()).toList();
    await localDataSource.saveTasks(tasksJson);
  }
}