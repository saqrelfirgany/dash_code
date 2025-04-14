import 'package:flutter/material.dart';

import '../../../../../core/dependency_injection/configure_dependencies.dart';
import '../../../../../core/firebase/track_button_click.dart';
import '../../cubit/task_cubit.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton.extended(
      icon: Icon(Icons.add, color: colorScheme.onPrimary),
      label: Text('Add Task', style: TextStyle(color: colorScheme.onPrimary)),
      backgroundColor: colorScheme.primary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.onPrimary.withOpacity(0.2),
          width: 1,
        ),
      ),
      onPressed: () => _showAddTaskDialog(context),
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
}
