class TaskCubit extends Cubit<TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTask;

  TaskCubit({
    required this.getTasks,
    required this.addTask,
    required this.updateTaskUseCase,
    required this.deleteTask,
  }) : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    final result = await getTasks();
    emit(TaskLoaded(result));
  }

  Future<void> createTask(String title) async {
    final task = Task(title: title);
    await addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await updateTaskUseCase(task);
    await loadTasks();
  }

  Future<void> removeTask(String taskId) async {
    await deleteTask(taskId);
    await loadTasks();
  }
}