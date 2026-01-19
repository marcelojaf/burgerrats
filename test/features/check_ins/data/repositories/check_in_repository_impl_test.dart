import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/check_ins/data/repositories/check_in_repository_impl.dart';
import 'package:burgerrats/features/check_ins/data/models/check_in_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late CheckInRepositoryImpl repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    repository = CheckInRepositoryImpl(fakeFirestore);
  });

  group('CheckInRepositoryImpl', () {
    group('createCheckIn', () {
      test('should create a new check-in', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final retrieved = await repository.getCheckInById('checkin-1');
        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'checkin-1');
        expect(retrieved.userId, 'user-123');
        expect(retrieved.leagueId, 'league-456');
      });
    });

    group('getCheckInById', () {
      test('should return check-in when it exists', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final retrieved = await repository.getCheckInById('checkin-1');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'checkin-1');
      });

      test('should return null when check-in does not exist', () async {
        final retrieved = await repository.getCheckInById('non-existent');

        expect(retrieved, isNull);
      });
    });

    group('getUserDailyCheckInCount', () {
      test('should return 0 when user has no check-ins today', () async {
        final count = await repository.getUserDailyCheckInCount('user-123');

        expect(count, 0);
      });

      test('should count only todays check-ins', () async {
        // Create a check-in for today
        final todayCheckIn = CheckInModel.newCheckIn(
          id: 'checkin-today',
          userId: 'user-123',
          leagueId: 'league-1',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(todayCheckIn);

        final count = await repository.getUserDailyCheckInCount('user-123');

        expect(count, 1);
      });

      test('should count multiple check-ins for same user today', () async {
        final checkIn1 = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-1',
          photoURL: 'https://example.com/photo1.jpg',
        );

        final checkIn2 = CheckInModel.newCheckIn(
          id: 'checkin-2',
          userId: 'user-123',
          leagueId: 'league-2',
          photoURL: 'https://example.com/photo2.jpg',
        );

        await repository.createCheckIn(checkIn1);
        await repository.createCheckIn(checkIn2);

        final count = await repository.getUserDailyCheckInCount('user-123');

        expect(count, 2);
      });
    });

    group('canUserCheckInToday', () {
      test('should return true when user has no check-ins today', () async {
        final canCheckIn = await repository.canUserCheckInToday('user-123');

        expect(canCheckIn, true);
      });

      test('should return false when user has already checked in today', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-1',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final canCheckIn = await repository.canUserCheckInToday('user-123');

        expect(canCheckIn, false);
      });
    });

    group('getUserDailyCheckInCountForLeague', () {
      test('should return 0 when user has no check-ins today for league',
          () async {
        final count = await repository.getUserDailyCheckInCountForLeague(
          'user-123',
          'league-456',
        );

        expect(count, 0);
      });

      test('should return 1 when user has one check-in today for league',
          () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final count = await repository.getUserDailyCheckInCountForLeague(
          'user-123',
          'league-456',
        );

        expect(count, 1);
      });

      test('should not count check-ins from other leagues', () async {
        final checkInLeague1 = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-1',
          photoURL: 'https://example.com/photo.jpg',
        );

        final checkInLeague2 = CheckInModel.newCheckIn(
          id: 'checkin-2',
          userId: 'user-123',
          leagueId: 'league-2',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkInLeague1);
        await repository.createCheckIn(checkInLeague2);

        final countLeague1 = await repository.getUserDailyCheckInCountForLeague(
          'user-123',
          'league-1',
        );

        final countLeague2 = await repository.getUserDailyCheckInCountForLeague(
          'user-123',
          'league-2',
        );

        expect(countLeague1, 1);
        expect(countLeague2, 1);
      });

      test('should not count check-ins from other users', () async {
        final checkInUser1 = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        final checkInUser2 = CheckInModel.newCheckIn(
          id: 'checkin-2',
          userId: 'user-456',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkInUser1);
        await repository.createCheckIn(checkInUser2);

        final countUser1 = await repository.getUserDailyCheckInCountForLeague(
          'user-123',
          'league-456',
        );

        final countUser2 = await repository.getUserDailyCheckInCountForLeague(
          'user-456',
          'league-456',
        );

        expect(countUser1, 1);
        expect(countUser2, 1);
      });
    });

    group('canUserCheckInTodayForLeague', () {
      test('should return true when user has no check-ins today for league',
          () async {
        final canCheckIn = await repository.canUserCheckInTodayForLeague(
          'user-123',
          'league-456',
        );

        expect(canCheckIn, true);
      });

      test(
          'should return false when user has already checked in today for league',
          () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final canCheckIn = await repository.canUserCheckInTodayForLeague(
          'user-123',
          'league-456',
        );

        expect(canCheckIn, false);
      });

      test(
          'should return true when user has checked in today but for different league',
          () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-1',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final canCheckInLeague1 = await repository.canUserCheckInTodayForLeague(
          'user-123',
          'league-1',
        );

        final canCheckInLeague2 = await repository.canUserCheckInTodayForLeague(
          'user-123',
          'league-2',
        );

        expect(canCheckInLeague1, false);
        expect(canCheckInLeague2, true);
      });

      test('should allow different users to check in to same league', () async {
        final checkInUser1 = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkInUser1);

        final canCheckInUser1 = await repository.canUserCheckInTodayForLeague(
          'user-123',
          'league-456',
        );

        final canCheckInUser2 = await repository.canUserCheckInTodayForLeague(
          'user-456',
          'league-456',
        );

        expect(canCheckInUser1, false);
        expect(canCheckInUser2, true);
      });
    });

    group('getUserTodayCheckInForLeague', () {
      test('should return null when user has no check-in today for league',
          () async {
        final checkIn = await repository.getUserTodayCheckInForLeague(
          'user-123',
          'league-456',
        );

        expect(checkIn, isNull);
      });

      test('should return check-in when user has checked in today for league',
          () async {
        final created = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
          note: 'Great burger!',
          rating: 5,
        );

        await repository.createCheckIn(created);

        final retrieved = await repository.getUserTodayCheckInForLeague(
          'user-123',
          'league-456',
        );

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'checkin-1');
        expect(retrieved.userId, 'user-123');
        expect(retrieved.leagueId, 'league-456');
        expect(retrieved.note, 'Great burger!');
        expect(retrieved.rating, 5);
      });

      test('should not return check-in from different league', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-1',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final retrieved = await repository.getUserTodayCheckInForLeague(
          'user-123',
          'league-2',
        );

        expect(retrieved, isNull);
      });

      test('should not return check-in from different user', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final retrieved = await repository.getUserTodayCheckInForLeague(
          'user-456',
          'league-456',
        );

        expect(retrieved, isNull);
      });
    });

    group('getCheckInsByUserAndLeague', () {
      test('should return check-ins for user and league', () async {
        final checkIn1 = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo1.jpg',
        );

        final checkIn2 = CheckInModel.newCheckIn(
          id: 'checkin-2',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo2.jpg',
        );

        final checkIn3 = CheckInModel.newCheckIn(
          id: 'checkin-3',
          userId: 'user-123',
          leagueId: 'league-other',
          photoURL: 'https://example.com/photo3.jpg',
        );

        await repository.createCheckIn(checkIn1);
        await repository.createCheckIn(checkIn2);
        await repository.createCheckIn(checkIn3);

        final checkIns = await repository.getCheckInsByUserAndLeague(
          'user-123',
          'league-456',
        );

        expect(checkIns.length, 2);
        expect(checkIns.every((c) => c.leagueId == 'league-456'), true);
      });

      test('should return empty list when no check-ins exist', () async {
        final checkIns = await repository.getCheckInsByUserAndLeague(
          'user-123',
          'league-456',
        );

        expect(checkIns, isEmpty);
      });
    });

    group('updateCheckIn', () {
      test('should update check-in note and rating', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        final updated = checkIn.copyWith(
          note: 'Updated note',
          rating: 4,
        );

        await repository.updateCheckIn(updated);

        final retrieved = await repository.getCheckInById('checkin-1');

        expect(retrieved!.note, 'Updated note');
        expect(retrieved.rating, 4);
      });
    });

    group('deleteCheckIn', () {
      test('should delete check-in', () async {
        final checkIn = CheckInModel.newCheckIn(
          id: 'checkin-1',
          userId: 'user-123',
          leagueId: 'league-456',
          photoURL: 'https://example.com/photo.jpg',
        );

        await repository.createCheckIn(checkIn);

        await repository.deleteCheckIn('checkin-1');

        final retrieved = await repository.getCheckInById('checkin-1');

        expect(retrieved, isNull);
      });
    });
  });
}
