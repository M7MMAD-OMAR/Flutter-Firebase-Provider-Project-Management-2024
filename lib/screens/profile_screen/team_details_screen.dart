import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/Constants/constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/in_bottomsheet_subtitle.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/widgets/project_card_vertical.dart';
import 'package:project_management_muhmad_omar/utils/data_model.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_tab_buttons.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/app_header.dart';
import 'package:project_management_muhmad_omar/widgets/Team/more_team_details_sheet.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';
import 'package:project_management_muhmad_omar/widgets/table_calendar.dart';

import 'my_team_screen.dart';

class TeamDetailsScreen extends StatelessWidget {
  final String title;

  const TeamDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final settingsButtonTrigger = ValueNotifier(0);

    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                TaskezAppHeader(
                    title: "$tabSpace $title Team",
                    widget: InkWell(
                        onTap: () {
                          showAppBottomSheet(
                            context,
                            Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: SizedBox(
                                  height: Utils.getScreenHeight(context) * 0.9,
                                  child: const MoreTeamDetailsSheet()),
                            ),
                            isScrollControlled: true,
                          );
                        },
                        child: const Icon(Icons.more_horiz,
                            size: 30, color: Colors.white))),
                AppSpaces.verticalSpace40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PrimaryTabButton(
                        buttonText: "Overview",
                        itemIndex: 0,
                        notifier: settingsButtonTrigger),
                    PrimaryTabButton(
                        buttonText: "Calendar",
                        itemIndex: 1,
                        notifier: settingsButtonTrigger),
                  ],
                ),
                AppSpaces.verticalSpace40,
                TeamStory(
                    teamTitle: title, numberOfMembers: "12", noImages: "8"),
                AppSpaces.verticalSpace10,
                InBottomSheetSubtitle(
                    title:
                        "We're a growing family of 371,521 designers and \nmakers from around the world.",
                    textStyle:
                        GoogleFonts.lato(fontSize: 15, color: Colors.white70)),
                AppSpaces.verticalSpace40,
                ValueListenableBuilder(
                    valueListenable: settingsButtonTrigger,
                    builder: (BuildContext context, _, __) {
                      return settingsButtonTrigger.value == 0
                          ? const Expanded(child: TeamProjectOverview())
                          : const CalendarView();
                    })
              ])))
    ]));
  }
}

class TeamProjectOverview extends StatelessWidget {
  const TeamProjectOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        mainAxisExtent: 220,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (_, index) => ProjectCardVertical(
        projectName: AppData.productData[index]['projectName'],
        category: AppData.productData[index]['category'],
        color: AppData.productData[index]['color'],
        ratingsUpperNumber: AppData.productData[index]['ratingsUpperNumber'],
        ratingsLowerNumber: AppData.productData[index]['ratingsLowerNumber'],
      ),
      itemCount: 4,
    );
  }
}
