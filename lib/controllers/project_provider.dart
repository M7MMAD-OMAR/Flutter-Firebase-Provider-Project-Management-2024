import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/controllers/status_provider.dart';
import 'package:project_management_muhmad_omar/controllers/task_provider.dart';
import 'package:project_management_muhmad_omar/controllers/team_provider.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/models/team/teamModel.dart';
import 'package:provider/provider.dart';

import '../constants/back_constants.dart';
import '../models/team/manger_model.dart';
import '../models/team/project_model.dart';
import '../providers/auth_provider.dart';
import '../services/collections_refrences.dart';
import '../utils/back_utils.dart';
import 'manger_provider.dart';

class ProjectProvider extends TaskProvider {
  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  Stream<QuerySnapshot<ProjectModel?>> getProjectsStream() {
    final userId = AuthProvider.firebaseAuth.currentUser!.uid;
    if (_selectedTab == 0) {
      return ProjectProvider()
          .getProjectsOfMemberWhereUserIsStream(userId: userId);
    } else if (_selectedTab == 1) {
      return ProjectProvider()
          .getProjectsOfMemberWhereUserIsStream(userId: userId);
    }

    return ProjectProvider().getProjectsOfUserStream(userId: userId);
    // Return an empty stream or another default stream if needed
  }

  void selectTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void updateSelectedTab(int newValue) {
    _selectedTab = newValue;
    notifyListeners();
  }

  Future<List<ProjectModel>> getAllManagersProjects() async {
    List<Object?>? list = await getAllListDataForRef(refrence: projectsRef);

    return list!.cast<ProjectModel>();
  }

  Future<void> updateProject2(
      {required String id, required Map<String, dynamic> data}) async {
    ProjectModel? projectModel = await getProjectById(id: id);

    if (data.containsKey(startDateK)) {
      DateTime? newStartDate = data[startDateK] as DateTime;
      if (newStartDate.isAfter(projectModel!.endDate!)) {
        throw Exception(
            'لا يمكن تحديث تاريخ بدء المشروع لأن الوقت الجديد لتاريخ البدء هو بعد تاريخ انتهاء المشروع');
      }
      if (projectModel.endDate!.isBefore(firebaseTime(DateTime.now()))) {
        throw Exception(
            'لا يمكن تحديث تاريخ البدء بعد انتهاء تاريخ انتهاء المشروع');
      }
      if (await existByOne(
          collectionReference: projectMainTasksRef,
          field: projectIdK,
          value: projectModel.id)) {
        throw Exception('عذرًا، تم بدء التنفيذ في المشروع بالفعل');
      }
    }
    if (data.containsKey(teamIdK)) {
      throw Exception('عذرًا، لا يمكن تحديث معرّف الفريق');
    }
    BuildContext context = navigatorKey.currentContext!;
    final ManagerProvider managerController =
        Provider.of<ManagerProvider>(context, listen: false);
    ManagerModel? managerModel =
        await managerController.getMangerOfProject(projectId: id);
    await updateRelationalFields(
      reference: projectsRef,
      data: data,
      id: id,
      fatherField: managerIdK,
      fatherValue: managerModel!.id,
      nameException: Exception('هناك بالفعل مشروع بنفس الاسم'),
    );
  }

  Stream<QuerySnapshot<ProjectModel>> getAllManagersProjectsStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(refrence: projectsRef);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<ProjectModel> getManagerProjectByName(
      {required String name, required String managerId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        name: name);
    return documentSnapshot.data() as ProjectModel;
  }

