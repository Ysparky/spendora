// This file is a proxy for backward compatibility
// It forwards to the environment configuration

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:spendora/core/config/env_config.dart';

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
    return EnvConfig.firebaseOptions;
  }
}
