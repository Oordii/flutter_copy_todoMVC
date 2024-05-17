import 'package:auto_route/auto_route.dart';

import 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

 @override
 List<AutoRoute> get routes => [
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: SignInEmailRoute.page),
    AutoRoute(page: SignUpEmailRoute.page),
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: AboutRoute.page)
 ];
}