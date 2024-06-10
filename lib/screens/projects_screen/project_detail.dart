import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/widgets/layout_list_tile.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/widgets/project_detail_appbar.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/widgets/project_task_card.dart';
import 'package:project_management_muhmad_omar/widgets/Buttons/primary_tab_buttons.dart';
import 'package:project_management_muhmad_omar/widgets/Shapes/app_settings_icon.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background.dart';

class ProjectDetails extends StatelessWidget {
  final String color;
  final String projectName;
  final String category;

  ProjectDetails(
      {Key? key,
      required this.color,
      required this.projectName,
      required this.category})
      : super(key: key);

  ValueNotifier<int> _settingsButtonTrigger = ValueNotifier(0);
  ValueNotifier<int> _layoutButtonTrigger = ValueNotifier(0);

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
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProjectDetailAppBar(
                      category: category,
                      color: color,
                      iconTapped: (() {
                        showSettingsBottomSheet();
                      }),
                      projectName: projectName,
                    ),
                    AppSpaces.verticalSpace20,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PrimaryTabButton(
                                  buttonText: "All Tasks",
                                  itemIndex: 0,
                                  notifier: _settingsButtonTrigger),
                              PrimaryTabButton(
                                  buttonText: "Recent",
                                  itemIndex: 1,
                                  notifier: _settingsButtonTrigger),
                              PrimaryTabButton(
                                  buttonText: "Starred",
                                  itemIndex: 2,
                                  notifier: _settingsButtonTrigger)
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              child: AppSettingsIcon(
                                callback: (() {
                                  _showLayoutDialog(context);
                                }),
                              ))
                        ]),
                    AppSpaces.verticalSpace10,
                    Expanded(
                        child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(children: [
                        AppSpaces.verticalSpace10,
                        ExpansionTile(
                            initiallyExpanded: true,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            textColor: Colors.white,
                            title: Text("IDEAS (3)",
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor.fromHex("616575"),
                                )),
                            children: [
                              const ProjectTaskCard(
                                  activated: true,
                                  header: "Orientation",
                                  image: "assets/memoji/2.png",
                                  backgroundColor: "FCA4FF",
                                  date: "Today 12:00PM"),
                              const ProjectTaskCard(
                                  activated: true,
                                  header: "Client Briefing",
                                  image: "assets/man-head.png",
                                  backgroundColor: "93F0F0",
                                  date: "Today 3:00PM"),
                              const ProjectTaskCard(
                                  activated: false,
                                  header: "WireFraming",
                                  image: "assets/memoji/9.png",
                                  backgroundColor: "8D96FF",
                                  date: "Tomorrow 4:15PM"),
                            ]),
                        AppSpaces.verticalSpace10,
                        ExpansionTile(
                            initiallyExpanded: true,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            textColor: Colors.white,
                            title: Text("DESIGN (12)",
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor.fromHex("616575"),
                                )),
                            children: const [
                              ProjectTaskCard(
                                  activated: false,
                                  header: "Onboarding Screens",
                                  image: "assets/memoji/2.png",
                                  backgroundColor: "FCA4FF",
                                  date: "Today 12:00PM"),
                              ProjectTaskCard(
                                  activated: false,
                                  header: "Sign In - Sign Up",
                                  image: "assets/man-head.png",
                                  backgroundColor: "93F0F0",
                                  date: "Today 3:00PM"),
                              ProjectTaskCard(
                                  activated: false,
                                  header: "WireFraming",
                                  image: "assets/memoji/9.png",
                                  backgroundColor: "8D96FF",
                                  date: "Tomorrow 4:15PM"),
                            ])
                      ]),
                    ))
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  _showLayoutDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: const EdgeInsets.only(bottom: 500),
          backgroundColor: HexColor.fromHex("262A34"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          children: [
            LayoutListTile(
              notifier: _layoutButtonTrigger,
              index: 0,
              icon: Icons.checklist,
              title: 'List',
            ),
            Divider(height: 1, color: HexColor.fromHex("353742")),
            LayoutListTile(
              notifier: _layoutButtonTrigger,
              index: 1,
              icon: Icons.dashboard,
              title: 'Board',
            ),
          ],
          /* ... */
        );
      },
    );
  }
}
