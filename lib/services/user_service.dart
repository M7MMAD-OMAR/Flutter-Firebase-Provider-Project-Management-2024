import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/services/app_service.dart';

import '../Utils/back_utils.dart';
import '../models/User/user_model.dart';
import '../models/User/user_task_model.dart';
import 'collections_refrences.dart';

class UserService extends AppService {
  Future<UserModel> getUserById({required String id}) async {
    DocumentSnapshot doc = await getDocById(reference: usersRef, id: id);
    return doc.data() as UserModel;
  }

  Future<List<UserModel>> getAllUsers() async {
    List<Object?>? list = await getAllListDataForRef(reference: usersRef);
    // List<UserModel> users =
    list!.cast<UserModel>();
    // print(users);
    return list.cast<UserModel>();
  }

  Future<void> createUser({required UserModel userModel}) async {
    await addDoc(reference: usersRef, model: userModel);
  }

  Stream<QuerySnapshot<UserModel>> getAllUsersStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(reference: usersRef);
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
        reference: usersRef, field: 'userName', value: userName, name: name);
    return documentSnapshot.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserByUserNameStream(
      {required String name, required String userName}) async* {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: usersRef, field: 'userName', value: userName, name: name);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Stream<DocumentSnapshot<UserModel>> getUserByIdStream({required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: id);
    return stream.cast<DocumentSnapshot<UserModel>>();
  }

  Stream<QuerySnapshot<UserModel>> getUsersWhereInIdsStream(
      {required List<String> usersId}) {
    Stream<QuerySnapshot<UserModel>> users =
        usersRef.where('id', whereIn: usersId).snapshots();
    return users;
  }

  Future<List<UserModel>> getUsersWhereInIds(
      {required List<String> usersId}) async {
    QuerySnapshot<UserModel> users =
        await usersRef.where('id', whereIn: usersId).get();
    List<UserModel> usersList = [];
    for (var element in users.docs) {
      usersList.add(element.data());
    }
    return usersList;
  }

  Future<void> updateUser(
      {required Map<String, dynamic> data, required String id}) async {
    if (data.containsKey("id")) {
      Exception exception = Exception("حدثت مشكلة أثناء تحديث المستخدم");
      throw exception;
    }
    data['updatedAt'] = firebaseTime(DateTime.now());
    usersRef.doc(id).update(data);
  }
}
