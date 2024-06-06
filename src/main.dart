import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './routes.dart';
import 'package:provider/provider.dart';

import 'providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold();
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
