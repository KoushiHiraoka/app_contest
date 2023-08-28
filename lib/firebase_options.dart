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
    apiKey: 'AIzaSyCZqph0a84xr03zjkiqTE_u8atElhjravU',
    appId: '1:53379008663:web:f3e8570dd2bd651e33c1d2',
    messagingSenderId: '53379008663',
    projectId: 'humanophi',
    authDomain: 'humanophi.firebaseapp.com',
    storageBucket: 'humanophi.appspot.com',
    measurementId: 'G-01RJDLXK50',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhD4KGwrHXNAOLaaBOclkZyK5lj2xaJs8',
    appId: '1:53379008663:android:66d5a3760782345f33c1d2',
    messagingSenderId: '53379008663',
    projectId: 'humanophi',
    storageBucket: 'humanophi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBX7iHFksEVYtAK5DYVvcWLekp35G0HSgs',
    appId: '1:53379008663:ios:5c23ef5a154bb26733c1d2',
    messagingSenderId: '53379008663',
    projectId: 'humanophi',
    storageBucket: 'humanophi.appspot.com',
    iosClientId: '53379008663-bmk84t963j4hsthtc5e28c07gd344c06.apps.googleusercontent.com',
    iosBundleId: 'com.example.appContest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBX7iHFksEVYtAK5DYVvcWLekp35G0HSgs',
    appId: '1:53379008663:ios:5c23ef5a154bb26733c1d2',
    messagingSenderId: '53379008663',
    projectId: 'humanophi',
    storageBucket: 'humanophi.appspot.com',
    iosClientId: '53379008663-bmk84t963j4hsthtc5e28c07gd344c06.apps.googleusercontent.com',
    iosBundleId: 'com.example.appContest',
  );
}
