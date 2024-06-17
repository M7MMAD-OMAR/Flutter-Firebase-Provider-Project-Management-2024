import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:project_management_muhmad_omar/constants/app_constants.dart';
import 'package:project_management_muhmad_omar/constants/back_constants.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';

import '../../providers/auth_provider.dart';
import '../tops/VarTopModel.dart';

class UserModel extends VarTopModel {
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
      throw Exception('الاسم لا يمكن أن يكون فارغاً');
    }
    if (name.length <= 3) {
      throw Exception('الاسم يجب أن لا يقل عن 3 أحرف');
    }
    if (regEx.hasMatch(name) || regEx2.hasMatch(name)) {
      throw Exception('الاسم يمكن أن يحتوي على أحرف فقط');
    }

    this.name = name;
  }

  set setUserName(String? userName) {
    if (userName == null) {
      this.userName = userName;
      return;
    }
    if (userName.isEmpty) {
      throw Exception('اسم المستخدم لا يمكن أن يكون فارغاً');
    }
    if (userName.length < 3) {
      throw Exception('اسم المستخدم لا يمكن أن يكون أقل من 3 أحرف');
    }
    if (userName.length >= 20) {
      throw Exception('اسم المستخدم لا يمكن أن يزيد عن 20 حرفًا');
    }
    this.userName = userName;
  }

  set setImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      throw Exception('لا يمكن أن يكون رابط صورة المستخدم فارغًا');
    }
    this.imageUrl = imageUrl;
  }

  set setEmail(String? email) {
    if (email != null) {
      if (!EmailValidator.validate(email)) {
        throw Exception('أدخل بريدًا إلكترونيًا صحيحًا');
      }
      this.email = email;
    } else {
      this.email = email;
    }
  }

  set setBio(String? bio) {
    this.bio = bio;
  }

  Future<void> addTokenFcm() async {
    String tokenFcm = await getFcmToken();

    this.tokenFcm.add(tokenFcm);
  }

  @override
  set setId(String id) {
    if (id.isEmpty) {
      throw Exception('لا يمكن أن يكون معرّف المستخدم فارغًا');
    }
    this.id = id;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());

    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      throw Exception('لا يمكن أن يكون وقت إنشاء المستخدم في المستقبل');
    }

    if (createdAtParameter.isBefore(now)) {
      throw Exception('لا يمكن أن يكون وقت إنشاء المستخدم في الماضي');
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    updatedAtParameter = firebaseTime(updatedAtParameter);

    if (updatedAtParameter.isBefore(createdAt)) {
      throw Exception(
          'لا يمكن أن يكون وقت تحديث حساب المستخدم قبل وقت الإنشاء');
    }
    updatedAt = updatedAtParameter;
  }

  factory UserModel.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data()!;
    return UserModel.firestoreConstructor(
      nameParameter: data[nameK],
      userNameParameter: data[userNameK],
      bioParameter: data[bioK],
      imageUrlParameter: data[imageUrlK],
      emailParameter: data[emailK],
      tokenFcm: data[tokenFcmK].cast<String>(),
      idParameter: data[idK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[nameK] = name;
    data[idK] = id;
    data[userNameK] = userName;
    data[bioK] = bio;
    data[imageUrlK] = imageUrl;
    data[emailK] = email;
    data[tokenFcmK] = tokenFcm;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "name $name id $id userName $userName boi $bio imageUrl $imageUrl email $email tokenfcm $tokenFcm createdAt $createdAt updatedAt $updatedAt";
  }
}
