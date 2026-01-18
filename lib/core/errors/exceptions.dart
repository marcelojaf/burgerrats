/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException({required super.message, super.code});
}

/// Exception thrown when there's no network connection
class NetworkException extends AppException {
  const NetworkException({required super.message, super.code});
}
