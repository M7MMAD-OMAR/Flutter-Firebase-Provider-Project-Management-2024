import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/splash_screen.dart';

class Routes {
  Routes._();

  static const String splashScreen = '/splash-screen';

  static const String loginScreen = '/login-screen';
  static const String signupScreen = '/signup-screen';
  static const String choosePlanScreen = '/choose-plan-screen';
  static const String emailAddressScreen = '/email-address-screen';
  static const String newWorkspaceScreen = '/new-workspace-screen';

  static const String homeScreen = '/home-screen';

  static final dynamic routes = <String, WidgetBuilder>{
    splashScreen: (BuildContext context) => const SplashScreen(),
  };
}
