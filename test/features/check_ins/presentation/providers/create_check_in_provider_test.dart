import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:burgerrats/core/services/check_in_notification_service.dart';
import 'package:burgerrats/core/services/firebase_storage_service.dart';
import 'package:burgerrats/core/services/image_compression_service.dart';
import 'package:burgerrats/core/services/photo_capture_service.dart';
import 'package:burgerrats/features/check_ins/domain/entities/check_in_entity.dart';
import 'package:burgerrats/features/check_ins/domain/repositories/check_in_repository.dart';
import 'package:burgerrats/features/check_ins/presentation/providers/create_check_in_provider.dart';
import 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';
import 'package:burgerrats/features/leagues/domain/repositories/league_repository.dart';

class MockCheckInRepository extends Mock implements CheckInRepository {}

class MockLeagueRepository extends Mock implements LeagueRepository {}

class MockImageCompressionService extends Mock
    implements ImageCompressionService {}

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {}

class MockCheckInNotificationService extends Mock
    implements CheckInNotificationService {}

class FakeFile extends Fake implements File {}

class FakeCheckInEntity extends Fake implements CheckInEntity {}

void main() {
  late MockCheckInRepository mockCheckInRepository;
  late MockLeagueRepository mockLeagueRepository;
  late MockImageCompressionService mockCompressionService;
  late MockFirebaseStorageService mockStorageService;
  late MockCheckInNotificationService mockNotificationService;
  late CreateCheckInNotifier notifier;

  setUpAll(() {
    registerFallbackValue(FakeFile());
    registerFallbackValue(FakeCheckInEntity());
  });

  setUp(() {
    mockCheckInRepository = MockCheckInRepository();
    mockLeagueRepository = MockLeagueRepository();
    mockCompressionService = MockImageCompressionService();
    mockStorageService = MockFirebaseStorageService();
    mockNotificationService = MockCheckInNotificationService();

    // Default stub for notification service (fire-and-forget, shouldn't block)
    when(
      () => mockNotificationService.sendCheckInNotification(
        checkInId: any(named: 'checkInId'),
        userId: any(named: 'userId'),
        userName: any(named: 'userName'),
        leagueId: any(named: 'leagueId'),
        leagueName: any(named: 'leagueName'),
        restaurantName: any(named: 'restaurantName'),
      ),
    ).thenAnswer((_) async {});

    notifier = CreateCheckInNotifier(
      mockCheckInRepository,
      mockLeagueRepository,
      mockCompressionService,
      mockStorageService,
      mockNotificationService,
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
        expect(notifier.state.submissionStep, SubmissionStep.idle);
        expect(notifier.state.uploadProgress, 0.0);
      });
    });

    group('loadUserLeagues', () {
      test('should load leagues and set ready status', () async {
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);

        await notifier.loadUserLeagues('user-123');

        expect(notifier.state.status, CreateCheckInStatus.ready);
        expect(notifier.state.userLeagues, testLeagues);
        expect(notifier.state.errorMessage, isNull);
      });

      test('should set error status on failure', () async {
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenThrow(Exception('Network error'));

        await notifier.loadUserLeagues('user-123');

        expect(notifier.state.status, CreateCheckInStatus.error);
        expect(notifier.state.errorMessage, isNotNull);
      });

      test('should show loading status while fetching', () async {
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async {
          // Verify loading state is set during fetch
          expect(notifier.state.status, CreateCheckInStatus.loading);
          return testLeagues;
        });

        await notifier.loadUserLeagues('user-123');
      });
    });

    group('selectLeague', () {
      setUp(() async {
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);
        await notifier.loadUserLeagues('user-123');
      });

      test('should select league and check daily limit (allowed)', () async {
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => true);

        await notifier.selectLeague('league-1', 'user-123');

        expect(notifier.state.selectedLeagueId, 'league-1');
        expect(notifier.state.selectedLeague!.id, 'league-1');
        expect(notifier.state.canCheckIn, true);
        expect(notifier.state.dailyLimitMessage, isNull);
      });

      test('should show daily limit message when already checked in', () async {
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => false);

        await notifier.selectLeague('league-1', 'user-123');

        expect(notifier.state.selectedLeagueId, 'league-1');
        expect(notifier.state.canCheckIn, false);
        expect(notifier.state.dailyLimitMessage, isNotNull);
      });

      test('should set error on daily limit check failure', () async {
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenThrow(Exception('Network error'));

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
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => false);

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
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => true);

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
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => true);

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
        expect(notifier.state.submissionStep, SubmissionStep.idle);
        expect(notifier.state.uploadProgress, 0.0);
      });
    });

    group('submissionStep', () {
      test('should be idle by default', () {
        expect(notifier.state.submissionStep, SubmissionStep.idle);
      });

      test('should track submission step changes', () {
        // Test compressing step
        final compressingState = notifier.state.copyWith(
          submissionStep: SubmissionStep.compressing,
        );
        expect(compressingState.submissionStep, SubmissionStep.compressing);

        // Test uploading step with progress
        final uploadingState = notifier.state.copyWith(
          submissionStep: SubmissionStep.uploading,
          uploadProgress: 0.5,
        );
        expect(uploadingState.submissionStep, SubmissionStep.uploading);
        expect(uploadingState.uploadProgress, 0.5);

        // Test creating document step
        final creatingState = notifier.state.copyWith(
          submissionStep: SubmissionStep.creatingDocument,
        );
        expect(creatingState.submissionStep, SubmissionStep.creatingDocument);

        // Test updating points step
        final updatingPointsState = notifier.state.copyWith(
          submissionStep: SubmissionStep.updatingPoints,
        );
        expect(updatingPointsState.submissionStep, SubmissionStep.updatingPoints);
      });
    });

    group('submitCheckIn', () {
      test('should return false when canSubmit is false', () async {
        final result = await notifier.submitCheckIn('user-123');
        expect(result, false);
      });

      test('should successfully submit check-in with all steps', () async {
        // Setup: load leagues and select one
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => true);

        await notifier.loadUserLeagues('user-123');
        await notifier.selectLeague('league-1', 'user-123');

        // Setup: set photo
        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );
        notifier.setPhoto(mockPhoto);

        // Setup: mock compression service
        final compressionResult = CompressionResult(
          file: File('/tmp/compressed.jpg'),
          originalPath: '/tmp/test.jpg',
          compressedPath: '/tmp/compressed.jpg',
          originalSizeInBytes: 1024,
          compressedSizeInBytes: 512,
          compressionRatio: 0.5,
          savedPercentage: 50.0,
        );
        when(
          () => mockCompressionService.compressPhotoCapture(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => compressionResult);

        // Setup: mock storage service
        final uploadResult = UploadResult(
          downloadUrl: 'https://storage.example.com/photo.jpg',
          storagePath: 'check-ins/user-123/2024/01/15/photo.jpg',
          fileName: 'photo.jpg',
          sizeInBytes: 512,
          uploadedAt: DateTime.now(),
        );
        when(
          () => mockStorageService.uploadCheckInPhoto(
            userId: any(named: 'userId'),
            leagueId: any(named: 'leagueId'),
            file: any(named: 'file'),
            options: any(named: 'options'),
            onProgress: any(named: 'onProgress'),
          ),
        ).thenAnswer((_) async => uploadResult);

        // Setup: mock check-in creation
        when(
          () => mockCheckInRepository.createCheckIn(any()),
        ).thenAnswer((_) async {});

        // Setup: mock points update
        when(
          () => mockLeagueRepository.addMemberPoints(
            leagueId: any(named: 'leagueId'),
            userId: any(named: 'userId'),
            pointsToAdd: any(named: 'pointsToAdd'),
          ),
        ).thenAnswer((_) async {});

        // Execute
        final result = await notifier.submitCheckIn(
          'user-123',
          userName: 'John Doe',
        );

        // Verify
        expect(result, true);
        expect(notifier.state.status, CreateCheckInStatus.success);
        expect(notifier.state.submissionStep, SubmissionStep.idle);
        expect(notifier.state.createdCheckInId, isNotNull);

        // Verify all service calls were made
        verify(
          () => mockCompressionService.compressPhotoCapture(
            any(),
            options: any(named: 'options'),
          ),
        ).called(1);
        verify(
          () => mockStorageService.uploadCheckInPhoto(
            userId: 'user-123',
            leagueId: 'league-1',
            file: any(named: 'file'),
            options: any(named: 'options'),
            onProgress: any(named: 'onProgress'),
          ),
        ).called(1);
        verify(() => mockCheckInRepository.createCheckIn(any())).called(1);
        verify(
          () => mockLeagueRepository.addMemberPoints(
            leagueId: 'league-1',
            userId: 'user-123',
            pointsToAdd: 10, // Default pointsPerCheckIn
          ),
        ).called(1);

        // Verify notification was sent
        verify(
          () => mockNotificationService.sendCheckInNotification(
            checkInId: any(named: 'checkInId'),
            userId: 'user-123',
            userName: 'John Doe',
            leagueId: 'league-1',
            leagueName: 'Test League 1',
            restaurantName: any(named: 'restaurantName'),
          ),
        ).called(1);
      });

      test('should handle compression error gracefully', () async {
        // Setup
        when(
          () => mockLeagueRepository.getLeaguesForUser('user-123'),
        ).thenAnswer((_) async => testLeagues);
        when(
          () => mockCheckInRepository.canUserCheckInTodayForLeague(
            'user-123',
            'league-1',
          ),
        ).thenAnswer((_) async => true);

        await notifier.loadUserLeagues('user-123');
        await notifier.selectLeague('league-1', 'user-123');

        final mockPhoto = PhotoCaptureResult(
          file: File('/tmp/test.jpg'),
          fileName: 'test.jpg',
          path: '/tmp/test.jpg',
          sizeInBytes: 1024,
        );
        notifier.setPhoto(mockPhoto);

        // Mock compression to throw error
        when(
          () => mockCompressionService.compressPhotoCapture(
            any(),
            options: any(named: 'options'),
          ),
        ).thenThrow(Exception('Compression failed'));

        // Execute
        final result = await notifier.submitCheckIn('user-123');

        // Verify
        expect(result, false);
        expect(notifier.state.status, CreateCheckInStatus.photoReady);
        expect(notifier.state.submissionStep, SubmissionStep.idle);
        expect(notifier.state.errorMessage, isNotNull);
      });
    });
  });
}
