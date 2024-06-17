import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../team/task_model.dart';

class UserTaskModel extends TaskClass {
  UserTaskModel({
    required String userIdParameter,
    required String folderIdParameter,
    required DocumentReference? taskFatherIdParameter,
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
    setFolderId = folderIdParameter;
    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
    setUserId = userIdParameter;
    setTaskFatherId = taskFatherIdParameter;
    setHexColor = hexColorParameter;
  }

  UserTaskModel.lateTask({
    required String userIdParameter,
    required String folderIdParameter,
    required DocumentReference? taskFatherIdParameter,
    required String descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
    required String color,
  }) {
    setHexColor = color;
    setFolderId = folderIdParameter;
    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    startDate = startDateParameter;
    setEndDate = endDateParameter;
    setUserId = userIdParameter;
    setTaskFatherId = taskFatherIdParameter;
  }

  UserTaskModel.firestoreConstructor({
    required this.userId,
    required this.folderId,
    this.taskFatherId,
    String? descriptionParameter,
    required String idParameter,
    required String nameParameter,
    required String statusIdParameter,
    required int importanceParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
    required DateTime startDateParameter,
    required DateTime endDateParameter,
    required String colorParameter,
  }) {
    hexcolor = colorParameter;
    id = idParameter;
    name = nameParameter;
    description = descriptionParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
  }

  late String userId;

  late String folderId;

  DocumentReference? taskFatherId;

  set setUserId(String userIdParameter) {
    if (userIdParameter.isEmpty) {
      throw Exception('لا يمكن أن يكون معرّف مستخدم المهمة فارغًا');
    }

    userId = userIdParameter;
  }

  set setFolderId(String folderIdParameter) {
    if (folderIdParameter.isEmpty) {
      throw Exception('معرف فئة المهمة لايمكن أن يكون فارغ');
    }

    folderId = folderIdParameter;
  }

  set setTaskFatherId(DocumentReference? taskFatherIdParameter) {
    taskFatherId = taskFatherIdParameter;
  }

  @override
  set setName(String? nameParameter) {
    if (nameParameter == null) {
      throw Exception('لا يمكن أن يكون اسم مهمة المستخدم فارغًا');
    }

    if (nameParameter.isEmpty) {
      throw Exception('اسم المهمة لا يمكن أن يكون فارغًا');
    }

    name = nameParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    if (idParameter.isEmpty) {
      throw Exception('رقم معرف مهمة المستخدم لا يمكن أن يكون فارغًا');
    }
    id = idParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    if (statusIdParameter.isEmpty) {
      throw Exception('رقم معرف حالة المهمة لا يمكن أن يكون فارغًا');
    }
    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    if (importanceParameter <= 0) {
      throw Exception('لا يمكن أن تكون الأهمية أقل من 0');
    }

    if (importanceParameter > 5) {
      throw Exception('قيمة الأهمية لا يمكن أن تكون أكبر من الخمسة');
    }
    importance = importanceParameter;
  }

  @override
  set setHexColor(String hexcolorParameter) {
    if (hexcolorParameter.isEmpty) {
      throw Exception('يجب ألا يكون لون المهمة فارغًا');
    }
    hexcolor = hexcolorParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (createdAtParameter.isAfter(now)) {
      throw Exception('وقت إنشاء مهمة المستخدم لا يمكن أن يكون في المستقبل');
    }

    if (firebaseTime(createdAtParameter).isBefore(now)) {
      throw Exception('وقت إنشاء مهمة المستخدم لا يمكن أن يكون في الماضي');
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception('تاريخ تحديث المهمة لا يمكن أن يكون قبل تاريخ الإنشاء');
    }
    updatedAt = firebaseTime(updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception('تاريخ بدء مهمة المستخدم لا يمكن أن يكون فارغاً');
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception('يجب ألا يكون تاريخ بدء مهمة المستخدم قبل اليوم الحالي');
    }

    startDate = firebaseTime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception('تاريخ انتهاء مهمة المستخدم لا يمكن أن يكون فارغًا');
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isAtSameMomentAs(startDate)) {
      throw Exception(
        'تاريخ بدء مهمة المستخدم لا يمكن أن يكون في نفس الوقت كتاريخ الانتهاء',
      );
    }

    if (differeInTime(getStartDate, endDateParameter).inMinutes < 5) {
      throw Exception(
          'يجب أن يكون الوقت بين وقت بدء المهمة ووقت انتهاء المهمة 5 دقائق أو أكثر');
    }

    if (endDateParameter.isBefore(startDate)) {
      throw Exception(
          'تاريخ انتهاء مهمة المستخدم لا يمكن أن يكون قبل تاريخ البدء');
    }
    endDate = firebaseTime(endDateParameter);
  }

  factory UserTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return UserTaskModel.firestoreConstructor(
      colorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      descriptionParameter: data[descriptionK],
      userId: data[userIdK],
      folderId: data[folderIdK],
      taskFatherId: data[taskFatherIdK],
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
      userIdK: userId,
      folderIdK: folderId,
      taskFatherIdK: taskFatherId,
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
    return "user task name is $name id:$id description:$description userId:$userId folderId$folderId \n task_father_id:$taskFatherId statusId:$statusId importance:$importance createdAt:$createdAt updatedAt:$updatedAt startDate:$startDate endDate:$endDate";
  }
}
