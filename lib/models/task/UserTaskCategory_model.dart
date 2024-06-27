import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/VarTopModel.dart';

class UserTaskCategoryModel extends VarTopModel {

  UserTaskCategoryModel({
    //primary kay
    required String idParameter,
    required String hexColorParameter,
    required String userIdParameter,
    required String nameParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required int iconCodePointParameter,
    required String? fontfamilyParameter,
  }) {
    setUserId = userIdParameter;
    setName = nameParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setHexColor = hexColorParameter;
    setIcon = iconCodePointParameter;
    setFontfamily = fontfamilyParameter;
  }

  late String? fontfamily;

  set setFontfamily(String? fontfamilyParameter) {
    fontfamily = fontfamilyParameter;
  }

  late String userId;
  late int iconCodePoint;

  set setIcon(int iconCodePointParameter) {
    iconCodePoint = iconCodePointParameter;
  }

  late String hexColor;

  set setHexColor(String hexColorParameter) {
    Exception exception;
    if (hexColorParameter.isEmpty) {
      exception = Exception(AppConstants.category_color_empty_key);
      throw exception;
    }
    hexColor = hexColorParameter;
  }

//  late String imageUrl;

  set setUserId(String userId) {
    this.userId = userId;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isBefore(now)) {
      exception = Exception(AppConstants.created_time_before_now_invalid_key);
      throw exception;
    }

    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.created_time_not_in_future_invalid_key);
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
          Exception(AppConstants.updating_time_before_creating_invalid_key);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setId(String idParameter) {
    Exception exception;

    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.category_id_empty_key);
      throw exception;
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    if (nameParameter.isEmpty) {
      exception = Exception(AppConstants.name_empty_key);
      throw exception;
    }
    if (nameParameter.length <= 3) {
      exception = Exception(AppConstants.name_length_invalid_key);
      throw exception;
    }

    name = nameParameter;
  }

  UserTaskCategoryModel.firestoreConstructor({
    required String idParameter,

    //forgin kay from UserModel
    required this.userId,
    required this.hexColor,
    required this.iconCodePoint,
    required this.fontfamily,
    required String nameParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    id = idParameter;
    name = nameParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }

  factory UserTaskCategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return UserTaskCategoryModel.firestoreConstructor(
      fontfamily: data[fontFamilyK],
      idParameter: data[idK],
      userId: data[userIdK],
      nameParameter: data[nameK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      hexColor: data[colorK],
      iconCodePoint: data[iconK],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[nameK] = name;
    data[idK] = id;
    data[userIdK] = userId;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    data[colorK] = hexColor;
    data[iconK] = iconCodePoint;
    data[fontFamilyK] = fontfamily;
    return data;
  }
}
