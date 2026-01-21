import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting locale preferences using SharedPreferences
@lazySingleton
class LocalePreferencesService {
  final SharedPreferences _prefs;

  static const String _localeKey = 'app_locale';

  /// Default locale when no preference is saved
  static const Locale defaultLocale = Locale('pt', 'BR');

  /// Supported locales in the app
  static const List<Locale> supportedLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];

  LocalePreferencesService(this._prefs);

  /// Gets the saved locale preference
  /// Returns defaultLocale (pt_BR) if no preference was saved
  Locale getLocale() {
    final savedValue = _prefs.getString(_localeKey);
    if (savedValue == null || savedValue.isEmpty) {
      return defaultLocale;
    }

    final parts = savedValue.split('_');
    if (parts.length == 2 && parts[0].isNotEmpty) {
      return Locale(parts[0], parts[1]);
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return Locale(parts[0]);
    }

    return defaultLocale;
  }

  /// Saves the locale preference
  Future<void> setLocale(Locale locale) async {
    final value =
        locale.countryCode != null
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;
    await _prefs.setString(_localeKey, value);
  }
}
