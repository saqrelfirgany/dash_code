import 'package:flutter/material.dart';

import '../../../../../core/dependency_injection/configure_dependencies.dart';
import '../../../../../core/firebase/track_button_click.dart';
import '../../../domain/entities/task.dart';
import '../../cubit/task_cubit.dart';

class HomeTaskItem extends StatelessWidget {
  const HomeTaskItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = serviceLocator<TaskCubit>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => cubit.toggleComplete(task),
            shape: const CircleBorder(),
            splashRadius: 20,
            fillColor: MaterialStateProperty.all(colorScheme.primary),
          ),
          title: Text(
            task.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted
                      ? colorScheme.onSurface.withOpacity(0.5)
                      : colorScheme.onSurface,
                ),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: colorScheme.primary),
                  onPressed: () => _showEditTaskDialog(context, task),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  onPressed: () => _confirmDeleteTask(context, task.id),
                ),
              ],
            ),
          ),
        ),
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
}
