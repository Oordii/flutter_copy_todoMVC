import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:copy_todo_mvc/widgets/todo_drawer.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({
    super.key,
    required this.child,
    this.floatingActionButton
  });

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* backgroundColor: const Color.fromARGB(255, 245, 245, 245), */
        appBar: const TodoAppBar(),
        drawer: const TodoDrawer(),
        drawerEnableOpenDragGesture: true,
        floatingActionButton: floatingActionButton,
        body: child);
  }
}