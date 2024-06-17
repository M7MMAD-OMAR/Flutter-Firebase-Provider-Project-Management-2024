import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import 'task_model.dart';

class ProjectSubTaskModel extends TaskClass {
  ProjectSubTaskModel({
    required String projectIdParameter,
    required String mainTaskIdParameter,
    required String descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
    required String assignedToParameter,
    required String hexColorParameter,
  }) {
    setHexColor = hexColorParameter;
    setMainTaskId = mainTaskIdParameter;
    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
    setAssignedTo = assignedToParameter;
    setprojectId = projectIdParameter;
  }

  ProjectSubTaskModel.firestoreConstructor({
    required String projectIdParameter,
    required String mainTaskIdParameter,
    String? descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
    required String assignedToParameter,
    required String hexColorParameter,
  }) {
    projectId = projectIdParameter;
    hexcolor = hexColorParameter;
    mainTaskId = mainTaskIdParameter;
    id = idParameter;
    name = nameParameter;
    description = descriptionParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
    assignedTo = assignedToParameter;
  }

  late String assignedTo;

  @override
  set setHexColor(String hexcolorParameter) {
    if (hexcolorParameter.isEmpty) {
      throw Exception('لون مهمة المشروع الفرعية لا يمكن أن يكون فارغًا');
    }
    hexcolor = hexcolorParameter;
  }

  set setAssignedTo(String assignedToParameter) {
    if (assignedToParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف عضو الفريق المعين فارغًا');
    }

    assignedTo = assignedToParameter;
  }

  late String mainTaskId;

  set setMainTaskId(String mainTaskIdParameter) {
    if (mainTaskIdParameter.isEmpty) {
      throw Exception(
          'لا يمكن أن يكون معرف المهمة الرئيسية للمهمة الفرعية فارغًا');
    }

    mainTaskId = mainTaskIdParameter;
  }

  late String projectId;

  set setprojectId(String projectIdParameter) {
    if (projectIdParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف مشروع المهمة الفرعية فارغًا');
    }

    projectId = projectIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف مهمة المشروع الفرعية فارغًا');
    }
    id = idParameter;
  }

  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String? nameParameter) {
    if (nameParameter == null) {
      throw Exception('اسم مهمة المشروع الفرعية لا يمكن أن يكون فارغًا');
    }

    if (nameParameter.isEmpty) {
      throw Exception('اسم مهمة المشروع الفرعية لا يمكن أن يكون فارغًا');
    }

    name = nameParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    if (statusIdParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرف حالة مهمة المشروع الفرعية فارغًا');
    }

    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    if (importanceParameter < 1) {
      throw Exception('أهمية مهمة المشروع الفرعية لا يمكن أن تكون أقل من 1');
    }

    if (importanceParameter > 5) {
      throw Exception('أهمية مهمة المشروع الفرعية لا يمكن أن تكون أكبر من 5');
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception(
          'لا يمكن أن يكون وقت إنشاء مهمة المشروع الفرعية في المستقبل');
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception(
          'لا يمكن أن يكون وقت إنشاء مهمة المشروع الفرعية في الماضي');
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          'لا يمكن أن يكون تاريخ تحديث مهمة المشروع الفرعية قبل تاريخ الإنشاء');
    }
    updatedAt = firebaseTime(updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception('تاريخ بدء مهمة المشروع الفرعية لا يمكن أن يكون فارغًا');
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception('تاريخ بدء مهمة المشروع الفرعية يجب ألا يكون في الماضي');
    }

    startDate = startDateParameter;
  }

  bool dateduplicated(DateTime starttime) {
    return true;
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception(
          'تاريخ انتهاء مهمة المشروع الفرعية لا يمكن أن يكون فارغًا');
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(startDate)) {
      throw Exception(
          'تاريخ بدء مهمة المشروع الفرعية لا يمكن أن يكون بعد تاريخ الانتهاء');
    }

    if ((endDateParameter).isAtSameMomentAs(getStartDate)) {
      throw Exception(
        'لا يمكن أن يكون تاريخ بدء مهمة المشروع الفرعية في نفس الوقت الذي ينتهي فيه',
      );
    }

    Duration diff = endDateParameter.difference(startDate);
    if (diff.inMinutes < 5) {
      throw Exception(
          'لا يمكن أن يكون الفرق الزمني بين وقت بدء مهمة المشروع الفرعية ووقت الانتهاء أقل من 5 دقائق');
    }
    endDate = firebaseTime(endDateParameter);
  }

  factory ProjectSubTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectSubTaskModel.firestoreConstructor(
      hexColorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      assignedToParameter: data[assignedToK],
      descriptionParameter: data[descriptionK],
      mainTaskIdParameter: data[mainTaskIdK],
      statusIdParameter: data[statusIdK],
      importanceParameter: data[importanceK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: data[startDateK].toDate(),
      endDateParameter: data[endDateK].toDate(),
      projectIdParameter: data[projectIdK],
    );
  }

  factory ProjectSubTaskModel.fromJson(
    Map<String, dynamic> data,
  ) {
    return ProjectSubTaskModel.firestoreConstructor(
      hexColorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      assignedToParameter: data[assignedToK],
      descriptionParameter: data[descriptionK],
      mainTaskIdParameter: data[mainTaskIdK],
      statusIdParameter: data[statusIdK],
      importanceParameter: data[importanceK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: data[startDateK].toDate(),
      endDateParameter: data[endDateK].toDate(),
      projectIdParameter: data[projectIdK],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      colorK: hexcolor,
      nameK: name,
      idK: id,
      descriptionK: description,
      mainTaskIdK: mainTaskId,
      assignedToK: assignedTo,
      statusIdK: statusId,
      importanceK: importance,
      createdAtK: createdAt,
      updatedAtK: updatedAt,
      startDateK: startDate,
      endDateK: endDate,
      projectIdK: projectId,
    };
  }
}
