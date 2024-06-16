// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/statusController.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/in_bottomsheet_subtitle_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Navigation/app_header_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Projects/project_card_vertical_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Team/more_team_details_sheet_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Team/show_team_members_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/table_calendar_widget.dart';

import 'my_team_screen.dart';

class TeamDetails extends StatelessWidget {
  final String title;
  TeamModel? team;
  TeamDetails(
      {Key? key,
      required this.title,
      required this.team,
      required this.userAsManager})
      : super(key: key);
  final ManagerModel? userAsManager;

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
            child: StreamBuilder<DocumentSnapshot<TeamModel>>(
                stream: TeamController().getTeamByIdStream(id: team!.id),
                builder: (context, snapshotTeam) {
                  if (snapshotTeam.hasError) {
                    return Center(
                      child: Text(
                        snapshotTeam.error.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  }
                  if (snapshotTeam.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshotTeam.hasData) {
                    team = snapshotTeam.data!.data()!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskezAppHeader(
                          title:
                              "$tabSpace ${AppConstants.details_key.tr} ${AppConstants.team_key.tr}",
                          widget: Visibility(
                            visible: userAsManager != null &&
                                team!.managerId == userAsManager!.id,
                            child: InkWell(
                              onTap: () {
                                showAppBottomSheet(
                                  Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: SizedBox(
                                        height: Utils.screenHeight * 0.9,
                                        child: MoreTeamDetailsSheet(
                                          userAsManager: userAsManager,
                                          teamModel: team!,
                                        )),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: const Icon(Icons.more_horiz,
                                  size: 30, color: Colors.white),
                            ),
                          ),
                        ),
                        AppSpaces.verticalSpace40,
                        StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                            stream: TeamMemberController()
                                .getMembersInTeamIdStream(teamId: team!.id),
                            builder: (context, snapshotMembers) {
                              List<String> listIds = [];

                              if (snapshotMembers.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              for (var member in snapshotMembers.data!.docs) {
                                listIds.add(member.data().userId);
                              }
                              if (listIds.isEmpty) {
                                return TeamStory(
                                    userAsManager: userAsManager,
                                    onTap: () {
                                      Get.to(() => ShowTeamMembers(
                                            teamModel: team!,
                                            userAsManager: userAsManager,
                                          ));
                                    },
                                    teamModel: team!,
                                    users: <UserModel>[],
                                    teamTitle: snapshotTeam.data!.data()!.name!,
                                    numberOfMembers: 0.toString(),
                                    noImages: 0.toString());
                                // buildStackedImages(
                                //   addMore: true,
                                //   numberOfMembers: 0.toString(),
                                //   users: <UserModel>[],
                                //   onTap: () {
                                //
                                //   },
                                // );
                              }
                              return StreamBuilder<QuerySnapshot<UserModel>>(
                                  stream: UserController()
                                      .getUsersWhereInIdsStream(
                                          usersId: listIds),
                                  builder: (context, snapshotUsers) {
                                    if (snapshotUsers.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    List<UserModel> users = [];
                                    for (var element
                                        in snapshotUsers.data!.docs) {
                                      users.add(element.data());
                                    }
                                    return TeamStory(
                                        userAsManager: userAsManager,
                                        onTap: () {
                                          Get.to(() => ShowTeamMembers(
                                                teamModel: team!,
                                                userAsManager: userAsManager,
                                              ));
                                        },
                                        teamModel: team!,
                                        users: users,
                                        teamTitle:
                                            snapshotTeam.data!.data()!.name!,
                                        numberOfMembers: snapshotUsers
                                            .data!.docs.length
                                            .toString(),
                                        noImages: snapshotUsers
                                            .data!.docs.length
                                            .toString());
                                  });
                            }),
                        AppSpaces.verticalSpace10,
                        FutureBuilder<UserModel>(
                            future: UserController().getUserWhereMangerIs(
                                mangerId: team!.managerId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    "There is an error ${snapshot.error}");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              return InBottomSheetSubtitle(
                                  title:
                                      " ${AppConstants.managed_by_key.tr} ${snapshot.data!.name} ${AppConstants.that_created_the_team_on_key.tr} ${snapshotTeam.data!.data()!.createdAt.month}/${snapshotTeam.data!.data()!.createdAt.day}  ${AppConstants.of_key.tr} ${snapshotTeam.data!.data()!.createdAt.year}",
                                  textStyle: GoogleFonts.lato(
                                      fontSize: Utils.screenHeight * 0.045,
                                      color: Colors.white70));
                            }),
                        AppSpaces.verticalSpace40,
                        ValueListenableBuilder(
                          valueListenable: settingsButtonTrigger,
                          builder: (BuildContext context, _, __) {
                            return settingsButtonTrigger.value == 0
                                ? Expanded(
                                    child: TeamProjectOverview(
                                    teamModel: team!,
                                  ))
                                : const CalendarView();
                          },
                        )
                      ],
                    );
                  }
                  return Center(
                    child: Text(
                      snapshotTeam.error.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Utils.screenHeight * 0.05),
                    ),
                  );
                }),
          ),
        )
      ]),
    );
  }
}

