import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/project_main_task_controller.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/controllers/waitingMamberController.dart';
import 'package:project_management_muhmad_omar/controllers/waitingSubTasks.dart';
import 'package:project_management_muhmad_omar/models/User/User_model.dart';
import 'package:project_management_muhmad_omar/models/team/Project_main_task_Model.dart';
import 'package:project_management_muhmad_omar/models/team/TeamMembers_model.dart';
import 'package:project_management_muhmad_omar/models/team/Team_model.dart';
import 'package:project_management_muhmad_omar/models/team/waitingMamber.dart';
import 'package:project_management_muhmad_omar/models/team/waitingSubTasksModel.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/widgets/Snackbar/custom_snackber.dart';

import '../../Values/values.dart';
import '../../models/team/Project_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/Buttons/primary_tab_buttons.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/Search/active_task_card.dart';
import '../../widgets/dummy/profile_dummy.dart';
import '../Profile/profile_overview.dart';
import 'DashboardTabScreens/boxController.dart';

class Invitions extends StatelessWidget {
  Invitions({Key? key}) : super(key: key);
  final BoxController boxController = Get.put(BoxController());

  @override
  Widget build(BuildContext context) {
    final settingsButtonTrigger = ValueNotifier(0);
    boxController.selectTab(0);
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: GetBuilder<BoxController>(
            init: BoxController(),
            builder: (controller) {
              return Column(children: [
                TaskezAppHeader(
                  title: AppConstants.invitations_key.tr,
                  widget: GestureDetector(
                    onTap: () async {
                      bool fcmStutas =
                          await FcmNotifications.getNotificationStatus();
                      Get.to(() => ProfileOverview(
                            isSelected: fcmStutas,
                          ));
                    },
                    child: StreamBuilder<DocumentSnapshot<UserModel>>(
                        stream: UserController().getUserByIdStream(
                            id: AuthService
                                .instance.firebaseAuth.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(AppConstants.loading_key.tr);
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
                                    boxController.selectTab(0);
                                    settingsButtonTrigger.value =
                                        controller.selectedTabIndex.value;
                                  },
                                  buttonText: AppConstants.task_in_box_key.tr,
                                  itemIndex: 0,
                                  notifier: settingsButtonTrigger),
                              PrimaryTabButton(
                                  callback: () {
                                    boxController.selectTab(1);
                                    settingsButtonTrigger.value =
                                        controller.selectedTabIndex.value;
                                  },
                                  buttonText:
                                      AppConstants.join_requests_in_box_key.tr,
                                  itemIndex: 1,
                                  notifier: settingsButtonTrigger),
                            ],
                          ),
                        ]),
                  ),
                ),
                AppSpaces.verticalSpace20,
                Expanded(
                  child: controller.selectedTabIndex.value == 0
                      ? StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                          stream: TeamMemberController()
                              .getMemberWhereUserIsStream(
                                  userId: AuthService
                                      .instance.firebaseAuth.currentUser!.uid),
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
                                        AppConstants.loading_key.tr,
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
                                          AppConstants
                                              .not_member_to_get_tasks_key.tr,
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
                                    stream: WatingSubTasksController()
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
                                                    AppConstants
                                                        .no_invitations_for_tasks_key
                                                        .tr,
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
                                                  stream: ProjectController()
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
                                                                        await WatingSubTasksController().rejectSubTask(
                                                                            waitingSubTaskId:
                                                                                listWaitingSubTasks[index].id,
                                                                            rejectingMessage: "rejectingMessage");
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      } on Exception catch (e) {
                                                                        CustomSnackBar.showError(
                                                                            "حدث خطأ غير متوقع");
                                                                      }
                                                                    },
                                                                    onPressedStart:
                                                                        (p0) async {
                                                                      try {
                                                                        showDialogMethod(
                                                                            context);
                                                                        await WatingSubTasksController()
                                                                            .accpetSubTask(
                                                                          waitingSubTaskId:
                                                                              listWaitingSubTasks[index].id,
                                                                        );
                                                                        Get.key
                                                                            .currentState!
                                                                            .pop();
                                                                        // Navigator.of(
                                                                        //         context)
                                                                        //     .pop();
                                                                      } on Exception catch (e) {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        CustomSnackBar.showError(
                                                                            "حدث خطأ غير متوقع");
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
                      //: Container(),
                      : StreamBuilder<QuerySnapshot<WaitingMemberModel>>(
                          stream: WaitingMamberController()
                              .getWaitingMembersInUserIdStream(
                                  userId: AuthService
                                      .instance.firebaseAuth.currentUser!.uid),
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
                                        AppConstants.loading_key.tr,
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
                                          AppConstants.no_invitation_key.tr,
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
                                    stream: TeamController().getTeamByIdStream(
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
                                                  AppConstants.loading_key.tr,
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
                                            stream: UserController()
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
                                                          AppConstants
                                                              .loading_key.tr,
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
                                                      await WaitingMamberController()
                                                          .declineTeamInvite(
                                                              rejectingMessage:
                                                                  "i dont like it",
                                                              waitingMemberId:
                                                                  listWaitingMembers[
                                                                          index]
                                                                      .id);
                                                      Get.key.currentState!
                                                          .pop();
                                                    },
                                                    onPressedStart: (p0) async {
                                                      showDialogMethod(context);
                                                      await WaitingMamberController()
                                                          .acceptTeamInvite(
                                                              waitingMemberId:
                                                                  listWaitingMembers[
                                                                          index]
                                                                      .id);
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                    },
                                                    header: teamModel.name!,
                                                    //  header: "Team Name",
                                                    subHeader:
                                                        "${AppConstants.manager_key.tr}  ${userModel!.name!}",
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
        ));
  }
}

String formatFromDate({required DateTime dateTime, required String fromat}) {
  return DateFormat(fromat).format(dateTime);
}
