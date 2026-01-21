I'll start by exploring the codebase to understand the existing structure, particularly around Firebase services and any existing Sentry integration.

🔧 Tool: Task
Input: {
  "description": "Explore Firebase and Sentry setup",
  "prompt": "Explore the codebase to understand:\n1. How Firebase services (Firestore, Auth, Storage) are currently implemented and used\n2. Any existing Sentry integration or configuration\n3. The service layer patterns used in the project\n4. How dependency injection is set up\n\nFocus on files in lib/core/ and any Firebase-related services. Be thorough - check for services, repositories, and how they interact with Firebase.",
  "subagent_type": "Explore"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\core\" -type f -name \"*.dart\" | head -30",
  "description": "List Dart files in core directory"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\" -type f -name \"*firebase*\" -o -name \"*sentry*\" | head -20",
  "description": "Find Firebase and Sentry related files"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\firebase\\firebase_config.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\config\\app_secrets.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\register_module.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\errors\\exceptions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\errors\\error_handler.dart"
}

🔧 Tool: Grep
Input: {
  "pattern": "sentry|Sentry",
  "type": "dart",
  "output_mode": "files_with_matches"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\features\" -type f -name \"*repository*\" | head -10",
  "description": "Find repository files in features"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\notification_service.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\" -type f -name \"main.dart\" -o -name \"app.dart\"",
  "description": "Find main app files"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\auth\\data\\repositories\\auth_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\auth\\domain\\repositories\\auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\core\\services\" -type f -name \"*.dart\" | xargs wc -l | sort -n | tail -15",
  "description": "List core service files by line count"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.config.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.config.dart",
  "offset": 100,
  "limit": 80
}

🔧 Tool: Grep
Input: {
  "pattern": "class.*Provider|final.*Provider|Stream.*FirebaseFirestore|FirebaseFirestore.*Stream",
  "type": "dart",
  "path": "C:\\dev\\burgerrats\\lib\\core",
  "head_limit": 20
}

🔧 Tool: Bash
Input: {
  "command": "ls -la \"C:\\dev\\burgerrats\\lib\\core\\state\\providers\\\" 2>/dev/null | head -20",
  "description": "List state providers directory"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\auth_state_provider.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\core\" -type f -name \"*.dart\" | xargs grep -l \"provider\" | head -10",
  "description": "Find files with provider pattern"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\errors\\error_boundary.dart"
}

🔧 Tool: Grep
Input: {
  "pattern": "TODO.*analytics|TODO.*crash|TODO.*sentry|Crashlytics",
  "type": "dart",
  "head_limit": 10
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\" -name \"*.dart\" -path \"*/test/*\" -prune -o -type f -name \"*test*\" -print | head -5",
  "description": "Find test files to understand testing patterns"
}
Now I have a comprehensive understanding of the codebase. Let me check if there's an existing Sentry service in the feature folders and examine the current main.dart initialization flow:

🔧 Tool: Glob
Input: {
  "pattern": "**/*sentry*"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart"
}
There's already a SentryService. Let me read it to understand what's already implemented:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\sentry_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing Firebase services and identify instrumentation points",
      "status": "completed",
      "activeForm": "Analyzing existing Firebase services"
    },
    {
      "content": "Create Sentry transaction/span wrapper service for Firebase operations",
      "status": "in_progress",
      "activeForm": "Creating Sentry transaction/span wrapper service"
    },
    {
      "content": "Instrument FirebaseAuthService with Sentry spans",
      "status": "pending",
      "activeForm": "Instrumenting FirebaseAuthService"
    },
    {
      "content": "Instrument FirebaseStorageService with Sentry spans",
      "status": "pending",
      "activeForm": "Instrumenting FirebaseStorageService"
    },
    {
      "content": "Instrument Firestore repositories with Sentry spans",
      "status": "pending",
      "activeForm": "Instrumenting Firestore repositories"
    },
    {
      "content": "Run code generation and verify build",
      "status": "pending",
      "activeForm": "Running code generation and verifying build"
    }
  ]
}
Let me also read the FirebaseStorageService and a sample repository to understand the patterns:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart"
}
Now I understand the codebase structure well. I need to create a performance monitoring service that wraps Firebase operations with Sentry Transactions and Spans. Let me check the context limit and plan the implementation:

The remaining context should be sufficient. Let me implement the Firebase tracing instrumentation with Sentry. I'll create:

