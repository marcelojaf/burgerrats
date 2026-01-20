import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection.dart';
import '../../services/notification_service.dart';

/// Provider for the NotificationService instance from GetIt
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return getIt<NotificationService>();
});

/// Provider that exposes the stream of tapped notifications
final notificationTappedStreamProvider = StreamProvider<NotificationPayload>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.onNotificationTapped;
});

/// Provider that exposes the stream of foreground notifications
final foregroundNotificationStreamProvider = StreamProvider<NotificationPayload>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.onForegroundMessage;
});

/// Provider for the initial notification (when app opens from notification)
final initialNotificationProvider = Provider<NotificationPayload?>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.initialNotification;
});

/// Handler class for notification navigation
///
/// This class manages navigation when users tap on notifications.
/// It should be initialized once in the app widget and disposed properly.
class NotificationHandler {
  final NotificationService _notificationService;
  final GoRouter _router;

  StreamSubscription<NotificationPayload>? _tappedSubscription;
  bool _initialized = false;

  NotificationHandler({
    required NotificationService notificationService,
    required GoRouter router,
  })  : _notificationService = notificationService,
        _router = router;

  /// Initialize the notification handler
  ///
  /// Starts listening to notification tap events and handles navigation.
  /// Also processes any initial notification that opened the app.
  void initialize() {
    if (_initialized) return;

    // Listen to notification taps
    _tappedSubscription = _notificationService.onNotificationTapped.listen(
      _handleNotificationTap,
    );

    // Handle initial notification if app was opened from terminated state
    final initial = _notificationService.initialNotification;
    if (initial != null) {
      debugPrint('Processing initial notification: $initial');
      // Delay slightly to ensure router is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationTap(initial);
        _notificationService.clearInitialNotification();
      });
    }

    _initialized = true;
    debugPrint('NotificationHandler initialized');
  }

  /// Handle notification tap and navigate to target route
  void _handleNotificationTap(NotificationPayload payload) {
    debugPrint('Handling notification tap: $payload');

    final targetRoute = payload.targetRoute;
    if (targetRoute != null) {
      debugPrint('Navigating to: $targetRoute');
      _router.go(targetRoute);
    } else {
      debugPrint('No target route for notification type: ${payload.type}');
    }
  }

  /// Dispose of subscriptions
  void dispose() {
    _tappedSubscription?.cancel();
    _initialized = false;
  }
}
