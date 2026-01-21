import 'dart:ui';

import 'package:injectable/injectable.dart';

import 'locale_preferences_service.dart';

/// Service that provides localized notification messages
///
/// This service allows notification services to get localized strings
/// without requiring a BuildContext. It uses the LocalePreferencesService
/// to determine the current locale and returns the appropriate message.
///
/// Example usage:
/// ```dart
/// final service = getIt<NotificationMessagesService>();
/// final title = service.checkInNotificationTitle('John');
/// final body = service.checkInNotificationBody(restaurant: 'Five Guys', leagueName: 'Burger League');
/// ```
@lazySingleton
class NotificationMessagesService {
  final LocalePreferencesService _localePreferencesService;

  NotificationMessagesService(this._localePreferencesService);

  /// Gets the current locale from preferences
  Locale get _currentLocale => _localePreferencesService.getLocale();

  /// Returns true if current locale is English
  bool get _isEnglish => _currentLocale.languageCode == 'en';

  // =====================
  // Notification Channels
  // =====================

  /// General notification channel name
  String get channelNameGeneral =>
      _isEnglish ? 'General' : 'Geral';

  /// General notification channel description
  String get channelDescriptionGeneral =>
      _isEnglish ? 'General app notifications' : 'Notificacoes gerais do aplicativo';

  /// Check-ins notification channel name
  String get channelNameCheckIns => 'Check-ins';

  /// Check-ins notification channel description
  String get channelDescriptionCheckIns =>
      _isEnglish
          ? 'Notifications about new check-ins in the league'
          : 'Notificacoes sobre novos check-ins na liga';

  /// Leagues notification channel name
  String get channelNameLeagues =>
      _isEnglish ? 'Leagues' : 'Ligas';

  /// Leagues notification channel description
  String get channelDescriptionLeagues =>
      _isEnglish
          ? 'Notifications about league invites and updates'
          : 'Notificacoes sobre convites e atualizacoes de ligas';

  /// Reminders notification channel name
  String get channelNameReminders =>
      _isEnglish ? 'Reminders' : 'Lembretes';

  /// Reminders notification channel description
  String get channelDescriptionReminders =>
      _isEnglish
          ? 'Reminders to make check-ins'
          : 'Lembretes para fazer check-in';

  /// Check-in reminders channel name (for local notifications)
  String get channelNameCheckInReminders =>
      _isEnglish ? 'Check-in Reminders' : 'Lembretes de Check-in';

  /// Check-in reminders channel description (for local notifications)
  String get channelDescriptionCheckInReminders =>
      _isEnglish
          ? 'Daily reminders to check-in at your leagues'
          : 'Lembretes diarios para fazer check-in nas suas ligas';

  // =====================
  // Reminder Notifications
  // =====================

  /// Reminder notification title
  String get reminderTitle =>
      _isEnglish ? 'Time to check-in!' : 'Hora do check-in!';

  /// Reminder notification body with league name
  String reminderBody(String leagueName) =>
      _isEnglish
          ? 'Don\'t forget to check-in at the "$leagueName" league'
          : 'Nao esqueca de fazer seu check-in na liga "$leagueName"';

  // =====================
  // Check-In Notifications
  // =====================

  /// Check-in notification title
  String checkInNotificationTitle(String userName) =>
      _isEnglish ? '$userName checked in!' : '$userName fez check-in!';

  /// Check-in notification body
  ///
  /// If [restaurantName] is provided, returns "restaurantName - leagueName"
  /// Otherwise returns "New check-in at leagueName league"
  String checkInNotificationBody({
    String? restaurantName,
    required String leagueName,
  }) {
    if (restaurantName != null && restaurantName.isNotEmpty) {
      return '$restaurantName - $leagueName';
    }
    return _isEnglish
        ? 'New check-in at $leagueName league'
        : 'Novo check-in na liga $leagueName';
  }
}
