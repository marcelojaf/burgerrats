import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration and initialization service.
///
/// Call [FirebaseConfig.initialize] before running the app to ensure
/// all Firebase services are properly configured.
class FirebaseConfig {
  FirebaseConfig._();

  static bool _initialized = false;

  /// Initialize Firebase services.
  ///
  /// This method should be called in main() before runApp().
  /// It's safe to call multiple times - subsequent calls are no-ops.
  static Future<void> initialize() async {
    if (_initialized) return;

    await Firebase.initializeApp();
    await _configureMessaging();

    _initialized = true;
    debugPrint('Firebase initialized successfully');
  }

  /// Configure Firebase Cloud Messaging for push notifications.
  static Future<void> _configureMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission for iOS (Android handles this differently)
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('FCM authorization status: ${settings.authorizationStatus}');

    // Get FCM token for this device
    final token = await messaging.getToken();
    debugPrint('FCM Token: $token');

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.messageId}');
      if (message.notification != null) {
        debugPrint('Notification: ${message.notification!.title}');
      }
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened app: ${message.messageId}');
    });
  }

  /// Get the current FCM token for this device.
  static Future<String?> getFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  /// Subscribe to a topic for targeted push notifications.
  static Future<void> subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic.
  static Future<void> unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}

/// Background message handler - must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}
