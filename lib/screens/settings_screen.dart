import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/cubits/settings_cubit.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:copy_todo_mvc/widgets/sign_in_button.dart';
import 'package:copy_todo_mvc/widgets/signin_error_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const languages = <String>['English', 'Русский'];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _error;
  bool _googleLinked = FirebaseAuth.instance.currentUser!.providerData
      .any((userInfo) => userInfo.providerId == "google.com");
  bool _facebookSignedIn = FirebaseAuth.instance.currentUser!.providerData
      .any((userInfo) => userInfo.providerId == "facebook.com");

  Future<void> _linkGoogle() async {
    setState(() {
      _error = null;
    });

    try {
      if (kIsWeb) {
        await _linkGoogleWeb();
      } else {
        await _linkGoogleNative();
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
    }
  }

  Future<void> _linkGoogleWeb() async {
    final googleAuthProvider = GoogleAuthProvider();
    await FirebaseAuth.instance.currentUser?.linkWithRedirect(googleAuthProvider);
  }

  Future<void> _linkGoogleNative() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    
    googleSignIn.signOut();

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

    FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  }

  Future<void> _linkFacebook() async {
    setState(() {
      _error = null;
    });

    try {
      if (kIsWeb) {
        await _linkFacebookWeb();
      } else {
        await _linkFacebookNative();
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
    }
  }

  Future<void> _linkFacebookWeb() async {
    final FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
    await FirebaseAuth.instance.currentUser?.linkWithPopup(facebookAuthProvider);
  }

  Future<void> _linkFacebookNative() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await FirebaseAuth.instance.currentUser?.linkWithCredential(facebookAuthCredential);
  }

  void handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
    case "provider-already-linked":
      setState(() {
        _error = "already_linked".tr();
      });
      break;
    case "invalid-credential":
      setState(() {
        _error = "invalid_credential".tr();
      });
      break;
    case "credential-already-in-use":
      setState(() {
        _error = "credential_in_use".tr();
      });
      break;
    default:
      setState(() {
        _error = "something_wrong".tr();
      });
    }
  }

  void _showSnackBarError(BuildContext context){
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(signinErrorSnackBar(context, _error!));
  }

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user){
      if(user != null){
        for (final userInfo in user.providerData){
          switch (userInfo.providerId){
            case 'google.com':
              setState(() {
                _googleLinked = true;
              });
              break;
            case 'facebook.com':
              setState(() {
                _facebookSignedIn = true;
              });
          }
        }
      }
    });
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
          child: Container(
              constraints: const BoxConstraints(maxWidth: 800, maxHeight: 500),
              child: Card(
                margin: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 12, 48, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Builder(builder: (context) {
                            return Row(
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
                            );
                          }),
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
                              child: _googleLinked
                                  ? Text('connected_google'.tr())
                                  : Text('link_google'.tr()),
                              onPressed: _googleLinked
                                  ? null
                                  : () async {
                                      await _linkGoogle();
                                      if(_error != null){
                                        if(context.mounted){
                                          _showSnackBarError(context);
                                        }
                                      } else {
                                        setState(() {
                                          _googleLinked = true;
                                        });
                                      }
                                    }),
                          const SizedBox(height: 20),
                          buildSignInButton(
                              icon: const AssetImage(
                                  "assets/images/auth/facebook.png"),
                              child: _facebookSignedIn
                                  ? Text('connected_facebook'.tr())
                                  : Text('link_facebook'.tr()),
                              onPressed: _facebookSignedIn
                                  ? null
                                  : () async {
                                      await _linkFacebook();
                                      if(_error != null){
                                        if(context.mounted){
                                          _showSnackBarError(context);
                                        }
                                      } else {
                                        setState(() {
                                          _facebookSignedIn = true;
                                        });
                                      }
                                    }),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
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
              )),
        )));
  }
}
