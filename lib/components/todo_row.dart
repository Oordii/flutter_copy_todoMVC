import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoRow extends StatefulWidget {
  const TodoRow({super.key, required this.taskEntry});

  final MapEntry<dynamic, Task> taskEntry;

  @override
  State<TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<TodoRow> {
  bool _isHovered = false;
  bool _isEditing = false;

  late FocusNode focusNode = FocusNode();
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      if(_isEditing){
        focusNode.requestFocus();
        _textEditingController.selection = TextSelection.collapsed(offset: _textEditingController.text.length);   
      }
    },);
    _textEditingController.text = widget.taskEntry.value.name;

    return (BlocBuilder<TodoListCubit, TodoListState>(
        builder: (context, state) {
      return (Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
        child: MouseRegion(
          onEnter: (event) => {
            setState(() {
              _isHovered = true;
            })
          },
          onExit: (event) => {
            setState(() {
              _isHovered = false;
            })
          },
          child: Row(
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
                  child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _textEditingController,
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      _isEditing = false;
                      _isHovered = false;
                    });
                  },
                  onFieldSubmitted: (value) {
                    widget.taskEntry.value.name = value;
                    context.read<TodoListCubit>().updateTask(widget.taskEntry);
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  enabled: _isEditing,
                  style: TextStyle(
                      color: widget.taskEntry.value.isCompleted
                          ? Colors.grey
                          : Colors.black,
                      decoration: widget.taskEntry.value.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: _isEditing
                          ? const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Color(0xffb83f45)))
                          : InputBorder.none),
                ),
              )),
                if(_isHovered || _isEditing)
                  IconButton(
                    onPressed: () {
                      context
                          .read<TodoListCubit>()
                          .deleteTask(widget.taskEntry);
                    },
                    icon: const Icon(Icons.close))
            ],
          ),
        ),
      ));
    }));
  }
}
