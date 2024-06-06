import 'package:flutter/material.dart';
import 'screens/home-screen/home-screen.dart';

class Routes {
  Routes._();

  // static variables
  static const String homeScreen = '/home-screen';
  static final dynamic routes = <String, WidgetBuilder>{
    homeScreen: (BuildContext context) => const HomeScreen(),
  };
}
