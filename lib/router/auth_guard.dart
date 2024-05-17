import 'package:auto_route/auto_route.dart';
import 'package:copy_todo_mvc/router/app_route.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGuard extends AutoRouteGuard {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_firebaseAuth.currentUser != null) {
      resolver.next();
    } else {
      router.push(const SignInRoute());
    }
  }
}
