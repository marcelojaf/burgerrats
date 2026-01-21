import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/reminder_scheduler_service.dart';
import '../../data/repositories/reminder_settings_repository.dart';
import '../../domain/entities/reminder_settings.dart';

/// Provider for the ReminderSettingsRepository singleton
final reminderSettingsRepositoryProvider =
    Provider<ReminderSettingsRepository>((ref) {
  return getIt<ReminderSettingsRepository>();
});

/// Provider for the ReminderSchedulerService singleton
final reminderSchedulerServiceProvider =
    Provider<ReminderSchedulerService>((ref) {
  return getIt<ReminderSchedulerService>();
});

/// Provider for global reminder settings
final globalReminderSettingsProvider =
    FutureProvider<GlobalReminderSettings>((ref) async {
  final repository = ref.watch(reminderSettingsRepositoryProvider);
  return repository.getGlobalSettings();
});

/// Provider for a specific league's reminder settings
final leagueReminderSettingsProvider = FutureProvider.family
    .autoDispose<LeagueReminderSettings, String>((ref, leagueId) async {
  final repository = ref.watch(reminderSettingsRepositoryProvider);
  return repository.getLeagueSettings(leagueId);
});

/// Provider for all league reminder settings
final allLeagueReminderSettingsProvider =
    FutureProvider<List<LeagueReminderSettings>>((ref) async {
  final repository = ref.watch(reminderSettingsRepositoryProvider);
  return repository.getAllLeagueSettings();
});

/// Provider for enabled league reminder settings
final enabledLeagueReminderSettingsProvider =
    FutureProvider<List<LeagueReminderSettings>>((ref) async {
  final repository = ref.watch(reminderSettingsRepositoryProvider);
  return repository.getEnabledLeagueSettings();
});

/// State class for reminder settings UI
class ReminderSettingsState {
  final LeagueReminderSettings settings;
  final bool isLoading;
  final String? errorMessage;

  const ReminderSettingsState({
    required this.settings,
    this.isLoading = false,
    this.errorMessage,
  });

  ReminderSettingsState copyWith({
    LeagueReminderSettings? settings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReminderSettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// StateNotifier for managing a league's reminder settings
class LeagueReminderSettingsNotifier
    extends StateNotifier<ReminderSettingsState> {
  final ReminderSettingsRepository _repository;
  final ReminderSchedulerService _schedulerService;
  final String leagueId;
  final String leagueName;

  LeagueReminderSettingsNotifier({
    required ReminderSettingsRepository repository,
    required ReminderSchedulerService schedulerService,
    required this.leagueId,
    required this.leagueName,
  })  : _repository = repository,
        _schedulerService = schedulerService,
        super(ReminderSettingsState(
          settings: LeagueReminderSettings.defaults(leagueId: leagueId),
        )) {
    _loadSettings();
  }

  void _loadSettings() {
    state = state.copyWith(isLoading: true);
    try {
      final settings = _repository.getLeagueSettings(leagueId);
      state = ReminderSettingsState(settings: settings);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar configuracoes',
      );
    }
  }

  /// Toggle reminder enabled/disabled
  Future<void> toggleEnabled() async {
    final newSettings = state.settings.copyWith(
      isEnabled: !state.settings.isEnabled,
    );
    await _updateSettings(newSettings);
  }

  /// Update the reminder time
  Future<void> updateTime(TimeOfDay time) async {
    final newSettings = state.settings.copyWith(
      reminderHour: time.hour,
      reminderMinute: time.minute,
    );
    await _updateSettings(newSettings);
  }

  /// Update settings and schedule/cancel reminder
  Future<void> _updateSettings(LeagueReminderSettings newSettings) async {
    state = state.copyWith(isLoading: true);
    try {
      // Save settings first
      await _repository.saveLeagueSettings(newSettings);

      // Schedule or cancel the reminder
      if (newSettings.isEnabled) {
        await _schedulerService.scheduleLeagueReminder(newSettings, leagueName);
      } else {
        await _schedulerService.cancelLeagueReminder(leagueId);
      }

      state = ReminderSettingsState(settings: newSettings);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao salvar configuracoes',
      );
    }
  }

  /// Clear any error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for managing a specific league's reminder settings
///
/// Usage:
/// ```dart
/// final notifier = ref.watch(
///   leagueReminderSettingsNotifierProvider((
///     leagueId: 'league123',
///     leagueName: 'Burger League',
///   ))
/// );
/// ```
final leagueReminderSettingsNotifierProvider = StateNotifierProvider.family
    .autoDispose<LeagueReminderSettingsNotifier, ReminderSettingsState,
        ({String leagueId, String leagueName})>((ref, params) {
  final repository = ref.watch(reminderSettingsRepositoryProvider);
  final schedulerService = ref.watch(reminderSchedulerServiceProvider);

  return LeagueReminderSettingsNotifier(
    repository: repository,
    schedulerService: schedulerService,
    leagueId: params.leagueId,
    leagueName: params.leagueName,
  );
});

/// Provider to check if notification permissions are granted
final notificationPermissionProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(reminderSchedulerServiceProvider);
  return service.areNotificationsEnabled();
});

/// Provider to request notification permissions
final requestNotificationPermissionProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(reminderSchedulerServiceProvider);
  return service.requestPermission();
});
