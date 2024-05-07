import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBar extends StatelessWidget {
  const TodoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return (BlocBuilder<TodoListCubit, TodoListState>(
      builder: (context, state) {
          return (Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(

                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: state.barIndex == BarIndex.all
                              ? const BorderSide(color: Colors.red)
                              : BorderSide.none),
                      onPressed: state.taskEntries.isEmpty ? null : () {
                        context
                            .read<TodoListCubit>()
                            .setBarItemIndex(BarIndex.all);
                      },
                      child: Text("bottombar_all".tr(context: context))),
                  TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: state.barIndex == BarIndex.active
                              ? const BorderSide(color: Colors.red)
                              : BorderSide.none),
                      onPressed: state.taskEntries.isEmpty ? null : () {
                        context
                            .read<TodoListCubit>()
                            .setBarItemIndex(BarIndex.active);
                      },
                      child: Text("bottombar_active".tr())),
                  TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: state.barIndex == BarIndex.completed
                              ? const BorderSide(color: Colors.red)
                              : BorderSide.none),
                      onPressed: state.taskEntries.isEmpty ? null : () {
                        context
                            .read<TodoListCubit>()
                            .setBarItemIndex(BarIndex.completed);
                      },
                      child: Text("bottombar_complete".tr())),
                ],
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    elevation: 3,
                    shape: const LinearBorder(),
                  ),
                  onPressed: state.taskEntries.values.where((element) => element.isCompleted).isEmpty ? null : () {
                    context.read<TodoListCubit>().clearCompletedTasks();
                  },
                  child: Text("bottombar_clear".tr()))
            ],
          ));
      },
    ));
  }
}
