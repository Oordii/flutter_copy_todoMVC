import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'todo_list_state.dart';

class TodoListCubit extends Cubit<TodoListState> {
  final _taskService = TaskService();

  TodoListCubit() : super(TodoListState(taskEntries: <dynamic, Task>{})) {
    _initializeTasks();
  }
  
  void _initializeTasks() {
    emit(TodoListState(taskEntries: _taskService.getTaskEntries()));
  }

  addTask(String taskName) async {
    final newEntryKey = await _taskService.addTask(taskName);
    emit(TodoListState(
        taskEntries: _taskService.getTaskEntries(), barIndex: state.barIndex, editedEntryKey: newEntryKey));
  }

  setEditedEntryKey(dynamic key){
    emit(TodoListState(taskEntries: _taskService.getTaskEntries(), barIndex: state.barIndex, editedEntryKey: key));
  }

  toggleAllTasks() async {
    _taskService.toggleAllTasks();
    emit(TodoListState(
        taskEntries: _taskService.getTaskEntries(), barIndex: state.barIndex));
  }

  Future<void> updateTask(MapEntry<dynamic, Task> entry) async {
    _taskService.updateTask(entry);
    emit(TodoListState(
        taskEntries: _taskService.getTaskEntries(), barIndex: state.barIndex, editedEntryKey: null));
  }

  Future<void> deleteTask(MapEntry<dynamic, Task> entry) async {
    _taskService.deleteTask(entry);
    emit(TodoListState(
        taskEntries: _taskService.getTaskEntries(), barIndex: state.barIndex));
  }

  void setBarItemIndex(BarIndex index) {
    var box = Hive.box<Task>('tasks');
    emit(TodoListState(
        taskEntries: box.toMap(), barIndex: index));
  }

  void clearCompletedTasks() async {
    _taskService.clearCompleted();
    emit(TodoListState(taskEntries: _taskService.getTaskEntries()));
  }
}
