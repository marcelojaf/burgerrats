import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/auth/data/models/user_model.dart';
import 'package:burgerrats/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserStatisticsModel', () {
    test('should create from JSON', () {
      final json = {
        'totalCheckIns': 10,
        'totalReviews': 5,
        'uniqueRestaurants': 8,
        'badgesEarned': 3,
        'leagueRank': 1,
        'leaguePoints': 100,
      };

      final stats = UserStatisticsModel.fromJson(json);

      expect(stats.totalCheckIns, 10);
      expect(stats.totalReviews, 5);
      expect(stats.uniqueRestaurants, 8);
      expect(stats.badgesEarned, 3);
      expect(stats.leagueRank, 1);
      expect(stats.leaguePoints, 100);
    });

    test('should handle missing JSON fields with defaults', () {
      final json = <String, dynamic>{};

      final stats = UserStatisticsModel.fromJson(json);

      expect(stats.totalCheckIns, 0);
      expect(stats.totalReviews, 0);
      expect(stats.uniqueRestaurants, 0);
      expect(stats.badgesEarned, 0);
      expect(stats.leagueRank, null);
      expect(stats.leaguePoints, 0);
    });

    test('should convert to JSON', () {
      const stats = UserStatisticsModel(
        totalCheckIns: 10,
        totalReviews: 5,
        uniqueRestaurants: 8,
        badgesEarned: 3,
        leagueRank: 1,
        leaguePoints: 100,
      );

      final json = stats.toJson();

      expect(json['totalCheckIns'], 10);
      expect(json['totalReviews'], 5);
      expect(json['uniqueRestaurants'], 8);
      expect(json['badgesEarned'], 3);
      expect(json['leagueRank'], 1);
      expect(json['leaguePoints'], 100);
    });

    test('should create from entity', () {
      const entity = UserStatistics(
        totalCheckIns: 10,
        totalReviews: 5,
      );

      final model = UserStatisticsModel.fromEntity(entity);

      expect(model.totalCheckIns, 10);
      expect(model.totalReviews, 5);
    });

    test('should convert to entity', () {
      const model = UserStatisticsModel(
        totalCheckIns: 10,
        totalReviews: 5,
      );

      final entity = model.toEntity();

      expect(entity.totalCheckIns, 10);
      expect(entity.totalReviews, 5);
      expect(entity, isA<UserStatistics>());
    });

    test('should create empty statistics', () {
      final stats = UserStatisticsModel.empty();

      expect(stats.totalCheckIns, 0);
      expect(stats.totalReviews, 0);
    });
  });

  group('UserModel', () {
    final createdAt = DateTime(2024, 1, 15);
    final timestamp = Timestamp.fromDate(createdAt);

    test('should create from JSON with Timestamp', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'photoURL': 'https://example.com/photo.jpg',
        'createdAt': timestamp,
        'statistics': {
          'totalCheckIns': 5,
          'totalReviews': 3,
          'uniqueRestaurants': 4,
          'badgesEarned': 2,
          'leagueRank': null,
          'leaguePoints': 50,
        },
      };

      final user = UserModel.fromJson(json);

      expect(user.uid, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.photoURL, 'https://example.com/photo.jpg');
      expect(user.createdAt, createdAt);
      expect(user.statistics.totalCheckIns, 5);
    });

    test('should create from JSON with uid parameter', () {
      final json = {
        'email': 'test@example.com',
        'displayName': 'Test User',
        'createdAt': timestamp,
      };

      final user = UserModel.fromJson(json, 'provided-uid');

      expect(user.uid, 'provided-uid');
      expect(user.email, 'test@example.com');
    });

    test('should create from JSON with ISO string date', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'createdAt': '2024-01-15T00:00:00.000',
      };

      final user = UserModel.fromJson(json);

      expect(user.createdAt.year, 2024);
      expect(user.createdAt.month, 1);
      expect(user.createdAt.day, 15);
    });

    test('should create from JSON with milliseconds timestamp', () {
      final millis = createdAt.millisecondsSinceEpoch;
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'createdAt': millis,
      };

      final user = UserModel.fromJson(json);

      expect(user.createdAt, createdAt);
    });

    test('should handle missing optional fields', () {
      final json = {
        'uid': 'test-uid',
        'email': 'test@example.com',
        'createdAt': timestamp,
      };

      final user = UserModel.fromJson(json);

      expect(user.displayName, null);
      expect(user.photoURL, null);
      expect(user.statistics, isA<UserStatistics>());
    });

    test('should convert to JSON', () {
      final user = UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        createdAt: createdAt,
        statistics: const UserStatistics(totalCheckIns: 5),
      );

      final json = user.toJson();

      expect(json['uid'], 'test-uid');
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['photoURL'], 'https://example.com/photo.jpg');
      expect(json['createdAt'], isA<Timestamp>());
      expect((json['createdAt'] as Timestamp).toDate(), createdAt);
      expect(json['statistics'], isA<Map>());
      expect(json['statistics']['totalCheckIns'], 5);
    });

    test('should convert to JSON for update (excludes uid and createdAt)', () {
      final user = UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        createdAt: createdAt,
        statistics: const UserStatistics(totalCheckIns: 5),
      );

      final json = user.toJsonForUpdate();

      expect(json.containsKey('uid'), false);
      expect(json.containsKey('createdAt'), false);
      expect(json['email'], 'test@example.com');
      expect(json['displayName'], 'Test User');
      expect(json['statistics'], isA<Map>());
    });

    test('should create new user', () {
      final user = UserModel.newUser(
        uid: 'new-uid',
        email: 'new@example.com',
        displayName: 'New User',
      );

      expect(user.uid, 'new-uid');
      expect(user.email, 'new@example.com');
      expect(user.displayName, 'New User');
      expect(user.statistics, isA<UserStatistics>());
      expect(user.statistics.totalCheckIns, 0);
    });

    test('should create from entity', () {
      final entity = UserEntity(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: createdAt,
      );

      final model = UserModel.fromEntity(entity);

      expect(model.uid, 'test-uid');
      expect(model.email, 'test@example.com');
      expect(model.displayName, 'Test User');
      expect(model.createdAt, createdAt);
    });

    test('should convert to entity', () {
      final model = UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: createdAt,
      );

      final entity = model.toEntity();

      expect(entity.uid, 'test-uid');
      expect(entity.email, 'test@example.com');
      expect(entity.displayName, 'Test User');
      expect(entity.createdAt, createdAt);
      expect(entity, isA<UserEntity>());
    });

    test('copyWith should create a copy with updated fields', () {
      final user = UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        createdAt: createdAt,
      );

      final updatedUser = user.copyWith(
        displayName: 'Updated Name',
      );

      expect(updatedUser.uid, 'test-uid');
      expect(updatedUser.email, 'test@example.com');
      expect(updatedUser.displayName, 'Updated Name');
      expect(updatedUser, isA<UserModel>());
    });

    test('should roundtrip through JSON', () {
      final original = UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
        photoURL: 'https://example.com/photo.jpg',
        createdAt: createdAt,
        statistics: const UserStatistics(
          totalCheckIns: 10,
          totalReviews: 5,
          uniqueRestaurants: 8,
          badgesEarned: 3,
          leagueRank: 1,
          leaguePoints: 100,
        ),
      );

      final json = original.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.uid, original.uid);
      expect(restored.email, original.email);
      expect(restored.displayName, original.displayName);
      expect(restored.photoURL, original.photoURL);
      expect(restored.createdAt, original.createdAt);
      expect(restored.statistics.totalCheckIns, original.statistics.totalCheckIns);
      expect(restored.statistics.leagueRank, original.statistics.leagueRank);
    });
  });
}
