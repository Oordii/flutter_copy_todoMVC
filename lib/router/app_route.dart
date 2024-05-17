import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/router/auth_guard.dart';

import 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  final AuthGuard authGuard = AuthGuard();

  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignInEmailRoute.page),
        AutoRoute(page: SignUpEmailRoute.page),
        AutoRoute(page: HomeRoute.page, initial: true, guards: [authGuard]),
        AutoRoute(page: SettingsRoute.page, guards: [authGuard]),
        AutoRoute(page: AboutRoute.page, guards: [authGuard])
      ];
}
