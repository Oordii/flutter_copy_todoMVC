import 'package:flutter/material.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TodoAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "todos",
        style: TextStyle(
            color: Color(0xffb83f45),
            fontWeight: FontWeight.w200,
            fontSize: 45,
            fontFamily: "Helvetica Neue"),
      ),
      centerTitle: true,
      elevation: 3,
    );
  }
  
}
