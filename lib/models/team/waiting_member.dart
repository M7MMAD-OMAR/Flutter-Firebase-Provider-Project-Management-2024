import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../tops/top_model.dart';

class WaitingMemberModel with TopModel {
  WaitingMemberModel({
    required String idParameter,
    required String userIdParameter,
    required String teamIdParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    setUserId = userIdParameter;
    setTeamId = teamIdParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }

  late String userId;

  late String teamId;

  set setTeamId(String teamId) {
    this.teamId = teamId;
  }

  set setUserId(String userId) {
    this.userId = userId;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(firebaseTime(createdAt))) {
      throw Exception(
          'لا يمكن أن يكون وقت تحديث عضو فريق الانتظار قبل وقت الإنشاء');
    }
    updatedAt = updatedAtParameter;
  }

  factory WaitingMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return WaitingMemberModel(
      idParameter: data[idK],
      userIdParameter: data[userIdK],
      teamIdParameter: data[teamIdK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[idK] = id;
    data[userIdK] = userId;
    data[teamIdK] = teamId;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }

  @override
  set setId(String id) {
    this.id = id;
  }
}
