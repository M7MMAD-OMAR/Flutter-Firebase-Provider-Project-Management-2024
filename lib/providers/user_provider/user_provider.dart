import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/services/user/user_service.dart';

typedef EitherException<T> = Future<Either<Exception, T>>;

class UserProvider extends ChangeNotifier {
  final UserService _userService;

  UserProvider(this._userService);

  EitherException<bool> updateEmail(String email) async {
    try {
      if (EmailValidator.validate(email)) {
        final user = FirebaseAuth.instance.currentUser;
        await user?.verifyBeforeUpdateEmail(email);
        notifyListeners();
        return const Right(true);
      }
    } on Exception catch (e) {
      return Left(e);
    }
    return Left(Exception("رجاء قم بكتابة بريد إلكتروني صحيح"));
  }
}
