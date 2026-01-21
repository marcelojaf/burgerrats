import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';

/// Wrapper class for Sentry performance monitoring
///
/// Provides utility methods to instrument Firebase operations with
/// Sentry Transactions and Spans for detailed performance tracking.
///
/// Usage:
/// ```dart
/// // Wrap a Firestore operation
/// final result = await SentryPerformanceWrapper.traceFirestoreOperation(
///   operation: 'createLeague',
///   collection: 'leagues',
///   action: () => firestore.collection('leagues').doc().set(data),
///   extraData: {'userId': userId},
/// );
///
/// // Wrap an Auth operation
/// final user = await SentryPerformanceWrapper.traceAuthOperation(
///   operation: 'signInWithEmail',
///   action: () => auth.signInWithEmailAndPassword(email: email, password: password),
/// );
///
/// // Wrap a Storage operation
/// final url = await SentryPerformanceWrapper.traceStorageOperation(
///   operation: 'uploadCheckInPhoto',
///   storagePath: 'check-ins/user123/photo.jpg',
///   action: () => storage.ref(path).putFile(file),
///   extraData: {'fileSize': fileSize},
/// );
/// ```
class SentryPerformanceWrapper {
  /// Operation types for categorization
  static const String opTypeFirestore = 'db.firestore';
  static const String opTypeAuth = 'auth.firebase';
  static const String opTypeStorage = 'storage.firebase';
  static const String opTypeFcm = 'messaging.fcm';

  /// Traces a Firestore operation with Sentry performance monitoring
  ///
  /// Creates a transaction for the operation with relevant metadata.
  ///
  /// [operation] - Name of the operation (e.g., 'createLeague', 'getById')
  /// [collection] - Firestore collection name
  /// [documentId] - Optional document ID if applicable
  /// [action] - The async function to execute
  /// [extraData] - Additional data to attach to the span
  ///
  /// Returns the result of [action]
  /// Throws any exception from [action] after recording it in Sentry
  static Future<T> traceFirestoreOperation<T>({
    required String operation,
    required String collection,
    String? documentId,
    required Future<T> Function() action,
    Map<String, dynamic>? extraData,
  }) async {
    final transaction = Sentry.startTransaction(
      'firestore.$operation',
      opTypeFirestore,
      bindToScope: true,
    );

    final span = transaction.startChild(
      'firestore.$operation',
      description: documentId != null
          ? '$collection/$documentId'
          : collection,
    );

    // Set span data
    span.setData('db.system', 'firestore');
    span.setData('db.collection', collection);
    if (documentId != null) {
      span.setData('db.document_id', documentId);
    }
    if (extraData != null) {
      extraData.forEach((key, value) {
        span.setData(key, value);
      });
    }

    try {
      final result = await action();
      span.status = const SpanStatus.ok();
      return result;
    } catch (error, stackTrace) {
      span.status = const SpanStatus.internalError();
      span.throwable = error;

      // Add error breadcrumb
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Firestore operation failed: $operation',
        category: 'firestore',
        level: SentryLevel.error,
        data: {
          'operation': operation,
          'collection': collection,
          if (documentId != null) 'documentId': documentId,
          'error': error.toString(),
        },
      ));

