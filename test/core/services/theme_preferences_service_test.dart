import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:burgerrats/core/services/theme_preferences_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ThemePreferencesService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    service = ThemePreferencesService(mockPrefs);
  });

  group('ThemePreferencesService', () {
    group('getThemeMode', () {
      test('returns ThemeMode.system when no preference is saved', () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn(null);

        final result = service.getThemeMode();

        expect(result, ThemeMode.system);
        verify(() => mockPrefs.getString('theme_mode')).called(1);
      });

      test('returns ThemeMode.light when light is saved', () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn('light');

        final result = service.getThemeMode();

        expect(result, ThemeMode.light);
      });

      test('returns ThemeMode.dark when dark is saved', () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn('dark');

        final result = service.getThemeMode();

        expect(result, ThemeMode.dark);
      });

      test('returns ThemeMode.system when system is saved', () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn('system');

        final result = service.getThemeMode();

        expect(result, ThemeMode.system);
      });

      test('returns ThemeMode.system for unknown saved value', () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn('unknown');

        final result = service.getThemeMode();

        expect(result, ThemeMode.system);
      });
    });

    group('setThemeMode', () {
      test('saves light when ThemeMode.light is passed', () async {
        when(() => mockPrefs.setString('theme_mode', 'light'))
            .thenAnswer((_) async => true);

        await service.setThemeMode(ThemeMode.light);

        verify(() => mockPrefs.setString('theme_mode', 'light')).called(1);
      });

      test('saves dark when ThemeMode.dark is passed', () async {
        when(() => mockPrefs.setString('theme_mode', 'dark'))
            .thenAnswer((_) async => true);

        await service.setThemeMode(ThemeMode.dark);

        verify(() => mockPrefs.setString('theme_mode', 'dark')).called(1);
      });

      test('saves system when ThemeMode.system is passed', () async {
        when(() => mockPrefs.setString('theme_mode', 'system'))
            .thenAnswer((_) async => true);

        await service.setThemeMode(ThemeMode.system);

        verify(() => mockPrefs.setString('theme_mode', 'system')).called(1);
      });
    });
  });
}
