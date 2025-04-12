import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/features/auth/presentation/controllers/auth_error_controller.dart';

/// Widget that listens for auth errors and shows a SnackBar
class AuthErrorListener extends ConsumerWidget {
  const AuthErrorListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use select to only rebuild when the error changes
    // final errorMessage = ref.watch(authErrorProvider);

    // When the error message changes and isn't null, show a Snackbar
    ref.listen<String?>(
      authErrorProvider,
      (_, errorMessage) {
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      },
    );

    return child;
  }
}
