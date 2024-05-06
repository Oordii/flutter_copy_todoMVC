import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final TextEditingController _controller = TextEditingController();
  late final FocusNode _node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListCubit, TodoListState>(builder: (context, state) {
      return (Container(
        constraints: const BoxConstraints(maxHeight: 70),
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        child: Row(
          children: [
            Visibility(
                visible: state.taskEntries.isNotEmpty,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: IconButton(
                    onPressed: () {
                      context.read<TodoListCubit>().toggleAllTasks();
                    },
                    icon: const Icon(Icons.expand_more))),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _node,
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(12, 15, 12, 17),
                    border: InputBorder.none,
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffb83f45)),
                        borderRadius: BorderRadius.only(topLeft: Radius.zero, bottomLeft: Radius.zero, topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                    hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                    hintText: "new_todo_hint".tr(context: context)),
                onSubmitted: (value) {
                  context.read<TodoListCubit>().addTask(value);
                  _controller.clear();
                  _node.requestFocus();
                },
              ),
            ),
          ],
        ),
      ));
    });
  }
}