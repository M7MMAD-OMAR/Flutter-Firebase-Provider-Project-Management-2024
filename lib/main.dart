import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers.dart';
import './routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        title: 'Flutter Mobile Application',
        // theme: appTheme(),
        // home: SplashScreen(),
        routes: Routes.routes,
      ),
    );
  }
}
