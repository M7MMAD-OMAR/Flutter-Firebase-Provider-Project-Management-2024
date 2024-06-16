import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../tops/Var2TopModel.dart';

class ProjectModel extends Var2TopModel {
  ProjectModel({
    required String nameParameter,
    required String idParameter,
    required String imageUrlParameter,
    required String descriptionParameter,
    required String teamIdParameter,
    required String stausIdParameter,
    required DateTime endDateParameter,
    required DateTime startDateParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required String managerIdParameter,
  }) {
    setId = idParameter;
    setStartDate = startDateParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setDescription = descriptionParameter;
    setEndDate = endDateParameter;
    setName = nameParameter;
    setTeamId = teamIdParameter;
    setStatusId = stausIdParameter;
    setImageUrl = imageUrlParameter;
    setmanagerId = managerIdParameter;
  }

  ProjectModel.firestoreConstructor({
    required String nameParameter,
    required String idParameter,
    required String imageUrlParameter,
    required String descriptionParameter,
    required String teamIdParameter,
    required String stausIdParameter,
    required DateTime endDateParameter,
    required DateTime startDateParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required this.managerId,
  }) {
    id = idParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    description = descriptionParameter;
    endDate = endDateParameter;
    name = nameParameter;
    startDate = startDateParameter;
    teamId = teamIdParameter;
    statusId = stausIdParameter;
    imageUrl = imageUrlParameter;
  }

  final _regex = RegExp(r'^[\p{P}\p{S}\p{N}]+$');
  late String imageUrl;

  set setImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      throw Exception(AppConstants.project_imageUrl_empty_error_key.tr);
    }
    this.imageUrl = imageUrl;
  }

  late String managerId;

  set setmanagerId(String managerIdParameter) {
    managerId = managerIdParameter;
  }

  late String? teamId;

  set setTeamId(String teamIdParameter) {
    teamId = teamIdParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    statusId = statusIdParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);

    if (createdAtParameter.isAfter(now)) {
      throw Exception(AppConstants.project_creating_time_future_error_key.tr);
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception(AppConstants.project_creating_time_past_error_key.tr);
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          AppConstants.project_updating_before_creating_error_key.tr);
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception(AppConstants.project_id_empty_error_key.tr);
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    if (nameParameter.isEmpty) {
      throw Exception(AppConstants.project_name_empty_error_key.tr);
    }

    if (nameParameter.length <= 3) {
      throw Exception(AppConstants.project_name_length_error_key.tr);
    }

    if (_regex.hasMatch(nameParameter)) {
      throw Exception(AppConstants.project_name_format_error_key.tr);
    }

    name = nameParameter;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception(AppConstants.project_start_date_null_error_key.tr);
    }

    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception(AppConstants.project_start_date_past_error_key.tr);
    }

    startDate = firebaseTime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception(AppConstants.project_end_date_null_error_key.tr);
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(getStartDate)) {
      throw Exception(AppConstants.project_end_time_error_key.tr);
    }

    if (getStartDate.isAtSameMomentAs(endDateParameter)) {
      throw Exception(AppConstants.project_end_time_same_error_key.tr);
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      throw Exception(AppConstants.project_time_difference_error_key.tr);
    }
    endDate = endDateParameter;
  }

  factory ProjectModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ProjectModel.firestoreConstructor(
      idParameter: data[idK],
      teamIdParameter: data[teamIdK],
      stausIdParameter: data[statusIdK],
      descriptionParameter: data[descriptionK],
      imageUrlParameter: data[imageUrlK],
      nameParameter: data[nameK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: firebaseTime(data[startDateK].toDate()),
      endDateParameter: firebaseTime(data[endDateK].toDate()),
      managerId: data[managerIdK],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[idK] = id;
    data[teamIdK] = teamId;
    data[statusIdK] = statusId;
    data[descriptionK] = description;
    data[imageUrlK] = imageUrl;
    data[nameK] = name;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    data[startDateK] = startDate;
    data[endDateK] = endDate;
    data[managerIdK] = managerId;
    return data;
  }
}
