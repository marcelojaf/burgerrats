import 'package:flutter/foundation.dart';

/// Represents the reminder settings for a specific league
///
/// Stores whether reminders are enabled and at what time they should trigger.
@immutable
class LeagueReminderSettings {
  /// The league ID these settings belong to
  final String leagueId;

  /// Whether daily reminders are enabled for this league
  final bool isEnabled;

  /// The hour (0-23) when the reminder should trigger
  final int reminderHour;

  /// The minute (0-59) when the reminder should trigger
  final int reminderMinute;

  const LeagueReminderSettings({
    required this.leagueId,
    this.isEnabled = false,
    this.reminderHour = 12,
    this.reminderMinute = 0,
  });

  /// Creates default settings for a league
  factory LeagueReminderSettings.defaults({required String leagueId}) {
    return LeagueReminderSettings(
      leagueId: leagueId,
      isEnabled: false,
      reminderHour: 12,
      reminderMinute: 0,
    );
  }

  /// Gets the formatted time string (e.g., "12:00")
  String get formattedTime {
    final hourStr = reminderHour.toString().padLeft(2, '0');
    final minuteStr = reminderMinute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Creates a copy with updated fields
  LeagueReminderSettings copyWith({
    String? leagueId,
    bool? isEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return LeagueReminderSettings(
      leagueId: leagueId ?? this.leagueId,
      isEnabled: isEnabled ?? this.isEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  /// Converts to JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'leagueId': leagueId,
      'isEnabled': isEnabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
    };
  }

  /// Creates from JSON map
  factory LeagueReminderSettings.fromJson(Map<String, dynamic> json) {
    return LeagueReminderSettings(
      leagueId: json['leagueId'] as String,
      isEnabled: json['isEnabled'] as bool? ?? false,
      reminderHour: json['reminderHour'] as int? ?? 12,
      reminderMinute: json['reminderMinute'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeagueReminderSettings &&
        other.leagueId == leagueId &&
        other.isEnabled == isEnabled &&
        other.reminderHour == reminderHour &&
        other.reminderMinute == reminderMinute;
  }

  @override
  int get hashCode =>
      Object.hash(leagueId, isEnabled, reminderHour, reminderMinute);

  @override
  String toString() {
    return 'LeagueReminderSettings(leagueId: $leagueId, isEnabled: $isEnabled, '
        'time: $formattedTime)';
  }
}

/// Global reminder settings that apply across all leagues
@immutable
class GlobalReminderSettings {
  /// Whether reminders are globally enabled
  final bool globalEnabled;

  /// Default reminder hour for new leagues
  final int defaultHour;

  /// Default reminder minute for new leagues
  final int defaultMinute;

  const GlobalReminderSettings({
    this.globalEnabled = true,
    this.defaultHour = 12,
    this.defaultMinute = 0,
  });

  /// Creates default global settings
  const GlobalReminderSettings.defaults()
      : globalEnabled = true,
        defaultHour = 12,
        defaultMinute = 0;

  /// Gets the formatted default time string
  String get formattedDefaultTime {
    final hourStr = defaultHour.toString().padLeft(2, '0');
    final minuteStr = defaultMinute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// Creates a copy with updated fields
  GlobalReminderSettings copyWith({
    bool? globalEnabled,
    int? defaultHour,
    int? defaultMinute,
  }) {
    return GlobalReminderSettings(
      globalEnabled: globalEnabled ?? this.globalEnabled,
      defaultHour: defaultHour ?? this.defaultHour,
      defaultMinute: defaultMinute ?? this.defaultMinute,
    );
  }

  /// Converts to JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'globalEnabled': globalEnabled,
      'defaultHour': defaultHour,
      'defaultMinute': defaultMinute,
    };
  }

  /// Creates from JSON map
  factory GlobalReminderSettings.fromJson(Map<String, dynamic> json) {
    return GlobalReminderSettings(
      globalEnabled: json['globalEnabled'] as bool? ?? true,
      defaultHour: json['defaultHour'] as int? ?? 12,
      defaultMinute: json['defaultMinute'] as int? ?? 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GlobalReminderSettings &&
        other.globalEnabled == globalEnabled &&
        other.defaultHour == defaultHour &&
        other.defaultMinute == defaultMinute;
  }

  @override
  int get hashCode => Object.hash(globalEnabled, defaultHour, defaultMinute);

  @override
  String toString() {
    return 'GlobalReminderSettings(globalEnabled: $globalEnabled, '
        'defaultTime: $formattedDefaultTime)';
  }
}
