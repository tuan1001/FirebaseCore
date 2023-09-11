import 'package:firebasecore/ui/views/landing/home_page.dart';
import 'package:firebasecore/ui/views/landing/landing_page.dart';
import 'package:firebasecore/ui/views/landing/login_page.dart';
import 'package:get/route_manager.dart';

mixin Routes {
  //landing
  static const String back = '/..';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  //home
  static const String home = '/home';
}

mixin AppPages {
  static final routes = [
    //landing
    GetPage(name: Routes.landing, page: () => const LandingPage(), transition: Transition.fadeIn),
    GetPage(name: Routes.login, page: () => const LoginPage(), transition: Transition.fadeIn),

    //home
    GetPage(name: Routes.home, page: () => const HomePage(), transition: Transition.downToUp),
  ];
}
