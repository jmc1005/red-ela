// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDKlew3tPoDXjB9vyN0yvcxFy_VcWJawR4',
    appId: '1:757105304257:web:fcf313d670026837f8ea40',
    messagingSenderId: '757105304257',
    projectId: 'redela-81338',
    authDomain: 'redela-81338.firebaseapp.com',
    storageBucket: 'redela-81338.appspot.com',
    measurementId: 'G-GRYW8XM20W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdabpO7hQBIolmQu9pFPCFCWIBXCHGI3A',
    appId: '1:757105304257:android:f33502c4023baaf1f8ea40',
    messagingSenderId: '757105304257',
    projectId: 'redela-81338',
    storageBucket: 'redela-81338.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLUaLKz7zErWBCkJ5smqy7YK_ri2hWCDY',
    appId: '1:757105304257:ios:5a16c7b3f7ff409bf8ea40',
    messagingSenderId: '757105304257',
    projectId: 'redela-81338',
    storageBucket: 'redela-81338.appspot.com',
    iosBundleId: 'es.ubu.tfg2324.ela.redEla',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCLUaLKz7zErWBCkJ5smqy7YK_ri2hWCDY',
    appId: '1:757105304257:ios:5a16c7b3f7ff409bf8ea40',
    messagingSenderId: '757105304257',
    projectId: 'redela-81338',
    storageBucket: 'redela-81338.appspot.com',
    iosBundleId: 'es.ubu.tfg2324.ela.redEla',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDKlew3tPoDXjB9vyN0yvcxFy_VcWJawR4',
    appId: '1:757105304257:web:1b988054e8a94c47f8ea40',
    messagingSenderId: '757105304257',
    projectId: 'redela-81338',
    authDomain: 'redela-81338.firebaseapp.com',
    storageBucket: 'redela-81338.appspot.com',
    measurementId: 'G-87Y824GK8F',
  );

}