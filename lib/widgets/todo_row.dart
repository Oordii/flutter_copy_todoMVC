import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoRow extends StatefulWidget {
  const TodoRow({super.key, required this.taskEntry});

  final MapEntry<dynamic, Task> taskEntry;

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
    widget.taskEntry.value.name = _textEditingController.text;
    context.read<TodoListCubit>().updateTask(widget.taskEntry);
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.taskEntry.value.name;

    return (BlocBuilder<TodoListCubit, TodoListState>(
        builder: (context, state) {

      var isEditing = widget.taskEntry.key == state.editedEntryKey;

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
              activeColor: Colors.green,
              value: widget.taskEntry.value.isCompleted,
              onChanged: (value) {
                widget.taskEntry.value.isCompleted = value ?? false;
                context.read<TodoListCubit>().updateTask(widget.taskEntry);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            Expanded(
                child: TextFormField(
               keyboardType:  TextInputType.multiline,
              maxLines: null,
              focusNode: focusNode,
              controller: _textEditingController,
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onFieldSubmitted: (value) {
                _submitText();
              },
              autofocus: isEditing,
              enabled: isEditing,
              style: Theme.of(context).textTheme.bodySmall,
                  
                  /* decoration: widget.taskEntry.value.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none), */
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'todo_hint'.tr(),
                hintStyle: Theme.of(context).textTheme.labelSmall
              ),
            )),
            Row(
              children: [
                if(isEditing) ...{
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {},
                    icon: const Icon(Icons.done)),
                } else ...{
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context
                          .read<TodoListCubit>()
                          .setEditedEntryKey(widget.taskEntry.key);
                    },
                    icon: const Icon(Icons.edit)),
                },
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context
                          .read<TodoListCubit>()
                          .deleteTask(widget.taskEntry);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    )),
              ],
            )
          ],
        )),
      );
    }));
  }
}
