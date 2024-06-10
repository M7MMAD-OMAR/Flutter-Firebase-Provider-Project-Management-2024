import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/back_utils.dart';
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
      throw Exception("لايمكن للمعرف أن يكون فارغ");
    }

    userId = userIdParameter;
  }

  set setFolderId(String folderIdParameter) {
    if (folderIdParameter.isEmpty) {
      throw Exception("لايمكن للمعرف أن يكون فارغ");
    }

    folderId = folderIdParameter;
  }

  set setTaskFatherId(DocumentReference? taskFatherIdParameter) {
    taskFatherId = taskFatherIdParameter;
  }

  @override
  set setName(String? nameParameter) {
    if (nameParameter == null) {
      throw Exception("لايمكن أن تكون اسم المهمة بدون قيمة");
    }

    if (nameParameter.isEmpty) {
      throw Exception("لايمكن أن تكون اسم المهمة فارغا");
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
      throw Exception("لايمكن أن يكون المعرف فارغ");
    }
    id = idParameter;
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
    if (importanceParameter <= 0) {
      throw Exception("لايمكن للأهمية أن تكون أقل من صغر أو تساويه");
    }

    if (importanceParameter > 5) {
      throw Exception("لايمكن للأهمية أن تكون أكبر من 5");
    }
    importance = importanceParameter;
  }

  @override
  set setHexColor(String hexcolorParameter) {
    if (hexcolorParameter.isEmpty) {
      throw Exception("لايمكن أن يكون فارغ");
    }
    hexcolor = hexcolorParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (createdAtParameter.isAfter(now)) {
      throw Exception(
          "تاريخ إضافة مهمة المستخدم لايمكن أن يكون بعد الوقت الحالي");
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
      throw Exception("تاريخ التحديث لايمكن أن يكون قبل تاريخ الإنشاء");
    }
    updatedAt = firebaseTime(updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    if (startDateParameter == null) {
      throw Exception("لايمكن لوقت لتاريخ البداية أن يكون فارغ");
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());

    if (startDateParameter.isBefore(now)) {
      throw Exception(
          "التاريخ والوقت لايمكن أن يكون قبل التاريخ والوقت الحالي");
    }

    startDate = firebaseTime(startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    if (endDateParameter == null) {
      throw Exception("لايمكن لتاريخ المهمة أن يكون فارغ");
    }
    endDateParameter = firebaseTime(endDateParameter);

    if (endDateParameter.isAtSameMomentAs(startDate)) {
      throw Exception(
        "لايمكن أن يكون تاريخ نهاية المهمة مماثل لتاريخ البداية",
      );
    }

    if (endDateParameter.isBefore(startDate)) {
      throw Exception("تاريخ انتهاء المهمة لا يمكن أن يكون قبل بداية المهمة");
    }
    endDate = firebaseTime(endDateParameter);
  }

  factory UserTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return UserTaskModel.firestoreConstructor(
      colorParameter: data['color'],
      nameParameter: data['name'],
      idParameter: data['id'],
      descriptionParameter: data['description'],
      userId: data['userId'],
      folderId: data['folderId'],
      taskFatherId: data['taskFatherId'],
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
      'userId': userId,
      'folderId': folderId,
      'taskFatherId': taskFatherId,
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
    return "user task name is $name id:$id description:$description userId:$userId folderId$folderId \n task_father_id:$taskFatherId statusId:$statusId importance:$importance createdAt:$createdAt updatedAt:$updatedAt startDate:$startDate endDate:$endDate";
  }
}
