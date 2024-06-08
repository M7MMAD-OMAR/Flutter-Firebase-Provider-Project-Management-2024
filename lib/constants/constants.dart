import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/Screens/Dashboard/dashboard.dart';
import 'package:project_management_muhmad_omar/Screens/Dashboard/notifications.dart';
import 'package:project_management_muhmad_omar/Screens/Dashboard/projects.dart';
import 'package:project_management_muhmad_omar/Screens/Dashboard/search_screen.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/utils/data_model.dart';
import 'package:project_management_muhmad_omar/widgets/Chat/online_user.dart';

String tabSpace = "\t\t\t";

final List<Widget> dashBoardScreens = [
  Dashboard(),
  ProjectScreen(),
  NotificationScreen(),
  SearchScreen()
];

List<Color> progressCardGradientList = [
  //grenn
  HexColor.fromHex("87EFB5"),
  //blue
  HexColor.fromHex("8ABFFC"),
  //pink
  HexColor.fromHex("EEB2E8"),
];

final onlineUsers = List.generate(
    AppData.onlineUsers.length,
    (index) => OnlineUser(
          image: AppData.onlineUsers[index]['profileImage'],
          imageBackground: AppData.onlineUsers[index]['color'],
          userName: AppData.onlineUsers[index]['name'],
        ));
