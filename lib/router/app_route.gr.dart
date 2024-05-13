// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:copy_todo_mvc/screens/about_screen.dart' as _i1;
import 'package:copy_todo_mvc/screens/auth_email_screen.dart' as _i2;
import 'package:copy_todo_mvc/screens/auth_password_screen.dart' as _i3;
import 'package:copy_todo_mvc/screens/auth_screen.dart' as _i4;
import 'package:copy_todo_mvc/screens/home_screen.dart' as _i5;
import 'package:copy_todo_mvc/screens/settings_screen.dart' as _i6;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    AboutRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AboutScreen(),
      );
    },
    AuthEmailRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AuthEmailScreen(),
      );
    },
    AuthPasswordRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AuthPasswordScreen(),
      );
    },
    AuthRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AuthScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomeScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AboutScreen]
class AboutRoute extends _i7.PageRouteInfo<void> {
  const AboutRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AuthEmailScreen]
class AuthEmailRoute extends _i7.PageRouteInfo<void> {
  const AuthEmailRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AuthEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthEmailRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AuthPasswordScreen]
class AuthPasswordRoute extends _i7.PageRouteInfo<void> {
  const AuthPasswordRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AuthPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthPasswordRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.AuthScreen]
class AuthRoute extends _i7.PageRouteInfo<void> {
  const AuthRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SettingsScreen]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
