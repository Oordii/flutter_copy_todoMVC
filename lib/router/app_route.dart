import 'package:auto_route/auto_route.dart';

import 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

 @override
 List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page, initial: true),
    AutoRoute(page: AuthEmailRoute.page),
    AutoRoute(page: AuthPasswordRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: AboutRoute.page)
 ];
}