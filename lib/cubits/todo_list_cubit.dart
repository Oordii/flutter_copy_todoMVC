import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:copy_todo_mvc/services/task_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_state.dart';
part 'todo_list_cubit.freezed.dart';

class TodoListCubit extends Cubit<TodoListState> {
  final TaskService _taskService = getIt.get<TaskService>();

  TodoListCubit() : super(const TodoListState.initial());

  Future<void> init() async {
    emit(const TodoListState.loading());
    try {
      final tasks = await _taskService.getAll();
      emit(TodoListState.success(
          tasks: tasks,
          barIndex: BarIndex.all,
          newTaskId: null));
    } catch (error) {
      emit(TodoListState.error(error.toString()));
    }
  }

  void addTask(String taskName) async {
    // Optimistically update the UI
    final newTask = Task(id: 0, name: taskName, isCompleted: false);
    final currentState = state;
    if (currentState is _Success) {
      emit(currentState.copyWith(
          tasks: List.from(currentState.tasks)..add(newTask),
          newTaskId: null));
    }

    try {
      final newTaskId = await _taskService.addTask(taskName);
      final tasks = await _taskService.getAll();
      emit(TodoListState.success(
          tasks: tasks,
          barIndex: (currentState as _Success).barIndex,
          newTaskId: newTaskId));
    } catch (error) {
      emit(TodoListState.error(error.toString()));
      if (currentState is _Success) {
        emit(currentState);
      }
    }
  }

  void setNewTaskId(int? id) {
    final currentState = state;
    if (currentState is _Success) {
      emit(currentState.copyWith(newTaskId: id));
    }
  }

  void toggleAllTasks() async {
    // Optimistically update the UI
    final currentState = state;
    if (currentState is _Success) {
      final bool anyUncompleted = currentState.tasks.any((task) => !task.isCompleted);
      final updatedTasks = currentState.tasks.map((task) {
        return task.copyWith(isCompleted: anyUncompleted);
      }).toList();
      emit(currentState.copyWith(tasks: updatedTasks));
    }

    try {
      await _taskService.toggleAllTasks();
      final tasks = await _taskService.getAll();
      emit(TodoListState.success(
          tasks: tasks,
          barIndex: (currentState as _Success).barIndex,
          newTaskId: null));
    } catch (error) {
      emit(TodoListState.error(error.toString()));
      if (currentState is _Success) {
        emit(currentState);
      }
    }
  }

  Future<void> updateTask(Task task) async {
    // Optimistically update the UI
    final currentState = state;
    if (currentState is _Success) {
      final updatedTasks = currentState.tasks.map((t) {
        return t.id == task.id ? task : t;
      }).toList();
      emit(currentState.copyWith(tasks: updatedTasks));
    }

    try {
      await _taskService.updateTask(task);
      final tasks = await _taskService.getAll();
      emit(TodoListState.success(
          tasks: tasks,
          barIndex: (currentState as _Success).barIndex,
          newTaskId: null));
    } catch (error) {
      emit(TodoListState.error(error.toString()));
      if (currentState is _Success) {
        emit(currentState);
      }
    }
  }

  Future<void> deleteTask(Task task) async {
    // Optimistically update the UI
    final currentState = state;
    if (currentState is _Success) {
      final updatedTasks = currentState.tasks.where((t) => t.id != task.id).toList();
      emit(currentState.copyWith(tasks: updatedTasks));
    }

    try {
      await _taskService.deleteTask(task);
      final tasks = await _taskService.getAll();
      emit(TodoListState.success(
          tasks: tasks,
          barIndex: (currentState as _Success).barIndex,
          newTaskId: null));
    } catch (error) {
      emit(TodoListState.error(error.toString()));
      if (currentState is _Success) {
        emit(currentState);
      }
    }
  }

  void setBarItemIndex(BarIndex index) async {
    final currentState = state;
    if (currentState is _Success) {
      emit(currentState.copyWith(barIndex: index));
    }
  }

  void clearCompletedTasks() async {
    // Optimistically update the UI
    final currentState = state;
    if (currentState is _Success) {
      final updatedTasks = currentState.tasks.where((t) => !t.isCompleted).toList();
      emit(currentState.copyWith(tasks: updatedTasks));
    }

    try {
      await _taskService.clearCompleted();
      final tasks = await _taskService.getAll();
      emit(TodoListState.success(
          tasks: tasks,
          barIndex: (currentState as _Success).barIndex,
          newTaskId: null));
    } catch (error) {
      emit(TodoListState.error(error.toString()));
      if (currentState is _Success) {
        emit(currentState);
      }
    }
  }
}
