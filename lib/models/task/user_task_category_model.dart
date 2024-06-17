import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../tops/VarTopModel.dart';

class UserTaskCategoryModel extends VarTopModel {
  UserTaskCategoryModel({
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
    if (hexColorParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون لون فئة مهمة المستخدم فارغًا');
    }
    hexColor = hexColorParameter;
  }

  set setUserId(String userId) {
    this.userId = userId;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isBefore(now)) {
      throw Exception('لا يمكن تعيين وقت الإنشاء قبل الوقت الحالي');
    }

    if (createdAtParameter.isAfter(now)) {
      throw Exception('لا يمكن أن يكون وقت الإنشاء في المستقبل');
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception('لا يمكن أن يكون وقت التحديث قبل وقت الإنشاء');
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف فئة مهمة المستخدم فارغًا');
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    if (nameParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون الاسم فارغًا');
    }
    if (nameParameter.length <= 3) {
      throw Exception('لا يمكن أن يكون الاسم أقل من 3 أحرف');
    }

    name = nameParameter;
  }

  UserTaskCategoryModel.firestoreConstructor({
    required String idParameter,
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
