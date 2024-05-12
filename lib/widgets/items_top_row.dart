import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemsTopRow extends StatelessWidget {
  const ItemsTopRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<TodoListCubit, TodoListState>(
          builder: (context, state) {
            final isEmpty =
                state.maybeWhen(success: (taskEntries, barIndex, editedTaskId) {
              return taskEntries.isEmpty;
            }, orElse: () {
              return true;
            });
            return (IconButton(
              disabledColor: Theme.of(context).disabledColor,
              iconSize: 24,
              visualDensity: VisualDensity.compact,
              style: ButtonStyle(
                side: MaterialStatePropertyAll<BorderSide>(
                  BorderSide(
                      width: 2,
                      color: isEmpty
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).hintColor),
                ),
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                    CircleBorder()),
              ),
              icon: Icon(Icons.done_all,
                  color: isEmpty ? Theme.of(context).disabledColor : null),
              selectedIcon: Icon(Icons.remove_done,
                  color: isEmpty ? Theme.of(context).disabledColor : null),
              isSelected: state.maybeWhen(
                  success: (taskEntries, barIndex, editedTaskId) {
                return !taskEntries.any((element) => !element.isCompleted);
              }, orElse: () {
                return false;
              }),
              onPressed: isEmpty
                  ? null
                  : () => context.read<TodoListCubit>().toggleAllTasks(),
            ));
          },
        ),
        Text(
          "title".tr(context: context),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        BlocBuilder<TodoListCubit, TodoListState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "left".tr(args: [
                state.maybeWhen(success: (tasks, barIndex, editedTaskId) {
                  return tasks.where((element) => !element.isCompleted).length;
                }, orElse: () {
                  return 0;
                }).toString()
              ]),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        })
      ],
    );
  }
}
