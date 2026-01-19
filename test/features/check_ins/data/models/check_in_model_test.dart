import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/features/check_ins/data/models/check_in_model.dart';
import 'package:burgerrats/features/check_ins/domain/entities/check_in_entity.dart';

void main() {
  group('LocationDataModel', () {
    test('should create from JSON', () {
      final json = {
        'latitude': 37.7749,
        'longitude': -122.4194,
        'address': '123 Main St, San Francisco, CA',
        'placeName': 'Best Burger Joint',
      };

      final location = LocationDataModel.fromJson(json);

      expect(location.latitude, 37.7749);
      expect(location.longitude, -122.4194);
      expect(location.address, '123 Main St, San Francisco, CA');
      expect(location.placeName, 'Best Burger Joint');
    });

    test('should handle missing optional fields', () {
      final json = {
        'latitude': 37.7749,
        'longitude': -122.4194,
      };

      final location = LocationDataModel.fromJson(json);

      expect(location.latitude, 37.7749);
      expect(location.longitude, -122.4194);
      expect(location.address, null);
      expect(location.placeName, null);
    });

    test('should handle integer coordinates', () {
      final json = {
        'latitude': 37,
        'longitude': -122,
      };

      final location = LocationDataModel.fromJson(json);

      expect(location.latitude, 37.0);
      expect(location.longitude, -122.0);
    });

    test('should convert to JSON', () {
      const location = LocationDataModel(
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Main St',
        placeName: 'Test Place',
      );

      final json = location.toJson();

      expect(json['latitude'], 37.7749);
      expect(json['longitude'], -122.4194);
      expect(json['address'], '123 Main St');
      expect(json['placeName'], 'Test Place');
    });

    test('should create from entity', () {
      const entity = LocationData(
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'Test Address',
      );

      final model = LocationDataModel.fromEntity(entity);

      expect(model.latitude, 37.7749);
      expect(model.longitude, -122.4194);
      expect(model.address, 'Test Address');
    });

    test('should convert to entity', () {
      const model = LocationDataModel(
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'Test Address',
      );

      final entity = model.toEntity();

      expect(entity.latitude, 37.7749);
      expect(entity.longitude, -122.4194);
      expect(entity.address, 'Test Address');
      expect(entity, isA<LocationData>());
    });

    test('should roundtrip through JSON', () {
      const original = LocationDataModel(
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Main St',
        placeName: 'Best Burger',
      );

      final json = original.toJson();
      final restored = LocationDataModel.fromJson(json);

      expect(restored.latitude, original.latitude);
      expect(restored.longitude, original.longitude);
      expect(restored.address, original.address);
      expect(restored.placeName, original.placeName);
    });
  });

  group('CheckInModel', () {
    final timestamp = DateTime(2024, 6, 15, 12, 30, 0);
    final firestoreTimestamp = Timestamp.fromDate(timestamp);

    test('should create from JSON with Timestamp', () {
      final json = {
        'id': 'checkin-123',
        'userId': 'user-456',
        'leagueId': 'league-789',
        'photoURL': 'https://example.com/burger.jpg',
        'timestamp': firestoreTimestamp,
        'location': {
          'latitude': 37.7749,
          'longitude': -122.4194,
          'address': '123 Main St',
          'placeName': 'Burger Palace',
        },
        'note': 'Amazing burger!',
        'rating': 5,
        'restaurantName': 'Burger Palace',
      };

      final checkIn = CheckInModel.fromJson(json);

      expect(checkIn.id, 'checkin-123');
      expect(checkIn.userId, 'user-456');
      expect(checkIn.leagueId, 'league-789');
      expect(checkIn.photoURL, 'https://example.com/burger.jpg');
      expect(checkIn.timestamp, timestamp);
      expect(checkIn.location, isNotNull);
      expect(checkIn.location!.latitude, 37.7749);
      expect(checkIn.location!.placeName, 'Burger Palace');
      expect(checkIn.note, 'Amazing burger!');
      expect(checkIn.rating, 5);
      expect(checkIn.restaurantName, 'Burger Palace');
    });

    test('should create from JSON with id parameter', () {
      final json = {
        'userId': 'user-456',
        'leagueId': 'league-789',
        'photoURL': 'https://example.com/burger.jpg',
        'timestamp': firestoreTimestamp,
      };

      final checkIn = CheckInModel.fromJson(json, 'provided-id');

      expect(checkIn.id, 'provided-id');
      expect(checkIn.userId, 'user-456');
    });

    test('should create from JSON with ISO string date', () {
      final json = {
        'id': 'checkin-123',
        'userId': 'user-456',
        'leagueId': 'league-789',
        'photoURL': 'https://example.com/burger.jpg',
        'timestamp': '2024-06-15T12:30:00.000',
      };

      final checkIn = CheckInModel.fromJson(json);

      expect(checkIn.timestamp.year, 2024);
      expect(checkIn.timestamp.month, 6);
      expect(checkIn.timestamp.day, 15);
      expect(checkIn.timestamp.hour, 12);
      expect(checkIn.timestamp.minute, 30);
    });

    test('should create from JSON with milliseconds timestamp', () {
      final millis = timestamp.millisecondsSinceEpoch;
      final json = {
        'id': 'checkin-123',
        'userId': 'user-456',
        'leagueId': 'league-789',
        'photoURL': 'https://example.com/burger.jpg',
        'timestamp': millis,
      };

      final checkIn = CheckInModel.fromJson(json);

      expect(checkIn.timestamp, timestamp);
    });

    test('should handle missing optional fields', () {
      final json = {
        'id': 'checkin-123',
        'userId': 'user-456',
        'leagueId': 'league-789',
        'photoURL': 'https://example.com/burger.jpg',
        'timestamp': firestoreTimestamp,
      };

      final checkIn = CheckInModel.fromJson(json);

      expect(checkIn.location, null);
      expect(checkIn.note, null);
      expect(checkIn.rating, null);
      expect(checkIn.restaurantName, null);
    });

    test('should convert to JSON', () {
      final checkIn = CheckInModel(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
        location: const LocationData(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Main St',
        ),
        note: 'Great burger!',
        rating: 4,
        restaurantName: 'Burger Joint',
      );

      final json = checkIn.toJson();

      expect(json['id'], 'checkin-123');
      expect(json['userId'], 'user-456');
      expect(json['leagueId'], 'league-789');
      expect(json['photoURL'], 'https://example.com/burger.jpg');
      expect(json['timestamp'], isA<Timestamp>());
      expect((json['timestamp'] as Timestamp).toDate(), timestamp);
      expect(json['location'], isA<Map>());
      expect(json['location']['latitude'], 37.7749);
      expect(json['note'], 'Great burger!');
      expect(json['rating'], 4);
      expect(json['restaurantName'], 'Burger Joint');
    });

    test('should convert to JSON with null location', () {
      final checkIn = CheckInModel(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
      );

      final json = checkIn.toJson();

      expect(json['location'], null);
    });

    test('should convert to JSON for update (excludes id, userId, leagueId, timestamp)', () {
      final checkIn = CheckInModel(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
        note: 'Updated note',
        rating: 3,
      );

      final json = checkIn.toJsonForUpdate();

      expect(json.containsKey('id'), false);
      expect(json.containsKey('userId'), false);
      expect(json.containsKey('leagueId'), false);
      expect(json.containsKey('timestamp'), false);
      expect(json['photoURL'], 'https://example.com/burger.jpg');
      expect(json['note'], 'Updated note');
      expect(json['rating'], 3);
    });

    test('should create new check-in', () {
      final checkIn = CheckInModel.newCheckIn(
        id: 'new-checkin',
        userId: 'user-123',
        leagueId: 'league-456',
        photoURL: 'https://example.com/new-burger.jpg',
        note: 'First burger!',
        rating: 5,
      );

      expect(checkIn.id, 'new-checkin');
      expect(checkIn.userId, 'user-123');
      expect(checkIn.leagueId, 'league-456');
      expect(checkIn.photoURL, 'https://example.com/new-burger.jpg');
      expect(checkIn.timestamp, isA<DateTime>());
      expect(checkIn.note, 'First burger!');
      expect(checkIn.rating, 5);
    });

    test('should create new check-in with location', () {
      const location = LocationData(
        latitude: 40.7128,
        longitude: -74.0060,
        placeName: 'NYC Burger',
      );

      final checkIn = CheckInModel.newCheckIn(
        id: 'new-checkin',
        userId: 'user-123',
        leagueId: 'league-456',
        photoURL: 'https://example.com/burger.jpg',
        location: location,
      );

      expect(checkIn.location, isNotNull);
      expect(checkIn.location!.latitude, 40.7128);
      expect(checkIn.location!.placeName, 'NYC Burger');
    });

    test('should create from entity', () {
      final entity = CheckInEntity(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
        note: 'Tasty!',
        rating: 4,
      );

      final model = CheckInModel.fromEntity(entity);

      expect(model.id, 'checkin-123');
      expect(model.userId, 'user-456');
      expect(model.leagueId, 'league-789');
      expect(model.note, 'Tasty!');
      expect(model.rating, 4);
    });

    test('should convert to entity', () {
      final model = CheckInModel(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
        note: 'Delicious!',
      );

      final entity = model.toEntity();

      expect(entity.id, 'checkin-123');
      expect(entity.userId, 'user-456');
      expect(entity.note, 'Delicious!');
      expect(entity, isA<CheckInEntity>());
    });

    test('copyWith should create a copy with updated fields', () {
      final checkIn = CheckInModel(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
      );

      final updated = checkIn.copyWith(
        note: 'Added note',
        rating: 5,
      );

      expect(updated.id, 'checkin-123');
      expect(updated.userId, 'user-456');
      expect(updated.note, 'Added note');
      expect(updated.rating, 5);
      expect(updated, isA<CheckInModel>());
    });

    test('should roundtrip through JSON', () {
      final original = CheckInModel(
        id: 'checkin-123',
        userId: 'user-456',
        leagueId: 'league-789',
        photoURL: 'https://example.com/burger.jpg',
        timestamp: timestamp,
        location: const LocationData(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Main St',
          placeName: 'Best Burger',
        ),
        note: 'Amazing burger with all the toppings!',
        rating: 5,
        restaurantName: 'Best Burger Restaurant',
      );

      final json = original.toJson();
      final restored = CheckInModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.userId, original.userId);
      expect(restored.leagueId, original.leagueId);
      expect(restored.photoURL, original.photoURL);
      expect(restored.timestamp, original.timestamp);
      expect(restored.location!.latitude, original.location!.latitude);
      expect(restored.location!.longitude, original.location!.longitude);
      expect(restored.location!.address, original.location!.address);
      expect(restored.location!.placeName, original.location!.placeName);
      expect(restored.note, original.note);
      expect(restored.rating, original.rating);
      expect(restored.restaurantName, original.restaurantName);
    });

    test('should roundtrip through JSON without optional fields', () {
      final original = CheckInModel(
        id: 'checkin-minimal',
        userId: 'user-123',
        leagueId: 'league-456',
        photoURL: 'https://example.com/photo.jpg',
        timestamp: timestamp,
      );

      final json = original.toJson();
      final restored = CheckInModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.userId, original.userId);
      expect(restored.leagueId, original.leagueId);
      expect(restored.photoURL, original.photoURL);
      expect(restored.timestamp, original.timestamp);
      expect(restored.location, null);
      expect(restored.note, null);
      expect(restored.rating, null);
      expect(restored.restaurantName, null);
    });
  });

  group('CheckInEntity', () {
    test('hasLocation should return true when location is set', () {
      final checkIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        location: const LocationData(latitude: 0, longitude: 0),
      );

      expect(checkIn.hasLocation, true);
    });

    test('hasLocation should return false when location is null', () {
      final checkIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
      );

      expect(checkIn.hasLocation, false);
    });

    test('hasNote should return true for non-empty note', () {
      final checkIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        note: 'A note',
      );

      expect(checkIn.hasNote, true);
    });

    test('hasNote should return false for empty or null note', () {
      final checkIn1 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        note: '',
      );

      final checkIn2 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
      );

      expect(checkIn1.hasNote, false);
      expect(checkIn2.hasNote, false);
    });

    test('isValidRating should validate rating range', () {
      final validCheckIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        rating: 3,
      );

      final invalidCheckIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        rating: 6,
      );

      final noRatingCheckIn = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
      );

      expect(validCheckIn.isValidRating, true);
      expect(invalidCheckIn.isValidRating, false);
      expect(noRatingCheckIn.isValidRating, true);
    });

    test('displayRestaurantName should fall back to location placeName', () {
      final checkIn1 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        restaurantName: 'My Restaurant',
      );

      final checkIn2 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
        location: const LocationData(
          latitude: 0,
          longitude: 0,
          placeName: 'Location Place',
        ),
      );

      final checkIn3 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: DateTime.now(),
      );

      expect(checkIn1.displayRestaurantName, 'My Restaurant');
      expect(checkIn2.displayRestaurantName, 'Location Place');
      expect(checkIn3.displayRestaurantName, null);
    });

    test('equality should work correctly', () {
      final timestamp = DateTime(2024, 1, 1);
      final checkIn1 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: timestamp,
      );

      final checkIn2 = CheckInEntity(
        id: 'test',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: timestamp,
      );

      final checkIn3 = CheckInEntity(
        id: 'different',
        userId: 'user',
        leagueId: 'league',
        photoURL: 'url',
        timestamp: timestamp,
      );

      expect(checkIn1 == checkIn2, true);
      expect(checkIn1 == checkIn3, false);
    });
  });

  group('LocationData', () {
    test('hasAddress should work correctly', () {
      const loc1 = LocationData(
        latitude: 0,
        longitude: 0,
        address: 'An address',
      );

      const loc2 = LocationData(
        latitude: 0,
        longitude: 0,
        address: '',
      );

      const loc3 = LocationData(
        latitude: 0,
        longitude: 0,
      );

      expect(loc1.hasAddress, true);
      expect(loc2.hasAddress, false);
      expect(loc3.hasAddress, false);
    });

    test('hasPlaceName should work correctly', () {
      const loc1 = LocationData(
        latitude: 0,
        longitude: 0,
        placeName: 'A place',
      );

      const loc2 = LocationData(
        latitude: 0,
        longitude: 0,
        placeName: '',
      );

      const loc3 = LocationData(
        latitude: 0,
        longitude: 0,
      );

      expect(loc1.hasPlaceName, true);
      expect(loc2.hasPlaceName, false);
      expect(loc3.hasPlaceName, false);
    });

    test('copyWith should create a copy with updated fields', () {
      const original = LocationData(
        latitude: 10,
        longitude: 20,
        address: 'Original',
      );

      final updated = original.copyWith(address: 'Updated');

      expect(updated.latitude, 10);
      expect(updated.longitude, 20);
      expect(updated.address, 'Updated');
    });

    test('equality should work correctly', () {
      const loc1 = LocationData(
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'Test',
      );

      const loc2 = LocationData(
        latitude: 37.7749,
        longitude: -122.4194,
        address: 'Test',
      );

      const loc3 = LocationData(
        latitude: 40.7128,
        longitude: -74.0060,
        address: 'Different',
      );

      expect(loc1 == loc2, true);
      expect(loc1 == loc3, false);
    });
  });
}
