import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/providers/top_provider.dart';

import '../constants/back_constants.dart';
import '../models/task/user_task_category_model.dart';
import '../models/user/user_task_Model.dart';
import '../services/collections_refrences.dart';

class TaskCategoryProvider extends TopProvider {
  Stream<DocumentSnapshot<UserTaskCategoryModel>> getCategoryByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: userTaskCategoryRef, id: id);
    return stream.cast<DocumentSnapshot<UserTaskCategoryModel>>();
  }

  Future<UserTaskCategoryModel> getCategoryById({required String id}) async {
    DocumentSnapshot doc =
        await getDocById(reference: userTaskCategoryRef, id: id);
    return doc.data() as UserTaskCategoryModel;
  }

  Future<List<UserTaskCategoryModel>> getUserCategories(
      {required String userId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: userTaskCategoryRef,
        field: userIdK,
        value: userId);

    return list!.cast<UserTaskCategoryModel>();
  }

  Stream<QuerySnapshot<UserTaskCategoryModel>> getUserCategoriesStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: userTaskCategoryRef, field: userIdK, value: userId);
    return stream.cast<QuerySnapshot<UserTaskCategoryModel>>();
  }

  Future<UserTaskCategoryModel> getCategoryByNameForUser(
      {required String name, required String userId}) async {
    DocumentSnapshot doc = await getDocSnapShotWhereAndWhere(
        collectionReference: userTaskCategoryRef,
        firstField: nameK,
        firstValue: name,
        secondField: userIdK,
        secondValue: userId);
    return doc.data() as UserTaskCategoryModel;
  }

  Stream<DocumentSnapshot<UserTaskCategoryModel>>
      getCategoryByNameForUserStream(
          {required String name, required String userId}) async* {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: userTaskCategoryRef,
        firstField: nameK,
        firstValue: name,
        secondField: nameK,
        secondValue: userId);
    yield* stream.cast<DocumentSnapshot<UserTaskCategoryModel>>();
  }

  Future<List<UserTaskModel>> getTasksByCategory(String folderId) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: usersTasksRef, field: folderIdK, value: folderId);
    return list!.cast<UserTaskModel>();
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getTasksByCategoryQuery(
      String folderId) async {
    dev.log("1");
    List<QueryDocumentSnapshot<Object?>> list = await getDocsSnapShotWhere(
        collectionReference: usersTasksRef, field: folderIdK, value: folderId);
    return list;
  }

  Future<void> addCategory(UserTaskCategoryModel taskCategoryModel) async {
    bool? exist = await existByOne(
        collectionReference: usersRef,
        field: idK,
        value: taskCategoryModel.userId);
    if (exist == true) {
      if (await existByTow(
          reference: userTaskCategoryRef,
          field: nameK,
          value: taskCategoryModel.name,
          field2: userIdK,
          value2: taskCategoryModel.userId)) {
        throw Exception('عذراً هناك صنف موجود بنفس الاسم');
      }
      addDoc(reference: userTaskCategoryRef, model: taskCategoryModel);
      dev.log("message");
      return;
    }
    throw Exception('عذرا ، لا يمكن العثور على معرف المستخدم');
  }

  updateCategory(
      {required Map<String, dynamic> data, required String id}) async {
    UserTaskCategoryModel userTaskCategoryModel = await getCategoryById(id: id);
    await updateRelationalFields(
      reference: userTaskCategoryRef,
      data: data,
      id: id,
      fatherField: userIdK,
      fatherValue: userTaskCategoryModel.userId,
      nameException: Exception('الفئة تمت إضافتها بالفعل'),
    );
  }

  deleteCategory(String categoryId) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot cat =
        await getDocById(reference: userTaskCategoryRef, id: categoryId);
    deleteDocUsingBatch(documentSnapshot: cat, refbatch: batch);
    List<QueryDocumentSnapshot> listTasks = await getDocsSnapShotWhere(
        collectionReference: usersTasksRef, field: folderIdK, value: cat.id);
    deleteDocsUsingBatch(list: listTasks, refBatch: batch);
    batch.commit();
  }
}
