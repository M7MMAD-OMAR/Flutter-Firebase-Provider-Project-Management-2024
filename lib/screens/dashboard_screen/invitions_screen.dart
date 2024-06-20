import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/project_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_main_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/controllers/waiting_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/waiting_sub_tasks_provider.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_member.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_sub_tasks_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:provider/provider.dart';

import '../../models/team/project_model.dart';
import '../../providers/box_provider.dart';
import '../../services/notifications/notification_service.dart';
import '../../widgets/buttons/primary_tab_buttons_widget.dart';
import '../../widgets/dummy/profile_dummy_widget.dart';
import '../../widgets/navigation/app_header_widget.dart';
import '../../widgets/search/active_task_card_widget.dart';
import '../profile/profile_overview_screen.dart';

class InvitationScreen extends StatelessWidget {
  InvitationScreen({super.key});

  final BoxProvider boxProvider = Provider.of<BoxProvider>(context);

  @override
  Widget build(BuildContext context) {
    final settingsButtonTrigger = ValueNotifier(0);
    // boxProvider.selectTab(0);
    return ChangeNotifierProvider<BoxProvider>(
        create: (_) => BoxProvider(),
        child: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SafeArea(
                  child: Consumer<BoxProvider>(
                    builder: (context, boxProvider, child) {
                      return Column(children: [
                        TaskezAppHeader(
                  title: 'الدعوات',
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
                          if (snapshot.hasError) {
                            return const Text("جاري التحميل...");
                          }
                          if (snapshot.hasData) {
                            return ProfileDummy(
                              imageType: ImageType.Network,
                              color: Colors.white,
                              dummyType: ProfileDummyType.Image,
                              image: snapshot.data!.data()!.imageUrl,
                              scale: 1.2,
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                ),
                AppSpaces.verticalSpace20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //tab indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PrimaryTabButton(
                                  callback: () {
                                            boxProvider.selectTab(0);
                                            settingsButtonTrigger.value =
                                                boxProvider.selectedTabIndex;
                                          },
                                  buttonText: 'المهمة في الصندوق',
                                  itemIndex: 0,
                                  notifier: settingsButtonTrigger),
                              PrimaryTabButton(
                                  callback: () {
                                            boxProvider.selectTab(1);
                                            settingsButtonTrigger.value =
                                                boxProvider.selectedTabIndex;
                                          },
                                  buttonText: 'طلبات الانضمام في الصندوق',
                                  itemIndex: 1,
                                  notifier: settingsButtonTrigger),
                            ],
                          ),
                        ]),
                  ),
                ),
                AppSpaces.verticalSpace20,
                Expanded(
                          child: boxProvider.selectedTabIndex == 0
                              ? StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                                  stream: TeamMemberProvider()
                                      .getMemberWhereUserIsStream(
                                  userId: AuthProvider
                                      .firebaseAuth.currentUser!.uid),
                          builder: (context, snapshotMembersforUser) {
                            if (snapshotMembersforUser.hasError) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                        "  ${snapshotMembersforUser.error}",
                                        style: GoogleFonts.fjallaOne(
                                          color: Colors.white,
                                          fontSize: Utils.screenWidth * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (!snapshotMembersforUser.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    //   Icons.heart_broken_outlined,
                                    color: Colors.lightBlue,
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
                                        "جاري التحميل...",
                                        style: GoogleFonts.fjallaOne(
                                          color: Colors.white,
                                          fontSize: Utils.screenWidth * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshotMembersforUser.hasData) {
                              if (snapshotMembersforUser.data!.docs.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
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
                                          'لست عضوًا في أي فريق حتى الآن للحصول على المهام',
                                          style: GoogleFonts.fjallaOne(
                                            color: Colors.white,
                                            fontSize: Utils.screenWidth * 0.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              List<String> membersId = <String>[];
                              List<TeamMemberModel> listMembers =
                                  snapshotMembersforUser.data!.docs
                                      .map((doc) => doc.data())
                                      .toList();
                              for (var member in listMembers) {
                                membersId.add(member.id);
                              }
                              if (snapshotMembersforUser.hasData) {
                                return StreamBuilder<
                                        QuerySnapshot<WaitingSubTaskModel>>(
                                            stream: WaitingSubTasksProvider()
                                                .getWaitingSubTasksInMembersId(
                                            membersId: membersId),
                                    builder:
                                        (context, snapshotOfWaitngSubTasks) {
                                      if (snapshotOfWaitngSubTasks.hasError) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //
                                            Icon(
                                              Icons.search_off,
                                              //   Icons.heart_broken_outlined,
                                              color: Colors.red,
                                              size: Utils.screenWidth * 0.27,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 40),
                                              child: Center(
                                                child: Text(
                                                  snapshotOfWaitngSubTasks.error
                                                      .toString(),
                                                  style: GoogleFonts.fjallaOne(
                                                    color: Colors.white,
                                                    fontSize:
                                                        Utils.screenWidth * 0.1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      if (snapshotOfWaitngSubTasks.hasData) {
                                        List<WaitingSubTaskModel>
                                            listWaitingSubTasks =
                                            snapshotOfWaitngSubTasks.data!.docs
                                                .map((doc) => doc.data())
                                                .toList();

                                        if (snapshotOfWaitngSubTasks
                                            .data!.docs.isEmpty) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search_off,
                                                //   Icons.heart_broken_outlined,
                                                color: Colors.red,
                                                size: Utils.screenWidth * 0.40,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Utils.screenWidth * 0.1,
                                                  // Adjust the percentage as needed
                                                  vertical:
                                                      Utils.screenHeight * 0.05,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'لا توجد دعوات للمهام',
                                                    style:
                                                        GoogleFonts.fjallaOne(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Utils.screenWidth *
                                                              0.1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: snapshotOfWaitngSubTasks
                                              .data!.size,
                                          itemBuilder: (context, index) =>
                                              StreamBuilder<
                                                      DocumentSnapshot<
                                                          ProjectModel>>(
                                                      stream: ProjectProvider()
                                                          .getProjectByIdStream(
                                                          id: listWaitingSubTasks[
                                                                  index]
                                                              .projectSubTaskModel
                                                              .projectId),
                                                  builder: (context,
                                                      snapshotOfProjectMainTask) {
                                                    ProjectModel? projectModel =
                                                        snapshotOfProjectMainTask
                                                            .data!
                                                            .data();
                                                    return StreamBuilder(
                                                        stream: ProjectMainTaskController()
                                                            .getProjectMainTaskByIdStream(
                                                                id: listWaitingSubTasks[
                                                                        index]
                                                                    .projectSubTaskModel
                                                                    .mainTaskId),
                                                        builder: (context,
                                                            snapshotOfMainTask) {
                                                          ProjectMainTaskModel
                                                              projectMainTaskModel =
                                                              snapshotOfMainTask
                                                                  .data!
                                                                  .data()!;
                                                          return Column(
                                                              children: [
                                                                ActiveTaskCard(
                                                                    onPressedEnd:
                                                                        (p0) async {
                                                                      try {
                                                                        showDialogMethod(
                                                                            context);
                                                                            await WaitingSubTasksProvider().rejectSubTask(
                                                                                waitingSubTaskId:
                                                                                listWaitingSubTasks[index].id,
                                                                            rejectingMessage: "rejectingMessage");
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      } on Exception catch (e) {
                                                                        CustomSnackBar.showError(
                                                                            e.toString());
                                                                      }
                                                                    },
                                                                    onPressedStart:
                                                                        (p0) async {
                                                                      try {
                                                                        showDialogMethod(
                                                                            context);
                                                                            await WaitingSubTasksProvider().accpetSubTask(
                                                                          waitingSubTaskId:
                                                                              listWaitingSubTasks[index].id,
                                                                        );

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      } on Exception catch (e) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        CustomSnackBar.showError(
                                                                            e.toString());
                                                                      }
                                                                    },
                                                                    imageUrl:
                                                                        projectModel!
                                                                            .imageUrl,
                                                                    header:
                                                                        projectMainTaskModel
                                                                            .name!,
                                                                    subHeader:
                                                                        projectModel
                                                                            .name!,
                                                                    date:
                                                                        " ${formatFromDate(dateTime: listWaitingSubTasks[index].createdAt, fromat: "MMM")}  ${listWaitingSubTasks[index].createdAt.day}"),
                                                                AppSpaces
                                                                    .verticalSpace10
                                                              ]);
                                                        });
                                                  }),
                                        );
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    });
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          })
                      : StreamBuilder<QuerySnapshot<WaitingMemberModel>>(
                                  stream: WaitingMemberProvider()
                                      .getWaitingMembersInUserIdStream(
                                  userId: AuthProvider
                                      .firebaseAuth.currentUser!.uid),
                          builder: (context, snapshotOfWaithingMembers) {
                            if (!snapshotOfWaithingMembers.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //
                                  Icon(
                                    Icons.search_off,
                                    //   Icons.heart_broken_outlined,
                                    color: Colors.lightBlue,
                                    size: Utils.screenWidth * 0.27,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 40),
                                    child: Center(
                                      child: Text(
                                        "جاري التحميل...",
                                        style: GoogleFonts.fjallaOne(
                                          color: Colors.white,
                                          fontSize: Utils.screenWidth * 0.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshotOfWaithingMembers.hasData) {
                              List<WaitingMemberModel> listWaitingMembers =
                                  snapshotOfWaithingMembers.data!.docs
                                      .map((doc) => doc.data())
                                      .toList();
                              if (snapshotOfWaithingMembers
                                  .data!.docs.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
                                    Icon(
                                      Icons.search_off,
                                      //   Icons.heart_broken_outlined,
                                      color: Colors.red,
                                      size: Utils.screenWidth * 0.40,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Utils.screenWidth * 0.10,
                                          vertical: 20),
                                      child: Center(
                                        child: Text(
                                          "لا توجد دعوة",
                                          style: GoogleFonts.fjallaOne(
                                            color: Colors.white,
                                            fontSize: Utils.screenWidth * 0.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshotOfWaithingMembers.data!.size,
                                itemBuilder: (context, index) => StreamBuilder<
                                        DocumentSnapshot<TeamModel>>(
                                                stream: TeamProvider()
                                                    .getTeamByIdStream(
                                                        id: listWaitingMembers[index].teamId),
                                    builder: (context, snapshotTeam) {
                                      if (!snapshotTeam.hasData) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //
                                            Icon(
                                              Icons.search,
                                              //   Icons.heart_broken_outlined,
                                              color: Colors.lightBlue,
                                              size: Utils.screenWidth * 0.27,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Utils.screenWidth * 0.1,
                                                // Adjust the percentage as needed
                                                vertical:
                                                    Utils.screenHeight * 0.05,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "جاري التحميل...",
                                                  style: GoogleFonts.fjallaOne(
                                                    color: Colors.white,
                                                    fontSize:
                                                        Utils.screenWidth * 0.1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      if (snapshotTeam.hasData) {
                                        TeamModel teamModel =
                                            snapshotTeam.data!.data()!;
                                        return StreamBuilder<
                                                DocumentSnapshot<UserModel>>(
                                                        stream: UserProvider()
                                                            .getUserWhereMangerIsStream(
                                                    mangerId: snapshotTeam.data!
                                                        .data()!
                                                        .managerId),
                                            builder: (context, snapshotOfUser) {
                                              if (!snapshotOfUser.hasData) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    //
                                                    Icon(
                                                      Icons.search,
                                                      //   Icons.heart_broken_outlined,
                                                      color: Colors.lightBlue,
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
                                                          "جاري التحميل...",
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
                                              UserModel? userModel =
                                                  snapshotOfUser.data!.data();
                                              return Column(children: [
                                                ActiveTaskCard(
                                                    onPressedEnd: (p0) async {
                                                      showDialogMethod(context);
                                                                      await WaitingMemberProvider().declineTeamInvite(
                                                              rejectingMessage:
                                                                  "i dont like it",
                                                              waitingMemberId:
                                                                  listWaitingMembers[
                                                                          index]
                                                                      .id);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    onPressedStart: (p0) async {
                                                      showDialogMethod(context);
                                                                      await WaitingMemberProvider().acceptTeamInvite(
                                                              waitingMemberId:
                                                                  listWaitingMembers[
                                                                          index]
                                                                      .id);
                                                    },
                                                    header: teamModel.name!,
                                                    //  header: "Team Name",
                                                    subHeader:
                                                        "مدير :  ${userModel!.name!}",
                                                    //subHeader: "Manager Team Name",
                                                    imageUrl:
                                                        teamModel.imageUrl,
                                                    date:
                                                        " ${formatFromDate(dateTime: listWaitingMembers[index].createdAt, fromat: "MMM")}  ${listWaitingMembers[index].createdAt.day}"),
                                                //   " ${formatFromDate(dateTime: DateTime.now(), fromat: "MMM")}  ${DateTime.now().day}"),
                                                AppSpaces.verticalSpace10
                                              ]);
                                            });
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                )
              ]);
            },
          ),
                ))));
  }
}

String formatFromDate({required DateTime dateTime, required String fromat}) {
  return DateFormat(fromat).format(dateTime);
}
