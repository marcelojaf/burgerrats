import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/app_secrets.dart';

/// Service for managing Sentry error tracking and performance monitoring
///
/// This service handles:
/// - Sentry SDK initialization with environment-specific configuration
/// - User context management (setting/clearing user identity)
/// - Custom event and exception capturing
/// - Performance monitoring configuration
///
/// Example usage:
/// ```dart
/// // Initialize Sentry (call before runApp)
/// await SentryService.initializeSentry(
///   secrets: appSecrets,
///   appRunner: () => runApp(MyApp()),
/// );
///
/// // After user login
/// final sentryService = getIt<SentryService>();
/// sentryService.setUserContext(userId: 'user123', email: 'user@example.com');
///
/// // On logout
/// sentryService.clearUserContext();
/// ```
@lazySingleton
class SentryService {
  bool _isInitialized = false;

  /// Whether Sentry has been initialized
  bool get isInitialized => _isInitialized;

  /// Initializes Sentry SDK with the provided configuration
  ///
  /// This is a static method that should be called in main.dart before runApp.
  /// It wraps the app with Sentry's error tracking.
  ///
  /// [secrets] - Application secrets containing Sentry DSN and configuration
  /// [appRunner] - Function that runs the app (typically () => runApp(MyApp()))
  /// [releaseVersion] - Optional release version string (e.g., "1.0.0+1")
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   final secrets = await AppSecrets.load();
  ///   final versionService = AppVersionService();
  ///   await versionService.initialize();
  ///   await SentryService.initializeSentry(
  ///     secrets: secrets,
  ///     releaseVersion: versionService.releaseVersion,
  ///     appRunner: () => runApp(const MyApp()),
  ///   );
  /// }
  /// ```
  static Future<void> initializeSentry({
    required AppSecrets secrets,
    required FutureOr<void> Function() appRunner,
    String? releaseVersion,
  }) async {
    // Skip Sentry initialization if DSN is not configured
    if (!secrets.sentry.isConfigured) {
      debugPrint('Sentry: DSN not configured, skipping initialization');
      await appRunner();
      return;
    }

    // Skip Sentry in debug mode (optional - can be removed if debug tracking is desired)
    if (kDebugMode) {
      debugPrint('Sentry: Debug mode - running without Sentry wrapper');
      await appRunner();
      return;
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = secrets.sentry.dsn;

        // Environment configuration
        options.environment = secrets.environment;

        // Release version (e.g., "1.0.0+1")
        if (releaseVersion != null) {
          options.release = releaseVersion;
          debugPrint('Sentry: Release version set to $releaseVersion');
        }

        // Performance monitoring
        options.tracesSampleRate = secrets.sentry.tracesSampleRate;

        // Enable automatic session tracking
        options.enableAutoSessionTracking = true;

        // Capture failed HTTP requests (4xx and 5xx)
        options.captureFailedRequests = true;

        // Send default PII (user info) if set
        options.sendDefaultPii = true;

        // Attach stacktrace to all messages
        options.attachStacktrace = true;

        // Debug mode for Sentry (logs Sentry operations)
        options.debug = kDebugMode;
      },
      appRunner: appRunner,
    );
  }

  /// Marks the service as initialized
  ///
  /// Call this after SentryService.initializeSentry completes.
  void markAsInitialized() {
    _isInitialized = true;
    debugPrint('Sentry: Service marked as initialized');
  }

  /// Sets the user context for error tracking
  ///
  /// Call this after user authentication to associate errors with users.
  ///
  /// [userId] - Unique identifier for the user
  /// [email] - User's email address (optional)
  /// [displayName] - User's display name (optional)
  /// [extras] - Additional custom data to attach to the user context
  void setUserContext({
    required String userId,
    String? email,
    String? displayName,
    Map<String, dynamic>? extras,
  }) {
    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: userId,
          email: email,
          name: displayName,
          data: extras,
        ),
      );
    });

    debugPrint('Sentry: User context set for user $userId');
  }

  /// Clears the current user context
  ///
  /// Call this on user logout to stop associating errors with the user.
  void clearUserContext() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });

    debugPrint('Sentry: User context cleared');
  }

  /// Captures an exception and sends it to Sentry
  ///
  /// [exception] - The exception to capture
  /// [stackTrace] - Optional stack trace (if not provided, current trace is used)
  /// [hint] - Optional hint with additional context
  Future<void> captureException(
    dynamic exception, {
    StackTrace? stackTrace,
    Hint? hint,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint,
    );
  }

  /// Captures a message and sends it to Sentry
  ///
  /// [message] - The message to capture
  /// [level] - Severity level of the message
  /// [params] - Optional parameters to include with the message
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    List<dynamic>? params,
  }) async {
    await Sentry.captureMessage(
      message,
      level: level,
      params: params,
    );
  }

  /// Adds a breadcrumb for tracking user actions
  ///
  /// Breadcrumbs are used to track the user's journey before an error occurs.
  ///
  /// [message] - Description of the action
  /// [category] - Category of the breadcrumb (e.g., 'navigation', 'user.action')
  /// [data] - Additional data to attach to the breadcrumb
  /// [level] - Severity level of the breadcrumb
  void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        data: data,
        level: level,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Sets a custom tag for filtering in Sentry dashboard
  ///
  /// [key] - Tag key
  /// [value] - Tag value
  void setTag(String key, String value) {
    Sentry.configureScope((scope) {
      scope.setTag(key, value);
    });
  }

  /// Sets custom context data for error reports
  ///
  /// [key] - Context key (creates a new context section in Sentry)
  /// [value] - Map of context data
  void setContext(String key, Map<String, dynamic> value) {
    Sentry.configureScope((scope) {
      scope.setContexts(key, value);
    });
  }

  /// Removes a custom context
  ///
  /// [key] - Context key to remove
  void removeContext(String key) {
    Sentry.configureScope((scope) {
      scope.removeContexts(key);
    });
  }
}
