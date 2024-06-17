import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_start_screen.dart';
import 'package:project_management_muhmad_omar/services/auth_service.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: AuthProvider.instance.firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const OnboardingStart();
            }
            if (snapshot.data!.isAnonymous) {
              return const Timeline();
            }
            if (snapshot.data!.emailVerified && !snapshot.data!.isAnonymous) {
              return const Timeline();
            }
            if (!snapshot.data!.emailVerified && !snapshot.data!.isAnonymous) {
              return const OnboardingStart();
            }
          } else {
            return const OnboardingStart();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
