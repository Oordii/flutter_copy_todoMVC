import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(TodoListState(taskEntries: <dynamic, Task>{})) {
    _initializeTasks();
  }

  void _initializeTasks() async {
    var box = Hive.box<Task>('tasks');
    emit(TodoListState(taskEntries: box.toMap()));
  }

  addTask(String taskName) async {
    Task task;
    var box = Hive.box<Task>('tasks');
    
    task = Task(name: taskName, isCompleted: false);

    await box.add(task);

    emit(TodoListState(
        taskEntries: box.toMap(), barIndex: state.barIndex, editedEntryKey: box.keys.last));
  }

  setEditedEntryKey(dynamic key){
    var box = Hive.box<Task>('tasks');

    emit(TodoListState(taskEntries: box.toMap(), barIndex: state.barIndex, editedEntryKey: key));
  }

  toggleAllTasks() async {
    var box = Hive.box<Task>('tasks');
    if (box.values.any((element) => !element.isCompleted)) {
      box.toMap().forEach((key, value) async {
        value.isCompleted = true;
        await box.put(key, value);
      });
    } else {
      box.toMap().forEach((key, value) async {
        value.isCompleted = false;
        await box.put(key, value);
      });
    }

    emit(TodoListState(
        taskEntries: box.toMap(), barIndex: state.barIndex));
  }

  Future<void> updateTask(MapEntry<dynamic, Task> entry) async {
    var box = Hive.box<Task>('tasks');
    await box.put(entry.key, entry.value);
    emit(TodoListState(
        taskEntries: box.toMap(), barIndex: state.barIndex));
  }

  Future<void> deleteTask(MapEntry<dynamic, Task> entry) async {
    var box = Hive.box<Task>('tasks');
    await box.delete(entry.key);
    emit(TodoListState(
        taskEntries: box.toMap(), barIndex: state.barIndex));
  }

  void setBarItemIndex(BarIndex index) {
    var box = Hive.box<Task>('tasks');
    emit(TodoListState(
        taskEntries: box.toMap(), barIndex: index));
  }

  void clearCompletedTasks() async {
    var box = Hive.box<Task>('tasks');
    box.toMap().forEach((key, value) async {
      if (value.isCompleted) {
        await box.delete(key);
      }
    });
    emit(TodoListState(taskEntries: box.toMap()));
  }
}
