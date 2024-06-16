import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_management_muhmad_omar/constants/app_constans.dart';
import 'package:project_management_muhmad_omar/utils/back_utils.dart';
import 'package:project_management_muhmad_omar/widgets/Snackbar/custom_snackber_widget.dart';

import '../constants/back_constants.dart';
import '../controllers/topController.dart';
import '../controllers/userController.dart';
import '../models/User/User_model.dart';
import 'collections_refrences.dart';

typedef EitherException<T> = Future<Either<Exception, T>>;
Future<String> getFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken!;
}

class AuthService extends GetxController {
  UserController userController = Get.put(UserController());
  static AuthService instance = Get.find();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
  }

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
    return Left(Exception(AppConstants.please_enter_valid_email_key.tr));
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
          AppConstants
              .please_the_password_should_contain_at_least_8_characters_and_big_letters_and_small_with_one_number_at_least_key
              .tr,
        ));
      }
      await user?.updatePassword(newPassword);
      return const Right(true);
    } on Exception catch (e) {
      if (e.toString() ==
          "[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.") {
        return Left(
            Exception(AppConstants.sensitive_change_password_process_key.tr));
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
          CustomSnackBar.showSuccess(
              AppConstants.the_email_in_its_way_to_you_key.tr);
          return const Right(false);
        }
        return const Right(true);
      }
      throw Exception(
          AppConstants.there_is_no_user_logging_in_or_sign_up_key.tr);
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
      throw Exception(
          AppConstants.there_is_no_user_logging_in_or_sign_up_key.tr);
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

//     // Create a credential from the access token
//     final OAuthCredential facebookAuthCredential =
//         FacebookAuthProvider.credential(loginResult.accessToken!.token);
//     return facebookAuthCredential;
//   }

  //* it works
  AuthCredential getEmailCredential(
      {required String email, required String password}) {
    // Email and password sign-in
    final AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    return credential;
  }

  //* it works
  Future<OAuthCredential> getGooglecredential() async {
    //Trigger the authentication
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    if (googleUser == null) {
      // User did not select an account, handle the error case here
      throw Exception(AppConstants
          .Google_sign_in_was_canceled_or_no_account_was_selected_key.tr);
    }
//Obtin the auth detailes from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
//Create New Credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }

  // Future<void> convertAnonymousToFacebook() async {
  //   OAuthCredential oAuthCredential = await getFacebookCredential();
  //   await convertAnonymousToPermanent(credential: oAuthCredential);
  // }

  //* it works
  Future<void> convertAnonymousToGoogle() async {
    OAuthCredential credential = await getGooglecredential();

    await convertAnonymousToPermanent(
      credential: credential,
      //authFormTypeParameter: AuthFormType.google
    );
  }

  //* it works
  Future<void> convertAnonymousToEmailandPassword(
      {required String email, required String password}) async {
    final credential = getEmailCredential(email: email, password: password);
    await convertAnonymousToPermanent(
      credential: credential,
      // authFormTypeParameter: AuthFormType.email
    );
  }

  //* it works
  Future<void> convertAnonymousToPermanent({
    required credential,
    // required AuthFormType authFormTypeParameter
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
      //authFormType = authFormTypeParameter;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          if (kDebugMode) {
            CustomSnackBar.showError(
              AppConstants
                  .The_provider_has_already_been_linked_to_the_user_key.tr,
            );
          }
          break;
        case "invalid-credential":
          if (kDebugMode) {
            CustomSnackBar.showError(
              AppConstants.The_providers_credential_is_not_valid_key.tr,
            );
          }
          break;
        case "credential-already-in-use":
          if (kDebugMode) {
            CustomSnackBar.showError(
              AppConstants
                  .The_account_corresponding_to_the_credential_already_exists_or_is_already_linked_to_a_Firebase_User_key
                  .tr,
            );
          }
          break;
        // See the API reference for the full list of error codes.
        default:
          if (kDebugMode) {}
      }
    }
  }

  //* it works
  EitherException<UserCredential> signInWithGoogle(
      /*  {required void Function() updateFcmToken}
    */
      ) async {
    try {
      final credential = await getGooglecredential();
      //when sign in ,return the UserCredential
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      await noUserMakeOne(userCredential: userCredential);
      await updatFcmToken();
      return Right(userCredential);
    } on Exception catch (e) {
      return Left(e);
    }
    //authFormType = AuthFormType.google;
  }

  //* it works
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
    //  authFormType = AuthFormType.anonymous;
  }

  //* it works
  Future<void> logOut() async {
    dev.log("remove");
    await userController.updateUser(data: {
      tokenFcmK: FieldValue.arrayRemove([await getFcmToken()]),
    }, id: firebaseAuth.currentUser!.uid);

    await firebaseAuth.signOut();
    //authFormType = AuthFormType.nothing;
    dev.log("remove");
  }
}
