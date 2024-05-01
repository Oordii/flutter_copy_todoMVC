import 'package:copy_todo_mvc/components/todo_row.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/bar_index.dart';
import '../models/task.dart';

class TodoItems extends StatelessWidget {
  const TodoItems({super.key});

  Iterable<MapEntry<dynamic, Task>> _getTasksForCurrentBarIndex(
      Map<dynamic, Task> taskEntries, BarIndex barIndex) {
    switch (barIndex) {
      case BarIndex.all:
        return taskEntries.entries;
      case BarIndex.active:
        final entries =
            taskEntries.entries.where((entry) => !entry.value.isCompleted);
        return entries;
      case BarIndex.completed:
        final entries =
            taskEntries.entries.where((entry) => entry.value.isCompleted);
        return entries;
      default:
        return taskEntries.entries;
    }
  }

  @override
  Widget build(BuildContext context) {              
    return (BlocBuilder<TodoListCubit, TodoListState>(
      builder: (context, state) {
        if (state.taskEntries.isNotEmpty) {
          return (Column(
            children: _getTasksForCurrentBarIndex(state.taskEntries, state.barIndex).map((e) => TodoRow(taskEntry: e)).toList(),
          ));
        } else {
          return (Container());
        }
      },
    ));
  }
}
