import 'package:uuid/uuid.dart';

import '../../data/models/task_model.dart';

class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime created;

  Task({
    String? id,
    required this.title,
    this.isCompleted = false,
    DateTime? created,
  })  : id = id ?? const Uuid().v4(),
        created = created ?? DateTime.now();

  Task copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      created: created,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'created': created.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'],
      created: DateTime.parse(map['created']),
    );
  }
}

extension TaskX on Task {
  TaskModel toModel() => TaskModel(
        id: id,
        title: title,
        isCompleted: isCompleted,
        created: created,
      );
}

extension TaskListX on List<Task> {
  List<TaskModel> toModels() => map((entity) => entity.toModel()).toList();
}
