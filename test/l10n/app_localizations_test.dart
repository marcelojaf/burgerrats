import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:burgerrats/l10n/app_localizations.dart';
import 'package:burgerrats/l10n/app_localizations_en.dart';
import 'package:burgerrats/l10n/app_localizations_pt.dart';

void main() {
  group('AppLocalizations', () {
    group('Delegate and Locale Loading', () {
      test('should load Portuguese locale correctly', () {
        final localizations = AppLocalizationsPt();

        expect(localizations.localeName, 'pt');
      });

      test('should load English locale correctly', () {
        final localizations = AppLocalizationsEn();

        expect(localizations.localeName, 'en');
      });

      test('delegate should support Portuguese and English', () {
        expect(
          AppLocalizations.delegate.isSupported(const Locale('pt')),
          isTrue,
        );
        expect(
          AppLocalizations.delegate.isSupported(const Locale('en')),
          isTrue,
        );
      });

      test('delegate should not support unsupported locales', () {
        expect(
          AppLocalizations.delegate.isSupported(const Locale('fr')),
          isFalse,
        );
        expect(
          AppLocalizations.delegate.isSupported(const Locale('es')),
          isFalse,
        );
      });

      test('supportedLocales should contain pt and en', () {
        expect(AppLocalizations.supportedLocales, hasLength(2));
        expect(
          AppLocalizations.supportedLocales,
          contains(const Locale('pt')),
        );
        expect(
          AppLocalizations.supportedLocales,
          contains(const Locale('en')),
        );
      });

      test('localizationsDelegates should include all required delegates', () {
        expect(
          AppLocalizations.localizationsDelegates,
          contains(AppLocalizations.delegate),
        );
        expect(
          AppLocalizations.localizationsDelegates,
          contains(GlobalMaterialLocalizations.delegate),
        );
        expect(
          AppLocalizations.localizationsDelegates,
          contains(GlobalWidgetsLocalizations.delegate),
        );
        expect(
          AppLocalizations.localizationsDelegates,
          contains(GlobalCupertinoLocalizations.delegate),
        );
      });
    });

    group('Portuguese Translations', () {
      late AppLocalizationsPt pt;

      setUp(() {
        pt = AppLocalizationsPt();
      });

      group('Common Strings', () {
        test('app title should be correct', () {
          expect(pt.appTitle, 'BurgerRats');
        });

        test('welcome should be correct', () {
          expect(pt.welcome, 'Bem-vindo');
        });

        test('login should be correct', () {
          expect(pt.login, 'Entrar');
        });

        test('logout should be correct', () {
          expect(pt.logout, 'Sair');
        });

        test('register should be correct', () {
          expect(pt.register, 'Cadastrar');
        });

        test('email should be correct', () {
          expect(pt.email, 'E-mail');
        });

        test('password should be correct', () {
          expect(pt.password, 'Senha');
        });

        test('cancel should be correct', () {
          expect(pt.cancel, 'Cancelar');
        });

        test('save should be correct', () {
          expect(pt.save, 'Salvar');
        });

        test('delete should be correct', () {
          expect(pt.delete, 'Excluir');
        });

        test('confirm should be correct', () {
          expect(pt.confirm, 'Confirmar');
        });

        test('error should be correct', () {
          expect(pt.error, 'Erro');
        });

        test('loading should be correct', () {
          expect(pt.loading, 'Carregando...');
        });

        test('tryAgain should be correct', () {
          expect(pt.tryAgain, 'Tentar novamente');
        });
      });

      group('Navigation Strings', () {
        test('home should be correct', () {
          expect(pt.home, 'Inicio');
        });

        test('profile should be correct', () {
          expect(pt.profile, 'Perfil');
        });

        test('settings should be correct', () {
          expect(pt.settings, 'Configuracoes');
        });
      });

      group('Auth Strings', () {
        test('loginSubtitle should be correct', () {
          expect(pt.loginSubtitle, 'Entre para avaliar hamburguerias');
        });

        test('forgotPassword should be correct', () {
          expect(pt.forgotPassword, 'Esqueceu a senha?');
        });

        test('continueWithGoogle should be correct', () {
          expect(pt.continueWithGoogle, 'Continuar com Google');
        });

        test('createAccount should be correct', () {
          expect(pt.createAccount, 'Criar conta');
        });

        test('confirmPassword should be correct', () {
          expect(pt.confirmPassword, 'Confirmar senha');
        });
      });

      group('Leagues Strings', () {
        test('myLeagues should be correct', () {
          expect(pt.myLeagues, 'Minhas Ligas');
        });

        test('joinLeague should be correct', () {
          expect(pt.joinLeague, 'Entrar em uma liga');
        });

        test('newLeague should be correct', () {
          expect(pt.newLeague, 'Nova Liga');
        });

        test('createLeague should be correct', () {
          expect(pt.createLeague, 'Criar Liga');
        });

        test('noLeaguesYet should be correct', () {
          expect(pt.noLeaguesYet, 'Nenhuma liga ainda');
        });
      });

      group('Check-ins Strings', () {
        test('myCheckIns should be correct', () {
          expect(pt.myCheckIns, 'Meus Check-ins');
        });

        test('noCheckInsYet should be correct', () {
          expect(pt.noCheckInsYet, 'Nenhum check-in ainda');
        });

        test('makeFirstCheckIn should be correct', () {
          expect(pt.makeFirstCheckIn,
              'Faca seu primeiro check-in clicando no botao +');
        });

        test('checkInSuccess should be correct', () {
          expect(pt.checkInSuccess, 'Check-in realizado com sucesso!');
        });
      });

      group('Validation Strings', () {
        test('requiredField should be correct', () {
          expect(pt.requiredField, 'Este campo e obrigatorio.');
        });

        test('invalidEmail should be correct', () {
          expect(pt.invalidEmail, 'O e-mail informado nao e valido.');
        });

        test('weakPassword should be correct', () {
          expect(pt.weakPassword,
              'A senha e muito fraca. Use pelo menos 6 caracteres.');
        });

        test('passwordMismatch should be correct', () {
          expect(pt.passwordMismatch, 'As senhas nao coincidem.');
        });
      });

      group('Settings Strings', () {
        test('theme should be correct', () {
          expect(pt.theme, 'Tema');
        });

        test('language should be correct', () {
          expect(pt.language, 'Idioma');
        });

        test('portuguese should be correct', () {
          expect(pt.portuguese, 'Portugues');
        });

        test('english should be correct', () {
          expect(pt.english, 'Ingles');
        });

        test('light theme should be correct', () {
          expect(pt.light, 'Claro');
        });

        test('dark theme should be correct', () {
          expect(pt.dark, 'Escuro');
        });

        test('system theme should be correct', () {
          expect(pt.system, 'Sistema');
        });
      });
    });

    group('English Translations', () {
      late AppLocalizationsEn en;

      setUp(() {
        en = AppLocalizationsEn();
      });

      group('Common Strings', () {
        test('app title should be correct', () {
          expect(en.appTitle, 'BurgerRats');
        });

        test('welcome should be correct', () {
          expect(en.welcome, 'Welcome');
        });

        test('login should be correct', () {
          expect(en.login, 'Login');
        });

        test('logout should be correct', () {
          expect(en.logout, 'Logout');
        });

        test('register should be correct', () {
          expect(en.register, 'Register');
        });

        test('email should be correct', () {
          expect(en.email, 'Email');
        });

        test('password should be correct', () {
          expect(en.password, 'Password');
        });

        test('cancel should be correct', () {
          expect(en.cancel, 'Cancel');
        });

        test('save should be correct', () {
          expect(en.save, 'Save');
        });

        test('delete should be correct', () {
          expect(en.delete, 'Delete');
        });

        test('confirm should be correct', () {
          expect(en.confirm, 'Confirm');
        });

        test('error should be correct', () {
          expect(en.error, 'Error');
        });

        test('loading should be correct', () {
          expect(en.loading, 'Loading...');
        });

        test('tryAgain should be correct', () {
          expect(en.tryAgain, 'Try again');
        });
      });

      group('Navigation Strings', () {
        test('home should be correct', () {
          expect(en.home, 'Home');
        });

        test('profile should be correct', () {
          expect(en.profile, 'Profile');
        });

        test('settings should be correct', () {
          expect(en.settings, 'Settings');
        });
      });

      group('Auth Strings', () {
        test('loginSubtitle should be correct', () {
          expect(en.loginSubtitle, 'Sign in to rate burger joints');
        });

        test('forgotPassword should be correct', () {
          expect(en.forgotPassword, 'Forgot password?');
        });

        test('continueWithGoogle should be correct', () {
          expect(en.continueWithGoogle, 'Continue with Google');
        });

        test('createAccount should be correct', () {
          expect(en.createAccount, 'Create account');
        });
      });

      group('Settings Strings', () {
        test('theme should be correct', () {
          expect(en.theme, 'Theme');
        });

        test('language should be correct', () {
          expect(en.language, 'Language');
        });

        test('portuguese should be correct', () {
          expect(en.portuguese, 'Portuguese');
        });

        test('english should be correct', () {
          expect(en.english, 'English');
        });

        test('light theme should be correct', () {
          expect(en.light, 'Light');
        });

        test('dark theme should be correct', () {
          expect(en.dark, 'Dark');
        });

        test('system theme should be correct', () {
          expect(en.system, 'System');
        });
      });
    });

    group('Parameterized Strings', () {
      late AppLocalizationsPt pt;
      late AppLocalizationsEn en;

      setUp(() {
        pt = AppLocalizationsPt();
        en = AppLocalizationsEn();
      });

      group('Time Strings (Portuguese)', () {
        test('minutesAgo should interpolate correctly', () {
          expect(pt.minutesAgo(5), 'Ha 5 min');
          expect(pt.minutesAgo(1), 'Ha 1 min');
          expect(pt.minutesAgo(30), 'Ha 30 min');
        });

        test('hoursAgo should interpolate correctly', () {
          expect(pt.hoursAgo(2), 'Ha 2h');
          expect(pt.hoursAgo(1), 'Ha 1h');
          expect(pt.hoursAgo(12), 'Ha 12h');
        });

        test('daysAgo should interpolate correctly', () {
          expect(pt.daysAgo(3), 'Ha 3 dias');
          expect(pt.daysAgo(7), 'Ha 7 dias');
        });

        test('weekAgo should interpolate correctly', () {
          expect(pt.weekAgo(1), 'Ha 1 semana');
        });

        test('weeksAgo should interpolate correctly', () {
          expect(pt.weeksAgo(2), 'Ha 2 semanas');
        });

        test('monthAgo should interpolate correctly', () {
          expect(pt.monthAgo(1), 'Ha 1 mes');
        });

        test('monthsAgo should interpolate correctly', () {
          expect(pt.monthsAgo(3), 'Ha 3 meses');
        });

        test('yearAgo should interpolate correctly', () {
          expect(pt.yearAgo(1), 'Ha 1 ano');
        });

        test('yearsAgo should interpolate correctly', () {
          expect(pt.yearsAgo(2), 'Ha 2 anos');
        });
      });

      group('Time Strings (English)', () {
        test('minutesAgo should interpolate correctly', () {
          expect(en.minutesAgo(5), '5 min ago');
          expect(en.minutesAgo(1), '1 min ago');
        });

        test('hoursAgo should interpolate correctly', () {
          expect(en.hoursAgo(2), '2h ago');
          expect(en.hoursAgo(1), '1h ago');
        });

        test('daysAgo should interpolate correctly', () {
          expect(en.daysAgo(3), '3 days ago');
        });

        test('weeksAgo should interpolate correctly', () {
          expect(en.weeksAgo(2), '2 weeks ago');
        });

        test('monthsAgo should interpolate correctly', () {
          expect(en.monthsAgo(3), '3 months ago');
        });

        test('yearsAgo should interpolate correctly', () {
          expect(en.yearsAgo(2), '2 years ago');
        });
      });

      group('Version String', () {
        test('version should interpolate correctly (Portuguese)', () {
          expect(pt.version('1.0.0'), 'Versao 1.0.0');
          expect(pt.version('2.1.3'), 'Versao 2.1.3');
        });

        test('version should interpolate correctly (English)', () {
          expect(en.version('1.0.0'), 'Version 1.0.0');
          expect(en.version('2.1.3'), 'Version 2.1.3');
        });
      });

      group('League Strings', () {
        test('minCharsRequired should interpolate correctly (Portuguese)', () {
          expect(pt.minCharsRequired(3), 'Minimo de 3 caracteres');
          expect(pt.minCharsRequired(6), 'Minimo de 6 caracteres');
        });

        test('minCharsRequired should interpolate correctly (English)', () {
          expect(en.minCharsRequired(3), 'Minimum of 3 characters');
          expect(en.minCharsRequired(6), 'Minimum of 6 characters');
        });

        test('fromToMembers should interpolate correctly (Portuguese)', () {
          expect(pt.fromToMembers(2, 50), 'De 2 a 50 membros');
          expect(pt.fromToMembers(5, 100), 'De 5 a 100 membros');
        });

        test('fromToMembers should interpolate correctly (English)', () {
          expect(en.fromToMembers(2, 50), 'From 2 to 50 members');
          expect(en.fromToMembers(5, 100), 'From 5 to 100 members');
        });

        test('leagueCreatedSuccess should interpolate correctly (Portuguese)',
            () {
          expect(pt.leagueCreatedSuccess('Burger Hunters'),
              'Sua liga "Burger Hunters" foi criada com sucesso!');
        });

        test('leagueCreatedSuccess should interpolate correctly (English)', () {
          expect(en.leagueCreatedSuccess('Burger Hunters'),
              'Your league "Burger Hunters" was created successfully!');
        });

        test('membersCount should interpolate correctly (Portuguese)', () {
          expect(pt.membersCount(5, 10), '5/10 membros');
        });

        test('membersCount should interpolate correctly (English)', () {
          expect(en.membersCount(5, 10), '5/10 members');
        });
      });

      group('Check-in Strings', () {
        test('uploadingPhoto should interpolate correctly (Portuguese)', () {
          expect(pt.uploadingPhoto(50), 'Enviando foto (50%)...');
          expect(pt.uploadingPhoto(100), 'Enviando foto (100%)...');
        });

        test('uploadingPhoto should interpolate correctly (English)', () {
          expect(en.uploadingPhoto(50), 'Uploading photo (50%)...');
          expect(en.uploadingPhoto(100), 'Uploading photo (100%)...');
        });

        test('cannotCheckIn should interpolate correctly (Portuguese)', () {
          expect(pt.cannotCheckIn('Limite diario atingido'),
              'Nao e possivel fazer check-in: Limite diario atingido');
        });

        test('cannotCheckIn should interpolate correctly (English)', () {
          expect(en.cannotCheckIn('Daily limit reached'),
              'Cannot check-in: Daily limit reached');
        });
      });

      group('Error Strings', () {
        test('errorMessage should interpolate correctly (Portuguese)', () {
          expect(pt.errorMessage('Conexao perdida'), 'Erro: Conexao perdida');
        });

        test('errorMessage should interpolate correctly (English)', () {
          expect(en.errorMessage('Connection lost'), 'Error: Connection lost');
        });

        test('errorCapturingPhoto should interpolate correctly (Portuguese)',
            () {
          expect(pt.errorCapturingPhoto('Camera nao disponivel'),
              'Erro ao capturar foto: Camera nao disponivel');
        });

        test('errorCapturingPhoto should interpolate correctly (English)', () {
          expect(en.errorCapturingPhoto('Camera not available'),
              'Error capturing photo: Camera not available');
        });
      });

      group('Confirmation Strings', () {
        test('promoteToAdminConfirmation should interpolate correctly', () {
          expect(
              pt.promoteToAdminConfirmation('Joao'),
              contains('Joao'));
          expect(
              en.promoteToAdminConfirmation('John'),
              contains('John'));
        });

        test('removeMemberConfirmation should interpolate correctly', () {
          expect(pt.removeMemberConfirmation('Maria'), contains('Maria'));
          expect(en.removeMemberConfirmation('Mary'), contains('Mary'));
        });

        test('transferOwnershipConfirmation should interpolate correctly', () {
          expect(pt.transferOwnershipConfirmation('Pedro'), contains('Pedro'));
          expect(en.transferOwnershipConfirmation('Peter'), contains('Peter'));
        });
      });

      group('Date Strings', () {
        test('dateAt should interpolate correctly (Portuguese)', () {
          expect(
              pt.dateAt(15, 'Janeiro', 2024, '14:30'),
              '15 de Janeiro de 2024 as 14:30');
        });

        test('dateAt should interpolate correctly (English)', () {
          expect(
              en.dateAt(15, 'January', 2024, '2:30 PM'),
              'January 15, 2024 at 2:30 PM');
        });

        test('createdOn should interpolate correctly (Portuguese)', () {
          expect(pt.createdOn('15/01/2024'), 'Criada em 15/01/2024');
        });

        test('createdOn should interpolate correctly (English)', () {
          expect(en.createdOn('01/15/2024'), 'Created on 01/15/2024');
        });
      });

      group('Email Verification Strings', () {
        test('resendInSeconds should interpolate correctly (Portuguese)', () {
          expect(pt.resendInSeconds(30), 'Reenviar em 30s');
          expect(pt.resendInSeconds(5), 'Reenviar em 5s');
        });

        test('resendInSeconds should interpolate correctly (English)', () {
          expect(en.resendInSeconds(30), 'Resend in 30s');
          expect(en.resendInSeconds(5), 'Resend in 5s');
        });
      });

      group('Name Validation Strings', () {
        test('nameMustHaveMinChars should interpolate correctly (Portuguese)',
            () {
          expect(pt.nameMustHaveMinChars(3),
              'Nome deve ter pelo menos 3 caracteres');
        });

        test('nameMustHaveMinChars should interpolate correctly (English)', () {
          expect(en.nameMustHaveMinChars(3),
              'Name must have at least 3 characters');
        });
      });
    });

    group('Translation Consistency', () {
      late AppLocalizationsPt pt;
      late AppLocalizationsEn en;

      setUp(() {
        pt = AppLocalizationsPt();
        en = AppLocalizationsEn();
      });

      test('both locales should have non-empty appTitle', () {
        expect(pt.appTitle, isNotEmpty);
        expect(en.appTitle, isNotEmpty);
      });

      test('both locales should have the same appTitle', () {
        expect(pt.appTitle, en.appTitle);
      });

      test('basic UI strings should not be empty (Portuguese)', () {
        expect(pt.login, isNotEmpty);
        expect(pt.logout, isNotEmpty);
        expect(pt.cancel, isNotEmpty);
        expect(pt.save, isNotEmpty);
        expect(pt.delete, isNotEmpty);
        expect(pt.confirm, isNotEmpty);
        expect(pt.loading, isNotEmpty);
        expect(pt.error, isNotEmpty);
        expect(pt.tryAgain, isNotEmpty);
      });

      test('basic UI strings should not be empty (English)', () {
        expect(en.login, isNotEmpty);
        expect(en.logout, isNotEmpty);
        expect(en.cancel, isNotEmpty);
        expect(en.save, isNotEmpty);
        expect(en.delete, isNotEmpty);
        expect(en.confirm, isNotEmpty);
        expect(en.loading, isNotEmpty);
        expect(en.error, isNotEmpty);
        expect(en.tryAgain, isNotEmpty);
      });

      test('validation strings should not be empty (Portuguese)', () {
        expect(pt.requiredField, isNotEmpty);
        expect(pt.invalidEmail, isNotEmpty);
        expect(pt.weakPassword, isNotEmpty);
        expect(pt.passwordMismatch, isNotEmpty);
      });

      test('validation strings should not be empty (English)', () {
        expect(en.requiredField, isNotEmpty);
        expect(en.invalidEmail, isNotEmpty);
        expect(en.weakPassword, isNotEmpty);
        expect(en.passwordMismatch, isNotEmpty);
      });

      test('navigation strings should not be empty (Portuguese)', () {
        expect(pt.home, isNotEmpty);
        expect(pt.profile, isNotEmpty);
        expect(pt.settings, isNotEmpty);
      });

      test('navigation strings should not be empty (English)', () {
        expect(en.home, isNotEmpty);
        expect(en.profile, isNotEmpty);
        expect(en.settings, isNotEmpty);
      });

      test('month names should not be empty (Portuguese)', () {
        expect(pt.monthJanuary, isNotEmpty);
        expect(pt.monthFebruary, isNotEmpty);
        expect(pt.monthMarch, isNotEmpty);
        expect(pt.monthApril, isNotEmpty);
        expect(pt.monthMay, isNotEmpty);
        expect(pt.monthJune, isNotEmpty);
        expect(pt.monthJuly, isNotEmpty);
        expect(pt.monthAugust, isNotEmpty);
        expect(pt.monthSeptember, isNotEmpty);
        expect(pt.monthOctober, isNotEmpty);
        expect(pt.monthNovember, isNotEmpty);
        expect(pt.monthDecember, isNotEmpty);
      });

      test('month names should not be empty (English)', () {
        expect(en.monthJanuary, isNotEmpty);
        expect(en.monthFebruary, isNotEmpty);
        expect(en.monthMarch, isNotEmpty);
        expect(en.monthApril, isNotEmpty);
        expect(en.monthMay, isNotEmpty);
        expect(en.monthJune, isNotEmpty);
        expect(en.monthJuly, isNotEmpty);
        expect(en.monthAugust, isNotEmpty);
        expect(en.monthSeptember, isNotEmpty);
        expect(en.monthOctober, isNotEmpty);
        expect(en.monthNovember, isNotEmpty);
        expect(en.monthDecember, isNotEmpty);
      });

      test('rating labels should not be empty (Portuguese)', () {
        expect(pt.ratingBad, isNotEmpty);
        expect(pt.ratingRegular, isNotEmpty);
        expect(pt.ratingGood, isNotEmpty);
        expect(pt.ratingVeryGood, isNotEmpty);
        expect(pt.ratingExcellent, isNotEmpty);
      });

      test('rating labels should not be empty (English)', () {
        expect(en.ratingBad, isNotEmpty);
        expect(en.ratingRegular, isNotEmpty);
        expect(en.ratingGood, isNotEmpty);
        expect(en.ratingVeryGood, isNotEmpty);
        expect(en.ratingExcellent, isNotEmpty);
      });
    });
  });

  group('Widget Localization Integration', () {
    Widget createLocalizedApp({
      required Locale locale,
      required Widget child,
    }) {
      return ProviderScope(
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );
    }

    testWidgets('should access localizations via AppLocalizations.of (Portuguese)',
        (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('pt'),
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return Text(l10n.appTitle);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n.appTitle, 'BurgerRats');
      expect(l10n.login, 'Entrar');
      expect(find.text('BurgerRats'), findsOneWidget);
    });

    testWidgets('should access localizations via AppLocalizations.of (English)',
        (tester) async {
      late AppLocalizations l10n;

      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return Text(l10n.login);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(l10n.login, 'Login');
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display different text for different locales',
        (tester) async {
      // Test Portuguese
      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('pt'),
          child: Builder(
            builder: (context) {
              return Text(AppLocalizations.of(context).welcome);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bem-vindo'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);

      // Test English
      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              return Text(AppLocalizations.of(context).welcome);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Bem-vindo'), findsNothing);
    });

    testWidgets('should handle parameterized strings in widgets (Portuguese)',
        (tester) async {
      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('pt'),
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Column(
                children: [
                  Text(l10n.minutesAgo(5)),
                  Text(l10n.version('1.0.0')),
                  Text(l10n.membersCount(3, 10)),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ha 5 min'), findsOneWidget);
      expect(find.text('Versao 1.0.0'), findsOneWidget);
      expect(find.text('3/10 membros'), findsOneWidget);
    });

    testWidgets('should handle parameterized strings in widgets (English)',
        (tester) async {
      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('en'),
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Column(
                children: [
                  Text(l10n.minutesAgo(5)),
                  Text(l10n.version('1.0.0')),
                  Text(l10n.membersCount(3, 10)),
                ],
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 min ago'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
      expect(find.text('3/10 members'), findsOneWidget);
    });

    testWidgets('should display multiple localized UI elements correctly',
        (tester) async {
      await tester.pumpWidget(
        createLocalizedApp(
          locale: const Locale('pt'),
          child: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              return Scaffold(
                appBar: AppBar(title: Text(l10n.settings)),
                body: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.theme),
                      subtitle: Text(l10n.light),
                    ),
                    ListTile(
                      title: Text(l10n.language),
                      subtitle: Text(l10n.portuguese),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(l10n.save),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(l10n.cancel),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Configuracoes'), findsOneWidget);
      expect(find.text('Tema'), findsOneWidget);
      expect(find.text('Claro'), findsOneWidget);
      expect(find.text('Idioma'), findsOneWidget);
      expect(find.text('Portugues'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
    });

    testWidgets('should fall back to supported locale when unsupported is used',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'), // Unsupported
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          localeResolutionCallback: (locale, supportedLocales) {
            // Default fallback to Portuguese
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode) {
                return supportedLocale;
              }
            }
            return const Locale('pt'); // Fallback
          },
          home: Builder(
            builder: (context) {
              // Localizations.of will return Portuguese as fallback
              try {
                final l10n = AppLocalizations.of(context);
                return Text(l10n.login);
              } catch (_) {
                return const Text('Fallback');
              }
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should fall back to Portuguese
      expect(find.text('Entrar'), findsOneWidget);
    });
  });

  group('Locale Switching', () {
    testWidgets('should update UI when locale changes', (tester) async {
      final localeNotifier = ValueNotifier<Locale>(const Locale('pt'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Column(
                    children: [
                      Text(l10n.login),
                      Text(l10n.settings),
                    ],
                  );
                },
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Initially Portuguese
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Configuracoes'), findsOneWidget);

      // Switch to English
      localeNotifier.value = const Locale('en');
      await tester.pumpAndSettle();

      // Now English
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Switch back to Portuguese
      localeNotifier.value = const Locale('pt');
      await tester.pumpAndSettle();

      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Configuracoes'), findsOneWidget);
    });

    testWidgets('should maintain correct translations after rapid locale changes',
        (tester) async {
      final localeNotifier = ValueNotifier<Locale>(const Locale('pt'));

      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context);
                  return Text(l10n.login);
                },
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      // Rapid locale changes
      localeNotifier.value = const Locale('en');
      await tester.pump();
      localeNotifier.value = const Locale('pt');
      await tester.pump();
      localeNotifier.value = const Locale('en');
      await tester.pumpAndSettle();

      // Should be in final state (English)
      expect(find.text('Login'), findsOneWidget);
    });
  });

  group('Special Characters and Edge Cases', () {
    late AppLocalizationsPt pt;
    late AppLocalizationsEn en;

    setUp(() {
      pt = AppLocalizationsPt();
      en = AppLocalizationsEn();
    });

    test('Portuguese strings with special characters should be correct', () {
      // Portuguese has special characters like ã, ç, etc.
      expect(pt.forgotPassword, contains('?'));
      expect(pt.loading, endsWith('...'));
    });

    test('English strings with apostrophes should be correct', () {
      // "Didn't" contains an apostrophe
      expect(en.didNotReceiveResend, contains("Didn't"));
    });

    test('strings should handle zero values correctly', () {
      expect(pt.minutesAgo(0), 'Ha 0 min');
      expect(en.minutesAgo(0), '0 min ago');
      expect(pt.membersCount(0, 10), '0/10 membros');
      expect(en.membersCount(0, 10), '0/10 members');
    });

    test('strings should handle large values correctly', () {
      expect(pt.minutesAgo(999), 'Ha 999 min');
      expect(en.minutesAgo(999), '999 min ago');
      expect(pt.membersCount(1000, 9999), '1000/9999 membros');
    });

    test('strings with quotes should interpolate correctly', () {
      expect(pt.leagueCreatedSuccess('Test "League"'),
          contains('"Test "League""'));
      expect(en.leagueCreatedSuccess('Test "League"'),
          contains('"Test "League""'));
    });

    test('empty string interpolation should work', () {
      expect(pt.version(''), 'Versao ');
      expect(en.version(''), 'Version ');
    });
  });
}
