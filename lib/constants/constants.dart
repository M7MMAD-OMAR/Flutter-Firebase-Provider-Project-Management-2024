import 'package:flutter/material.dart';

import '../Screens/Dashboard/category_screen.dart';
import '../Screens/Dashboard/dashboard_screen.dart';
import '../Screens/Dashboard/invitions_screen.dart';
import '../Screens/Dashboard/notifications_screen.dart';
import '../Screens/Dashboard/projects_screen.dart';
import '../Values/values.dart';

String tabSpace = "\t\t\t";

final List<Widget> dashBoardScreens = [
  Dashboard(),
  ProjectScreen(),
  CategoryScreen(),
  Invitions()
];

List<Color> progressCardGradientList = [
  //grenn
  HexColor.fromHex("87EFB5"),
  //blue
  HexColor.fromHex("8ABFFC"),
  //pink
  HexColor.fromHex("EEB2E8"),
];


// the Developer karem saad 