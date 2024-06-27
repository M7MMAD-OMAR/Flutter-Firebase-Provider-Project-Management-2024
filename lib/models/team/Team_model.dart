import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/VarTopModel.dart';

class TeamModel extends VarTopModel {
  late String imageUrl;

  //forgin kay from MangerModel

  late String managerId;

  TeamModel({
    //primary key
    required String idParameter,

    //foreign key
    required String managerIdParameter,
    required String nameParameter,
    required String imageUrlParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    setId = idParameter;
    setmangerId = managerIdParameter;
    setName = nameParameter;
    setImageUrl = imageUrlParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }

  TeamModel.firestoreConstructor({
    required String idParameter,

    //foreign key
    required String mangerIdParameter,
    required String nameParameter,
    required String imageUrlParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    id = idParameter;
    managerId = mangerIdParameter;
    name = nameParameter;
    imageUrl = imageUrlParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }

  set setmangerId(String mangerId) {
    managerId = mangerId;
  }

  set setImageUrl(String imageUrl) {
    Exception exception;
    if (imageUrl.isEmpty) {
      exception = Exception(AppConstants.team_image_empty_error_key.tr);
      throw exception;
    }
    this.imageUrl = imageUrl;
  }

  @override
  set setId(String id) {
    Exception exception;

    if (id.isEmpty) {
      exception = Exception(AppConstants.team_id_empty_error_key.tr);
      throw exception;
    }
    this.id = id;
  }

  @override
  set setName(String name) {
    Exception exception;

    if (name.isEmpty) {
      exception = Exception(AppConstants.team_name_empty_error_key.tr);
      throw exception;
    }
    if (name.length < 3) {
      exception = Exception(AppConstants.team_name_min_length_error_key.tr);
      throw exception;
    }

    this.name = name;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;

    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.team_creating_time_future_error_key.tr);
      throw exception;
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      exception = Exception(AppConstants.team_creating_time_past_error_key.tr);
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
          AppConstants.team_updating_time_before_creation_error_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  factory TeamModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return TeamModel.firestoreConstructor(
      idParameter: data[idK],
      mangerIdParameter: data[managerIdK],
      nameParameter: data[nameK],
      imageUrlParameter: data[imageUrlK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[idK] = id;
    data[managerIdK] = managerId;
    data[nameK] = name;
    data[imageUrlK] = imageUrl;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }
}
