import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/reminder_settings.dart';

/// Repository for persisting reminder settings locally
///
/// Uses SharedPreferences to store reminder configurations.
/// Settings are stored per-user and per-league.
@lazySingleton
class ReminderSettingsRepository {
  static const String _globalSettingsKey = 'global_reminder_settings';
  static const String _leagueSettingsPrefix = 'league_reminder_settings_';

  final SharedPreferences _prefs;

  ReminderSettingsRepository(this._prefs);

  /// Get global reminder settings
  GlobalReminderSettings getGlobalSettings() {
    final jsonString = _prefs.getString(_globalSettingsKey);
    if (jsonString == null) {
      return const GlobalReminderSettings.defaults();
    }
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return GlobalReminderSettings.fromJson(json);
    } catch (_) {
      return const GlobalReminderSettings.defaults();
    }
  }

  /// Save global reminder settings
  Future<void> saveGlobalSettings(GlobalReminderSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(_globalSettingsKey, jsonString);
  }

  /// Get reminder settings for a specific league
  LeagueReminderSettings getLeagueSettings(String leagueId) {
    final key = '$_leagueSettingsPrefix$leagueId';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) {
      return LeagueReminderSettings.defaults(leagueId: leagueId);
    }
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return LeagueReminderSettings.fromJson(json);
    } catch (_) {
      return LeagueReminderSettings.defaults(leagueId: leagueId);
    }
  }

  /// Save reminder settings for a specific league
  Future<void> saveLeagueSettings(LeagueReminderSettings settings) async {
    final key = '$_leagueSettingsPrefix${settings.leagueId}';
    final jsonString = jsonEncode(settings.toJson());
    await _prefs.setString(key, jsonString);
  }

  /// Get all league reminder settings
  List<LeagueReminderSettings> getAllLeagueSettings() {
    final allKeys = _prefs.getKeys();
    final leagueKeys =
        allKeys.where((key) => key.startsWith(_leagueSettingsPrefix));

    final settings = <LeagueReminderSettings>[];
    for (final key in leagueKeys) {
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          settings.add(LeagueReminderSettings.fromJson(json));
        } catch (_) {
          // Skip invalid entries
        }
      }
    }
    return settings;
  }

  /// Get all enabled league reminder settings
  List<LeagueReminderSettings> getEnabledLeagueSettings() {
    final allSettings = getAllLeagueSettings();
    return allSettings.where((s) => s.isEnabled).toList();
  }

  /// Delete reminder settings for a specific league
  Future<void> deleteLeagueSettings(String leagueId) async {
    final key = '$_leagueSettingsPrefix$leagueId';
    await _prefs.remove(key);
  }

  /// Clear all reminder settings (useful for logout)
  Future<void> clearAllSettings() async {
    await _prefs.remove(_globalSettingsKey);

    final allKeys = _prefs.getKeys();
    final leagueKeys =
        allKeys.where((key) => key.startsWith(_leagueSettingsPrefix)).toList();

    for (final key in leagueKeys) {
      await _prefs.remove(key);
    }
  }
}
