import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/features/auth/presentation/controllers/auth_controller.dart';

// A provider that exposes the auth error messages
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authControllerProvider);

  return authState.maybeWhen(
    error: (error, _) => error.toString(),
    orElse: () => null,
  );
});
