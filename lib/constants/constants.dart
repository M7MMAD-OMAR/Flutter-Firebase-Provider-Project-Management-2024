import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/category_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/dashboard_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/projects_screen.dart';

String tabSpace = "\t\t\t";

final List<Widget> dashBoardScreens = [
  DashboardScreen(),
  const ProjectScreen(),
  const CategoryScreen(),
  // InvitationScreen()
];

List<Color> progressCardGradientList = [
  //grenn
  HexColor.fromHex("87EFB5"),
  //blue
  HexColor.fromHex("8ABFFC"),
  //pink
  HexColor.fromHex("EEB2E8"),
];

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showErrorDialog(
    {required String title,
    required String middleText,
    required VoidCallback onConfirm,
    required VoidCallback onCancel}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(), // Add your content here
        bottomSheet: AlertDialog(
          title: Text(title),
          content: Text(middleText),
          actions: [
            TextButton(
              onPressed: onCancel,
              child: const Text('إالغاء'),
            ),
            TextButton(
              onPressed: onConfirm,
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );
    },
  );
}

void showSuccessSnackBar(String message) {
  final context = navigatorKey.currentContext!;
  showDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(), // Add your content here
        bottomSheet: SnackBar(
          content: Text(message),
        ),
      );
    },
  );
}

class AppConstants {
  static const String dir_key = "dir";

  static final Map<String, dynamic> dir = {
    "ar": {
      "big_picture_L": 100.0,
      "square_shape_L": 1.0,
      "medium_picture_L": 0.65,
      "small_picture_L": 80.0,
      "big_bubble_L": 295.0,
      "small_bubble_L": 180.0,
      "one_sticker_L": 0.0,
      "two_sticker_L": 0.14,
      "three_sticker_L": 0.0,
      "three_sticker_R": 0.6,
      "get_started_B": 20.0,
      "get_started_L": 30.0,
      "triangle_shape_L": -0.40,
      "triangle_shape_R": 0.83,
    },
    "en": {
      "big_picture_L": 110.0,
      "square_shape_L": 0.0,
      "medium_picture_L": 0.10,
      "small_picture_L": 220.0,
      "big_bubble_L": 50.0,
      "small_bubble_L": 130.0,
      "one_sticker_L": 0.45,
      "two_sticker_L": 0.22,
      "three_sticker_L": 0.6,
      "three_sticker_R": 0.0,
      "get_started_B": 60.0,
      "get_started_L": 40.0,
      "triangle_shape_L": 0.83,
      "triangle_shape_R": -0.40,
    }
  };
}
