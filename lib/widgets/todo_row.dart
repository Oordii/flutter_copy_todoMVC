import 'package:copy_todo_mvc/cubits/editing_cubit.dart';
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
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.name;
    final state = context.watch<EditingCubit>().state;
    bool isEditing = state.maybeWhen(
        editing: (editedTaskId) {
          return widget.task.id == editedTaskId;
        },
        orElse: () => false);

    if (isEditing) {
      // FocusManager.instance.primaryFocus?.unfocus();
      Future.delayed(Duration.zero, () {
        focusNode.requestFocus();
      });
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: Row(
        children: [
          Checkbox(
            splashRadius: 15,
            value: widget.task.isCompleted,
            onChanged: (value) {
              context.read<TodoListCubit>().updateTask(
                  widget.task.copyWith(isCompleted: value ?? false));
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          Expanded(
            child: !isEditing
                ? Text(
                    widget.task.name.isNotEmpty
                        ? widget.task.name
                        : 'todo_hint'.tr(),
                    style: widget.task.name.isEmpty
                        ? Theme.of(context).textTheme.labelSmall
                        : Theme.of(context).textTheme.bodySmall!.merge(
                            TextStyle(
                                color: widget.task.isCompleted
                                    ? Theme.of(context).dividerColor
                                    : null,
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none)),
                  )
                : TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    focusNode: focusNode,
                    controller: _textEditingController,
                    onTapOutside: (PointerDownEvent event) async {
                      context.read<EditingCubit>().setEditedTaskId(null);
                      await context.read<TodoListCubit>().updateTask(widget.task
                          .copyWith(name: _textEditingController.text));
                    },
                    enabled: isEditing,
                    style: Theme.of(context).textTheme.bodySmall!.merge(
                        TextStyle(
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
              Visibility(
                visible: !isEditing,
                child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      if (context.mounted) {
                        Future.delayed(const Duration(milliseconds: 40), () {
                          context
                              .read<EditingCubit>()
                              .setEditedTaskId(widget.task.id);
                        });
                      }
                    },
                    icon: const Icon(Icons.edit)),
              ),
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
      ),
    );
  }
}
