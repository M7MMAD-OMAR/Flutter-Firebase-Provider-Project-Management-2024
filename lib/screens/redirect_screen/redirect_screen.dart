import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/constants/constants.dart';
import 'package:project_management_muhmad_omar/screens/login_screen/login_screen.dart';
import 'package:project_management_muhmad_omar/screens/projects_screen/projects_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';

class RedirectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().checkUserLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Constants.loadingAnimationWidget(context);
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ أثناء التحقق من تسجيل الدخول'));
          } else {
            bool isLoggedIn = snapshot.data ?? false;
            if (isLoggedIn) {
              return ProjectsScreen();
            } else {
              return LoginScreen();
            }
          }
        }
      },
    );
  }
}
