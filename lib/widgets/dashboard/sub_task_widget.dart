import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/values.dart';
import 'package:project_management_muhmad_omar/controllers/manger_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_main_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/status_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/top_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_provider.dart';
import 'package:project_management_muhmad_omar/controllers/waiting_sub_tasks_provider.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_sub_tasks_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_model.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:project_management_muhmad_omar/services/types_services.dart';
import 'package:project_management_muhmad_omar/widgets/Dashboard/create_sub_task_widget.dart';
import 'package:project_management_muhmad_omar/widgets/bottom_sheets/bottom_sheets_widget.dart';

import '../../providers/auth_provider.dart';
import '../snackbar/custom_snackber_widget.dart';
import '../user/focused_menu_item_widget.dart';

enum TaskStatus {
  notDone,
  inProgress,
  done,
  notStarted,
}

class TaskWidget extends StatelessWidget {
  final TaskStatus status;

  const TaskWidget({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String statusText;

    switch (status) {
      case TaskStatus.notDone:
        icon = Icons.clear;
        color = Colors.red;
        statusText = 'غير مكتمل';
        break;
      case TaskStatus.inProgress:
        icon = Icons.access_time;
        color = Colors.orange;
        statusText = 'قيد التنفيذ';
        break;
      case TaskStatus.done:
        icon = Icons.check;
        color = Colors.green;
        statusText = 'تم';
      case TaskStatus.notStarted:
        icon = Icons.schedule;
        color = Colors.grey;
        statusText = 'لم تبدأ بعد';
        break;
    }

    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SubTaskCard extends StatefulWidget {
  const SubTaskCard({
    required this.task,
    required this.primary,
    required this.onPrimary,
    super.key,
  });
  final ProjectSubTaskModel task;
  final Color primary;
  final Color onPrimary;

  @override
  State<SubTaskCard> createState() => _SubTaskCardState();
}

class _SubTaskCardState extends State<SubTaskCard> {
  String taskStatus = "";
  String name = "";
  String? image;
  String bio = "";
  // ismanager() async {
  //   ProjectModel? projectModel =
  //       await ProjectController().getProjectById(id: widget.task.projectId);
  //   ManagerModel managerModel =
  //       await ManagerController().getMangerById(id: projectModel!.managerId);
  //   UserModel? userModel =
  //       await UserController().getUserWhereMangerIs(mangerId: managerModel.id);
  //   if (userModel.id != firebaseAuth.currentUser!.uid) {
  //     isManager = false;
  //   } else {
  //     isManager = true;
  //   }
  //
  // }
  @override
  void initState() {
    ismanagerStream();
    super.initState();
  }

  ismanagerStream() async {
    ProjectModel? projectModel =
    await ProjectProvider().getProjectById(id: widget.task.projectId);
    Stream<DocumentSnapshot<ManagerModel>> managerModelStream =
    ManagerProvider().getMangerByIdStream(id: projectModel!.managerId);
    Stream<DocumentSnapshot<UserModel>> userModelStream;

    StreamSubscription<DocumentSnapshot<ManagerModel>> managerSubscription;
    StreamSubscription<DocumentSnapshot<UserModel>> userSubscription;

    managerSubscription = managerModelStream.listen((managerSnapshot) {
      ManagerModel manager = managerSnapshot.data()!;
      userModelStream =
          UserProvider().getUserWhereMangerIsStream(mangerId: manager.id);
      userSubscription = userModelStream.listen((userSnapshot) {
        UserModel user = userSnapshot.data()!;
        bool updatedIsManager;
        if (user.id != AuthProvider.firebaseAuth.currentUser!.uid) {
          updatedIsManager = false;
        } else {
          updatedIsManager = true;
        }

        // Update the state and trigger a rebuild
        isManager.value = updatedIsManager;
      });
    });
  }

  // getMemberUserModelStream() {
  //   StreamSubscription<DocumentSnapshot<UserModel>> userSubscription;
  //   Stream<DocumentSnapshot<UserModel>> userModelStream = UserController()
  //       .getUserWhereMemberIsStream(memberId: widget.task.assignedTo);
  //   userSubscription = userModelStream.listen((event) {
  //     userModel.value=event.data();
  //   });
  // }

  // Rx<UserModel>? userModel;
  RxBool isManager = false.obs;

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot<UserModel>> steam = UserProvider()
        .getUserWhereMemberIsStream(memberId: widget.task.assignedTo)
        .asBroadcastStream();
    StatusProvider statusController = Get.put(StatusProvider());
    StatusModel? statusModel;

    taskStatus = " ";
    return Obx(() => isManager.value
        ? FocusedMenu(
            onClick: () {},
            deleteButton: () async {
              ProjectSubTaskProvider userTaskController =
              Get.put(ProjectSubTaskProvider());
              await userTaskController.deleteProjectSubTask(id: widget.task.id);
            },
            editButton: () {
              showAppBottomSheet(
                CreateSubTask(
                  userTaskModel: widget.task,
                  projectId: widget.task.projectId,
                  checkExist: ({required String name}) async {
                    bool s;
                    s = await TopProvider().existByTow(
                        reference: projectSubTasksRef,
                        value: widget.task.mainTaskId,
                        field: mainTaskIdK,
                        value2: name,
                        field2: nameK);
                    s = await TopProvider().existByTow(
                        reference: watingSubTasksRef,
                        value: widget.task.mainTaskId,
                        field: "subTask.$mainTaskIdK",
                        value2: name,
                        field2: "subTask.$nameK");
                    return s;
                  },
                  addTask: (
                      {required int priority,
                      required String taskName,
                      required DateTime startDate,
                      required DateTime dueDate,
                      required String? desc,
                      required String color,
                      required String userIdAssignedTo}) async {
                    ProjectSubTaskModel projectSubTaskModel =
                    await ProjectSubTaskProvider()
                            .getProjectSubTaskById(id: widget.task.id);
                    ProjectMainTaskModel mainTask =
                        await ProjectMainTaskController()
                            .getProjectMainTaskById(
                                id: projectSubTaskModel.mainTaskId);
                    if (!projectSubTaskModel.startDate
                            .isAfter(mainTask.startDate) ||
                        !projectSubTaskModel.endDate!
                            .isBefore(mainTask.endDate!)) {
                      throw Exception(
                          "يجب أن تكون تواريخ بداية وانتهاء المهمة الفرعية بين تواريخ بداية وانتهاء المهمة الرئيسية");
                    }
                    TeamMemberModel memberModelold =
                    await TeamMemberProvider().getMemberById(
                            memberId: projectSubTaskModel.assignedTo);
                    ProjectModel? projectModel = await ProjectProvider()
                        .getProjectById(id: projectSubTaskModel.projectId);

                    String s = projectModel!.teamId!;
                    TeamModel teamModel =
                        await TeamController().getTeamById(id: s);
                    TeamMemberModel newteamMemberModel =
                        await TeamMemberProvider().getMemberByTeamIdAndUserId(
                            teamId: teamModel.id,
                            userId: userIdAssigTeamProvider if
                            ((projectSubTaskModel.startDate != startDate ||
                            projectSubTaskModel.endDate != dueDate ||
                            memberModelold.id != newteamMemberModel.id) &&
                        taskStatus != statusNotStarted) {
                      CustomSnackBar.showError(
                          "Cannot edit assignes or start time and end time of not done or done or doing task");
                      return;
                    }
                    if (startDate.isAfter(dueDate) ||
                        startDate.isAtSameMomentAs(dueDate)) {
                      CustomSnackBar.showError(
                          'لا يمكن أن يكون تاريخ البدء بعد تاريخ الانتهاء أو في نفس الوقت أو قبل التاريخ الحالي');
                      return;
                    }
                    if (memberModelold.id != newteamMemberModel.id) {
                      try {
                        bool overlapped = false;
                        int over = 0;
                        List<ProjectSubTaskModel> list =
                        await ProjectSubTaskProvider().getMemberSubTasks(
                                memberId: newteamMemberModel.id);
                        for (ProjectSubTaskModel existingTask in list) {
                          if (projectSubTaskModel.startDate
                                  .isBefore(existingTask.endDate!) &&
                              projectSubTaskModel.endDate!
                                  .isAfter(existingTask.startDate)) {
                            overlapped = true;
                            over += 1;
                          }
                        }
                        if (overlapped) {
                          Get.defaultDialog(
                            title: "Task Time Error",
                            middleText:
                                "There is ${over} task That start in this time \n for the new assigned user \n Would you Like To assign the Task Any Way?",
                            onConfirm: () async {
                              StatusModel statusModel = await statusController
                                  .getStatusByName(status: statusNotStarted);
                    await ProjectSubTaskProvider()
                                  .deleteProjectSubTask(
                                      id: projectSubTaskModel.id);
                              ProjectSubTaskModel updatedprojectSubTaskModel =
                                  ProjectSubTaskModel(
                                      assignedToParameter:
                                          newteamMemberModel.id,
                                      mainTaskIdParameter:
                                          projectSubTaskModel.mainTaskId,
                                      hexColorParameter: color,
                                      projectIdParameter:
                                          projectSubTaskModel.projectId,
                                      descriptionParameter: desc!,
                                      idParameter: projectMainTasksRef.doc().id,
                                      nameParameter: taskName,
                                      statusIdParameter: statusModel.id,
                                      importanceParameter: priority,
                                      createdAtParameter: DateTime.now(),
                                      updatedAtParameter: DateTime.now(),
                                      startDateParameter: startDate,
                                      endDateParameter: dueDate);
                              // await ProjectSubTaskController()
                              //     .addProjectSubTask(projectsubTaskModel: userTaskModel);
                              String waitingid = watingSubTasksRef.doc().id;
                              WaitingSubTaskModel waitingSubTaskModel =
                                  WaitingSubTaskModel(
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      id: waitingid,
                                      projectSubTaskModel: projectSubTaskModel);
                                      WaitingSubTasksProvider
                                  waitingSubTaskController =
                                  Get.put(WaitingSubTasksProvider());
                              await waitingSubTaskController.addWatingSubTask(
                                  waitingSubTaskModel: waitingSubTaskModel);
                              FcmNotificationsProvider fcmNotifications =
                                  Get.put(FcmNotificationsProvider());
                              UserModel userModelnewAssigned =
                    await UserProvider()
                                      .getUserById(id: userIdAssignedTo);
                              UserModel userModelOldAssigned =
                    await UserProvider()
                                      .getUserById(id: memberModelold.userId);
                              await fcmNotifications.sendNotificationAsJson(
                                  fcmTokens: userModelnewAssigned.tokenFcm,
                                  title: "you have a task ",
                                  data: {"id": waitingid},
                                  body:
                                      "the project ${projectModel?.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
                                  type: NotificationType.taskRecieved);
                              await fcmNotifications.sendNotificationAsJson(
                                  fcmTokens: userModelOldAssigned.tokenFcm,
                                  title:
                                      "the task ${updatedprojectSubTaskModel.name} have benn unassigned",
                                  body:
                                      "the project ${projectModel?.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
                                  type: NotificationType.notification);
                              CustomSnackBar.showSuccess(
                                  "task ${taskName} sended to member successfully");
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          StatusModel statusModel = await statusController
                              .getStatusByName(status: statusNotStarted);
                    await ProjectSubTaskProvider()
                              .deleteProjectSubTask(id: projectSubTaskModel.id);
                          ProjectSubTaskModel updatedprojectSubTaskModel =
                              ProjectSubTaskModel(
                                  assignedToParameter: newteamMemberModel.id,
                                  mainTaskIdParameter:
                                      projectSubTaskModel.mainTaskId,
                                  hexColorParameter: color,
                                  projectIdParameter:
                                      projectSubTaskModel.projectId,
                                  descriptionParameter: desc!,
                                  idParameter: projectMainTasksRef.doc().id,
                                  nameParameter: taskName,
                                  statusIdParameter: statusModel.id,
                                  importanceParameter: priority,
                                  createdAtParameter: DateTime.now(),
                                  updatedAtParameter: DateTime.now(),
                                  startDateParameter: startDate,
                                  endDateParameter: dueDate);
                          // await ProjectSubTaskController()
                          //     .addProjectSubTask(projectsubTaskModel: userTaskModel);
                          String waitingid = watingSubTasksRef.doc().id;
                          WaitingSubTaskModel waitingSubTaskModel =
                              WaitingSubTaskModel(
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                  id: waitingid,
                                  projectSubTaskModel: projectSubTaskModel);
                                  WaitingSubTasksProvider waitingSubTaskController =
                    Get.put(WaitingSubTasksProvider());
                          await waitingSubTaskController.addWatingSubTask(
                              waitingSubTaskModel: waitingSubTaskModel);
                          FcmNotificationsProvider fcmNotifications =
                              Get.put(FcmNotificationsProvider());
                          UserModel userModelnewAssigned =
                    await UserProvider()
                                  .getUserById(id: userIdAssignedTo);
                          UserModel userModelOldAssigned =
                    await UserProvider()
                                  .getUserById(id: memberModelold.userId);
                          await fcmNotifications.sendNotificationAsJson(
                              fcmTokens: userModelnewAssigned.tokenFcm,
                              title: "you have a task ",
                              data: {"id": waitingid},
                              body:
                                  "the project ${projectModel.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
                              type: NotificationType.taskRecieved);
                          await fcmNotifications.sendNotificationAsJson(
                              fcmTokens: userModelOldAssigned.tokenFcm,
                              title:
                                  "the task ${updatedprojectSubTaskModel.name} have been unassigned",
                              body:
                                  "the project ${projectModel.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
                              type: NotificationType.notification);
                          CustomSnackBar.showSuccess(
                              "task ${taskName} sended to member successfully");
                          Navigator.pop(context);
                        }
                        return;
                      } catch (e) {
                        CustomSnackBar.showError(e.toString());
                      }
                    }
                    if (startDate != projectSubTaskModel.startDate ||
                        dueDate != projectSubTaskModel.endDate) {
                      bool overlapped = false;
                      int over = 0;
                      List<ProjectSubTaskModel> list =
                      await ProjectSubTaskProvider()
                              .getMemberSubTasks(memberId: memberModelold.id);
                      for (ProjectSubTaskModel existingTask in list) {
                        if (projectSubTaskModel.startDate
                                .isBefore(existingTask.endDate!) &&
                            projectSubTaskModel.endDate!
                                .isAfter(existingTask.startDate)) {
                          overlapped = true;
                          over += 1;
                        }
                      }
                      if (overlapped) {
                        Get.defaultDialog(
                          title: "Task Time Error",
                          middleText:
                              "There is ${over} task That start in this time \n for the new assigned user \n Would you Like To assign the Task Any Way?",
                          onConfirm: () async {
                    await ProjectSubTaskProvider().updateSubTask(
                                isfromback: false,
                                data: {
                                  nameK: taskName,
                                  startDateK: startDate,
                                  endDateK: dueDate,
                                  descriptionK: desc,
                                  colorK: color,
                                  importanceK: priority,
                                },
                                id: widget.task.id);
                            FcmNotificationsProvider fcmNotifications =
                                Get.put(FcmNotificationsProvider());

                            UserModel userModelOldAssigned =
                    await UserProvider()
                                    .getUserById(id: memberModelold.userId);

                            await fcmNotifications.sendNotificationAsJson(
                                fcmTokens: userModelOldAssigned.tokenFcm,
                                title:
                                    "the task ${taskName} time have been changed",
                                body:
                                    "the new start time is ${startDate} and the new due time is ${dueDate}",
                                type: NotificationType.notification);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        );
                      } else {
                    await ProjectSubTaskProvider().updateSubTask(
                            isfromback: false,
                            data: {
                              nameK: taskName,
                              startDateK: startDate,
                              endDateK: dueDate,
                              descriptionK: desc,
                              colorK: color,
                              importanceK: priority,
                            },
                            id: widget.task.id);
                        FcmNotificationsProvider fcmNotifications =
                            Get.put(FcmNotificationsProvider());

                    UserModel userModelOldAssigned = await UserProvider()
                            .getUserById(id: memberModelold.userId);

                        await fcmNotifications.sendNotificationAsJson(
                            fcmTokens: userModelOldAssigned.tokenFcm,
                            title:
                                "the task ${taskName} time have been changed",
                            body:
                                "the new start time is ${startDate} and the new due time is ${dueDate}",
                            type: NotificationType.notification);

                        CustomSnackBar.showSuccess(
                            "task ${taskName} sended to member successfully");
                        Navigator.pop(context);
                      }
                    }
                    try {
                    await ProjectSubTaskProvider().updateSubTask(
                          isfromback: false,
                          data: {
                            nameK: taskName,
                            startDateK: startDate,
                            endDateK: dueDate,
                            descriptionK: desc,
                            colorK: color,
                            importanceK: priority,
                          },
                          id: widget.task.id);
                    } catch (e) {
                      CustomSnackBar.showError(e.toString());
                    }
                  },
                  isEditMode: true,
                ),
                isScrollControlled: true,
                popAndShow: false,
              );
            },
            widget: Opacity(
              opacity: getOpacity(widget.task.importance),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.primary,
                          widget.primary.withOpacity(.7)
                        ],
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter,
                      ),
                    ),
                    child: _BackgroundDecoration(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<DocumentSnapshot<UserModel>>(
                                stream: steam,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    UserModel userModel =
                                        snapshot.data!.data()!;
                                    name = userModel.name ?? "";
                                    bio = userModel.bio ?? "";
                                    image = userModel.imageUrl;
                                    // return GlowContainer(
                                    //   borderRadius: BorderRadius.circular(25),
                                    //   glowColor: Colors.lightBlueAccent,
                                    //   child: InactiveEmployeeCardSubTask(
                                    //     onTap: () {},
                                    //     bio: userModel.bio!,
                                    //     color: Colors.white,
                                    //     userImage: userModel.imageUrl,
                                    //     userName: userModel.userName!,
                                    //   ),
                                    // );
                                  }

                                  if (!snapshot.hasData) {
                                    // return image != null
                                    //     ? GlowContainer(
                                    //         borderRadius:
                                    //             BorderRadius.circular(25),
                                    //         glowColor: Colors.lightBlueAccent,
                                    //         child: InactiveEmployeeCardSubTask(
                                    //           onTap: () {},
                                    //           bio: bio,
                                    //           color: Colors.white,
                                    //           userImage: image!,
                                    //           userName: name,
                                    //         ),
                                    //       )
                                    //     : GlowContainer(
                                    //         borderRadius:
                                    //             BorderRadius.circular(25),
                                    //         glowColor: Colors.lightBlueAccent,
                                    //         child: InactiveEmployeeCardSubTask(
                                    //           onTap: () {},
                                    //           bio: bio,
                                    //           color: Colors.white,
                                    //           userImage: "",
                                    //           showicon: true,
                                    //           userName: name,
                                    //         ),
                                    //       );
                                  }
                                  return const CircularProgressIndicator
                                      .adaptive();
                                },
                              ),
                              AppSpaces.verticalSpace10,
                              SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildLabel(widget.task.name!),
                                    AppSpaces.horizontalSpace10,
                                    _buildStatus(widget.task.importance),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              buildLabel(
                                  "وصف: ${widget.task.description ?? "no description"}"),
                              StreamBuilder(
                                stream: statusController
                                    .getStatusByIdStream(
                                        idk: widget.task.statusId)
                                    .asBroadcastStream(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot<StatusModel>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    statusModel =
                                        snapshot.data!.data() as StatusModel;
                                    taskStatus = statusModel!.name!;
                                    return TaskWidget(
                                        status: getStatus(taskStatus));
                                  }
                                  return TaskWidget(
                                      status: getStatus(taskStatus));
                                },
                              ),
                              buildLabel(
                                  "تاريخ البدء:${formatDateTime(widget.task.startDate)}"),
                              buildLabel(
                                  "تاريخ الانتهاء:${formatDateTime(widget.task.endDate!)}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Opacity(
            opacity: getOpacity(widget.task.importance),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.primary, widget.primary.withOpacity(.7)],
                      begin: AlignmentDirectional.topCenter,
                      end: AlignmentDirectional.bottomCenter,
                    ),
                  ),
                  child: _BackgroundDecoration(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<DocumentSnapshot<UserModel>>(
                              stream: UserProvider()
                                  .getUserWhereMemberIsStream(
                                      memberId: widget.task.assignedTo)
                                  .asBroadcastStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    height: 80,
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryBackgroundColor,
                                        // border: Border.all(color: AppColors.primaryBackgroundColor, width: 4),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    width: double.infinity,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  UserModel userModel = snapshot.data!.data()!;
                                  // return GlowContainer(
                                  //   borderRadius: BorderRadius.circular(25),
                                  //   glowColor: Colors.lightBlueAccent,
                                  //   child: InactiveEmployeeCardSubTask(
                                  //     onTap: () {},
                                  //     bio: userModel.bio!,
                                  //     color: Colors.white,
                                  //     userImage: userModel.imageUrl,
                                  //     userName: userModel.userName!,
                                  //   ),
                                  // );
                                }
                                return const CircularProgressIndicator
                                    .adaptive();
                              },
                            ),
                            AppSpaces.verticalSpace20,
                            SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildLabel(widget.task.name!),
                                  _buildStatus(widget.task.importance),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildLabel("وصف: ${widget.task.description}"),
                            StreamBuilder(
                              stream: statusController
                                  .getStatusByIdStream(
                                      idk: widget.task.statusId)
                                  .asBroadcastStream(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot<StatusModel>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  statusModel =
                                      snapshot.data!.data() as StatusModel;
                                  taskStatus = statusModel!.name!;
                                  return TaskWidget(
                                      status: getStatus(taskStatus));
                                }
                                return TaskWidget(
                                    status: getStatus(taskStatus));
                              },
                            ),
                            buildLabel(
                                "تاريخ البدء:${formatDateTime(widget.task.startDate)}"),
                            buildLabel(
                                "تاريخ الانتهاء:${formatDateTime(widget.task.endDate!)}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
  }

  double getOpacity(int importance) {
    double opacity = 1.0;

    switch (importance) {
      case 1:
        opacity = 0.3;
        break;
      case 2:
        opacity = 0.4;
        break;
      case 3:
        opacity = 0.7;
        break;
      case 4:
        opacity = 0.8;
        break;
      case 5:
        opacity = 1.0;
        break;
    }

    return opacity;
  }

  TaskStatus getStatus(String status) {
    switch (status) {
      case statusNotDone:
        return TaskStatus.notDone;
      case statusDoing:
        return TaskStatus.inProgress;
      case statusDone:
        return TaskStatus.done;
      case statusNotStarted:
        return TaskStatus.notStarted;
      default:
        return TaskStatus.notDone;
    }
  }

  Widget _buildStatus(int importance) {
    final maxOpacity = 0.9; // Maximum opacity for the task
    final minOpacity = 0.3; // Minimum opacity for the task
    final opacityStep =
        (maxOpacity - minOpacity) / 4; // Step size for opacity calculation

    return Row(
      children: List.generate(5, (index) {
        final isFilledStar = index < importance;
        final opacity = isFilledStar
            ? minOpacity + (importance - 1) * opacityStep
            : 1.0; // Set opacity to 1.0 for empty stars
        return Text("jj");

        // return GlowContainer(
        //   glowColor: isFilledStar
        //       ? Colors.yellow.withOpacity(opacity)
        //       : Colors.transparent,
        //   child: Icon(
        //     isFilledStar ? Icons.star_rate_rounded : Icons.star_border_rounded,
        //     color: Colors.yellow.withOpacity(opacity),
        //   ),
        // );
      }),
    );
  }

  // Widget _buildStatus(int importance) {
  //   final maxOpacity = 1.0; // Maximum opacity for the task
  //   final minOpacity = 0.5; // Minimum opacity for the task
  //   final opacityStep =
  //       (maxOpacity - minOpacity) / 5; // Step size for opacity calculation

  //   return Row(
  //     children: List.generate(5, (index) {
  //       final opacity = minOpacity +
  //           (index + 1) * opacityStep; // Calculate the opacity value

  //       return Opacity(
  //         opacity: opacity,
  //         child: Icon(
  //           index < importance ? Icons.star : Icons.star_border_rounded,
  //           color: Colors.yellow,
  //         ),
  //       );
  //     }),
  //   );
  // }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "اليوم ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM/yy h:mma').format(dateTime);
    }
  }

  Widget buildLabel(String name) {
    return Text(
      name,
      style: AppTextStyles.header2_2,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
