import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import '../../utils/back_utils.dart';
import '../tops/basic_model.dart';

class UserModel extends BasicModel {
  late String imageUrl;

  late String? userName;

  late String? bio;

  late String? email;

  late List<String> tokenFcm = [];

  UserModel({
    required String nameParameter,
    String? userNameParameter,
    required String imageUrlParameter,
    String? emailParameter,
    this.bio,
    required String idParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    setEmail = emailParameter;
    setUserName = userNameParameter;
    setImageUrl = imageUrlParameter;
    setName = nameParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }

  UserModel.firestoreConstructor({
    required String nameParameter,
    String? userNameParameter,
    required String imageUrlParameter,
    String? emailParameter,
    String? bioParameter,
    required this.tokenFcm,
    required String idParameter,
    required DateTime createdAtParameter,
    required DateTime updatedAtParameter,
  }) {
    bio = bioParameter;
    email = emailParameter;
    userName = userNameParameter;
    imageUrl = imageUrlParameter;
    name = nameParameter;
    id = idParameter;
    updatedAt = updatedAtParameter;
    createdAt = createdAtParameter;
    tokenFcm = tokenFcm;
  }

  RegExp regEx = RegExp(r"(?=.*[0-9])\w+");
  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');

  @override
  set setName(String name) {
    if (name.isEmpty) {
      throw Exception("الاسم يجب أن يكون غير فارغ");
    }
    if (name.length <= 3) {
      throw Exception("يجب أن يكون الاسم أكثر من 3 محارف");
    }
    if (regEx.hasMatch(name) || regEx2.hasMatch(name)) {
      throw Exception("يجب أن يكون الاسم فقط يحتوي على حروف صغيرة");
    }

    this.name = name;
  }

  set setUserName(String? userName) {
    if (userName == null) {
      this.userName = userName;
      return;
    }
    if (userName.isEmpty) {
      throw Exception("الاسم يجب أن يكون غير فارغ");
    }
    if (userName.length < 3) {
      throw Exception("يجب أن يكون الاسم أكثر من 3 محارف");
    }
    if (userName.length >= 20) {
      throw Exception("أقصى حد لاسم المستخدم هو 20 محرف");
    }
    this.userName = userName;
  }

  set setImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      throw Exception("لايمكن أن تكون الصورة فارغة");
    }
    this.imageUrl = imageUrl;
  }

  set setEmail(String? email) {
    if (email != null) {
      if (!EmailValidator.validate(email)) {
        throw Exception("تنسيق البريد الإلكتروني غير صحيح");
      }
      this.email = email;
    } else {
      this.email = email;
    }
  }

  set setBio(String? bio) {
    this.bio = bio;
  }

  @override
  set setId(String id) {
    if (id.isEmpty) {
      throw Exception("لايمكن أن يكون معرف المستخدم فارغ");
    }
    this.id = id;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception("تاريخ إضافة المستخدم لايمكن أن يكون بعد الوقت الحالي");
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception("تاريخ إضافة المستخدم لايمكن أن يكون قبل الوقت الحالي");
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          "تاريخ تحديث بيانات المستخدم لايمكن أن يكون قبل تاريخ إنشائه");
    }
    updatedAt = updatedAtParameter;
  }

  factory UserModel.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data()!;
    return UserModel.firestoreConstructor(
      nameParameter: data['name'],
      userNameParameter: data['userName'],
      bioParameter: data['bio'],
      imageUrlParameter: data['imageUrl'],
      emailParameter: data['email'],
      tokenFcm: data['tokenFcm'].cast<String>(),
      idParameter: data['id'],
      createdAtParameter: data['createdAt'].toDate(),
      updatedAtParameter: data['updatedAt'].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['userName'] = userName;
    data['bio'] = bio;
    data['imageUrl'] = imageUrl;
    data['email'] = email;
    data['tokenFcm'] = tokenFcm;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "name $name id $id userName $userName boi $bio imageUrl $imageUrl email $email tokenfcm $tokenFcm createdAt $createdAt updatedAt $updatedAt";
  }
}
