import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.isCompleted,
    required super.created,
  });

  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        isCompleted: task.isCompleted,
        created: task.created,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'created': created.toIso8601String(),
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        created: DateTime.parse(json['created']),
      );
}

extension TaskModelX on TaskModel {
  Task toEntity() => Task(
        id: id,
        title: title,
        isCompleted: isCompleted,
        created: created,
      );
}

extension TaskModelListX on List<TaskModel> {
  List<Task> toEntities() => map((model) => model.toEntity()).toList();
}
