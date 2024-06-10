import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/back_utils.dart';
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
      throw Exception("لايمكن أن يكون اللون فارغ");
    }
    hexcolor = hexcolorParameter;
  }

  set setAssignedTo(String assignedToParameter) {
    if (assignedToParameter.isEmpty) {
      throw Exception("لايمكن أن يكون الشخص المسند له المهمة فارغا");
    }

    assignedTo = assignedToParameter;
  }

  late String mainTaskId;

  set setMainTaskId(String mainTaskIdParameter) {
    if (mainTaskIdParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف بالمهمة الأساسية فارغا");
    }

    mainTaskId = mainTaskIdParameter;
  }

  late String projectId;

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
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }
    id = idParameter;
  }

  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String? nameParameter) {
    if (nameParameter == null) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }

    if (nameParameter.isEmpty) {
      throw Exception("لايمكن أن يكون المعرف فارغا");
    }

    name = nameParameter;
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
      throw Exception("الأهمية لا يمكن أن تكون أقل من واحد");
    }

    if (importanceParameter > 5) {
      throw Exception("لا يمكن أن تكون للأهمية قيمة أكبر من 5");
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception("يجب أن يكون التاريخ بعد هذه اللحظة");
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception("تاريخ الإضافة لايمكن أن يكون قبل الوقت الحالي");
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception("لا يمكن أن يكون تاريخ التحديث قبل تاريخ إنشاء المهمة");
    }
    updatedAt = firebaseTime(updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception("تاريخ بداية المهمة لا يمكن أن يكون عديم القيمة");
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception(
          "تاريخ ووقت البداية البداية لا يمكن أن يكون قبل التاريخ والوقت الحالي");
    }

    startDate = startDateParameter;
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception(
          "لا يمكن أن يكون تاريخ ووقت نهاية المهمة الفرعية معدوم القيمة");
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isBefore(startDate)) {
      throw Exception(
          "لا يمكن أن يكون تاريخ نهاية المهمة المهمة الفرعية قبل تاريخ بدايتها");
    }

    if ((endDateParameter).isAtSameMomentAs(getStartDate)) {
      throw Exception(
        "لا يمكن أن يكون تاريخ ووقت نهاية وبدايتها متساويين",
      );
    }

    Duration diff = endDateParameter.difference(startDate);
    if (diff.inMinutes < 5) {
      throw Exception(
          "لايمكن أن يكون تاريخ ووقت نهاية المهمة المهمة الفرعية أقل من 5");
    }
    endDate = firebaseTime(endDateParameter);
  }

  factory ProjectSubTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectSubTaskModel.firestoreConstructor(
      hexColorParameter: data['color'],
      nameParameter: data['name'],
      idParameter: data['id'],
      assignedToParameter: data['assignedTo'],
      descriptionParameter: data['description'],
      mainTaskIdParameter: data['mainTaskId'],
      statusIdParameter: data['statusId'],
      importanceParameter: data['importance'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
      startDateParameter: data['startDate'].toDate(),
      endDateParameter: data['endDate'].toDate(),
      projectIdParameter: data['projectId'],
    );
  }

  factory ProjectSubTaskModel.fromJson(
    Map<String, dynamic> data,
  ) {
    return ProjectSubTaskModel.firestoreConstructor(
      hexColorParameter: data['color'],
      nameParameter: data['name'],
      idParameter: data['id'],
      assignedToParameter: data['assignedTo'],
      descriptionParameter: data['description'],
      mainTaskIdParameter: data['mainTaskId'],
      statusIdParameter: data['statusId'],
      importanceParameter: data['importance'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
      startDateParameter: data['startDate'].toDate(),
      endDateParameter: data['endDate'].toDate(),
      projectIdParameter: data['projectId'],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'color': hexcolor,
      'name': name,
      'id': id,
      'description': description,
      'mainTaskId': mainTaskId,
      'assignedTo': assignedTo,
      'statusId': statusId,
      'importance': importance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'startDate': startDate,
      'endDate': endDate,
      'projectId': projectId,
    };
  }
}
