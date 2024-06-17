import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../tops/VarTopModel.dart';

class TeamModel extends VarTopModel {
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
    if (imageUrl.isEmpty) {
      throw Exception('صورة الفريق لا يمكن أن تكون فارغة');
    }
    this.imageUrl = imageUrl;
  }

  @override
  set setId(String id) {
    if (id.isEmpty) {
      throw Exception('لا يمكن أن يكون معرّف الفريق فارغًا');
    }
    this.id = id;
  }

  @override
  set setName(String name) {
    if (name.isEmpty) {
      throw Exception('اسم الفريق لا يمكن أن يكون فارغًا');
    }
    if (name.length < 3) {
      throw Exception('اسم الفريق لا يمكن أن يكون أقل من 3 أحرف');
    }

    this.name = name;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (createdAtParameter.isAfter(now)) {
      throw Exception('وقت إنشاء الفريق لا يمكن أن يكون في المستقبل');
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception('وقت إنشاء الفريق لا يمكن أن يكون في الماضي');
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception('وقت تحديث الفريق لا يمكن أن يكون قبل وقت الإنشاء');
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
