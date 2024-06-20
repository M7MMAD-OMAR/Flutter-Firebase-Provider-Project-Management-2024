import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/controllers/manger_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_main_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/status_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/controllers/top_provider.dart';
import 'package:project_management_muhmad_omar/controllers/user_task_provider.dart';
import 'package:project_management_muhmad_omar/firebase_options.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/models/user/user_task_Model.dart';
import 'package:project_management_muhmad_omar/providers/auth_provider.dart';
import 'package:project_management_muhmad_omar/services/types_services.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../collections_refrences.dart';
import 'notification_controller_services.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> sendMainTaskNotification(
    {required ProjectMainTaskModel task,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotificationsProvider fcmNotifications =
      Get.put(FcmNotificationsProvider(), permanent: true);
  if (!finished) {
    String title = started
        ? "main task ${task.name} has Started"
        : "${task.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Task ${task.name} has begun.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
        type: NotificationType.notification);
    return;
  }
  String title = started
      ? "main task ${task.name} has Ended"
      : "${task.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
    fcmTokens: token,
    title: title,
    body:
        "🚀 Task ${task.name} has Finished.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
    type: NotificationType.notification,
  );
}

Future<void> sendSubTaskNotification(
    {required ProjectSubTaskModel task,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotificationsProvider fcmNotifications =
      Get.put(FcmNotificationsProvider(), permanent: true);
  if (!finished) {
    String title = started
        ? "sub task ${task.name} has Started"
        : "${task.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Task ${task.name} has begun.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
        type: NotificationType.notification);
    return;
  }
  String title = started
      ? "sub task ${task.name} has Ended"
      : "${task.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
      fcmTokens: token,
      title: title,
      body:
          "🚀 Task ${task.name} has Finished.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
      type: NotificationType.memberTaskTimeFinished,
      data: {"id": task.id});
}

@pragma('vm:entry-point')
Future<void> sendTaskNotification(
    {required UserTaskModel task,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotificationsProvider fcmNotifications =
      Get.put(FcmNotificationsProvider(), permanent: true);
  if (!finished) {
    String title = started
        ? "${task.name} has Started"
        : "${task.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Task ${task.name} has begun.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
        type: NotificationType.notification);
    return;
  }
  String title =
      started ? "${task.name} has Ended" : "${task.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
      fcmTokens: token,
      title: title,
      body:
          "🚀 Task ${task.name} has Finished.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
      data: {"id": task.id},
      type: NotificationType.userTaskTimeFinished);
}

@pragma('vm:entry-point')
Future<void> sendProjectNotification(
    {required ProjectModel project,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotificationsProvider fcmNotifications =
      Get.put(FcmNotificationsProvider(), permanent: true);
  if (!finished) {
    String title = started
        ? "${project.name} has Started"
        : "${project.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Project ${project.name} has begun.📅 Deadline: ${project.endDate}. ⭐",
        type: NotificationType.notification);
    return;
  }
  String title = started
      ? "${project.name} has Ended"
      : "${project.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
      fcmTokens: token,
      title: title,
      body:
          "🚀 Task ${project.name} has Finished.📅 Deadline: ${project.endDate}. ",
      type: NotificationType.notification);
}

@pragma('vm:entry-point')
Future<void> checkProjectsToSendNotificationToManager() async {
  ManagerProvider managerController = Get.put(ManagerProvider());
  UserTaskProvider userTaskController = Get.put(UserTaskProvider());
  String userId = FirebaseAuth.instance.currentUser!.uid;
  if (await userTaskController.existByOne(
    collectionReference: managersRef,
    field: userIdK,
    value: userId,
  )) {
    List<ManagerModel> managerList = [];
    managerList = await managerController.getUserManager(userId: userId);
    managerList.forEach((element) async {
      await checkProjectsForManager(managerId: element.id);
    });
  }
}

@pragma('vm:entry-point')
Future<void> checkProjectsForManager({required String managerId}) async {
  ProjectProvider projectController = Get.put(ProjectProvider());
  String token = await getFcmToken();
  if (await projectController.existByOne(
        collectionReference: projectsRef,
        field: managerIdK,
        value: managerId,
      ) ==
      false) {
    return;
  }
  List<ProjectModel?>? projectList =
      await ProjectProvider().getProjectsOfManager(mangerId: managerId);
  await checkProjectsToSendNotification(
      ismanager: true, projectList: projectList);
}

