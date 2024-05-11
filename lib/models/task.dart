import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task{
  @HiveType(typeId: 1, adapterName: 'TaskAdapter')
  const factory Task({
    @HiveField(2)
    required int id,
    @HiveField(0)
    required String name,
    @HiveField(1)
    @Default(false)
    bool isCompleted,
  }) = _Task;

 factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}