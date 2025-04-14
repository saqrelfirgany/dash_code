import 'dart:convert';

import 'package:dash_code/features/home_tasks/data/data_sources/local_data_source.dart';
import 'package:dash_code/features/home_tasks/data/models/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LocalTaskSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = LocalTaskSourceImpl();
  });

  test('should return empty list when no tasks stored', () async {
    when(mockPrefs.getStringList('any')).thenReturn(null);

    final result = await dataSource.getTasks();

    expect(result, isEmpty);
  });

  test('should return tasks when present', () async {
    final taskJson = TaskModel(
      id: '1',
      title: 'Test',
      isCompleted: false,
      created: DateTime.now(),
    ).toJson();

    when(mockPrefs.getStringList('any'))
        .thenReturn([jsonEncode(taskJson)]);

    final result = await dataSource.getTasks();

    expect(result.first.id, '1');
  });

  test('should save tasks correctly', () async {
    final tasks = [TaskModel(
      id: '1',
      title: 'Test',
      isCompleted: false,
      created: DateTime.now(),
    )];

    await dataSource.saveTasks(tasks.map((t) => t.toJson()).toList());

    verify(mockPrefs.setStringList(
      'any',
      [jsonEncode(tasks.first.toJson())],
    )).called(1);
  });
}