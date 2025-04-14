import '../../domain/entities/task.dart';


abstract class TaskState {
  final List<Task> tasks;
  final String error;

  const TaskState({
    this.tasks = const [],
    this.error = '',
  });
}

class TaskInitial extends TaskState {
  const TaskInitial() : super();
}

class TaskLoading extends TaskState {
  const TaskLoading() : super();
}

class TaskLoaded extends TaskState {
  const TaskLoaded(List<Task> tasks) : super(tasks: tasks);
}

class TaskError extends TaskState {
  const TaskError(String error) : super(error: error);
}