import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/team_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/add_team_to_create_project_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/add_user_to_team_provider.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/dashboard_meeting_details_widget.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:provider/provider.dart';

import '../profile/profile_overview_screen.dart';

enum TeamSortOption {
  name,
  createDate,
  updatedDate,
  // numbersOfMembers
  // Add more sorting options if needed
}

class TeamInfo {
  final TeamModel team;
  int? membersNumber;

  TeamInfo(this.team, this.membersNumber);

  static List<TeamModel> sortTeams(
      {required List<TeamModel> teams,
      required TeamSortOption sortOption,
      bool ascending = true}) {
    switch (sortOption) {
      case TeamSortOption.name:
        teams.sort((a, b) => a.name!.compareTo(b.name!));
        break;
      case TeamSortOption.createDate:
        teams.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TeamSortOption.updatedDate:
        teams.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
    }

    if (!ascending) {
      teams = teams.reversed.toList();
    }
    return teams;
  }
}

class SelectMyTeamsScreen extends StatefulWidget {
  SelectMyTeamsScreen({super.key, required this.title});
  final String title;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  DashboardMeetingDetailsProvider controller =
      Provider.of<DashboardMeetingDetailsProvider>(context);

  AddTeamToCreatProjectProvider addTeamToCreatProjectScreen =
      Provider.of<AddTeamToCreatProjectProvider>(context);

  @override
  State<SelectMyTeamsScreen> createState() => _SelectMyTeamsScreenState();
}

class _SelectMyTeamsScreenState extends State<SelectMyTeamsScreen> {
  @override
  void initState() {
    UserProvider.users.clear();
    addTeamToCreatProjectScreen.teams.clear();

    super.initState();
  }


  TeamSortOption selectedSortOption = TeamSortOption.name;

  String _getSortOptionText(TeamSortOption option) {
    switch (option) {
      case TeamSortOption.name:
        return "الاسم";
      case TeamSortOption.updatedDate:
        return "تاريح التحديث";
      case TeamSortOption.createDate:
        return "تاريخ الإنشاء";

      // Add cases for more sorting options if needed
      default:
        return '';
    }
  }

