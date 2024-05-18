import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/cubits/auth_cubit.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:copy_todo_mvc/widgets/todo_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SignUpEmailScreen extends StatefulWidget {
  const SignUpEmailScreen({super.key});

  @override
  State<SignUpEmailScreen> createState() => _SignUpEmailScreenState();
}

class _SignUpEmailScreenState extends State<SignUpEmailScreen> {
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
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
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

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        key: _passwordKey,
        autofillHints: const [AutofillHints.newPassword],
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

  Widget _buildConfirmPasswordField() {
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
        onFieldSubmitted: (_) {
          context.read<AuthCubit>().signUpWithEmail(_email, _password);
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
          ? () {
              context.read<AuthCubit>().signUpWithEmail(_email, _password);
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
                child: Builder(
                  builder: (context) {
                    final state = context.watch<AuthCubit>().state;
                    final loading = state.maybeWhen(
                        loading: () => true, orElse: () => false);

                    state.whenOrNull(error: (message) {
                      if (message != null && context.mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final messenger = ScaffoldMessenger.of(context);
                          messenger.clearSnackBars();
                          messenger.showSnackBar(signinErrorSnackBar(context, message.tr()));
                        });
                      }
                    });

                    return loading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AutofillGroup(
                                child: Column(
                                  children: [
                                    _buildEmailField(),
                                    _buildPasswordField(),
                                    _buildConfirmPasswordField(),
                                  ],
                                ),
                              ),
                              _buildSignUpButton(context),
                            ],
                          );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
