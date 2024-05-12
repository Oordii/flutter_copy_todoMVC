import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_state.dart';
part 'todo_list_cubit.freezed.dart';

class TodoListCubit extends Cubit<TodoListState> {
  TodoListCubit() : super(const TodoListState.initial());

  final _taskService = TaskService();

  void init() {
    emit(const TodoListState.loading());

    List<Task> tasks = <Task>[];
    try{
      tasks = _taskService.getAll();
    } catch (error){
      emit(TodoListState.error(error.toString()));
    }

    emit(TodoListState.success(
        tasks: tasks,
        barIndex: BarIndex.all,
        editedTaskId: null));
  }

  addTask(String taskName) async {
    final newEntryKey = await _taskService.addTask(taskName);
    emit(TodoListState.success(
        tasks: _taskService.getAll(),
        barIndex:
            state.maybeWhen(success: (taskEntries, barIndex, editedTaskId) {
          return barIndex;
        }, orElse: () {
          return BarIndex.all;
        }),
        editedTaskId: newEntryKey));
  }

  setEditedEntryKey(int key) {
    emit(TodoListState.success(
        tasks: _taskService.getAll(),
        barIndex:
            state.maybeWhen(success: (taskEntries, barIndex, editedTaskId) {
          return barIndex;
        }, orElse: () {
          return BarIndex.all;
        }),
        editedTaskId: key));
  }

  toggleAllTasks() async {
    _taskService.toggleAllTasks();
    emit(TodoListState.success(
        tasks: _taskService.getAll(),
        barIndex: state.maybeWhen(success: (taskEntries, barIndex, editedTaskId) {
          return barIndex;
        }, orElse: (){return BarIndex.all;}),));
  }

  Future<void> updateTask(Task task) async {
    _taskService.updateTask(task);
    emit(TodoListState.success(
        tasks: _taskService.getAll(),
        barIndex: state.maybeWhen(success: (taskEntries, barIndex, editedTaskId) {
          return barIndex;
        }, orElse: (){return BarIndex.all;}),
        editedTaskId: null));
  }

  Future<void> deleteTask(Task task) async {
    _taskService.deleteTask(task);
    emit(TodoListState.success(
        tasks: _taskService.getAll(),
        barIndex:state.maybeWhen(success: (taskEntries, barIndex, editedTaskId) {
          return barIndex;
        }, orElse: (){return BarIndex.all;})));
  }

  void setBarItemIndex(BarIndex index) {
    emit(TodoListState.success(tasks: _taskService.getAll(), barIndex: index));
  }

  void clearCompletedTasks() async {
    _taskService.clearCompleted();
    emit(TodoListState.success(tasks: _taskService.getAll()));
  }
}
