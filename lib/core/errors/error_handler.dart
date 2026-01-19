import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'error_messages.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Handles error transformation, logging, and display
class ErrorHandler {
  ErrorHandler._();

  static final List<void Function(AppException, StackTrace?)> _errorListeners =
      [];

  /// Adds a listener that will be called whenever an error is handled
  static void addErrorListener(
      void Function(AppException, StackTrace?) listener) {
    _errorListeners.add(listener);
  }

  /// Removes a previously added error listener
  static void removeErrorListener(
      void Function(AppException, StackTrace?) listener) {
    _errorListeners.remove(listener);
  }

  /// Notifies all error listeners
  static void _notifyListeners(AppException exception, StackTrace? stackTrace) {
    for (final listener in _errorListeners) {
      try {
        listener(exception, stackTrace);
      } catch (e) {
        debugPrint('Error in error listener: $e');
      }
    }
  }

  /// Transforms any error into an AppException with a user-friendly message
  static AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    final exception = _transformToException(error, stackTrace);

    // Log the error in debug mode
    if (kDebugMode) {
      debugPrint('ErrorHandler: ${exception.runtimeType}');
      debugPrint('Message: ${exception.message}');
      debugPrint('Code: ${exception.code}');
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }

    // Notify listeners
    _notifyListeners(exception, stackTrace);

    return exception;
  }

  /// Transforms any error into an AppException
  static AppException _transformToException(
      dynamic error, StackTrace? stackTrace) {
    // Already an AppException
    if (error is AppException) {
      return error;
    }

    // Handle common Flutter/Dart exceptions
    if (error is SocketException) {
      return NetworkException(
        message: ErrorMessages.noInternet,
        code: 'network-error',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is TimeoutException) {
      return NetworkException(
        message: ErrorMessages.connectionTimeout,
        code: 'timeout',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is FormatException) {
      return ValidationException(
        message: ErrorMessages.invalidFormat,
        code: 'format-error',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Handle Firebase exceptions by checking error code in message/toString
    final errorString = error.toString().toLowerCase();

    if (_isFirebaseAuthError(errorString)) {
      return _handleFirebaseAuthError(error, stackTrace);
    }

    if (_isFirestoreError(errorString)) {
      return _handleFirestoreError(error, stackTrace);
    }

    if (_isStorageError(errorString)) {
      return _handleStorageError(error, stackTrace);
    }

    // Default to unknown exception
    return UnknownException(
      message: ErrorMessages.unknownError,
      code: 'unknown',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static bool _isFirebaseAuthError(String errorString) {
    return errorString.contains('firebase') && errorString.contains('auth');
  }

  static bool _isFirestoreError(String errorString) {
    return errorString.contains('firestore') ||
        errorString.contains('cloud_firestore');
  }

  static bool _isStorageError(String errorString) {
    return errorString.contains('firebase_storage') ||
        errorString.contains('storage/');
  }

  static AppException _handleFirebaseAuthError(
      dynamic error, StackTrace? stackTrace) {
    String? code;

    // Try to extract error code
    if (error is Exception) {
      final errorString = error.toString();
      final codeMatch =
          RegExp(r'\[([^\]]+)\]').firstMatch(errorString)?.group(1);
      code = codeMatch;
    }

    return AuthException(
      message: ErrorMessages.getMessageForCode(code),
      code: code,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static AppException _handleFirestoreError(
      dynamic error, StackTrace? stackTrace) {
    String? code;

    // Try to extract error code
    if (error is Exception) {
      final errorString = error.toString();
      final codeMatch =
          RegExp(r'\[([^\]]+)\]').firstMatch(errorString)?.group(1);
      code = codeMatch;
    }

    return FirestoreException(
      message: ErrorMessages.getMessageForCode(code),
      code: code,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static AppException _handleStorageError(
      dynamic error, StackTrace? stackTrace) {
    String? code;

    // Try to extract error code
    if (error is Exception) {
      final errorString = error.toString();
      final codeMatch =
          RegExp(r'storage/([^\]]+)').firstMatch(errorString)?.group(0);
      code = codeMatch;
    }

    return StorageException(
      message: ErrorMessages.getMessageForCode(code),
      code: code,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Converts an AppException to a Failure for domain layer
  static Failure toFailure(AppException exception) {
    return Failure.fromException(exception);
  }

  /// Gets a user-friendly message for any error
  static String getUserMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }
    if (error is Failure) {
      return error.message;
    }
    return handleError(error).message;
  }

  /// Executes a function and handles any errors that occur
  static Future<T> runGuarded<T>(
    Future<T> Function() fn, {
    T Function(AppException)? onError,
  }) async {
    try {
      return await fn();
    } catch (e, stackTrace) {
      final exception = handleError(e, stackTrace);
      if (onError != null) {
        return onError(exception);
      }
      rethrow;
    }
  }

  /// Executes a synchronous function and handles any errors
  static T runGuardedSync<T>(
    T Function() fn, {
    T Function(AppException)? onError,
  }) {
    try {
      return fn();
    } catch (e, stackTrace) {
      final exception = handleError(e, stackTrace);
      if (onError != null) {
        return onError(exception);
      }
      rethrow;
    }
  }
}
