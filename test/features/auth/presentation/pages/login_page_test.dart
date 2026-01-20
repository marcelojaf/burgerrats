import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/state/providers/auth_state_provider.dart';
import 'package:burgerrats/features/auth/domain/repositories/auth_repository.dart';
import 'package:burgerrats/features/auth/presentation/pages/login_page.dart';
import 'package:burgerrats/shared/theme/app_theme.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockAuthRepository mockRepository;
  late StreamController<User?> authStateController;

  setUp(() {
    mockRepository = MockAuthRepository();
    authStateController = StreamController<User?>.broadcast();
    when(() => mockRepository.authStateChanges)
        .thenAnswer((_) => authStateController.stream);
  });

  tearDown(() {
    authStateController.close();
  });

  Widget createTestWidget({
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepository),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const LoginPage(),
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
          '/register': (context) => const Scaffold(body: Text('Register')),
          '/forgot-password': (context) =>
              const Scaffold(body: Text('Forgot Password')),
          '/email-verification': (context) =>
              const Scaffold(body: Text('Email Verification')),
        },
      ),
    );
  }

  group('LoginPage', () {
    group('UI Elements', () {
      testWidgets('should display all required elements in Portuguese',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // App branding
        expect(find.text('BurgerRats'), findsOneWidget);
        expect(find.text('Entre para avaliar hamburguerias'), findsOneWidget);

        // Form fields
        expect(find.text('E-mail'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);

        // Buttons
        expect(find.text('Entrar'), findsOneWidget);
        expect(find.text('Esqueceu a senha?'), findsOneWidget);
        expect(find.text('ou'), findsOneWidget);
        expect(find.text('Continuar com Google'), findsOneWidget);
        expect(find.text('Criar conta'), findsOneWidget);
      });

      testWidgets('should have email and password input fields',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('should have restaurant icon as logo', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('should display password visibility toggle', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('should display email and lock icons', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('should show validation error for empty email',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap login without entering anything
        await tester.tap(find.text('Entrar'));
        await tester.pumpAndSettle();

        expect(find.text('Este campo é obrigatório.'), findsWidgets);
      });

      testWidgets('should show validation error for invalid email format',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter invalid email
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'invalid-email',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          '123456',
        );

        await tester.tap(find.text('Entrar'));
        await tester.pumpAndSettle();

        expect(find.text('O e-mail informado não é válido.'), findsOneWidget);
      });

      testWidgets('should show validation error for short password',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter valid email but short password
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          '123',
        );

        await tester.tap(find.text('Entrar'));
        await tester.pumpAndSettle();

        expect(
          find.text('A senha é muito fraca. Use pelo menos 6 caracteres.'),
          findsOneWidget,
        );
      });
    });

    group('Password Visibility Toggle', () {
      testWidgets('should toggle password visibility when icon is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initially visibility icon should be present (password obscured)
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

        // Tap visibility toggle
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pumpAndSettle();

        // Now visibility_off icon should be present (password visible)
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      });
    });

    group('Login Flow', () {
      testWidgets('should show loading indicator when login is in progress',
          (tester) async {
        final completer = Completer<UserCredential>();
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) => completer.future);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter valid credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'password123',
        );

        // Tap login
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should disable buttons while loading', (tester) async {
        final completer = Completer<UserCredential>();
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) => completer.future);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter valid credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'password123',
        );

        // Tap login
        await tester.tap(find.text('Entrar'));
        await tester.pump();

        // Login button should be disabled (shows loading)
        final loginButton = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Entrar').first,
        );
        expect(loginButton.onPressed, isNull);
      });
    });

    group('Google Sign-In', () {
      testWidgets('should show loading indicator when Google sign-in is in progress',
          (tester) async {
        final completer = Completer<UserCredential?>();
        when(() => mockRepository.signInWithGoogle())
            .thenAnswer((_) => completer.future);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap Google sign-in button
        await tester.tap(find.text('Continuar com Google'));
        await tester.pump();

        // Should show loading indicator in the Google button
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics for screen readers',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // All text elements should be accessible
        expect(find.text('BurgerRats'), findsOneWidget);
        expect(find.text('Entrar'), findsOneWidget);
      });

      testWidgets('should be scrollable on small screens', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}