@pragma('vm:entry-point')
Future<void> checkTaskToSendNotification() async {
  UserTaskProvider userTaskController = Get.put(UserTaskProvider());
  StatusProvider statusController = Get.put(StatusProvider());
  String token = await getFcmToken();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  if (await userTaskController.existByOne(
        collectionReference: usersTasksRef,
        field: userIdK,
        value: FirebaseAuth.instance.currentUser!.uid,
      ) ==
      false) {
    return;
  }
  StatusModel statusDoneModel =
      await statusController.getStatusByName(status: statusDone);
  StatusModel statusNotDoneModel =
      await statusController.getStatusByName(status: statusNotDone);
  StatusModel statusNotStartedModel =
      await statusController.getStatusByName(status: statusNotStarted);
  StatusModel statusDoingModel =
      await statusController.getStatusByName(status: statusDoing);
  List<UserTaskModel> userTaskList =
      await userTaskController.getUserTasks(userId: userId);
  for (UserTaskModel element in userTaskList) {
    DateTime taskStartdate = firebaseTime(element.startDate);
    DateTime? taskEnddate = firebaseTime(element.endDate!);

    DateTime now = DateTime.now();

    if (taskStartdate.day == now.day &&
        taskStartdate.month == now.month &&
        taskStartdate.year == now.year) {
      DateTime firebaseNow = firebaseTime(DateTime.now());

      if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
          element.statusId == statusNotStartedModel.id) {
        await userTaskController.updateUserTask(
            isfromback: true,
            data: {statusIdK: statusDoingModel.id},
            id: element.id);
        await sendTaskNotification(
            task: element, started: true, token: [token], finished: false);
      }
      if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
          element.statusId == statusNotStartedModel.id) {
        await sendTaskNotification(
            task: element, started: false, token: [token], finished: false);
      }
      DocumentSnapshot documentSnapshot = await TopProvider()
          .getDocById(reference: usersTasksRef, id: element.id);
      bool isFather = await TopProvider().existByOne(
          collectionReference: usersTasksRef,
          value: documentSnapshot.reference,
          field: taskFatherIdK);
      if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
          element.statusId == statusDoingModel.id &&
          isFather == false) {
        await userTaskController.updateUserTask(
            isfromback: true,
            data: {statusIdK: statusNotDoneModel.id},
            id: element.id);
        await sendTaskNotification(
            task: element, started: false, token: [token], finished: true);
      } else if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
          element.statusId == statusDoingModel.id &&
          isFather == true) {
        bool isDone = true;
        List<UserTaskModel> childTasks = await UserTaskProvider()
            .getChildTasks(taskFatherId: documentSnapshot.reference);
        for (var childElement in childTasks) {
          UserTaskModel child = childElement;
          if (child.statusId == statusNotDoneModel.id) {
            isDone = false;
            break;
          }
        }
        if (isDone) {
          UserTaskProvider().updateUserTask(
            isfromback: true,
            data: {
              statusIdK: statusDoneModel.id,
            },
            id: element.id,
          );
          String title = "${element.name} has Ended";
          await FcmNotificationsProvider().sendNotificationAsJson(
              fcmTokens: [token],
              title: title,
              body: "🚀Task ${element.name} has Finished.📅.and got Done",
              data: {"id": element.id},
              type: NotificationType.userTaskTimeFinished);
        } else {
          UserTaskProvider().updateUserTask(
            isfromback: true,
            data: {
              statusIdK: statusNotDoneModel.id,
            },
            id: element.id,
          );
          String title = "${element.name} has Ended";
          await FcmNotificationsProvider().sendNotificationAsJson(
              fcmTokens: [token],
              title: title,
              body: "🚀Task ${element.name} has Finished.📅.and got not Done",
              data: {"id": element.id},
              type: NotificationType.userTaskTimeFinished);
        }
      }
    }
  }
}

@pragma('vm:entry-point')
void checkAuth(int x, Map<String, dynamic> map) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(/*() =>  */ AuthProvider()));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationController.initializeNotification();
  AuthProvider authSXervice = Get.put(AuthProvider());
  FirebaseAuth.instance.authStateChanges().listen(
    (User? user) async {
      if (user != null) {
        await checkTaskToSendNotification();
        await checkProjectMainTasksToSendNotificationToManager();
        await checkProjectMainTasksToSendNotificationToMembers();
        await checkSubTasksToSendNotification();
        await checkProjectsToSendNotificationToManager();
        await checkProjectsToSendNotificationToMember();
      } else {}
    },
  );
}

