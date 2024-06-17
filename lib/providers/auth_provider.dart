import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';
import 'package:project_management_muhmad_omar/widgets/snackbar/custom_snackber_widget.dart';

import '../constants/back_constants.dart';
import '../constants/values.dart';
import '../controllers/topController.dart';
import '../controllers/userController.dart';
import '../models/user/user_model.dart';

typedef EitherException<T> = Future<Either<Exception, T>>;

Future<String> getFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken!;
}

class AuthProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  EitherException<bool> updateEmail({required String email}) async {
    final user = firebaseAuth.currentUser;
    try {
      if (EmailValidator.validate(email)) {
        await user?.updateEmail(email);
        return const Right(true);
      }
    } on Exception catch (e) {
      return Left(e);
    }
    return Left(Exception("يرجى إدخال بريد إلكتروني صحيح"));
  }

  EitherException<bool> updatePassword({required String newPassword}) async {
    final user = firebaseAuth.currentUser;
    RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
    RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
    RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");

    try {
      if (regExletters.hasMatch(newPassword) == false ||
          regExnumbers.hasMatch(newPassword) == false ||
          regExbigletters.hasMatch(newPassword) == false) {
        return Left(Exception(
          "يرجى أن تحتوي كلمة المرور على 8 أحرف على الأقل وحروف كبيرة وحروف صغيرة ورقم واحد على الأقل",
        ));
      }
      await user?.updatePassword(newPassword);
      return const Right(true);
    } on Exception catch (e) {
      if (e.toString() ==
          "[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.") {
        return Left(Exception(
            "هذه العملية حساسة، لذلك يجب عليك تسجيل الدخول مرة أخرى قبل محاولة تغيير كلمة المرور مرة أخرى"));
      }

      return Left(e);
    }
  }

  EitherException<bool> createUserWithEmailAndPassword(
      {required String email,
      required password,
      required UserModel userModel}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userModel.id = userCredential.user!.uid;
      await userController.createUser(userModel: userModel);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  EitherException<bool> sendVerifiectionEmail() async {
    final user = firebaseAuth.currentUser;

    try {
      if (user != null) {
        await firebaseAuth.currentUser!.reload();

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          CustomSnackBar.showSuccess("البريد الإلكتروني في طريقه إليك");
          return const Right(false);
        }
        return const Right(true);
      }
      throw Exception("لا يوجد مستخدم في التطبيق");
    } on Exception catch (e) {
      dev.log("error");
      return Left(e);
    }
  }

  EitherException<bool> checkEmailVerifction() async {
    User? user = firebaseAuth.currentUser;
    try {
      if (user != null) {
        await firebaseAuth.currentUser!.reload();
        user = firebaseAuth.currentUser;
        dev.log("reload");
        if (user!.emailVerified) {
          return const Right(true);
        }
        return const Right(false);
      }
      throw Exception("لا يوجد مستخدم في التطبيق");
    } on Exception catch (e) {
      dev.log(e.toString());
      return Left(e);
    }
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> sigInWithEmailAndPassword({
    required String email,
    required String password,
    /* required void Function({required String id}) function */
  }) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    await updatFcmToken();

    return userCredential;
  }

  Future<void> updatFcmToken(/*{required String id}*/) async {
    dev.log("message");

    userController.updateUser(data: {
      tokenFcmK: FieldValue.arrayUnion([await getFcmToken()]),
    }, id: firebaseAuth.currentUser!.uid);
    dev.log("message");
  }

  Future<void> noUserMakeOne({required UserCredential userCredential}) async {
    dev.log("check not here");
    TopController topController = TopController();
    if (userCredential.user!.isAnonymous) {
      UserModel userModel = UserModel(
          nameParameter: "Anynonmous",
          imageUrlParameter: defaultUserImageProfile,
          idParameter: userCredential.user!.uid,
          createdAtParameter: DateTime.now(),
          updatedAtParameter: DateTime.now());
      await userController.createUser(userModel: userModel);
    } else {
      if (!(await topController.existByOne(
          collectionReference: usersRef,
          value: userCredential.user?.uid,
          field: idK))) {
        dev.log("not here");
        UserModel userModel = UserModel(
            emailParameter: userCredential.user!.email,
            nameParameter: userCredential.user!.displayName!,
            imageUrlParameter: userCredential.user!.photoURL!,
            idParameter: userCredential.user!.uid,
            createdAtParameter: DateTime.now(),
            updatedAtParameter: DateTime.now());
        await userController.createUser(userModel: userModel);
      }

      dev.log("not here");
    }
  }

  AuthCredential getEmailCredential(
      {required String email, required String password}) {
    final AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    return credential;
  }

  Future<OAuthCredential> getGooglecredential() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    if (googleUser == null) {
      throw Exception(
          "تم إلغاء تسجيل الدخول بواسطة Google أو لم يتم تحديد حساب");
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }

  Future<void> convertAnonymousToGoogle() async {
    OAuthCredential credential = await getGooglecredential();

    await convertAnonymousToPermanent(
      credential: credential,
    );
  }

  Future<void> convertAnonymousToEmailandPassword(
      {required String email, required String password}) async {
    final credential = getEmailCredential(email: email, password: password);
    await convertAnonymousToPermanent(
      credential: credential,
    );
  }

  Future<void> convertAnonymousToPermanent({
    required credential,
  }) async {
    try {
      final userCredential =
          await firebaseAuth.currentUser?.linkWithCredential(credential);

      String email = userCredential!.user!.email!;
      String name = email.split('@')[0];
      if (name.length > 10) {
        name = name.substring(0, 10);
        name = name.replaceAll(RegExp(r'[0-9]'), '');
      }
      name = name.replaceAll('.', ' ');

      userController.updateUser(data: {
        nameK: name,
        emailK: userCredential.user!.email,
      }, id: userCredential.user!.uid);

      await updatFcmToken();
      firebaseAuth.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          if (kDebugMode) {
            CustomSnackBar.showError(
              "تم ربط الموفر بالفعل بالمستخدم",
            );
          }
          break;
        case "invalid-credential":
          if (kDebugMode) {
            CustomSnackBar.showError(
              "اعتمادات الموفر غير صالحة",
            );
          }
          break;
        case "credential-already-in-use":
          if (kDebugMode) {
            CustomSnackBar.showError(
              "الحساب موجود بالفعل",
            );
          }
          break;
        default:
          if (kDebugMode) {}
      }
    }
  }

  EitherException<UserCredential> signInWithGoogle() async {
    try {
      final credential = await getGooglecredential();

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      await noUserMakeOne(userCredential: userCredential);
      await updatFcmToken();
      return Right(userCredential);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  EitherException<UserCredential> anonymosSignInMethod() async {
    try {
      final credential = await firebaseAuth.signInAnonymously();
      await noUserMakeOne(userCredential: credential);
      dev.log("Right");
      return Right(credential);
    } on Exception catch (e) {
      dev.log("left  $e");
      return Left(e);
    }
  }

  Future<void> logOut() async {
    dev.log("remove");
    await userController.updateUser(data: {
      tokenFcmK: FieldValue.arrayRemove([await getFcmToken()]),
    }, id: firebaseAuth.currentUser!.uid);

    await firebaseAuth.signOut();

    dev.log("remove");
  }
}
