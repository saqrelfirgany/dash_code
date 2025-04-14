import 'package:dash_code/features/home_tasks/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var tTask = Task(
    id: '1',
    title: 'Test',
    isCompleted: false,
    created: DateTime(2023),
  );

  test('should create valid copy', () {
    final copy = tTask.copyWith(isCompleted: true);

    expect(copy.isCompleted, true);
    expect(copy.title, tTask.title);
  });

  test('should properly convert to/from map', () {
    final map = tTask.toMap();
    final fromMap = Task.fromMap(map);

    expect(fromMap, tTask);
  });
}