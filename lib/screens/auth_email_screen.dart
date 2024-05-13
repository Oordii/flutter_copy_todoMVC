import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthEmailScreen extends StatefulWidget {
  const AuthEmailScreen({super.key});

  @override
  State<AuthEmailScreen> createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen> {
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
                  hintText: "Email",
                ),
              ),
              OutlinedButton(
                  onPressed: () {
                    context.router.navigate(const AuthPasswordRoute());
                  },
                  child: const Text("Next"))
            ],
          ),
        ),
      ),
    ));
  }
}
