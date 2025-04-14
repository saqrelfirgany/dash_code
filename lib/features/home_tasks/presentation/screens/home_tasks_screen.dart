import 'package:dash_code/core/dependency_injection/configure_dependencies.dart';
import 'package:dash_code/features/home_tasks/presentation/screens/body/home_app_bar.dart';
import 'package:dash_code/features/home_tasks/presentation/screens/body/home_floating_action_button.dart';
import 'package:dash_code/features/home_tasks/presentation/screens/body/home_task_item.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/firebase/track_button_click.dart';
import '../../domain/entities/task.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';
import 'body/empty_state.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: serviceLocator<TaskCubit>(),
      child: Scaffold(
        floatingActionButton: HomeFloatingActionButton(),
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

            return CustomScrollView(
              slivers: [
                HomeAppBar(),
                if (isLoading)
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (error.isNotEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                if (!isLoading && error.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.warning, color: colorScheme.error),
                        label: Text('Simulate Crash',
                            style: TextStyle(color: colorScheme.error)),
                        onPressed: () {
                          trackButtonClick('Crash app Clicked');
                          FirebaseCrashlytics.instance.crash();
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SearchBar(
                        controller: _searchController,
                        hintText: 'Search tasks...',
                        hintStyle: MaterialStateProperty.all(TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.5))),
                        leading:
                            Icon(Icons.search, color: colorScheme.onSurface),
                        trailing: [
                          if (_isSearchActive)
                            IconButton(
                              icon: Icon(Icons.close,
                                  color: colorScheme.onSurface),
                              onPressed: () {
                                _searchController.clear();
                                cubit.clearSearch();
                                setState(() => _isSearchActive = false);
                              },
                            ),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            cubit.searchTasks(value);
                            setState(() => _isSearchActive = true);
                          }
                        },
                        backgroundColor: MaterialStateProperty.all(
                            colorScheme.surface.withOpacity(0.7)),
                        elevation: MaterialStateProperty.all(2),
                        shape: MaterialStateProperty.all(
                          const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (isSearchEmpty) {
                          return EmptyState(
                            icon: Icons.search_off,
                            message:
                                'No results for "${_searchController.text}"',
                            iconColor: colorScheme.onSurface.withOpacity(0.5),
                          );
                        }
                        if (tasks.isEmpty) {
                          return EmptyState(
                            icon: Icons.task_outlined,
                            message: 'No tasks yet!\nTap + to add a new task',
                            iconColor: colorScheme.onSurface.withOpacity(0.5),
                          );
                        }
                        final task = tasks[index];
                        return HomeTaskItem(task: task);
                      },
                      childCount:
                          isSearchEmpty || tasks.isEmpty ? 1 : tasks.length,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
