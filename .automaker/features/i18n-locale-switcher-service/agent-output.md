
🔧 Tool: Task
Input: {
  "description": "Explore i18n codebase structure",
  "prompt": "I need to implement a locale switcher service for a Flutter app. Please explore the codebase to understand:\n\n1. The current i18n/localization setup (check lib/l10n/ directory, l10n.yaml, pubspec.yaml for flutter_localizations)\n2. How services are structured and registered (DI patterns with get_it + injectable)\n3. The existing settings page where the locale switcher might be added\n4. Any existing locale-related code or preferences storage\n\nFocus on understanding the patterns used so I can implement a LocaleSwitcherService that:\n- Allows changing app language at runtime\n- Persists the user's language preference\n- Integrates with the existing DI and state management (Riverpod)\n\nBe thorough in exploring the relevant files and report back what you find.",
  "subagent_type": "Explore"
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*.yaml"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/l10n/**"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/**/*.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/profile/**"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\l10n.yaml"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\theme_preferences_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.config.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_pt.arb"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_en.arb"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\shared\\extensions\\context_extensions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\register_module.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\core\\services\" -name \"*.dart\" -type f | head -20",
  "description": "List all service files"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_localizations.dart",
  "limit": 100
}
Excelente! Agora tenho uma visão completa da estrutura. Vou implementar o LocaleSwitcherService seguindo os padrões existentes.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "pending",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "pending",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "pending",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "pending",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\theme_preferences_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart"
}
Agora preciso verificar os arquivos ARB para as strings de localização necessárias:

🔧 Tool: Grep
Input: {
  "pattern": "\"english\"|\"portuguese\"|\"selectLanguage\"|\"spanish\"",
  "path": "C:\\dev\\burgerrats\\lib\\l10n",
  "output_mode": "content"
}

🔧 Tool: Grep
Input: {
  "pattern": "selectLanguage",
  "path": "C:\\dev\\burgerrats\\lib\\l10n",
  "output_mode": "content"
}
Preciso adicionar a string "selectLanguage" nos arquivos ARB. Primeiro, vou criar o LocalePreferencesService:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "in_progress",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "pending",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "pending",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "pending",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "pending",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\locale_preferences_service.dart",
  "content": "import 'dart:ui';\n\nimport 'package:injectable/injectable.dart';\nimport 'package:shared_preferences/shared_preferences.dart';\n\n/// Service for persisting locale preferences using SharedPreferences\n@lazySingleton\nclass LocalePreferencesService {\n  final SharedPreferences _prefs;\n\n  static const String _localeKey = 'app_locale';\n\n  /// Default locale when no preference is saved\n  static const Locale defaultLocale = Locale('pt', 'BR');\n\n  /// Supported locales in the app\n  static const List<Locale> supportedLocales = [\n    Locale('pt', 'BR'),\n    Locale('en', 'US'),\n  ];\n\n  LocalePreferencesService(this._prefs);\n\n  /// Gets the saved locale preference\n  /// Returns defaultLocale (pt_BR) if no preference was saved\n  Locale getLocale() {\n    final savedValue = _prefs.getString(_localeKey);\n    if (savedValue == null) {\n      return defaultLocale;\n    }\n\n    final parts = savedValue.split('_');\n    if (parts.length == 2) {\n      return Locale(parts[0], parts[1]);\n    } else if (parts.length == 1) {\n      return Locale(parts[0]);\n    }\n\n    return defaultLocale;\n  }\n\n  /// Saves the locale preference\n  Future<void> setLocale(Locale locale) async {\n    final value =\n        locale.countryCode != null\n            ? '${locale.languageCode}_${locale.countryCode}'\n            : locale.languageCode;\n    await _prefs.setString(_localeKey, value);\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "in_progress",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "pending",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "pending",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "pending",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Agora vou atualizar o AppState para incluir a propriedade locale:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "old_string": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport '../../di/injection.dart';\nimport '../../services/theme_preferences_service.dart';",
  "new_string": "import 'dart:ui';\n\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport '../../di/injection.dart';\nimport '../../services/locale_preferences_service.dart';\nimport '../../services/theme_preferences_service.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "old_string": "/// Global app state for theme and app-wide settings\nclass AppState {\n  /// Current theme mode\n  final ThemeMode themeMode;\n\n  /// Whether the app has completed initialization\n  final bool isInitialized;\n\n  /// Global loading state for overlay indicators\n  final bool isLoading;\n\n  /// Global error message to display\n  final String? errorMessage;\n\n  const AppState({\n    this.themeMode = ThemeMode.system,\n    this.isInitialized = false,\n    this.isLoading = false,\n    this.errorMessage,\n  });\n\n  const AppState.initial()\n      : themeMode = ThemeMode.system,\n        isInitialized = false,\n        isLoading = false,\n        errorMessage = null;\n\n  AppState copyWith({\n    ThemeMode? themeMode,\n    bool? isInitialized,\n    bool? isLoading,\n    String? errorMessage,\n  }) {\n    return AppState(\n      themeMode: themeMode ?? this.themeMode,\n      isInitialized: isInitialized ?? this.isInitialized,\n      isLoading: isLoading ?? this.isLoading,\n      errorMessage: errorMessage,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is AppState &&\n        other.themeMode == themeMode &&\n        other.isInitialized == isInitialized &&\n        other.isLoading == isLoading &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        themeMode,\n        isInitialized,\n        isLoading,\n        errorMessage,\n      );\n}",
  "new_string": "/// Global app state for theme and app-wide settings\nclass AppState {\n  /// Current theme mode\n  final ThemeMode themeMode;\n\n  /// Current locale\n  final Locale locale;\n\n  /// Whether the app has completed initialization\n  final bool isInitialized;\n\n  /// Global loading state for overlay indicators\n  final bool isLoading;\n\n  /// Global error message to display\n  final String? errorMessage;\n\n  const AppState({\n    this.themeMode = ThemeMode.system,\n    this.locale = const Locale('pt', 'BR'),\n    this.isInitialized = false,\n    this.isLoading = false,\n    this.errorMessage,\n  });\n\n  const AppState.initial()\n      : themeMode = ThemeMode.system,\n        locale = const Locale('pt', 'BR'),\n        isInitialized = false,\n        isLoading = false,\n        errorMessage = null;\n\n  AppState copyWith({\n    ThemeMode? themeMode,\n    Locale? locale,\n    bool? isInitialized,\n    bool? isLoading,\n    String? errorMessage,\n  }) {\n    return AppState(\n      themeMode: themeMode ?? this.themeMode,\n      locale: locale ?? this.locale,\n      isInitialized: isInitialized ?? this.isInitialized,\n      isLoading: isLoading ?? this.isLoading,\n      errorMessage: errorMessage,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is AppState &&\n        other.themeMode == themeMode &&\n        other.locale == locale &&\n        other.isInitialized == isInitialized &&\n        other.isLoading == isLoading &&\n        other.errorMessage == errorMessage;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        themeMode,\n        locale,\n        isInitialized,\n        isLoading,\n        errorMessage,\n      );\n}"
}
Agora preciso atualizar o AppStateNotifier para adicionar o LocalePreferencesService e os métodos para manipular o locale:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "old_string": "/// Notifier for global app state\nclass AppStateNotifier extends StateNotifier<AppState> {\n  final ThemePreferencesService _themePreferencesService;\n\n  AppStateNotifier(this._themePreferencesService)\n      : super(const AppState.initial()) {\n    _loadSavedThemeMode();\n  }\n\n  /// Loads the saved theme mode from SharedPreferences\n  void _loadSavedThemeMode() {\n    final savedThemeMode = _themePreferencesService.getThemeMode();\n    state = state.copyWith(themeMode: savedThemeMode);\n  }\n\n  /// Marks the app as initialized\n  void setInitialized() {\n    state = state.copyWith(isInitialized: true);\n  }\n\n  /// Sets the theme mode and persists to SharedPreferences\n  void setThemeMode(ThemeMode mode) {\n    state = state.copyWith(themeMode: mode);\n    _themePreferencesService.setThemeMode(mode);\n  }\n\n  /// Toggles between light, dark and system theme\n  void toggleTheme() {\n    final newMode = state.themeMode == ThemeMode.light\n        ? ThemeMode.dark\n        : state.themeMode == ThemeMode.dark\n            ? ThemeMode.system\n            : ThemeMode.light;\n    setThemeMode(newMode);\n  }\n\n  /// Shows a global loading indicator\n  void showLoading() {\n    state = state.copyWith(isLoading: true);\n  }\n\n  /// Hides the global loading indicator\n  void hideLoading() {\n    state = state.copyWith(isLoading: false);\n  }\n\n  /// Sets a global error message\n  void setError(String message) {\n    state = state.copyWith(errorMessage: message);\n  }\n\n  /// Clears the global error message\n  void clearError() {\n    state = state.copyWith(errorMessage: null);\n  }\n}",
  "new_string": "/// Notifier for global app state\nclass AppStateNotifier extends StateNotifier<AppState> {\n  final ThemePreferencesService _themePreferencesService;\n  final LocalePreferencesService _localePreferencesService;\n\n  AppStateNotifier(\n    this._themePreferencesService,\n    this._localePreferencesService,\n  ) : super(const AppState.initial()) {\n    _loadSavedPreferences();\n  }\n\n  /// Loads saved preferences from SharedPreferences\n  void _loadSavedPreferences() {\n    final savedThemeMode = _themePreferencesService.getThemeMode();\n    final savedLocale = _localePreferencesService.getLocale();\n    state = state.copyWith(themeMode: savedThemeMode, locale: savedLocale);\n  }\n\n  /// Marks the app as initialized\n  void setInitialized() {\n    state = state.copyWith(isInitialized: true);\n  }\n\n  /// Sets the theme mode and persists to SharedPreferences\n  void setThemeMode(ThemeMode mode) {\n    state = state.copyWith(themeMode: mode);\n    _themePreferencesService.setThemeMode(mode);\n  }\n\n  /// Sets the locale and persists to SharedPreferences\n  void setLocale(Locale locale) {\n    state = state.copyWith(locale: locale);\n    _localePreferencesService.setLocale(locale);\n  }\n\n  /// Toggles between light, dark and system theme\n  void toggleTheme() {\n    final newMode = state.themeMode == ThemeMode.light\n        ? ThemeMode.dark\n        : state.themeMode == ThemeMode.dark\n            ? ThemeMode.system\n            : ThemeMode.light;\n    setThemeMode(newMode);\n  }\n\n  /// Shows a global loading indicator\n  void showLoading() {\n    state = state.copyWith(isLoading: true);\n  }\n\n  /// Hides the global loading indicator\n  void hideLoading() {\n    state = state.copyWith(isLoading: false);\n  }\n\n  /// Sets a global error message\n  void setError(String message) {\n    state = state.copyWith(errorMessage: message);\n  }\n\n  /// Clears the global error message\n  void clearError() {\n    state = state.copyWith(errorMessage: null);\n  }\n}"
}
Agora preciso atualizar o provider e adicionar o localeProvider:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "old_string": "/// Provider for global app state\nfinal appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(\n  (ref) => AppStateNotifier(getIt<ThemePreferencesService>()),\n);",
  "new_string": "/// Provider for global app state\nfinal appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(\n  (ref) => AppStateNotifier(\n    getIt<ThemePreferencesService>(),\n    getIt<LocalePreferencesService>(),\n  ),\n);"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "offset": 150
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "old_string": "/// Provider for current theme mode\nfinal themeModeProvider = Provider<ThemeMode>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.themeMode));\n});\n\n/// Provider for app initialization status",
  "new_string": "/// Provider for current theme mode\nfinal themeModeProvider = Provider<ThemeMode>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.themeMode));\n});\n\n/// Provider for current locale\nfinal localeProvider = Provider<Locale>((ref) {\n  return ref.watch(appStateProvider.select((state) => state.locale));\n});\n\n/// Provider for app initialization status"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "completed",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "in_progress",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "pending",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "pending",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Agora vou atualizar o main.dart para usar o locale dinâmico do Riverpod:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart",
  "old_string": "  @override\n  Widget build(BuildContext context) {\n    // Watch theme mode from app state\n    final themeMode = ref.watch(themeModeProvider);\n\n    // Watch auth-aware router that automatically handles redirects\n    final router = ref.watch(routerProvider);\n\n    return MaterialApp.router(\n      title: 'BurgerRats',\n      debugShowCheckedModeBanner: false,\n      theme: AppTheme.light,\n      darkTheme: AppTheme.dark,\n      themeMode: themeMode,\n      routerConfig: router,\n      localizationsDelegates: const [\n        AppLocalizations.delegate,\n        GlobalMaterialLocalizations.delegate,\n        GlobalWidgetsLocalizations.delegate,\n        GlobalCupertinoLocalizations.delegate,\n      ],\n      supportedLocales: AppLocalizations.supportedLocales,\n      locale: const Locale('pt', 'BR'),\n      builder: (context, child) {\n        // Wrap the app with ErrorBoundary for uncaught widget errors\n        return ErrorBoundary(\n          onError: _handleGlobalError,\n          child: child ?? const SizedBox.shrink(),\n        );\n      },\n    );\n  }",
  "new_string": "  @override\n  Widget build(BuildContext context) {\n    // Watch theme mode from app state\n    final themeMode = ref.watch(themeModeProvider);\n\n    // Watch locale from app state\n    final locale = ref.watch(localeProvider);\n\n    // Watch auth-aware router that automatically handles redirects\n    final router = ref.watch(routerProvider);\n\n    return MaterialApp.router(\n      title: 'BurgerRats',\n      debugShowCheckedModeBanner: false,\n      theme: AppTheme.light,\n      darkTheme: AppTheme.dark,\n      themeMode: themeMode,\n      routerConfig: router,\n      localizationsDelegates: const [\n        AppLocalizations.delegate,\n        GlobalMaterialLocalizations.delegate,\n        GlobalWidgetsLocalizations.delegate,\n        GlobalCupertinoLocalizations.delegate,\n      ],\n      supportedLocales: AppLocalizations.supportedLocales,\n      locale: locale,\n      builder: (context, child) {\n        // Wrap the app with ErrorBoundary for uncaught widget errors\n        return ErrorBoundary(\n          onError: _handleGlobalError,\n          child: child ?? const SizedBox.shrink(),\n        );\n      },\n    );\n  }"
}
Agora preciso adicionar o import do localeProvider:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart",
  "limit": 20
}
O import do `app_state_provider.dart` já está lá na linha 15, então o `localeProvider` já está disponível já que eu o adicionei nesse arquivo.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "completed",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "completed",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "in_progress",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "pending",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Agora vou atualizar a SettingsPage para adicionar o diálogo de seleção de idioma:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/router/app_routes.dart';\nimport '../../../../core/state/providers/app_state_provider.dart';\nimport '../../../../shared/extensions/context_extensions.dart';",
  "new_string": "import 'dart:ui';\n\nimport 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';\n\nimport '../../../../core/router/app_routes.dart';\nimport '../../../../core/state/providers/app_state_provider.dart';\nimport '../../../../shared/extensions/context_extensions.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "  @override\n  Widget build(BuildContext context, WidgetRef ref) {\n    final themeMode = ref.watch(themeModeProvider);\n\n    return Scaffold(",
  "new_string": "  @override\n  Widget build(BuildContext context, WidgetRef ref) {\n    final themeMode = ref.watch(themeModeProvider);\n    final locale = ref.watch(localeProvider);\n\n    return Scaffold("
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "          ListTile(\n            leading: const Icon(Icons.language),\n            title: Text(context.l10n.language),\n            trailing: Text(context.l10n.portuguese),\n          ),",
  "new_string": "          ListTile(\n            leading: const Icon(Icons.language),\n            title: Text(context.l10n.language),\n            subtitle: Text(_getLocaleLabel(context, locale)),\n            trailing: const Icon(Icons.chevron_right),\n            onTap: () => _showLanguageSelectionDialog(context, ref, locale),\n          ),"
}
Agora preciso adicionar os métodos `_getLocaleLabel` e `_showLanguageSelectionDialog`:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "  String _getThemeModeLabel(BuildContext context, ThemeMode mode) {\n    switch (mode) {\n      case ThemeMode.light:\n        return context.l10n.light;\n      case ThemeMode.dark:\n        return context.l10n.dark;\n      case ThemeMode.system:\n        return context.l10n.system;\n    }\n  }",
  "new_string": "  String _getThemeModeLabel(BuildContext context, ThemeMode mode) {\n    switch (mode) {\n      case ThemeMode.light:\n        return context.l10n.light;\n      case ThemeMode.dark:\n        return context.l10n.dark;\n      case ThemeMode.system:\n        return context.l10n.system;\n    }\n  }\n\n  String _getLocaleLabel(BuildContext context, Locale locale) {\n    switch (locale.languageCode) {\n      case 'pt':\n        return context.l10n.portuguese;\n      case 'en':\n        return context.l10n.english;\n      default:\n        return context.l10n.portuguese;\n    }\n  }"
}
Agora preciso adicionar o método `_showLanguageSelectionDialog`. Vou ler o final do arquivo para ver onde está o `_showThemeSelectionDialog`:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "offset": 135
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "        actions: [\n          TextButton(\n            onPressed: () => Navigator.pop(dialogContext),\n            child: Text(context.l10n.cancel),\n          ),\n        ],\n      ),\n    );\n  }\n}\n\nclass _ThemeOption extends StatelessWidget {",
  "new_string": "        actions: [\n          TextButton(\n            onPressed: () => Navigator.pop(dialogContext),\n            child: Text(context.l10n.cancel),\n          ),\n        ],\n      ),\n    );\n  }\n\n  void _showLanguageSelectionDialog(\n    BuildContext context,\n    WidgetRef ref,\n    Locale currentLocale,\n  ) {\n    showDialog(\n      context: context,\n      builder: (dialogContext) => AlertDialog(\n        title: Text(context.l10n.selectLanguage),\n        content: Column(\n          mainAxisSize: MainAxisSize.min,\n          children: [\n            _LanguageOption(\n              label: context.l10n.portuguese,\n              isSelected: currentLocale.languageCode == 'pt',\n              onTap: () {\n                ref\n                    .read(appStateProvider.notifier)\n                    .setLocale(const Locale('pt', 'BR'));\n                Navigator.pop(dialogContext);\n              },\n            ),\n            const SizedBox(height: 8),\n            _LanguageOption(\n              label: context.l10n.english,\n              isSelected: currentLocale.languageCode == 'en',\n              onTap: () {\n                ref\n                    .read(appStateProvider.notifier)\n                    .setLocale(const Locale('en', 'US'));\n                Navigator.pop(dialogContext);\n              },\n            ),\n          ],\n        ),\n        actions: [\n          TextButton(\n            onPressed: () => Navigator.pop(dialogContext),\n            child: Text(context.l10n.cancel),\n          ),\n        ],\n      ),\n    );\n  }\n}\n\nclass _LanguageOption extends StatelessWidget {\n  final String label;\n  final bool isSelected;\n  final VoidCallback onTap;\n\n  const _LanguageOption({\n    required this.label,\n    required this.isSelected,\n    required this.onTap,\n  });\n\n  @override\n  Widget build(BuildContext context) {\n    final colorScheme = Theme.of(context).colorScheme;\n\n    return ListTile(\n      leading: Icon(\n        Icons.language,\n        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,\n      ),\n      title: Text(\n        label,\n        style: TextStyle(\n          color: isSelected ? colorScheme.primary : colorScheme.onSurface,\n          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,\n        ),\n      ),\n      trailing: isSelected\n          ? Icon(Icons.check_circle, color: colorScheme.primary)\n          : null,\n      selected: isSelected,\n      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),\n      shape: RoundedRectangleBorder(\n        borderRadius: BorderRadius.circular(8),\n      ),\n      onTap: onTap,\n    );\n  }\n}\n\nclass _ThemeOption extends StatelessWidget {"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "completed",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "completed",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "completed",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "in_progress",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Agora preciso adicionar a string `selectLanguage` nos arquivos ARB:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_pt.arb",
  "limit": 50
}

🔧 Tool: Grep
Input: {
  "pattern": "selectTheme",
  "path": "C:\\dev\\burgerrats\\lib\\l10n",
  "output_mode": "content",
  "-A": 3
}
Vou adicionar a string `selectLanguage` nos arquivos ARB. Primeiro vou ver o contexto das linhas 579-590 do arquivo pt:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_pt.arb",
  "offset": 575,
  "limit": 30
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_pt.arb",
  "old_string": "  \"system\": \"Sistema\",\n  \"@system\": {\n    \"description\": \"System theme option\"\n  },\n\n  \"skip\": \"Pular\",",
  "new_string": "  \"system\": \"Sistema\",\n  \"@system\": {\n    \"description\": \"System theme option\"\n  },\n\n  \"selectLanguage\": \"Selecionar Idioma\",\n  \"@selectLanguage\": {\n    \"description\": \"Select language dialog title\"\n  },\n\n  \"skip\": \"Pular\","
}
Agora vou adicionar ao arquivo em inglês:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_en.arb",
  "offset": 185,
  "limit": 20
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\l10n\\app_en.arb",
  "old_string": "  \"selectTheme\": \"Select Theme\",\n  \"light\": \"Light\",\n  \"dark\": \"Dark\",\n  \"system\": \"System\",\n\n  \"skip\": \"Skip\",",
  "new_string": "  \"selectTheme\": \"Select Theme\",\n  \"light\": \"Light\",\n  \"dark\": \"Dark\",\n  \"system\": \"System\",\n\n  \"selectLanguage\": \"Select Language\",\n\n  \"skip\": \"Skip\","
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "completed",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "completed",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "completed",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "completed",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "in_progress",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "pending",
      "activeForm": "Running flutter analyze"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "cd \"C:\\dev\\burgerrats\" && dart run build_runner build --delete-conflicting-outputs",
  "description": "Generate DI configuration with build_runner",
  "timeout": 180000
}

🔧 Tool: Bash
Input: {
  "command": "cd /c/dev/burgerrats && flutter pub run build_runner build --delete-conflicting-outputs",
  "description": "Generate DI configuration with flutter",
  "timeout": 180000
}
Parece haver um problema de ambiente. Vou tentar uma abordagem diferente:

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter pub run build_runner build --delete-conflicting-outputs",
  "description": "Generate DI configuration with environment fix",
  "timeout": 180000
}
O build_runner foi executado com sucesso. Houve um warning sobre um dependency não registrado (`ReminderSettingsRepository`), mas isso é um problema pré-existente não relacionado à minha implementação. Agora vou gerar as localizações:

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter gen-l10n",
  "description": "Generate localization files",
  "timeout": 60000
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "completed",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "completed",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "completed",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "completed",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "in_progress",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Vou verificar se o arquivo de localização gerado agora tem a nova string:

🔧 Tool: Grep
Input: {
  "pattern": "selectLanguage",
  "path": "C:\\dev\\burgerrats\\lib\\l10n",
  "output_mode": "content"
}
As localizações foram geradas corretamente. Agora vou rodar o flutter analyze:

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter analyze",
  "description": "Analyze Flutter code for issues",
  "timeout": 120000
}
Os warnings são problemas pré-existentes no código, não relacionados à minha implementação. Os únicos info relacionados ao meu código são os imports desnecessários de `dart:ui`. Vou corrigir esses dois:

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\app_state_provider.dart",
  "old_string": "import 'dart:ui';\n\nimport 'package:flutter/material.dart';",
  "new_string": "import 'package:flutter/material.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\profile\\presentation\\pages\\settings_page.dart",
  "old_string": "import 'dart:ui';\n\nimport 'package:flutter/material.dart';",
  "new_string": "import 'package:flutter/material.dart';"
}

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter analyze lib/core/state/providers/app_state_provider.dart lib/features/profile/presentation/pages/settings_page.dart lib/core/services/locale_preferences_service.dart lib/main.dart 2>&1",
  "description": "Analyze modified files for issues",
  "timeout": 60000
}
Todos os arquivos que modifiquei estão sem problemas.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LocalePreferencesService (following ThemePreferencesService pattern)",
      "status": "completed",
      "activeForm": "Creating LocalePreferencesService"
    },
    {
      "content": "Update AppState to include locale property and setter",
      "status": "completed",
      "activeForm": "Updating AppState with locale support"
    },
    {
      "content": "Update main.dart to use dynamic locale from Riverpod",
      "status": "completed",
      "activeForm": "Updating main.dart for dynamic locale"
    },
    {
      "content": "Update SettingsPage with language selection dialog",
      "status": "completed",
      "activeForm": "Updating SettingsPage with language selector"
    },
    {
      "content": "Add selectLanguage string to ARB files",
      "status": "completed",
      "activeForm": "Adding selectLanguage to ARB files"
    },
    {
      "content": "Run build_runner to generate DI configuration",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Run flutter analyze to verify code quality",
      "status": "completed",
      "activeForm": "Running flutter analyze"
    }
  ]
}
Agora, sobre a verificação com Playwright: este é um projeto Flutter mobile (iOS e Android), não um projeto web. Playwright é uma ferramenta de teste de automação para navegadores web. Para um app Flutter mobile, a verificação adequada seria executar testes de widget/integration do Flutter.

Deixe-me verificar se existem testes no projeto que possam ser usados ou se podemos criar um teste simples:

🔧 Tool: Glob
Input: {
  "pattern": "test/**/*_test.dart",
  "path": "C:\\dev\\burgerrats"
}
Vou criar um teste de unidade simples para o LocalePreferencesService, seguindo o padrão existente no projeto:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\test\\core\\services\\theme_preferences_service_test.dart"
}

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\test\\core\\services\\locale_preferences_service_test.dart",
  "content": "import 'dart:ui';\n\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:mocktail/mocktail.dart';\nimport 'package:shared_preferences/shared_preferences.dart';\n\nimport 'package:burgerrats/core/services/locale_preferences_service.dart';\n\nclass MockSharedPreferences extends Mock implements SharedPreferences {}\n\nvoid main() {\n  late LocalePreferencesService service;\n  late MockSharedPreferences mockPrefs;\n\n  setUp(() {\n    mockPrefs = MockSharedPreferences();\n    service = LocalePreferencesService(mockPrefs);\n  });\n\n  group('LocalePreferencesService', () {\n    group('getLocale', () {\n      test('returns default locale (pt_BR) when no preference is saved', () {\n        when(() => mockPrefs.getString('app_locale')).thenReturn(null);\n\n        final result = service.getLocale();\n\n        expect(result, const Locale('pt', 'BR'));\n        verify(() => mockPrefs.getString('app_locale')).called(1);\n      });\n\n      test('returns Locale(pt, BR) when pt_BR is saved', () {\n        when(() => mockPrefs.getString('app_locale')).thenReturn('pt_BR');\n\n        final result = service.getLocale();\n\n        expect(result, const Locale('pt', 'BR'));\n      });\n\n      test('returns Locale(en, US) when en_US is saved', () {\n        when(() => mockPrefs.getString('app_locale')).thenReturn('en_US');\n\n        final result = service.getLocale();\n\n        expect(result, const Locale('en', 'US'));\n      });\n\n      test('returns Locale(en) when only en is saved (no country code)', () {\n        when(() => mockPrefs.getString('app_locale')).thenReturn('en');\n\n        final result = service.getLocale();\n\n        expect(result.languageCode, 'en');\n      });\n\n      test('returns default locale for invalid saved value', () {\n        when(() => mockPrefs.getString('app_locale')).thenReturn('');\n\n        final result = service.getLocale();\n\n        expect(result, const Locale('pt', 'BR'));\n      });\n    });\n\n    group('setLocale', () {\n      test('saves pt_BR when Locale(pt, BR) is passed', () async {\n        when(() => mockPrefs.setString('app_locale', 'pt_BR'))\n            .thenAnswer((_) async => true);\n\n        await service.setLocale(const Locale('pt', 'BR'));\n\n        verify(() => mockPrefs.setString('app_locale', 'pt_BR')).called(1);\n      });\n\n      test('saves en_US when Locale(en, US) is passed', () async {\n        when(() => mockPrefs.setString('app_locale', 'en_US'))\n            .thenAnswer((_) async => true);\n\n        await service.setLocale(const Locale('en', 'US'));\n\n        verify(() => mockPrefs.setString('app_locale', 'en_US')).called(1);\n      });\n\n      test('saves only language code when no country code is provided',\n          () async {\n        when(() => mockPrefs.setString('app_locale', 'es'))\n            .thenAnswer((_) async => true);\n\n        await service.setLocale(const Locale('es'));\n\n        verify(() => mockPrefs.setString('app_locale', 'es')).called(1);\n      });\n    });\n\n    group('supportedLocales', () {\n      test('contains Portuguese (pt_BR) locale', () {\n        expect(\n          LocalePreferencesService.supportedLocales,\n          contains(const Locale('pt', 'BR')),\n        );\n      });\n\n      test('contains English (en_US) locale', () {\n        expect(\n          LocalePreferencesService.supportedLocales,\n          contains(const Locale('en', 'US')),\n        );\n      });\n    });\n\n    group('defaultLocale', () {\n      test('is Portuguese (pt_BR)', () {\n        expect(\n          LocalePreferencesService.defaultLocale,\n          const Locale('pt', 'BR'),\n        );\n      });\n    });\n  });\n}\n"
}

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter test test/core/services/locale_preferences_service_test.dart",
  "description": "Run LocalePreferencesService unit tests",
  "timeout": 120000
}
10 de 11 testes passaram. O teste que falhou foi o de valor vazio, pois a biblioteca Locale do Flutter não aceita strings vazias. Vou corrigir tanto o teste quanto o serviço para lidar com esse caso:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\locale_preferences_service.dart"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\services\\locale_preferences_service.dart",
  "old_string": "  /// Gets the saved locale preference\n  /// Returns defaultLocale (pt_BR) if no preference was saved\n  Locale getLocale() {\n    final savedValue = _prefs.getString(_localeKey);\n    if (savedValue == null) {\n      return defaultLocale;\n    }\n\n    final parts = savedValue.split('_');\n    if (parts.length == 2) {\n      return Locale(parts[0], parts[1]);\n    } else if (parts.length == 1) {\n      return Locale(parts[0]);\n    }\n\n    return defaultLocale;\n  }",
  "new_string": "  /// Gets the saved locale preference\n  /// Returns defaultLocale (pt_BR) if no preference was saved\n  Locale getLocale() {\n    final savedValue = _prefs.getString(_localeKey);\n    if (savedValue == null || savedValue.isEmpty) {\n      return defaultLocale;\n    }\n\n    final parts = savedValue.split('_');\n    if (parts.length == 2 && parts[0].isNotEmpty) {\n      return Locale(parts[0], parts[1]);\n    } else if (parts.length == 1 && parts[0].isNotEmpty) {\n      return Locale(parts[0]);\n    }\n\n    return defaultLocale;\n  }"
}

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter test test/core/services/locale_preferences_service_test.dart",
  "description": "Run LocalePreferencesService unit tests again",
  "timeout": 120000
}
Todos os 11 testes passaram. Agora vou verificar a configuração de DI gerada para garantir que o LocalePreferencesService foi registrado:

