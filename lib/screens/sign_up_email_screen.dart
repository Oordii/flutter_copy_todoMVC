import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
  String? _error;
  String _email = '';
  String _password = '';
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _confirmPasswordKey = GlobalKey<FormFieldState>();
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        getIt.get<AppRouter>().replaceAll([const HomeRoute()]);
      }
    });
  }

  Future<void> _submit() async {
    if (!_isEmailValid || !_isPasswordValid || !_isConfirmPasswordValid) {
      setState(() {
        _error = "Email or password is invalid";
      });
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      setState(() {
        _error = null;
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            _error = 'Invalid email';
          });
          break;
        case 'invalid-credential':
          setState(() {
            _error = 'Email or password is incorrect';
          });
          break;
        case 'email-already-in-use':
          setState(() {
            _error = 'This email is already used';
          });
          break;
        case 'weak-password':
          setState(() {
            _error = 'Password is weak';
          });
          break;
        default:
          setState(() {
            _error = 'Login failed. try again';
          });
      }
    } finally {
      if (_error != null) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const TodoAppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 64),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          key: _emailKey,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Can`t be empty';
                            }
                            final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email);
                            if (!emailValid) {
                              return 'Invalid email address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                              _isEmailValid =
                                  _emailKey.currentState!.validate();
                            });
                          },
                          onFieldSubmitted: (_) {
                            _passwordFocusNode.requestFocus();
                          },
                          onTapOutside: (_) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextFormField(
                            key: _passwordKey,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            focusNode: _passwordFocusNode,
                            validator: (password) {
                              if (password == null || password.isEmpty) {
                                return 'Can`t be empty';
                              }
                              final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
                              if (!regex.hasMatch(password)){
                                return 'Password should contain at least one upper-, one lower case, one digit and be at least 8 charecters in length';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                                _isPasswordValid =
                                    _passwordKey.currentState!.validate();
                              });
                            },
                            onTapOutside: (_) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onFieldSubmitted: (_) {
                              _confirmPasswordFocusNode.requestFocus();
                            },
                            decoration:
                                const InputDecoration(labelText: "Password", errorMaxLines: 3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextFormField(
                            key: _confirmPasswordKey,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            focusNode: _confirmPasswordFocusNode,
                            validator: (confirmPass) {
                              if (confirmPass == null || confirmPass.isEmpty) {
                                return 'Can`t be empty';
                              } else if (confirmPass != _password) {
                                return 'Passwords don`t match';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _isConfirmPasswordValid = _confirmPasswordKey
                                    .currentState!
                                    .validate();
                              });
                            },
                            onTapOutside: (_) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onFieldSubmitted: (_) async {
                              await _submit();
                              if (context.mounted && _error != null) {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.clearSnackBars();
                                messenger.showSnackBar(
                                    signinErrorSnackBar(context, _error!));
                              }
                            },
                            decoration: const InputDecoration(
                                labelText: 'Confirm password'),
                          ),
                        )
                      ],
                    ),
                    OutlinedButton(
                        onPressed: _isEmailValid &&
                                _isPasswordValid &&
                                _isConfirmPasswordValid
                            ? () async {
                                await _submit();

                                if (context.mounted && _error != null) {
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  messenger.clearSnackBars();
                                  messenger.showSnackBar(
                                      signinErrorSnackBar(context, _error!));
                                }
                              }
                            : null,
                        child: const Text("Sign up")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
