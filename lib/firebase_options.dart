import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAO3lg514vLQ-8Y51N-4koPb962GUM66ls',
    appId: '1:526714468929:web:581092f6c44628a2ba24c0',
    messagingSenderId: '526714468929',
    projectId: 'project-management-muhmad-omar',
    authDomain: 'project-management-muhmad-omar.firebaseapp.com',
    storageBucket: 'project-management-muhmad-omar.appspot.com',
    measurementId: 'G-7TJVR4TPCW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjbfbS6M2o55iavgpdG-jXwuIZ8QTPZDw',
    appId: '1:526714468929:android:60c0042604382ad6ba24c0',
    messagingSenderId: '526714468929',
    projectId: 'project-management-muhmad-omar',
    storageBucket: 'project-management-muhmad-omar.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjBk3lihV5ka_aZum8wayE0Ax1Xkl5R1U',
    appId: '1:526714468929:ios:36e431389010ffecba24c0',
    messagingSenderId: '526714468929',
    projectId: 'project-management-muhmad-omar',
    storageBucket: 'project-management-muhmad-omar.appspot.com',
    iosBundleId: 'com.asalib.projectManagementMuhmadOmar',
  );
}
