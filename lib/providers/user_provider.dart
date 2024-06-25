import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_management_muhmad_omar/providers/team_member_provider.dart';
import 'package:project_management_muhmad_omar/providers/top_provider.dart';
import 'package:provider/provider.dart';

import '../constants/back_constants.dart';
import '../constants/constants.dart';
import '../models/task/user_task_category_model.dart';
import '../models/team/manger_model.dart';
import '../models/team/team_members_model.dart';
import '../models/user/user_model.dart';
import '../models/user/user_task_Model.dart';
import '../services/collections_refrences.dart';
import '../utils/back_utils.dart';
import 'task_category_provider.dart';
import 'manger_provider.dart';

class UserProvider extends TopProvider {
  static late List<UserModel> users;

  UserProvider() {
    _initializeUsers();
  }

  Future<void> _initializeUsers() async {
    users = await getAllUsers();
  }

  Future<UserModel> getUserById({required String id}) async {
    DocumentSnapshot doc = await getDocById(reference: usersRef, id: id);
    return doc.data() as UserModel;
  }

  Future<List<UserModel>> getAllUsers() async {
    List<Object?>? list = await getAllListDataForRef(refrence: usersRef);
    List<UserModel> users1 = list!.cast<UserModel>();
    users = users1;
    return users1;
  }

  Stream<QuerySnapshot<UserModel>> getAllUsersStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(refrence: usersRef);
    return stream.cast<QuerySnapshot<UserModel>>();
  }

  Future<UserModel> getUserOfTask({required String userTaskId}) async {
    DocumentSnapshot userTaskDoc = await usersTasksRef.doc(userTaskId).get();
    UserTaskModel userTaskModel = userTaskDoc.data() as UserTaskModel;

    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: userTaskModel.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserOfTaskStream(
      {required String userTaskId}) async* {
    DocumentSnapshot userTaskDoc = await usersTasksRef.doc(userTaskId).get();
    UserTaskModel userTaskModel = userTaskDoc.data() as UserTaskModel;

    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: userTaskModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserByUserName(
      {required String name, required String userName}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: usersRef, field: userNameK, value: userName, name: name);
    return documentSnapshot.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserByUserNameStream(
      {required String name, required String userName}) async* {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: usersRef, field: userNameK, value: userName, name: name);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserOfCategory({required String categoryId}) async {
    BuildContext context = navigatorKey.currentContext!;

    TaskCategoryProvider taskCategoryController =
        Provider.of<TaskCategoryProvider>(context);
    UserTaskCategoryModel userTaskCategoryModel =
        await taskCategoryController.getCategoryById(id: categoryId);
    UserModel userModel = await getUserById(id: userTaskCategoryModel.userId);
    return userModel;
  }

  getUserOfcategoryStream({required String categoryId}) async* {
    BuildContext context = navigatorKey.currentContext!;

    TaskCategoryProvider taskCategoryController =
        Provider.of<TaskCategoryProvider>(context);
    UserTaskCategoryModel userTaskCategoryModel =
        await taskCategoryController.getCategoryById(id: categoryId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: userTaskCategoryModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Stream<DocumentSnapshot<UserModel>> getUserByIdStream({required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: id);
    return stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserWhereMangerIs({required String mangerId}) async {
    BuildContext context = navigatorKey.currentContext!;

    ManagerProvider mangerController = Provider.of<ManagerProvider>(context);
    ManagerModel managerModel =
        await mangerController.getMangerById(id: mangerId);
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: managerModel.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserWhereMangerIsStream(
      {required String mangerId}) async* {
    BuildContext context = navigatorKey.currentContext!;

    ManagerProvider mangerController = Provider.of<ManagerProvider>(context);
    ManagerModel managerModel =
        await mangerController.getMangerById(id: mangerId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: managerModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserWhereMemberIs({required String memberId}) async {
    BuildContext context = navigatorKey.currentContext!;

    TeamMemberProvider memberController =
        Provider.of<TeamMemberProvider>(context);
    TeamMemberModel member =
        await memberController.getMemberById(memberId: memberId);
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: member.userId);
    return userDoc.data() as UserModel;
  }

  Stream<QuerySnapshot<UserModel>> getUsersWhereInIdsStream(
      {required List<String> usersId}) {
    Stream<QuerySnapshot<UserModel>> users =
        usersRef.where(idK, whereIn: usersId).snapshots();
    return users;
  }

  Future<List<UserModel>> getUsersWhereInIds(
      {required List<String> usersId}) async {
    QuerySnapshot<UserModel> users =
        await usersRef.where(idK, whereIn: usersId).get();
    List<UserModel> usersList = [];
    for (var element in users.docs) {
      usersList.add(element.data());
    }
    return usersList;
  }

  Stream<DocumentSnapshot<UserModel>> getUserWhereMemberIsStream(
      {required String memberId}) async* {
    BuildContext context = navigatorKey.currentContext!;

    TeamMemberProvider memberController =
        Provider.of<TeamMemberProvider>(context);
    TeamMemberModel member =
        await memberController.getMemberById(memberId: memberId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: member.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<void> createUser({required UserModel userModel}) async {
    await userModel.addTokenFcm();
    await addDoc(reference: usersRef, model: userModel);
  }

  Future<void> updateUser(
      {required Map<String, dynamic> data, required String id}) async {
    if (data.containsKey(idK)) {
      throw Exception('خطأ في تحديث معرف المستخدم');
    }
    data[updatedAtK] = firebaseTime(DateTime.now());
    usersRef.doc(id).update(data);
  }

  Future<void> deleteUser({required String id}) async {
    BuildContext context = navigatorKey.currentContext!;

    ManagerProvider mangerController = Provider.of<ManagerProvider>(context);
    WriteBatch batch = fireStore.batch();
    List<DocumentSnapshot> membrs = await getDocsSnapShotWhere(
        collectionReference: teamMembersRef, field: userIdK, value: id);
    List<DocumentSnapshot> listAllSubTasks = [];
    deleteDocsUsingBatch(list: membrs, refBatch: batch);
    for (var member in membrs) {
      List<DocumentSnapshot> listOfSubTasks = await getDocsSnapShotWhere(
          collectionReference: projectSubTasksRef,
          field: assignedToK,
          value: member.id);
      listAllSubTasks.addAll(listOfSubTasks);
    }
    deleteDocsUsingBatch(list: listAllSubTasks, refBatch: batch);

    ManagerModel? managerModel =
        await mangerController.getMangerWhereUserIs(userId: id);
    deleteDocUsingBatch(
        documentSnapshot: await usersRef.doc(id).get(), refbatch: batch);

    await mangerController.deleteManger(
        id: managerModel!.id, writeBatch: batch);
  }
}
