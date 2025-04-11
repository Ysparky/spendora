import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  @override
  SocialAuthStatus build() {
    ref.listen(authControllerProvider, (previous, next) {
      if ((previous?.isLoading ?? false) && next.hasValue) {
        // Sign-in was successful
        state = SocialAuthStatus.success;

        // Show success message in a post-frame callback to avoid build-phase errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // We don't show a success message here because the user will be redirected
          // to the dashboard by the router
        });
      } else if ((previous?.isLoading ?? false) && next.hasError) {
        // Sign-in failed
        state = SocialAuthStatus.error;
      }
    });

    return SocialAuthStatus.initial;
  }

  Future<void> signIn() async {
    if (state == SocialAuthStatus.loading) return;

    state = SocialAuthStatus.loading;
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
      // We don't set state here, as it will be set by the listener above
    } on Exception catch (e) {
      // In case the error isn't caught by the auth controller
      print('Error signing in with Google: $e');
      state = SocialAuthStatus.error;
    }
  }

  void reset() {
    state = SocialAuthStatus.initial;
  }
}
