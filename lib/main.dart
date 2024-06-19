import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:project_management_muhmad_omar/providers.dart';
import 'package:project_management_muhmad_omar/routes.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;
  // runApp(MyApp(
  //   languages: languages,
  // ));

  runApp(
    MultiProvider(
      providers: Providers.providers,
      child: MyApp(),
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

          // home: AuthScreen(),
          initialRoute: Routes.authScreen,
          routes: Routes.routes,
        );
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> fcmHandler() async {
  FirebaseMessaging.onMessage
      .listen(FcmNotificationsProvider.handleMessageJson);
  FirebaseMessaging.onMessageOpenedApp
      .listen(FcmNotificationsProvider.handleMessageJson);
  FirebaseMessaging.onBackgroundMessage(
      FcmNotificationsProvider.handleMessageJson);
  RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {
    await FcmNotificationsProvider.handleMessageJson(remoteMessage);
  }
}