1. A `SentryPerformanceWrapper` utility class that provides easy-to-use methods for creating transactions and spans
2. Instrument the services by adding tracing to critical operations

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\sentry_performance_wrapper.dart",
  "content": "import 'dart:async';\n\nimport 'package:sentry_flutter/sentry_flutter.dart';\n\n/// Wrapper class for Sentry performance monitoring\n///\n/// Provides utility methods to instrument Firebase operations with\n/// Sentry Transactions and Spans for detailed performance tracking.\n///\n/// Usage:\n/// ```dart\n/// // Wrap a Firestore operation\n/// final result = await SentryPerformanceWrapper.traceFirestoreOperation(\n///   operation: 'createLeague',\n///   collection: 'leagues',\n///   action: () => firestore.collection('leagues').doc().set(data),\n///   extraData: {'userId': userId},\n/// );\n///\n/// // Wrap an Auth operation\n/// final user = await SentryPerformanceWrapper.traceAuthOperation(\n///   operation: 'signInWithEmail',\n///   action: () => auth.signInWithEmailAndPassword(email: email, password: password),\n/// );\n///\n/// // Wrap a Storage operation\n/// final url = await SentryPerformanceWrapper.traceStorageOperation(\n///   operation: 'uploadCheckInPhoto',\n///   storagePath: 'check-ins/user123/photo.jpg',\n///   action: () => storage.ref(path).putFile(file),\n///   extraData: {'fileSize': fileSize},\n/// );\n/// ```\nclass SentryPerformanceWrapper {\n  /// Operation types for categorization\n  static const String opTypeFirestore = 'db.firestore';\n  static const String opTypeAuth = 'auth.firebase';\n  static const String opTypeStorage = 'storage.firebase';\n  static const String opTypeFcm = 'messaging.fcm';\n\n  /// Traces a Firestore operation with Sentry performance monitoring\n  ///\n  /// Creates a transaction for the operation with relevant metadata.\n  ///\n  /// [operation] - Name of the operation (e.g., 'createLeague', 'getById')\n  /// [collection] - Firestore collection name\n  /// [documentId] - Optional document ID if applicable\n  /// [action] - The async function to execute\n  /// [extraData] - Additional data to attach to the span\n  ///\n  /// Returns the result of [action]\n  /// Throws any exception from [action] after recording it in Sentry\n  static Future<T> traceFirestoreOperation<T>({\n    required String operation,\n    required String collection,\n    String? documentId,\n    required Future<T> Function() action,\n    Map<String, dynamic>? extraData,\n  }) async {\n    final transaction = Sentry.startTransaction(\n      'firestore.$operation',\n      opTypeFirestore,\n      bindToScope: true,\n    );\n\n    final span = transaction.startChild(\n      'firestore.$operation',\n      description: documentId != null\n          ? '$collection/$documentId'\n          : collection,\n    );\n\n    // Set span data\n    span.setData('db.system', 'firestore');\n    span.setData('db.collection', collection);\n    if (documentId != null) {\n      span.setData('db.document_id', documentId);\n    }\n    if (extraData != null) {\n      extraData.forEach((key, value) {\n        span.setData(key, value);\n      });\n    }\n\n    try {\n      final result = await action();\n      span.status = const SpanStatus.ok();\n      return result;\n    } catch (error, stackTrace) {\n      span.status = const SpanStatus.internalError();\n      span.throwable = error;\n\n      // Add error breadcrumb\n      Sentry.addBreadcrumb(Breadcrumb(\n        message: 'Firestore operation failed: $operation',\n        category: 'firestore',\n        level: SentryLevel.error,\n        data: {\n          'operation': operation,\n          'collection': collection,\n          if (documentId != null) 'documentId': documentId,\n          'error': error.toString(),\n        },\n      ));\n\n      // Re-throw the error\n      Error.throwWithStackTrace(error, stackTrace);\n    } finally {\n      await span.finish();\n      await transaction.finish();\n    }\n  }\n\n  /// Traces a Firestore query operation\n  ///\n  /// Similar to [traceFirestoreOperation] but includes query details.\n  ///\n  /// [operation] - Name of the query operation\n  /// [collection] - Firestore collection name\n  /// [queryDescription] - Human-readable description of the query\n  /// [action] - The async function to execute\n  /// [extraData] - Additional data to attach to the span\n  static Future<T> traceFirestoreQuery<T>({\n    required String operation,\n    required String collection,\n    String? queryDescription,\n    required Future<T> Function() action,\n    Map<String, dynamic>? extraData,\n  }) async {\n    final transaction = Sentry.startTransaction(\n      'firestore.query.$operation',\n      opTypeFirestore,\n      bindToScope: true,\n    );\n\n    final span = transaction.startChild(\n      'firestore.query',\n      description: queryDescription ?? 'Query on $collection',\n    );\n\n    span.setData('db.system', 'firestore');\n    span.setData('db.collection', collection);\n    span.setData('db.operation', 'query');\n    if (extraData != null) {\n      extraData.forEach((key, value) {\n        span.setData(key, value);\n      });\n    }\n\n    try {\n      final result = await action();\n      span.status = const SpanStatus.ok();\n      return result;\n    } catch (error, stackTrace) {\n      span.status = const SpanStatus.internalError();\n      span.throwable = error;\n      Error.throwWithStackTrace(error, stackTrace);\n    } finally {\n      await span.finish();\n      await transaction.finish();\n    }\n  }\n\n  /// Traces a Firebase Auth operation\n  ///\n  /// [operation] - Name of the auth operation (e.g., 'signIn', 'signUp', 'signOut')\n  /// [action] - The async function to execute\n  /// [extraData] - Additional data to attach to the span (avoid PII)\n  static Future<T> traceAuthOperation<T>({\n    required String operation,\n    required Future<T> Function() action,\n    Map<String, dynamic>? extraData,\n  }) async {\n    final transaction = Sentry.startTransaction(\n      'auth.$operation',\n      opTypeAuth,\n      bindToScope: true,\n    );\n\n    final span = transaction.startChild(\n      'auth.$operation',\n      description: 'Firebase Auth: $operation',\n    );\n\n    span.setData('auth.provider', 'firebase');\n    span.setData('auth.operation', operation);\n    if (extraData != null) {\n      extraData.forEach((key, value) {\n        span.setData(key, value);\n      });\n    }\n\n    try {\n      final result = await action();\n      span.status = const SpanStatus.ok();\n      return result;\n    } catch (error, stackTrace) {\n      span.status = const SpanStatus.internalError();\n      span.throwable = error;\n\n      Sentry.addBreadcrumb(Breadcrumb(\n        message: 'Auth operation failed: $operation',\n        category: 'auth',\n        level: SentryLevel.error,\n        data: {\n          'operation': operation,\n          'error': error.toString(),\n        },\n      ));\n\n      Error.throwWithStackTrace(error, stackTrace);\n    } finally {\n      await span.finish();\n      await transaction.finish();\n    }\n  }\n\n  /// Traces a Firebase Storage operation\n  ///\n  /// [operation] - Name of the storage operation (e.g., 'upload', 'download', 'delete')\n  /// [storagePath] - The storage path being accessed\n  /// [action] - The async function to execute\n  /// [extraData] - Additional data like file size, content type\n  static Future<T> traceStorageOperation<T>({\n    required String operation,\n    required String storagePath,\n    required Future<T> Function() action,\n    Map<String, dynamic>? extraData,\n  }) async {\n    final transaction = Sentry.startTransaction(\n      'storage.$operation',\n      opTypeStorage,\n      bindToScope: true,\n    );\n\n    final span = transaction.startChild(\n      'storage.$operation',\n      description: storagePath,\n    );\n\n    span.setData('storage.provider', 'firebase');\n    span.setData('storage.operation', operation);\n    span.setData('storage.path', storagePath);\n    if (extraData != null) {\n      extraData.forEach((key, value) {\n        span.setData(key, value);\n      });\n    }\n\n    try {\n      final result = await action();\n      span.status = const SpanStatus.ok();\n      return result;\n    } catch (error, stackTrace) {\n      span.status = const SpanStatus.internalError();\n      span.throwable = error;\n\n      Sentry.addBreadcrumb(Breadcrumb(\n        message: 'Storage operation failed: $operation',\n        category: 'storage',\n        level: SentryLevel.error,\n        data: {\n          'operation': operation,\n          'path': storagePath,\n          'error': error.toString(),\n        },\n      ));\n\n      Error.throwWithStackTrace(error, stackTrace);\n    } finally {\n      await span.finish();\n      await transaction.finish();\n    }\n  }\n\n  /// Traces an FCM/Push notification operation\n  ///\n  /// [operation] - Name of the FCM operation (e.g., 'registerToken', 'subscribe')\n  /// [action] - The async function to execute\n  /// [extraData] - Additional data to attach to the span\n  static Future<T> traceFcmOperation<T>({\n    required String operation,\n    required Future<T> Function() action,\n    Map<String, dynamic>? extraData,\n  }) async {\n    final transaction = Sentry.startTransaction(\n      'fcm.$operation',\n      opTypeFcm,\n      bindToScope: true,\n    );\n\n    final span = transaction.startChild(\n      'fcm.$operation',\n      description: 'FCM: $operation',\n    );\n\n    span.setData('messaging.system', 'fcm');\n    span.setData('messaging.operation', operation);\n    if (extraData != null) {\n      extraData.forEach((key, value) {\n        span.setData(key, value);\n      });\n    }\n\n    try {\n      final result = await action();\n      span.status = const SpanStatus.ok();\n      return result;\n    } catch (error, stackTrace) {\n      span.status = const SpanStatus.internalError();\n      span.throwable = error;\n\n      Sentry.addBreadcrumb(Breadcrumb(\n        message: 'FCM operation failed: $operation',\n        category: 'fcm',\n        level: SentryLevel.error,\n        data: {\n          'operation': operation,\n          'error': error.toString(),\n        },\n      ));\n\n      Error.throwWithStackTrace(error, stackTrace);\n    } finally {\n      await span.finish();\n      await transaction.finish();\n    }\n  }\n\n  /// Creates a child span within an existing transaction\n  ///\n  /// Useful for tracking sub-operations within a larger traced operation.\n  ///\n  /// [operation] - Operation type\n  /// [description] - Human-readable description\n  /// [action] - The async function to execute\n  static Future<T> traceChildSpan<T>({\n    required String operation,\n    required String description,\n    required Future<T> Function() action,\n    Map<String, dynamic>? data,\n  }) async {\n    final span = Sentry.getSpan()?.startChild(\n      operation,\n      description: description,\n    );\n\n    if (span == null) {\n      // No parent span, just execute the action\n      return await action();\n    }\n\n    if (data != null) {\n      data.forEach((key, value) {\n        span.setData(key, value);\n      });\n    }\n\n    try {\n      final result = await action();\n      span.status = const SpanStatus.ok();\n      return result;\n    } catch (error, stackTrace) {\n      span.status = const SpanStatus.internalError();\n      span.throwable = error;\n      Error.throwWithStackTrace(error, stackTrace);\n    } finally {\n      await span.finish();\n    }\n  }\n\n  /// Records a metric for the current span\n  ///\n  /// Useful for recording custom metrics like document count, file size, etc.\n  static void recordMetric(String key, dynamic value) {\n    final span = Sentry.getSpan();\n    span?.setData(key, value);\n  }\n\n  /// Adds a breadcrumb for tracking user journey\n  ///\n  /// [message] - Description of the action\n  /// [category] - Category (e.g., 'navigation', 'firebase', 'user.action')\n  /// [data] - Additional context data\n  static void addBreadcrumb({\n    required String message,\n    required String category,\n    Map<String, dynamic>? data,\n    SentryLevel level = SentryLevel.info,\n  }) {\n    Sentry.addBreadcrumb(Breadcrumb(\n      message: message,\n      category: category,\n      level: level,\n      data: data,\n      timestamp: DateTime.now(),\n    ));\n  }\n}\n"
}
Now let's update the `FirebaseAuthService` to add Sentry tracing:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing Firebase services and identify instrumentation points",
      "status": "completed",
      "activeForm": "Analyzing existing Firebase services"
    },
    {
      "content": "Create Sentry transaction/span wrapper service for Firebase operations",
      "status": "completed",
      "activeForm": "Creating Sentry transaction/span wrapper service"
    },
    {
      "content": "Instrument FirebaseAuthService with Sentry spans",
      "status": "in_progress",
      "activeForm": "Instrumenting FirebaseAuthService"
    },
    {
      "content": "Instrument FirebaseStorageService with Sentry spans",
      "status": "pending",
      "activeForm": "Instrumenting FirebaseStorageService"
    },
    {
      "content": "Instrument Firestore repositories with Sentry spans",
      "status": "pending",
      "activeForm": "Instrumenting Firestore repositories"
    },
    {
      "content": "Run code generation and verify build",
      "status": "pending",
      "activeForm": "Running code generation and verifying build"
    }
  ]
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "import 'dart:async';\n\nimport 'package:firebase_auth/firebase_auth.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../errors/error_handler.dart';\nimport '../errors/error_messages.dart';\nimport '../errors/exceptions.dart';",
  "new_string": "import 'dart:async';\n\nimport 'package:firebase_auth/firebase_auth.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../errors/error_handler.dart';\nimport '../errors/error_messages.dart';\nimport '../errors/exceptions.dart';\nimport 'sentry_performance_wrapper.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Signs in a user with email and password\n  ///\n  /// Returns [AuthResult] with the user on success, or error details on failure.\n  Future<AuthResult> signInWithEmailAndPassword({\n    required String email,\n    required String password,\n  }) async {\n    try {\n      final credential = await _firebaseAuth.signInWithEmailAndPassword(\n        email: email.trim(),\n        password: password,\n      );\n\n      if (credential.user == null) {\n        return AuthResult.failure(\n          message: ErrorMessages.unknownError,\n          code: 'no-user-returned',\n        );\n      }\n\n      return AuthResult.success(credential.user!);\n    } on FirebaseAuthException catch (e) {\n      return AuthResult.failure(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      return AuthResult.failure(\n        message: exception.message,\n        code: exception.code,\n      );\n    }\n  }",
  "new_string": "  /// Signs in a user with email and password\n  ///\n  /// Returns [AuthResult] with the user on success, or error details on failure.\n  Future<AuthResult> signInWithEmailAndPassword({\n    required String email,\n    required String password,\n  }) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'signInWithEmailAndPassword',\n      action: () async {\n        try {\n          final credential = await _firebaseAuth.signInWithEmailAndPassword(\n            email: email.trim(),\n            password: password,\n          );\n\n          if (credential.user == null) {\n            return AuthResult.failure(\n              message: ErrorMessages.unknownError,\n              code: 'no-user-returned',\n            );\n          }\n\n          return AuthResult.success(credential.user!);\n        } on FirebaseAuthException catch (e) {\n          return AuthResult.failure(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          return AuthResult.failure(\n            message: exception.message,\n            code: exception.code,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Creates a new user with email and password\n  ///\n  /// Returns [AuthResult] with the new user on success, or error details on failure.\n  Future<AuthResult> createUserWithEmailAndPassword({\n    required String email,\n    required String password,\n  }) async {\n    try {\n      final credential = await _firebaseAuth.createUserWithEmailAndPassword(\n        email: email.trim(),\n        password: password,\n      );\n\n      if (credential.user == null) {\n        return AuthResult.failure(\n          message: ErrorMessages.unknownError,\n          code: 'no-user-returned',\n        );\n      }\n\n      return AuthResult.success(credential.user!);\n    } on FirebaseAuthException catch (e) {\n      return AuthResult.failure(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      return AuthResult.failure(\n        message: exception.message,\n        code: exception.code,\n      );\n    }\n  }",
  "new_string": "  /// Creates a new user with email and password\n  ///\n  /// Returns [AuthResult] with the new user on success, or error details on failure.\n  Future<AuthResult> createUserWithEmailAndPassword({\n    required String email,\n    required String password,\n  }) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'createUserWithEmailAndPassword',\n      action: () async {\n        try {\n          final credential = await _firebaseAuth.createUserWithEmailAndPassword(\n            email: email.trim(),\n            password: password,\n          );\n\n          if (credential.user == null) {\n            return AuthResult.failure(\n              message: ErrorMessages.unknownError,\n              code: 'no-user-returned',\n            );\n          }\n\n          return AuthResult.success(credential.user!);\n        } on FirebaseAuthException catch (e) {\n          return AuthResult.failure(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          return AuthResult.failure(\n            message: exception.message,\n            code: exception.code,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Signs out the current user\n  ///\n  /// Throws [AuthException] if sign out fails.\n  Future<void> signOut() async {\n    try {\n      await _firebaseAuth.signOut();\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao sair da conta. Por favor, tente novamente.',\n        code: 'sign-out-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Signs out the current user\n  ///\n  /// Throws [AuthException] if sign out fails.\n  Future<void> signOut() async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'signOut',\n      action: () async {\n        try {\n          await _firebaseAuth.signOut();\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao sair da conta. Por favor, tente novamente.',\n            code: 'sign-out-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Sends a password reset email to the specified address\n  ///\n  /// Returns true on success, throws [AuthException] on failure.\n  Future<bool> sendPasswordResetEmail({required String email}) async {\n    try {\n      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());\n      return true;\n    } on FirebaseAuthException catch (e) {\n      throw AuthException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw AuthException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Sends a password reset email to the specified address\n  ///\n  /// Returns true on success, throws [AuthException] on failure.\n  Future<bool> sendPasswordResetEmail({required String email}) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'sendPasswordResetEmail',\n      action: () async {\n        try {\n          await _firebaseAuth.sendPasswordResetEmail(email: email.trim());\n          return true;\n        } on FirebaseAuthException catch (e) {\n          throw AuthException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          throw AuthException(\n            message: exception.message,\n            code: exception.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Sends an email verification to the current user\n  ///\n  /// Returns true on success, throws [AuthException] if no user is signed in\n  /// or if the operation fails.\n  Future<bool> sendEmailVerification() async {\n    final user = currentUser;\n    if (user == null) {\n      throw const AuthException(\n        message: 'Nenhum usuario logado para verificar o e-mail.',\n        code: 'no-current-user',\n      );\n    }\n\n    try {\n      await user.sendEmailVerification();\n      return true;\n    } on FirebaseAuthException catch (e) {\n      throw AuthException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao enviar e-mail de verificacao. Tente novamente.',\n        code: 'email-verification-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Sends an email verification to the current user\n  ///\n  /// Returns true on success, throws [AuthException] if no user is signed in\n  /// or if the operation fails.\n  Future<bool> sendEmailVerification() async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'sendEmailVerification',\n      action: () async {\n        final user = currentUser;\n        if (user == null) {\n          throw const AuthException(\n            message: 'Nenhum usuario logado para verificar o e-mail.',\n            code: 'no-current-user',\n          );\n        }\n\n        try {\n          await user.sendEmailVerification();\n          return true;\n        } on FirebaseAuthException catch (e) {\n          throw AuthException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao enviar e-mail de verificacao. Tente novamente.',\n            code: 'email-verification-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Reloads the current user's data from Firebase\n  ///\n  /// Useful to check if email has been verified after sending verification.\n  Future<void> reloadUser() async {\n    final user = currentUser;\n    if (user == null) return;\n\n    try {\n      await user.reload();\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao atualizar dados do usuario.',\n        code: 'reload-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Reloads the current user's data from Firebase\n  ///\n  /// Useful to check if email has been verified after sending verification.\n  Future<void> reloadUser() async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'reloadUser',\n      action: () async {\n        final user = currentUser;\n        if (user == null) return;\n\n        try {\n          await user.reload();\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao atualizar dados do usuario.',\n            code: 'reload-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Updates the current user's display name\n  ///\n  /// Throws [AuthException] if no user is signed in or update fails.\n  Future<void> updateDisplayName(String displayName) async {\n    final user = currentUser;\n    if (user == null) {\n      throw const AuthException(\n        message: 'Nenhum usuario logado.',\n        code: 'no-current-user',\n      );\n    }\n\n    try {\n      await user.updateDisplayName(displayName);\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao atualizar nome de exibicao.',\n        code: 'update-display-name-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Updates the current user's display name\n  ///\n  /// Throws [AuthException] if no user is signed in or update fails.\n  Future<void> updateDisplayName(String displayName) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'updateDisplayName',\n      action: () async {\n        final user = currentUser;\n        if (user == null) {\n          throw const AuthException(\n            message: 'Nenhum usuario logado.',\n            code: 'no-current-user',\n          );\n        }\n\n        try {\n          await user.updateDisplayName(displayName);\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao atualizar nome de exibicao.',\n            code: 'update-display-name-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Updates the current user's photo URL\n  ///\n  /// Throws [AuthException] if no user is signed in or update fails.\n  Future<void> updatePhotoURL(String photoURL) async {\n    final user = currentUser;\n    if (user == null) {\n      throw const AuthException(\n        message: 'Nenhum usuario logado.',\n        code: 'no-current-user',\n      );\n    }\n\n    try {\n      await user.updatePhotoURL(photoURL);\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao atualizar foto de perfil.',\n        code: 'update-photo-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Updates the current user's photo URL\n  ///\n  /// Throws [AuthException] if no user is signed in or update fails.\n  Future<void> updatePhotoURL(String photoURL) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'updatePhotoURL',\n      action: () async {\n        final user = currentUser;\n        if (user == null) {\n          throw const AuthException(\n            message: 'Nenhum usuario logado.',\n            code: 'no-current-user',\n          );\n        }\n\n        try {\n          await user.updatePhotoURL(photoURL);\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao atualizar foto de perfil.',\n            code: 'update-photo-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Deletes the current user's account\n  ///\n  /// WARNING: This action is irreversible. The user will need to re-authenticate\n  /// if they haven't signed in recently.\n  ///\n  /// Throws [AuthException] if no user is signed in or deletion fails.\n  Future<void> deleteAccount() async {\n    final user = currentUser;\n    if (user == null) {\n      throw const AuthException(\n        message: 'Nenhum usuario logado.',\n        code: 'no-current-user',\n      );\n    }\n\n    try {\n      await user.delete();\n    } on FirebaseAuthException catch (e) {\n      throw AuthException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao excluir conta. Tente fazer login novamente.',\n        code: 'delete-account-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Deletes the current user's account\n  ///\n  /// WARNING: This action is irreversible. The user will need to re-authenticate\n  /// if they haven't signed in recently.\n  ///\n  /// Throws [AuthException] if no user is signed in or deletion fails.\n  Future<void> deleteAccount() async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'deleteAccount',\n      action: () async {\n        final user = currentUser;\n        if (user == null) {\n          throw const AuthException(\n            message: 'Nenhum usuario logado.',\n            code: 'no-current-user',\n          );\n        }\n\n        try {\n          await user.delete();\n        } on FirebaseAuthException catch (e) {\n          throw AuthException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao excluir conta. Tente fazer login novamente.',\n            code: 'delete-account-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Re-authenticates the user with email and password\n  ///\n  /// This is required before sensitive operations like account deletion\n  /// or password change if the user hasn't signed in recently.\n  Future<AuthResult> reauthenticateWithEmailAndPassword({\n    required String email,\n    required String password,\n  }) async {\n    final user = currentUser;\n    if (user == null) {\n      return AuthResult.failure(\n        message: 'Nenhum usuario logado.',\n        code: 'no-current-user',\n      );\n    }\n\n    try {\n      final credential = EmailAuthProvider.credential(\n        email: email.trim(),\n        password: password,\n      );\n\n      await user.reauthenticateWithCredential(credential);\n      return AuthResult.success(user);\n    } on FirebaseAuthException catch (e) {\n      return AuthResult.failure(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      return AuthResult.failure(\n        message: exception.message,\n        code: exception.code,\n      );\n    }\n  }",
  "new_string": "  /// Re-authenticates the user with email and password\n  ///\n  /// This is required before sensitive operations like account deletion\n  /// or password change if the user hasn't signed in recently.\n  Future<AuthResult> reauthenticateWithEmailAndPassword({\n    required String email,\n    required String password,\n  }) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'reauthenticateWithEmailAndPassword',\n      action: () async {\n        final user = currentUser;\n        if (user == null) {\n          return AuthResult.failure(\n            message: 'Nenhum usuario logado.',\n            code: 'no-current-user',\n          );\n        }\n\n        try {\n          final credential = EmailAuthProvider.credential(\n            email: email.trim(),\n            password: password,\n          );\n\n          await user.reauthenticateWithCredential(credential);\n          return AuthResult.success(user);\n        } on FirebaseAuthException catch (e) {\n          return AuthResult.failure(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          return AuthResult.failure(\n            message: exception.message,\n            code: exception.code,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_auth_service.dart",
  "old_string": "  /// Updates the current user's password\n  ///\n  /// Requires recent authentication. Call [reauthenticateWithEmailAndPassword]\n  /// first if needed.\n  ///\n  /// Throws [AuthException] on failure.\n  Future<void> updatePassword(String newPassword) async {\n    final user = currentUser;\n    if (user == null) {\n      throw const AuthException(\n        message: 'Nenhum usuario logado.',\n        code: 'no-current-user',\n      );\n    }\n\n    try {\n      await user.updatePassword(newPassword);\n    } on FirebaseAuthException catch (e) {\n      throw AuthException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      throw AuthException(\n        message: 'Erro ao atualizar senha.',\n        code: 'update-password-failed',\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n}",
  "new_string": "  /// Updates the current user's password\n  ///\n  /// Requires recent authentication. Call [reauthenticateWithEmailAndPassword]\n  /// first if needed.\n  ///\n  /// Throws [AuthException] on failure.\n  Future<void> updatePassword(String newPassword) async {\n    return SentryPerformanceWrapper.traceAuthOperation(\n      operation: 'updatePassword',\n      action: () async {\n        final user = currentUser;\n        if (user == null) {\n          throw const AuthException(\n            message: 'Nenhum usuario logado.',\n            code: 'no-current-user',\n          );\n        }\n\n        try {\n          await user.updatePassword(newPassword);\n        } on FirebaseAuthException catch (e) {\n          throw AuthException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          throw AuthException(\n            message: 'Erro ao atualizar senha.',\n            code: 'update-password-failed',\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }\n}"
}
Now let's update the todos and instrument the FirebaseStorageService:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing Firebase services and identify instrumentation points",
      "status": "completed",
      "activeForm": "Analyzing existing Firebase services"
    },
    {
      "content": "Create Sentry transaction/span wrapper service for Firebase operations",
      "status": "completed",
      "activeForm": "Creating Sentry transaction/span wrapper service"
    },
    {
      "content": "Instrument FirebaseAuthService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseAuthService"
    },
    {
      "content": "Instrument FirebaseStorageService with Sentry spans",
      "status": "in_progress",
      "activeForm": "Instrumenting FirebaseStorageService"
    },
    {
      "content": "Instrument Firestore repositories with Sentry spans",
      "status": "pending",
      "activeForm": "Instrumenting Firestore repositories"
    },
    {
      "content": "Run code generation and verify build",
      "status": "pending",
      "activeForm": "Running code generation and verifying build"
    }
  ]
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "import 'dart:io';\nimport 'dart:typed_data';\n\nimport 'package:firebase_storage/firebase_storage.dart';\nimport 'package:injectable/injectable.dart';\nimport 'package:path/path.dart' as path;\n\nimport '../errors/error_handler.dart';\nimport '../errors/error_messages.dart';\nimport '../errors/exceptions.dart';",
  "new_string": "import 'dart:io';\nimport 'dart:typed_data';\n\nimport 'package:firebase_storage/firebase_storage.dart';\nimport 'package:injectable/injectable.dart';\nimport 'package:path/path.dart' as path;\n\nimport '../errors/error_handler.dart';\nimport '../errors/error_messages.dart';\nimport '../errors/exceptions.dart';\nimport 'sentry_performance_wrapper.dart';"
}
Now let's instrument the storage service methods. I'll update the key methods:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// Upload a check-in photo organized by user and date\n  ///\n  /// Files are stored in: check-ins/{userId}/{year}/{month}/{day}/{filename}\n  ///\n  /// [userId] - The ID of the user uploading the photo\n  /// [leagueId] - The ID of the league for the check-in\n  /// [file] - The image file to upload\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress (0.0 to 1.0)\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadCheckInPhoto({\n    required String userId,\n    required String leagueId,\n    required File file,\n    UploadOptions options = UploadOptions.checkInPhoto,\n    UploadProgressCallback? onProgress,\n  }) async {\n    // Validate file\n    await _validateFile(file);\n\n    // Generate path organized by user and date\n    final now = DateTime.now();\n    final year = now.year.toString();\n    final month = now.month.toString().padLeft(2, '0');\n    final day = now.day.toString().padLeft(2, '0');\n\n    final fileName = _generateFileName(file.path, options);\n    final storagePath = 'check-ins/$userId/$year/$month/$day/$fileName';\n\n    // Add league ID to metadata\n    final metadata = <String, String>{\n      'userId': userId,\n      'leagueId': leagueId,\n      'uploadedAt': now.toIso8601String(),\n      ...?options.metadata,\n    };\n\n    return _uploadFile(\n      file: file,\n      storagePath: storagePath,\n      options: options.copyWith(metadata: metadata),\n      onProgress: onProgress,\n    );\n  }",
  "new_string": "  /// Upload a check-in photo organized by user and date\n  ///\n  /// Files are stored in: check-ins/{userId}/{year}/{month}/{day}/{filename}\n  ///\n  /// [userId] - The ID of the user uploading the photo\n  /// [leagueId] - The ID of the league for the check-in\n  /// [file] - The image file to upload\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress (0.0 to 1.0)\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadCheckInPhoto({\n    required String userId,\n    required String leagueId,\n    required File file,\n    UploadOptions options = UploadOptions.checkInPhoto,\n    UploadProgressCallback? onProgress,\n  }) async {\n    // Validate file\n    await _validateFile(file);\n\n    // Generate path organized by user and date\n    final now = DateTime.now();\n    final year = now.year.toString();\n    final month = now.month.toString().padLeft(2, '0');\n    final day = now.day.toString().padLeft(2, '0');\n\n    final fileName = _generateFileName(file.path, options);\n    final storagePath = 'check-ins/$userId/$year/$month/$day/$fileName';\n\n    // Add league ID to metadata\n    final metadata = <String, String>{\n      'userId': userId,\n      'leagueId': leagueId,\n      'uploadedAt': now.toIso8601String(),\n      ...?options.metadata,\n    };\n\n    final fileSize = await file.length();\n\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'uploadCheckInPhoto',\n      storagePath: storagePath,\n      action: () => _uploadFile(\n        file: file,\n        storagePath: storagePath,\n        options: options.copyWith(metadata: metadata),\n        onProgress: onProgress,\n      ),\n      extraData: {\n        'userId': userId,\n        'leagueId': leagueId,\n        'fileSize': fileSize,\n        'contentType': _getContentType(file.path),\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// Upload a profile photo\n  ///\n  /// Files are stored in: profile-photos/{userId}/{filename}\n  ///\n  /// [userId] - The ID of the user\n  /// [file] - The image file to upload\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadProfilePhoto({\n    required String userId,\n    required File file,\n    UploadOptions options = UploadOptions.profilePhoto,\n    UploadProgressCallback? onProgress,\n  }) async {\n    await _validateFile(file);\n\n    final fileName = _generateFileName(file.path, options);\n    final storagePath = 'profile-photos/$userId/$fileName';\n\n    final metadata = <String, String>{\n      'userId': userId,\n      'uploadedAt': DateTime.now().toIso8601String(),\n      ...?options.metadata,\n    };\n\n    return _uploadFile(\n      file: file,\n      storagePath: storagePath,\n      options: options.copyWith(metadata: metadata),\n      onProgress: onProgress,\n    );\n  }",
  "new_string": "  /// Upload a profile photo\n  ///\n  /// Files are stored in: profile-photos/{userId}/{filename}\n  ///\n  /// [userId] - The ID of the user\n  /// [file] - The image file to upload\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadProfilePhoto({\n    required String userId,\n    required File file,\n    UploadOptions options = UploadOptions.profilePhoto,\n    UploadProgressCallback? onProgress,\n  }) async {\n    await _validateFile(file);\n\n    final fileName = _generateFileName(file.path, options);\n    final storagePath = 'profile-photos/$userId/$fileName';\n\n    final metadata = <String, String>{\n      'userId': userId,\n      'uploadedAt': DateTime.now().toIso8601String(),\n      ...?options.metadata,\n    };\n\n    final fileSize = await file.length();\n\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'uploadProfilePhoto',\n      storagePath: storagePath,\n      action: () => _uploadFile(\n        file: file,\n        storagePath: storagePath,\n        options: options.copyWith(metadata: metadata),\n        onProgress: onProgress,\n      ),\n      extraData: {\n        'userId': userId,\n        'fileSize': fileSize,\n        'contentType': _getContentType(file.path),\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// Upload a file from bytes\n  ///\n  /// [bytes] - The file bytes to upload\n  /// [storagePath] - The full path in storage\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadBytes({\n    required Uint8List bytes,\n    required String storagePath,\n    UploadOptions options = const UploadOptions(),\n    UploadProgressCallback? onProgress,\n  }) async {\n    // Validate size\n    if (bytes.length > maxFileSizeBytes) {\n      throw const StorageException(\n        message: ErrorMessages.fileTooLarge,\n        code: 'file-too-large',\n      );\n    }\n\n    try {\n      final ref = _storage.ref().child(storagePath);\n\n      // Build metadata\n      final settableMetadata = SettableMetadata(\n        contentType: options.contentType ?? 'application/octet-stream',\n        cacheControl: options.cacheControl,\n        customMetadata: options.metadata,\n      );\n\n      // Start upload\n      final uploadTask = ref.putData(bytes, settableMetadata);\n\n      // Track progress\n      if (onProgress != null) {\n        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {\n          final progress = snapshot.bytesTransferred / snapshot.totalBytes;\n          onProgress(progress);\n        });\n      }\n\n      // Wait for completion\n      await uploadTask;\n\n      // Get download URL\n      final downloadUrl = await ref.getDownloadURL();\n\n      return UploadResult(\n        downloadUrl: downloadUrl,\n        storagePath: storagePath,\n        fileName: path.basename(storagePath),\n        sizeInBytes: bytes.length,\n        contentType: options.contentType,\n        uploadedAt: DateTime.now(),\n        metadata: options.metadata,\n      );\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Upload a file from bytes\n  ///\n  /// [bytes] - The file bytes to upload\n  /// [storagePath] - The full path in storage\n  /// [options] - Upload configuration options\n  /// [onProgress] - Optional callback for upload progress\n  ///\n  /// Returns [UploadResult] with download URL and metadata.\n  /// Throws [StorageException] on failure.\n  Future<UploadResult> uploadBytes({\n    required Uint8List bytes,\n    required String storagePath,\n    UploadOptions options = const UploadOptions(),\n    UploadProgressCallback? onProgress,\n  }) async {\n    // Validate size\n    if (bytes.length > maxFileSizeBytes) {\n      throw const StorageException(\n        message: ErrorMessages.fileTooLarge,\n        code: 'file-too-large',\n      );\n    }\n\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'uploadBytes',\n      storagePath: storagePath,\n      action: () async {\n        try {\n          final ref = _storage.ref().child(storagePath);\n\n          // Build metadata\n          final settableMetadata = SettableMetadata(\n            contentType: options.contentType ?? 'application/octet-stream',\n            cacheControl: options.cacheControl,\n            customMetadata: options.metadata,\n          );\n\n          // Start upload\n          final uploadTask = ref.putData(bytes, settableMetadata);\n\n          // Track progress\n          if (onProgress != null) {\n            uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {\n              final progress = snapshot.bytesTransferred / snapshot.totalBytes;\n              onProgress(progress);\n            });\n          }\n\n          // Wait for completion\n          await uploadTask;\n\n          // Get download URL\n          final downloadUrl = await ref.getDownloadURL();\n\n          return UploadResult(\n            downloadUrl: downloadUrl,\n            storagePath: storagePath,\n            fileName: path.basename(storagePath),\n            sizeInBytes: bytes.length,\n            contentType: options.contentType,\n            uploadedAt: DateTime.now(),\n            metadata: options.metadata,\n          );\n        } on FirebaseException catch (e) {\n          throw StorageException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          throw StorageException(\n            message: exception.message,\n            code: exception.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'fileSize': bytes.length,\n        'contentType': options.contentType ?? 'application/octet-stream',\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// Delete a file from storage\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Throws [StorageException] on failure.\n  Future<void> deleteFile(String storagePath) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      await ref.delete();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Delete a file from storage\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Throws [StorageException] on failure.\n  Future<void> deleteFile(String storagePath) async {\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'deleteFile',\n      storagePath: storagePath,\n      action: () async {\n        try {\n          final ref = _storage.ref().child(storagePath);\n          await ref.delete();\n        } on FirebaseException catch (e) {\n          throw StorageException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          throw StorageException(\n            message: exception.message,\n            code: exception.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// Get a secure download URL for a file\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Returns the download URL string.\n  /// Throws [StorageException] if file not found or on failure.\n  Future<String> getDownloadUrl(String storagePath) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      return await ref.getDownloadURL();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Get a secure download URL for a file\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Returns the download URL string.\n  /// Throws [StorageException] if file not found or on failure.\n  Future<String> getDownloadUrl(String storagePath) async {\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'getDownloadUrl',\n      storagePath: storagePath,\n      action: () async {\n        try {\n          final ref = _storage.ref().child(storagePath);\n          return await ref.getDownloadURL();\n        } on FirebaseException catch (e) {\n          throw StorageException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          throw StorageException(\n            message: exception.message,\n            code: exception.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// Get file metadata\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Returns the file metadata.\n  /// Throws [StorageException] if file not found or on failure.\n  Future<FullMetadata> getFileMetadata(String storagePath) async {\n    try {\n      final ref = _storage.ref().child(storagePath);\n      return await ref.getMetadata();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// Get file metadata\n  ///\n  /// [storagePath] - The full path to the file in storage\n  ///\n  /// Returns the file metadata.\n  /// Throws [StorageException] if file not found or on failure.\n  Future<FullMetadata> getFileMetadata(String storagePath) async {\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'getFileMetadata',\n      storagePath: storagePath,\n      action: () async {\n        try {\n          final ref = _storage.ref().child(storagePath);\n          return await ref.getMetadata();\n        } on FirebaseException catch (e) {\n          throw StorageException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          throw StorageException(\n            message: exception.message,\n            code: exception.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\firebase_storage_service.dart",
  "old_string": "  /// List all check-in photos for a user on a specific date\n  ///\n  /// [userId] - The user ID\n  /// [date] - The date to list photos for\n  ///\n  /// Returns list of storage paths for the photos.\n  Future<List<String>> listCheckInPhotos({\n    required String userId,\n    required DateTime date,\n  }) async {\n    final year = date.year.toString();\n    final month = date.month.toString().padLeft(2, '0');\n    final day = date.day.toString().padLeft(2, '0');\n    final prefix = 'check-ins/$userId/$year/$month/$day/';\n\n    try {\n      final ref = _storage.ref().child(prefix);\n      final result = await ref.listAll();\n      return result.items.map((item) => item.fullPath).toList();\n    } on FirebaseException catch (e) {\n      throw StorageException(\n        message: ErrorMessages.getMessageForCode(e.code),\n        code: e.code,\n        originalError: e,\n      );\n    } catch (e, stackTrace) {\n      final exception = ErrorHandler.handleError(e, stackTrace);\n      throw StorageException(\n        message: exception.message,\n        code: exception.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  /// List all check-in photos for a user on a specific date\n  ///\n  /// [userId] - The user ID\n  /// [date] - The date to list photos for\n  ///\n  /// Returns list of storage paths for the photos.\n  Future<List<String>> listCheckInPhotos({\n    required String userId,\n    required DateTime date,\n  }) async {\n    final year = date.year.toString();\n    final month = date.month.toString().padLeft(2, '0');\n    final day = date.day.toString().padLeft(2, '0');\n    final prefix = 'check-ins/$userId/$year/$month/$day/';\n\n    return SentryPerformanceWrapper.traceStorageOperation(\n      operation: 'listCheckInPhotos',\n      storagePath: prefix,\n      action: () async {\n        try {\n          final ref = _storage.ref().child(prefix);\n          final result = await ref.listAll();\n          return result.items.map((item) => item.fullPath).toList();\n        } on FirebaseException catch (e) {\n          throw StorageException(\n            message: ErrorMessages.getMessageForCode(e.code),\n            code: e.code,\n            originalError: e,\n          );\n        } catch (e, stackTrace) {\n          final exception = ErrorHandler.handleError(e, stackTrace);\n          throw StorageException(\n            message: exception.message,\n            code: exception.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'userId': userId,\n        'date': date.toIso8601String(),\n      },\n    );\n  }"
}
Now let's update the todos and instrument the LeagueRepository:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing Firebase services and identify instrumentation points",
      "status": "completed",
      "activeForm": "Analyzing existing Firebase services"
    },
    {
      "content": "Create Sentry transaction/span wrapper service for Firebase operations",
      "status": "completed",
      "activeForm": "Creating Sentry transaction/span wrapper service"
    },
    {
      "content": "Instrument FirebaseAuthService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseAuthService"
    },
    {
      "content": "Instrument FirebaseStorageService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseStorageService"
    },
    {
      "content": "Instrument Firestore repositories with Sentry spans",
      "status": "in_progress",
      "activeForm": "Instrumenting Firestore repositories"
    },
    {
      "content": "Run code generation and verify build",
      "status": "pending",
      "activeForm": "Running code generation and verifying build"
    }
  ]
}
Now let's instrument the LeagueRepository - the most critical Firestore operations:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "import 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../../../../core/errors/exceptions.dart';\nimport '../../../../core/services/invite_code_generator_service.dart';\nimport '../../../../core/utils/typedefs.dart';\nimport '../../domain/entities/league_entity.dart';\nimport '../../domain/repositories/league_repository.dart';\nimport '../models/league_model.dart';",
  "new_string": "import 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../../../../core/errors/exceptions.dart';\nimport '../../../../core/services/invite_code_generator_service.dart';\nimport '../../../../core/services/sentry_performance_wrapper.dart';\nimport '../../../../core/utils/typedefs.dart';\nimport '../../domain/entities/league_entity.dart';\nimport '../../domain/repositories/league_repository.dart';\nimport '../models/league_model.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<LeagueEntity> createLeague({\n    required String name,\n    String? description,\n    required String createdBy,\n    LeagueSettings? settings,\n  }) async {\n    try {\n      // Generate unique ID\n      final docRef = _leaguesRef.doc();\n\n      // Generate unique invite code with Firestore validation\n      final inviteCodeResult = await _inviteCodeService.generateUniqueCode();\n      final inviteCode = inviteCodeResult.code;\n\n      // Create the league model\n      final league = LeagueModel.newLeague(\n        id: docRef.id,\n        name: name,\n        description: description,\n        createdBy: createdBy,\n        inviteCode: inviteCode,\n        settings: settings,\n      );\n\n      // Save to Firestore\n      await docRef.set(league.toJson());\n\n      return league.toEntity();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to create league: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<LeagueEntity> createLeague({\n    required String name,\n    String? description,\n    required String createdBy,\n    LeagueSettings? settings,\n  }) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'createLeague',\n      collection: _leaguesCollection,\n      action: () async {\n        try {\n          // Generate unique ID\n          final docRef = _leaguesRef.doc();\n\n          // Generate unique invite code with Firestore validation\n          final inviteCodeResult = await _inviteCodeService.generateUniqueCode();\n          final inviteCode = inviteCodeResult.code;\n\n          // Create the league model\n          final league = LeagueModel.newLeague(\n            id: docRef.id,\n            name: name,\n            description: description,\n            createdBy: createdBy,\n            inviteCode: inviteCode,\n            settings: settings,\n          );\n\n          // Save to Firestore\n          await docRef.set(league.toJson());\n\n          return league.toEntity();\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to create league: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'createdBy': createdBy,\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<LeagueEntity?> getLeagueById(String leagueId) async {\n    try {\n      final doc = await _leagueDoc(leagueId).get();\n      if (!doc.exists || doc.data() == null) {\n        return null;\n      }\n      return LeagueModel.fromFirestore(doc).toEntity();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get league: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<LeagueEntity?> getLeagueById(String leagueId) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'getLeagueById',\n      collection: _leaguesCollection,\n      documentId: leagueId,\n      action: () async {\n        try {\n          final doc = await _leagueDoc(leagueId).get();\n          if (!doc.exists || doc.data() == null) {\n            return null;\n          }\n          return LeagueModel.fromFirestore(doc).toEntity();\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to get league: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<LeagueEntity?> getLeagueByInviteCode(String inviteCode) async {\n    try {\n      final querySnapshot = await _leaguesRef\n          .where('inviteCode', isEqualTo: inviteCode.toUpperCase())\n          .limit(1)\n          .get();\n\n      if (querySnapshot.docs.isEmpty) {\n        return null;\n      }\n\n      return LeagueModel.fromFirestore(querySnapshot.docs.first).toEntity();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get league by invite code: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<LeagueEntity?> getLeagueByInviteCode(String inviteCode) async {\n    return SentryPerformanceWrapper.traceFirestoreQuery(\n      operation: 'getLeagueByInviteCode',\n      collection: _leaguesCollection,\n      queryDescription: 'Query by inviteCode',\n      action: () async {\n        try {\n          final querySnapshot = await _leaguesRef\n              .where('inviteCode', isEqualTo: inviteCode.toUpperCase())\n              .limit(1)\n              .get();\n\n          if (querySnapshot.docs.isEmpty) {\n            return null;\n          }\n\n          return LeagueModel.fromFirestore(querySnapshot.docs.first).toEntity();\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to get league by invite code: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<void> updateLeague(LeagueEntity league) async {\n    try {\n      final leagueModel = LeagueModel.fromEntity(league);\n      await _leagueDoc(league.id).update(leagueModel.toJsonForUpdate());\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to update league: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<void> updateLeague(LeagueEntity league) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'updateLeague',\n      collection: _leaguesCollection,\n      documentId: league.id,\n      action: () async {\n        try {\n          final leagueModel = LeagueModel.fromEntity(league);\n          await _leagueDoc(league.id).update(leagueModel.toJsonForUpdate());\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to update league: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<void> deleteLeague(String leagueId) async {\n    try {\n      await _leagueDoc(leagueId).delete();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to delete league: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<void> deleteLeague(String leagueId) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'deleteLeague',\n      collection: _leaguesCollection,\n      documentId: leagueId,\n      action: () async {\n        try {\n          await _leagueDoc(leagueId).delete();\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to delete league: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<List<LeagueEntity>> getLeaguesForUser(String userId) async {\n    try {\n      // Firestore can't deeply query array fields with nested objects,\n      // so we query all leagues and filter client-side\n      final allLeagues = await _leaguesRef.get();\n\n      return allLeagues.docs\n          .map((doc) => LeagueModel.fromFirestore(doc))\n          .where((league) => league.isMember(userId))\n          .map((league) => league.toEntity())\n          .toList();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get leagues for user: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<List<LeagueEntity>> getLeaguesForUser(String userId) async {\n    return SentryPerformanceWrapper.traceFirestoreQuery(\n      operation: 'getLeaguesForUser',\n      collection: _leaguesCollection,\n      queryDescription: 'Get all leagues filtered by user membership',\n      action: () async {\n        try {\n          // Firestore can't deeply query array fields with nested objects,\n          // so we query all leagues and filter client-side\n          final allLeagues = await _leaguesRef.get();\n\n          return allLeagues.docs\n              .map((doc) => LeagueModel.fromFirestore(doc))\n              .where((league) => league.isMember(userId))\n              .map((league) => league.toEntity())\n              .toList();\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to get leagues for user: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'userId': userId,\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<List<LeagueEntity>> getPublicLeagues() async {\n    try {\n      final querySnapshot = await _leaguesRef\n          .where('settings.isPublic', isEqualTo: true)\n          .get();\n\n      return querySnapshot.docs\n          .map((doc) => LeagueModel.fromFirestore(doc).toEntity())\n          .toList();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get public leagues: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<List<LeagueEntity>> getPublicLeagues() async {\n    return SentryPerformanceWrapper.traceFirestoreQuery(\n      operation: 'getPublicLeagues',\n      collection: _leaguesCollection,\n      queryDescription: 'Query public leagues',\n      action: () async {\n        try {\n          final querySnapshot = await _leaguesRef\n              .where('settings.isPublic', isEqualTo: true)\n              .get();\n\n          return querySnapshot.docs\n              .map((doc) => LeagueModel.fromFirestore(doc).toEntity())\n              .toList();\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to get public leagues: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n    );\n  }"
}
Now let me instrument a couple more critical operations - addMember and the regenerateInviteCode:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<void> addMember({\n    required String leagueId,\n    required String userId,\n    LeagueMemberRole role = LeagueMemberRole.member,\n  }) async {\n    try {\n      final league = await getLeagueById(leagueId);\n      if (league == null) {\n        throw const BusinessException(\n          message: 'League not found',\n          code: 'league-not-found',\n        );\n      }\n\n      if (league.isMember(userId)) {\n        throw const BusinessException(\n          message: 'User is already a member of this league',\n          code: 'already-member',\n        );\n      }\n\n      if (league.isFull) {\n        throw const BusinessException(\n          message: 'League has reached maximum member capacity',\n          code: 'league-full',\n        );\n      }\n\n      final newMember = LeagueMemberModel.newMember(\n        userId: userId,\n        role: role,\n      );\n\n      final updatedMembers = [...league.members, newMember];\n      final updatedLeague = league.copyWith(members: updatedMembers);\n\n      await updateLeague(updatedLeague);\n    } on FirestoreException {\n      rethrow;\n    } on BusinessException {\n      rethrow;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to add member: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<void> addMember({\n    required String leagueId,\n    required String userId,\n    LeagueMemberRole role = LeagueMemberRole.member,\n  }) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'addMember',\n      collection: _leaguesCollection,\n      documentId: leagueId,\n      action: () async {\n        try {\n          final league = await getLeagueById(leagueId);\n          if (league == null) {\n            throw const BusinessException(\n              message: 'League not found',\n              code: 'league-not-found',\n            );\n          }\n\n          if (league.isMember(userId)) {\n            throw const BusinessException(\n              message: 'User is already a member of this league',\n              code: 'already-member',\n            );\n          }\n\n          if (league.isFull) {\n            throw const BusinessException(\n              message: 'League has reached maximum member capacity',\n              code: 'league-full',\n            );\n          }\n\n          final newMember = LeagueMemberModel.newMember(\n            userId: userId,\n            role: role,\n          );\n\n          final updatedMembers = [...league.members, newMember];\n          final updatedLeague = league.copyWith(members: updatedMembers);\n\n          await updateLeague(updatedLeague);\n        } on FirestoreException {\n          rethrow;\n        } on BusinessException {\n          rethrow;\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to add member: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'userId': userId,\n        'role': role.name,\n      },\n    );\n  }"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<void> removeMember({\n    required String leagueId,\n    required String userId,\n    required String requesterId,\n  }) async {\n    try {\n      final league = await getLeagueById(leagueId);\n      if (league == null) {\n        throw const BusinessException(\n          message: 'League not found',\n          code: 'league-not-found',\n        );\n      }\n\n      final member = league.getMember(userId);\n      if (member == null) {\n        throw const BusinessException(\n          message: 'User is not a member of this league',\n          code: 'not-member',\n        );\n      }\n\n      if (member.isOwner) {\n        throw const BusinessException(\n          message: 'Cannot remove the owner of the league',\n          code: 'cannot-remove-owner',\n        );\n      }\n\n      // Check permissions: either removing yourself (leaving) or admin removing a member\n      final isRemovingSelf = requesterId == userId;\n      final isRequesterAdmin = league.isAdmin(requesterId);\n\n      if (!isRemovingSelf && !isRequesterAdmin) {\n        throw const PermissionException(\n          message: 'Only admins can remove other members',\n          code: 'permission-denied',\n          permissionType: 'admin',\n        );\n      }\n\n      final updatedMembers =\n          league.members.where((m) => m.userId != userId).toList();\n      final updatedLeague = league.copyWith(members: updatedMembers);\n\n      await updateLeague(updatedLeague);\n    } on FirestoreException {\n      rethrow;\n    } on BusinessException {\n      rethrow;\n    } on PermissionException {\n      rethrow;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to remove member: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<void> removeMember({\n    required String leagueId,\n    required String userId,\n    required String requesterId,\n  }) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'removeMember',\n      collection: _leaguesCollection,\n      documentId: leagueId,\n      action: () async {\n        try {\n          final league = await getLeagueById(leagueId);\n          if (league == null) {\n            throw const BusinessException(\n              message: 'League not found',\n              code: 'league-not-found',\n            );\n          }\n\n          final member = league.getMember(userId);\n          if (member == null) {\n            throw const BusinessException(\n              message: 'User is not a member of this league',\n              code: 'not-member',\n            );\n          }\n\n          if (member.isOwner) {\n            throw const BusinessException(\n              message: 'Cannot remove the owner of the league',\n              code: 'cannot-remove-owner',\n            );\n          }\n\n          // Check permissions: either removing yourself (leaving) or admin removing a member\n          final isRemovingSelf = requesterId == userId;\n          final isRequesterAdmin = league.isAdmin(requesterId);\n\n          if (!isRemovingSelf && !isRequesterAdmin) {\n            throw const PermissionException(\n              message: 'Only admins can remove other members',\n              code: 'permission-denied',\n              permissionType: 'admin',\n            );\n          }\n\n          final updatedMembers =\n              league.members.where((m) => m.userId != userId).toList();\n          final updatedLeague = league.copyWith(members: updatedMembers);\n\n          await updateLeague(updatedLeague);\n        } on FirestoreException {\n          rethrow;\n        } on BusinessException {\n          rethrow;\n        } on PermissionException {\n          rethrow;\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to remove member: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'userId': userId,\n        'requesterId': requesterId,\n      },\n    );\n  }"
}
Now let me instrument a few more critical operations. Let me instrument the regenerateInviteCode and transferOwnership methods:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "offset": 595,
  "limit": 100
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<String> regenerateInviteCode({\n    required String leagueId,\n    required String requesterId,\n  }) async {\n    try {\n      final league = await getLeagueById(leagueId);\n      if (league == null) {\n        throw const BusinessException(\n          message: 'League not found',\n          code: 'league-not-found',\n        );\n      }\n\n      // Check permissions: only admins/owners can regenerate invite code\n      final isRequesterAdmin = league.isAdmin(requesterId);\n      if (!isRequesterAdmin) {\n        throw const PermissionException(\n          message: 'Only admins can regenerate the invite code',\n          code: 'permission-denied',\n          permissionType: 'admin',\n        );\n      }\n\n      // Generate unique invite code with Firestore validation\n      final inviteCodeResult = await _inviteCodeService.generateUniqueCode();\n      final newInviteCode = inviteCodeResult.code;\n\n      await _leagueDoc(leagueId).update({\n        'inviteCode': newInviteCode,\n      });\n\n      return newInviteCode;\n    } on BusinessException {\n      rethrow;\n    } on PermissionException {\n      rethrow;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to regenerate invite code: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<String> regenerateInviteCode({\n    required String leagueId,\n    required String requesterId,\n  }) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'regenerateInviteCode',\n      collection: _leaguesCollection,\n      documentId: leagueId,\n      action: () async {\n        try {\n          final league = await getLeagueById(leagueId);\n          if (league == null) {\n            throw const BusinessException(\n              message: 'League not found',\n              code: 'league-not-found',\n            );\n          }\n\n          // Check permissions: only admins/owners can regenerate invite code\n          final isRequesterAdmin = league.isAdmin(requesterId);\n          if (!isRequesterAdmin) {\n            throw const PermissionException(\n              message: 'Only admins can regenerate the invite code',\n              code: 'permission-denied',\n              permissionType: 'admin',\n            );\n          }\n\n          // Generate unique invite code with Firestore validation\n          final inviteCodeResult = await _inviteCodeService.generateUniqueCode();\n          final newInviteCode = inviteCodeResult.code;\n\n          await _leagueDoc(leagueId).update({\n            'inviteCode': newInviteCode,\n          });\n\n          return newInviteCode;\n        } on BusinessException {\n          rethrow;\n        } on PermissionException {\n          rethrow;\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to regenerate invite code: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'requesterId': requesterId,\n      },\n    );\n  }"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "offset": 663,
  "limit": 80
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart",
  "old_string": "  @override\n  Future<void> transferOwnership({\n    required String leagueId,\n    required String newOwnerId,\n    required String requesterId,\n  }) async {\n    try {\n      final league = await getLeagueById(leagueId);\n      if (league == null) {\n        throw const BusinessException(\n          message: 'League not found',\n          code: 'league-not-found',\n        );\n      }\n\n      // Check permissions: only owner can transfer ownership\n      final isRequesterOwner = league.isOwner(requesterId);\n      if (!isRequesterOwner) {\n        throw const PermissionException(\n          message: 'Only the owner can transfer ownership',\n          code: 'permission-denied',\n          permissionType: 'owner',\n        );\n      }\n\n      final newOwner = league.getMember(newOwnerId);\n      if (newOwner == null) {\n        throw const BusinessException(\n          message: 'New owner must be a member of the league',\n          code: 'not-member',\n        );\n      }\n\n      if (newOwnerId == requesterId) {\n        throw const BusinessException(\n          message: 'You are already the owner',\n          code: 'already-owner',\n        );\n      }\n\n      // Update members: new owner becomes owner, old owner becomes admin\n      final updatedMembers = league.members.map((m) {\n        if (m.userId == newOwnerId) {\n          return m.copyWith(role: LeagueMemberRole.owner);\n        }\n        if (m.userId == requesterId) {\n          return m.copyWith(role: LeagueMemberRole.admin);\n        }\n        return m;\n      }).toList();\n\n      // Also update createdBy field to the new owner\n      final updatedLeague = league.copyWith(\n        members: updatedMembers,\n        createdBy: newOwnerId,\n      );\n      await updateLeague(updatedLeague);\n    } on FirestoreException {\n      rethrow;\n    } on BusinessException {\n      rethrow;\n    } on PermissionException {\n      rethrow;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to transfer ownership: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }",
  "new_string": "  @override\n  Future<void> transferOwnership({\n    required String leagueId,\n    required String newOwnerId,\n    required String requesterId,\n  }) async {\n    return SentryPerformanceWrapper.traceFirestoreOperation(\n      operation: 'transferOwnership',\n      collection: _leaguesCollection,\n      documentId: leagueId,\n      action: () async {\n        try {\n          final league = await getLeagueById(leagueId);\n          if (league == null) {\n            throw const BusinessException(\n              message: 'League not found',\n              code: 'league-not-found',\n            );\n          }\n\n          // Check permissions: only owner can transfer ownership\n          final isRequesterOwner = league.isOwner(requesterId);\n          if (!isRequesterOwner) {\n            throw const PermissionException(\n              message: 'Only the owner can transfer ownership',\n              code: 'permission-denied',\n              permissionType: 'owner',\n            );\n          }\n\n          final newOwner = league.getMember(newOwnerId);\n          if (newOwner == null) {\n            throw const BusinessException(\n              message: 'New owner must be a member of the league',\n              code: 'not-member',\n            );\n          }\n\n          if (newOwnerId == requesterId) {\n            throw const BusinessException(\n              message: 'You are already the owner',\n              code: 'already-owner',\n            );\n          }\n\n          // Update members: new owner becomes owner, old owner becomes admin\n          final updatedMembers = league.members.map((m) {\n            if (m.userId == newOwnerId) {\n              return m.copyWith(role: LeagueMemberRole.owner);\n            }\n            if (m.userId == requesterId) {\n              return m.copyWith(role: LeagueMemberRole.admin);\n            }\n            return m;\n          }).toList();\n\n          // Also update createdBy field to the new owner\n          final updatedLeague = league.copyWith(\n            members: updatedMembers,\n            createdBy: newOwnerId,\n          );\n          await updateLeague(updatedLeague);\n        } on FirestoreException {\n          rethrow;\n        } on BusinessException {\n          rethrow;\n        } on PermissionException {\n          rethrow;\n        } on FirebaseException catch (e, stackTrace) {\n          throw FirestoreException(\n            message: 'Failed to transfer ownership: ${e.message}',\n            code: e.code,\n            originalError: e,\n            stackTrace: stackTrace,\n          );\n        }\n      },\n      extraData: {\n        'newOwnerId': newOwnerId,\n        'requesterId': requesterId,\n      },\n    );\n  }"
}
Now let's update todos and run the build to verify everything works:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing Firebase services and identify instrumentation points",
      "status": "completed",
      "activeForm": "Analyzing existing Firebase services"
    },
    {
      "content": "Create Sentry transaction/span wrapper service for Firebase operations",
      "status": "completed",
      "activeForm": "Creating Sentry transaction/span wrapper service"
    },
    {
      "content": "Instrument FirebaseAuthService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseAuthService"
    },
    {
      "content": "Instrument FirebaseStorageService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseStorageService"
    },
    {
      "content": "Instrument Firestore repositories with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting Firestore repositories"
    },
    {
      "content": "Run code generation and verify build",
      "status": "in_progress",
      "activeForm": "Running code generation and verifying build"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter analyze lib/core/services/sentry_performance_wrapper.dart lib/core/services/firebase_auth_service.dart lib/core/services/firebase_storage_service.dart lib/features/leagues/data/repositories/league_repository_impl.dart 2>&1",
  "description": "Analyze modified Dart files for errors",
  "timeout": 120000
}
All the files pass analysis. Now let me run a broader analysis to make sure all the imports are correctly resolved:

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter analyze 2>&1 | head -50",
  "description": "Run full Flutter analyze",
  "timeout": 180000
}
The analysis passed with only pre-existing warnings (not related to my changes). The new instrumentation code has no issues.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing Firebase services and identify instrumentation points",
      "status": "completed",
      "activeForm": "Analyzing existing Firebase services"
    },
    {
      "content": "Create Sentry transaction/span wrapper service for Firebase operations",
      "status": "completed",
      "activeForm": "Creating Sentry transaction/span wrapper service"
    },
    {
      "content": "Instrument FirebaseAuthService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseAuthService"
    },
    {
      "content": "Instrument FirebaseStorageService with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting FirebaseStorageService"
    },
    {
      "content": "Instrument Firestore repositories with Sentry spans",
      "status": "completed",
      "activeForm": "Instrumenting Firestore repositories"
    },
    {
      "content": "Run code generation and verify build",
      "status": "completed",
      "activeForm": "Running code generation and verifying build"
    }
  ]
}
<summary>
## Summary: Sentry Firebase Tracing Instrumentation

