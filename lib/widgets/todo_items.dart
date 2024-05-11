import 'package:copy_todo_mvc/widgets/todo_row.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/bar_index.dart';
import '../models/task.dart';

class TodoItems extends StatelessWidget {
  const TodoItems({super.key});

  Iterable<Task> _getTasksForCurrentBarIndex(
      List<Task> tasks, BarIndex barIndex) {
    switch (barIndex) {
      case BarIndex.all:
        return tasks;
      case BarIndex.active:
        final entries =
            tasks.where((task) => !task.isCompleted);
        return entries;
      case BarIndex.completed:
        final entries =
            tasks.where((task) => task.isCompleted);
        return entries;
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {              
    return (BlocBuilder<TodoListCubit, TodoListState>(
      builder: (context, state) {
        context.read<TodoListCubit>().init();
        return state.when(
          initial: (){
            return Container();
          }, 
          loading: (){
            return const CircularProgressIndicator();
          }, 
          success: (tasks, barIndex, editedTaskId){
            return Column(
              children: _getTasksForCurrentBarIndex(tasks, barIndex).map((e) => TodoRow(task: e)).toList(),
            );
          }, 
          error: (errorMessage){
            return Text(errorMessage);
          });
      },
    ));
  }
}
