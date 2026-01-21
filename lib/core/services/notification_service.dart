import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as android show Importance;
import 'package:injectable/injectable.dart';

import '../errors/exceptions.dart';
import '../errors/error_messages.dart';
import 'notification_messages_service.dart';

/// Notification channel configuration for Android
class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final Importance importance;

  const NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    this.importance = Importance.defaultImportance,
  });
}

/// Importance levels for notification channels
enum Importance {
  none,
  min,
  low,
  defaultImportance,
  high,
  max,
}

/// Result of notification permission request
enum NotificationPermissionResult {
  /// Permission was granted
  granted,

  /// Permission was denied
  denied,

  /// User hasn't been asked yet (iOS provisional)
  provisional,

  /// Permission not determined
  notDetermined,
}

/// Types of notifications the app can receive
enum NotificationType {
  /// New check-in was posted in a league
  newCheckIn,

  /// User was invited to join a league
  leagueInvite,

  /// League activity update
  leagueUpdate,

  /// Reminder to make a check-in
  reminder,

  /// General notification
  general,
}

/// Parsed notification payload data
class NotificationPayload {
  /// The type of notification
  final NotificationType type;

  /// Title of the notification
  final String? title;

  /// Body text of the notification
  final String? body;

  /// League ID if applicable
  final String? leagueId;

  /// Check-in ID if applicable
  final String? checkInId;

  /// User ID of the sender/actor if applicable
  final String? userId;

  /// Additional custom data
  final Map<String, dynamic> data;

  const NotificationPayload({
    required this.type,
    this.title,
    this.body,
    this.leagueId,
    this.checkInId,
    this.userId,
    this.data = const {},
  });

  /// Creates a payload from FCM RemoteMessage data
  factory NotificationPayload.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;
    final notification = message.notification;

    return NotificationPayload(
      type: _parseNotificationType(data['type'] as String?),
      title: notification?.title ?? data['title'] as String?,
      body: notification?.body ?? data['body'] as String?,
      leagueId: data['leagueId'] as String?,
      checkInId: data['checkInId'] as String?,
      userId: data['userId'] as String?,
      data: data,
    );
  }

  /// Parses the notification type from string
  static NotificationType _parseNotificationType(String? type) {
    return switch (type) {
      'new_checkin' => NotificationType.newCheckIn,
      'league_invite' => NotificationType.leagueInvite,
      'league_update' => NotificationType.leagueUpdate,
      'reminder' => NotificationType.reminder,
      _ => NotificationType.general,
    };
  }

  /// Returns the route path to navigate to based on this notification
  String? get targetRoute {
    switch (type) {
      case NotificationType.newCheckIn:
        if (checkInId != null) {
          return '/check-ins/$checkInId';
        }
        if (leagueId != null) {
          return '/leagues/$leagueId';
        }
        return null;
      case NotificationType.leagueInvite:
      case NotificationType.leagueUpdate:
        if (leagueId != null) {
          return '/leagues/$leagueId';
        }
        return null;
      case NotificationType.reminder:
        if (leagueId != null) {
          return '/check-ins/create?leagueId=$leagueId';
        }
        return '/check-ins/create';
      case NotificationType.general:
        return null;
    }
  }

  @override
  String toString() {
    return 'NotificationPayload(type: $type, title: $title, body: $body, '
        'leagueId: $leagueId, checkInId: $checkInId, userId: $userId)';
  }
}

/// Service for managing push notifications
///
/// This service handles:
/// - FCM token registration and refresh
/// - Token storage in Firestore
/// - Notification permission requests
/// - Topic subscriptions for targeted notifications
/// - Notification channel setup (Android)
///
/// Example usage:
/// ```dart
/// final notificationService = getIt<NotificationService>();
///
/// // Request permission and register token
/// await notificationService.initialize();
///
/// // Subscribe to league updates
/// await notificationService.subscribeToLeague('league123');
/// ```

/// Top-level function to handle background messages
///
/// This MUST be a top-level function (not a class method or anonymous function)
/// as it needs to be callable from the native platform code.
///
/// Call [NotificationService.setBackgroundMessageHandler] in main.dart
/// before runApp() to register this handler.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Message data: ${message.data}');

  // Note: In background, we cannot access GetIt or other app services
  // The notification will be displayed by the system automatically
  // When user taps, onMessageOpenedApp will handle navigation
}

