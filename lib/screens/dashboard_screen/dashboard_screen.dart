import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/screens/chat_screen/chat_screen.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_tab_buttons.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/dasboard_header.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/app_settings_icon.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/dashboard_settings_sheet.dart';

import 'dashboard_tab_screens/overview_screen.dart';
import 'dashboard_tab_screens/productivity_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final ValueNotifier<bool> _totalTaskTrigger = ValueNotifier(true);
  final ValueNotifier<bool> _totalDueTrigger = ValueNotifier(false);
  final ValueNotifier<bool> _totalCompletedTrigger = ValueNotifier(true);
  final ValueNotifier<bool> _workingOnTrigger = ValueNotifier(false);
  final ValueNotifier<int> _buttonTrigger = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DashboardNav(
                icon: FontAwesomeIcons.comment,
                image: "assets/man-head.png",
                notificationCount: "2",
                page: const ChatScreen(),
                title: "Dashboard",
                onImageTapped: () {
                  Navigator.pushNamed(context, Routes.profileOverviewScreen);
                },
              ),
              AppSpaces.verticalSpace20,
              Text(
                  textAlign: TextAlign.right,
                  "Hello,\nDereck Doyle 👋",
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PrimaryTabButton(
                        buttonText: "Overview",
                        itemIndex: 0,
                        notifier: _buttonTrigger),
                    PrimaryTabButton(
                        buttonText: "Productivity",
                        itemIndex: 1,
                        notifier: _buttonTrigger)
                  ],
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: AppSettingsIcon(
                      callback: () {
                        showAppBottomSheet(
                          context,
                          DashboardSettingsBottomSheet(
                            totalTaskNotifier: _totalTaskTrigger,
                            totalDueNotifier: _totalDueTrigger,
                            workingOnNotifier: _workingOnTrigger,
                            totalCompletedNotifier: _totalCompletedTrigger,
                          ),
                        );
                      },
                    ))
              ]),
              AppSpaces.verticalSpace20,
              ValueListenableBuilder(
                  valueListenable: _buttonTrigger,
                  builder: (BuildContext context, _, __) {
                    return _buttonTrigger.value == 0
                        ? const DashboardOverviewScreen()
                        : const DashboardProductivityScreen();
                  })
            ]),
          ),
        ));
  }
}
