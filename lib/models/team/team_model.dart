import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/back_utils.dart';
import '../tops/basic_model.dart';

class TeamModel extends BasicModel {

  late String imageUrl;


  late String managerId;

  TeamModel({


    required String idParameter,


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
      throw Exception("لا يمكن أن يكون رابط صورة الفريق فارغاً");
    }
    this.imageUrl = imageUrl;
  }

  @override
  set setId(String id) {
    Exception exception;

    if (id.isEmpty) {
      throw Exception("المعرف لايمكن أن يكون فارغا");
    }
    this.id = id;
  }

  @override
  set setName(String name) {
    Exception exception;


    if (name.isEmpty) {
      throw Exception("اسم الفريق لا يمكن أن يكون فارغاً");
    }
    if (name.length < 3) {
      throw Exception(
          "
      }

          this.name = name;
      }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;

    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (createdAtParameter.isAfter(now)) {
      throw Exception(
          "تاريخ الإضافة الخاص بالفريق لايمكن ان يكون بعد الوقت الحالي");
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception("تاريخ الإضافة لايمكن أن يكون قبل الوقت الحالي");
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("تاريخ التحديث لايمكن أن يكون قبل التاريخ الحالي");
    }
    updatedAt = updatedAtParameter;
  }


  factory TeamModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data()!;

    return TeamModel.firestoreConstructor(
      idParameter: data['id'],
      mangerIdParameter: data['managerId'],
      nameParameter: data['name'],
      imageUrlParameter: data['imageUrl'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
    );
  }


  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['managerId'] = managerId;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
