import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burgerrats/features/reminders/data/repositories/reminder_settings_repository.dart';
import 'package:burgerrats/features/reminders/domain/entities/reminder_settings.dart';

void main() {
  group('ReminderSettingsRepository', () {
    late ReminderSettingsRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = ReminderSettingsRepository();
    });

    group('getGlobalSettings', () {
      test('should return default settings when no data stored', () async {
        final settings = repository.getGlobalSettings();

        expect(settings.globalEnabled, true);
        expect(settings.defaultHour, 12);
        expect(settings.defaultMinute, 0);
      });

      test('should return stored settings', () async {
        // First save some settings
        const customSettings = GlobalReminderSettings(
          globalEnabled: false,
          defaultHour: 18,
          defaultMinute: 30,
        );
        await repository.saveGlobalSettings(customSettings);

        // Then retrieve them
        final retrievedSettings = repository.getGlobalSettings();

        expect(retrievedSettings.globalEnabled, false);
        expect(retrievedSettings.defaultHour, 18);
        expect(retrievedSettings.defaultMinute, 30);
      });
    });

    group('saveGlobalSettings', () {
      test('should persist global settings', () async {
        const settings = GlobalReminderSettings(
          globalEnabled: false,
          defaultHour: 20,
          defaultMinute: 45,
        );

        await repository.saveGlobalSettings(settings);

        // Create a new repository instance to verify persistence
        final newRepository = ReminderSettingsRepository();
        final retrieved = newRepository.getGlobalSettings();

        expect(retrieved.globalEnabled, settings.globalEnabled);
        expect(retrieved.defaultHour, settings.defaultHour);
        expect(retrieved.defaultMinute, settings.defaultMinute);
      });
    });

    group('getLeagueSettings', () {
      test('should return default settings for new league', () async {
        final settings = repository.getLeagueSettings('newLeague123');

        expect(settings.leagueId, 'newLeague123');
        expect(settings.isEnabled, false);
        expect(settings.reminderHour, 12);
        expect(settings.reminderMinute, 0);
      });

      test('should return stored settings for existing league', () async {
        const storedSettings = LeagueReminderSettings(
          leagueId: 'existingLeague',
          isEnabled: true,
          reminderHour: 14,
          reminderMinute: 15,
        );
        await repository.saveLeagueSettings(storedSettings);

        final retrieved = repository.getLeagueSettings('existingLeague');

        expect(retrieved.leagueId, 'existingLeague');
        expect(retrieved.isEnabled, true);
        expect(retrieved.reminderHour, 14);
        expect(retrieved.reminderMinute, 15);
      });
    });

    group('saveLeagueSettings', () {
      test('should persist league settings', () async {
        const settings = LeagueReminderSettings(
          leagueId: 'myLeague',
          isEnabled: true,
          reminderHour: 9,
          reminderMinute: 30,
        );

        await repository.saveLeagueSettings(settings);

        final newRepository = ReminderSettingsRepository();
        final retrieved = newRepository.getLeagueSettings('myLeague');

        expect(retrieved.isEnabled, settings.isEnabled);
        expect(retrieved.reminderHour, settings.reminderHour);
        expect(retrieved.reminderMinute, settings.reminderMinute);
      });
    });

    group('getAllLeagueSettings', () {
      test('should return empty list when no leagues configured', () async {
        final allSettings = repository.getAllLeagueSettings();

        expect(allSettings, isEmpty);
      });

      test('should return all stored league settings', () async {
        const settings1 = LeagueReminderSettings(
          leagueId: 'league1',
          isEnabled: true,
          reminderHour: 10,
          reminderMinute: 0,
        );
        const settings2 = LeagueReminderSettings(
          leagueId: 'league2',
          isEnabled: false,
          reminderHour: 15,
          reminderMinute: 30,
        );

        await repository.saveLeagueSettings(settings1);
        await repository.saveLeagueSettings(settings2);

        final allSettings = repository.getAllLeagueSettings();

        expect(allSettings.length, 2);
        expect(allSettings.any((s) => s.leagueId == 'league1'), true);
        expect(allSettings.any((s) => s.leagueId == 'league2'), true);
      });
    });

    group('getEnabledLeagueSettings', () {
      test('should return only enabled league settings', () async {
        const enabledSettings = LeagueReminderSettings(
          leagueId: 'enabledLeague',
          isEnabled: true,
          reminderHour: 12,
          reminderMinute: 0,
        );
        const disabledSettings = LeagueReminderSettings(
          leagueId: 'disabledLeague',
          isEnabled: false,
          reminderHour: 12,
          reminderMinute: 0,
        );

        await repository.saveLeagueSettings(enabledSettings);
        await repository.saveLeagueSettings(disabledSettings);

        final enabledOnly = repository.getEnabledLeagueSettings();

        expect(enabledOnly.length, 1);
        expect(enabledOnly.first.leagueId, 'enabledLeague');
      });
    });

    group('deleteLeagueSettings', () {
      test('should remove league settings', () async {
        const settings = LeagueReminderSettings(
          leagueId: 'toDelete',
          isEnabled: true,
          reminderHour: 10,
          reminderMinute: 0,
        );
        await repository.saveLeagueSettings(settings);

        // Verify it exists
        var allSettings = repository.getAllLeagueSettings();
        expect(allSettings.any((s) => s.leagueId == 'toDelete'), true);

        // Delete it
        await repository.deleteLeagueSettings('toDelete');

        // Verify it's gone
        allSettings = repository.getAllLeagueSettings();
        expect(allSettings.any((s) => s.leagueId == 'toDelete'), false);
      });
    });

    group('clearAllSettings', () {
      test('should clear all reminder settings', () async {
        // Add some settings
        await repository.saveGlobalSettings(
          const GlobalReminderSettings(globalEnabled: false),
        );
        await repository.saveLeagueSettings(
          const LeagueReminderSettings(leagueId: 'league1', isEnabled: true),
        );
        await repository.saveLeagueSettings(
          const LeagueReminderSettings(leagueId: 'league2', isEnabled: true),
        );

        // Clear all
        await repository.clearAllSettings();

        // Verify everything is cleared
        final globalSettings = repository.getGlobalSettings();
        expect(globalSettings.globalEnabled, true); // Should be default

        final leagueSettings = repository.getAllLeagueSettings();
        expect(leagueSettings, isEmpty);
      });
    });
  });
}
