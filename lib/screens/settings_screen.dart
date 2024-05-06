import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/cubits/settings_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
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
  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        appBar: AppBar(
          title: Text("settings".tr(), style: const TextStyle(fontSize: 24)),
          elevation: 3,
        ),
        body: Container(
            constraints: const BoxConstraints(maxWidth: 550, maxHeight: 200),
            child: Card(
              margin: const EdgeInsets.fromLTRB(16, 40, 16, 0),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 12, 48, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.dark_mode),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text("settings_theme".tr(), style: const TextStyle(fontSize: 20),),
                                ),
                              ],
                            ),
                            Switch(value: state.themeMode == ThemeMode.dark, 
                            onChanged: (value) {
                              context.read<SettingsCubit>().setTheme(value ? ThemeMode.dark : ThemeMode.light);
                            })
                          ],
                        );
                      }
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text("settings_locale".tr(), style: const TextStyle(fontSize: 20),),
                            ),
                          ],
                        ),
                        DropdownButton<Locale>(
                          value: context.locale,
                          items: const [
                            DropdownMenuItem(value: Locale('en', 'US'),child: Text("English"),),
                            DropdownMenuItem(value: Locale('ru', 'RU'),child: Text("Русский"),)
                          ],
                          onChanged: (locale){
                            setState(() {
                              context.setLocale(locale!);
                            });
                          })
                      ],
                    )
                  ],
                ),
              ),
            ))
      )
    );
  }
}
