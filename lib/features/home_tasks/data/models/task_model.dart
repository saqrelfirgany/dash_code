import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.isCompleted,
    required super.createdAt,
  });

  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        isCompleted: json['isCompleted'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