checkProjectsToSendNotification(
    {required List<ProjectModel?>? projectList,
    required bool ismanager}) async {
  String token = await getFcmToken();
  StatusProvider statusController = Get.put(StatusProvider());
  StatusModel statusDoneModel =
      await statusController.getStatusByName(status: statusDone);
  StatusModel statusNotStartedModel =
      await statusController.getStatusByName(status: statusNotStarted);
  StatusModel statusNotDoneModel =
      await statusController.getStatusByName(status: statusNotDone);
  StatusModel statusDoingModel =
      await statusController.getStatusByName(status: statusDoing);
  if (projectList != null) {
    for (ProjectModel? element in projectList) {
      if (element != null) {
        DateTime taskStartdate = firebaseTime(element.startDate);
        DateTime? taskEnddate = firebaseTime(element.endDate!);
        DateTime now = DateTime.now();
        if (taskStartdate.day == now.day &&
            taskStartdate.month == now.month &&
            taskStartdate.year == now.year) {
          DateTime firebaseNow = firebaseTime(DateTime.now());
          if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusNotStartedModel.id) {
            await ProjectProvider().updateProject2(
                data: {statusIdK: statusDoingModel.id}, id: element.id);

            await sendProjectNotification(
                project: element,
                started: true,
                token: [token],
                finished: false);
          }
          if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
              element.statusId == statusNotDoneModel.id) {
            await sendProjectNotification(
                project: element,
                started: false,
                token: [token],
                finished: true);
          }

          if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusDoingModel.id) {
            bool isDone = true;
            List<ProjectMainTaskModel> list = await ProjectMainTaskController()
                .getProjectMainTasks(projectId: element.id);
            for (var element in list) {
              if (element.statusId == statusNotDoneModel.id) {
                isDone = false;
              }
            }

            if (isDone) {
              await ProjectProvider().updateProject2(
                  data: {statusIdK: statusDoneModel.id}, id: element.id);
            } else {
              await ProjectProvider().updateProject2(
                  data: {statusIdK: statusNotDoneModel.id}, id: element.id);
            }

            await sendProjectNotification(
                project: element,
                started: false,
                token: [token],
                finished: true);
          }
        }
      }
    }
  }
}

checkProjectsToSendNotificationToMember() async {
  if (await TeamMemberProvider().existByOne(
          collectionReference: teamMembersRef,
          value: userIdK,
          field: AuthProvider.firebaseAuth.currentUser!.uid) ==
      false) {
    return;
  }
  List<ProjectModel?>? projectList = [];

  projectList = await ProjectProvider().getProjectsOfMemberWhereUserIs2(
      userId: AuthProvider.firebaseAuth.currentUser!.uid);
  await checkProjectsToSendNotification(
      ismanager: false, projectList: projectList);
}

checkProjectMainTasksToSendNotificationToMembers() async {
  if (await TeamMemberProvider().existByOne(
          collectionReference: teamMembersRef,
          value: userIdK,
          field: AuthProvider.firebaseAuth.currentUser!.uid) ==
      true) {
    List<ProjectModel?>? projectList = [];
    projectList = await ProjectProvider().getProjectsOfMemberWhereUserIs2(
        userId: AuthProvider.firebaseAuth.currentUser!.uid);
    await checkProjectMainTasksToSendNotifications(
        manager: false, projectList: projectList);
  }
}

checkProjectMainTasksToSendNotificationToManager() async {
  if (await TeamMemberProvider().existByOne(
          collectionReference: managersRef,
          value: userIdK,
          field: AuthProvider.firebaseAuth.currentUser!.uid) ==
      true) {
    List<ProjectModel?>? projectList = [];
    projectList = await ProjectProvider()
        .getProjectsOfUser(userId: AuthProvider.firebaseAuth.currentUser!.uid);
    await checkProjectMainTasksToSendNotifications(
        manager: true, projectList: projectList);
  }
}

