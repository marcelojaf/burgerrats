import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/reminders/domain/entities/reminder_settings.dart';

void main() {
  group('LeagueReminderSettings', () {
    test('should create with default values', () {
      const settings = LeagueReminderSettings(leagueId: 'league123');

      expect(settings.leagueId, 'league123');
      expect(settings.isEnabled, false);
      expect(settings.reminderHour, 12);
      expect(settings.reminderMinute, 0);
    });

    test('should create with custom values', () {
      const settings = LeagueReminderSettings(
        leagueId: 'league456',
        isEnabled: true,
        reminderHour: 18,
        reminderMinute: 30,
      );

      expect(settings.leagueId, 'league456');
      expect(settings.isEnabled, true);
      expect(settings.reminderHour, 18);
      expect(settings.reminderMinute, 30);
    });

    test('should create defaults for a league', () {
      final settings = LeagueReminderSettings.defaults(leagueId: 'myLeague');

      expect(settings.leagueId, 'myLeague');
      expect(settings.isEnabled, false);
      expect(settings.reminderHour, 12);
      expect(settings.reminderMinute, 0);
    });

    test('should format time correctly', () {
      const settings1 = LeagueReminderSettings(
        leagueId: 'test',
        reminderHour: 9,
        reminderMinute: 5,
      );
      expect(settings1.formattedTime, '09:05');

      const settings2 = LeagueReminderSettings(
        leagueId: 'test',
        reminderHour: 14,
        reminderMinute: 30,
      );
      expect(settings2.formattedTime, '14:30');

      const settings3 = LeagueReminderSettings(
        leagueId: 'test',
        reminderHour: 0,
        reminderMinute: 0,
      );
      expect(settings3.formattedTime, '00:00');
    });

    test('should copy with updated values', () {
      const original = LeagueReminderSettings(
        leagueId: 'league1',
        isEnabled: false,
        reminderHour: 12,
        reminderMinute: 0,
      );

      final updated = original.copyWith(
        isEnabled: true,
        reminderHour: 18,
        reminderMinute: 30,
      );

      expect(updated.leagueId, 'league1');
      expect(updated.isEnabled, true);
      expect(updated.reminderHour, 18);
      expect(updated.reminderMinute, 30);
    });

    test('should convert to and from JSON', () {
      const original = LeagueReminderSettings(
        leagueId: 'jsonTest',
        isEnabled: true,
        reminderHour: 15,
        reminderMinute: 45,
      );

      final json = original.toJson();
      final restored = LeagueReminderSettings.fromJson(json);

      expect(restored.leagueId, original.leagueId);
      expect(restored.isEnabled, original.isEnabled);
      expect(restored.reminderHour, original.reminderHour);
      expect(restored.reminderMinute, original.reminderMinute);
    });

    test('should handle missing JSON fields with defaults', () {
      final settings = LeagueReminderSettings.fromJson({
        'leagueId': 'partial',
      });

      expect(settings.leagueId, 'partial');
      expect(settings.isEnabled, false);
      expect(settings.reminderHour, 12);
      expect(settings.reminderMinute, 0);
    });

    test('should implement equality correctly', () {
      const settings1 = LeagueReminderSettings(
        leagueId: 'test',
        isEnabled: true,
        reminderHour: 10,
        reminderMinute: 30,
      );

      const settings2 = LeagueReminderSettings(
        leagueId: 'test',
        isEnabled: true,
        reminderHour: 10,
        reminderMinute: 30,
      );

      const settings3 = LeagueReminderSettings(
        leagueId: 'different',
        isEnabled: true,
        reminderHour: 10,
        reminderMinute: 30,
      );

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
      expect(settings1.hashCode, equals(settings2.hashCode));
    });
  });

  group('GlobalReminderSettings', () {
    test('should create with default values', () {
      const settings = GlobalReminderSettings();

      expect(settings.globalEnabled, true);
      expect(settings.defaultHour, 12);
      expect(settings.defaultMinute, 0);
    });

    test('should create defaults', () {
      const settings = GlobalReminderSettings.defaults();

      expect(settings.globalEnabled, true);
      expect(settings.defaultHour, 12);
      expect(settings.defaultMinute, 0);
    });

    test('should format default time correctly', () {
      const settings = GlobalReminderSettings(
        defaultHour: 8,
        defaultMinute: 15,
      );
      expect(settings.formattedDefaultTime, '08:15');
    });

    test('should copy with updated values', () {
      const original = GlobalReminderSettings();

      final updated = original.copyWith(
        globalEnabled: false,
        defaultHour: 20,
        defaultMinute: 45,
      );

      expect(updated.globalEnabled, false);
      expect(updated.defaultHour, 20);
      expect(updated.defaultMinute, 45);
    });

    test('should convert to and from JSON', () {
      const original = GlobalReminderSettings(
        globalEnabled: false,
        defaultHour: 16,
        defaultMinute: 30,
      );

      final json = original.toJson();
      final restored = GlobalReminderSettings.fromJson(json);

      expect(restored.globalEnabled, original.globalEnabled);
      expect(restored.defaultHour, original.defaultHour);
      expect(restored.defaultMinute, original.defaultMinute);
    });

    test('should implement equality correctly', () {
      const settings1 = GlobalReminderSettings(
        globalEnabled: true,
        defaultHour: 12,
        defaultMinute: 0,
      );

      const settings2 = GlobalReminderSettings(
        globalEnabled: true,
        defaultHour: 12,
        defaultMinute: 0,
      );

      const settings3 = GlobalReminderSettings(
        globalEnabled: false,
        defaultHour: 12,
        defaultMinute: 0,
      );

      expect(settings1, equals(settings2));
      expect(settings1, isNot(equals(settings3)));
    });
  });
}
