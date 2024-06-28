import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/login_screen/login_screen.dart';
import 'package:project_management_muhmad_omar/screens/profile_screen/profile_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/register_screen/register_screen.dart';
import 'package:project_management_muhmad_omar/screens/tasks_screen/tasks_screen.dart';

class Routes {
  Routes._();

  // Start Auth Screens --------------------------------------------------------------
  static const String loginScreen = '/login-screen';
  static const String registerScreen = '/register-screen';
  static const String projectsScreen = '/projects-screen';
  static const String tasksScreen = '/tasks-screen';
  static const String profileScreen = '/profile-screen';

  static final dynamic routes = <String, WidgetBuilder>{
    loginScreen: (BuildContext context) => LoginScreen(),
    registerScreen: (BuildContext context) => RegisterScreen(),
    projectsScreen: (BuildContext context) => ProjectsScreen(),
    tasksScreen: (BuildContext context) => TasksScreen(),
    profileScreen: (BuildContext context) => ProfileScreen(),
  };
}