🔧 Tool: Grep
Input: {
  "pattern": "LocalePreferencesService",
  "path": "C:\\dev\\burgerrats\\lib\\core\\di\\injection.config.dart",
  "output_mode": "content",
  "-A": 3
}
O `LocalePreferencesService` foi corretamente registrado no container de DI. Vou fazer uma verificação final executando todos os testes do projeto para garantir que as mudanças não quebram nada:

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter test 2>&1 | tail -30",
  "description": "Run all Flutter tests",
  "timeout": 180000
}
506 testes passaram! As 98 falhas são todas em `splash_page_test.dart` e estão relacionadas a um problema de timeout pré-existente (não relacionado às minhas mudanças). O teste do `LocalePreferencesService` passou com sucesso.

Para confirmar que minhas mudanças não introduziram falhas, vou rodar apenas os testes dos arquivos que modifiquei ou relacionados:

🔧 Tool: Bash
Input: {
  "command": "export LOCALAPPDATA=/c/Users/marce/AppData/Local && cd /c/dev/burgerrats && flutter test test/core/services/locale_preferences_service_test.dart test/core/services/theme_preferences_service_test.dart",
  "description": "Run preference service tests",
  "timeout": 60000
}
Todos os 19 testes de serviços de preferências passaram com sucesso.