      // Capture exception in Sentry before re-throwing
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation_type': 'firestore',
          'operation': operation,
          'collection': collection,
          if (documentId != null) 'document_id': documentId,
        }),
      );

      // Re-throw the error
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await span.finish();
      await transaction.finish();
    }
  }

  /// Traces a Firestore query operation
  ///
  /// Similar to [traceFirestoreOperation] but includes query details.
  ///
  /// [operation] - Name of the query operation
  /// [collection] - Firestore collection name
  /// [queryDescription] - Human-readable description of the query
  /// [action] - The async function to execute
  /// [extraData] - Additional data to attach to the span
  static Future<T> traceFirestoreQuery<T>({
    required String operation,
    required String collection,
    String? queryDescription,
    required Future<T> Function() action,
    Map<String, dynamic>? extraData,
  }) async {
    final transaction = Sentry.startTransaction(
      'firestore.query.$operation',
      opTypeFirestore,
      bindToScope: true,
    );

    final span = transaction.startChild(
      'firestore.query',
      description: queryDescription ?? 'Query on $collection',
    );

    span.setData('db.system', 'firestore');
    span.setData('db.collection', collection);
    span.setData('db.operation', 'query');
    if (extraData != null) {
      extraData.forEach((key, value) {
        span.setData(key, value);
      });
    }

    try {
      final result = await action();
      span.status = const SpanStatus.ok();
      return result;
    } catch (error, stackTrace) {
      span.status = const SpanStatus.internalError();
      span.throwable = error;

      // Add error breadcrumb
      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Firestore query failed: $operation',
        category: 'firestore',
        level: SentryLevel.error,
        data: {
          'operation': operation,
          'collection': collection,
          if (queryDescription != null) 'query': queryDescription,
          'error': error.toString(),
        },
      ));

      // Capture exception in Sentry before re-throwing
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation_type': 'firestore_query',
          'operation': operation,
          'collection': collection,
          if (queryDescription != null) 'query_description': queryDescription,
        }),
      );

      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await span.finish();
      await transaction.finish();
    }
  }

  /// Traces a Firebase Auth operation
  ///
  /// [operation] - Name of the auth operation (e.g., 'signIn', 'signUp', 'signOut')
  /// [action] - The async function to execute
  /// [extraData] - Additional data to attach to the span (avoid PII)
  static Future<T> traceAuthOperation<T>({
    required String operation,
    required Future<T> Function() action,
    Map<String, dynamic>? extraData,
  }) async {
    final transaction = Sentry.startTransaction(
      'auth.$operation',
      opTypeAuth,
      bindToScope: true,
    );

    final span = transaction.startChild(
      'auth.$operation',
      description: 'Firebase Auth: $operation',
    );

    span.setData('auth.provider', 'firebase');
    span.setData('auth.operation', operation);
    if (extraData != null) {
      extraData.forEach((key, value) {
        span.setData(key, value);
      });
    }

    try {
      final result = await action();
      span.status = const SpanStatus.ok();
      return result;
    } catch (error, stackTrace) {
      span.status = const SpanStatus.internalError();
      span.throwable = error;

      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Auth operation failed: $operation',
        category: 'auth',
        level: SentryLevel.error,
        data: {
          'operation': operation,
          'error': error.toString(),
        },
      ));

      // Capture exception in Sentry before re-throwing
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation_type': 'auth',
          'operation': operation,
        }),
      );

      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await span.finish();
      await transaction.finish();
    }
  }

  /// Traces a Firebase Storage operation
  ///
  /// [operation] - Name of the storage operation (e.g., 'upload', 'download', 'delete')
  /// [storagePath] - The storage path being accessed
  /// [action] - The async function to execute
  /// [extraData] - Additional data like file size, content type
  static Future<T> traceStorageOperation<T>({
    required String operation,
    required String storagePath,
    required Future<T> Function() action,
    Map<String, dynamic>? extraData,
  }) async {
    final transaction = Sentry.startTransaction(
      'storage.$operation',
      opTypeStorage,
      bindToScope: true,
    );

    final span = transaction.startChild(
      'storage.$operation',
      description: storagePath,
    );

    span.setData('storage.provider', 'firebase');
    span.setData('storage.operation', operation);
    span.setData('storage.path', storagePath);
    if (extraData != null) {
      extraData.forEach((key, value) {
        span.setData(key, value);
      });
    }

    try {
      final result = await action();
      span.status = const SpanStatus.ok();
      return result;
    } catch (error, stackTrace) {
      span.status = const SpanStatus.internalError();
      span.throwable = error;

      Sentry.addBreadcrumb(Breadcrumb(
        message: 'Storage operation failed: $operation',
        category: 'storage',
        level: SentryLevel.error,
        data: {
          'operation': operation,
          'path': storagePath,
          'error': error.toString(),
        },
      ));

      // Capture exception in Sentry before re-throwing
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation_type': 'storage',
          'operation': operation,
          'storage_path': storagePath,
        }),
      );

      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await span.finish();
      await transaction.finish();
    }
  }

  /// Traces an FCM/Push notification operation
  ///
  /// [operation] - Name of the FCM operation (e.g., 'registerToken', 'subscribe')
  /// [action] - The async function to execute
  /// [extraData] - Additional data to attach to the span
  static Future<T> traceFcmOperation<T>({
    required String operation,
    required Future<T> Function() action,
    Map<String, dynamic>? extraData,
  }) async {
    final transaction = Sentry.startTransaction(
      'fcm.$operation',
      opTypeFcm,
      bindToScope: true,
    );

    final span = transaction.startChild(
      'fcm.$operation',
      description: 'FCM: $operation',
    );

    span.setData('messaging.system', 'fcm');
    span.setData('messaging.operation', operation);
    if (extraData != null) {
      extraData.forEach((key, value) {
        span.setData(key, value);
      });
    }

    try {
      final result = await action();
      span.status = const SpanStatus.ok();
      return result;
    } catch (error, stackTrace) {
      span.status = const SpanStatus.internalError();
      span.throwable = error;

      Sentry.addBreadcrumb(Breadcrumb(
        message: 'FCM operation failed: $operation',
        category: 'fcm',
        level: SentryLevel.error,
        data: {
          'operation': operation,
          'error': error.toString(),
        },
      ));

      // Capture exception in Sentry before re-throwing
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation_type': 'fcm',
          'operation': operation,
        }),
      );

      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await span.finish();
      await transaction.finish();
    }
  }

  /// Creates a child span within an existing transaction
  ///
  /// Useful for tracking sub-operations within a larger traced operation.
  ///
  /// [operation] - Operation type
  /// [description] - Human-readable description
  /// [action] - The async function to execute
  static Future<T> traceChildSpan<T>({
    required String operation,
    required String description,
    required Future<T> Function() action,
    Map<String, dynamic>? data,
  }) async {
    final span = Sentry.getSpan()?.startChild(
      operation,
      description: description,
    );

    if (span == null) {
      // No parent span, just execute the action
      return await action();
    }

    if (data != null) {
      data.forEach((key, value) {
        span.setData(key, value);
      });
    }

    try {
      final result = await action();
      span.status = const SpanStatus.ok();
      return result;
    } catch (error, stackTrace) {
      span.status = const SpanStatus.internalError();
      span.throwable = error;

      // Capture exception in Sentry before re-throwing
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'operation_type': 'child_span',
          'operation': operation,
          'description': description,
        }),
      );

      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      await span.finish();
    }
  }

  /// Records a metric for the current span
  ///
  /// Useful for recording custom metrics like document count, file size, etc.
  static void recordMetric(String key, dynamic value) {
    final span = Sentry.getSpan();
    span?.setData(key, value);
  }

  /// Adds a breadcrumb for tracking user journey
  ///
  /// [message] - Description of the action
  /// [category] - Category (e.g., 'navigation', 'firebase', 'user.action')
  /// [data] - Additional context data
  static void addBreadcrumb({
    required String message,
    required String category,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      category: category,
      level: level,
      data: data,
      timestamp: DateTime.now(),
    ));
  }
}
