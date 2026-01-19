import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserStatistics', () {
    test('should create with default values', () {
      const stats = UserStatistics();

      expect(stats.totalCheckIns, 0);
      expect(stats.totalReviews, 0);
      expect(stats.uniqueRestaurants, 0);
      expect(stats.badgesEarned, 0);
      expect(stats.leagueRank, null);
      expect(stats.leaguePoints, 0);
    });

    test('should create empty statistics', () {
      const stats = UserStatistics.empty();

      expect(stats.totalCheckIns, 0);
      expect(stats.totalReviews, 0);
      expect(stats.uniqueRestaurants, 0);
      expect(stats.badgesEarned, 0);
      expect(stats.leagueRank, null);
      expect(stats.leaguePoints, 0);
    });

    test('should create with custom values', () {
      const stats = UserStatistics(
        totalCheckIns: 10,
        totalReviews: 5,
        uniqueRestaurants: 8,
        badgesEarned: 3,
        leagueRank: 1,
        leaguePoints: 100,
      );

      expect(stats.totalCheckIns, 10);
      expect(stats.totalReviews, 5);
      expect(stats.uniqueRestaurants, 8);
      expect(stats.badgesEarned, 3);
      expect(stats.leagueRank, 1);
      expect(stats.leaguePoints, 100);
    });

    test('copyWith should create a copy with updated fields', () {
      const stats = UserStatistics(
        totalCheckIns: 10,
        totalReviews: 5,
      );

      final updatedStats = stats.copyWith(
        totalCheckIns: 15,
        leagueRank: 2,
      );

      expect(updatedStats.totalCheckIns, 15);
      expect(updatedStats.totalReviews, 5); // unchanged
      expect(updatedStats.leagueRank, 2);
    });

    test('should have value equality', () {
      const stats1 = UserStatistics(totalCheckIns: 10);
      const stats2 = UserStatistics(totalCheckIns: 10);
      const stats3 = UserStatistics(totalCheckIns: 20);

      expect(stats1, equals(stats2));
      expect(stats1, isNot(equals(stats3)));
    });
  });

  group('UserEntity', () {
    final createdAt = DateTime(2024, 1, 15);

    test('should create with required fields', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      expect(user.uid, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.displayName, null);
      expect(user.photoURL, null);
      expect(user.createdAt, createdAt);
      expect(user.statistics, const UserStatistics.empty());
    });

    test('should create with all fields', () {
      const stats = UserStatistics(totalCheckIns: 5);
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        createdAt: createdAt,
        statistics: stats,
      );

      expect(user.uid, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoURL, 'https://example.com/photo.jpg');
      expect(user.createdAt, createdAt);
      expect(user.statistics, stats);
    });

    test('hasDisplayName should return true when display name is set', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: createdAt,
      );

      expect(user.hasDisplayName, true);
    });

    test('hasDisplayName should return false when display name is null', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      expect(user.hasDisplayName, false);
    });

    test('hasDisplayName should return false when display name is empty', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: '',
        createdAt: createdAt,
      );

      expect(user.hasDisplayName, false);
    });

    test('hasProfilePhoto should return true when photo URL is set', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        photoURL: 'https://example.com/photo.jpg',
        createdAt: createdAt,
      );

      expect(user.hasProfilePhoto, true);
    });

    test('hasProfilePhoto should return false when photo URL is null', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      expect(user.hasProfilePhoto, false);
    });

    test('displayNameOrEmail should return display name when available', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: createdAt,
      );

      expect(user.displayNameOrEmail, 'Test User');
    });

    test('displayNameOrEmail should return email prefix when no display name',
        () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      expect(user.displayNameOrEmail, 'test');
    });

    test('copyWith should create a copy with updated fields', () {
      final user = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      final updatedUser = user.copyWith(
        displayName: 'New Name',
        photoURL: 'https://example.com/new-photo.jpg',
      );

      expect(updatedUser.uid, 'test-uid'); // unchanged
      expect(updatedUser.email, 'test@example.com'); // unchanged
      expect(updatedUser.displayName, 'New Name');
      expect(updatedUser.photoURL, 'https://example.com/new-photo.jpg');
      expect(updatedUser.createdAt, createdAt); // unchanged
    });

    test('should have value equality', () {
      final user1 = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      final user2 = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      final user3 = UserEntity(
        uid: 'different-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });
}
