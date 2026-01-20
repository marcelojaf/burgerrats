import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/reminders/data/repositories/reminder_settings_repository.dart';
import '../../features/reminders/domain/entities/reminder_settings.dart';
import '../errors/exceptions.dart';

/// Callback for handling notification taps in background
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
      'Notification tapped in background: ${notificationResponse.payload}');
}

/// Service for scheduling and managing local notifications for daily reminders
///
/// This service handles:
/// - Initialization of flutter_local_notifications
/// - Scheduling daily reminders for leagues
/// - Canceling reminders
/// - Permission requests for notifications
///
/// Example usage:
/// ```dart
/// final service = getIt<ReminderSchedulerService>();
/// await service.initialize();
///
/// // Schedule a reminder for a league
/// await service.scheduleLeagueReminder(leagueSettings, 'Burger League');
/// ```
@lazySingleton
class ReminderSchedulerService {
  final ReminderSettingsRepository _settingsRepository;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  /// Notification channel ID for reminders (Android)
  static const String channelId = 'burgerrats_reminders_channel';

  /// Notification channel name (Android)
  static const String channelName = 'Lembretes de Check-in';

  /// Notification channel description (Android)
  static const String channelDescription =
      'Lembretes diarios para fazer check-in nas suas ligas';

  /// Base notification ID for league reminders
  /// Each league gets ID: _baseNotificationId + leagueId.hashCode
  static const int _baseNotificationId = 1000;

  bool _isInitialized = false;

  ReminderSchedulerService(this._settingsRepository)
      : _notificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Whether the service has been initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the notification service
  ///
  /// Must be called before scheduling any notifications.
  /// Initializes timezone data and notification settings.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(_getLocalTimezone()));

      // Initialize notification settings
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      // Create notification channel on Android
      if (Platform.isAndroid) {
        await _createAndroidNotificationChannel();
      }

      _isInitialized = true;
      debugPrint('ReminderSchedulerService initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing ReminderSchedulerService: $e');
      throw ReminderSchedulerException(
        message: 'Erro ao inicializar servico de lembretes',
        code: 'reminder-init-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Request notification permission from the user
  ///
  /// Returns true if permission was granted.
  Future<bool> requestPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted =
            await androidPlugin?.requestNotificationsPermission() ?? false;
        return granted;
      } else if (Platform.isIOS) {
        final iosPlugin =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosPlugin?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
        return granted;
      }
      return false;
    } catch (e, stackTrace) {
      debugPrint('Error requesting notification permission: $e');
      throw ReminderSchedulerException(
        message: 'Erro ao solicitar permissao de notificacao',
        code: 'reminder-permission-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidPlugin =
            _notificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        return await androidPlugin?.areNotificationsEnabled() ?? false;
      }
      // iOS doesn't have a direct check, assume enabled after permission granted
      return true;
    } catch (e) {
      debugPrint('Error checking notification status: $e');
      return false;
    }
  }

  /// Schedule a daily reminder for a league
  ///
  /// Schedules a notification to fire daily at the specified time.
  /// If a reminder already exists for this league, it will be replaced.
  Future<void> scheduleLeagueReminder(
    LeagueReminderSettings settings,
    String leagueName,
  ) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!settings.isEnabled) {
      await cancelLeagueReminder(settings.leagueId);
      return;
    }

    try {
      final notificationId = _getNotificationId(settings.leagueId);

      // Create the scheduled time for today
      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        settings.reminderHour,
        settings.reminderMinute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: '@mipmap/ic_launcher',
        autoCancel: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.zonedSchedule(
        notificationId,
        'Hora do check-in!',
        'Nao esqueca de fazer seu check-in na liga "$leagueName"',
        scheduledDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'league:${settings.leagueId}',
      );

      // Save the settings
      await _settingsRepository.saveLeagueSettings(settings);

      debugPrint(
          'Scheduled reminder for league ${settings.leagueId} at ${settings.formattedTime}');
    } catch (e, stackTrace) {
      debugPrint('Error scheduling league reminder: $e');
      throw ReminderSchedulerException(
        message: 'Erro ao agendar lembrete',
        code: 'reminder-schedule-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Cancel a reminder for a specific league
  Future<void> cancelLeagueReminder(String leagueId) async {
    try {
      final notificationId = _getNotificationId(leagueId);
      await _notificationsPlugin.cancel(notificationId);

      // Update settings to disabled
      final settings = await _settingsRepository.getLeagueSettings(leagueId);
      await _settingsRepository
          .saveLeagueSettings(settings.copyWith(isEnabled: false));

      debugPrint('Cancelled reminder for league $leagueId');
    } catch (e, stackTrace) {
      debugPrint('Error canceling league reminder: $e');
      throw ReminderSchedulerException(
        message: 'Erro ao cancelar lembrete',
        code: 'reminder-cancel-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Cancel all league reminders
  Future<void> cancelAllReminders() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('Cancelled all reminders');
    } catch (e, stackTrace) {
      debugPrint('Error canceling all reminders: $e');
      throw ReminderSchedulerException(
        message: 'Erro ao cancelar todos os lembretes',
        code: 'reminder-cancel-all-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Reschedule all enabled reminders
  ///
  /// Useful after app restart or timezone change.
  Future<void> rescheduleAllReminders(
      Map<String, String> leagueNames) async {
    try {
      final enabledSettings =
          await _settingsRepository.getEnabledLeagueSettings();

      for (final settings in enabledSettings) {
        final leagueName = leagueNames[settings.leagueId] ?? 'Liga';
        await scheduleLeagueReminder(settings, leagueName);
      }

      debugPrint('Rescheduled ${enabledSettings.length} reminders');
    } catch (e, stackTrace) {
      debugPrint('Error rescheduling reminders: $e');
      throw ReminderSchedulerException(
        message: 'Erro ao reagendar lembretes',
        code: 'reminder-reschedule-error',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Generate a notification ID for a league
  int _getNotificationId(String leagueId) {
    return _baseNotificationId + leagueId.hashCode.abs() % 100000;
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // The payload contains 'league:leagueId'
    // Navigation can be handled by listening to this in the app
  }

  /// Create the Android notification channel
  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.defaultImportance,
    );

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Get the local timezone identifier
  String _getLocalTimezone() {
    // Try to get the local timezone, fallback to UTC
    try {
      final timeZoneName = DateTime.now().timeZoneName;
      // Map common abbreviations to IANA names
      final mapping = <String, String>{
        'BRT': 'America/Sao_Paulo',
        'BRST': 'America/Sao_Paulo',
        'GMT': 'Europe/London',
        'UTC': 'UTC',
        'EST': 'America/New_York',
        'EDT': 'America/New_York',
        'PST': 'America/Los_Angeles',
        'PDT': 'America/Los_Angeles',
      };
      return mapping[timeZoneName] ?? 'America/Sao_Paulo';
    } catch (_) {
      return 'America/Sao_Paulo';
    }
  }
}

/// Exception thrown for reminder scheduling errors
class ReminderSchedulerException extends AppException {
  const ReminderSchedulerException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
