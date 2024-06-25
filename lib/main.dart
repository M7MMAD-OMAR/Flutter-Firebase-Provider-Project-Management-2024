import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management_muhmad_omar/providers.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'constants/constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await AndroidAlarmManager.initialize();
  // const int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(seconds: 45), helloAlarmID, checkAuth,
  //     wakeup: true, rescheduleOnReboot: true);
  // await fcmHandler();

  runApp(
    MultiProvider(
      providers: Providers.providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          locale: const Locale('ar'),
          // supportedLocales: const [
          //   Locale('ar'),
          // ],
          // localizationsDelegates: const [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // localeResolutionCallback: (locale, supportedLocales) {
          //   for (var supportedLocale in supportedLocales) {
          //     if (supportedLocale.languageCode == locale?.languageCode) {
          //       return supportedLocale;
          //     }
          //   }
          //   return supportedLocales.first;
          // },
          // home: AuthScreen(),
          initialRoute: Routes.authScreen,
          routes: Routes.routes,
        );
      },
    );
  }
}

// @pragma('vm:entry-point')
// Future<void> fcmHandler() async {
//   FirebaseMessaging.onMessage
//       .listen(FcmNotificationsProvider.handleMessageJson);
//   FirebaseMessaging.onMessageOpenedApp
//       .listen(FcmNotificationsProvider.handleMessageJson);
//   FirebaseMessaging.onBackgroundMessage(
//       FcmNotificationsProvider.handleMessageJson);
//   RemoteMessage? remoteMessage =
//       await FirebaseMessaging.instance.getInitialMessage();
//   if (remoteMessage != null) {
//     await FcmNotificationsProvider.handleMessageJson(remoteMessage);
//   }
// }
