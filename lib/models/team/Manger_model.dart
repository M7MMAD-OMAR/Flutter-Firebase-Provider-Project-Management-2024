import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/TopModel_model.dart';

class ManagerModel with TopModel {
  late String userId;

  ManagerModel({
    //primary kay

    required String idParameter,
    //forgin kay from UserModel

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
    //primary kay

    required String idParameter,
    //forgin kay from UserModel

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
    Exception exception;

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);

    if (createdAtParameter.isBefore(now)) {
      exception = Exception(
          AppConstants.manager_creating_time_before_now_invalid_key.tr);
      throw exception;
    }

    if (createdAtParameter.isAfter(now)) {
      exception = Exception(
          AppConstants.manager_creating_time_not_in_future_invalid_key.tr);
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setId(String idParameter) {
    Exception exception;

    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.manager_id_empty_key.tr);
      throw exception;
    }

    id = idParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception(AppConstants.updating_time_before_creating_invalid_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  factory ManagerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
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
