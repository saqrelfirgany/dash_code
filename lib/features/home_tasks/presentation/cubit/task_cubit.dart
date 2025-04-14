import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/search_tasks.dart';
import '../../domain/usecases/update_task.dart';
import 'task_state.dart';

@lazySingleton
class TaskCubit extends Cubit<TaskState> {
  final GetTasks _getTasks = GetTasks();
  final AddTask _addTask = AddTask();
  final UpdateTask _updateTask = UpdateTask();
  final DeleteTask _deleteTask = DeleteTask();
  final SearchTasks _searchTasks = SearchTasks();

  List<Task> _allTasks = [];
  String _currentSearchQuery = '';

  TaskCubit() : super(TaskInitial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(TaskLoading());
    try {
      _allTasks = await _getTasks();
      _applySearchFilter();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(String title) async {
    try {
      final newTask = Task(title: title);
      await _addTask(newTask);
      await _refreshTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      await _updateTask(updatedTask);
      await _refreshTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _deleteTask(taskId);
      await _refreshTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> toggleComplete(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _updateTask(updatedTask);
      await _refreshTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void searchTasks(String query) {
    _currentSearchQuery = query;
    _applySearchFilter();
  }

  void clearSearch() {
    _currentSearchQuery = '';
    _applySearchFilter();
  }

  Future<void> _refreshTasks() async {
    try {
      _allTasks = await _getTasks();
      _applySearchFilter();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _applySearchFilter() async {
    if (_currentSearchQuery.isEmpty) {
      emit(TaskLoaded(_allTasks));
      return;
    }

    final filtered = await _searchTasks(_currentSearchQuery, _allTasks);
    emit(TaskLoaded(filtered));
  }
}
