import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/state/providers/auth_state_provider.dart';
import 'package:burgerrats/features/auth/domain/repositories/auth_repository.dart';
import 'package:burgerrats/features/auth/presentation/pages/register_page.dart';
import 'package:burgerrats/shared/theme/app_theme.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

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
        home: const RegisterPage(),
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login')),
          '/email-verification': (context) =>
              const Scaffold(body: Text('Email Verification')),
        },
      ),
    );
  }

  group('RegisterPage', () {
    group('UI Elements', () {
      testWidgets('should display all required elements in Portuguese',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // App bar title
        expect(find.text('Criar conta'), findsWidgets);

        // Info text
        expect(
          find.text(
              'Crie sua conta para começar a avaliar hamburguerias e competir com seus amigos!'),
          findsOneWidget,
        );

        // Form fields
        expect(find.text('Nome'), findsOneWidget);
        expect(find.text('E-mail'), findsOneWidget);
        expect(find.text('Senha'), findsOneWidget);
        expect(find.text('Confirmar senha'), findsOneWidget);

        // Terms checkbox text
        expect(find.text('Termos de Uso'), findsOneWidget);
        expect(find.text('Política de Privacidade'), findsOneWidget);

        // Already have account link
        expect(find.text('Já tem uma conta?'), findsOneWidget);
        expect(find.text('Entrar'), findsOneWidget);
      });

      testWidgets('should have four input fields', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsNWidgets(4));
      });

      testWidgets('should have terms acceptance checkbox', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('should display password visibility toggles', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Two password fields, two visibility toggles
        expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
      });

      testWidgets('should display proper icons for form fields', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.person_outlined), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('should show validation error for empty name', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap register without entering anything
        await tester.tap(find.text('Criar conta').last);
        await tester.pumpAndSettle();

        expect(find.text('Este campo é obrigatório.'), findsWidgets);
      });

      testWidgets('should show validation error for invalid email format',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter name
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'),
          'Test User',
        );
        // Enter invalid email
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'invalid-email',
        );
        // Enter valid password
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          '123456',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          '123456',
        );

        // Accept terms
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Criar conta').last);
        await tester.pumpAndSettle();

        expect(find.text('O e-mail informado não é válido.'), findsOneWidget);
      });

      testWidgets('should show validation error for short password',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter all fields with short password
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'),
          'Test User',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          '123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          '123',
        );

        // Accept terms
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Criar conta').last);
        await tester.pumpAndSettle();

        expect(
          find.text('A senha é muito fraca. Use pelo menos 6 caracteres.'),
          findsOneWidget,
        );
      });

      testWidgets('should show validation error for password mismatch',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter all fields with mismatched passwords
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'),
          'Test User',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          'differentpassword',
        );

        // Accept terms
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Criar conta').last);
        await tester.pumpAndSettle();

        expect(find.text('As senhas não coincidem.'), findsOneWidget);
      });

      testWidgets('should show validation error when terms not accepted',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter all fields correctly
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'),
          'Test User',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          'password123',
        );

        // Don't accept terms
        await tester.tap(find.text('Criar conta').last);
        await tester.pumpAndSettle();

        expect(
          find.text('Você deve aceitar os termos de uso'),
          findsOneWidget,
        );
      });
    });

    group('Terms Acceptance', () {
      testWidgets('should toggle checkbox when tapped', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initially unchecked
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isFalse);

        // Tap checkbox
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Now checked
        final checkboxAfter = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkboxAfter.value, isTrue);
      });

      testWidgets('should toggle checkbox when text is tapped', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Tap on "Termos de Uso" text
        await tester.tap(find.text('Termos de Uso'));
        await tester.pumpAndSettle();

        // Checkbox should be checked
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });
    });

    group('Password Visibility Toggle', () {
      testWidgets('should toggle password visibility when icon is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initially visibility icons should be present (passwords obscured)
        expect(find.byIcon(Icons.visibility_outlined), findsWidgets);

        // Tap first visibility toggle (password field)
        await tester.tap(find.byIcon(Icons.visibility_outlined).first);
        await tester.pumpAndSettle();

        // Now at least one visibility_off icon should be present
        expect(find.byIcon(Icons.visibility_off_outlined), findsWidgets);
      });

      testWidgets('should toggle confirm password visibility', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initially visibility icons should be present (passwords obscured)
        expect(find.byIcon(Icons.visibility_outlined), findsWidgets);

        // Tap second visibility toggle (confirm password field)
        await tester.tap(find.byIcon(Icons.visibility_outlined).last);
        await tester.pumpAndSettle();

        // Now confirm password should be visible
        expect(find.byIcon(Icons.visibility_off_outlined), findsWidgets);
      });
    });

    group('Registration Flow', () {
      testWidgets('should show loading indicator when registration is in progress',
          (tester) async {
        final completer = Completer<UserCredential>();
        when(() => mockRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) => completer.future);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter all valid fields
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'),
          'Test User',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          'password123',
        );

        // Accept terms
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Tap register
        await tester.tap(find.text('Criar conta').last);
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should disable button while loading', (tester) async {
        final completer = Completer<UserCredential>();
        when(() => mockRepository.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) => completer.future);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Enter all valid fields
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nome'),
          'Test User',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'),
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Confirmar senha'),
          'password123',
        );

        // Accept terms
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        // Tap register
        await tester.tap(find.text('Criar conta').last);
        await tester.pump();

        // Register button should be disabled
        final registerButton = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Criar conta').first,
        );
        expect(registerButton.onPressed, isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics for screen readers',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // All text elements should be accessible
        expect(find.text('Criar conta'), findsWidgets);
        expect(find.text('Nome'), findsOneWidget);
        expect(find.text('E-mail'), findsOneWidget);
      });

      testWidgets('should be scrollable on small screens', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}
