import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import 'Task_model.dart';
//TODO use the firebase time

class ProjectMainTaskModel extends TaskClass {
  ProjectMainTaskModel({
    //foreign key
    required String projectIdParameter,
    required String descriptionParameter,

    //primary key
    required String idParameter,
    required String nameParameter,

    //foreign key
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
    required String hexColorParameter,
  }) {
    setHexColor = hexColorParameter;

    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
    setprojectId = projectIdParameter;
  }
  ProjectMainTaskModel.firestoreConstructor({
    //foreign key
    required String projectIdParameter,
    String? descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
    required String hexColorParameter,
  }) {
    hexcolor = hexColorParameter;
    projectId = projectIdParameter;
    id = idParameter;
    description = descriptionParameter;
    name = nameParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
  }
  late String projectId;

  @override
  set setHexColor(String hexcolorParameter) {
    Exception exception;
    if (hexcolorParameter.isEmpty) {
      exception = Exception(AppConstants.main_task_color_empty_key);
      throw exception;
    }
    hexcolor = hexcolorParameter;
  }

  @override
  set setId(String idParameter) {
    Exception exception;

    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.project_main_task_id_empty_key);
      throw exception;
    }
    id = idParameter;
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if the task name already been stored in the firebase for this project for this model
  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    if (nameParameter.isEmpty) {
      exception = Exception(AppConstants.project_main_task_name_empty_key);
      throw exception;
    }

    name = nameParameter;
  }

  set setprojectId(String projectIdParameter) {
    Exception exception;

    if (projectIdParameter.isEmpty) {
      exception = Exception(AppConstants.project_id_empty_key);
      throw exception;
    }
    projectId = projectIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    Exception exception;

    if (statusIdParameter.isEmpty) {
      exception = Exception(AppConstants.main_task_status_id_empty_key);
      throw exception;
    }

    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    Exception exception;

    if (importanceParameter < 1) {
      exception = Exception(AppConstants.main_task_importance_min_invalid_key);
      throw exception;
    }

    if (importanceParameter > 5) {
      exception = Exception(AppConstants.main_task_importance_max_invalid_key);
      throw exception;
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      exception = Exception(
          AppConstants.main_task_create_time_not_in_future_invalid_key);
      throw exception;
    }

    if (createdAtParameter.isBefore(now)) {
      exception =
          Exception(AppConstants.main_task_create_time_in_past_error_key);
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      exception = Exception(
          AppConstants.main_task_updating_time_not_in_future_invalid_key);
      throw exception;
    }
    updatedAt = (updatedAtParameter);
  }

  bool dateduplicated(DateTime starttime) {
    return true;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    Exception exception;
    if (startDateParameter == null) {
      exception = Exception(AppConstants.main_task_start_date_null_key);
      throw exception;
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      exception = Exception(AppConstants.main_task_start_date_past_error_key);
      throw exception;
    }

    startDate = (startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    Exception exception;

    if (endDateParameter == null) {
      exception = Exception(AppConstants.main_task_end_date_null_key);
      throw exception;
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(startDate)) {
      exception = Exception(AppConstants.main_task_start_after_end_error_key);
      throw exception;
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      exception = Exception(AppConstants.main_task_date_difference_error_key);
      throw exception;
    }

    //TODO check this line
    if (endDateParameter.isAtSameMomentAs(getStartDate)) {
      exception = Exception(
        AppConstants.main_task_start_same_as_end_error_key,
      );
      throw exception;
    }

    endDate = endDateParameter;
  }

  factory ProjectMainTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectMainTaskModel.firestoreConstructor(
      hexColorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      descriptionParameter: data[descriptionK],
      projectIdParameter: data[projectIdK],
      statusIdParameter: data[statusIdK],
      importanceParameter: data[importanceK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: data[startDateK].toDate(),
      endDateParameter: data[endDateK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      colorK: hexcolor,
      nameK: name,
      idK: id,
      descriptionK: description,
      projectIdK: projectId,
      statusIdK: statusId,
      importanceK: importance,
      createdAtK: createdAt,
      updatedAtK: updatedAt,
      startDateK: startDate,
      endDateK: endDate,
    };
  }

  @override
  String toString() {
    return "main task name is:$name id:$id  description:$description projectId:$projectId  statusId:$statusId importance:$importance startDate:$startDate endDate:$endDate createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
