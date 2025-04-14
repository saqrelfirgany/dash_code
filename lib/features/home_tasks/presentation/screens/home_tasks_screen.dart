import 'package:dash_code/core/dependency_injection/configure_dependencies.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/firebase/track_button_click.dart';
import '../../../settings_feature/presentation/settings_screen.dart';
import '../../domain/entities/task.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<TaskCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Manager'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showAddTaskDialog(context),
        ),
        body: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is TaskError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final cubit = serviceLocator<TaskCubit>();
            List<Task> tasks = [];
            bool isLoading = false;
            String error = '';
            bool isSearchEmpty = false;

            if (state is TaskLoading) {
              isLoading = true;
            } else if (state is TaskError) {
              error = state.error;
            } else if (state is TaskLoaded) {
              tasks = state.tasks;
              isSearchEmpty = _isSearchActive && tasks.isEmpty;
            }

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (error.isNotEmpty) {
              return Center(child: Text(error));
            }

            return Column(
              children: [
                TextButton(
                  onPressed: () {
                    trackButtonClick('Crash app Clicked');
                    FirebaseCrashlytics.instance.crash();
                  },
                  child: const Text('Crash app'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search tasks',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (_searchController.text.isNotEmpty) {
                            cubit.searchTasks(_searchController.text);
                            setState(() => _isSearchActive = true);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          cubit.clearSearch();
                          setState(() => _isSearchActive = false);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isSearchEmpty
                      ? Center(
                          child: Text(
                            'No results for "${_searchController.text}"',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : tasks.isEmpty
                          ? const Center(child: Text('No tasks yet!'))
                          : ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return Dismissible(
                                  key: Key(task.id),
                                  background: Container(color: Colors.red),
                                  confirmDismiss: (_) async {
                                    _confirmDeleteTask(context, task.id);
                                    return false;
                                  },
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: task.isCompleted,
                                      onChanged: (_) =>
                                          cubit.toggleComplete(task),
                                    ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        decoration: task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _showEditTaskDialog(
                                              context, task),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _confirmDeleteTask(
                                              context, task.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, String taskId) {
    trackButtonClick('confirmDeleteTask');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              serviceLocator<TaskCubit>().deleteTask(taskId);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    trackButtonClick('showAddTaskDialog');
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                serviceLocator<TaskCubit>().addTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    trackButtonClick('showEditTaskDialog');
    final controller = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final updatedTask = task.copyWith(title: controller.text);
                serviceLocator<TaskCubit>().updateTask(updatedTask);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
