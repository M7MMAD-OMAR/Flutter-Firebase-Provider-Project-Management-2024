import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

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
      throw Exception('لا يمكن أن يكون وقت إنشاء المدير في الماضي');
    }

    if (createdAtParameter.isAfter(now)) {
      throw Exception('لا يمكن أن يكون وقت إنشاء المدير في المستقبل');
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف المدير فارغًا');
    }

    id = idParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception('لا يمكن أن يكون وقت التحديث قبل وقت الإنشاء');
    }
    updatedAt = updatedAtParameter;
  }

  factory ManagerModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data()!;

    return ManagerModel.firestoreConstructor(
      idParameter: data[idK],
      userIdParameter: data[userIdK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[idK] = id;
    data[userIdK] = userId;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "manager id is $id user Id is $userId  createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
