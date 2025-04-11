import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spendora/features/auth/domain/utils/firebase_auth_error_handler.dart';
import 'package:spendora/features/auth/presentation/controllers/auth_controller.dart';

part 'social_auth_controller.g.dart';

enum SocialAuthStatus {
  initial,
  loading,
  success,
  error,
}

@riverpod
class GoogleSignInController extends _$GoogleSignInController {
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  @override
  SocialAuthStatus build() {
    ref.listen(authControllerProvider, (previous, next) {
      if ((previous?.isLoading ?? false) && next.hasValue) {
        // Sign-in was successful
        state = SocialAuthStatus.success;
        _errorMessage = '';

        // Show success message in a post-frame callback to avoid build-phase
        // errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // We don't show a success message here because the user will be
          // redirected to the dashboard by the router
        });
      } else if ((previous?.isLoading ?? false) && next.hasError) {
        // Sign-in failed
        state = SocialAuthStatus.error;
        _errorMessage = next.error.toString();
      }
    });

    return SocialAuthStatus.initial;
  }

  Future<void> signIn() async {
    if (state == SocialAuthStatus.loading) return;

    _errorMessage = '';
    state = SocialAuthStatus.loading;
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
      // We don't set state here, as it will be set by the listener above
    } on FirebaseAuthException catch (e) {
      _errorMessage = FirebaseAuthErrorHandler.handleError(e);
      print('Error signing in with Google: ${e.message}');
      state = SocialAuthStatus.error;
    } on Exception catch (e) {
      // In case the error isn't caught by the auth controller
      _errorMessage = FirebaseAuthErrorHandler.handleGoogleSignInError(e);
      print('Error signing in with Google: $e');
      state = SocialAuthStatus.error;
    }
  }

  void reset() {
    _errorMessage = '';
    state = SocialAuthStatus.initial;
  }
}
