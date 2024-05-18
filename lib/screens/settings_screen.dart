import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/cubits/auth_cubit.dart';
import 'package:copy_todo_mvc/cubits/settings_cubit.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/sign_in_button.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const languages = <String>['English', 'Русский'];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showSnackBarError(BuildContext context, String error) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(signinErrorSnackBar(context, error.tr()));
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          title: Text("settings".tr(), style: const TextStyle(fontSize: 24)),
          elevation: 3,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Builder(builder: (context) {
            final authCubit = context.watch<AuthCubit>();
            final loading = authCubit.state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            context.watch<AuthCubit>().state.maybeWhen(
                error: (message) {
                  if (message != null && context.mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showSnackBarError(context, message);
                    });
                  }
                },
                orElse: () {});

            final googleLinked = FirebaseAuth.instance.currentUser?.providerData
                    .any((userInfo) => userInfo.providerId == "google.com") ??
                false;
            final facebookLinked = FirebaseAuth
                    .instance.currentUser?.providerData
                    .any((userInfo) => userInfo.providerId == "facebook.com") ??
                false;
            return Container(
                constraints:
                    const BoxConstraints(maxWidth: 800, maxHeight: 500),
                child: Card(
                  margin: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(48, 12, 48, 12),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.dark_mode),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text("settings_theme".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                      value: Theme.of(context).brightness ==
                                          Brightness.dark,
                                      onChanged: (value) {
                                        context.read<SettingsCubit>().setTheme(
                                            value
                                                ? ThemeMode.dark
                                                : ThemeMode.light);
                                      })
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.language),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text("settings_locale".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                      ),
                                    ],
                                  ),
                                  DropdownButton<Locale>(
                                      value: context.locale,
                                      items: [
                                        DropdownMenuItem(
                                          value: const Locale('en', 'US'),
                                          child: Text("English",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium),
                                        ),
                                        DropdownMenuItem(
                                          value: const Locale('ru', 'RU'),
                                          child: Text("Русский",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium),
                                        )
                                      ],
                                      onChanged: (locale) {
                                        setState(() {
                                          context.setLocale(locale!);
                                        });
                                      })
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              buildSignInButton(
                                  icon: const AssetImage(
                                      "assets/images/auth/google.png"),
                                  child: googleLinked
                                      ? Text('connected_google'.tr())
                                      : Text('link_google'.tr()),
                                  onPressed: loading || googleLinked
                                      ? null
                                      : () async {
                                          context.read<AuthCubit>().linkGoogle();
                                        }),
                              const SizedBox(height: 20),
                              buildSignInButton(
                                  icon: const AssetImage(
                                      "assets/images/auth/facebook.png"),
                                  child: facebookLinked
                                      ? Text('connected_facebook'.tr())
                                      : Text('link_facebook'.tr()),
                                  onPressed: loading || facebookLinked
                                      ? null
                                      : () async {
                                          context
                                              .read<AuthCubit>()
                                              .linkFacebook();
                                        }),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: loading
                                    ? null
                                    : () async {
                                        await context.read<AuthCubit>().signOut();
                                        if (context.mounted) {
                                          await context.router
                                              .replaceAll([const SignInRoute()]);
                                        }
                                      },
                                child: Text("signout".tr()),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }),
        )));
  }
}
