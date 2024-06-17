import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/statusController.dart';
import 'package:project_management_muhmad_omar/controllers/teamController.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/screens/Projects/edit_project_screen.dart';
import 'package:project_management_muhmad_omar/screens/Projects/project_screen_screen.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/select_team_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/main_tasks_widget.dart';
import 'package:project_management_muhmad_omar/widgets/Projects/project_card_horizontal_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';
import 'package:project_management_muhmad_omar/widgets/buttons/primary_tab_buttons_widget.dart';
import 'package:project_management_muhmad_omar/widgets/navigation/app_header_widget.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';
import 'package:project_management_muhmad_omar/widgets/user/focused_menu_item_widget.dart';

import '../../widgets/Projects/project_card_vertical_widget.dart';

enum ProjecSortOption {
  name,
  createDate,
  updatedDate,
  stauts,
  teamName,
}

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    super.key,
  });

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  bool desc = false;
  String? orderByField = nameK;
  ManagerModel? userAsManager;
  ProjecSortOption selectedSortOption = ProjecSortOption.name;

  String _getSortOptionText(ProjecSortOption option) {
    switch (option) {
      case ProjecSortOption.name:
        return "الاسم";
      case ProjecSortOption.updatedDate:
        return "تاريح التحديث";
      case ProjecSortOption.createDate:
        return "تاريخ الإنشاء";
      case ProjecSortOption.stauts:
        return 'الحالة';
      case ProjecSortOption.teamName:
        return "اسم الفريق";

      default:
        return '';
    }
  }

  bool sortAscending = true;

  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserAsManamger();
  }

  getUserAsManamger() async {
    userAsManager = await ManagerController().getMangerWhereUserIs(
        userId: AuthProvider.instance.firebaseAuth.currentUser!.uid);
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
                right: Utils.screenWidth * 0.04,
                left: Utils.screenWidth * 0.03,
                top: Utils.screenHeight * 0.03,
              ),
              child: SafeArea(
                child: TaskezAppHeader(
                  title: 'المشاريع',
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
                        size: Utils.screenWidth * 0.05,
                        sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      onPressed: toggleSortOrder,
                    ),
                  ),
                ),
              ),
            ),
            AppSpaces.verticalSpace20,
            Padding(
              padding: EdgeInsets.only(
                right: Utils.screenWidth * 0.04,
                left: Utils.screenWidth * 0.04,
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
                              right: Utils.screenWidth * 0.05,
                              left: Utils.screenWidth * 0.05,
                            ),
                            padding: EdgeInsets.only(
                              right: Utils.screenWidth * 0.04,
                              left: Utils.screenWidth * 0.02,
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
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: Utils.screenWidth * 0.08,
                              ),
                              underline: const SizedBox(),
                            ),
                          ),
                          PrimaryTabButton(
                            callback: () {
                              controller.selectTab(0);
                              settingsButtonTrigger.value =
                                  controller.selectedTab.value;
                            },
                            buttonText: "الكل",
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
                                          userId: AuthProvider.instance
                                              .firebaseAuth.currentUser!.uid);

                              Navigator.of(context).pop();
                              Get.to(() => SelectTeamScreen(
                                    managerModel: managerModel,
                                    title: 'اختر الفريق',
                                  ));
                              dev.log("Team Tap");
                              settingsButtonTrigger.value =
                                  controller.selectedTab.value;
                            },
                            buttonText: 'بواسطة الفريق',
                            itemIndex: 1,
                            notifier: settingsButtonTrigger,
                          ),
                          PrimaryTabButton(
                            callback: () async {
                              controller.selectTab(2);
                            },
                            buttonText: "مدير المشروع",
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
                  right: Utils.screenWidth * 0.04,
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
                                Icon(
                                  Icons.search_off,
                                  color: Colors.red,
                                  size: Utils.screenWidth * 0.28,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Utils.screenWidth * 0.1,
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
                                      'لا توجد مشاريع أنت تديرها',
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
                          }
                          if (!sortAscending) {
                            list = list.reversed.toList();
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
                                                        'تم حذف المشروع بنجاح');
                                                  } on Exception catch (e) {
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showError(
                                                        "Delete Field : ${e.toString()}");
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
                                                      'حذف مشروع',
                                                    );
                                                  } on Exception catch (e) {
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showError(
                                                        "Delete Field : ${e.toString()}");
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
