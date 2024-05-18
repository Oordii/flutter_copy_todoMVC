import 'package:auto_route/annotations.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/screens/layout.dart';
import 'package:copy_todo_mvc/widgets/todo_bar.dart';
import 'package:copy_todo_mvc/widgets/todo_items.dart';
import 'package:copy_todo_mvc/widgets/items_top_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Layout(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<TodoListCubit>().addTask('');
        },
        child: const Icon(Icons.add),
      ),
      child: (const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TodoBar(),
            Card(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.all(8),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ItemsTopRow(),
                    ),
                    TodoItems(),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
