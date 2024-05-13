import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: const TodoAppBar(),
      body: Align(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 12, 48, 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 240,
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: OutlinedButton(
                  onPressed: () {
                    context.router.navigate(const AuthEmailRoute());
                  },
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(8, 0, 0, 0)),
                  ),
                  child: const SizedBox(
                    width: 240,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.email, size: 40),
                        VerticalDivider(),
                        Text("Sign in with email"),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 240,
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: OutlinedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(8, 0, 0, 0))
                  ),
                  child: const SizedBox(
                    width: 240,
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                            image: AssetImage("assets/images/auth/google.png"),
                            width: 40),
                        VerticalDivider(),
                        Text("Continue with Google"),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 240,
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: OutlinedButton(
                  onPressed: () {},
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(8, 0, 0, 0))
                  ),
                  child: const SizedBox(
                    width: 240,
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                            image: AssetImage("assets/images/auth/facebook.png"),
                            width: 40),
                        VerticalDivider(),
                        Text("Continue with Facebook"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
