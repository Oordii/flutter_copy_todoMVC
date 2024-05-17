import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/main.dart';
import 'package:copy_todo_mvc/router/app_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SignInEmailScreen extends StatefulWidget {
  const SignInEmailScreen({super.key});

  @override
  State<SignInEmailScreen> createState() => _SignInEmailScreenState();
}

class _SignInEmailScreenState extends State<SignInEmailScreen> {
  String? _error;
  String _email = '';
  String _password = '';
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _passwordVisible = false;
  bool _loading = false;
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        getIt.get<AppRouter>().replaceAll([const HomeRoute()]);
      }
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isEmailValid || !_isPasswordValid) {
      setState(() {
        _error = "email_or_pw_invalid".tr();
      });
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      setState(() {
        _error = null;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = _getErrorMessage(e.code);
        _loading = false;
      });
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'email_invalid'.tr();
      case 'invalid-credential':
      case 'wrong-password':
        return 'email_or_pw_invalid'.tr();
      default:
        return 'login_failed'.tr();
    }
  }

  void _showErrorSnackbar(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(signinErrorSnackBar(context, _error!));
  }

  Widget _buildEmailField() {
    return TextFormField(
      key: _emailKey,
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      validator: (email) {
        if (email == null || email.isEmpty) {
          return 'cant_be_empty'.tr();
        }
        final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(email);
        if (!emailValid) {
          return 'email_invalid'.tr();
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _email = value;
          _isEmailValid = _emailKey.currentState!.validate();
        });
      },
      onFieldSubmitted: (_) {
        _passwordFocusNode.requestFocus();
      },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: const InputDecoration(
        labelText: "Email",
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        key: _passwordKey,
        autofillHints: const [AutofillHints.password],
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        autocorrect: false,
        focusNode: _passwordFocusNode,
        validator: (password) {
          if (password == null || password.isEmpty) {
            return 'cant_be_empty'.tr();
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _password = value;
            _isPasswordValid = _passwordKey.currentState!.validate();
          });
        },
        onTapOutside: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onFieldSubmitted: (_) async {
          await _submit();
          if (_error != null && context.mounted) {
            _showErrorSnackbar(context);
          }
        },
        decoration: InputDecoration(
          labelText: "pw".tr(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              !_passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return OutlinedButton(
      onPressed: _isEmailValid && _isPasswordValid
          ? () async {
              setState(() {
                _loading = true;
              });
              await _submit();
              if (_error != null && context.mounted) {
                _showErrorSnackbar(context);
              }
            }
          : null,
      child: Text("sign_in".tr()),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        context.router.navigate(const SignUpEmailRoute());
      },
      child: Text("new_account".tr()),
    );
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
                padding: const EdgeInsets.all(16),
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutofillGroup(
                            child: Column(
                              children: [
                                _buildEmailField(),
                                _buildPasswordField(context),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildSignInButton(context),
                              Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "no_account".tr(),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ),
                              ),
                              _buildSignUpButton(context),
                            ],
                          ),
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
