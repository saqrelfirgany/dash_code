import '../../data/repositories/task_repository_impl.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository = TaskRepositoryImpl();

  AddTask();

  Future<void> call(Task task) => repository.addTask(task);
}
