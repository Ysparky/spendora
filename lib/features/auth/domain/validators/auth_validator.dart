class AuthValidationError implements Exception {
  AuthValidationError(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthValidator {
  static void validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      throw AuthValidationError('Por favor ingresa tu email');
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw AuthValidationError('Por favor ingresa un email válido');
    }
  }

  static void validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      throw AuthValidationError('Por favor ingresa tu contraseña');
    }
    if (password.length < 8) {
      throw AuthValidationError(
        'La contraseña debe tener al menos 8 caracteres',
      );
    }
    // At least one uppercase letter
    if (!password.contains(RegExp('[A-Z]'))) {
      throw AuthValidationError(
        'La contraseña debe contener al menos una mayúscula',
      );
    }
    // At least one number
    if (!password.contains(RegExp('[0-9]'))) {
      throw AuthValidationError(
        'La contraseña debe contener al menos un número',
      );
    }
  }

  static void validatePasswordMatch(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      throw AuthValidationError('Por favor confirma tu contraseña');
    }
    if (password != confirmPassword) {
      throw AuthValidationError('Las contraseñas no coinciden');
    }
  }

  static void validateName(String? name) {
    if (name == null || name.isEmpty) {
      throw AuthValidationError('Por favor ingresa tu nombre');
    }
    if (name.trim().length < 2) {
      throw AuthValidationError('El nombre debe tener al menos 2 caracteres');
    }
  }
}
