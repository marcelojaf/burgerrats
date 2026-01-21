import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'error_messages.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Extension to add Sentry error reporting to Streams
extension StreamErrorReporting<T> on Stream<T> {
  /// Handles errors in the stream and reports them to Sentry
  ///
  /// [onError] - Optional callback to transform the error before re-throwing
  /// [context] - Optional context map for Sentry
  ///
  /// Example:
  /// ```dart
  /// return _firestore.collection('leagues').snapshots()
  ///     .map((snapshot) => snapshot.docs.map(...))
  ///     .handleErrorWithSentry(
  ///       onError: (error, stackTrace) {
  ///         if (error is FirebaseException) {
  ///           throw FirestoreException(...);
  ///         }
  ///         throw error;
  ///       },
  ///       context: {'operation': 'watchLeagues'},
  ///     );
  /// ```
  Stream<T> handleErrorWithSentry({
    void Function(Object error, StackTrace stackTrace)? onError,
    Map<String, dynamic>? context,
  }) {
    return handleError((error, stackTrace) {
      // Report to Sentry
      ErrorHandler.reportToSentry(
        error,
        stackTrace: stackTrace,
        context: context,
      );

      // Call custom error handler if provided
      if (onError != null) {
        onError(error, stackTrace);
      } else {
        throw error;
      }
    });
  }
}

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

  /// Handles an error and reports it to Sentry
  ///
  /// Use this method when you want to ensure the error is reported to Sentry
  /// even if it's being handled/caught locally.
  ///
  /// [error] - The error to handle
  /// [stackTrace] - Optional stack trace
  /// [hint] - Optional additional context for Sentry
  ///
  /// Returns the transformed AppException
  static Future<AppException> handleErrorAndReport(
    dynamic error, [
    StackTrace? stackTrace,
    Map<String, dynamic>? hint,
  ]) async {
    final exception = handleError(error, stackTrace);

    // Report to Sentry (only in release mode, as Sentry skips debug mode)
    if (!kDebugMode) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: hint != null
            ? Hint.withMap({
                ...hint,
                'error_type': exception.runtimeType.toString(),
                'error_code': exception.code ?? 'unknown',
              })
            : Hint.withMap({
                'error_type': exception.runtimeType.toString(),
                'error_code': exception.code ?? 'unknown',
              }),
      );
    }

    return exception;
  }

  /// Reports an error to Sentry without transforming it
  ///
  /// Use this for errors that you want to track in Sentry but are already
  /// being handled appropriately in the app.
  ///
  /// [error] - The error to report
  /// [stackTrace] - Optional stack trace
  /// [context] - Optional context map for additional information
  static Future<void> reportToSentry(
    dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    if (kDebugMode) {
      debugPrint('ErrorHandler.reportToSentry: $error');
      return;
    }

    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: context != null ? Hint.withMap(context) : null,
    );
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
