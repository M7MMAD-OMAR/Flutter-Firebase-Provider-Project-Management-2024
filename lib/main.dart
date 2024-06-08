import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'Utils/messages.dart';
import 'constants/constants.dart';
import 'controllers/language_controller.dart';
import 'firebase_options.dart';
import 'screens/Auth/auth_screen.dart';
import 'services/auth_service.dart';
import 'utils/dep.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Firebase.apps.isEmpty) {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthService()));
  // }
  await AndroidAlarmManager.initialize();
  const int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(
  //     const Duration(seconds: 45), helloAlarmID, checkAuth,
  //     wakeup: true, rescheduleOnReboot: true);
  // await fcmHandler();
  Map<String, Map<String, String>> languages = await dep.init();

  runApp(MyApp(
    languages: languages,
  ));
}

/// هذه الدالة fcmHandler مسؤولة عن التعامل مع إشعارات Firebase Cloud Messaging (FCM) في تطبيق Flutter.
// @pragma('vm:entry-point')
// Future<void> fcmHandler() async {
//   FirebaseMessaging.onMessage.listen(FcmNotifications.handleMessageJson);
//   FirebaseMessaging.onMessageOpenedApp
//       .listen(FcmNotifications.handleMessageJson);
//   FirebaseMessaging.onBackgroundMessage(FcmNotifications.handleMessageJson);
//   RemoteMessage? remoteMessage =
//   await FirebaseMessaging.instance.getInitialMessage();
//   if (remoteMessage != null) {
//     await FcmNotifications.handleMessageJson(remoteMessage);
//   }
// }

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) =>
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return GetMaterialApp(
          locale: localizationController.locale,
          translations: Messages(languages: languages),
          fallbackLocale:
              Locale(Constants.languageCode[1], Constants.countryCode[1]),
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
        );
      }),
    );
  }
}
