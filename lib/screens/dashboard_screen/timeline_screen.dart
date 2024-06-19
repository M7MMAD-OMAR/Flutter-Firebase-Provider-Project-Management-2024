import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/bottom_navigation_item_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/dashboard_add_icon_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/dashboard_add_sheet_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';

import 'dashboard_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  ValueNotifier<int> bottomNavigatorTrigger = ValueNotifier(0);

  AddTeamToCreatProjectScreen addTeamToCreatProjectScreen =
      Get.put(AddTeamToCreatProjectScreen());
  DashboardMeetingDetailsScreenController
      dashboardMeetingDetailsScreenController =
      Get.put(DashboardMeetingDetailsScreenController());
  ProfileOverviewProvider profileOverviewController =
      Get.put(ProfileOverviewProvider(), permanent: true);
  StatelessWidget currentScreen = DashboardScreen();

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#181a1f"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        ValueListenableBuilder(
            valueListenable: bottomNavigatorTrigger,
            builder: (BuildContext context, _, __) {
              return PageStorage(
                  bucket: bucket,
                  child: dashBoardScreens[bottomNavigatorTrigger.value]);
            })
      ]),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 90,
        padding: const EdgeInsets.only(top: 10, right: 30, left: 30),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: HexColor.fromHex("#181a1f").withOpacity(0.8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavigationItem(
                itemIndex: 0,
                notifier: bottomNavigatorTrigger,
                icon: Icons.widgets),
            const Spacer(),
            BottomNavigationItem(
                itemIndex: 1,
                notifier: bottomNavigatorTrigger,
                icon: FeatherIcons.clipboard),
            const Spacer(),
            DashboardAddButton(
              iconTapped: (() {
                showAppBottomSheet(SizedBox(
                    height: Utils.screenHeight * 0.8,
                    child: const DashboardAddBottomSheet()));
              }),
            ),
            const Spacer(),
            BottomNavigationItem(
                itemIndex: 2,
                notifier: bottomNavigatorTrigger,
                icon: Icons.category_rounded),
            const Spacer(),
            BottomNavigationItem(
                itemIndex: 3,
                notifier: bottomNavigatorTrigger,
                icon: FeatherIcons.search)
          ],
        ),
      ),
    );
  }
}