  bool sortAscending = true; // Variable for sort order
  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending; // Toggle the sort order
    });
  }

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
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: Utils.screenWidth *
                        0.05, // Adjust the percentage as needed
                    left: Utils.screenWidth *
                        0.05, // Adjust the percentage as needed
                  ),
                  child: TaskezAppHeader(
                    title: widget.title,
                    widget: GestureDetector(
                      onTap: () async {
                        bool fcmStutas = await FcmNotificationsProvider
                            .getNotificationStatus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileOverviewScreen(
                                      isSelected: fcmStutas,
                                    )));
                      },
                      child: StreamBuilder<DocumentSnapshot<UserModel>>(
                          stream: UserProvider().getUserByIdStream(
                              id: AuthProvider.firebaseAuth.currentUser!.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            return ProfileDummy(
                              imageType: ImageType.Network,
                              color: Colors.white,
                              dummyType: ProfileDummyType.Image,
                              image: snapshot.data!.data()!.imageUrl,
                              scale: 1.2,
                            );
                          }),
                    ),
                  ),
                ),
                AppSpaces.verticalSpace40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: Utils.screenWidth *
                            0.05, // Adjust the percentage as needed
                        left: Utils.screenWidth *
                            0.05, // Adjust the percentage as needed
                      ),
                      padding: EdgeInsets.only(
                        right: Utils.screenWidth *
                            0.04, // Adjust the percentage as needed
                        left: Utils.screenWidth *
                            0.02, // Adjust the percentage as needed
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<TeamSortOption>(
                        value: selectedSortOption,
                        onChanged: (TeamSortOption? newValue) {
                          setState(() {
                            selectedSortOption = newValue!;
                            // Implement the sorting logic here
                          });
                        },
                        items:
                            TeamSortOption.values.map((TeamSortOption option) {
                          return DropdownMenuItem<TeamSortOption>(
                            value: option,
                            child: Text(
                              _getSortOptionText(option),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),

                        // Add extra styling
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: Utils.screenWidth *
                              0.08, // Adjust the percentage as needed
                        ),
                        underline: const SizedBox(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: Utils.screenWidth *
                            0.02, // Adjust the percentage as needed
                        left: Utils.screenWidth *
                            0.035, // Adjust the percentage as needed
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          width: Utils.screenWidth *
                              0.006, // Adjust the percentage as needed
                          color: HexColor.fromHex("616575"),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.white,
                        ),
                        onPressed: toggleSortOrder, // Toggle the sort order
                      ),
                    ),
                  ],
                ),
                AppSpaces.verticalSpace20,
                Expanded(
                  child: StreamBuilder<QuerySnapshot<TeamModel>?>(
                    stream: TeamProvider().getTeamsOfUserStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TeamModel> teams = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        switch (selectedSortOption) {
                          case TeamSortOption.name:
                            teams.sort((a, b) => a.name!.compareTo(b.name!));
                            break;
                          case TeamSortOption.createDate:
                            teams.sort(
                                (a, b) => a.createdAt.compareTo(b.createdAt));
                            break;
                          case TeamSortOption.updatedDate:
                            teams.sort(
                                (a, b) => a.updatedAt.compareTo(b.updatedAt));
                            break;
                        }

                        if (!sortAscending) {
                          teams = teams.reversed.toList();
                        }
                        if (teams.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.task,
                                  size: Utils.screenWidth * 0.3,
                                  color: HexColor.fromHex("#999999"),
                                ),
                                AppSpaces.verticalSpace10,
                                Text(
                                  'لا توجد فرق، قم بإضافة فريق للبدء',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: HexColor.fromHex("#999999"),
                                      fontSize: Utils.screenWidth * 0.065,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              final team = teams[index];
                              return StreamBuilder<
                                  QuerySnapshot<TeamMemberModel>>(
                                stream: TeamMemberProvider()
                                    .getMembersInTeamIdStream(teamId: team.id),
                                builder: (context, memberSnapshot) {
                                  if (memberSnapshot.hasData) {
                                    final membersCount =
                                        memberSnapshot.data!.docs.length;
                                    return Text("jj");
                                    // for (var element in teamInfos) {
                                    //   element.membersNumber = membersCount;
                                    // }
                                    // teamInfos = TeamInfo.sortTeams(
                                    //     teams: teamInfos,
                                    //     sortOption: selectedSortOption,
                                    //     ascending: sortAscending);

                                    // return Padding(
                                    //   padding: const EdgeInsets.all(3),
                                    //   child: Slidable(
                                    //     endActionPane: ActionPane(
                                    //         extentRatio: .30,
                                    //         motion: const StretchMotion(),
                                    //         children: [
                                    //           SlidableAction(
                                    //             label:
                                    //                 'حذف',
                                    //             borderRadius:
                                    //                 BorderRadius.circular(30),
                                    //             backgroundColor: Colors.red,
                                    //             icon: FontAwesomeIcons.trash,
                                    //             onPressed: (context) async {
                                    //               try {
                                    //
                                    //                 // showDialogMethod(context);
                                    //
                                    //                 List<ProjectModel>
                                    //                     projects =
                                    //                     await ProjectController()
                                    //                         .getProjectsOfTeamKarem(
                                    //                             teamId:
                                    //                                 team.id);
                                    //                 List<String> projectsIds =
                                    //                     <String>[];
                                    //                 for (var element
                                    //                     in projects) {
                                    //                   projectsIds
                                    //                       .add(element.id);
                                    //                 }
                                    //                 await TeamController()
                                    //                     .deleteTeam(
                                    //                         id: team.id,
                                    //                         projectIds:
                                    //                             projectsIds);
                                    //
                                    //
                                    //                 CustomSnackBar.showSuccess(
                                    //                     AppConstants
                                    //                         .team_deleted_successfully_key
                                    //                         .tr);
                                    //               } on Exception catch (e) {
                                    //                 Navigator.of(context).pop();
                                    //                 CustomSnackBar.showError(
                                    //                     e.toString());
                                    //                 // TODO
                                    //               }
                                    //             },
                                    //           ),
                                    //         ]),
                                    //     startActionPane: ActionPane(
                                    //         extentRatio: .30,
                                    //         motion: const StretchMotion(),
                                    //         children: [
                                    //           SlidableAction(
                                    //             label:
                                    //                 AppConstants.details_key.tr,
                                    //             borderRadius:
                                    //                 BorderRadius.circular(30),
                                    //             backgroundColor: Colors.blue,
                                    //             icon:
                                    //                 FontAwesomeIcons.tableList,
                                    //             onPressed: (context) async {
                                    //               showDialogMethod(context);
                                    //               ManagerModel? userAsManger =
                                    //                   await ManagerController()
                                    //                       .getMangerWhereUserIs(
                                    //                           userId: AuthService
                                    //
                                    //                               .firebaseAuth
                                    //                               .currentUser!
                                    //                               .uid);
                                    //
                                    //               Navigator.pop(context);
                                    //
                                    //               Get.to(() => TeamDetails(
                                    //                   title: team.name!,
                                    //                   team: team,
                                    //                   userAsManager:
                                    //                       userAsManger));
                                    //
                                    //             },
                                    //           ),
                                    //         ]),
                                    //     child: Padding(
                                    //       padding: EdgeInsets.symmetric(
                                    //         horizontal: Utils.screenWidth *
                                    //             0.02, // Adjust the percentage as needed
                                    //       ),
                                    //       child: ActiveTeamCard(
                                    //         imageType: ImageType.Network,
                                    //         onTap: () {
                                    //           if (widget.title !=
                                    //               AppConstants
                                    //                   .manager_teams_key.tr) {
                                    //
                                    //             addTeamToCreatProjectScreen
                                    //                 .addUser(team);
                                    //
                                    //
                                    //             addTeamToCreatProjectScreen
                                    //                 .update();
                                    //             Get.close(1);
                                    //           }
                                    //         },
                                    //         team: team,
                                    //         numberOfMembers: membersCount,
                                    //         teamName: team.name!,
                                    //         teamImage: team.imageUrl,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // );
                                  } else if (memberSnapshot.hasError) {
                                    return Text(
                                      'خطأ ${memberSnapshot.error}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Utils.screenWidth * 0.1,
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
//                             Container(
// //width: 100,
//                               height: 75,
//                               child: Image.asset("assets/icon/error.png"),
//                             ),
                            Icon(
                              Icons.search_off,
                              //   Icons.heart_broken_outlined,
                              color: Colors.red,
                              size: Utils.screenWidth * 0.27,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Utils.screenWidth *
                                    0.1, // Adjust the percentage as needed
                                vertical: Utils.screenHeight * 0.05,
                              ),
                              child: Center(
                                child: Text(
                                  snapshot.error.toString().substring(11),
                                  style: GoogleFonts.fjallaOne(
                                    color: Colors.white,
                                    fontSize: Utils.screenWidth * 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                AppPrimaryButton(
                  buttonHeight: Utils.screenHeight *
                      0.12, // Adjust the percentage as needed
                  buttonWidth: Utils.screenWidth * 0.4,
                  buttonText: 'إنشاء فريق جديد',
                  callback: () {
                    DashboardMeetingDetailsWidget.users = [];
                    Navigator.pushNamed(
                        context, Routes.dashboardMeetingDetailsScreen);
                  },
                ),
                AppSpaces.verticalSpace20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
