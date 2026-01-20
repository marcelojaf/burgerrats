import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:burgerrats/features/check_ins/domain/entities/check_in_entity.dart';
import 'package:burgerrats/features/check_ins/domain/repositories/check_in_repository.dart';
import 'package:burgerrats/features/streak_tracker/domain/entities/streak_entity.dart';
import 'package:burgerrats/features/streak_tracker/domain/repositories/streak_repository.dart';
import 'package:burgerrats/features/streak_tracker/domain/services/streak_tracker_service.dart';

class MockStreakRepository extends Mock implements StreakRepository {}

class MockCheckInRepository extends Mock implements CheckInRepository {}

class MockUuid extends Mock implements Uuid {}

void main() {
  late MockStreakRepository mockStreakRepository;
  late MockCheckInRepository mockCheckInRepository;
  late MockUuid mockUuid;
  late StreakTrackerService service;

  setUpAll(() {
    registerFallbackValue(StreakEntity.initial(id: 'test', userId: 'test'));
  });

  setUp(() {
    mockStreakRepository = MockStreakRepository();
    mockCheckInRepository = MockCheckInRepository();
    mockUuid = MockUuid();
    service = StreakTrackerService(
      mockStreakRepository,
      mockCheckInRepository,
      mockUuid,
    );
  });

  CheckInEntity createCheckIn({
    required String id,
    required String userId,
    required DateTime timestamp,
  }) {
    return CheckInEntity(
      id: id,
      userId: userId,
      leagueId: 'league-123',
      photoURL: 'https://example.com/photo.jpg',
      timestamp: timestamp,
    );
  }

  group('StreakTrackerService', () {
    group('recordCheckIn', () {
      test('should create new streak for first check-in', () async {
        final checkIn = createCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          timestamp: DateTime(2026, 1, 19, 12, 0),
        );

        when(() => mockUuid.v4()).thenReturn('streak-new');
        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => null);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.recordCheckIn(checkIn);

        expect(result.currentStreak, 1);
        expect(result.totalCheckIns, 1);
        expect(result.userId, 'user-123');

        verify(() => mockStreakRepository.saveStreak(any())).called(1);
      });

      test('should increment streak for consecutive day check-in', () async {
        final yesterday = DateTime(2026, 1, 18, 12, 0);
        final today = DateTime(2026, 1, 19, 12, 0);

        final existingStreak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          lastCheckInDate: yesterday,
          streakStartDate: DateTime(2026, 1, 13),
          totalCheckIns: 5,
          updatedAt: yesterday,
        );

        final checkIn = createCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          timestamp: today,
        );

        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => existingStreak);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.recordCheckIn(checkIn);

        expect(result.currentStreak, 6);
        expect(result.totalCheckIns, 6);

        verify(() => mockStreakRepository.saveStreak(any())).called(1);
      });

      test('should reset streak when day is missed', () async {
        final twoDaysAgo = DateTime(2026, 1, 17, 12, 0);
        final today = DateTime(2026, 1, 19, 12, 0);

        final existingStreak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          lastCheckInDate: twoDaysAgo,
          streakStartDate: DateTime(2026, 1, 12),
          totalCheckIns: 5,
          updatedAt: twoDaysAgo,
        );

        final checkIn = createCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          timestamp: today,
        );

        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => existingStreak);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.recordCheckIn(checkIn);

        expect(result.currentStreak, 1);
        expect(result.longestStreak, 10);
        expect(result.totalCheckIns, 6);
      });

      test('should update longest streak when current exceeds it', () async {
        final yesterday = DateTime(2026, 1, 18, 12, 0);
        final today = DateTime(2026, 1, 19, 12, 0);

        final existingStreak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 10,
          longestStreak: 10,
          lastCheckInDate: yesterday,
          streakStartDate: DateTime(2026, 1, 8),
          totalCheckIns: 10,
          updatedAt: yesterday,
        );

        final checkIn = createCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          timestamp: today,
        );

        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => existingStreak);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.recordCheckIn(checkIn);

        expect(result.currentStreak, 11);
        expect(result.longestStreak, 11);
      });

      test('should only increment total when already checked in today', () async {
        final today = DateTime(2026, 1, 19, 12, 0);

        final existingStreak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          lastCheckInDate: today.subtract(const Duration(hours: 2)),
          streakStartDate: DateTime(2026, 1, 14),
          totalCheckIns: 5,
          updatedAt: today.subtract(const Duration(hours: 2)),
        );

        final checkIn = createCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          timestamp: today,
        );

        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => existingStreak);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.recordCheckIn(checkIn);

        expect(result.currentStreak, 5);
        expect(result.totalCheckIns, 6);
      });
    });

    group('getStreakStatus', () {
      test('should create new streak for user without existing streak', () async {
        when(() => mockUuid.v4()).thenReturn('streak-new');
        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => null);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.getStreakStatus('user-123');

        expect(result.userId, 'user-123');
        expect(result.currentStreak, 0);

        verify(() => mockStreakRepository.saveStreak(any())).called(1);
      });

      test('should return existing streak if still valid', () async {
        final today = DateTime.now();
        final startOfToday = DateTime(today.year, today.month, today.day);

        final existingStreak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          lastCheckInDate: startOfToday,
          streakStartDate: DateTime(today.year, today.month, today.day - 4),
          totalCheckIns: 5,
          updatedAt: startOfToday,
        );

        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => existingStreak);

        final result = await service.getStreakStatus('user-123');

        expect(result.currentStreak, 5);
        verifyNever(() => mockStreakRepository.updateStreak(any()));
      });
    });

    group('calculateStreakFromHistory', () {
      test('should calculate correct streak from check-in history', () async {
        final checkIns = [
          createCheckIn(
            id: 'checkin-1',
            userId: 'user-123',
            timestamp: DateTime(2026, 1, 19),
          ),
          createCheckIn(
            id: 'checkin-2',
            userId: 'user-123',
            timestamp: DateTime(2026, 1, 18),
          ),
          createCheckIn(
            id: 'checkin-3',
            userId: 'user-123',
            timestamp: DateTime(2026, 1, 17),
          ),
          createCheckIn(
            id: 'checkin-4',
            userId: 'user-123',
            timestamp: DateTime(2026, 1, 15),
          ),
          createCheckIn(
            id: 'checkin-5',
            userId: 'user-123',
            timestamp: DateTime(2026, 1, 14),
          ),
        ];

        when(() => mockUuid.v4()).thenReturn('streak-new');
        when(() => mockCheckInRepository.getCheckInsByUser('user-123'))
            .thenAnswer((_) async => checkIns);
        when(() => mockStreakRepository.getStreakByUserId('user-123'))
            .thenAnswer((_) async => null);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.calculateStreakFromHistory('user-123');

        expect(result.totalCheckIns, 5);
      });

      test('should return empty streak when no check-ins', () async {
        when(() => mockUuid.v4()).thenReturn('streak-new');
        when(() => mockCheckInRepository.getCheckInsByUser('user-123'))
            .thenAnswer((_) async => []);
        when(() => mockStreakRepository.saveStreak(any()))
            .thenAnswer((_) async {});

        final result = await service.calculateStreakFromHistory('user-123');

        expect(result.currentStreak, 0);
        expect(result.longestStreak, 0);
        expect(result.totalCheckIns, 0);
      });
    });
  });

  group('StreakEntity', () {
    test('hasActiveStreak returns true when currentStreak > 0', () {
      final streak = StreakEntity(
        id: 'test',
        userId: 'user',
        currentStreak: 5,
        updatedAt: DateTime.now(),
      );

      expect(streak.hasActiveStreak, true);
    });

    test('hasActiveStreak returns false when currentStreak is 0', () {
      final streak = StreakEntity(
        id: 'test',
        userId: 'user',
        currentStreak: 0,
        updatedAt: DateTime.now(),
      );

      expect(streak.hasActiveStreak, false);
    });

    test('isPersonalBest returns true when current equals longest', () {
      final streak = StreakEntity(
        id: 'test',
        userId: 'user',
        currentStreak: 10,
        longestStreak: 10,
        updatedAt: DateTime.now(),
      );

      expect(streak.isPersonalBest, true);
    });

    test('isPersonalBest returns false when current is less than longest', () {
      final streak = StreakEntity(
        id: 'test',
        userId: 'user',
        currentStreak: 5,
        longestStreak: 10,
        updatedAt: DateTime.now(),
      );

      expect(streak.isPersonalBest, false);
    });

    test('needsCheckInToday returns true when lastCheckInDate is null', () {
      final streak = StreakEntity(
        id: 'test',
        userId: 'user',
        lastCheckInDate: null,
        updatedAt: DateTime.now(),
      );

      expect(streak.needsCheckInToday, true);
    });

    test('needsCheckInToday returns false when checked in today', () {
      final today = DateTime.now();

      final streak = StreakEntity(
        id: 'test',
        userId: 'user',
        lastCheckInDate: today,
        updatedAt: DateTime.now(),
      );

      expect(streak.needsCheckInToday, false);
    });
  });

  group('StreakGracePeriod', () {
    test('default grace period is 4 hours', () {
      const gracePeriod = StreakGracePeriod();

      expect(gracePeriod.gracePeriodHours, 4);
      expect(gracePeriod.isInGracePeriod, false);
      expect(gracePeriod.gracePeriodExpiresAt, isNull);
    });

    test('copyWith creates new instance with updated values', () {
      const original = StreakGracePeriod(
        gracePeriodHours: 4,
        isInGracePeriod: false,
      );

      final updated = original.copyWith(
        isInGracePeriod: true,
        gracePeriodExpiresAt: DateTime(2026, 1, 19, 4, 0),
      );

      expect(updated.isInGracePeriod, true);
      expect(updated.gracePeriodExpiresAt, isNotNull);
      expect(updated.gracePeriodHours, 4);
    });
  });
}
