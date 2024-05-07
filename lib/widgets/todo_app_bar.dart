import 'package:flutter/material.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TodoAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "todos",
        style: Theme.of(context).textTheme.displayLarge,
      ),
      centerTitle: true,
      elevation: 3,
    );
  }
  
}
