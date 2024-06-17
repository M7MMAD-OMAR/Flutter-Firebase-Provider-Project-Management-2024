import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/controllers/manger_controller.dart';
import 'package:project_management_muhmad_omar/controllers/team_member_controller.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/models/team/manger_model.dart';
import 'package:project_management_muhmad_omar/models/team/team_members_model.dart';

import '../constants/back_constants.dart';
import '../models/team/project_model.dart';
import '../models/team/teamModel.dart';
import '../models/tops/top_model.dart';
import '../services/collections_refrences.dart';

class TeamController extends TopController {
  Future<void> addTeam(TeamModel teamModel) async {
    if (await existByOne(
        collectionReference: managersRef,
        field: idK,
        value: teamModel.managerId)) {
      await addDoc(reference: teamsRef, model: teamModel);
    } else {
      throw Exception('عذرًا، مدير المشروع غير موجود');
    }
  }

  Future<List<TeamModel>> getAllTeams() async {
    List<Object?>? list = await getAllListDataForRef(refrence: teamsRef);

    return list!.cast<TeamModel>();
  }

  Stream<QuerySnapshot<TeamModel>> getAllTeamsStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(refrence: teamsRef);
    return stream.cast<QuerySnapshot<TeamModel>>();
  }

  Stream<DocumentSnapshot<TeamModel>> getTeamByIdStream<t extends TopModel>(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: teamsRef, id: id);
    return stream.cast<DocumentSnapshot<TeamModel>>();
  }

  Future<List<TeamModel>> getTeamsofMemberWhereUserId({required userId}) async {
    TeamMemberController teamMemberController = TeamMemberController();
    List<TeamMemberModel> listMembers =
        await teamMemberController.getMemberWhereUserIs(userId: userId);

    List<TeamModel> listOfTeams = <TeamModel>[];
    for (TeamMemberModel member in listMembers) {
      TeamModel team = await getTeamById(id: member.teamId);
      listOfTeams.add(team);
    }
    return listOfTeams;
  }

  Stream<QuerySnapshot<TeamModel>> getTeamsofProjectsStream(
      {required List<ProjectModel> projects}) {
    List<String> teamsId = <String>[];
    for (var project in projects) {
      teamsId.add(project.teamId!);
    }
    return teamsRef
        .where(idK, whereIn: teamsId)
        .snapshots()
        .cast<QuerySnapshot<TeamModel>>();
  }

  Stream<QuerySnapshot<TeamModel>> getTeamsofMemberWhereUserIdStream(
      {required userId}) async* {
    TeamMemberController teamMemberController = TeamMemberController();
    List<TeamMemberModel> listMembers =
        await teamMemberController.getMemberWhereUserIs(userId: userId);
    if (listMembers.isEmpty) {
      throw Exception('أنت لست عضواً بعد في أي فريق');
    }
    List<String> teamsId = <String>[];
    for (TeamMemberModel member in listMembers) {
      teamsId.add(member.teamId);
    }
    Stream<QuerySnapshot<Object?>> teams =
        teamsRef.where(idK, whereIn: teamsId).snapshots();
    yield* teams.cast<QuerySnapshot<TeamModel>>();
  }

  Future<List<TeamModel>?> getTeamsOfUser({required String userId}) async {
    ManagerController controller = Get.put(ManagerController());
    ManagerModel? managerModel =
        await controller.getMangerWhereUserIs(userId: userId);
    if (managerModel != null) {
      return getTeamsOfManager(managerId: managerModel.id);
    }
    return null;
  }

  Stream<QuerySnapshot<TeamModel>?> getTeamsOfUserStream(
      {required String userId}) async* {
    ManagerController controller = Get.put(ManagerController());
    ManagerModel? managerModel =
        await controller.getMangerWhereUserIs(userId: userId);
    if (managerModel == null) {
      throw Exception("You dont have any team yet");
    }
    yield* getTeamsOfManagerStream(managerId: managerModel.id);
  }

  Future<List<TeamModel>> getTeamsOfManager({required String managerId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: teamsRef, field: managerIdK, value: managerId);
    return list!.cast<TeamModel>();
  }

  Stream<QuerySnapshot<TeamModel>> getTeamsOfManagerStream(
      {required String managerId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: teamsRef, field: managerIdK, value: managerId);
    return stream.cast<QuerySnapshot<TeamModel>>();
  }

  Future<TeamModel> getTeamById({required String id}) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
        collectionReference: teamsRef, field: idK, value: id);
    return documentSnapshot?.data() as TeamModel;
  }

  Future<TeamModel> getTeamByName(
      {required String name, required String managerId}) async {
    DocumentSnapshot? doc = await getDocSnapShotByNameInTow(
        reference: teamsRef, field: managerIdK, value: managerId, name: name);
    return doc.data() as TeamModel;
  }

  Stream<DocumentSnapshot<TeamModel>> getTeamByNameNameStream(
      {required String name, required String managerId}) async* {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: teamsRef, field: managerIdK, value: managerId, name: name);
    yield* stream.cast<DocumentSnapshot<TeamModel>>();
  }

  Future<TeamModel> getTeamOfProject({required ProjectModel project}) async {
    DocumentSnapshot? doc = await getDocSnapShotWhere(
        collectionReference: teamsRef, field: idK, value: project.teamId);
    return doc!.data() as TeamModel;
  }

  Stream<DocumentSnapshot<TeamModel>> getTeamOfProjectStream(
      {required ProjectModel project}) {
    Stream<DocumentSnapshot> stream = getDocWhereStream(
        collectionReference: teamsRef, field: idK, value: project.teamId);
    return stream.cast<DocumentSnapshot<TeamModel>>();
  }

  Future<void> updateTeam(String id, Map<String, dynamic> data) async {
    if (data.containsKey(managerIdK)) {
      throw Exception('لا يمكن تحديث معرّف المدير');
    }
    ManagerController managerController = Get.put(ManagerController());
    ManagerModel managerModel =
        await managerController.getMangerOfTeam(teamId: id);
    await updateRelationalFields(
        reference: teamsRef,
        data: data,
        id: id,
        fatherField: managerIdK,
        fatherValue: managerModel.id,
        nameException: Exception(""));
  }

  deleteTeam({required String id, required List<String> projectIds}) async {
    WriteBatch batch = fireStore.batch();

    DocumentSnapshot team = await getDocById(reference: teamsRef, id: id);

    deleteDocUsingBatch(documentSnapshot: team, refbatch: batch);
    for (var projectId in projectIds) {
      DocumentSnapshot? project =
          await getDocById(reference: projectsRef, id: projectId);

      deleteDocUsingBatch(documentSnapshot: project, refbatch: batch);

      List<DocumentSnapshot> projectMembers = await getDocsSnapShotWhere(
        collectionReference: teamMembersRef,
        field: projectIdK,
        value: projectId,
      );

      deleteDocsUsingBatch(list: projectMembers, refBatch: batch);

      List<DocumentSnapshot> mainTasks = await getDocsSnapShotWhere(
        collectionReference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
      );

      deleteDocsUsingBatch(list: mainTasks, refBatch: batch);

      List<DocumentSnapshot> subTasks = [];
      for (var member in projectMembers) {
        List<DocumentSnapshot> memberSubTasks = await getDocsSnapShotWhere(
          collectionReference: projectSubTasksRef,
          field: assignedToK,
          value: member.id,
        );
        subTasks.addAll(memberSubTasks);
      }

      deleteDocsUsingBatch(list: subTasks, refBatch: batch);
    }

    batch.commit();
  }
}
