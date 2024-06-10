import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/back_utils.dart';
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
      throw Exception("تاريخ التحديث يجب أن يكون بعد تاريخ الإنشاء");
    }
    updatedAt = updatedAtParameter;
  }

  factory WaitingMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return WaitingMemberModel(
      idParameter: data['id'],
      userIdParameter: data['userId'],
      teamIdParameter: data['teamId'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['teamId'] = teamId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  set setId(String id) {
    this.id = id;
  }
}
