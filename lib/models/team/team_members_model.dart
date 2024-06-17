import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

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
      throw Exception(AppConstants.team_member_id_empty_error_key.tr);
    }
    id = idParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception(
          AppConstants.team_member_creating_time_future_error_key.tr);
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception(AppConstants.team_member_creating_time_past_error_key.tr);
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          AppConstants.team_member_updating_time_before_create_error_key.tr);
    }
    updatedAt = updatedAtParameter;
  }

  factory TeamMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return TeamMemberModel.firestoreConstructor(
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
}
