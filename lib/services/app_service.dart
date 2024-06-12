import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utils/back_utils.dart';
import '../models/tops/top_model.dart';

class AppService {
  Future<DocumentSnapshot> getDocById(
      {required CollectionReference reference, required String id}) async {
    return await reference.doc(id).get();
  }

  Future<List<Object?>?> getAllListDataForRef({
    required CollectionReference reference,
  }) async {
    QuerySnapshot<Object?> querySnapshot = await reference.get();

    List<Object?>? listDocs = [];
    for (var doc in querySnapshot.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

  Stream<QuerySnapshot<Object?>> getAllListDataForRefStream({
    required CollectionReference reference,
  }) {
    Query query = reference;
    return query.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> getDocByIdStream(
      {required CollectionReference reference, required String id}) {
    return reference.doc(id).snapshots();
  }

  Future<QueryDocumentSnapshot<Object?>>
      getDocSnapShotByNameInTow<t extends TopModel>({
    required CollectionReference reference,
    required String field,
    required String value,
    required String name,
  }) async {
    return await getDocSnapShotWhereAndWhere(
      collectionReference: reference,
      firstField: 'name',
      firstValue: name,
      secondField: field,
      secondValue: value,
    );
  }

  Future<QueryDocumentSnapshot<Object?>> getDocSnapShotWhereAndWhere({
    required CollectionReference collectionReference,
    required String firstField,
    dynamic firstValue,
    required String secondField,
    dynamic secondValue,
  }) async {
    QuerySnapshot querySnapshot = await queryWhereAndWhere(
        reference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    return list.first;
  }

  Future<QuerySnapshot<Object?>> queryWhereAndWhere({
    required CollectionReference reference,
    required dynamic firstValue,
    required String firstField,
    required String secondField,
    required dynamic secondValue,
  }) async {
    Query query = reference;
    return await query
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .get();
  }

  Stream<DocumentSnapshot<Object?>> getDocByNameInTowStream({
    required CollectionReference reference,
    required String field,
    required String value,
    required String name,
  }) {
    return getDocWhereAndWhereStream(
        collectionReference: reference,
        firstField: field,
        firstValue: value,
        secondField: 'name',
        secondValue: name);
  }

  Stream<DocumentSnapshot<Object?>> getDocWhereAndWhereStream(
      {required CollectionReference collectionReference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async* {
    DocumentSnapshot documentSnapshot = await getDocSnapShotWhereAndWhere(
        collectionReference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    yield* documentSnapshot.reference.snapshots();
  }

  Future<QueryDocumentSnapshot<Object?>?> getDocSnapShotWhere(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async {
    QuerySnapshot querySnapshot = await queryWhere(
        reference: collectionReference, field: field, value: value);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    if (list.isEmpty) {
      return null;
    }
    return list.first;
  }

  Future<QuerySnapshot<Object?>> queryWhere({
    required CollectionReference reference,
    required dynamic value,
    required String field,
  }) async {
    Query query = reference.where(field, isEqualTo: value);
    return await query.get();
  }

  Future<QueryDocumentSnapshot<Object?>?>
      getDocSnapShotByName<t extends TopModel>({
    required CollectionReference reference,
    required String name,
  }) async {
    return await getDocSnapShotWhere(
      collectionReference: reference,
      field: 'name',
      value: name,
    );
  }

  Stream<DocumentSnapshot<Object?>> getDocByNameStream({
    required CollectionReference reference,
    required String name,
  }) {
    return getDocWhereStream(
      collectionReference: reference,
      field: 'name',
      value: name,
    );
  }

  Stream<DocumentSnapshot> getDocWhereStream(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async* {
    DocumentSnapshot? doc = await getDocSnapShotWhere(
        collectionReference: collectionReference, field: field, value: value);
    yield* doc!.reference.snapshots();
  }

  //اضافة دوكيومنت
  Future<void> addDoc(
      {required CollectionReference reference, required TopModel model}) async {
    await reference.doc(model.id).set(model);
  }

  void deleteDocUsingBatch(
      {required DocumentSnapshot? documentSnapshot,
      required WriteBatch refbatch}) {
    WriteBatch writeBatch = refbatch;
    if (documentSnapshot != null) {
      writeBatch.delete(documentSnapshot.reference);
    }
  }

  void deleteDocsUsingBatch(
      {required List<DocumentSnapshot?> list, required WriteBatch refBatch}) {
    final batch = refBatch;

    for (var doc in list) {
      if (doc != null) {
        batch.delete(doc.reference);
      }
    }
  }

  Future<void> updateRelationalFields({
    required CollectionReference reference,
    required Map<String, dynamic> data,
    required String id,
    required String fatherField,
    required String fatherValue,
    required Exception nameException,
  }) async {
    await updateFields(
        data: data,
        field: fatherField,
        haveFather: true,
        id: id,
        nameException: nameException,
        reference: reference,
        value: fatherValue);
  }

  Future<void> updateNonRelationalFields({
    required CollectionReference reference,
    required Map<String, dynamic> data,
    required String id,
    required Exception nameException,
  }) async {
    await updateFields(
      data: data,
      field: null,
      haveFather: false,
      id: id,
      nameException: nameException,
      reference: reference,
      value: null,
    );
  }

  Future<void> updateFields({
    required CollectionReference reference,
    required Map<String, dynamic> data,
    required String id,
    required String? field,
    required String? value,
    required bool haveFather,
    required Exception nameException,
  }) async {
    DocumentSnapshot doc = await getDocById(reference: reference, id: id);
    if (data.containsKey('name')) {
      if (haveFather) {
        if (await existByTow(
              reference: reference,
              value: data['name'],
              field: 'name',
              value2: value,
              field2: field!,
            ) &&
            data['name'] != doc.get('name')) {
          throw nameException;
        }
      }
      if (await existByOne(
            collectionReference: reference,
            value: data['name'],
            field: 'name',
          ) &&
          data['name'] != doc.get('name')) {
        throw nameException;
      }
    }
    if (data.containsKey("id")) {
      Exception exception = Exception(
          "لا يمكن تحديث المعرف ... هذه الطريقة فقط لتحديث الحقول غير العلائقية");
      throw exception;
    }
    data['updatedAt'] = firebaseTime(DateTime.now());
    reference.doc(id).update(data);
  }

  Future<bool> existByOne({
    required CollectionReference collectionReference,
    required dynamic value,
    required String field,
  }) async {
    Query query = collectionReference;
    AggregateQuerySnapshot querySnapshot =
        await query.where(field, isEqualTo: value).count().get();

    if (querySnapshot.count! >= 1) {
      return true;
    }
    return false;
  }

  Future<bool> existByTow({
    required CollectionReference reference,
    required dynamic value,
    required String field,
    required dynamic value2,
    required String field2,
  }) async {
    Query query = reference;
    AggregateQuerySnapshot querySnapshot = await query
        .where(field, isEqualTo: value)
        .where(field2, isEqualTo: value2)
        .count()
        .get();
    if (querySnapshot.count! >= 1) {
      return true;
    }
    return false;
    // return querySnapshot.count;
  }

  Future<bool> existInTowPlaces({
    required CollectionReference firstCollectionReference,
    required String firstFiled,
    dynamic firstValue,
    required CollectionReference secondCollectionReference,
    required String secondFiled,
    dynamic secondValue,
  }) async {
    if (await existByOne(
            collectionReference: firstCollectionReference,
            field: firstFiled,
            value: firstValue) &&
        await existByOne(
            collectionReference: secondCollectionReference,
            field: secondFiled,
            value: secondValue)) {
      return true;
    }
    return false;
  }
}
