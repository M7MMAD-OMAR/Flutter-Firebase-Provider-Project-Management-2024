import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Chat/add_chat_icon.dart';
import 'package:project_management_muhmad_omar/widgets/DarkBackground/darkRadialBackground.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/app_header.dart';

class Projects extends StatelessWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TaskezAppHeader(
                title: "Chat",
                widget: AppAddIcon(),
              ),
              AppSpaces.verticalSpace20,
            ]),
          ))
    ]));
  }
}
