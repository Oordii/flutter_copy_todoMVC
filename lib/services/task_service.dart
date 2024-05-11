
import 'package:copy_todo_mvc/models/task.dart';
import 'package:hive/hive.dart';

class TaskService {
  TaskService();

  final _box = Hive.box<Task>('tasks');

  List<Task> getAll() {
    return _box.values.toList();
  }

  Future<int> addTask(String taskName) async {
    int id = 0;
    if (_box.isEmpty){
      id = 1;
    } else {
      id = _box.values.last.id + 1;
    }
    final task = Task(id: id, name: taskName, isCompleted: false);
    await _box.put(task.id, task);
    return task.id;
  }

  void toggleAllTasks() async {
    if (_box.values.any((element) => !element.isCompleted)) {
      _box.toMap().forEach((key, value) async {
        await _box.put(key, value.copyWith(isCompleted: true));
      });
    } else {
      _box.toMap().forEach((key, value) async {
        await _box.put(key, value.copyWith(isCompleted: false));
      });
    }
  }

  void updateTask(Task task) async {
    await _box.put(task.id, task);
  }

  void deleteTask(Task task) async {
    await _box.delete(task.id);
  }

  void clearCompleted() async {
    _box.toMap().forEach((key, value) async {
      if (value.isCompleted) {
        await _box.delete(key);
      }
    });
  }
}