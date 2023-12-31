// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAre5i3WoWLpx28KHuC7gPRbjqmc9JC-uA',
    appId: '1:365783008418:web:4840f2af7af329db04c3fb',
    messagingSenderId: '365783008418',
    projectId: 'ngoc-huong-86683',
    authDomain: 'ngoc-huong-86683.firebaseapp.com',
    storageBucket: 'ngoc-huong-86683.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAokQmpqBF5WuplEe_MWx_kIWo7rK2vE6Y',
    appId: '1:365783008418:android:ce0fda1c85153d4904c3fb',
    messagingSenderId: '365783008418',
    projectId: 'ngoc-huong-86683',
    storageBucket: 'ngoc-huong-86683.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKTpH4TXjBseDqAnK3DsvVrvuHlTva7sM',
    appId: '1:365783008418:ios:8c4ea8a11cc54ad004c3fb',
    messagingSenderId: '365783008418',
    projectId: 'ngoc-huong-86683',
    storageBucket: 'ngoc-huong-86683.appspot.com',
    iosClientId:
        '365783008418-s7ja1hgn8bufu88j2hibt5l2nopeuenj.apps.googleusercontent.com',
    iosBundleId: 'com.tan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKTpH4TXjBseDqAnK3DsvVrvuHlTva7sM',
    appId: '1:365783008418:ios:8c4ea8a11cc54ad004c3fb',
    messagingSenderId: '365783008418',
    projectId: 'ngoc-huong-86683',
    storageBucket: 'ngoc-huong-86683.appspot.com',
    iosClientId:
        '365783008418-s7ja1hgn8bufu88j2hibt5l2nopeuenj.apps.googleusercontent.com',
    iosBundleId: '',
  );
}
