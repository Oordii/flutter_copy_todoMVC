import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {

 @override
 List<AutoRoute> get routes => [
    AutoRoute(page: SignInRoute.page, initial: FirebaseAuth.instance.currentUser == null),
    AutoRoute(page: SignInEmailRoute.page),
    AutoRoute(page: SignUpEmailRoute.page),
    AutoRoute(page: HomeRoute.page, initial: FirebaseAuth.instance.currentUser != null),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: AboutRoute.page)
 ];
}