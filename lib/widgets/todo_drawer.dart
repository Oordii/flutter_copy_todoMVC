import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TodoDrawer extends StatelessWidget {
  const TodoDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentRouteName = context.router.current.name;

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 115,
            width: MediaQuery.of(context).size.width,
            child: DrawerHeader(
              child: Text("todos",
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 0),
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text("drawer_home".tr(context: context)),
                  onTap: () async {
                    await context.router.replace(const HomeRoute());
                  },
                  selected: currentRouteName == HomeRoute.name,
                ),
                const Divider()
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text("drawer_settings".tr()),
            onTap: () async {
              Navigator.pop(context);
              await context.router.navigate(const SettingsRoute());
            },
            selected: currentRouteName == SettingsRoute.name,
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: Text("drawer_about".tr()),
            onTap: () async {
              await context.router.navigate(const AboutRoute());
            },
            selected: currentRouteName == AboutRoute.name,
          )
        ],
      ),
    );
  }
}
