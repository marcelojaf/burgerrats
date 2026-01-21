import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:burgerrats/core/services/locale_preferences_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LocalePreferencesService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    service = LocalePreferencesService(mockPrefs);
  });

  group('LocalePreferencesService', () {
    group('getLocale', () {
      test('returns default locale (pt_BR) when no preference is saved', () {
        when(() => mockPrefs.getString('app_locale')).thenReturn(null);

        final result = service.getLocale();

        expect(result, const Locale('pt', 'BR'));
        verify(() => mockPrefs.getString('app_locale')).called(1);
      });

      test('returns Locale(pt, BR) when pt_BR is saved', () {
        when(() => mockPrefs.getString('app_locale')).thenReturn('pt_BR');

        final result = service.getLocale();

        expect(result, const Locale('pt', 'BR'));
      });

      test('returns Locale(en, US) when en_US is saved', () {
        when(() => mockPrefs.getString('app_locale')).thenReturn('en_US');

        final result = service.getLocale();

        expect(result, const Locale('en', 'US'));
      });

      test('returns Locale(en) when only en is saved (no country code)', () {
        when(() => mockPrefs.getString('app_locale')).thenReturn('en');

        final result = service.getLocale();

        expect(result.languageCode, 'en');
      });

      test('returns default locale for invalid saved value', () {
        when(() => mockPrefs.getString('app_locale')).thenReturn('');

        final result = service.getLocale();

        expect(result, const Locale('pt', 'BR'));
      });
    });

    group('setLocale', () {
      test('saves pt_BR when Locale(pt, BR) is passed', () async {
        when(() => mockPrefs.setString('app_locale', 'pt_BR'))
            .thenAnswer((_) async => true);

        await service.setLocale(const Locale('pt', 'BR'));

        verify(() => mockPrefs.setString('app_locale', 'pt_BR')).called(1);
      });

      test('saves en_US when Locale(en, US) is passed', () async {
        when(() => mockPrefs.setString('app_locale', 'en_US'))
            .thenAnswer((_) async => true);

        await service.setLocale(const Locale('en', 'US'));

        verify(() => mockPrefs.setString('app_locale', 'en_US')).called(1);
      });

      test('saves only language code when no country code is provided',
          () async {
        when(() => mockPrefs.setString('app_locale', 'es'))
            .thenAnswer((_) async => true);

        await service.setLocale(const Locale('es'));

        verify(() => mockPrefs.setString('app_locale', 'es')).called(1);
      });
    });

    group('supportedLocales', () {
      test('contains Portuguese (pt_BR) locale', () {
        expect(
          LocalePreferencesService.supportedLocales,
          contains(const Locale('pt', 'BR')),
        );
      });

      test('contains English (en_US) locale', () {
        expect(
          LocalePreferencesService.supportedLocales,
          contains(const Locale('en', 'US')),
        );
      });
    });

    group('defaultLocale', () {
      test('is Portuguese (pt_BR)', () {
        expect(
          LocalePreferencesService.defaultLocale,
          const Locale('pt', 'BR'),
        );
      });
    });
  });
}
