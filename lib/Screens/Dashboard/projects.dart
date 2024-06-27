import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_management_muhmad_omar/Screens/Dashboard/select_team.dart';
import 'package:project_management_muhmad_omar/Screens/Projects/editProject.dart';
import 'package:project_management_muhmad_omar/Screens/Projects/projectScreenCotroller.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/controllers/statusController.dart';
import 'package:project_management_muhmad_omar/models/team/Manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/Project_model.dart';
import 'package:project_management_muhmad_omar/models/team/Team_model.dart';
import 'package:project_management_muhmad_omar/models/statusmodel.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/widgets/Snackbar/custom_snackber.dart';
import 'package:project_management_muhmad_omar/widgets/User/focused_menu_item.dart';

import 'dart:developer' as dev;
import '../../BottomSheets/bottom_sheets.dart';
import '../../Values/values.dart';
import '../../constants/app_constans.dart';
import '../../widgets/Buttons/primary_tab_buttons.dart';
import '../../widgets/Chat/add_chat_icon.dart';
import '../../widgets/Dashboard/main_tasks.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/Projects/project_card_horizontal.dart';
import '../../widgets/Projects/project_card_vertical.dart';

enum ProjecSortOption {
  name,
  createDate,
  updatedDate,
  stauts,
  teamName,

  // Add more sorting options if needed
}

class ProjectScreen extends StatefulWidget {
  ProjectScreen({
    //required this.userAsManager,
    Key? key,
  }) : super(key: key);
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  bool desc = false; // Track sorting option, initially false
  String? orderByField = nameK;
  ManagerModel? userAsManager;
  ProjecSortOption selectedSortOption = ProjecSortOption.name;

