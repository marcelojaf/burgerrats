import '../../../core/errors/error_messages.dart';

/// Form validators for authentication and other forms
class Validators {
  Validators._();

  /// Validates an email address
  /// Returns null if valid, error message if invalid
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.requiredField;
    }

    // Simple email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return ErrorMessages.invalidEmail;
    }

    return null;
  }

  /// Validates a password
  /// Returns null if valid, error message if invalid
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.requiredField;
    }

    if (value.length < 6) {
      return ErrorMessages.weakPassword;
    }

    return null;
  }

  /// Validates password confirmation matches
  /// Returns null if valid, error message if invalid
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return ErrorMessages.requiredField;
    }

    if (value != password) {
      return ErrorMessages.passwordMismatch;
    }

    return null;
  }

  /// Validates a required field
  /// Returns null if valid, error message if invalid
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorMessages.requiredField;
    }

    return null;
  }

  /// Validates a display name (1-50 characters)
  /// Returns null if valid, error message if invalid
  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ErrorMessages.requiredField;
    }

    if (value.trim().length > 50) {
      return ErrorMessages.maxLength;
    }

    return null;
  }
}
