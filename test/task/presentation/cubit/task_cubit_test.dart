import 'package:bloc_test/bloc_test.dart';
import 'package:dash_code/features/home_tasks/presentation/cubit/task_cubit.dart';
import 'package:dash_code/features/home_tasks/presentation/cubit/task_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TaskCubit cubit;

  setUp(() {
    cubit = TaskCubit();
  });

  blocTest<TaskCubit, TaskState>(
    'emits [Loading, Loaded] when loading succeeds',
    build: () {
      // when().thenAnswer((_) async => []);
      return cubit;
    },
    act: (cubit) => cubit.loadTasks(),
    expect: () => [
      TaskLoading(),
      TaskLoaded([]),
    ],
  );

  blocTest<TaskCubit, TaskState>(
    'emits error state when loading fails',
    build: () {
      // when().thenThrow(Exception());
      return cubit;
    },
    act: (cubit) => cubit.loadTasks(),
    expect: () => [
      TaskLoading(),
      isA<TaskError>(),
    ],
  );
}