  Stream<DocumentSnapshot<ProjectModel>> getManagerProjectByNameStream(
      {required String name, required String managerId}) {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        name: name);
    return stream.cast<DocumentSnapshot<ProjectModel>>();
  }

  Future<void> addProject({required ProjectModel projectModel}) async {
    if (await existByOne(
        collectionReference: managersRef,
        field: idK,
        value: projectModel.managerId)) {
      if (projectModel.teamId != null) {
        if (await existByTow(
            reference: teamsRef,
            field: idK,
            value: projectModel.teamId,
            field2: managerIdK,
            value2: projectModel.managerId)) {
          StatusModel statusModel =
              await StatusProvider().getStatusByName(status: statusDone);

          QuerySnapshot anotherProjects = await projectsRef
              .where(teamIdK, isEqualTo: projectModel.teamId)
              .where(statusIdK, isNotEqualTo: statusModel.id)
              .limit(1)
              .get();

          if (anotherProjects.docs.isNotEmpty) {
            throw Exception('خطأ تداخل مشروع الفريق');
          } else {
            await addDoc(reference: projectsRef, model: projectModel);
            return;
          }
        } else {
          throw Exception('عذرًا، هناك خطأ ما فيما يتعلق بالفريق أو المدير');
        }
      }
      {
        await addDoc(reference: projectsRef, model: projectModel);
        return;
      }
    } else {
      throw Exception('عذرًا، مدير المشروع غير موجود');
    }
  }

  Future<ProjectModel?> getProjectOfTeam({required String teamId}) async {
    StatusModel statusModel =
        await StatusProvider().getStatusByName(status: statusNotDone);
    DocumentSnapshot? porjectDoc = await getDocSnapShotWhereAndWhere(
        secondField: statusIdK,
        secondValue: statusModel.id,
        collectionReference: projectsRef,
        firstField: teamIdK,
        firstValue: teamId);

    return porjectDoc.data() as ProjectModel;
  }

  Stream<DocumentSnapshot<ProjectModel>> getProjectOfTeamStream(
      {required String teamId}) {
    Stream<DocumentSnapshot> projectDoc = getDocWhereStream(
        collectionReference: projectsRef, field: teamIdK, value: teamId);
    return projectDoc.cast<DocumentSnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel?>?> getProjectsOfManager(
      {required String mangerId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectsRef, field: managerIdK, value: mangerId);
    if (list != null && list.isNotEmpty) {
      return list.cast<ProjectModel>();
    }
    return null;
  }

  Stream<QuerySnapshot<ProjectModel>> getManagerProjectsStartInADayStream(
      {required DateTime date,
      required String managerId,
      required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        status: status,
        reference: projectsRef,
        date: date,
        field: managerIdK,
        value: managerId);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsStartInADayForAStatus(
      {required DateTime date,
      required String mangerId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: projectsRef,
      date: date,
      field: managerIdK,
      value: mangerId,
    );
    return list!.cast<ProjectModel>();
  }

  Future<List<double>>
      getPercentagesForLastSevenDaysforaProjectMainTasksforAStatus(
          String managerId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Future<List<ProjectModel?>?> getProjectsOfUser(
      {required String userId}) async {
    BuildContext context = navigatorKey.currentContext!;

    ManagerProvider managerController = Provider.of<ManagerProvider>(context);
    ManagerModel? managerModel = await managerController.getMangerWhereUserIs(
        userId: AuthProvider.firebaseAuth.currentUser!.uid);
    if (managerModel != null) {
      List<ProjectModel?>? list =
          await getProjectsOfManager(mangerId: managerModel.id);
      return list;
    }

    return null;
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfUserStream(
      {required String userId}) async* {
    BuildContext context = navigatorKey.currentContext!;

    ManagerProvider managerController = Provider.of<ManagerProvider>(context);
    ManagerModel? managerModel =
        await managerController.getMangerWhereUserIs(userId: userId);
    if (managerModel == null) {
      throw Exception('آسف ، ولكن قم بإنشاء مشروع أولاً للبدء');
    }

    Stream<QuerySnapshot> projectsStream = queryWhereStream(
        reference: projectsRef, field: managerIdK, value: managerModel.id);
    yield* projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfManagerStream(
      {required String mangerId}) {
    Stream<QuerySnapshot> projectsStream = queryWhereStream(
        reference: projectsRef, field: managerIdK, value: mangerId);
    return projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfTeamStream(
      {required String teamId}) {
    Stream<QuerySnapshot> projectsStream =
        queryWhereStream(reference: projectsRef, field: teamIdK, value: teamId);
    return projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getProjectsOfTeams(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectsRef, field: teamIdK, value: teamId);
    return list!.cast<ProjectModel>();
  }

  Future<List<ProjectModel?>?> getProjectsOfTeam(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectsRef, field: teamIdK, value: teamId);
    if (list != null && list.isNotEmpty) {
      return list.cast<ProjectModel>();
    }
    return null;
  }

  Future<ProjectModel?> getProjectById({required String id}) async {
    DocumentSnapshot projectDoc =
        await getDocById(reference: projectsRef, id: id);
    return projectDoc.data() as ProjectModel?;
  }

  Stream<DocumentSnapshot<ProjectModel>> getProjectByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> projectDoc =
        getDocByIdStream(reference: projectsRef, id: id);
    return projectDoc.cast<DocumentSnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsWhereteamInStream(
      {required List<String> listteamsId}) {
    return projectsRef
        .where(teamIdK, whereIn: listteamsId)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsWhereIdsIN(
      {required List<String> listProjectsId}) {
    return projectsRef
        .where(idK, whereIn: listProjectsId)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>>
      getProjectsOfManagerWhereUserIsInADayStream({
    required String userId,
    required DateTime date,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    List<String> projectsInTheDay = [];

    Completer<List<String>> completer = Completer<List<String>>();

    getProjectsOfUserStream(userId: userId).listen(
      (event) {
        List<QueryDocumentSnapshot<ProjectModel?>> list = event.docs;
        for (var element in list) {
          ProjectModel projectModel = element.data()!;
          if (projectModel.startDate.isAfter(startOfDay) &&
              projectModel.startDate.isBefore(endOfDay)) {
            projectsInTheDay.add(projectModel.id);
          }
        }

        if (!completer.isCompleted) {
          completer.complete(projectsInTheDay);
        }
      },
    );

    List<String> projectsFinal = await completer.future;

    if (projectsFinal.isEmpty) {
      throw Exception("لا توجد مشاريع أنا مدير لها تبدأ في يوم معين");
    }

    yield* getProjectsWhereIdsIN(listProjectsId: projectsFinal);
  }

  Stream<QuerySnapshot<ProjectModel>>
      getProjectsOfMemberWhereUserIsInADayStream({
    required String userId,
    required DateTime date,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));

    List<String> projectsInTheDay = [];
    List<ProjectModel?> list =
        await getProjectsOfMemberWhereUserIs2(userId: userId);

    for (var projectModel in list) {
      if (projectModel!.startDate.isAfter(startOfDay) &&
          projectModel.startDate.isBefore(endOfDay)) {
        if (!projectsInTheDay.contains(projectModel.id)) {
          projectsInTheDay.add(projectModel.id);
        }
      }
    }

    if (projectsInTheDay.isEmpty) {
      throw Exception("لا توجد مشاريع أنا عضو فيها");
    }

    yield* getProjectsWhereIdsIN(listProjectsId: projectsInTheDay);
  }

  Future<List<ProjectModel?>> getProjectsOfMemberWhereUserIs2(
      {required String userId}) async {
    TeamProvider teamController = TeamProvider();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<ProjectModel?> projects = <ProjectModel>[];
    for (TeamModel team in teams) {
      List<ProjectModel?>? projects2;
      projects2 = await getProjectsOfTeam(teamId: team.id);
      projects2?.forEach((element) {
        projects.add(element);
      });
    }
    return projects;
  }

  Stream<QuerySnapshot<ProjectModel?>> getProjectsOfMemberWhereUserIs2Stream(
      {required String userId}) async* {
    TeamProvider teamController = TeamProvider();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<String> projects = [];
    for (TeamModel team in teams) {
      getProjectsOfTeamStream(teamId: team.id).listen(
        (event) {
          List<QueryDocumentSnapshot<ProjectModel>> list = event.docs;
          for (var element in list) {
            projects.add(element.data().id);
          }
        },
      );
    }
    if (projects.isEmpty) {
      throw Exception("لا توجد مشاريع أنا عضو فيها");
    }
    yield* getProjectsWhereIdsIN(listProjectsId: projects);
  }

  Future<List<ProjectModel?>> getProjectsOfMemberWhereUserIs(
      {required String userId}) async {
    TeamProvider teamController = TeamProvider();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<ProjectModel?> projects = <ProjectModel>[];
    for (TeamModel team in teams) {
      ProjectModel? projectModel = await getProjectOfTeam(teamId: team.id);
      projects.add(projectModel);
    }
    return projects;
  }

  Stream<QuerySnapshot<ProjectModel?>>
      getProjectsOfMemberWhereUserIsStreamOrderBy(
          {required String userId,
          required String field,
          required bool descending}) async* {
    TeamProvider teamController = TeamProvider();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<String> teamsId = <String>[];
    for (TeamModel team in teams) {
      teamsId.add(team.id);
    }

    yield* projectsRef
        .where(teamIdK, whereIn: teamsId)
        .orderBy(descending: descending, nameK)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel?>> getProjectsOfMemberWhereUserIsStream(
      {required String userId}) async* {
    TeamProvider teamController = TeamProvider();

    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);

    List<String> teamsId = <String>[];
    if (teams.isNotEmpty) {
      for (TeamModel team in teams) {
        teamsId.add(team.id);
      }
    } else {
      throw Exception('لست عضوا في أي فريق ليكون لديك مشاريع');
    }

    yield* projectsRef
        .where(teamIdK, whereIn: teamsId)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsStartInASpecificTime(
      {required DateTime date, required String managerId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: projectsRef,
        date: date,
        field: managerIdK,
        value: managerId);
    return list!.cast<ProjectModel>();
  }

  Stream<QuerySnapshot<ProjectModel>>
      getManagerProjectsStartInASpecificTimeStream(
          {required DateTime date, required String managerId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: projectsRef,
        date: date,
        field: managerIdK,
        value: managerId);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String managerId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: projectsRef,
      field: managerIdK,
      value: managerId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<ProjectModel>();
  }

  Stream<QuerySnapshot<ProjectModel>> getManagerProjectsBetweenTowTimesStream(
      {required DateTime firstDate,
      required DateTime secondDate,
      required String managerId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsForAStatus(
      {required String managerId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: projectsRef,
      field: managerIdK,
      value: managerId,
    );
    return list!.cast<ProjectModel>();
  }

  Stream<QuerySnapshot<ProjectModel>> getManagerProjectsForAStatusStream(
      {required String managerId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: projectsRef,
      field: managerIdK,
      value: managerId,
    );
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<double> getPercentOfManagerProjectsForAStatus({
    required String status,
    required String managerId,
  }) async {
    return await getPercentOfTasksForAStatus(
      reference: projectsRef,
      status: status,
      field: managerIdK,
      value: managerId,
    );
  }

  Future<double> getPercentOfManagerProjectsForAStatusBetweenTowTimes({
    required String status,
    required String managerId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: projectsRef,
        status: status,
        field: managerIdK,
        value: managerId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<void> updateProject(
      {required String id,
      required ManagerModel managerModel,
      required Map<String, dynamic> data,
      required ProjectModel oldProject}) async {
    if (data.containsKey(startDateK)) {
      DateTime? newStartDate = data[startDateK] as DateTime;
      if (newStartDate.isAfter(oldProject.endDate!)) {
        throw Exception(
            'لا يمكن تحديث تاريخ بدء المشروع لأن الوقت الجديد لتاريخ البدء هو بعد تاريخ انتهاء المشروع');
      }

      if (oldProject.endDate!.isBefore(firebaseTime(DateTime.now()))) {
        throw Exception(
            'لا يمكن تحديث تاريخ البدء بعد انتهاء تاريخ انتهاء المشروع');
      }
      if (await existByOne(
          collectionReference: projectMainTasksRef,
          field: projectIdK,
          value: id)) {
        throw Exception('عذرًا، تم بدء التنفيذ في المشروع بالفعل');
      }
    }
    if (data.containsKey(teamIdK)) {
      throw Exception('عذرًا، لا يمكن تحديث معرّف الفريق');
    }

    await updateRelationalFields(
      reference: projectsRef,
      data: data,
      id: id,
      fatherField: managerIdK,
      fatherValue: managerModel.id,
      nameException: Exception('هناك بالفعل مشروع بنفس الاسم'),
    );
  }

  Future<void> deleteProject(String id) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot project = await getDocById(reference: projectsRef, id: id);
    ProjectModel projectModel = project.data() as ProjectModel;

    deleteDocUsingBatch(documentSnapshot: project, refbatch: batch);

    await firebaseStorage.refFromURL(projectModel.imageUrl).delete();

    List<DocumentSnapshot> listMainTasks = await getDocsSnapShotWhere(
        collectionReference: projectMainTasksRef, field: projectIdK, value: id);

    List<DocumentSnapshot> listSubTasks = await getDocsSnapShotWhere(
        collectionReference: projectSubTasksRef, field: projectIdK, value: id);

    deleteDocsUsingBatch(list: listMainTasks, refBatch: batch);
    deleteDocsUsingBatch(list: listSubTasks, refBatch: batch);
    batch.commit();
  }
}
