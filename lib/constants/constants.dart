import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/widgets/online_user.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_projects_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/notifications_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/search_screen.dart';
import 'package:project_management_muhmad_omar/utils/data_model.dart';

String tabSpace = "\t\t\t";

final List<Widget> dashBoardScreens = [
  DashboardScreen(),
  DashboardProjectScreen(),
  const NotificationScreen(),
  SearchScreen()
];

List<Color> progressCardGradientList = [
  HexColor.fromHex("87EFB5"),
  HexColor.fromHex("8ABFFC"),
  HexColor.fromHex("EEB2E8"),
];

final onlineUsers = List.generate(
    AppData.onlineUsers.length,
    (index) => OnlineUser(
          image: AppData.onlineUsers[index]['profileImage'],
          imageBackground: AppData.onlineUsers[index]['color'],
          userName: AppData.onlineUsers[index]['name'],
        ));

class Constants {}
