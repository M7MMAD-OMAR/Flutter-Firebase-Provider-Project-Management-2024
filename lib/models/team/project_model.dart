import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/back_utils.dart';
import '../tops/detailed_model.dart';

class ProjectModel extends DetailedModel {
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
    Exception exception;
    if (imageUrl.isEmpty) {
      throw Exception("الشرط الأول لايمكن أن يكون فارغ");
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
      throw Exception("تاريخ الإضافة لايمكن أن يكون بعد الوقت الحالي");
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception("تاريخ الإضافة لايمكن أن يكون قبل الوقت الحالي");
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("تاريخ التحديث لايمكن أن يكون قبل تاريخ الإنشاء");
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
      throw Exception("لايمكن للمعرف أن يكون فارغ");
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    if (nameParameter.isEmpty) {
      throw Exception("لايمكن لاسم المشروع أن يكون فارغ");
    }

    if (nameParameter.length <= 3) {
      throw Exception("لايمكن لاسم المشروع أن يكون أقل من 3 أحرف");
    }

    if (_regex.hasMatch(nameParameter)) {
      throw Exception("لايمكن أن يحتوي اسم المشروع على أرقام او محارف خاصة");
    }
    name = nameParameter;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    Exception exception;

    if (startDateParameter == null) {
      throw Exception("لا يمكن أن يكون وقت بداية المشروع عديم القيمة");
    }

    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception("لا يمكن أن يكون تاريخ بداية المشروع قبل الوقت الحالي");
    }

    startDate = firebaseTime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    Exception exception;

    if (endDateParameter == null) {
      throw Exception("لا يمكن أن يكون تاريخ نهاية المشروع عديم القيمة");
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(getStartDate)) {
      throw Exception(
          "لا يمكن أن يكون تاريخ نهاية المشروع قبل تاريخ بداية المشروع");
    }

    if (getStartDate.isAtSameMomentAs(endDateParameter)) {
      throw Exception(
          "لا يمكن أن يكون تاريخ نهاية المشروع بنفس وقت تاريخ بداية المشروع");
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      throw Exception(
          "لا يمكن أن يكون الفرق بين تاريخ بداية المشروع ونهايته أقل منن 5 دقائق");
    }
    endDate = endDateParameter;
  }

  factory ProjectModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ProjectModel.firestoreConstructor(
      idParameter: data['id'],
      teamIdParameter: data['teamId'],
      stausIdParameter: data['statusId'],
      descriptionParameter: data['description'],
      imageUrlParameter: data['imageUrl'],
      nameParameter: data['name'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
      startDateParameter: firebaseTime(data['startDate'].toDate()),
      endDateParameter: firebaseTime(data['endDate'].toDate()),
      managerId: data['managerId'],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['teamId'] = teamId;
    data['statusId'] = statusId;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['managerId'] = managerId;
    return data;
  }
}
