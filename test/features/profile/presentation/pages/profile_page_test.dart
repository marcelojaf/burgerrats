import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/state/providers/auth_state_provider.dart';
import 'package:burgerrats/features/auth/domain/repositories/auth_repository.dart';
import 'package:burgerrats/features/check_ins/domain/repositories/check_in_repository.dart';
import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';
import 'package:burgerrats/features/leagues/presentation/providers/my_leagues_provider.dart';
import 'package:burgerrats/features/profile/presentation/pages/profile_page.dart';
import 'package:burgerrats/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:burgerrats/features/streak_tracker/domain/entities/streak_entity.dart';
import 'package:burgerrats/features/streak_tracker/presentation/providers/streak_provider.dart';
import 'package:burgerrats/shared/theme/app_theme.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

class MockCheckInRepository extends Mock implements CheckInRepository {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;
  late MockCheckInRepository mockCheckInRepository;
  late StreamController<User?> authStateController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    mockCheckInRepository = MockCheckInRepository();
    authStateController = StreamController<User?>.broadcast();

    // Setup default mock behaviors
    when(() => mockAuthRepository.authStateChanges)
        .thenAnswer((_) => authStateController.stream);
    when(() => mockUser.uid).thenReturn('test-user-id');
    when(() => mockUser.email).thenReturn('test@example.com');
    when(() => mockUser.displayName).thenReturn('Test User');
    when(() => mockUser.photoURL).thenReturn(null);
    when(() => mockCheckInRepository.getUserCheckInCount(any()))
        .thenAnswer((_) async => 42);
  });

  tearDown(() {
    authStateController.close();
  });

  Widget createTestWidget({
    List<Override> overrides = const [],
    User? user,
  }) {
    final effectiveUser = user ?? mockUser;

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        currentUserProvider.overrideWithValue(effectiveUser),
        profileCheckInRepositoryProvider.overrideWithValue(mockCheckInRepository),
        myLeaguesProvider.overrideWith((ref) => Stream.value(<LeagueEntity>[])),
        myLeaguesCountProvider.overrideWithValue(3),
        userStreakStreamProvider(effectiveUser.uid).overrideWith(
          (ref) => Stream.value(
            StreakEntity(
              id: 'streak-1',
              userId: effectiveUser.uid,
              currentStreak: 7,
              longestStreak: 14,
              totalCheckIns: 42,
              updatedAt: DateTime.now(),
            ),
          ),
        ),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const ProfilePage(),
        routes: {
          '/settings': (context) => const Scaffold(body: Text('Settings')),
          '/profile/edit': (context) => const Scaffold(body: Text('Edit Profile')),
          '/check-ins': (context) => const Scaffold(body: Text('Check-ins')),
          '/leagues': (context) => const Scaffold(body: Text('Leagues')),
          '/login': (context) => const Scaffold(body: Text('Login')),
        },
      ),
    );
  }

  group('ProfilePage', () {
    group('UI Elements', () {
      testWidgets('should display app bar with Profile title', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('should display settings icon in app bar', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should display user display name', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Test User'), findsOneWidget);
      });

      testWidgets('should display user email', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('should display stat cards for Check-ins, Streak, and Leagues',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Check-ins'), findsOneWidget);
        expect(find.text('Streak'), findsOneWidget);
        expect(find.text('Leagues'), findsOneWidget);
      });

      testWidgets('should display menu options', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Edit Profile'), findsOneWidget);
        expect(find.text('Check-in History'), findsOneWidget);
        expect(find.text('My Leagues'), findsOneWidget);
      });

      testWidgets('should display logout option', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('Logout'), findsOneWidget);
      });
    });

    group('User Avatar', () {
      testWidgets('should display initial avatar when no photo URL', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Should display CircleAvatar with user initial
        expect(find.byType(CircleAvatar), findsAtLeastNWidgets(1));
        expect(find.text('T'), findsOneWidget); // First letter of "Test User"
      });

      testWidgets('should display email prefix when no display name', (tester) async {
        final userWithoutName = MockUser();
        when(() => userWithoutName.uid).thenReturn('test-user-id');
        when(() => userWithoutName.email).thenReturn('johndoe@example.com');
        when(() => userWithoutName.displayName).thenReturn(null);
        when(() => userWithoutName.photoURL).thenReturn(null);

        await tester.pumpWidget(createTestWidget(user: userWithoutName));
        await tester.pumpAndSettle();

        expect(find.text('johndoe'), findsOneWidget);
      });
    });

    group('Statistics Display', () {
      testWidgets('should display correct total check-ins count', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('42'), findsOneWidget);
      });

      testWidgets('should display correct streak value', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('7d'), findsOneWidget); // 7 days streak
      });

      testWidgets('should display correct leagues count', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('should display fire icon for streak', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      });

      testWidgets('should display restaurant icon for check-ins', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('should display trophy icon for leagues', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      });
    });

    group('Navigation', () {
      testWidgets('should navigate to settings when settings icon is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();

        expect(find.text('Settings'), findsOneWidget);
      });

      testWidgets('should navigate to edit profile when Edit Profile is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit Profile'));
        await tester.pumpAndSettle();

        expect(find.text('Edit Profile'), findsNWidgets(2)); // In list and page title
      });

      testWidgets('should navigate to check-ins when Check-in History is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Check-in History'));
        await tester.pumpAndSettle();

        expect(find.text('Check-ins'), findsOneWidget);
      });

      testWidgets('should navigate to leagues when My Leagues is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('My Leagues'));
        await tester.pumpAndSettle();

        expect(find.text('Leagues'), findsOneWidget);
      });
    });

    group('Logout', () {
      testWidgets('should show confirmation dialog when Logout is tapped',
          (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Logout'));
        await tester.pumpAndSettle();

        expect(find.text('Tem certeza que deseja sair?'), findsOneWidget);
        expect(find.text('Cancelar'), findsOneWidget);
        expect(find.text('Sair'), findsOneWidget);
      });

      testWidgets('should dismiss dialog when Cancel is tapped', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Logout'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();

        // Dialog should be dismissed
        expect(find.text('Tem certeza que deseja sair?'), findsNothing);
      });
    });

    group('Loading State', () {
      testWidgets('should show loading indicator while profile is loading',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(mockAuthRepository),
              currentUserProvider.overrideWithValue(null),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: const ProfilePage(),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be scrollable for content overflow', (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}
