import 'package:firebase_auth/firebase_auth.dart';

/// Utility class to handle Firebase Auth error codes
class FirebaseAuthErrorHandler {
  /// Converts Firebase Auth error codes to user-friendly messages
  static String handleError(FirebaseAuthException exception) {
    switch (exception.code) {
      // Sign in errors
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Correo o contraseña incorrectos';
      case 'invalid-email':
        return 'El formato del correo electrónico es inválido';
      case 'user-disabled':
        return 'Este usuario ha sido deshabilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo de nuevo más tarde';

      // Registration errors
      case 'email-already-in-use':
        return 'Este correo ya está registrado. Intenta iniciar sesión';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'operation-not-allowed':
        return 'Operación no permitida';

      // Password reset errors
      case 'expired-action-code':
        return 'El código ha expirado';
      case 'invalid-action-code':
        return 'El código es inválido';

      // Network errors
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu red';

      // Google sign in errors
      case 'account-exists-with-different-credential':
        return 'Ya existe una cuenta con este correo pero con otro método de inicio de sesión';
      case 'popup-closed-by-user':
        return 'Se cerró la ventana de inicio de sesión';
      case 'cancelled-popup-request':
        return 'La operación fue cancelada';

      // Default fallback
      default:
        return exception.message ??
            'Ha ocurrido un error. Por favor intenta de nuevo';
    }
  }
}
