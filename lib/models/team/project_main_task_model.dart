import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/back_utils.dart';
import 'task_model.dart';

class ProjectMainTaskModel extends TaskClass {
  ProjectMainTaskModel({
    required String projectIdParameter,
    required String descriptionParameter,
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
    if (hexcolorParameter.isEmpty) {
      throw Exception("لايمكن أن يكون فارغ");
    }
    hexcolor = hexcolorParameter;
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception("لايمكن أن يكون فارغ");
    }
    id = idParameter;
  }

  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String nameParameter) {
    if (nameParameter.isEmpty) {
      throw Exception("لايمكن أن تكون اسم المهمة فارغة");
    }

    name = nameParameter;
  }

  set setprojectId(String projectIdParameter) {
    if (projectIdParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }
    projectId = projectIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    if (statusIdParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }

    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    if (importanceParameter < 1) {
      throw Exception("الأهمية لايمكن أن تكون أقل أو تساوي 0");
    }

    if (importanceParameter > 5) {
      throw Exception("الأهمية لايمكن أن تكون أكبر من 5");
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception("تاريخ إضافة المهمة غير صحيح");
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception("تاريخ الإضافة لايمكن أن يكون قبل الوقت الحالي");
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("لايمكن ان يكون تاريخ التحديث قبل تاريخ الإضافة");
    }
    updatedAt = (updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception("لايمكن لتاريخ البداية أن يكون فارغ");
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception("لايمكن أن يكون تاريخ البداية هو قبل تاريخ الحالي");
    }

    startDate = (startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception("لايمكن أن يكون تاريخ المهمة فارغ");
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(startDate)) {
      throw Exception(
          "لايمكن أن يكون وقت المهمة الأساسية قبل تاريخ بداية المهمة");
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      throw Exception(
          "لايمكن أن يوجد فارق 5 دقائق كفارق بين المهمة الأساسية ونهايتها");
    }

    if (endDateParameter.isAtSameMomentAs(getStartDate)) {
      throw Exception(
          "لا يمكن أن يكون تاريخ ووقت نهاية وبداية المهمة متساويين");
    }

    endDate = endDateParameter;
  }

  factory ProjectMainTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectMainTaskModel.firestoreConstructor(
      hexColorParameter: data['color'],
      nameParameter: data['name'],
      idParameter: data['id'],
      descriptionParameter: data['description'],
      projectIdParameter: data['projectId'],
      statusIdParameter: data['statusId'],
      importanceParameter: data['importance'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
      startDateParameter: data['startDate'].toDate(),
      endDateParameter: data['endDate'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'color': hexcolor,
      'name': name,
      'id': id,
      'description': description,
      'projectId': projectId,
      'statusId': statusId,
      'importance': importance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  @override
  String toString() {
    return "main task name is:$name id:$id  description:$description projectId:$projectId  statusId:$statusId importance:$importance startDate:$startDate endDate:$endDate createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
