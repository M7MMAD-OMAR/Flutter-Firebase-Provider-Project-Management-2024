import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/providers.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.providers,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
        debugShowCheckedModeBanner: false,
        // home: AuthScreen(),
        initialRoute: Routes.loginScreen,
        routes: Routes.routes,
      ),
    );
  }
}
