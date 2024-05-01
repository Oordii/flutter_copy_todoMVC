import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/bar_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBottomBar extends StatelessWidget {
  const TodoBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return (BlocBuilder<TodoListCubit, TodoListState>(
      builder: (context, state) {
        if (state.taskEntries.isNotEmpty) {
          return (Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black12)),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceAround,
              children: [
                Text(
                    "${state.taskEntries.entries.where((entry) => !entry.value.isCompleted).length} items left"),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 45,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              elevation: 3,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              side: state.barIndex == BarIndex.all
                                  ? const BorderSide(color: Colors.red)
                                  : BorderSide.none),
                          onPressed: () {
                            context
                                .read<TodoListCubit>()
                                .setBarItemIndex(BarIndex.all);
                          },
                          child: const Text("All",
                              style: TextStyle(color: Colors.black))),
                    ),
                    SizedBox(
                      width: 65,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              side: state.barIndex == BarIndex.active
                                  ? const BorderSide(color: Colors.red)
                                  : BorderSide.none),
                          onPressed: () {
                            context
                                .read<TodoListCubit>()
                                .setBarItemIndex(BarIndex.active);
                          },
                          child: const Text("Active",
                              style: TextStyle(color: Colors.black))),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            side: state.barIndex == BarIndex.completed
                                ? const BorderSide(color: Colors.red)
                                : BorderSide.none),
                        onPressed: () {
                          context
                              .read<TodoListCubit>()
                              .setBarItemIndex(BarIndex.completed);
                        },
                        child: const Text("Completed",
                            style: TextStyle(color: Colors.black))),
                  ],
                ),
                Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    visible: state.taskEntries.entries
                        .any((entry) => entry.value.isCompleted),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          elevation: 3,
                          shape: const LinearBorder(),
                        ),
                        onPressed: () {
                          context.read<TodoListCubit>().clearCompletedTasks();
                        },
                        child: const Text("Clear completed",
                            style: TextStyle(color: Colors.black))))
              ],
            ),
          ));
        } else {
          return (Container());
        }
      },
    ));
  }
}