checkProjectMainTasksToSendNotifications(
    {List<ProjectModel?>? projectList, required bool manager}) async {
  String token = await getFcmToken();
  StatusModel statusDoneModel =
      await StatusProvider().getStatusByName(status: statusDone);
  StatusProvider statusController = Get.put(StatusProvider());
  StatusModel statusNotStartedModel =
      await statusController.getStatusByName(status: statusNotStarted);
  StatusModel statusNotDoneModel =
      await statusController.getStatusByName(status: statusNotDone);
  StatusModel statusDoingModel =
      await statusController.getStatusByName(status: statusDoing);
  List<ProjectMainTaskModel> mainTasksList = [];
  if (projectList!.isNotEmpty) {
    for (ProjectModel? element in projectList) {
      if (element != null) {
        List<ProjectMainTaskModel> mainTasksListmini = [];
        mainTasksListmini = await ProjectMainTaskController()
            .getProjectMainTasks(projectId: element.id);
        mainTasksList.addAll(mainTasksListmini);
      }
      mainTasksList.forEach((element) async {
        DateTime taskStartdate = firebaseTime(element.startDate);
        DateTime? taskEnddate = firebaseTime(element.endDate!);

        DateTime now = DateTime.now();

        if (taskStartdate.day == now.day &&
            taskStartdate.month == now.month &&
            taskStartdate.year == now.year) {
          DateTime firebaseNow = firebaseTime(DateTime.now());

          if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusNotStartedModel.id) {
            if (manager) {
              await ProjectMainTaskController().updateMainTask(
                  isfromback: true,
                  data: {statusIdK: statusDoingModel.id},
                  id: element.id);
            }
            await sendMainTaskNotification(
                task: element, started: true, token: [token], finished: false);
          }
          if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
              element.statusId == statusNotDoneModel.id) {
            await sendMainTaskNotification(
                task: element, started: false, token: [token], finished: false);
          }

          if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusDoingModel.id) {
            bool isDone = true;
            List<ProjectSubTaskModel> subtasks = await ProjectSubTaskProvider()
                .getSubTasksForAMainTask(mainTaskId: element.id);
            for (var element in subtasks) {
              if (element.statusId == statusNotDoneModel.id) {
                isDone = false;
              }
            }

            if (isDone) {
              await ProjectSubTaskProvider().updateSubTask(
                  isfromback: true,
                  data: {statusIdK: statusDoneModel.id},
                  id: element.id);
            } else {
              await ProjectSubTaskProvider().updateSubTask(
                  isfromback: true,
                  data: {statusIdK: statusNotDoneModel.id},
                  id: element.id);
            }

            await sendMainTaskNotification(
                task: element, started: false, token: [token], finished: true);
          }
        }
      });
    }
  }
}

checkSubTasksToSendNotification() async {
  StatusProvider statusController = Get.put(StatusProvider());
  TeamMemberProvider teamMemberController = Get.put(TeamMemberProvider());
  ProjectSubTaskProvider projectSubTaskController =
      Get.put(ProjectSubTaskProvider());
  String token = await getFcmToken();
  if (await teamMemberController.existByOne(
          collectionReference: teamMembersRef,
          value: userIdK,
          field: AuthProvider.firebaseAuth.currentUser!.uid) ==
      true) {
    StatusModel statusDoneModel =
        await statusController.getStatusByName(status: statusDone);
    StatusModel statusNotStartedModel =
        await statusController.getStatusByName(status: statusNotStarted);
    StatusModel statusNotDoneModel =
        await statusController.getStatusByName(status: statusNotDone);
    StatusModel statusDoingModel =
        await statusController.getStatusByName(status: statusDoing);
    List<ProjectSubTaskModel> allsubtasklist = [];
    List<TeamMemberModel> list =
        await teamMemberController.getMemberWhereUserIs(
            userId: AuthProvider.firebaseAuth.currentUser!.uid);
    list.forEach((element) async {
      List<ProjectSubTaskModel> minisubtasklist = await projectSubTaskController
          .getMemberSubTasks(memberId: element.id);
      for (var subtask in minisubtasklist) {
        if (subtask.statusId == statusNotStartedModel.id) {
          allsubtasklist.add(subtask);
        }
      }
    });
    allsubtasklist.forEach((ProjectSubTaskModel element) async {
      DateTime taskStartdate = element.startDate;
      DateTime? taskEnddate = element.endDate;
      DateTime now = DateTime.now();
      if (taskStartdate.day == now.day &&
          taskStartdate.month == now.month &&
          taskStartdate.year == now.year) {
        DateTime firebaseNow = firebaseTime(DateTime.now());

        if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
            element.statusId == statusNotStartedModel.id) {
          await projectSubTaskController.updateSubTask(
              isfromback: true,
              data: {statusIdK: statusDoingModel.id},
              id: element.id);
          await sendSubTaskNotification(
              task: element, started: true, token: [token], finished: false);
        }
        if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
            element.statusId == statusNotStartedModel.id) {
          await sendSubTaskNotification(
              task: element, started: false, token: [token], finished: false);
        }

        if (taskEnddate!.isAtSameMomentAs(firebaseNow) &&
            element.statusId == statusDoingModel.id) {
          await ProjectSubTaskProvider().updateSubTask(
              isfromback: true,
              data: {statusIdK: statusNotDoneModel.id},
              id: element.id);
          await sendSubTaskNotification(
              task: element, started: false, token: [token], finished: true);
        }
      }
    });
  }
}
