import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http_proxy/http_proxy.dart';
import 'package:project_management_muhmad_omar/providers.dart';
import 'package:project_management_muhmad_omar/providers/lang_provider.dart';
import 'package:project_management_muhmad_omar/screens/auth_screen/auth_page_screen.dart';
import 'package:project_management_muhmad_omar/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';
import 'utils/dep.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //           options: DefaultFirebaseOptions.currentPlatform)
  //       .then((value) => Get.put(AuthService()));
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await AndroidAlarmManager.initialize();
  // const int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(seconds: 45), helloAlarmID, checkAuth,
  //     wakeup: true, rescheduleOnReboot: true);
  // await fcmHandler();
  Map<String, Map<String, String>> languages = await dep.init();
  WidgetsFlutterBinding.ensureInitialized();
  HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  HttpOverrides.global = httpProxy;
  runApp(MyApp(
    languages: languages,
  ));
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

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: Providers.providers,
          child: Consumer<LangProvider>(
            builder: (context, localizationController, child) {
              return MaterialApp(
                locale: localizationController.locale,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ar', 'SY'),
                ],
                debugShowCheckedModeBanner: false,
                home: const AuthPage(),
              );
            },
          ),
        );
      },
    );
  }
}
