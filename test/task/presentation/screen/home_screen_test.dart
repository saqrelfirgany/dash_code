import 'package:dash_code/features/home_tasks/presentation/cubit/task_cubit.dart';
import 'package:dash_code/features/home_tasks/presentation/cubit/task_state.dart';
import 'package:dash_code/features/home_tasks/presentation/screens/home_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTaskCubit extends Mock implements TaskCubit {}

void main() {
  late MockTaskCubit mockCubit;

  setUp(() {
    mockCubit = MockTaskCubit();
  });

  testWidgets('shows loading indicator', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(TaskLoading() as TaskState Function());

    await tester.pumpWidget(
      BlocProvider.value(
        value: mockCubit,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays error message', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(TaskError('Test Error') as TaskState Function());

    await tester.pumpWidget(
      BlocProvider.value(
        value: mockCubit,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Test Error'), findsOneWidget);
  });

  testWidgets('shows empty state', (tester) async {
    when(() => mockCubit.state)
        .thenReturn(TaskLoaded([]) as TaskState Function());

    await tester.pumpWidget(BlocProvider.value(
      value: mockCubit,
      child: const MaterialApp(home: HomeScreen()),
    ));

    expect(find.text('No tasks yet!'), findsOneWidget);
  });
}
