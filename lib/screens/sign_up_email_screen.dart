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
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
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

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isEmailValid || !_isPasswordValid || !_isConfirmPasswordValid) {
      setState(() {
        _error = "email_or_pw_invalid".tr();
      });
      return;
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
      setState(() {
        _error = _getErrorMessage(e.code);
      });
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'email_invalid'.tr();
      case 'email-already-in-use':
        return 'email_or_pw_invalid'.tr();
      case 'weak-password':
        return 'weak_pw'.tr();
      default:
        return 'signup_failed'.tr();
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
      autofillHints: const [ AutofillHints.email ],
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

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        key: _passwordKey,
        autofillHints: const [ AutofillHints.password ],
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        autocorrect: false,
        focusNode: _passwordFocusNode,
        validator: (password) {
          if (password == null || password.isEmpty) {
            return 'cant_be_empty'.tr();
          }
          final regex = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
          );
          if (!regex.hasMatch(password)) {
            return 'pw_requirements'.tr();
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
        onFieldSubmitted: (_) {
          _confirmPasswordFocusNode.requestFocus();
        },
        decoration: InputDecoration(
          labelText: "pw".tr(),
          errorMaxLines: 4,
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

  Widget _buildConfirmPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        key: _confirmPasswordKey,
        obscureText: !_confirmPasswordVisible,
        enableSuggestions: false,
        autocorrect: false,
        focusNode: _confirmPasswordFocusNode,
        validator: (confirmPass) {
          if (confirmPass == null || confirmPass.isEmpty) {
            return 'cant_be_empty'.tr();
          } else if (confirmPass != _password) {
            return 'pws_dont_match'.tr();
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _isConfirmPasswordValid =
                _confirmPasswordKey.currentState!.validate();
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
          labelText: 'confirm_pw'.tr(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _confirmPasswordVisible = !_confirmPasswordVisible;
              });
            },
            icon: Icon(
              !_confirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return OutlinedButton(
      onPressed: _isEmailValid && _isPasswordValid && _isConfirmPasswordValid
          ? () async {
              await _submit();
              if (_error != null && context.mounted) {
                _showErrorSnackbar(context);
              }
            }
          : null,
      child: Text("signup".tr()),
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
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 500),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AutofillGroup(
                      child: Column(
                        children: [
                          _buildEmailField(),
                          _buildPasswordField(),
                          _buildConfirmPasswordField(context),
                        ],
                      ),
                    ),
                    _buildSignUpButton(context),
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
