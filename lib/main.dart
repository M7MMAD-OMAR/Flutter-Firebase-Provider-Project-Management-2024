import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:project_management_muhmad_omar/providers.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/auth_page_screen.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AuthPage(),
        );
      },
    );
  }
}

@pragma('vm:entry-point')
Future<void> fcmHandler() async {
  FirebaseMessaging.onMessage.listen(FcmNotifications.handleMessageJson);
  FirebaseMessaging.onMessageOpenedApp
      .listen(FcmNotifications.handleMessageJson);
  FirebaseMessaging.onBackgroundMessage(FcmNotifications.handleMessageJson);
  RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {
    await FcmNotifications.handleMessageJson(remoteMessage);
  }
}
