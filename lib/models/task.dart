import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_flutter/adapters.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task{
   Task({required this.name, this.isCompleted = false});

  @HiveField(0)
  String name;
  @HiveField(1)
  bool isCompleted;

  Task copyWith({String? name, bool? isCompleted}) {
    return Task(
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}