import 'exceptions.dart';

/// Base class for all failures in the application
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  /// Creates a failure from an exception
  factory Failure.fromException(AppException exception) {
    return switch (exception) {
      ServerException() => ServerFailure(
          message: exception.message,
          code: exception.code,
        ),
      CacheException() => CacheFailure(
          message: exception.message,
          code: exception.code,
        ),
      NetworkException() => NetworkFailure(
          message: exception.message,
          code: exception.code,
        ),
      AuthException() => AuthFailure(
          message: exception.message,
          code: exception.code,
        ),
      ValidationException(:final fieldErrors) => ValidationFailure(
          message: exception.message,
          code: exception.code,
          fieldErrors: fieldErrors,
        ),
      FirestoreException() => FirestoreFailure(
          message: exception.message,
          code: exception.code,
        ),
      StorageException() => StorageFailure(
          message: exception.message,
          code: exception.code,
        ),
      PermissionException(:final permissionType) => PermissionFailure(
          message: exception.message,
          code: exception.code,
          permissionType: permissionType,
        ),
      BusinessException() => BusinessFailure(
          message: exception.message,
          code: exception.code,
        ),
      _ => UnknownFailure(
          message: exception.message,
          code: exception.code,
        ),
    };
  }
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

/// Validation-related failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    this.fieldErrors,
  });
}

/// Firestore-related failures
class FirestoreFailure extends Failure {
  const FirestoreFailure({required super.message, super.code});
}

/// Firebase Storage-related failures
class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}

/// Permission-related failures
class PermissionFailure extends Failure {
  final String? permissionType;

  const PermissionFailure({
    required super.message,
    super.code,
    this.permissionType,
  });
}

/// Business logic failures
class BusinessFailure extends Failure {
  const BusinessFailure({required super.message, super.code});
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code});
}
