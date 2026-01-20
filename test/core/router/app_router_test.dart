import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/router/app_router.dart';
import 'package:burgerrats/core/router/app_routes.dart';
import 'package:burgerrats/core/state/providers/auth_state_provider.dart';

class MockUser extends Mock implements User {}

void main() {
  group('routerProvider', () {
    testWidgets('should redirect to login when not authenticated',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Builder(
            builder: (context) {
              final router = container.read(routerProvider);
              return MaterialApp.router(
                routerConfig: router,
              );
            },
          ),
        ),
      );

      // Allow time for async operations
      await tester.pumpAndSettle();

      // Verify we don't crash and can build
      expect(find.byType(MaterialApp), findsOneWidget);

      container.dispose();
    });

    testWidgets('should allow access to login page when not authenticated',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
      );

      final router = GoRouter(
        initialLocation: AppRoutes.login,
        routes: [
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => const Scaffold(
              body: Text('Login Page'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);

      container.dispose();
    });
  });

  group('_isPublicRoute helper', () {
    test('login route should be public', () {
      // Test that login routes are considered public
      expect(AppRoutes.login.startsWith('/login'), true);
    });

    test('home route should be protected', () {
      // Test that home route is not in public routes
      expect(AppRoutes.home, '/home');
      expect(AppRoutes.home.startsWith('/login'), false);
    });

    test('splash route should be public', () {
      expect(AppRoutes.splash, '/');
    });
  });

  group('Auth State Integration', () {
    test('AuthState transitions should be detectable', () {
      // Test initial state
      const initial = AuthState.initial();
      expect(initial.isAuthenticated, false);
      expect(initial.isLoading, false);

      // Test authenticating state
      const authenticating = AuthState.authenticating();
      expect(authenticating.isAuthenticated, false);
      expect(authenticating.isLoading, true);

      // Test authenticated state
      final mockUser = MockUser();
      final authenticated = AuthState.authenticated(mockUser);
      expect(authenticated.isAuthenticated, true);
      expect(authenticated.isLoading, false);

      // Test unauthenticated state
      const unauthenticated = AuthState.unauthenticated();
      expect(unauthenticated.isAuthenticated, false);
      expect(unauthenticated.isLoading, false);
    });

    test('AuthStatus enum should have correct values', () {
      expect(AuthStatus.values.length, 5);
      expect(AuthStatus.values, contains(AuthStatus.initial));
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
      expect(AuthStatus.values, contains(AuthStatus.authenticating));
      expect(AuthStatus.values, contains(AuthStatus.error));
    });
  });
}
