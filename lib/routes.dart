import 'package:flutter/material.dart';

import 'screens/home_screen/home_screen.dart';

class Routes {
  Routes._();

  // static variables
  static const String homeScreen = '/home-screen';
  static const String authScreen = '/auth-screen';

  // route list
  static final dynamic routes = <String, WidgetBuilder>{
    homeScreen: (BuildContext context) => const HomeScreen(),
    // authScreen: (BuildContext context) => const AuthScreen(),
  };
}
