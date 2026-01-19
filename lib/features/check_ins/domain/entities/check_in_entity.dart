import 'package:flutter/foundation.dart';

/// Represents optional location data for a check-in
///
/// Contains latitude, longitude, and optional address information.
@immutable
class LocationData {
  /// Latitude coordinate
  final double latitude;

  /// Longitude coordinate
  final double longitude;

  /// Optional human-readable address
  final String? address;

  /// Optional name of the place (e.g., restaurant name)
  final String? placeName;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
  });

  /// Whether the location has address information
  bool get hasAddress => address != null && address!.isNotEmpty;

  /// Whether the location has a place name
  bool get hasPlaceName => placeName != null && placeName!.isNotEmpty;

  /// Creates a copy with updated fields
  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? placeName,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeName: placeName ?? this.placeName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.placeName == placeName;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude, address, placeName);

  @override
  String toString() {
    return 'LocationData(latitude: $latitude, longitude: $longitude, '
        'address: $address, placeName: $placeName)';
  }
}

/// Domain entity representing a burger check-in in the BurgerRats app
///
/// A check-in records when a user visits a burger restaurant,
/// optionally including a photo and location data.
@immutable
class CheckInEntity {
  /// Unique identifier for the check-in
  final String id;

  /// User ID of the person who made the check-in
  final String userId;

  /// League ID this check-in belongs to
  final String leagueId;

  /// URL to the uploaded photo of the burger
  final String photoURL;

  /// When the check-in was created
  final DateTime timestamp;

  /// Optional location data for the check-in
  final LocationData? location;

  /// Optional note or description from the user
  final String? note;

  /// Optional rating (1-5 stars)
  final int? rating;

  /// Restaurant name (if provided separately from location)
  final String? restaurantName;

  const CheckInEntity({
    required this.id,
    required this.userId,
    required this.leagueId,
    required this.photoURL,
    required this.timestamp,
    this.location,
    this.note,
    this.rating,
    this.restaurantName,
  });

  /// Whether the check-in has location data
  bool get hasLocation => location != null;

  /// Whether the check-in has a note
  bool get hasNote => note != null && note!.isNotEmpty;

  /// Whether the check-in has a rating
  bool get hasRating => rating != null;

  /// Whether the check-in has a restaurant name
  bool get hasRestaurantName =>
      restaurantName != null && restaurantName!.isNotEmpty;

  /// Gets the display name for the restaurant
  /// Falls back to location place name if restaurant name is not set
  String? get displayRestaurantName {
    if (hasRestaurantName) return restaurantName;
    if (hasLocation && location!.hasPlaceName) return location!.placeName;
    return null;
  }

  /// Validates that the rating is within acceptable range
  bool get isValidRating => rating == null || (rating! >= 1 && rating! <= 5);

  /// Creates a copy with updated fields
  CheckInEntity copyWith({
    String? id,
    String? userId,
    String? leagueId,
    String? photoURL,
    DateTime? timestamp,
    LocationData? location,
    String? note,
    int? rating,
    String? restaurantName,
  }) {
    return CheckInEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      leagueId: leagueId ?? this.leagueId,
      photoURL: photoURL ?? this.photoURL,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      restaurantName: restaurantName ?? this.restaurantName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckInEntity &&
        other.id == id &&
        other.userId == userId &&
        other.leagueId == leagueId &&
        other.photoURL == photoURL &&
        other.timestamp == timestamp &&
        other.location == location &&
        other.note == note &&
        other.rating == rating &&
        other.restaurantName == restaurantName;
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        leagueId,
        photoURL,
        timestamp,
        location,
        note,
        rating,
        restaurantName,
      );

  @override
  String toString() {
    return 'CheckInEntity(id: $id, userId: $userId, leagueId: $leagueId, '
        'photoURL: $photoURL, timestamp: $timestamp, location: $location, '
        'note: $note, rating: $rating, restaurantName: $restaurantName)';
  }
}