  String _getSortOptionText(ProjecSortOption option) {
    switch (option) {
      case ProjecSortOption.name:
        return AppConstants.name_key.tr;
      case ProjecSortOption.updatedDate:
        return AppConstants.updated_date_key.tr;
      case ProjecSortOption.createDate:
        return AppConstants.created_date_key.tr;
      case ProjecSortOption.stauts:
        return AppConstants.status_key.tr;
      case ProjecSortOption.teamName:
        return AppConstants.team_name_key.tr;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAsManamger();
  }

  getUserAsManamger() async {
    userAsManager = await ManagerController().getMangerWhereUserIs(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> settingsButtonTrigger = ValueNotifier(0);
    final switchGridLayout = ValueNotifier(false);
    return GetBuilder<ProjectScreenController>(
      init: ProjectScreenController(),
      builder: (controller) {
        settingsButtonTrigger.value = controller.selectedTab.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right:
                    Utils.screenWidth * 0.04, // Adjust the percentage as needed
                left:
                    Utils.screenWidth * 0.03, // Adjust the percentage as needed
                top: Utils.screenHeight *
                    0.03, // Adjust the percentage as needed
              ),
              child: SafeArea(
                child: TaskezAppHeader(
                  title: AppConstants.projects_key.tr,
                  widget: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        width: 2,
                        color: HexColor.fromHex("616575"),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        size: Utils.screenWidth *
                            0.05, // Adjust the percentage as needed

                        sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      onPressed: toggleSortOrder, // Toggle the sort order
                    ),
                  ),
                ),
              ),
            ),
            AppSpaces.verticalSpace20,
            Padding(
              padding: EdgeInsets.only(
                right:
                    Utils.screenWidth * 0.04, // Adjust the percentage as needed
                left:
                    Utils.screenWidth * 0.04, // Adjust the percentage as needed
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  0.04, // Adjust the 0percentage as needed
                              left: Utils.screenWidth *
                                  0.02, // Adjust the percentage as needed
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<ProjecSortOption>(
                              value: selectedSortOption,
                              onChanged: (ProjecSortOption? newValue) {
                                setState(() {
                                  selectedSortOption = newValue!;
                                  settingsButtonTrigger.value =
                                      controller.selectedTab.value;
                                  // Implement the sorting logic here
                                });
                              },
                              items: ProjecSortOption.values
                                  .map((ProjecSortOption option) {
                                return DropdownMenuItem<ProjecSortOption>(
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
                                size: Utils.screenWidth * 0.08,
                              ),
                              underline: const SizedBox(),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     _showOptions(context); // Show options menu
                          //   },
                          //   child: const Icon(Icons.more_vert, color: Colors.white),
                          // ),
                          PrimaryTabButton(
                            callback: () {
                              controller.selectTab(0);
                              settingsButtonTrigger.value =
                                  controller.selectedTab.value;
                            },
                            buttonText: AppConstants.all_key.tr,
                            itemIndex: 0,
                            notifier: settingsButtonTrigger,
                          ),
                          PrimaryTabButton(
                            callback: () async {
                              showDialog(
                                context: context,
                                builder: (context) => const Center(
                                    child: CircularProgressIndicator()),
                              );
                              ManagerModel? managerModel =
                                  await ManagerController()
                                      .getMangerWhereUserIs(
                                          userId: AuthService.instance
                                              .firebaseAuth.currentUser!.uid);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                              Get.to(() => SelectTeamScreen(
                                    managerModel: managerModel,
                                    title: AppConstants.choose_team_key.tr,
                                  ));
                              dev.log("Team Tap");
                              settingsButtonTrigger.value =
                                  controller.selectedTab.value;
                              // controller.selectedTab(0);
                            },
                            buttonText: AppConstants.by_team_key.tr,
                            itemIndex: 1,
                            notifier: settingsButtonTrigger,
                          ),
                          PrimaryTabButton(
                            callback: () async {
                              // ManagerModel? managerModel =
                              //     await ManagerController()
                              //         .getMangerWhereUserIs(
                              //             userId: AuthService.instance
                              //                 .firebaseAuth.currentUser!.uid);
                              // if (managerModel == null) {
                              //   CustomSnackBar.showError("You Are not Manager");
                              //   // controller.selectTab(2);
                              //   controller.selectTab(0);
                              // }
                              controller.selectTab(2);
                            },
                            buttonText: AppConstants.project_manager_key.tr,
                            itemIndex: 2,
                            notifier: settingsButtonTrigger,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpaces.horizontalSpace10,
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        switchGridLayout.value = !switchGridLayout.value;
                      },
                      child: ValueListenableBuilder(
                        valueListenable: switchGridLayout,
                        builder: (BuildContext context, _, __) {
                          return switchGridLayout.value
                              ? Icon(
                                  FeatherIcons.clipboard,
                                  color: Colors.white,
                                  size: Utils.screenWidth * 0.07,
                                )
                              : Icon(
                                  FeatherIcons.grid,
                                  color: Colors.white,
                                  size: Utils.screenWidth * 0.07,
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpaces.verticalSpace20,
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: Utils.screenWidth *
                      0.04, // Adjust the percentage as needed
                  left: Utils.screenWidth * 0.04,
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ValueListenableBuilder(
                    valueListenable: switchGridLayout,
                    builder: (BuildContext context, _, __) {
                      return StreamBuilder<QuerySnapshot<ProjectModel?>>(
                        stream: controller.getProjectsStream(),
                        builder: (context, snapshotProject) {
                          if (snapshotProject.hasError) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
//
                                Icon(
                                  Icons.search_off,
                                  //   Icons.heart_broken_outlined,
                                  color: Colors.red,
                                  size: Utils.screenWidth * 0.28,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Utils.screenWidth *
                                        0.1, // Adjust the percentage as needed
                                    vertical: Utils.screenHeight * 0.05,
                                  ),
                                  child: Center(
                                    child: Text(
                                      snapshotProject.error
                                          .toString()
                                          .substring(11),
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

                          if (snapshotProject.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          List<ProjectModel?> list = snapshotProject.data!.docs
                              .map((doc) => doc.data())
                              .toList();
                          final projects = snapshotProject.data!.docs.toList();
                          if (projects.isEmpty) {
                            return Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Iconsax.task,
                                      size: Utils.screenWidth * 0.34,
                                      color: HexColor.fromHex("#999999"),
                                    ),
                                    AppSpaces.verticalSpace10,
                                    Text(
                                      AppConstants
                                          .no_projects_you_are_in_key.tr,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          color: HexColor.fromHex("#999999"),
                                          fontSize: Utils.screenWidth * 0.05,
                                          // Adjust the percentage as needed
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ]),
                            );
                          }
                          // Sort the list based on the selected sort option
                          switch (selectedSortOption) {
                            case ProjecSortOption.name:
                              list.sort((a, b) => a!.name!.compareTo(b!.name!));
                              break;
                            case ProjecSortOption.createDate:
                              list.sort((a, b) =>
                                  a!.createdAt.compareTo(b!.createdAt));
                              break;
                            case ProjecSortOption.updatedDate:
                              list.sort((a, b) =>
                                  b!.updatedAt.compareTo(a!.updatedAt));
                              break;
                            case ProjecSortOption.stauts:
                              list.sort(
                                  (a, b) => b!.statusId.compareTo(a!.statusId));
                              break;
                            case ProjecSortOption.teamName:
                              list.sort(
                                  (a, b) => b!.teamId!.compareTo(a!.teamId!));
                              break;
                            // Add cases for more sorting options if needed
                          }
                          if (!sortAscending) {
                            list = list.reversed
                                .toList(); // Reverse the list for descending order
                          }
                          return GridView.builder(
                            itemCount: list.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: switchGridLayout.value ? 2 : 1,
                              mainAxisSpacing: 10,
                              mainAxisExtent:
                                  switchGridLayout.value ? 235 : 140,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (_, index) {
                              final teamId = list[index]!.teamId!;
                              return StreamBuilder<DocumentSnapshot<TeamModel>>(
                                stream: TeamController()
                                    .getTeamByIdStream(id: teamId),
                                builder: (context, snapshotTeam) {
                                  if (snapshotTeam.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error: ${snapshotTeam.error}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Utils.screenWidth * 0.1,
                                        ),
                                      ),
                                    );
                                  }

                                  if (snapshotTeam.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  final teamName =
                                      snapshotTeam.data?.data()?.name ?? '';

                                  return StreamBuilder<
                                      DocumentSnapshot<StatusModel>>(
                                    stream:
                                        StatusController().getStatusByIdStream(
                                      idk: list[index]!.statusId,
                                    ),
                                    builder: (context, snapshotStatus) {
                                      if (snapshotStatus.hasError) {
                                        return Center(
                                          child: Text(
                                            'Error: ${snapshotStatus.error}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Utils.screenWidth * 0.1,
                                            ),
                                          ),
                                        );
                                      }

                                      if (snapshotStatus.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      final status =
                                          snapshotStatus.data!.data()!.name;

                                      if (switchGridLayout.value) {
                                        return userAsManager != null &&
                                                userAsManager!.id ==
                                                    projects[index]
                                                        .data()!
                                                        .managerId
                                            ? FocusedMenu(
                                                widget: ProjectCardVertical(
                                                  idk: projects[index].id,
                                                  status: status!,
                                                  teamName: teamName,
                                                  projectName:
                                                      list[index]!.name!,
                                                  projeImagePath:
                                                      list[index]!.imageUrl,
                                                  endDate:
                                                      list[index]!.endDate!,
                                                  startDate:
                                                      list[index]!.startDate,
                                                ),
                                                onClick: () async {
                                                  Get.to(MainTaskScreen(
                                                    projectId:
                                                        projects[index].id,
                                                  ));
                                                },
                                                deleteButton: () async {
                                                  try {
                                                    showDialogMethod(context);
                                                    await ProjectController()
                                                        .deleteProject(
                                                            projects[index].id);
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showSuccess(
                                                        AppConstants
                                                            .project_deleted_successfully_key
                                                            .tr);
                                                  } on Exception catch (e) {
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showError(
                                                        "Delete Field : ${"حدث خطأ غير متوقع"}");
                                                  }
                                                },
                                                editButton: () {
                                                  showAppBottomSheet(
                                                    EditProject(
                                                        userAsManager:
                                                            userAsManager!,
                                                        teamModel: snapshotTeam
                                                            .data!
                                                            .data()!,
                                                        projectModel:
                                                            projects[index]
                                                                .data()!),
                                                    isScrollControlled: true,
                                                    popAndShow: false,
                                                  );
                                                })
                                            : InkWell(
                                                onTap: () async {
                                                  Get.to(MainTaskScreen(
                                                    projectId:
                                                        projects[index].id,
                                                  ));
                                                },
                                                child: ProjectCardVertical(
                                                  idk: projects[index].id,
                                                  status: status!,
                                                  teamName: teamName,
                                                  projectName:
                                                      list[index]!.name!,
                                                  projeImagePath:
                                                      list[index]!.imageUrl,
                                                  endDate:
                                                      list[index]!.endDate!,
                                                  startDate:
                                                      list[index]!.startDate,
                                                ),
                                              );
                                      } else {
                                        return userAsManager != null &&
                                                userAsManager!.id ==
                                                    projects[index]
                                                        .data()!
                                                        .managerId
                                            ? FocusedMenu(
                                                widget: ProjectCardHorizontal(
                                                  idk: projects[index].id,
                                                  status: status!,
                                                  teamName: teamName,
                                                  projectName:
                                                      list[index]!.name!,
                                                  projeImagePath:
                                                      list[index]!.imageUrl,
                                                  endDate:
                                                      list[index]!.endDate!,
                                                  startDate:
                                                      list[index]!.startDate,
                                                ),
                                                onClick: () async {
                                                  Get.to(MainTaskScreen(
                                                    projectId:
                                                        projects[index].id,
                                                  ));
                                                },
                                                deleteButton: () async {
                                                  try {
                                                    showDialogMethod(context);
                                                    await ProjectController()
                                                        .deleteProject(
                                                            projects[index].id);
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showSuccess(
                                                      AppConstants
                                                          .delete_project_key
                                                          .tr,
                                                    );
                                                  } on Exception catch (e) {
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showError(
                                                        "Delete Field : ${"حدث خطأ غير متوقع"}");
                                                  }
                                                },
                                                editButton: () {
                                                  showAppBottomSheet(
                                                    EditProject(
                                                        userAsManager:
                                                            userAsManager!,
                                                        teamModel: snapshotTeam
                                                            .data!
                                                            .data()!,
                                                        projectModel:
                                                            projects[index]
                                                                .data()!),
                                                    isScrollControlled: true,
                                                    popAndShow: false,
                                                  );
                                                })
                                            : InkWell(
                                                onTap: () async {
                                                  Get.to(MainTaskScreen(
                                                    projectId:
                                                        projects[index].id,
                                                  ));
                                                },
                                                child: ProjectCardHorizontal(
                                                  idk: projects[index].id,
                                                  status: status!,
                                                  teamName: teamName,
                                                  projectName:
                                                      list[index]!.name!,
                                                  projeImagePath:
                                                      list[index]!.imageUrl,
                                                  endDate:
                                                      list[index]!.endDate!,
                                                  startDate:
                                                      list[index]!.startDate,
                                                ),
                                              );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
