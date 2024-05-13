import 'package:copy_todo_mvc/widgets/todo_row.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoItems extends StatelessWidget {
  const TodoItems({super.key});

  Iterable<Task> _getTasksForCurrentBarIndex(
      List<Task> tasks, BarIndex barIndex) {
    switch (barIndex) {
      case BarIndex.all:
        return tasks;
      case BarIndex.active:
        final entries = tasks.where((task) => !task.isCompleted);
        return entries;
      case BarIndex.completed:
        final entries = tasks.where((task) => task.isCompleted);
        return entries;
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodoListCubit>().state;
    state.maybeWhen(
        initial: () {
          context.read<TodoListCubit>().init();
        },
        orElse: () {});

    return state.when(initial: () {
      return Container();
    }, loading: () {
      return const Center(child: CircularProgressIndicator());
    }, success: (tasks, barIndex, editedTaskId) {
      return Column(
        children: _getTasksForCurrentBarIndex(tasks, barIndex)
            .map((e) => TodoRow(task: e))
            .toList(),
      );
    }, error: (errorMessage) {
      return Text(errorMessage);
    });
  }
}
