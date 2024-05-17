import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/cubits/todo_list_cubit.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/sign_in_button.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? _error;
  bool _loading = false;

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

  Future<void> signInWithGoogle() async {
    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      if (kIsWeb) {
        await signInWithGoogleWeb();
      } else {
        await signInWithGoogleNative();
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> signInWithGoogleWeb() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<void> signInWithGoogleNative() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithFacebook() async {
    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      if (kIsWeb) {
        await signInWithFacebookWeb();
      } else {
        await signInWithFacebookNative();
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> signInWithFacebookWeb() async {
    final FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
    await FirebaseAuth.instance.signInWithPopup(facebookAuthProvider);
  }

  Future<void> signInWithFacebookNative() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  void handleAuthException(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      setState(() {
        _error = 'email_registered_with_diff_provider'.tr();
      });
    } else {
      throw e;
    }
  }

  void showSignInErrorSnackbar(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(signinErrorSnackBar(context, _error!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TodoAppBar(),
      body: Align(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 12, 48, 64),
          child: _loading
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
                      icon: const AssetImage("assets/images/auth/google.png"),
                      child: Text("sign_in_google".tr()),
                      onPressed: () async {
                        await signInWithGoogle();
                        if (_error != null && context.mounted) {
                          showSignInErrorSnackbar(context);
                        }
                      },
                    ),
                    buildSignInButton(
                      icon: const AssetImage("assets/images/auth/facebook.png"),
                      child: Text("sign_in_facebook".tr()),
                      onPressed: () async {
                        await signInWithFacebook();
                        if (_error != null && context.mounted) {
                          showSignInErrorSnackbar(context);
                        }
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
