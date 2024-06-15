import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/category_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/invitions_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/projects_screen.dart';

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