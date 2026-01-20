import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/state/providers/auth_state_provider.dart';
import 'package:burgerrats/features/auth/domain/repositories/auth_repository.dart';
import 'package:burgerrats/features/splash/presentation/pages/splash_page.dart';
import 'package:burgerrats/shared/theme/app_theme.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

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
        home: const SplashPage(),
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home')),
          '/login': (context) => const Scaffold(body: Text('Login')),
        },
      ),
    );
  }

  group('SplashPage', () {
    group('UI Elements', () {
      testWidgets('should display branded logo and app name', (tester) async {
        await tester.pumpWidget(createTestWidget());
        // Don't settle - animation is running
        await tester.pump();

        // App name should be present
        expect(find.text('BurgerRats'), findsOneWidget);
      });

      testWidgets('should display tagline', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.text('Track Your Burger Journey'), findsOneWidget);
      });

      testWidgets('should display loading indicator', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should display logo images', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Should have Image.asset widgets for the logos
        expect(find.byType(Image), findsWidgets);
      });

      testWidgets('should have gradient background', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Find Container with gradient decoration
        final containerFinder = find.byWidgetPredicate((widget) {
          if (widget is Container && widget.decoration is BoxDecoration) {
            final decoration = widget.decoration as BoxDecoration;
            return decoration.gradient != null;
          }
          return false;
        });
        expect(containerFinder, findsOneWidget);
      });
    });

    group('Authentication Routing', () {
      testWidgets('should navigate to home when user is authenticated',
          (tester) async {
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('test-uid');

        await tester.pumpWidget(createTestWidget());

        // Emit authenticated user
        authStateController.add(mockUser);

        // Wait for splash delay (2000ms) plus navigation
        await tester.pump(const Duration(milliseconds: 2500));
        await tester.pumpAndSettle();

        // Should have navigated to home
        expect(find.text('Home'), findsOneWidget);
      });

      testWidgets('should navigate to login when user is not authenticated',
          (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Emit null user (not authenticated)
        authStateController.add(null);

        // Wait for splash delay (2000ms) plus navigation
        await tester.pump(const Duration(milliseconds: 2500));
        await tester.pumpAndSettle();

        // Should have navigated to login
        expect(find.text('Login'), findsOneWidget);
      });
    });

    group('Animation', () {
      testWidgets('should have animation controller', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Find widgets that use animation
        expect(find.byType(Opacity), findsWidgets);
        expect(find.byType(Transform), findsWidgets);
      });

      testWidgets('should animate fade-in effect', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Initial pump - animation starting
        await tester.pump();

        // After 500ms, animation should be partially complete
        await tester.pump(const Duration(milliseconds: 500));

        // After full animation duration
        await tester.pump(const Duration(milliseconds: 500));

        // Content should be visible
        expect(find.text('BurgerRats'), findsOneWidget);
      });
    });

    group('Theme Support', () {
      testWidgets('should render correctly in light theme', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockRepository),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: const SplashPage(),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('BurgerRats'), findsOneWidget);
      });

      testWidgets('should render correctly in dark theme', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockRepository),
            ],
            child: MaterialApp(
              theme: AppTheme.dark,
              home: const SplashPage(),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('BurgerRats'), findsOneWidget);
      });
    });

    group('Safety Checks', () {
      testWidgets('should handle rapid auth state changes gracefully',
          (tester) async {
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn('test-uid');

        await tester.pumpWidget(createTestWidget());

        // Rapid auth state changes
        authStateController.add(null);
        authStateController.add(mockUser);
        authStateController.add(null);
        authStateController.add(mockUser);

        // Wait for navigation
        await tester.pump(const Duration(milliseconds: 2500));
        await tester.pumpAndSettle();

        // Should navigate only once (to final state)
        expect(find.text('Home'), findsOneWidget);
      });
    });
  });
}
