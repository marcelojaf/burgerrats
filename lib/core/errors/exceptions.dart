/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.statusCode,
  });
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown when there's no network connection
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for authentication errors
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for validation errors
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors,
  });
}

/// Exception thrown for Firestore operations
class FirestoreException extends AppException {
  const FirestoreException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for Firebase Storage operations
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for permission-related issues
class PermissionException extends AppException {
  final String? permissionType;

  const PermissionException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.permissionType,
  });
}

/// Exception thrown for camera/photo capture operations
class CameraException extends AppException {
  const CameraException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for business logic errors
class BusinessException extends AppException {
  const BusinessException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for unexpected/unknown errors
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception thrown for image compression operations
class CompressionException extends AppException {
  const CompressionException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
