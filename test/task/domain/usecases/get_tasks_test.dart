import 'package:dash_code/features/home_tasks/domain/usecases/get_tasks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late GetTasks useCase;
  late MockTaskRepository mockRepo;

  setUp(() {
    mockRepo = MockTaskRepository();
    useCase = GetTasks();
  });

  test('should get tasks from repository', () async {
    when(mockRepo.getTasks()).thenAnswer((_) async => []);

    final result = await useCase();

    expect(result, []);
    verify(mockRepo.getTasks());
  });
}
