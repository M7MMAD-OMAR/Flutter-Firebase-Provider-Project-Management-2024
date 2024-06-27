import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../constants/app_constans.dart';
import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/Var2TopModel.dart';

class ProjectModel extends Var2TopModel {
  ProjectModel({
    required String nameParameter,

    //primary key
    required String idParameter,
    required String imageUrlParameter,
    required String descriptionParameter,

    //foreign key
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

    //primary key
    required String idParameter,
    required String imageUrlParameter,
    required String descriptionParameter,

    //foreign key
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
    Exception exception;
    if (imageUrl.isEmpty) {
      exception = Exception(AppConstants.project_imageUrl_empty_error_key.tr);
      throw exception;
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
    Exception exception;

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);

    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.project_creating_time_future_error_key.tr);
      throw exception;
    }

    if (createdAtParameter.isBefore(now)) {
      exception =
          Exception(AppConstants.project_creating_time_past_error_key.tr);
      throw exception;
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception(AppConstants.project_updating_before_creating_error_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    Exception exception;

    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.project_id_empty_error_key.tr);
      throw exception;
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    if (nameParameter.isEmpty) {
      exception = Exception(AppConstants.project_name_empty_error_key.tr);
      throw exception;
    }

    if (nameParameter.length <= 3) {
      exception = Exception(AppConstants.project_name_length_error_key.tr);
      throw exception;
    }

    if (_regex.hasMatch(nameParameter)) {
      exception = Exception(AppConstants.project_name_format_error_key.tr);
      throw exception;
    }

    // if (projectexist(nameParameter)) {
    //   exception = Exception("project main task already been added");
    //   throw exception;
    // }

    name = nameParameter;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    Exception exception;

    if (startDateParameter == null) {
      exception = Exception(AppConstants.project_start_date_null_error_key.tr);
      throw exception;
    }

    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      exception = Exception(AppConstants.project_start_date_past_error_key.tr);
      throw exception;
    }

    startDate = firebaseTime(startDateParameter);
  }

  // // TODO:this method is just for demo make the method to make a query in firebase to know that if there is another task in the same time for this model
  // bool dateduplicated(DateTime starttime) {
  //   return true;
  // }

  @override
  set setEndDate(DateTime? endDateParameter) {
    Exception exception;

    if (endDateParameter == null) {
      exception = Exception(AppConstants.project_end_date_null_error_key.tr);
      throw exception;
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(getStartDate)) {
      exception = Exception(AppConstants.project_end_time_error_key.tr);
      throw exception;
    }

    if (getStartDate.isAtSameMomentAs(endDateParameter)) {
      exception = Exception(AppConstants.project_end_time_same_error_key.tr);
      throw exception;
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      exception = Exception(AppConstants.project_time_difference_error_key.tr);
      throw exception;
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
