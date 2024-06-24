import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_provider.dart';
import 'package:project_management_muhmad_omar/providers/projects/project_sub_task_provider.dart';
import 'package:project_management_muhmad_omar/providers/task_provider.dart';
import 'package:project_management_muhmad_omar/providers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/models/team/project_main_task_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_model.dart';
import 'package:project_management_muhmad_omar/models/team/project_sub_task_model.dart';
import '../auth_provider.dart';

class ProjectMainTaskProvider extends TaskProvider {
  Future<ProjectMainTaskModel> getProjectMainTaskById(
      {required String id}) async {
    DocumentSnapshot mainTaskDoc =
        await getDocById(reference: projectMainTasksRef, id: id);
    return mainTaskDoc.data() as ProjectMainTaskModel;
  }

  Stream<DocumentSnapshot<ProjectMainTaskModel>> getProjectMainTaskByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: projectMainTasksRef, id: id);
    return stream.cast<DocumentSnapshot<ProjectMainTaskModel>>();
  }

  Future<ProjectMainTaskModel> getProjectMainTaskByName(
      {required String name, required String projectId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        name: name);
    return documentSnapshot.data() as ProjectMainTaskModel;
  }

  Stream<DocumentSnapshot<ProjectMainTaskModel>> getProjectMainTaskByNameStream(
      {required String name, required String projectId}) {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        name: name);
    return stream.cast<DocumentSnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasks(
      {required String projectId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectMainTasksRef,
        field: projectIdK,
        value: projectId);
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>> getProjectMainTasksStream(
      {required String projectId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
        reference: projectMainTasksRef, field: projectIdK, value: projectId));
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksForAStatus(
      {required String projectId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksForAStatusStream(
          {required String projectId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
    );
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<double> getPercentOfMainTasksInAProjectForAStatus(
      String status, String projectId) async {
    return await getPercentOfTasksForAStatus(
      reference: projectMainTasksRef,
      status: status,
      field: projectIdK,
      value: projectId,
    );
  }

  Stream<double> getPercentOfMainTasksInAProjectForAStatusStream(
      String status, String projectId) {
    return getPercentOfTasksForAStatusStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        status: status);
  }

  Future<double> getPercentOfMainTasksInAProjectForAStatusBetweenTowStartTime({
    required String status,
    required String projectId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: projectMainTasksRef,
        status: status,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Stream<double>
      getPercentOfMainTasksInAProjectForAStatusBetweenTowStartTimeStream({
    required String status,
    required String projectId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimesStream(
        reference: projectMainTasksRef,
        status: status,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksForAnImportance(
      {required String projectId, required int importance}) async {
    List<Object?>? list = await getTasksForAnImportance(
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
      importance: importance,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksForAnImportanceStream(
          {required String projectId, required int importance}) {
    Stream<QuerySnapshot> stream = getTasksForAnImportanceStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        importance: importance);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksStartInADayForAStatus(
      {required DateTime date,
      required String projectId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: projectMainTasksRef,
      date: date,
      field: projectIdK,
      value: projectId,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksStartInADayForAStatusStream(
          {required DateTime date,
          required String projectId,
          required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        status: status,
        reference: projectMainTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<double>>
      getPercentagesForLastSevenDaysforaProjectMainTasksforAStatus(
          String projectId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksStartInASpecificTime(
      {required DateTime date, required String projectId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: projectMainTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksStartInASpecificTimeStream(
          {required DateTime date, required String projectId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: projectMainTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksStartBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String projectId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getCommonMainTasksBetweenTwoMembersStream({
    required String projectId,
    required String firstMember,
    required String secondMember,
  }) async* {
    List<ProjectSubTaskModel> firstMemberMainTasks = [];
    List<ProjectSubTaskModel> secondMemberMainTasks = [];
    List<String> mainTasksIds = [];
    firstMemberMainTasks =
        await ProjectSubTaskProvider().getMemberSubTasks(memberId: firstMember);

    secondMemberMainTasks = await ProjectSubTaskProvider()
        .getMemberSubTasks(memberId: secondMember);

    for (var firstMemberMainTask in firstMemberMainTasks) {
      for (var secondMemberMainTask in secondMemberMainTasks) {
        if (firstMemberMainTask.mainTaskId == secondMemberMainTask.mainTaskId) {
          if (!mainTasksIds.contains(firstMemberMainTask.mainTaskId)) {
            mainTasksIds.add(firstMemberMainTask.mainTaskId);
          }
        }
      }
    }
    if (mainTasksIds.isEmpty) {
      throw Exception("لم يتم العثور على مهام شائعة");
    }

    yield* getMainTasksByListIdStream(mainTasks: mainTasksIds);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>> getMemberMainTasksStream({
    required String projectId,
    required String firstMember,
  }) async* {
    List<ProjectMainTaskModel> firstMemberMainTasks = [];
    List<String> mainTasksIds = [];

    Completer<List<String>> completer = Completer<List<String>>();

    Stream<QuerySnapshot<ProjectSubTaskModel>> firstMemberSubTasksStream =
        ProjectSubTaskProvider().getMemberSubTasksForAProjectStream(
            memberId: firstMember, projectId: projectId);

    StreamSubscription<QuerySnapshot<ProjectSubTaskModel>>
        firstMemberSubscription;
    firstMemberSubscription = firstMemberSubTasksStream.listen((event) async {
      for (var element in event.docs) {
        ProjectMainTaskModel projectMainTaskModel =
            await getProjectMainTaskById(id: element.data().mainTaskId);
        firstMemberMainTasks.add(projectMainTaskModel);
      }

      if (!completer.isCompleted) {
        for (var firstMemberMainTask in firstMemberMainTasks) {
          mainTasksIds.add(firstMemberMainTask.id);
        }

        completer.complete(mainTasksIds);
      }
    });

    List<String> mainTasksFinal = await completer.future;

    firstMemberSubscription.cancel();

    if (mainTasksFinal.isEmpty) {
      throw Exception("لا توجد مهام رئيسية للمشاريع التي فيها عضو ");
    }

    yield* getMainTasksByListIdStream(mainTasks: mainTasksFinal);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getUserAsMemberMainTasksInADayStream({
    required DateTime date,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));

    String memberId = "";
    List<String> mainTaskIds = [];
    List<String> finalIds = [];
    List<TeamMemberModel> list = await TeamMemberProvider()
        .getMemberWhereUserIs(
            userId: AuthProvider.firebaseAuth.currentUser!.uid);
    for (var element in list) {
      TeamMemberModel teamMemberModel = element;
      memberId = teamMemberModel.id;
      List<ProjectSubTaskModel> subTasksList =
          await ProjectSubTaskProvider().getMemberSubTasks(memberId: memberId);

      for (var subTaskModel in subTasksList) {
        if (!mainTaskIds.contains(subTaskModel.mainTaskId)) {
          mainTaskIds.add(subTaskModel.mainTaskId);
        }
      }
    }

    if (mainTaskIds.isEmpty) {
      throw Exception("لا توجد مهام رئيسية للمشاريع التي أنا عضو فيها");
    }

    for (var element in mainTaskIds) {
      ProjectMainTaskModel mainTask = await getProjectMainTaskById(id: element);
      if (mainTask.startDate.isAfter(startOfDay) &&
          mainTask.startDate.isBefore(endOfDay)) {
        if (!finalIds.contains(mainTask.id)) {
          finalIds.add(mainTask.id);
        }
      }
    }

    if (finalIds.isEmpty) {
      throw Exception("لا توجد مهام رئيسية للمشاريع التي أنا عضو فيها");
    }

    yield* getMainTasksByListIdStream(mainTasks: finalIds);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>> getMainTasksByListIdStream(
      {required List<String> mainTasks}) {
    return projectMainTasksRef
        .where(idK, whereIn: mainTasks)
        .snapshots()
        .cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getUserAsManagerMainTasksInADayStream({required DateTime date}) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    List<ProjectMainTaskModel> mainTasksall = [];
    List<String> idList = [];
    List<ProjectModel?>? projects = await ProjectProvider()
        .getProjectsOfUser(userId: AuthProvider.firebaseAuth.currentUser!.uid);
    for (var element in projects!) {
      List<ProjectMainTaskModel> mainTasks =
          await getProjectMainTasks(projectId: element!.id);
      for (var element in mainTasks) {
        mainTasksall.add(element);
      }
    }
    for (var MainTaskelement in mainTasksall) {
      ProjectMainTaskModel mainTask = MainTaskelement;
      if (mainTask.startDate.isAfter(startOfDay) &&
          mainTask.startDate.isBefore(endOfDay)) {
        if (!idList.contains(mainTask.id)) {
          idList.add(mainTask.id);
        }
      }
    }
    if (idList.isEmpty) {
      throw Exception("لا توجد مهام رئيسية لمدير مشروع IAM");
    }
    yield* getMainTasksByListIdStream(mainTasks: idList);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksStartBetweenTowTimesStream(
          {required DateTime firstDate,
          required DateTime secondDate,
          required String projectId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<void> addProjectMainTask({
    required ProjectMainTaskModel projectMainTaskModel,
  }) async {
    bool overlapped = false;
    int over = 0;
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    List<ProjectMainTaskModel> list =
        await getProjectMainTasks(projectId: projectMainTaskModel.projectId);
    ProjectModel? project = await ProjectProvider()
        .getProjectById(id: projectMainTaskModel.projectId);
    if (!projectMainTaskModel.startDate.isAfter(project!.startDate) ||
        !projectMainTaskModel.endDate!.isBefore(project.endDate!)) {
      throw Exception(
          "يجب أن يكون تاريخ بدء المهمة الرئيسية وتاريخ انتهائها بين تاريخ بدء وانتهاء المشروع");
    }
    for (ProjectMainTaskModel existingTask in list) {
      if (projectMainTaskModel.startDate.isBefore(existingTask.endDate!) &&
          projectMainTaskModel.endDate!.isAfter(existingTask.startDate)) {
        overlapped = true;
        over += 1;
      }
    }
    if (overlapped) {
      showErrorDialog(
        title: 'خطأ في وقت المهمة',
        middleText: "هناك $over تبدأ في هذا الوقت هل تود إضافتها؟",
        onConfirm: () async {
          await addTask(
            reference: projectMainTasksRef,
            field: projectIdK,
            value: projectMainTaskModel.projectId,
            taskModel: projectMainTaskModel,
            exception: Exception('المهمة الرئيسية موجودة بالفعل في المشروع'),
          );
          _navigatorKey.currentState?.pop(); // Close the dialog
          showSuccessSnackBar(
              "مهمة ${projectMainTaskModel.name} تمت الإضافة بنجاح");
        },
        onCancel: () {
          _navigatorKey.currentState?.pop(); // Close the dialog
        },
      );
    } else {
      await addTask(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectMainTaskModel.projectId,
        taskModel: projectMainTaskModel,
        exception: Exception('المهمة الرئيسية موجودة بالفعل في المشروع'),
      );
      _navigatorKey.currentState?.pop(); // Close any existing context
      showSuccessSnackBar(
          "مهمة ${projectMainTaskModel.name} تمت الإضافة بنجاح");
    }
    // await addTask(
    //   reference: projectMainTasksRef,
    //   field: projectIdK,
    //   value: projectMainTaskModel.projectId,
    //   taskModel: projectMainTaskModel,
    //   exception: Exception("task already exist in main task"),
    // );
  }

  // Future<void> updateProjectMainTask(
  //     {required Map<String, dynamic> value, required String id}) async {
  //   ProjectMainTaskModel projectMainTaskModel =
  //       await getProjectMainTaskById(id: id);
  //   await updateTask(
  //     data: value,
  //     id: id,
  //     field: projectIdK,
  //     value: projectMainTaskModel.projectId,
  //     reference: projectMainTasksRef,
  //     exception: Exception("main task already been added"),
  //   );
  //   // updateFields(reference: usersTasksRef, data: value, id: id);
  // }

  Future<void> deleteProjectMainTask({required String mainTaskId}) async {
    WriteBatch batch = fireStore.batch();
    QuerySnapshot query = await queryWhere(
        reference: projectSubTasksRef, field: mainTaskIdK, value: mainTaskId);
    DocumentSnapshot documentSnapshot =
        await getDocById(reference: projectMainTasksRef, id: mainTaskId);
    deleteDocUsingBatch(documentSnapshot: documentSnapshot, refbatch: batch);
    deleteDocsUsingBatch(list: query.docs, refBatch: batch);
    batch.commit();
  }

  Future<void> updateMainTask(
      {required Map<String, dynamic> data,
      required String id,
      required bool isfromback}) async {
    DocumentSnapshot snapshot =
        await getDocById(reference: projectMainTasksRef, id: id);
    ProjectMainTaskModel projectMainTaskModel =
        snapshot.data() as ProjectMainTaskModel;
    ProjectModel? project = await ProjectProvider()
        .getProjectById(id: projectMainTaskModel.projectId);
    if (isfromback) {
      await updateTask(
          reference: projectSubTasksRef,
          data: data,
          id: id,
          exception: Exception('المهمة الرئيسية موجودة بالفعل في المشروع'),
          field: projectIdK,
          value: projectMainTaskModel.projectId);
      return;
    }
    if (data.containsKey(startDateK) || data[endDateK]) {
      if (!data[startDateK].isAfter(project!.startDate) ||
          !data[endDateK].isBefore(project.endDate!)) {
        throw Exception(
            "يجب أن يكون تاريخ بدء المهمة الرئيسية وتاريخ انتهائها بين تاريخ بدء وانتهاء المشروع");
      }

      bool overlapped = false;
      int over = 0;
      List<ProjectMainTaskModel> list =
          await getProjectMainTasks(projectId: projectMainTaskModel.projectId);

      list.removeWhere((element) => element.id == id);
      for (ProjectMainTaskModel existingTask in list) {
        if (data[startDateK].isBefore(existingTask.endDate) &&
            data[endDateK].isAfter(existingTask.startDate)) {
          overlapped = true;
          over += 1;
        }
      }
      final GlobalKey<NavigatorState> _navigatorKey =
          GlobalKey<NavigatorState>();
      if (overlapped) {
        showErrorDialog(
          title: 'خطأ في وقت المهمة',
          middleText: "هناك $over تبدأ في هذا الوقت هل تود إضافتها؟",
          onConfirm: () async {
            await updateTask(
              reference: projectSubTasksRef,
              data: data,
              id: id,
              exception: Exception('المهمة الرئيسية موجودة بالفعل في المشروع'),
              field: projectIdK,
              value: projectMainTaskModel.projectId,
            );
            showSuccessSnackBar("مهمة ${data[nameK]} تم التحديث بنجاح");
            _navigatorKey.currentState?.pop(); // Close the dialog
          },
          onCancel: () {
            _navigatorKey.currentState?.pop(); // Close the dialog
          },
        );
      } else {
        await updateTask(
          reference: projectSubTasksRef,
          data: data,
          id: id,
          exception: Exception('المهمة الرئيسية موجودة بالفعل في المشروع'),
          field: projectIdK,
          value: projectMainTaskModel.projectId,
        );
        showSuccessSnackBar("مهمة ${data[nameK]} تم التحديث بنجاح");
        _navigatorKey.currentState?.pop(); // Close any existing context
      }
    }
  }
}