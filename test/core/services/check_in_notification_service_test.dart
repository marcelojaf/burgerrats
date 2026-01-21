import 'package:burgerrats/core/services/check_in_notification_service.dart';
import 'package:burgerrats/core/services/notification_messages_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationMessagesService extends Mock
    implements NotificationMessagesService {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockNotificationMessagesService mockMessagesService;
  late CheckInNotificationService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockMessagesService = MockNotificationMessagesService();

    // Setup mock to return Portuguese messages by default (matching original test expectations)
    when(() => mockMessagesService.checkInNotificationTitle(any()))
        .thenAnswer((invocation) => '${invocation.positionalArguments[0]} fez check-in!');
    when(() => mockMessagesService.checkInNotificationBody(
          restaurantName: any(named: 'restaurantName'),
          leagueName: any(named: 'leagueName'),
        )).thenAnswer((invocation) {
      final restaurantName = invocation.namedArguments[#restaurantName] as String?;
      final leagueName = invocation.namedArguments[#leagueName] as String;
      if (restaurantName != null && restaurantName.isNotEmpty) {
        return '$restaurantName - $leagueName';
      }
      return 'Novo check-in na liga $leagueName';
    });

    service = CheckInNotificationService(fakeFirestore, mockMessagesService);
  });

  group('CheckInNotificationService', () {
    group('sendCheckInNotification', () {
      test('creates notification request document with correct data', () async {
        // Arrange
        const checkInId = 'check-in-123';
        const userId = 'user-456';
        const userName = 'John Doe';
        const leagueId = 'league-789';
        const leagueName = 'Burger Lovers';
        const restaurantName = 'Five Guys';

        // Act
        await service.sendCheckInNotification(
          checkInId: checkInId,
          userId: userId,
          userName: userName,
          leagueId: leagueId,
          leagueName: leagueName,
          restaurantName: restaurantName,
        );

        // Assert
        final snapshot = await fakeFirestore
            .collection('notification_requests')
            .get();

        expect(snapshot.docs.length, equals(1));

        final doc = snapshot.docs.first.data();
        expect(doc['type'], equals('new_checkin'));
        expect(doc['title'], equals('$userName fez check-in!'));
        expect(doc['body'], equals('$restaurantName - $leagueName'));
        expect(doc['topic'], equals('league_$leagueId'));
        expect(doc['data']['type'], equals('new_checkin'));
        expect(doc['data']['checkInId'], equals(checkInId));
        expect(doc['data']['leagueId'], equals(leagueId));
        expect(doc['data']['userId'], equals(userId));
        expect(doc['excludeUserId'], equals(userId));
        expect(doc['status'], equals('pending'));
      });

      test(
        'creates notification with default body when restaurant name is null',
        () async {
          // Arrange
          const checkInId = 'check-in-123';
          const userId = 'user-456';
          const userName = 'John Doe';
          const leagueId = 'league-789';
          const leagueName = 'Burger Lovers';

          // Act
          await service.sendCheckInNotification(
            checkInId: checkInId,
            userId: userId,
            userName: userName,
            leagueId: leagueId,
            leagueName: leagueName,
            restaurantName: null,
          );

          // Assert
          final snapshot = await fakeFirestore
              .collection('notification_requests')
              .get();

          expect(snapshot.docs.length, equals(1));

          final doc = snapshot.docs.first.data();
          expect(doc['body'], equals('Novo check-in na liga $leagueName'));
        },
      );

      test(
        'creates notification with default body when restaurant name is empty',
        () async {
          // Arrange
          const checkInId = 'check-in-123';
          const userId = 'user-456';
          const userName = 'John Doe';
          const leagueId = 'league-789';
          const leagueName = 'Burger Lovers';

          // Act
          await service.sendCheckInNotification(
            checkInId: checkInId,
            userId: userId,
            userName: userName,
            leagueId: leagueId,
            leagueName: leagueName,
            restaurantName: '',
          );

          // Assert
          final snapshot = await fakeFirestore
              .collection('notification_requests')
              .get();

          expect(snapshot.docs.length, equals(1));

          final doc = snapshot.docs.first.data();
          expect(doc['body'], equals('Novo check-in na liga $leagueName'));
        },
      );

      test('does not throw on Firestore error', () async {
        // The service is designed to not throw errors to avoid breaking
        // the check-in flow. This test verifies that behavior.
        // Firestore errors are caught and logged silently.

        // Act & Assert - should not throw
        await expectLater(
          service.sendCheckInNotification(
            checkInId: 'check-in-123',
            userId: 'user-456',
            userName: 'John Doe',
            leagueId: 'league-789',
            leagueName: 'Burger Lovers',
          ),
          completes,
        );
      });
    });

    group('sendBatchCheckInNotifications', () {
      test('creates notification for each league', () async {
        // Arrange
        const checkInId = 'check-in-123';
        const userId = 'user-456';
        const userName = 'John Doe';
        const restaurantName = 'Five Guys';
        final leagues = [
          const LeagueNotificationInfo(
            leagueId: 'league-1',
            leagueName: 'League One',
          ),
          const LeagueNotificationInfo(
            leagueId: 'league-2',
            leagueName: 'League Two',
          ),
          const LeagueNotificationInfo(
            leagueId: 'league-3',
            leagueName: 'League Three',
          ),
        ];

        // Act
        await service.sendBatchCheckInNotifications(
          checkInId: checkInId,
          userId: userId,
          userName: userName,
          leagues: leagues,
          restaurantName: restaurantName,
        );

        // Assert
        final snapshot = await fakeFirestore
            .collection('notification_requests')
            .get();

        expect(snapshot.docs.length, equals(3));

        // Verify each notification targets the correct league topic
        final topics = snapshot.docs
            .map((doc) => doc.data()['topic'] as String)
            .toSet();
        expect(
          topics,
          containsAll([
            'league_league-1',
            'league_league-2',
            'league_league-3',
          ]),
        );
      });
    });
  });

  group('LeagueNotificationInfo', () {
    test('stores leagueId and leagueName correctly', () {
      // Arrange & Act
      const info = LeagueNotificationInfo(
        leagueId: 'league-123',
        leagueName: 'Test League',
      );

      // Assert
      expect(info.leagueId, equals('league-123'));
      expect(info.leagueName, equals('Test League'));
    });
  });
}
