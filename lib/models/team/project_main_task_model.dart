import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

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
      throw Exception('لا يمكن أن يكون لون المهمة الرئيسية فارغًا');
    }
    hexcolor = hexcolorParameter;
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف المهمة الرئيسية للمشروع فارغًا');
    }
    id = idParameter;
  }

  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String nameParameter) {
    if (nameParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون اسم المهمة الرئيسية للمشروع فارغًا');
    }

    name = nameParameter;
  }

  set setprojectId(String projectIdParameter) {
    if (projectIdParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف المشروع فارغًا');
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
      throw Exception('لا يمكن أن يكون معرف حالة المهمة الرئيسية فارغًا');
    }

    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    if (importanceParameter < 1) {
      throw Exception('أهمية المهمة الرئيسية لا يمكن أن تكون أقل من 1');
    }

    if (importanceParameter > 5) {
      throw Exception('أهمية المهمة الرئيسية لا يمكن أن تكون أكبر من خمسة');
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception('وقت إنشاء المهمة الرئيسية لا يمكن أن يكون في المستقبل');
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception('وقت إنشاء المهمة الرئيسية لا يمكن أن يكون في الماضي');
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          'تاريخ تحديث المهمة الرئيسية لا يمكن أن يكون قبل تاريخ الإنشاء');
    }
    updatedAt = (updatedAtParameter);
  }

  bool dateduplicated(DateTime starttime) {
    return true;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception('تاريخ بدء المهمة الرئيسية لا يمكن أن يكون فارغًا');
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception('تاريخ بدء المهمة الرئيسية يجب ألا يكون في الماضي');
    }

    startDate = (startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception('تاريخ انتهاء المهمة الرئيسية لا يمكن أن يكون فارغًا');
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(startDate)) {
      throw Exception(
          'تاريخ بدء المهمة الرئيسية لا يمكن أن يكون بعد تاريخ الانتهاء');
    }

    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      throw Exception(
          'الفرق بين تاريخ البدء وتاريخ الانتهاء للمهمة الرئيسية لا يمكن أن يكون أقل من 5 دقائق');
    }

    if (endDateParameter.isAtSameMomentAs(getStartDate)) {
      throw Exception(
        'تاريخ بدء المهمة الرئيسية لا يمكن أن يكون في نفس الوقت مع تاريخ الانتهاء',
      );
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
