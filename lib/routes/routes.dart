import 'package:firebasecore/ui/views/home/page1.dart';
import 'package:firebasecore/ui/views/home/page2.dart';
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
  static const String page1 = '/page1';
  static const String page2 = '/page2';
}

mixin AppPages {
  static final routes = [
    //landing
    GetPage(name: Routes.landing, page: () => const LandingPage(), transition: Transition.fadeIn),
    GetPage(name: Routes.login, page: () => const LoginPage(), transition: Transition.fadeIn),

    //home
    GetPage(name: Routes.home, page: () => const HomePage(), transition: Transition.downToUp),
    GetPage(name: Routes.page1, page: () => const Page1(), transition: Transition.downToUp),
    GetPage(name: Routes.page2, page: () => const Page2(), transition: Transition.downToUp),
  ];
}
