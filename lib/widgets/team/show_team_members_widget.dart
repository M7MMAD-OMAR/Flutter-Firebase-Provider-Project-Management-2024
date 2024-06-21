import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/controllers/waiting_member_provider.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/screens/Projects/search_for_members_screen.dart';
import 'package:project_management_muhmad_omar/widgets/active_employee_card_widget.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/inactive_employee_card_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

import '../dummy/profile_dummy_widget.dart';

class ShowTeamMembers extends StatelessWidget {
  final TeamModel teamModel;
  final ManagerModel? userAsManager;

  const ShowTeamMembers({
    required this.userAsManager,
    required this.teamModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(
                left:
                    Utils.screenWidth * 0.04, // Adjust the percentage as needed
                right: Utils.screenWidth * 0.04,
              ),
              child: TaskezAppHeader(
                title: "الأعضاء",
                widget: GestureDetector(
                  onTap: () async {
                    //TODO:

                    // bool fcmStutas =
                    //     await FcmNotifications.getNotificationStatus();
                    // Get.to(() => ProfileOverview(
                    //       isSelected: fcmStutas,
                    //     ));
                  },
                  child: FutureBuilder<UserModel>(
                      future: UserProvider().getUserWhereMangerIs(
                          mangerId: userAsManager?.id ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return GestureDetector(
                          onTap: () {
                            CustomDialog.userInfoDialog(
                                title: "قائد الفريق",
                                imageUrl: snapshot.data!.imageUrl,
                                name: snapshot.data!.name!,
                                userName: snapshot.data!.userName!,
                                bio: snapshot.data!.bio);
                          },
                          child: ProfileDummy(
                            imageType: ImageType.Network,
                            color: Colors.white,
                            dummyType: ProfileDummyType.Image,
                            image: snapshot.data!.imageUrl,
                            scale: 1.2,
                          ),
                        );
                      }),
                ),
              ),
            ),
            AppSpaces.verticalSpace40,
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecorationStyles.fadingGlory,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: DecoratedBox(
                    decoration: BoxDecorationStyles.fadingInnerDecor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpaces.verticalSpace20,
                            Expanded(
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child:
                                    StreamBuilder<
                                            QuerySnapshot<TeamMemberModel>>(
                                        stream: TeamMemberProvider()
                                            .getMembersInTeamIdStream(
                                                teamId: teamModel.id),
                                        builder:
                                            (context, snapshotTeamMembers) {
                                          List<String> usersId = [];
                                          if (snapshotTeamMembers
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (snapshotTeamMembers.hasError) {
                                            return Center(
                                              child: Text(
                                                  snapshotTeamMembers.error
                                                      .toString(),
                                                  style: const TextStyle(
                                                      backgroundColor:
                                                          Colors.red)),
                                            );
                                          }
                                          for (var member in snapshotTeamMembers
                                              .data!.docs) {
                                            usersId.add(member.data().userId);
                                          }
                                          return StreamBuilder<
                                              QuerySnapshot<
                                                  WaitingMemberModel>>(
                                            stream: WaitingMemberProvider()
                                                .getWaitingMembersInTeamIdStream(
                                                    teamId: teamModel.id),
                                            builder:
                                                (context, snapShotWatingUsers) {
                                              if (snapShotWatingUsers
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }

                                              if (snapShotWatingUsers.hasData) {
                                                for (var member
                                                    in snapShotWatingUsers
                                                        .data!.docs) {
                                                  usersId.add(
                                                      member.data().userId);
                                                }
                                              }
                                              if (usersId.isEmpty) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
//
                                                    Icon(
                                                      Icons.search_off,
                                                      color: Colors.red,
                                                      size: Utils.screenWidth *
                                                          0.27,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            Utils.screenWidth *
                                                                0.1,
                                                        // Adjust the percentage as needed
                                                        vertical:
                                                            Utils.screenHeight *
                                                                0.05,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'لا يوجد أي أعضاء حتى الآن',
                                                          style: GoogleFonts
                                                              .fjallaOne(
                                                            color: Colors.white,
                                                            fontSize: Utils
                                                                    .screenWidth *
                                                                0.1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }
                                              return StreamBuilder<
                                                      QuerySnapshot<UserModel>>(
                                                  stream: UserProvider()
                                                      .getUsersWhereInIdsStream(
                                                          usersId: usersId),
                                                  builder:
                                                      (context, snapshotUsers) {
                                                    if (snapshotUsers
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    }
                                                    return ListView.builder(
                                                      itemCount: snapshotUsers
                                                          .data!.size,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 3,
                                                                  vertical: 6),
                                                          child: Slidable(
                                                            endActionPane: userAsManager !=
                                                                        null &&
                                                                    teamModel
                                                                            .managerId ==
                                                                        userAsManager
                                                                            ?.id
                                                                ? index <
                                                                        snapshotTeamMembers
                                                                            .data!
                                                                            .size
                                                                    ? ActionPane(
                                                                        motion:
                                                                            StretchMotion(),
                                                                        children: [
                                                                            SlidableAction(
                                                                              backgroundColor: Colors.red,
                                                                              borderRadius: BorderRadius.circular(16),
                                                                              onPressed: (context) {
                                                                                CustomDialog.showConfirmDeleteDialog(
                                                                                    onDelete: () async {
                                                                                      await TeamMemberProvider().deleteMember(id: snapshotTeamMembers.data!.docs[index].data().id);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    content: Text("هل أنت متأكد من رغبتك في حذف هذه المهمة؟ ${snapshotUsers.data!.docs[index].data().name} من هذا الفريق ؟"));
                                                                              },
                                                                              label: "حذف",
                                                                              icon: FontAwesomeIcons.trash,
                                                                            ),
                                                                          ])
                                                                    : ActionPane(
                                                                        motion:
                                                                            StretchMotion(),
                                                                        children: [
                                                                            SlidableAction(
                                                                              backgroundColor: Colors.red,
                                                                              borderRadius: BorderRadius.circular(16),
                                                                              onPressed: (context) async {
                                                                                showDialogMethod(context);
                                                                                await WaitingMemberProvider().deleteWaitingMamberDoc(waitingMemberId: snapShotWatingUsers.data!.docs[index].data().id);
                                                                                Navigator.pop(context);
                                                                              },
                                                                              label: 'حذف',
                                                                              icon: FontAwesomeIcons.trash,
                                                                            ),
                                                                          ])
                                                                : null,
                                                            startActionPane: index <
                                                                    snapshotTeamMembers
                                                                        .data!
                                                                        .size
                                                                ? userAsManager !=
                                                                            null &&
                                                                        teamModel.managerId ==
                                                                            userAsManager?.id
                                                                    ? null
                                                                    : null
                                                                : null,
                                                            child: index <
                                                                    snapshotTeamMembers
                                                                        .data!
                                                                        .size
                                                                ? ActiveEmployeeCard(
                                                                    onTap: () {
                                                                      CustomDialog.userInfoDialog(
                                                                          title:
                                                                              'عضو',
                                                                          imageUrl: snapshotUsers
                                                                              .data!
                                                                              .docs[
                                                                                  index]
                                                                              .data()
                                                                              .imageUrl,
                                                                          name: snapshotUsers
                                                                              .data!
                                                                              .docs[
                                                                                  index]
                                                                              .data()
                                                                              .name!,
                                                                          userName: snapshotUsers
                                                                              .data!
                                                                              .docs[
                                                                                  index]
                                                                              .data()
                                                                              .userName!,
                                                                          bio: snapshotUsers
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()
                                                                              .bio);
                                                                    },
                                                                    notifier:
                                                                        null,
                                                                    userImage: snapshotUsers
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()
                                                                        .imageUrl,
                                                                    userName: AuthProvider.firebaseAuth.currentUser!.uid ==
                                                                            snapshotUsers.data!.docs[index]
                                                                                .data()
                                                                                .id
                                                                        ? 'أنت'
                                                                        : snapshotUsers
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()
                                                                            .name!,
                                                                    color: null,
                                                                    bio: snapshotUsers
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()
                                                                            .bio ??
                                                                        " ",
                                                                  )
                                                                : Visibility(
                                                                    visible: userAsManager !=
                                                                            null &&
                                                                        teamModel.managerId ==
                                                                            userAsManager?.id,
                                                                    child:
                                                                        InactiveEmployeeCardWidget(
                                                                      onTap:
                                                                          () {
                                                                        CustomDialog.userInfoDialog(
                                                                            title:
                                                                                'مدعو (ليس عضوًا بعد)',
                                                                            imageUrl:
                                                                                snapshotUsers.data!.docs[index].data().imageUrl,
                                                                            name: snapshotUsers.data!.docs[index].data().name!,
                                                                            userName: snapshotUsers.data!.docs[index].data().userName!,
                                                                            bio: snapshotUsers.data!.docs[index].data().bio);
                                                                      },
                                                                      userName: AuthProvider.firebaseAuth.currentUser!.uid == snapshotUsers.data!.docs[index].data().id
                                                                          ? 'أنت'
                                                                          : snapshotUsers
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()
                                                                              .name!,
                                                                      color:
                                                                          null,
                                                                      userImage: snapshotUsers
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()
                                                                          .imageUrl,
                                                                      bio: snapshotUsers
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()
                                                                              .bio ??
                                                                          "",
                                                                    ),
                                                                  ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                            },
                                          );
                                        }),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            //AppSpaces.verticalSpace20,
            Visibility(
              visible: userAsManager != null &&
                  teamModel.managerId == userAsManager?.id,
              child: AppPrimaryButton(
                  buttonHeight: 50,
                  buttonWidth: 150,
                  buttonText: 'إضافة عضو',
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SearchForMembersScreen(
                                  teamModel: teamModel,
                                  users: null,
                                  newTeam: false,
                                )));
                  }),
            ),
            AppSpaces.verticalSpace20,
          ]),
        ),
      ]),
    );
  }
}
