import 'package:copy_todo_mvc/components/new_todo.dart';
import 'package:copy_todo_mvc/components/todo_items.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'components/todo_bottom_bar.dart';
import 'models/task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoMVC copy',
      home: BlocProvider(
          create: (context) => TodoListCubit(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(245, 245, 245, 255),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "todos",
                style: TextStyle(
                    color: Color(0xffb83f45),
                    fontWeight: FontWeight.w200,
                    fontSize: 80,
                    fontFamily: "Helvetica Neue"),
              ),
              Container(
                  constraints: const BoxConstraints(maxWidth: 550),
                  child: const Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
                    shape: BeveledRectangleBorder(),
                    elevation: 3,
                    color: Color.fromARGB(254, 254, 254, 255),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [NewTodo(), TodoItems(), TodoBottomBar()],
                    ),
                  )),
              const Text("Double-click to edit a todo",
                  style: TextStyle(fontSize: 12)),
              const Text("Created by житомирські бойові слони",
                  style: TextStyle(fontSize: 12)),
              const Text("Part of plan of destroying russia",
                  style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
