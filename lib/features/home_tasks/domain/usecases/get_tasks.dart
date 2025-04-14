import '../../data/repositories/task_repository_impl.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository = TaskRepositoryImpl();

  GetTasks();

  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}
