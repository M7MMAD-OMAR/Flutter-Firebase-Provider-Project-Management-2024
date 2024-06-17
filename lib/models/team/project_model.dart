import 'package:cloud_firestore/cloud_firestore.dart';
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
      throw Exception('صورة المشروع لا يمكن أن تكون فارغة');
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
      throw Exception('وقت إنشاء المشروع لا يمكن أن يكون في المستقبل');
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception('وقت إنشاء المشروع لا يمكن أن يكون في الماضي');
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception('وقت تحديث المشروع لا يمكن أن يكون قبل وقت الإنشاء');
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
      throw Exception('لا يمكن أن يكون معرف المشروع فارغًا');
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    if (nameParameter.isEmpty) {
      throw Exception('اسم المشروع لا يمكن أن يكون فارغًا');
    }

    if (nameParameter.length <= 3) {
      throw Exception('اسم المشروع لا يمكن أن يكون أقل من 3 أحرف');
    }

    if (_regex.hasMatch(nameParameter)) {
      throw Exception('اسم المشروع لا يمكن أن يحتوي على أحرف خاصة أو أرقام');
    }

    name = nameParameter;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception('لا يمكن أن يكون تاريخ بدء المشروع فارغًا');
    }

    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception('تاريخ بدء المشروع يجب ألا يكون في الماضي');
    }

    startDate = firebaseTime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception('لا يمكن أن يكون تاريخ انتهاء المشروع فارغًا');
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(getStartDate)) {
      throw Exception('وقت انتهاء المشروع لا يمكن أن يكون قبل وقت البدء');
    }

    if (getStartDate.isAtSameMomentAs(endDateParameter)) {
      throw Exception(
          'وقت انتهاء المشروع لا يمكن أن يكون في نفس الوقت كوقت البدء');
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      throw Exception(
          'فرق الوقت بين وقت بدء المشروع ووقت الانتهاء لا يمكن أن يكون أقل من 5 دقائق');
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
