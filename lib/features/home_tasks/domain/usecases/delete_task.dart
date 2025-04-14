import '../../data/repositories/task_repository_impl.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository = TaskRepositoryImpl();

  DeleteTask();

  Future<void> call(String taskId) => repository.deleteTask(taskId);
}
