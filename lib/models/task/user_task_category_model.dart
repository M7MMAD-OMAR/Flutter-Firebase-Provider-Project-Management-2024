import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/back_utils.dart';
import '../tops/basic_model.dart';

class UserTaskCategoryModel extends BasicModel {
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
    Exception exception;
    if (hexColorParameter.isEmpty) {
      throw Exception("لايمكن أن يكون لون الصنف فارغ");
    }
    hexColor = hexColorParameter;
  }

  set setUserId(String userId) {
    this.userId = userId;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isBefore(now)) {
      throw Exception("لايمكن أن يكون تاريخ الإنشاء قبل الوقت الحالي");
    }

    if (createdAtParameter.isAfter(now)) {
      throw Exception("لايمكن أن يكون تاريخ الإنشاء بعد الوقت الحالي");
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("لايمكن أن يكون تاريخ التحديث قبل تاريخ الإنشاء");
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setId(String idParameter) {
    Exception exception;

    if (idParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف الخاص بالمهمة فارغا");
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    if (nameParameter.isEmpty) {
      throw Exception("لايمكن أن يكون اسم الصنف فارغا");
    }
    if (nameParameter.length <= 3) {
      throw Exception("لايمكن أن يكون اسم الصنف أقل من 3 محارف");
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
      fontfamily: data['fontFamily'],
      idParameter: data['id'],
      userId: data['userId'],
      nameParameter: data['name'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
      hexColor: data['color'],
      iconCodePoint: data['icon'],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['color'] = hexColor;
    data['icon'] = iconCodePoint;
    data['fontFamily'] = fontfamily;
    return data;
  }
}
