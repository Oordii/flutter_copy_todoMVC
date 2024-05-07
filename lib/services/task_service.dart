
import 'package:copy_todo_mvc/models/task.dart';
import 'package:hive/hive.dart';

class TaskService {
  TaskService();

  final _box = Hive.box<Task>('tasks');

  Map<dynamic, Task> getTaskEntries() {
    return _box.toMap();
  }

  Future<int> addTask(String taskName) async {
    final task = Task(name: taskName, isCompleted: false);
    return await _box.add(task);
  }

  void toggleAllTasks() async {
    if (_box.values.any((element) => !element.isCompleted)) {
      _box.toMap().forEach((key, value) async {
        value.isCompleted = true;
        await _box.put(key, value);
      });
    } else {
      _box.toMap().forEach((key, value) async {
        value.isCompleted = false;
        await _box.put(key, value);
      });
    }
  }

  void updateTask(MapEntry<dynamic, Task> entry) async {
    await _box.put(entry.key, entry.value);
  }

  void deleteTask(MapEntry<dynamic, Task> entry) async {
    await _box.delete(entry.key);
  }

  void clearCompleted() async {
    _box.toMap().forEach((key, value) async {
      if (value.isCompleted) {
        await _box.delete(key);
      }
    });
  }
}