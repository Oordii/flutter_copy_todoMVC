import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  Future<void> signInWithGoogle() async {
  // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    await getIt.get<AppRouter>().replaceAll([const HomeRoute()]);
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
                    context.router.navigate(const SignInEmailRoute());
                  },
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(8, 0, 0, 0)),
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
                  onPressed: () async {
                    await widget.signInWithGoogle();
                  },
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(8, 0, 0, 0))
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
                    padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.fromLTRB(8, 0, 0, 0))
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
