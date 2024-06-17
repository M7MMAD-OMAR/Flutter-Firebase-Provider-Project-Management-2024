import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/controllers/topController.dart';
import 'package:project_management_muhmad_omar/models/status_model.dart';
import 'package:project_management_muhmad_omar/services/collections_refrences.dart';

import '../constants/back_constants.dart';

class StatusController extends TopController {
  Future<List<StatusModel>> getAllStatuses() async {
    List<Object?>? list = await getAllListDataForRef(refrence: statusesRef);
    return list!.cast<StatusModel>();
  }
  Future<StatusModel> getStatusById({required String statusId}) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: idK,
      value: statusId,
    );
    return documentSnapshot!.data() as StatusModel;
  }
  Stream<DocumentSnapshot<StatusModel>> getStatusByIdStream(
      {required String idk}) {
    Stream<DocumentSnapshot<Object?>> statusDoc = getDocWhereStream(
        collectionReference: statusesRef, field: idK, value: idk);
    return statusDoc.cast<DocumentSnapshot<StatusModel>>();
  }

  Future<StatusModel> getStatusByName({required String status}) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    return documentSnapshot!.data() as StatusModel;
  }

  Future<void> addStatus(StatusModel statusModel) async {
    bool exist = await existByOne(
        collectionReference: statusesRef,
        value: statusModel.name,
        field: nameK);
    if (exist) {
      throw Exception('اسم الحالة تمت إضافته بالفعل');
    }
    await addDoc(model: statusModel, reference: statusesRef);
  }

  Future<void> deleteStatus(String id) async {
    DocumentSnapshot documentSnapshot =
        await getDocById(reference: statusesRef, id: id);
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(documentSnapshot: documentSnapshot, refbatch: batch);
    batch.commit();
  }

  Future<void> updateStatus(StatusModel statusModel) async {
    DocumentSnapshot? snapshot = await getDocSnapShotWhereAndNotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: statusModel.name,
      notField: idK,
      notValue: statusModel.id,
    );
    if (snapshot == null) {
      await addDoc(model: statusModel, reference: statusesRef);
      return;
    } else {
      throw Exception('اسم الحالة تمت إضافته بالفعل');
    }
  }

  Future<void> updateStatus2(
      {required id, required Map<String, dynamic> data}) async {
    if (data.containsKey(id)) {
      throw Exception('عذرًا، لا يمكن تحديث معرّف الحالة');
    }

    await updateNonRelationalFields(
        reference: teamMembersRef,
        data: data,
        id: id,
        nameException: Exception('الحالة تمت إضافتها بالفعل'));
  }
}
