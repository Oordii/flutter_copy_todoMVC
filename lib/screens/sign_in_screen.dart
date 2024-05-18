import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/cubits/auth_cubit.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/sign_in_button.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        unawaited(context.read<TodoListCubit>().init());
        await getIt.get<AppRouter>().replaceAll([const HomeRoute()]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              if (message != null && context.mounted) {
                final messenger = ScaffoldMessenger.of(context);
                messenger.clearSnackBars();
                messenger
                    .showSnackBar(signinErrorSnackBar(context, message.tr()));
              }
            },
          );
        },
        builder: (context, state) {
          final loading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Align(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 12, 48, 64),
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSignInButton(
                          icon: Icons.email,
                          child: Text("sign_in_email".tr()),
                          onPressed: () {
                            context.router.navigate(const SignInEmailRoute());
                          },
                        ),
                        buildSignInButton(
                          icon:
                              const AssetImage("assets/images/auth/google.png"),
                          child: Text("sign_in_google".tr()),
                          onPressed: () async {
                            await context.read<AuthCubit>().signInWithGoogle();
                          },
                        ),
                        buildSignInButton(
                          icon: const AssetImage(
                              "assets/images/auth/facebook.png"),
                          child: Text("sign_in_facebook".tr()),
                          onPressed: () async {
                            await context.read<AuthCubit>().signInWithFacebook();
                          },
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
