import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthPasswordScreen extends StatefulWidget {
  const AuthPasswordScreen({super.key});

  @override
  State<AuthPasswordScreen> createState() => _AuthPasswordScreenState();
}

class _AuthPasswordScreenState extends State<AuthPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: const TodoAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 12, 48, 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: "Password"
                ),
              ),
              OutlinedButton(onPressed: (){
                context.router.replace(const HomeRoute());
              }, child: const Text("Done"))
            ],
          ),
        ),
      ),
    ));
  }
}
