import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../services/theme_preferences_service.dart';

/// Global app state for theme and app-wide settings
class AppState {
  /// Current theme mode
  final ThemeMode themeMode;

  /// Whether the app has completed initialization
  final bool isInitialized;

  /// Global loading state for overlay indicators
  final bool isLoading;

  /// Global error message to display
  final String? errorMessage;

  const AppState({
    this.themeMode = ThemeMode.system,
    this.isInitialized = false,
    this.isLoading = false,
    this.errorMessage,
  });

  const AppState.initial()
      : themeMode = ThemeMode.system,
        isInitialized = false,
        isLoading = false,
        errorMessage = null;

  AppState copyWith({
    ThemeMode? themeMode,
    bool? isInitialized,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppState &&
        other.themeMode == themeMode &&
        other.isInitialized == isInitialized &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(
        themeMode,
        isInitialized,
        isLoading,
        errorMessage,
      );
}

/// Notifier for global app state
class AppStateNotifier extends StateNotifier<AppState> {
  final ThemePreferencesService _themePreferencesService;

  AppStateNotifier(this._themePreferencesService)
      : super(const AppState.initial()) {
    _loadSavedThemeMode();
  }

  /// Loads the saved theme mode from SharedPreferences
  void _loadSavedThemeMode() {
    final savedThemeMode = _themePreferencesService.getThemeMode();
    state = state.copyWith(themeMode: savedThemeMode);
  }

  /// Marks the app as initialized
  void setInitialized() {
    state = state.copyWith(isInitialized: true);
  }

  /// Sets the theme mode and persists to SharedPreferences
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _themePreferencesService.setThemeMode(mode);
  }

  /// Toggles between light, dark and system theme
  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : state.themeMode == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;
    setThemeMode(newMode);
  }

  /// Shows a global loading indicator
  void showLoading() {
    state = state.copyWith(isLoading: true);
  }

  /// Hides the global loading indicator
  void hideLoading() {
    state = state.copyWith(isLoading: false);
  }

  /// Sets a global error message
  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  /// Clears the global error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for global app state
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(getIt<ThemePreferencesService>()),
);

/// Provider for current theme mode
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appStateProvider.select((state) => state.themeMode));
});

/// Provider for app initialization status
final isAppInitializedProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider.select((state) => state.isInitialized));
});

/// Provider for global loading state
final isGlobalLoadingProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider.select((state) => state.isLoading));
});

/// Provider for global error message
final globalErrorProvider = Provider<String?>((ref) {
  return ref.watch(appStateProvider.select((state) => state.errorMessage));
});
