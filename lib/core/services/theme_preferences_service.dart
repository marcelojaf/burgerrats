import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting theme preferences using SharedPreferences
@lazySingleton
class ThemePreferencesService {
  final SharedPreferences _prefs;

  static const String _themeModeKey = 'theme_mode';

  ThemePreferencesService(this._prefs);

  /// Gets the saved theme mode preference
  /// Returns ThemeMode.system if no preference was saved
  ThemeMode getThemeMode() {
    final savedValue = _prefs.getString(_themeModeKey);
    if (savedValue == null) {
      return ThemeMode.system;
    }

    switch (savedValue) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Saves the theme mode preference
  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await _prefs.setString(_themeModeKey, value);
  }
}
