import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/state/providers/auth_state_provider.dart';
import 'package:burgerrats/core/services/notification_service.dart';
import 'package:burgerrats/features/auth/domain/repositories/auth_repository.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserCredential extends Mock implements UserCredential {}

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  group('AuthState', () {
    test('initial state should have correct status', () {
      const state = AuthState.initial();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('authenticated state should have user and correct status', () {
      final mockUser = MockUser();
      final state = AuthState.authenticated(mockUser);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, mockUser);
      expect(state.isAuthenticated, true);
      expect(state.errorMessage, isNull);
    });

    test('unauthenticated state should have no user', () {
      const state = AuthState.unauthenticated();

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.isAuthenticated, false);
    });

    test('authenticating state should indicate loading', () {
      const state = AuthState.authenticating();

      expect(state.status, AuthStatus.authenticating);
      expect(state.isLoading, true);
    });

    test('error state should have error message', () {
      const state = AuthState.error('Test error');

      expect(state.status, AuthStatus.error);
      expect(state.hasError, true);
      expect(state.errorMessage, 'Test error');
    });

    test('needsEmailVerification state should have user', () {
      final mockUser = MockUser();
      final state = AuthState.needsEmailVerification(mockUser);

      expect(state.status, AuthStatus.needsEmailVerification);
      expect(state.user, mockUser);
      expect(state.needsEmailVerification, true);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update only specified fields', () {
      const initial = AuthState.initial();
      final mockUser = MockUser();
      final updated = initial.copyWith(
        status: AuthStatus.authenticated,
        user: mockUser,
      );

      expect(updated.status, AuthStatus.authenticated);
      expect(updated.user, mockUser);
      expect(updated.errorMessage, isNull);
    });

    test('equality should compare status, user uid, and error message', () {
      final user1 = MockUser();
      final user2 = MockUser();
      when(() => user1.uid).thenReturn('same-uid');
      when(() => user2.uid).thenReturn('same-uid');

      final state1 = AuthState.authenticated(user1);
      final state2 = AuthState.authenticated(user2);

      expect(state1 == state2, true);
    });

    test('inequality for different users', () {
      final user1 = MockUser();
      final user2 = MockUser();
      when(() => user1.uid).thenReturn('uid-1');
      when(() => user2.uid).thenReturn('uid-2');

      final state1 = AuthState.authenticated(user1);
      final state2 = AuthState.authenticated(user2);

      expect(state1 == state2, false);
    });
  });

  group('AuthNotifier', () {
    late MockAuthRepository mockRepository;
    late MockNotificationService mockNotificationService;
    late StreamController<User?> authStateController;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockNotificationService = MockNotificationService();
      authStateController = StreamController<User?>.broadcast();

      when(() => mockRepository.authStateChanges)
          .thenAnswer((_) => authStateController.stream);
      when(() => mockNotificationService.initialize())
          .thenAnswer((_) async => {});
      when(() => mockNotificationService.deleteToken())
          .thenAnswer((_) async => {});
    });

    tearDown(() {
      authStateController.close();
    });

    test('should initialize with initial state and listen to auth changes', () {
      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      expect(notifier.state.status, AuthStatus.initial);
      verify(() => mockRepository.authStateChanges).called(1);

      notifier.dispose();
    });

    test('should update to authenticated when user emits on stream', () async {
      final mockUser = MockUser();
      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      authStateController.add(mockUser);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.user, mockUser);

      notifier.dispose();
    });

    test('should update to unauthenticated when null emits on stream',
        () async {
      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      authStateController.add(null);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(notifier.state.status, AuthStatus.unauthenticated);
      expect(notifier.state.user, isNull);

      notifier.dispose();
    });

    test('signIn should return true on success', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(mockUser);

      when(() => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCredential);

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.signIn(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, true);
      expect(notifier.state.status, AuthStatus.authenticated);
      expect(notifier.state.user, mockUser);

      notifier.dispose();
    });

    test('signIn should return false and set error on failure', () async {
      when(() => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(FirebaseAuthException('wrong-password', 'Wrong password'));

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.signIn(
        email: 'test@example.com',
        password: 'wrongpassword',
      );

      expect(result, false);
      expect(notifier.state.status, AuthStatus.error);
      expect(notifier.state.hasError, true);

      notifier.dispose();
    });

    test('signUp should return true on success', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(mockUser);

      when(() => mockRepository.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => mockCredential);

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.signUp(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, true);
      expect(notifier.state.status, AuthStatus.authenticated);

      notifier.dispose();
    });

    test('signOut should set state to unauthenticated', () async {
      when(() => mockRepository.signOut()).thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      await notifier.signOut();

      expect(notifier.state.status, AuthStatus.unauthenticated);

      notifier.dispose();
    });

    test('clearError should reset error state', () async {
      when(() => mockRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('Error'));

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      await notifier.signIn(email: 'test@example.com', password: 'password');
      expect(notifier.state.hasError, true);

      notifier.clearError();
      expect(notifier.state.hasError, false);

      notifier.dispose();
    });

    test('sendPasswordReset should return true on success', () async {
      when(() => mockRepository.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.sendPasswordReset(email: 'test@example.com');

      expect(result, true);
      verify(() => mockRepository.sendPasswordResetEmail(email: 'test@example.com')).called(1);

      notifier.dispose();
    });

    test('sendEmailVerification should return true on success', () async {
      when(() => mockRepository.sendEmailVerification())
          .thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.sendEmailVerification();

      expect(result, true);
      verify(() => mockRepository.sendEmailVerification()).called(1);

      notifier.dispose();
    });

    test('sendEmailVerification should return false and set error on failure', () async {
      when(() => mockRepository.sendEmailVerification())
          .thenThrow(FirebaseAuthException('too-many-requests', 'Too many requests'));

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.sendEmailVerification();

      expect(result, false);
      expect(notifier.state.hasError, true);

      notifier.dispose();
    });

    test('reloadUser should update state based on email verification status', () async {
      final mockUser = MockUser();
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockRepository.reloadUser()).thenAnswer((_) async {});
      when(() => mockRepository.currentUser).thenReturn(mockUser);

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      await notifier.reloadUser();

      expect(notifier.state.status, AuthStatus.authenticated);
      verify(() => mockRepository.reloadUser()).called(1);

      notifier.dispose();
    });

    test('reloadUser should set needsEmailVerification when email not verified', () async {
      final mockUser = MockUser();
      when(() => mockUser.emailVerified).thenReturn(false);
      when(() => mockRepository.reloadUser()).thenAnswer((_) async {});
      when(() => mockRepository.currentUser).thenReturn(mockUser);

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      await notifier.reloadUser();

      expect(notifier.state.status, AuthStatus.needsEmailVerification);

      notifier.dispose();
    });

    test('isEmailVerified should return value from repository', () {
      when(() => mockRepository.isEmailVerified).thenReturn(true);

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      expect(notifier.isEmailVerified, true);

      notifier.dispose();
    });

    test('updateDisplayName should return true on success', () async {
      when(() => mockRepository.updateDisplayName(any()))
          .thenAnswer((_) async {});

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.updateDisplayName('New Name');

      expect(result, true);
      verify(() => mockRepository.updateDisplayName('New Name')).called(1);

      notifier.dispose();
    });

    test('updateDisplayName should return false and set error on failure', () async {
      when(() => mockRepository.updateDisplayName(any()))
          .thenThrow(Exception('Update failed'));

      final notifier = AuthNotifier(mockRepository, mockNotificationService);

      final result = await notifier.updateDisplayName('New Name');

      expect(result, false);
      expect(notifier.state.hasError, true);

      notifier.dispose();
    });
  });

  group('Auth Providers', () {
    test('authStateProvider should provide stream of auth state', () {
      final container = ProviderContainer();

      // This will create the provider - in a real app with Firebase initialized,
      // it would stream auth state changes
      expect(
        () => container.read(authStateProvider),
        returnsNormally,
      );

      container.dispose();
    });

    test('currentUserProvider should derive from authStateProvider', () {
      final container = ProviderContainer();

      // Provider exists and can be read
      expect(
        () => container.read(currentUserProvider),
        returnsNormally,
      );

      container.dispose();
    });

    test('isAuthenticatedProvider should return false when no user', () {
      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(null),
        ],
      );

      final isAuthenticated = container.read(isAuthenticatedProvider);
      expect(isAuthenticated, false);

      container.dispose();
    });

    test('isAuthenticatedProvider should return true when user exists', () {
      final mockUser = MockUser();
      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWithValue(mockUser),
        ],
      );

      final isAuthenticated = container.read(isAuthenticatedProvider);
      expect(isAuthenticated, true);

      container.dispose();
    });
  });
}

/// Custom exception for testing Firebase errors
class FirebaseAuthException implements Exception {
  final String code;
  final String message;

  FirebaseAuthException(this.code, this.message);

  @override
  String toString() => 'FirebaseAuthException($code): $message';
}
