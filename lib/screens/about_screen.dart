import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/screens/layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: Container(
        constraints: const BoxConstraints.expand(height: 200),
        margin: const EdgeInsets.only(top: 40),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("about_title".tr(),
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
