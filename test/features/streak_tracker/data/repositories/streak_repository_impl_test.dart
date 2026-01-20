import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/streak_tracker/data/repositories/streak_repository_impl.dart';
import 'package:burgerrats/features/streak_tracker/domain/entities/streak_entity.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late StreakRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = StreakRepositoryImpl(fakeFirestore);
  });

  group('StreakRepositoryImpl', () {
    group('saveStreak', () {
      test('should create a new streak record', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          lastCheckInDate: DateTime(2026, 1, 19),
          streakStartDate: DateTime(2026, 1, 14),
          totalCheckIns: 15,
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);

        final retrieved = await repository.getStreakById('streak-123');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'streak-123');
        expect(retrieved.userId, 'user-123');
        expect(retrieved.currentStreak, 5);
        expect(retrieved.longestStreak, 10);
        expect(retrieved.totalCheckIns, 15);
      });
    });

    group('getStreakByUserId', () {
      test('should return streak when it exists', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          totalCheckIns: 15,
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);

        final retrieved = await repository.getStreakByUserId('user-123');

        expect(retrieved, isNotNull);
        expect(retrieved!.userId, 'user-123');
        expect(retrieved.currentStreak, 5);
      });

      test('should return null when streak does not exist', () async {
        final retrieved = await repository.getStreakByUserId('non-existent');

        expect(retrieved, isNull);
      });
    });

    group('getStreakById', () {
      test('should return streak when it exists', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);

        final retrieved = await repository.getStreakById('streak-123');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'streak-123');
      });

      test('should return null when streak does not exist', () async {
        final retrieved = await repository.getStreakById('non-existent');

        expect(retrieved, isNull);
      });
    });

    group('updateStreak', () {
      test('should update existing streak', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          longestStreak: 10,
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);

        final updated = streak.copyWith(
          currentStreak: 6,
          longestStreak: 11,
          updatedAt: DateTime.now(),
        );

        await repository.updateStreak(updated);

        final retrieved = await repository.getStreakById('streak-123');

        expect(retrieved!.currentStreak, 6);
        expect(retrieved.longestStreak, 11);
      });
    });

    group('deleteStreak', () {
      test('should delete streak', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);
        await repository.deleteStreak('streak-123');

        final retrieved = await repository.getStreakById('streak-123');

        expect(retrieved, isNull);
      });
    });

    group('getTopStreaks', () {
      test('should return streaks sorted by current streak descending', () async {
        await repository.saveStreak(StreakEntity(
          id: 'streak-1',
          userId: 'user-1',
          currentStreak: 5,
          updatedAt: DateTime.now(),
        ));

        await repository.saveStreak(StreakEntity(
          id: 'streak-2',
          userId: 'user-2',
          currentStreak: 15,
          updatedAt: DateTime.now(),
        ));

        await repository.saveStreak(StreakEntity(
          id: 'streak-3',
          userId: 'user-3',
          currentStreak: 10,
          updatedAt: DateTime.now(),
        ));

        final topStreaks = await repository.getTopStreaks(limit: 10);

        expect(topStreaks.length, 3);
        expect(topStreaks[0].currentStreak, 15);
        expect(topStreaks[1].currentStreak, 10);
        expect(topStreaks[2].currentStreak, 5);
      });

      test('should respect limit parameter', () async {
        for (var i = 1; i <= 5; i++) {
          await repository.saveStreak(StreakEntity(
            id: 'streak-$i',
            userId: 'user-$i',
            currentStreak: i * 5,
            updatedAt: DateTime.now(),
          ));
        }

        final topStreaks = await repository.getTopStreaks(limit: 3);

        expect(topStreaks.length, 3);
        expect(topStreaks[0].currentStreak, 25);
      });

      test('should exclude streaks with 0 current streak', () async {
        await repository.saveStreak(StreakEntity(
          id: 'streak-1',
          userId: 'user-1',
          currentStreak: 0,
          updatedAt: DateTime.now(),
        ));

        await repository.saveStreak(StreakEntity(
          id: 'streak-2',
          userId: 'user-2',
          currentStreak: 5,
          updatedAt: DateTime.now(),
        ));

        final topStreaks = await repository.getTopStreaks();

        expect(topStreaks.length, 1);
        expect(topStreaks[0].userId, 'user-2');
      });
    });

    group('getTopLongestStreaks', () {
      test('should return streaks sorted by longest streak descending', () async {
        await repository.saveStreak(StreakEntity(
          id: 'streak-1',
          userId: 'user-1',
          currentStreak: 5,
          longestStreak: 20,
          updatedAt: DateTime.now(),
        ));

        await repository.saveStreak(StreakEntity(
          id: 'streak-2',
          userId: 'user-2',
          currentStreak: 15,
          longestStreak: 15,
          updatedAt: DateTime.now(),
        ));

        await repository.saveStreak(StreakEntity(
          id: 'streak-3',
          userId: 'user-3',
          currentStreak: 10,
          longestStreak: 30,
          updatedAt: DateTime.now(),
        ));

        final topStreaks = await repository.getTopLongestStreaks(limit: 10);

        expect(topStreaks.length, 3);
        expect(topStreaks[0].longestStreak, 30);
        expect(topStreaks[1].longestStreak, 20);
        expect(topStreaks[2].longestStreak, 15);
      });
    });

    group('watchUserStreak', () {
      test('should emit streak updates', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);

        final stream = repository.watchUserStreak('user-123');

        expect(
          stream,
          emitsInOrder([
            predicate<StreakEntity?>(
                (s) => s != null && s.currentStreak == 5),
          ]),
        );
      });

      test('should emit null when user has no streak', () async {
        final stream = repository.watchUserStreak('non-existent');

        expect(stream, emits(isNull));
      });
    });

    group('shouldResetStreak', () {
      test('should return false when user has no streak', () async {
        final shouldReset = await repository.shouldResetStreak('non-existent');

        expect(shouldReset, false);
      });

      test('should return false when current streak is 0', () async {
        await repository.saveStreak(StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 0,
          updatedAt: DateTime.now(),
        ));

        final shouldReset = await repository.shouldResetStreak('user-123');

        expect(shouldReset, false);
      });

      test('should return true when no last check-in date', () async {
        await repository.saveStreak(StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          lastCheckInDate: null,
          updatedAt: DateTime.now(),
        ));

        final shouldReset = await repository.shouldResetStreak('user-123');

        expect(shouldReset, true);
      });

      test('should return false when checked in today', () async {
        final today = DateTime.now();

        await repository.saveStreak(StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          lastCheckInDate: today,
          updatedAt: DateTime.now(),
        ));

        final shouldReset = await repository.shouldResetStreak('user-123');

        expect(shouldReset, false);
      });
    });

    group('grace period', () {
      test('should save and retrieve grace period settings', () async {
        final streak = StreakEntity(
          id: 'streak-123',
          userId: 'user-123',
          currentStreak: 5,
          gracePeriod: StreakGracePeriod(
            gracePeriodHours: 6,
            isInGracePeriod: true,
            gracePeriodExpiresAt: DateTime(2026, 1, 19, 6, 0),
          ),
          updatedAt: DateTime.now(),
        );

        await repository.saveStreak(streak);

        final retrieved = await repository.getStreakByUserId('user-123');

        expect(retrieved!.gracePeriod.gracePeriodHours, 6);
        expect(retrieved.gracePeriod.isInGracePeriod, true);
        expect(retrieved.gracePeriod.gracePeriodExpiresAt, isNotNull);
      });
    });
  });
}