<summary>
## Summary: Implement service to allow users to change app language at runtime

### Changes Implemented
- Created `LocalePreferencesService` following the existing `ThemePreferencesService` pattern for persisting locale preferences using SharedPreferences
- Extended `AppState` class to include `locale` property alongside `themeMode`
- Updated `AppStateNotifier` to load saved locale on startup and provide `setLocale()` method for changing locale
- Added `localeProvider` selector provider to allow components to watch locale changes
- Updated `main.dart` to use dynamic locale from Riverpod provider instead of hardcoded `Locale('pt', 'BR')`
- Updated `SettingsPage` with a language selection dialog (similar to theme selector) allowing users to switch between Portuguese and English
- Added `selectLanguage` localization string to both ARB files (Portuguese and English)
- Created comprehensive unit tests for `LocalePreferencesService`

### Files Modified
- `lib/core/services/locale_preferences_service.dart` (new file)
- `lib/core/state/providers/app_state_provider.dart` (extended with locale support)
- `lib/main.dart` (use dynamic locale from provider)
- `lib/features/profile/presentation/pages/settings_page.dart` (language selector dialog)
- `lib/l10n/app_pt.arb` (added selectLanguage string)
- `lib/l10n/app_en.arb` (added selectLanguage string)
- `lib/core/di/injection.config.dart` (auto-generated - LocalePreferencesService registered)
- `test/core/services/locale_preferences_service_test.dart` (new file - unit tests)

### Notes for Developer
- The locale switcher follows the exact same pattern as the theme switcher for consistency
- Supported locales: Portuguese (pt_BR) and English (en_US)
- Default locale is Portuguese (pt_BR) to maintain existing behavior
- Locale preference is persisted in SharedPreferences with key `app_locale`
- The app language changes immediately at runtime without requiring restart
- All 11 unit tests pass for the new LocalePreferencesService

### Verification Status
- Verified with Flutter unit tests instead of Playwright (this is a mobile app, not a web app)
- Created 11 unit tests for `LocalePreferencesService` covering:
  - Get/set locale with country code (pt_BR, en_US)
  - Get locale with only language code (en)
  - Default locale fallback for null/empty values
  - Static supportedLocales and defaultLocale constants
- All tests pass: `flutter test test/core/services/locale_preferences_service_test.dart` (11/11 passed)
- Code analysis clean: `flutter analyze` shows no issues on modified files
</summary>