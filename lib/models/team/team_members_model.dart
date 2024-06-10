import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/back_utils.dart';
import '../tops/top_model.dart';

class TeamMemberModel with TopModel {
  TeamMemberModel({
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

  TeamMemberModel.firestoreConstructor({
    required String idParameter,
    required String userIdParameter,
    required String teamIdParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    userId = userIdParameter;
    teamId = teamIdParameter;
    id = idParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
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
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }
    id = idParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception("يجب أن يكون تاريخ الإضافة قبل الوقت الحالي");
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception("التاريخ لا يمكن أن يكون قبل الوقت الحالي");
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("تاريخ التحديث لا يمكن أن يكون قبل تاريخ الإنشاء");
    }
    updatedAt = updatedAtParameter;
  }

  factory TeamMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return TeamMemberModel.firestoreConstructor(
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
}
