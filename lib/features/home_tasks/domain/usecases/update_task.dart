import '../../data/repositories/task_repository_impl.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository = TaskRepositoryImpl();

  UpdateTask();

  Future<void> call(Task task) => repository.updateTask(task);
}