@lazySingleton
class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final NotificationMessagesService _messagesService;

  /// Collection name for storing FCM tokens
  static const String _tokensCollection = 'fcm_tokens';

  /// Collection name for users (for storing token in user document)
  static const String _usersCollection = 'users';

  /// Stream controller for notification tap events
  final StreamController<NotificationPayload> _onNotificationTappedController =
      StreamController<NotificationPayload>.broadcast();

  /// Stream controller for foreground notification events
  final StreamController<NotificationPayload> _onForegroundMessageController =
      StreamController<NotificationPayload>.broadcast();

  /// Flutter local notifications plugin for showing notifications in foreground
  FlutterLocalNotificationsPlugin? _localNotifications;

  /// Whether the service has been initialized with handlers
  bool _handlersInitialized = false;

  /// Stores the initial notification if app was opened from terminated state
  NotificationPayload? _initialNotification;

  /// Notification channel IDs (static, not localized)
  static const String defaultChannelId = 'burgerrats_default_channel';
  static const String checkInsChannelId = 'burgerrats_checkins_channel';
  static const String leaguesChannelId = 'burgerrats_leagues_channel';
  static const String remindersChannelId = 'burgerrats_reminders_channel';

  NotificationService(
    this._messaging,
    this._firestore,
    this._auth,
    this._messagesService,
  );

  /// Get localized notification channels for Android
  List<NotificationChannel> get channels => [
    NotificationChannel(
      id: defaultChannelId,
      name: _messagesService.channelNameGeneral,
      description: _messagesService.channelDescriptionGeneral,
      importance: Importance.defaultImportance,
    ),
    NotificationChannel(
      id: checkInsChannelId,
      name: _messagesService.channelNameCheckIns,
      description: _messagesService.channelDescriptionCheckIns,
      importance: Importance.high,
    ),
    NotificationChannel(
      id: leaguesChannelId,
      name: _messagesService.channelNameLeagues,
      description: _messagesService.channelDescriptionLeagues,
      importance: Importance.high,
    ),
    NotificationChannel(
      id: remindersChannelId,
      name: _messagesService.channelNameReminders,
      description: _messagesService.channelDescriptionReminders,
      importance: Importance.defaultImportance,
    ),
  ];

  /// Stream of notifications that were tapped by the user
  ///
  /// Subscribe to this stream to handle navigation when user taps a notification.
  Stream<NotificationPayload> get onNotificationTapped =>
      _onNotificationTappedController.stream;

  /// Stream of notifications received while app is in foreground
  ///
  /// Subscribe to this stream to show in-app notifications or update UI.
  Stream<NotificationPayload> get onForegroundMessage =>
      _onForegroundMessageController.stream;

  /// Returns the notification that opened the app from terminated state
  ///
  /// Returns null if app was not opened from a notification.
  /// Call this after [setupMessageHandlers] to check if there's a pending notification.
  NotificationPayload? get initialNotification => _initialNotification;

  /// Clears the initial notification after it has been processed
  void clearInitialNotification() {
    _initialNotification = null;
  }

  /// Sets up the background message handler
  ///
  /// Call this in main.dart BEFORE runApp() and AFTER Firebase.initializeApp()
  static void setBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Setup message handlers for foreground and notification tap events
  ///
  /// Call this after [initialize] to start receiving notification events.
  Future<void> setupMessageHandlers() async {
    if (_handlersInitialized) {
      debugPrint('Message handlers already initialized');
      return;
    }

    try {
      // Initialize local notifications for foreground display
      await _initializeLocalNotifications();

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a terminated state notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _initialNotification = NotificationPayload.fromRemoteMessage(initialMessage);
        debugPrint('App opened from notification: $_initialNotification');
      }

      _handlersInitialized = true;
      debugPrint('Notification message handlers setup complete');
    } catch (e, stackTrace) {
      debugPrint('Error setting up message handlers: $e');
      throw NotificationException(
        message: 'Erro ao configurar handlers de notificacao',
        code: 'handler-setup-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Initialize flutter_local_notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Android initialization
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Already requested via FCM
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Create notification channels on Android
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannels();
    }
  }

  /// Create Android notification channels
  Future<void> _createAndroidNotificationChannels() async {
    final androidPlugin = _localNotifications!
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    for (final channel in channels) {
      await androidPlugin.createNotificationChannel(
        AndroidNotificationChannel(
          channel.id,
          channel.name,
          description: channel.description,
          importance: _mapToAndroidImportance(channel.importance),
        ),
      );
    }
  }

  /// Map our Importance enum to Android's Importance
  android.Importance _mapToAndroidImportance(Importance importance) {
    return switch (importance) {
      Importance.none => android.Importance.none,
      Importance.min => android.Importance.min,
      Importance.low => android.Importance.low,
      Importance.defaultImportance => android.Importance.defaultImportance,
      Importance.high => android.Importance.high,
      Importance.max => android.Importance.max,
    };
  }

  /// Handle foreground message received
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.messageId}');
    debugPrint('Message data: ${message.data}');

    final payload = NotificationPayload.fromRemoteMessage(message);
    _onForegroundMessageController.add(payload);

    // Show local notification
    _showLocalNotification(message);
  }

  /// Show a local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    if (_localNotifications == null) return;

    final notification = message.notification;
    if (notification == null) return;

    final channelId = _getChannelIdForMessage(message);

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: android.Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use message hash as notification ID
    final notificationId = message.messageId?.hashCode ?? DateTime.now().hashCode;

    // Encode payload data as JSON string for retrieval on tap
    final payloadString = _encodePayload(message.data);

    await _localNotifications!.show(
      notificationId,
      notification.title,
      notification.body,
      details,
      payload: payloadString,
    );
  }

  /// Get channel ID based on message type
  String _getChannelIdForMessage(RemoteMessage message) {
    final type = message.data['type'] as String?;
    return switch (type) {
      'new_checkin' => checkInsChannelId,
      'league_invite' || 'league_update' => leaguesChannelId,
      'reminder' => remindersChannelId,
      _ => defaultChannelId,
    };
  }

  /// Get channel name by ID
  String _getChannelName(String channelId) {
    return channels
        .firstWhere(
          (c) => c.id == channelId,
          orElse: () => channels.first,
        )
        .name;
  }

  /// Get channel description by ID
  String _getChannelDescription(String channelId) {
    return channels
        .firstWhere(
          (c) => c.id == channelId,
          orElse: () => channels.first,
        )
        .description;
  }

  /// Encode payload data as string for local notification
  String _encodePayload(Map<String, dynamic> data) {
    // Simple encoding: key=value pairs separated by |
    return data.entries.map((e) => '${e.key}=${e.value}').join('|');
  }

  /// Decode payload string from local notification
  Map<String, dynamic> _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return {};

    final data = <String, dynamic>{};
    for (final pair in payload.split('|')) {
      final parts = pair.split('=');
      if (parts.length == 2) {
        data[parts[0]] = parts[1];
      }
    }
    return data;
  }

  /// Handle notification tap from FCM
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped (background): ${message.messageId}');
    final payload = NotificationPayload.fromRemoteMessage(message);
    _onNotificationTappedController.add(payload);
  }

  /// Handle local notification tap
  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.id}');
    final data = _decodePayload(response.payload);

    final payload = NotificationPayload(
      type: NotificationPayload._parseNotificationType(data['type'] as String?),
      title: data['title'] as String?,
      body: data['body'] as String?,
      leagueId: data['leagueId'] as String?,
      checkInId: data['checkInId'] as String?,
      userId: data['userId'] as String?,
      data: data,
    );

    _onNotificationTappedController.add(payload);
  }

  /// Dispose of stream controllers
  void dispose() {
    _onNotificationTappedController.close();
    _onForegroundMessageController.close();
  }

  /// Initialize the notification service
  ///
  /// This should be called after user authentication.
  /// It requests permission, gets the FCM token, and stores it.
  Future<void> initialize() async {
    try {
      // Request permission
      final permissionResult = await requestPermission();
      if (permissionResult != NotificationPermissionResult.granted &&
          permissionResult != NotificationPermissionResult.provisional) {
        debugPrint('Notification permission not granted: $permissionResult');
        return;
      }

      // Get and store token
      await _registerToken();

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      debugPrint('NotificationService initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing NotificationService: $e');
      throw NotificationException(
        message: 'Erro ao inicializar notificacoes',
        code: 'notification-init-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Request notification permission from the user
  ///
  /// Returns the permission result status.
  Future<NotificationPermissionResult> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return _mapAuthorizationStatus(settings.authorizationStatus);
    } catch (e, stackTrace) {
      debugPrint('Error requesting notification permission: $e');
      throw PermissionException(
        message: ErrorMessages.notificationPermissionDenied,
        code: 'notification-permission-error',
        permissionType: 'notification',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Check current notification permission status
  Future<NotificationPermissionResult> checkPermissionStatus() async {
    final settings = await _messaging.getNotificationSettings();
    return _mapAuthorizationStatus(settings.authorizationStatus);
  }

  /// Get the current FCM token
  ///
  /// Returns null if token is not available.
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Delete the FCM token
  ///
  /// Call this when user logs out to stop receiving notifications.
  Future<void> deleteToken() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final token = await _messaging.getToken();
        if (token != null) {
          await _removeTokenFromFirestore(currentUser.uid, token);
        }
      }
      await _messaging.deleteToken();
      debugPrint('FCM token deleted');
    } catch (e, stackTrace) {
      debugPrint('Error deleting FCM token: $e');
      throw NotificationException(
        message: 'Erro ao remover token de notificacao',
        code: 'token-delete-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Subscribe to a topic for targeted notifications
  ///
  /// Topics are useful for sending notifications to groups of users.
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e, stackTrace) {
      debugPrint('Error subscribing to topic $topic: $e');
      throw NotificationException(
        message: 'Erro ao inscrever no topico de notificacoes',
        code: 'topic-subscribe-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e, stackTrace) {
      debugPrint('Error unsubscribing from topic $topic: $e');
      throw NotificationException(
        message: 'Erro ao cancelar inscricao no topico',
        code: 'topic-unsubscribe-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Subscribe to league notifications
  ///
  /// Users subscribed to a league topic will receive notifications
  /// about new check-ins and league updates.
  Future<void> subscribeToLeague(String leagueId) async {
    await subscribeToTopic('league_$leagueId');
  }

  /// Unsubscribe from league notifications
  Future<void> unsubscribeFromLeague(String leagueId) async {
    await unsubscribeFromTopic('league_$leagueId');
  }

  /// Subscribe to all leagues the user is a member of
  Future<void> subscribeToUserLeagues(List<String> leagueIds) async {
    for (final leagueId in leagueIds) {
      await subscribeToLeague(leagueId);
    }
  }

  /// Unsubscribe from all league topics
  Future<void> unsubscribeFromAllLeagues(List<String> leagueIds) async {
    for (final leagueId in leagueIds) {
      await unsubscribeFromLeague(leagueId);
    }
  }

  /// Register the FCM token in Firestore
  Future<void> _registerToken() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint('Cannot register token: no authenticated user');
      return;
    }

    final token = await getToken();
    if (token == null) {
      debugPrint('Cannot register token: token is null');
      return;
    }

    await _storeTokenInFirestore(currentUser.uid, token);
  }

  /// Handle token refresh events
  void _onTokenRefresh(String token) async {
    debugPrint('FCM token refreshed');
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _storeTokenInFirestore(currentUser.uid, token);
    }
  }

  /// Store FCM token in Firestore
  ///
  /// Stores token in both a dedicated tokens collection (for backend querying)
  /// and in the user document (for user-specific operations).
  Future<void> _storeTokenInFirestore(String userId, String token) async {
    try {
      final tokenData = {
        'token': token,
        'userId': userId,
        'platform': Platform.operatingSystem,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Store in tokens collection (useful for backend to query all tokens)
      await _firestore
          .collection(_tokensCollection)
          .doc('${userId}_$token')
          .set(tokenData, SetOptions(merge: true));

      // Also update user document with current token
      await _firestore.collection(_usersCollection).doc(userId).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('FCM token stored for user: $userId');
    } catch (e, stackTrace) {
      debugPrint('Error storing FCM token: $e');
      throw NotificationException(
        message: 'Erro ao salvar token de notificacao',
        code: 'token-store-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Remove FCM token from Firestore
  Future<void> _removeTokenFromFirestore(String userId, String token) async {
    try {
      // Remove from tokens collection
      await _firestore
          .collection(_tokensCollection)
          .doc('${userId}_$token')
          .delete();

      // Clear token from user document
      await _firestore.collection(_usersCollection).doc(userId).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': FieldValue.delete(),
      });

      debugPrint('FCM token removed for user: $userId');
    } catch (e) {
      // Don't throw on removal errors - just log
      debugPrint('Error removing FCM token: $e');
    }
  }

  /// Map Firebase authorization status to our enum
  NotificationPermissionResult _mapAuthorizationStatus(
    AuthorizationStatus status,
  ) {
    return switch (status) {
      AuthorizationStatus.authorized => NotificationPermissionResult.granted,
      AuthorizationStatus.denied => NotificationPermissionResult.denied,
      AuthorizationStatus.provisional => NotificationPermissionResult.provisional,
      AuthorizationStatus.notDetermined =>
        NotificationPermissionResult.notDetermined,
    };
  }
}

/// Exception thrown for notification-related errors
class NotificationException extends AppException {
  const NotificationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
