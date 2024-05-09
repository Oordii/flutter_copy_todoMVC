import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:copy_todo_mvc/widgets/todo_drawer.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({
    super.key,
    required this.child,
    this.floatingActionButton, 
  });

  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TodoAppBar(),
        drawer: const TodoDrawer(),
        drawerEnableOpenDragGesture: true,
        floatingActionButton: floatingActionButton,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.only(top: 8, bottom: 64),
            alignment: Alignment.topCenter,
            child: child
          ),
        )    
      );
  }
}