### Changes Implemented
- Created a new `SentryPerformanceWrapper` utility class with methods for tracing Firebase operations:
  - `traceFirestoreOperation()` - for single document operations (CRUD)
  - `traceFirestoreQuery()` - for query operations  
  - `traceAuthOperation()` - for Firebase Auth operations
  - `traceStorageOperation()` - for Firebase Storage operations
  - `traceFcmOperation()` - for FCM/Push notification operations
  - `traceChildSpan()` - for creating child spans within transactions
  - `addBreadcrumb()` - for tracking user journey

- Instrumented **FirebaseAuthService** with Sentry performance monitoring (12 methods):
  - signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut
  - sendPasswordResetEmail, sendEmailVerification, reloadUser
  - updateDisplayName, updatePhotoURL, deleteAccount
  - reauthenticateWithEmailAndPassword, updatePassword

- Instrumented **FirebaseStorageService** with Sentry performance monitoring (7 methods):
  - uploadCheckInPhoto, uploadProfilePhoto, uploadBytes
  - deleteFile, getDownloadUrl, getFileMetadata, listCheckInPhotos

- Instrumented **LeagueRepositoryImpl** (critical Firestore operations, 12 methods):
  - createLeague, getLeagueById, getLeagueByInviteCode
  - updateLeague, deleteLeague, getLeaguesForUser, getPublicLeagues
  - addMember, removeMember, regenerateInviteCode, transferOwnership

### Files Modified
- `lib/core/services/sentry_performance_wrapper.dart` (NEW - 320 lines)
- `lib/core/services/firebase_auth_service.dart` (added tracing to all async methods)
- `lib/core/services/firebase_storage_service.dart` (added tracing to all async methods)
- `lib/features/leagues/data/repositories/league_repository_impl.dart` (added tracing to 12 critical methods)

### Notes for Developer
- Each traced operation creates a Sentry Transaction with child Spans
- Errors are automatically captured and attached to spans with status `internalError`
- Extra metadata (userId, leagueId, fileSize, etc.) is attached to spans for filtering in Sentry dashboard
- Breadcrumbs are added on failures for better debugging context
- The wrapper handles error re-throwing correctly to preserve stack traces
- Performance monitoring is already configured via `SentryService` with environment-aware sampling rates (dev/stg: 100%, prod: recommended 20%)
- Stream-based methods (watchLeague, watchLeaguesForUser) are NOT instrumented as they're continuous subscriptions rather than discrete operations
</summary>