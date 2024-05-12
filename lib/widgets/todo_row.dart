import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/app_color.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoRow extends StatefulWidget {
  const TodoRow({super.key, required this.task});

  final Task task;

  @override
  State<TodoRow> createState() => TodoRowState();
}

class TodoRowState extends State<TodoRow> {
  late FocusNode focusNode;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _textEditingController = TextEditingController();

    focusNode.addListener(() {
      Future.delayed(Duration.zero, () {
        if (!focusNode.hasPrimaryFocus) {
          _submitText();
        }
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _submitText() {
    final updatedTask = widget.task.copyWith(name: _textEditingController.text);
    context.read<TodoListCubit>().updateTask(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.name;

    return (BlocBuilder<TodoListCubit, TodoListState>(
        builder: (context, state) {
      var isEditing = widget.task.id ==
          state.maybeWhen(
              success: (tasks, barIndex, editedTaskId) {
                return editedTaskId;
              },
              orElse: () => null);

      if (isEditing) {
        Future.delayed(Duration.zero, () {
          focusNode.requestFocus();
        });
      }

      return Card(
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: (Row(
          children: [
            Checkbox(
              splashRadius: 15,
              value: widget.task.isCompleted,
              onChanged: (value) {
                context.read<TodoListCubit>().updateTask(
                    widget.task.copyWith(isCompleted: value ?? false));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                focusNode: focusNode,
                controller: _textEditingController,
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onSubmitted: (value) {
                  _submitText();
                },
                enabled: isEditing,
                style: Theme.of(context).textTheme.bodySmall!.merge(TextStyle(
                    color: widget.task.isCompleted
                        ? Theme.of(context).dividerColor
                        : null,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none)),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'todo_hint'.tr(),
                    hintStyle: Theme.of(context).textTheme.labelSmall),
              ),
            ),
            Row(
              children: [
                if (isEditing) ...{
                  const IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: null,
                      icon: Icon(Icons.done)),
                } else ...{
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context
                            .read<TodoListCubit>()
                            .setEditedEntryKey(widget.task.id);
                      },
                      icon: const Icon(Icons.edit)),
                },
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    context.read<TodoListCubit>().deleteTask(widget.task);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: AppColor.titleRed,
                  ),
                ),
              ],
            )
          ],
        )),
      );
    }));
  }
}
