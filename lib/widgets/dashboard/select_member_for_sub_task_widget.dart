import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/widgets/search_bar_animation_widget.dart';
import 'package:project_management_muhmad_omar/widgets/dark_background/dark_radial_background_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';

import '../Buttons/primary_progress_button_widget.dart';
import '../user/employee_card_sub_task_widget.dart';

class SearchForMembersSubTask extends StatefulWidget {
  final UserModel? userModel;
  final TeamModel? teamModel;
  final Function({required UserModel? userModel}) onSelectedUserChanged;

  const SearchForMembersSubTask({
    required this.userModel,
    super.key,
    this.teamModel,
    required this.onSelectedUserChanged,
  });

  @override
  State<SearchForMembersSubTask> createState() =>
      _SearchForMembersSubTaskState();
}

class _SearchForMembersSubTaskState extends State<SearchForMembersSubTask> {
  static String search = "";

  final searchController = TextEditingController();
  final ValueNotifier<UserModel?> selectedUserNotifier =
      ValueNotifier<UserModel?>(null);

  @override
  void initState() {
    if (widget.userModel != null) {
      selectedUserNotifier.value = widget.userModel;
    }
    super.initState();
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
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: Utils.screenWidth * 0.04,
                    left: Utils.screenWidth * 0.04),
                child: SafeArea(
                  child: TaskezAppHeader(
                    title: 'البحث عن عضو',
                    widget: MySearchBarWidget(
                      searchWord: "الأعضاء",
                      editingController: searchController,
                      onChanged: (String value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),
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
                                child: StreamBuilder<
                                    QuerySnapshot<TeamMemberModel>>(
                                  stream: TeamMemberController()
                                      .getMembersInTeamIdStream(
                                    teamId: widget.teamModel!.id,
                                  ),
                                  builder: (context, snapshotMembers) {
                                    if (snapshotMembers.hasData) {
                                      List<String> listIds = [];
                                      List<
                                              QueryDocumentSnapshot<
                                                  TeamMemberModel>> list =
                                          snapshotMembers.data!.docs;
                                      for (var element in list) {
                                        listIds.add(element.data().userId);
                                      }
                                      if (listIds.isEmpty) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.search_off,
                                              color: Colors.red,
                                              size: Utils.screenWidth * 0.27,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Utils.screenWidth * 0.1,
                                                vertical:
                                                    Utils.screenHeight * 0.03,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'لم يتم العثور على أعضاء للفريق الذي يعمل على هذا المشروع',
                                                  style: GoogleFonts.fjallaOne(
                                                    color: Colors.white,
                                                    fontSize:
                                                        Utils.screenWidth *
                                                            0.09,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return StreamBuilder<
                                          QuerySnapshot<UserModel>>(
                                        stream: UserController()
                                            .getUsersWhereInIdsStream(
                                          usersId: listIds,
                                        ),
                                        builder: (context, snapshotUsers) {
                                          if (snapshotUsers.hasData) {
                                            int taskCount =
                                                snapshotUsers.data!.docs.length;
                                            List<UserModel> users = [];
                                            if (taskCount > 0) {
                                              if (search.isNotEmpty) {
                                                for (var element
                                                    in snapshotUsers
                                                        .data!.docs) {
                                                  UserModel taskModel =
                                                      element.data();
                                                  if (taskModel.userName!
                                                      .toLowerCase()
                                                      .contains(search)) {
                                                    users.add(taskModel);
                                                  }
                                                }
                                              } else {
                                                for (var element
                                                    in snapshotUsers
                                                        .data!.docs) {
                                                  UserModel taskCategoryModel =
                                                      element.data();

                                                  users.add(taskCategoryModel);
                                                }
                                              }
                                              selectedUserNotifier.value ??=
                                                  users.first;
                                            }
                                            return ValueListenableBuilder(
                                                valueListenable:
                                                    selectedUserNotifier,
                                                builder: (context, value, _) {
                                                  return ListView.separated(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          selectedUserNotifier
                                                                  .value =
                                                              users[index];
                                                        },
                                                        child:
                                                            EmployeeCardSubTask(
                                                          activated:
                                                              selectedUserNotifier
                                                                      .value!
                                                                      .id ==
                                                                  users[index]
                                                                      .id,
                                                          backgroundColor:
                                                              Colors.white,
                                                          Image: users[index]
                                                              .imageUrl,
                                                          Name: users[index]
                                                                  .userName ??
                                                              "",
                                                          bio: users[index]
                                                                  .bio ??
                                                              "",
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return const SizedBox(
                                                        height: 10,
                                                      );
                                                    },
                                                    itemCount: users.length,
                                                  );
                                                });
                                          }
                                          if (snapshotUsers.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors
                                                    .lightMauveBackgroundColor,
                                                backgroundColor: AppColors
                                                    .primaryBackgroundColor,
                                              ),
                                            );
                                          }

                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search_off,
                                                color: Colors.red,
                                                size: Utils.screenWidth * 0.27,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Utils.screenWidth * 0.1,
                                                  vertical:
                                                      Utils.screenHeight * 0.05,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'لم يتم العثور على أعضاء للفريق الذي يعمل على هذا المشروع',
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
                                        },
                                      );
                                    }
                                    if (snapshotMembers.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors
                                              .lightMauveBackgroundColor,
                                          backgroundColor:
                                              AppColors.primaryBackgroundColor,
                                        ),
                                      );
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          color: Colors.red,
                                          size: Utils.screenWidth * 0.27,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Utils.screenWidth * 0.1,
                                            vertical: Utils.screenHeight * 0.05,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'لم يتم العثور على أعضاء للفريق الذي يعمل على هذا المشروع',
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
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AppSpaces.verticalSpace10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "إلغاء",
                      style: GoogleFonts.lato(
                        color: HexColor.fromHex("F49189"),
                        fontSize: Utils.screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PrimaryProgressButton(
                    width: Utils.screenWidth * 0.25,
                    height: Utils.screenHeight2 * 0.07,
                    label: 'تم',
                    callback: () {
                      if (selectedUserNotifier.value != null) {
                        widget.onSelectedUserChanged(
                            userModel: selectedUserNotifier.value!);
                      }
                      Get.back();
                    },
                  )
                ],
              ),
              AppSpaces.verticalSpace10,
            ],
          ),
        ],
      ),
    );
  }
}
