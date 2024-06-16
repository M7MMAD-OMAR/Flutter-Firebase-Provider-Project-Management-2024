import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Chat/add_chat_icon_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';

class Projects extends StatelessWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
           Padding(
               padding: EdgeInsets.only(
          left: Utils.screenWidth * 0.04, // Adjust the percentage as needed
          right: Utils.screenWidth * 0.04,
        ),
              child: const SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskezAppHeader(
                        title: "Chat",
                        widget: AppAddIcon(),
                      ),
                      AppSpaces.verticalSpace20,
                    ]),
              ))
        ],
      ),
    );
  }
}
