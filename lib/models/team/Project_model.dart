import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';
import '../tops/Var2TopModel.dart';

class ProjectModel extends Var2TopModel {
  ProjectModel({
    //اسم المشروع الخاص بالفريق
    required String nameParameter,
    //الاي دي الخاص بالفريق
    //يتم أخذه تلقائياً من فاير ستور
    //primary key
    required String idParameter,
    //صورة المشروع الخاص بالفريق
    required String imageUrlParameter,
    //الوصف الخاص بالمشروع
    required String descriptionParameter,
    //الاي دي الخاص بالتيم الذي سيعمل على لمشروع
    //foreign key
    required String teamIdParameter,
    //الاي دي الخاص بالحالة لمعرفة حالة المشروع
    required String stausIdParameter,
    //تاريخ نهاية المشروع
    required DateTime endDateParameter,
    //تاريخ بداية المشروع
    required DateTime startDateParameter,
    //تاريخ إنشاء المشروع
    required DateTime createdAtParameter,
    //تاريخ آخر تعديل على المشروع
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
    //اسم المشروع الخاص بالفريق
    required String nameParameter,
    //الاي دي الخاص بالفريق
    //يتم أخذه تلقائياً من فاير ستور
    //primary key
    required String idParameter,
    //صورة المشروع الخاص بالفريق
    required String imageUrlParameter,
    //الوصف الخاص بالمشروع
    required String descriptionParameter,
    //الاي دي الخاص بالتيم الذي سيعمل على لمشروع
    //foreign key
    required String teamIdParameter,
    //الاي دي الخاص بالحالة لمعرفة حالة المشروع
    required String stausIdParameter,
    //تاريخ نهاية المشروع
    required DateTime endDateParameter,
    //تاريخ بداية المشروع
    required DateTime startDateParameter,
    //تاريخ إنشاء المشروع
    required DateTime createdAtParameter,
    //تاريخ آخر تعديل على المشروع
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
      //الشرط الأول لايمكن ان يكون فارغ
      throw Exception(AppConstants.project_imageUrl_empty_error_key.tr);
    }
    this.imageUrl = imageUrl;
  }

  late String managerId;

  set setmanagerId(String managerIdParameter) {
    // مجرد مايكون التيم بالداتا بيز معناها هو محقق الشروط
    managerId = managerIdParameter;
  }

  //ايدي الفريق المسؤول عن هذا المشروع لايمكن ان يكون فارغ
  late String? teamId;
  set setTeamId(String teamIdParameter) {
    // مجرد مايكون التيم بالداتا بيز معناها هو محقق الشروط
    teamId = teamIdParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    // TODO   //CheckExist(statusId,collectionName);هون منحط الميثود المسؤولة عن التأكد من وجود هل الفريق بالداتا بيز او لأ
    // مجرد مايكون التيم بالداتا بيز معناها هو محقق الشروط
    statusId = statusIdParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    //الشروط الخاصة بتاريخ ووقت إضافة الدوكيومنت الخاص بالمشروع

    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    //تاريخ إضافة الدوكيومنت الخاص بالمشروع لا يمكن أن يكون بعد الوقت الحالي
    if (createdAtParameter.isAfter(now)) {
      throw Exception(AppConstants.project_creating_time_future_error_key.tr);
    }
    //تاريخ إضافة الدوكيومنت الخاص بالمشروع لا يمكن أن يكون قبل الوقت الحالي
    if (createdAtParameter.isBefore(now)) {
      throw Exception(AppConstants.project_creating_time_past_error_key.tr);
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //تاريخ تحديث الدوكيومنت الخاص بالمشروع لا يمكن أن يكون قبل تاريخ الإنشاء
    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          AppConstants.project_updating_before_creating_error_key.tr);
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    //لا يمكن أن يكون اي دي الدوكيومنت الخاص بالمشروع فارغ
    if (idParameter.isEmpty) {
      throw Exception(AppConstants.project_id_empty_error_key.tr);
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    //هذه الخاصية تستخدم لوضع قيمة لاسم المستخدم وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق
    //لا يمكن أن ان يكون اسم المشروع فارغاً
    if (nameParameter.isEmpty) {
      throw Exception(AppConstants.project_name_empty_error_key.tr);
    }
    //لايمكن ان يكون اسم المشروع مؤلف من اقل من ثلاث محارف
    if (nameParameter.length <= 3) {
      throw Exception(AppConstants.project_name_length_error_key.tr);
    }

    //لايمكن ان يحوي اسم المشروع اي ارقام او محارف خاصة فقطط احرف
    if (_regex.hasMatch(nameParameter)) {
      throw Exception(AppConstants.project_name_format_error_key.tr);
    }
    //TODO: write the function taskExist
    // if (projectexist(nameParameter)) {
    //   throw Exception("project main task already been added");
    //
    // }
    //في حال مرروره على جميع الشروط وعدم رمي اكسيبشن فذلك يعني تحقيقه للشروط المطلوبة وعندها سيتم وضع القيمة
    name = nameParameter;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    //لا يمكن أن يكون وقت بداية المشروع عديم القيمة
    if (startDateParameter == null) {
      throw Exception(AppConstants.project_start_date_null_error_key.tr);
    }

    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());
    //لا يمكن أن يكون تاريخ بداية المشروع قبل الوقت الحالي
    if (startDateParameter.isBefore(now)) {
      throw Exception(AppConstants.project_start_date_past_error_key.tr);
    }

    startDate = firebaseTime(startDateParameter);
  }

  // // TODO:this method is just for demo make the method to make a query in firebase to know that if there is another task in the same time for this model
  // bool dateduplicated(DateTime starttime) {
  //   return true;
  // }

  @override
  set setEndDate(DateTime? endDateParameter) {
    //لا يمكن أن يكون تاريخ نهاية المشروع عديم القيمة
    if (endDateParameter == null) {
      throw Exception(AppConstants.project_end_date_null_error_key.tr);
    }
    endDateParameter = firebaseTime(endDateParameter);
    //لا يمكن أن يكون تاريخ نهاية المشروع قبل تاريخ بداية المشروع
    if (endDateParameter.isBefore(getStartDate)) {
      throw Exception(AppConstants.project_end_time_error_key.tr);
    }
    //لا يمكن أن يكون تاريخ نهاية المشروع بنفس وقت تاريخ بداية المشروع
    if (getStartDate.isAtSameMomentAs(endDateParameter)) {
      throw Exception(AppConstants.project_end_time_same_error_key.tr);
    }
    //لا يمكن أن يكون الفرق بين تاريخ بداية المشروع ونهايته أقل منن 5 دقائق
    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      throw Exception(AppConstants.project_time_difference_error_key.tr);
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
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
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
