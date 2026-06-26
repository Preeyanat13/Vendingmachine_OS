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
    apiKey: 'AIzaSyB8up44AyVuGwBtsdD6h1diKMCNzlzrCtQ',
    appId: '1:18365957073:web:1b2fc1a8ac2713ec49d6f0',
    messagingSenderId: '18365957073',
    projectId: 'vending-machine-os',
    authDomain: 'vending-machine-os.firebaseapp.com',
    storageBucket: 'vending-machine-os.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDs8Ls6mUrIRpuS3kKm_hCEqjR6fDI77no',
    appId: '1:18365957073:android:54017f339ce5245649d6f0',
    messagingSenderId: '18365957073',
    projectId: 'vending-machine-os',
    storageBucket: 'vending-machine-os.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAz1xnvCxFSlFzzmyyRQJl43WFFKLM3SXE',
    appId: '1:18365957073:ios:68dd0ddfe352f0ce49d6f0',
    messagingSenderId: '18365957073',
    projectId: 'vending-machine-os',
    storageBucket: 'vending-machine-os.firebasestorage.app',
    iosBundleId: 'com.example.projectOs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAz1xnvCxFSlFzzmyyRQJl43WFFKLM3SXE',
    appId: '1:18365957073:ios:68dd0ddfe352f0ce49d6f0',
    messagingSenderId: '18365957073',
    projectId: 'vending-machine-os',
    storageBucket: 'vending-machine-os.firebasestorage.app',
    iosBundleId: 'com.example.projectOs',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB8up44AyVuGwBtsdD6h1diKMCNzlzrCtQ',
    appId: '1:18365957073:web:3280ccf1c7d34a8649d6f0',
    messagingSenderId: '18365957073',
    projectId: 'vending-machine-os',
    authDomain: 'vending-machine-os.firebaseapp.com',
    storageBucket: 'vending-machine-os.firebasestorage.app',
  );
}