class TeamProjectOverview extends StatelessWidget {
  final TeamModel teamModel;
  const TeamProjectOverview({
    required this.teamModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<ProjectModel>>(
        stream:
            ProjectController().getProjectsOfTeamStream(teamId: teamModel.id),
        builder: (context, snapshotProject) {
          if (snapshotProject.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshotProject.error}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 39,
                ),
              ),
            );
          }

          if (snapshotProject.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final projects = snapshotProject.data!.docs.toList();
          if (projects.isEmpty) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Iconsax.task,
                      size: Utils.screenWidth * 0.4,
                      color: HexColor.fromHex("#999999"),
                    ),
                    AppSpaces.verticalSpace10,
                    Text(
                      "${AppConstants.no_projects_for_key.tr}  ${teamModel.name} ",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: HexColor.fromHex("#999999"),
                          fontSize: Utils.screenWidth * 0.05,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ]),
            );
          }
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //change
                crossAxisCount: 2,
                mainAxisSpacing: 10,

                //change height 125
                mainAxisExtent: 240,
                crossAxisSpacing: 10,
              ),
              itemCount: snapshotProject.data!.size,
              itemBuilder: (_, index) {
                final teamId = snapshotProject.data!.docs[index].data().teamId!;
                return StreamBuilder<DocumentSnapshot<TeamModel>>(
                    stream: TeamController().getTeamByIdStream(id: teamId),
                    builder: (context, snapshotTeam) {
                      if (snapshotTeam.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshotTeam.error}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 39,
                            ),
                          ),
                        );
                      }

                      if (snapshotTeam.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final teamName = snapshotTeam.data?.data()?.name ?? '';

                      return StreamBuilder<DocumentSnapshot<StatusModel>>(
                        stream: StatusController().getStatusByIdStream(
                          idk:
                              snapshotProject.data!.docs[index].data().statusId,
                        ),
                        builder: (context, snapshotStatus) {
                          if (snapshotStatus.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshotStatus.error}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 39,
                                ),
                              ),
                            );
                          }

                          if (snapshotStatus.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          final status = snapshotStatus.data!.data()!.name;
                          return ProjectCardVertical(
                            idk: snapshotProject.data!.docs[index].data().id,
                            status: status!,
                            projeImagePath: snapshotProject.data!.docs[index]
                                .data()
                                .imageUrl,
                            projectName:
                                snapshotProject.data!.docs[index].data().name!,
                            teamName: teamName,
                            endDate: snapshotProject.data!.docs[index]
                                .data()
                                .endDate!,
                            startDate: snapshotProject.data!.docs[index]
                                .data()
                                .startDate,
                          );
                        },
                      );
                    });
              });
        });
  }
}
