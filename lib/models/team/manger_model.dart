import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/back_utils.dart';
import '../tops/top_model.dart';

class ManagerModel with TopModel {
  late String userId;

  ManagerModel({
    required String idParameter,
    required String userIdParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    setUserId = userIdParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }

  ManagerModel.firestoreConstructor({
    required String idParameter,
    required String userIdParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    id = idParameter;
    userId = userIdParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }

  set setUserId(String userIdParameter) {
    userId = userIdParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);

    if (createdAtParameter.isBefore(now)) {
      throw Exception(
          "لايمكن أن يكون وقت الإنشاء الخاص بالمدير قبل الوقت الحالي");
    }

    if (createdAtParameter.isAfter(now)) {
      throw Exception(
          "لايمكن أن يكون وقت الإنشاء الخاص بالمدير بعد الوقت الحالي");
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }

    id = idParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          "لايمكن أن يكون تاريخ التحديث الخاص بالمدير قبل تاريخ الإنشاء");
    }
    updatedAt = updatedAtParameter;
  }

  factory ManagerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ManagerModel.firestoreConstructor(
      idParameter: data['id'],
      userIdParameter: data['userId'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "manager id is $id user Id is $userId  createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
