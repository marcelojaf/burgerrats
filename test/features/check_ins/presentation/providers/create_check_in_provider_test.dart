import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/services/image_compression_service.dart';
import 'package:burgerrats/core/services/photo_capture_service.dart';
import 'package:burgerrats/features/check_ins/domain/repositories/check_in_repository.dart';
import 'package:burgerrats/features/check_ins/presentation/providers/create_check_in_provider.dart';
import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';
import 'package:burgerrats/features/leagues/domain/repositories/league_repository.dart';

class MockCheckInRepository extends Mock implements CheckInRepository {}

class MockLeagueRepository extends Mock implements LeagueRepository {}

class MockImageCompressionService extends Mock
    implements ImageCompressionService {}

class FakeFile extends Fake implements File {}

void main() {
  late MockCheckInRepository mockCheckInRepository;
  late MockLeagueRepository mockLeagueRepository;
  late MockImageCompressionService mockCompressionService;
  late CreateCheckInNotifier notifier;

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockCheckInRepository = MockCheckInRepository();
    mockLeagueRepository = MockLeagueRepository();
    mockCompressionService = MockImageCompressionService();
    notifier = CreateCheckInNotifier(
      mockCheckInRepository,
      mockLeagueRepository,
      mockCompressionService,
    );
  });

  group('CreateCheckInNotifier', () {
    final now = DateTime.now();
    final testLeagues = [
      LeagueEntity(
        id: 'league-1',
        name: 'Test League 1',
        createdBy: 'user-123',
        members: [
          LeagueMember(
            userId: 'user-123',
            role: LeagueMemberRole.owner,
            joinedAt: now,
          ),
        ],
        inviteCode: 'TEST1234',
        createdAt: now,
      ),
      LeagueEntity(
        id: 'league-2',
        name: 'Test League 2',
        createdBy: 'user-456',
        members: [
          LeagueMember(
            userId: 'user-123',
            role: LeagueMemberRole.member,
            joinedAt: now,
          ),
        ],
        inviteCode: 'TEST5678',
        createdAt: now,
      ),
    ];

    group('initial state', () {
      test('should have initial status', () {
        expect(notifier.state.status, CreateCheckInStatus.initial);
        expect(notifier.state.userLeagues, isEmpty);
        expect(notifier.state.selectedLeagueId, isNull);
        expect(notifier.state.photo, isNull);
        expect(notifier.state.canCheckIn, true);
        expect(notifier.state.canSubmit, false);
      });
    });

    group('loadUserLeagues', () {
      test('should load leagues and set ready status', () async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenAnswer((_) async => testLeagues);

        await notifier.loadUserLeagues('user-123');

        expect(notifier.state.status, CreateCheckInStatus.ready);
        expect(notifier.state.userLeagues, testLeagues);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should set error status on failure', () async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenThrow(Exception('Network error'));

        await notifier.loadUserLeagues('user-123');

        expect(notifier.state.status, CreateCheckInStatus.error);
        expect(notifier.state.errorMessage, isNotNull);
      });

      test('should show loading status while fetching', () async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenAnswer((_) async {
          // Verify loading state is set during fetch
          expect(notifier.state.status, CreateCheckInStatus.loading);
          return testLeagues;
        });

        await notifier.loadUserLeagues('user-123');
      });
    });

    group('selectLeague', () {
      setUp(() async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenAnswer((_) async => testLeagues);
        await notifier.loadUserLeagues('user-123');
      });

      test('should select league and check daily limit (allowed)', () async {
        when(() => mockCheckInRepository.canUserCheckInTodayForLeague(
              'user-123',
              'league-1',
            )).thenAnswer((_) async => true);

        await notifier.selectLeague('league-1', 'user-123');

        expect(notifier.state.selectedLeagueId, 'league-1');
        expect(notifier.state.selectedLeague!.id, 'league-1');
        expect(notifier.state.canCheckIn, true);
        expect(notifier.state.dailyLimitMessage, isNull);
      });

      test('should show daily limit message when already checked in', () async {
        when(() => mockCheckInRepository.canUserCheckInTodayForLeague(
              'user-123',
              'league-1',
            )).thenAnswer((_) async => false);

        await notifier.selectLeague('league-1', 'user-123');

        expect(notifier.state.selectedLeagueId, 'league-1');
        expect(notifier.state.canCheckIn, false);
        expect(notifier.state.dailyLimitMessage, isNotNull);
      });

      test('should set error on daily limit check failure', () async {
        when(() => mockCheckInRepository.canUserCheckInTodayForLeague(
              'user-123',
              'league-1',
            )).thenThrow(Exception('Network error'));

        await notifier.selectLeague('league-1', 'user-123');

        expect(notifier.state.status, CreateCheckInStatus.error);
        expect(notifier.state.errorMessage, isNotNull);
      });
    });

    group('setPhoto', () {
      test('should set photo and update status', () {
        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );

        notifier.setPhoto(mockPhoto);

        expect(notifier.state.photo, mockPhoto);
        expect(notifier.state.status, CreateCheckInStatus.photoReady);
        expect(notifier.state.hasPhoto, true);
      });
    });

    group('clearPhoto', () {
      test('should clear photo and reset status', () {
        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );

        notifier.setPhoto(mockPhoto);
        notifier.clearPhoto();

        expect(notifier.state.photo, isNull);
        expect(notifier.state.hasPhoto, false);
        expect(notifier.state.status, CreateCheckInStatus.initial);
      });
    });

    group('setRestaurantName', () {
      test('should set restaurant name', () {
        notifier.setRestaurantName('Burger King');

        expect(notifier.state.restaurantName, 'Burger King');
      });

      test('should clear restaurant name when null or empty', () {
        notifier.setRestaurantName('Burger King');
        notifier.setRestaurantName('');

        expect(notifier.state.restaurantName, isNull);
      });
    });

    group('setRating', () {
      test('should set rating', () {
        notifier.setRating(5);

        expect(notifier.state.rating, 5);
      });

      test('should allow null rating', () {
        notifier.setRating(5);
        notifier.setRating(null);

        expect(notifier.state.rating, isNull);
      });
    });

    group('setNote', () {
      test('should set note', () {
        notifier.setNote('Great burger!');

        expect(notifier.state.note, 'Great burger!');
      });

      test('should clear note when null or empty', () {
        notifier.setNote('Great burger!');
        notifier.setNote('');

        expect(notifier.state.note, isNull);
      });
    });

    group('canSubmit', () {
      test('should return false when no photo', () {
        expect(notifier.state.canSubmit, false);
      });

      test('should return false when no league selected', () async {
        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );

        notifier.setPhoto(mockPhoto);

        expect(notifier.state.canSubmit, false);
      });

      test('should return false when daily limit reached', () async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenAnswer((_) async => testLeagues);
        when(() => mockCheckInRepository.canUserCheckInTodayForLeague(
              'user-123',
              'league-1',
            )).thenAnswer((_) async => false);

        await notifier.loadUserLeagues('user-123');
        await notifier.selectLeague('league-1', 'user-123');

        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );

        notifier.setPhoto(mockPhoto);

        expect(notifier.state.canSubmit, false);
      });

      test('should return true when all conditions met', () async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenAnswer((_) async => testLeagues);
        when(() => mockCheckInRepository.canUserCheckInTodayForLeague(
              'user-123',
              'league-1',
            )).thenAnswer((_) async => true);

        await notifier.loadUserLeagues('user-123');
        await notifier.selectLeague('league-1', 'user-123');

        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );

        notifier.setPhoto(mockPhoto);

        expect(notifier.state.canSubmit, true);
      });
    });

    group('reset', () {
      test('should reset to initial state', () async {
        when(() => mockLeagueRepository.getLeaguesForUser('user-123'))
            .thenAnswer((_) async => testLeagues);
        when(() => mockCheckInRepository.canUserCheckInTodayForLeague(
              'user-123',
              'league-1',
            )).thenAnswer((_) async => true);

        await notifier.loadUserLeagues('user-123');
        await notifier.selectLeague('league-1', 'user-123');

        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );

        notifier.setPhoto(mockPhoto);
        notifier.setRestaurantName('Burger King');
        notifier.setRating(5);
        notifier.setNote('Great!');

        notifier.reset();

        expect(notifier.state.status, CreateCheckInStatus.initial);
        expect(notifier.state.userLeagues, isEmpty);
        expect(notifier.state.selectedLeagueId, isNull);
        expect(notifier.state.photo, isNull);
        expect(notifier.state.restaurantName, isNull);
        expect(notifier.state.rating, isNull);
        expect(notifier.state.note, isNull);
      });
    });
  });
}
