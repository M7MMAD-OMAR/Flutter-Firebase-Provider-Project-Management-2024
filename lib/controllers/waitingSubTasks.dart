import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_management_muhmad_omar/controllers/projectController.dart';
import 'package:project_management_muhmad_omar/controllers/project_sub_task_controller.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/controllers/userController.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/waiting_sub_tasks_model.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:provider/provider.dart';

import '../constants/back_constants.dart';
import '../constants/constants.dart';
import '../models/team/project_model.dart';
import '../models/team/project_sub_task_model.dart';
import '../models/user/user_model.dart';
import '../services/notifications/notification_service.dart';
import '../services/types_services.dart';
import '../widgets/snackbar/custom_snackber_widget.dart';
import 'manger_controller.dart';

class WatingSubTasksController extends TopController {
  Future<void> addWatingSubTask(
      {required WaitingSubTaskModel waitingSubTaskModel}) async {
    await addDoc(reference: watingSubTasksRef, model: waitingSubTaskModel);
  }

  Future<List<WaitingSubTaskModel>> getWatingSubTasksForMember(
      {required String memberId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingSubTasksRef,
        field: "subTask.$assignedToK",
        value: memberId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>> getWatingSubTasksForMemberStream(
      {required String memberId}) {
    return queryWhereStream(
            reference: watingSubTasksRef,
            value: memberId,
            field: "subTask.$assignedToK")
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Future<List<WaitingSubTaskModel>> getWatingSubTasksForMainTask(
      {required String mainTaskId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingSubTasksRef,
        field: "subTask.$mainTaskIdK",
        value: mainTaskId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Future<List<WaitingSubTaskModel>> getWatingSubTasksForProject(
      {required String projectId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingSubTasksRef,
        field: "subTask.$projectIdK",
        value: projectId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>> getWatingSubTasksForProjectStream(
      {required String projectId}) {
    return queryWhereStream(
            reference: watingSubTasksRef,
            field: "subTask.$projectIdK",
            value: projectId)
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>>
      getWatingSubTasksFormainTasksStream({required String mainTaskId}) {
    return queryWhereStream(
            reference: watingSubTasksRef,
            value: mainTaskId,
            field: "subTask.$mainTaskIdK")
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Future<List<WaitingSubTaskModel>> getAllwatingSubtaksforMamber(
      {required memberId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectSubTasksRef,
        field: assignedToK,
        value: memberId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Future<WaitingSubTaskModel> getWatingSubTaskById({required String id}) async {
    return (await getDocById(reference: watingSubTasksRef, id: id)).data()
        as WaitingSubTaskModel;
  }

  Stream<DocumentSnapshot<WaitingSubTaskModel>> getWatingSubTaskByIdStream(
      {required String id}) {
    return getDocByIdStream(reference: watingSubTasksRef, id: id)
        .cast<DocumentSnapshot<WaitingSubTaskModel>>();
  }

  Future<void> accpetSubTask({required String waitingSubTaskId}) async {
    await waitingTaskHandler(
        waitingSubTaskId: waitingSubTaskId,
        isAccepted: true,
        memberMessage: '');
  }

  Future<void> rejectSubTask({
    required String waitingSubTaskId,
    required String rejectingMessage,
  }) async {
    String reasonforRejection = "سبب الرفض $rejectingMessage";
    await waitingTaskHandler(
      waitingSubTaskId: waitingSubTaskId,
      isAccepted: false,
      memberMessage: reasonforRejection,
    );
  }

  Future<void> waitingTaskHandler({
    required String waitingSubTaskId,
    required bool isAccepted,
    required String memberMessage,
  }) async {
    try {
      String status = isAccepted ? 'قبولها' : "رفضها";
      BuildContext context = navigatorKey.currentContext!;

      final UserController userController =
          Provider.of<UserController>(context, listen: false);

      final WatingSubTasksController watingSubTasksController =
          Provider.of<WatingSubTasksController>(context, listen: false);
      final ProjectController projectController =
          Provider.of<ProjectController>(context, listen: false);
      final ManagerController managerController =
          Provider.of<ManagerController>(context, listen: false);
      final WaitingSubTaskModel waitingSubTaskModel =
          await watingSubTasksController.getWatingSubTaskById(
              id: waitingSubTaskId);

      if (isAccepted) {
        watingSubTasksController.deleteWatingSubTask(id: waitingSubTaskId);
        ProjectSubTaskController projectSubTaskController =
            Provider.of<ProjectSubTaskController>(context, listen: false);
        ProjectSubTaskModel projectSubTaskModel =
            waitingSubTaskModel.projectSubTaskModel;
        projectSubTaskController.addProjectSubTask(
          projectsubTaskModel: projectSubTaskModel,
        );
      } else {
        watingSubTasksController.deleteWatingSubTask(id: waitingSubTaskId);
      }

      ProjectModel? projectModel = await projectController.getProjectById(
          id: waitingSubTaskModel.projectSubTaskModel.projectId);
      ManagerModel? managerModel =
          await managerController.getMangerById(id: projectModel!.managerId);
      UserModel manager =
          await userController.getUserWhereMangerIs(mangerId: managerModel.id);

      UserModel member = await userController.getUserWhereMemberIs(
        memberId: waitingSubTaskModel.projectSubTaskModel.assignedTo,
      );

      for (var element in manager.tokenFcm) {}
      FcmNotificationsProvider fcmNotifications =
          Provider.of<FcmNotificationsProvider>(context, listen: false);
      await fcmNotifications.sendNotificationAsJson(
          fcmTokens: manager.tokenFcm,
          title: "المهمة تم $status",
          body:
              "${member.name} $status المهمة ${waitingSubTaskModel.projectSubTaskModel.name} في المشروع ${projectModel.name} $memberMessage",
          type: NotificationType.notification);
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>> getWaitingSubTasksInMembersId(
      {required List<String> membersId}) {
    return watingSubTasksRef
        .where("subTask.$assignedToK", whereIn: membersId)
        .snapshots()
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Future<void> deleteWatingSubTask({required String id}) async {
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(
        documentSnapshot: await watingSubTasksRef.doc(id).get(),
        refbatch: batch);
  }
}
