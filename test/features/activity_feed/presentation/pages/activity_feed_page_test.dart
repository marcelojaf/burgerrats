import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:burgerrats/features/activity_feed/domain/entities/activity_feed_entry.dart';
import 'package:burgerrats/features/activity_feed/presentation/providers/activity_feed_provider.dart';
import 'package:burgerrats/features/activity_feed/presentation/widgets/feed_item_card.dart';
import 'package:burgerrats/features/check_ins/domain/entities/check_in_entity.dart';

void main() {
  group('ActivityFeedEntry', () {
    late CheckInEntity testCheckIn;
    late ActivityFeedEntry testEntry;

    setUp(() {
      testCheckIn = CheckInEntity(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: DateTime(2024, 1, 15, 12, 30),
        rating: 5,
        note: 'Amazing burger!',
        restaurantName: 'Best Burger Place',
      );

      testEntry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John Doe',
        userPhotoURL: 'https://example.com/avatar.jpg',
        leagueName: 'Burger Lovers League',
      );
    });

    test('should have correct id from checkIn', () {
      expect(testEntry.id, 'checkin-123');
    });

    test('should have correct userId from checkIn', () {
      expect(testEntry.userId, 'user-456');
    });

    test('should have correct leagueId from checkIn', () {
      expect(testEntry.leagueId, 'league-789');
    });

    test('should have correct photoURL from checkIn', () {
      expect(testEntry.photoURL, 'https://example.com/burger.jpg');
    });

    test('should have correct timestamp from checkIn', () {
      expect(testEntry.timestamp, DateTime(2024, 1, 15, 12, 30));
    });

    test('should have correct rating from checkIn', () {
      expect(testEntry.rating, 5);
      expect(testEntry.hasRating, true);
    });

    test('should have correct note from checkIn', () {
      expect(testEntry.note, 'Amazing burger!');
      expect(testEntry.hasNote, true);
    });

    test('should have correct restaurantName from checkIn', () {
      expect(testEntry.restaurantName, 'Best Burger Place');
    });

    test('should have correct userName', () {
      expect(testEntry.userName, 'John Doe');
    });

    test('should have correct userPhotoURL', () {
      expect(testEntry.userPhotoURL, 'https://example.com/avatar.jpg');
      expect(testEntry.hasUserPhoto, true);
    });

    test('should have correct leagueName', () {
      expect(testEntry.leagueName, 'Burger Lovers League');
    });

    test('should generate correct initials for single word name', () {
      final entry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John',
        leagueName: 'Test League',
      );
      expect(entry.userInitials, 'JO');
    });

    test('should generate correct initials for two word name', () {
      expect(testEntry.userInitials, 'JD');
    });

    test('should generate correct initials for multiple word name', () {
      final entry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John Michael Doe',
        leagueName: 'Test League',
      );
      expect(entry.userInitials, 'JM');
    });

    test('should handle empty name for initials', () {
      final entry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: '',
        leagueName: 'Test League',
      );
      expect(entry.userInitials, '?');
    });

    test('should have hasUserPhoto false when no photo', () {
      final entry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John Doe',
        userPhotoURL: null,
        leagueName: 'Test League',
      );
      expect(entry.hasUserPhoto, false);
    });

    test('should have hasUserPhoto false when empty photo', () {
      final entry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John Doe',
        userPhotoURL: '',
        leagueName: 'Test League',
      );
      expect(entry.hasUserPhoto, false);
    });

    test('should have hasRating false when no rating', () {
      final checkInNoRating = CheckInEntity(
        id: 'checkin-no-rating',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: DateTime(2024, 1, 15),
        rating: null,
      );
      final entry = ActivityFeedEntry(
        checkIn: checkInNoRating,
        userName: 'John Doe',
        leagueName: 'Test League',
      );
      expect(entry.hasRating, false);
    });

    test('should have hasNote false when no note', () {
      final checkInNoNote = CheckInEntity(
        id: 'checkin-no-note',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: DateTime(2024, 1, 15),
        note: null,
      );
      final entry = ActivityFeedEntry(
        checkIn: checkInNoNote,
        userName: 'John Doe',
        leagueName: 'Test League',
      );
      expect(entry.hasNote, false);
    });

    test('copyWith creates new instance with updated fields', () {
      final updatedEntry = testEntry.copyWith(userName: 'Jane Doe');

      expect(updatedEntry.userName, 'Jane Doe');
      expect(updatedEntry.leagueName, testEntry.leagueName);
      expect(updatedEntry.checkIn, testEntry.checkIn);
    });

    test('equality works correctly', () {
      final entry1 = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John Doe',
        userPhotoURL: 'https://example.com/avatar.jpg',
        leagueName: 'Burger Lovers League',
      );
      final entry2 = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'John Doe',
        userPhotoURL: 'https://example.com/avatar.jpg',
        leagueName: 'Burger Lovers League',
      );

      expect(entry1, equals(entry2));
      expect(entry1.hashCode, equals(entry2.hashCode));
    });

    test('toString returns correct representation', () {
      final str = testEntry.toString();
      expect(str.contains('ActivityFeedEntry'), true);
      expect(str.contains('John Doe'), true);
      expect(str.contains('Burger Lovers League'), true);
    });
  });

  group('ActivityFeedPaginationState', () {
    test('initial state has correct defaults', () {
      const state = ActivityFeedPaginationState();

      expect(state.entries, isEmpty);
      expect(state.isLoading, false);
      expect(state.isLoadingMore, false);
      expect(state.hasMore, true);
      expect(state.errorMessage, isNull);
      expect(state.hasError, false);
      expect(state.isEmpty, true);
    });

    test('copyWith creates new state with updated fields', () {
      const state = ActivityFeedPaginationState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.entries, isEmpty);
      expect(state.isLoading, false); // Original unchanged
    });

    test('hasError is true when errorMessage is set', () {
      const state = ActivityFeedPaginationState(errorMessage: 'Test error');
      expect(state.hasError, true);
    });

    test('isEmpty is false when loading', () {
      const state = ActivityFeedPaginationState(isLoading: true);
      expect(state.isEmpty, false);
    });

    test('isEmpty is false when has entries', () {
      final checkIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'https://example.com/photo.jpg',
        timestamp: DateTime.now(),
      );
      final entry = ActivityFeedEntry(
        checkIn: checkIn,
        userName: 'Test User',
        leagueName: 'Test League',
      );
      final state = ActivityFeedPaginationState(entries: [entry]);
      expect(state.isEmpty, false);
    });
  });

  group('FeedItemCard Widget', () {
    late CheckInEntity testCheckIn;
    late ActivityFeedEntry testEntry;

    setUp(() {
      testCheckIn = CheckInEntity(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: DateTime.now(),
        rating: 4,
        note: 'Great burger!',
        restaurantName: 'Burger Joint',
      );

      testEntry = ActivityFeedEntry(
        checkIn: testCheckIn,
        userName: 'Test User',
        userPhotoURL: null,
        leagueName: 'Test League',
      );
    });

    testWidgets('should display user name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('should display league name in badge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      expect(find.text('Test League'), findsOneWidget);
    });

    testWidgets('should display restaurant name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      expect(find.text('Burger Joint'), findsOneWidget);
    });

    testWidgets('should display note text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      expect(find.text('Great burger!'), findsOneWidget);
    });

    testWidgets('should display user initials when no photo', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      // User initials 'TU' for 'Test User' should be visible
      expect(find.text('TU'), findsOneWidget);
    });

    testWidgets('should display star icons for rating', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      // Should have star icons (filled and outline)
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('should display restaurant icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });

    testWidgets('should display emoji events icon for league badge', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('should be tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: FeedItemCard(entry: testEntry)),
          ),
        ),
      );

      // Find and tap the InkWell
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
