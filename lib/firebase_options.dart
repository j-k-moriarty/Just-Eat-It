// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDJrgFcO0xW15-3GePC5bXLG-nDJktElXU',
    appId: '1:387957106808:web:c13c7e832b4ef55fe4658d',
    messagingSenderId: '387957106808',
    projectId: 'cs321-just-eat-it',
    authDomain: 'cs321-just-eat-it.firebaseapp.com',
    storageBucket: 'cs321-just-eat-it.appspot.com',
    measurementId: 'G-LSD37FQKB2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCK43dvYmw5C2aL49eGGFI5TWrxsCRx81o',
    appId: '1:387957106808:android:288af4bf405fee98e4658d',
    messagingSenderId: '387957106808',
    projectId: 'cs321-just-eat-it',
    storageBucket: 'cs321-just-eat-it.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmFW_jov3EZy9HFXtqqe5_NQieA_vxYCc',
    appId: '1:387957106808:ios:8709340ae7cb875ce4658d',
    messagingSenderId: '387957106808',
    projectId: 'cs321-just-eat-it',
    storageBucket: 'cs321-just-eat-it.appspot.com',
    iosClientId: '387957106808-flhn0pn6q98erbccdgafg623e8a7tkqf.apps.googleusercontent.com',
    iosBundleId: 'justeatit',
  );
}
