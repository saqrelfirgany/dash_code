// test/mocks.dart
import 'package:dash_code/features/home_tasks/data/data_sources/local_data_source.dart';
import 'package:dash_code/features/home_tasks/domain/repositories/task_repository.dart';
import 'package:dash_code/features/home_tasks/presentation/cubit/task_cubit.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  LocalTaskSource,
  TaskRepository,
], customMocks: [
  MockSpec<TaskCubit>(as: #MockTaskCubit),
])
void main() {}
