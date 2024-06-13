import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/screens/dashboard_screen/timeline_screen.dart';
import 'package:project_management_muhmad_omar/screens/onboarding_screen/onboarding_start_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/my_auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<MyAuthProvider>(context);

    return Scaffold(
      body: StreamProvider<User?>.value(
        value: auth.firebaseAuth.authStateChanges(),
        initialData: null,
        child: Consumer<User?>(
          builder: (context, user, _) {
            if (user == null || !user.emailVerified && !user.isAnonymous) {
              return const OnboardingStartScreen();
            } else if (user.isAnonymous ||
                (user.emailVerified && !user.isAnonymous)) {
              return const TimelineScreen();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
