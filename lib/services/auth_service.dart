import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management_muhmad_omar/services/user_service.dart';

import '../models/User/user_model.dart';
import '../providers/user_provider/user_provider.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UserService userService = UserService();

  EitherException<bool> createUserWithEmailAndPassword(
      {required String email,
      required password,
      required UserModel userModel}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userModel.id = userCredential.user!.uid;
      await userService.createUser(userModel: userModel);
      return const Right(true);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
