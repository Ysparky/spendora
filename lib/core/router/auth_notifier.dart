import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

/// A [ChangeNotifier] for [FirebaseAuth] that notifies listeners
/// when the auth state changes
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    // Listen to Firebase Auth state changes
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((_) {
      // Notify listeners when auth state changes
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _authStateChangesSubscription;

  @override
  void dispose() {
    _authStateChangesSubscription.cancel();
    super.dispose();
  }
}

@riverpod
AuthNotifier authNotifier(Ref ref) {
  final notifier = AuthNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
}
