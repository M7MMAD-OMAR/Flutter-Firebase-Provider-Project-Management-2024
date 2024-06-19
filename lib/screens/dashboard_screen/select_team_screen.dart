import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/widgets/Team/active_team_cardK_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dummy/profile_dummy_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';

import '../profile/profile_overview_screen.dart';
import '../profile/team_details_screen.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({
    super.key,
    required this.title,
    required this.managerModel,
  });

  final ManagerModel? managerModel;
  final String title;

  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
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
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TaskezAppHeader(
                    title: widget.title,
                    widget: GestureDetector(
                      onTap: () async {
                        bool fcmStatus = await FcmNotificationsProvider
                            .getNotificationStatus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileOverviewScreen(
                                      isSelected: fcmStatus,
                                    )));
                      },
                      child: StreamBuilder<DocumentSnapshot<UserModel>>(
                          stream: UserController().getUserByIdStream(
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot<TeamModel>>(
                    stream: TeamController().getTeamsofMemberWhereUserIdStream(
                        userId: AuthProvider.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final teams = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              final team = teams[index];

                              return StreamBuilder<
                                  QuerySnapshot<TeamMemberModel>>(
                                stream: TeamMemberController()
                                    .getMembersInTeamIdStream(teamId: team.id),
                                builder: (context, memberSnapshot) {
                                  if (memberSnapshot.hasData) {
                                    final membersCount =
                                        memberSnapshot.data!.docs.length;
                                    return ActiveTeamCard(
                                      imageType: ImageType.Network,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    TeamDetailsScreen(
                                                      userAsManager:
                                                          widget.managerModel,
                                                      title: team.name!,
                                                      team: team,
                                                    )));
                                      },
                                      team: team,
                                      numberOfMembers: membersCount,
                                      teamName: team.name!,
                                      teamImage: team.imageUrl,
                                    );
                                  } else if (memberSnapshot.hasError) {
                                    return Text(
                                      'Error: ${memberSnapshot.error.toString().substring(11)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 39,
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
                            const Icon(
                              Icons.search_off,
                              //   Icons.heart_broken_outlined,
                              color: Colors.red,
                              size: 120,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 40),
                              child: Center(
                                child: Text(
                                  snapshot.error.toString().substring(11),
                                  style: GoogleFonts.fjallaOne(
                                    color: Colors.white,
                                    fontSize: 40,
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
                AppSpaces.verticalSpace20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
