
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/repositories/abstract_repository.dart';

class TaskService {
  final Repository _repository;
  TaskService():_repository = getIt.get<Repository>();

  List<Task> getAll() {
    return _repository.getAllTasks();
  }

  Future<int> addTask(String taskName) async {
    final tasks = _repository.getAllTasks();
    int id = 0;
    if (tasks.isEmpty){
      id = 1;
    } else {
      id = tasks.last.id + 1;
    }
    final task = Task(id: id, name: taskName, isCompleted: false);
    await _repository.addTask(task);
    return task.id;
  }

  void toggleAllTasks() async {
    final tasks = _repository.getAllTasks();
    final bool anyUncompleted = tasks.any((task) => !task.isCompleted);
    for (var task in tasks) {
      _repository.updateTask(task.copyWith(isCompleted: anyUncompleted));
    }
  }

  void updateTask(Task task) async {
    await _repository.updateTask(task);
  }

  void deleteTask(Task task) async {
    await _repository.deleteTask(task);
  }

  void clearCompleted() async {
    final tasks = _repository.getAllTasks();
    for (final task in tasks){
      if(task.isCompleted){
        _repository.deleteTask(task);
      }
    }
  }
}