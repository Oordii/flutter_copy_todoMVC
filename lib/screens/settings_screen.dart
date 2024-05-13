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
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
              constraints: const BoxConstraints(maxWidth: 800, maxHeight: 200),
              child: Card(
                margin: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(48, 12, 48, 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Builder(
                        builder: (context) {
                          final settingsState = context.watch<SettingsCubit>().state;
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.dark_mode),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text("settings_theme".tr(), style: Theme.of(context).textTheme.bodyMedium),
                                  ),
                                ],
                              ),
                              Switch(value: settingsState.themeMode == ThemeMode.dark, 
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
                                child: Text("settings_locale".tr(), style: Theme.of(context).textTheme.bodyMedium),
                              ),
                            ],
                          ),
                          DropdownButton<Locale>(
                            value: context.locale,
                            items: [
                              DropdownMenuItem(value: const Locale('en', 'US'),child: Text("English", style:  Theme.of(context).textTheme.labelMedium),),
                              DropdownMenuItem(value: const Locale('ru', 'RU'),child: Text("Русский", style:  Theme.of(context).textTheme.labelMedium),)
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
              )),
        )
      )
    );
  }
}
