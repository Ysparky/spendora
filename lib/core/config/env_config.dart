import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class that loads values from .env file
class EnvConfig {
  /// Initializes the environment configuration
  static Future<void> init() async {
    await dotenv.load();
  }

  /// Gets a value from the environment
  static String get(String key) {
    return dotenv.env[key] ?? '';
  }

  /// Firebase Options based on environment variables
  static FirebaseOptions get firebaseOptions {
    if (kIsWeb) {
      // Define web options if needed
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return iOS;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
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

  /// Android Firebase options from env variables
  static FirebaseOptions get android {
    return FirebaseOptions(
      apiKey: EnvConfig.get('FIREBASE_ANDROID_API_KEY'),
      appId: EnvConfig.get('FIREBASE_ANDROID_APP_ID'),
      messagingSenderId: EnvConfig.get('FIREBASE_ANDROID_MESSAGING_SENDER_ID'),
      projectId: EnvConfig.get('FIREBASE_ANDROID_PROJECT_ID'),
      storageBucket: EnvConfig.get('FIREBASE_ANDROID_STORAGE_BUCKET'),
    );
  }

  /// iOS Firebase options from env variables
  static FirebaseOptions get iOS {
    return FirebaseOptions(
      apiKey: EnvConfig.get('FIREBASE_IOS_API_KEY'),
      appId: EnvConfig.get('FIREBASE_IOS_APP_ID'),
      messagingSenderId: EnvConfig.get('FIREBASE_IOS_MESSAGING_SENDER_ID'),
      projectId: EnvConfig.get('FIREBASE_IOS_PROJECT_ID'),
      storageBucket: EnvConfig.get('FIREBASE_IOS_STORAGE_BUCKET'),
      iosBundleId: EnvConfig.get('FIREBASE_IOS_BUNDLE_ID'),
    );
  }
}
