import '../entities/task.dart';

class SearchTasks {
  Future<List<Task>> call(String query, List<Task> tasks) async {
    return tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
