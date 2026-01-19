import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/check_in_entity.dart';

/// Data model for LocationData with Firestore serialization
///
/// Extends the domain entity with JSON/Firestore conversion capabilities.
class LocationDataModel extends LocationData {
  const LocationDataModel({
    required super.latitude,
    required super.longitude,
    super.address,
    super.placeName,
  });

  /// Creates a model from a domain entity
  factory LocationDataModel.fromEntity(LocationData entity) {
    return LocationDataModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      placeName: entity.placeName,
    );
  }

  /// Creates a model from JSON/Firestore data
  factory LocationDataModel.fromJson(Json json) {
    return LocationDataModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      placeName: json['placeName'] as String?,
    );
  }

  /// Converts to JSON for Firestore storage
  Json toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'placeName': placeName,
    };
  }

  /// Converts to domain entity
  LocationData toEntity() {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      address: address,
      placeName: placeName,
    );
  }
}

/// Data model for CheckIn with Firestore serialization
///
/// Handles conversion between:
/// - Firestore documents
/// - Domain CheckInEntity
class CheckInModel extends CheckInEntity {
  const CheckInModel({
    required super.id,
    required super.userId,
    required super.leagueId,
    required super.photoURL,
    required super.timestamp,
    super.location,
    super.note,
    super.rating,
    super.restaurantName,
  });

  /// Creates a model from a domain entity
  factory CheckInModel.fromEntity(CheckInEntity entity) {
    return CheckInModel(
      id: entity.id,
      userId: entity.userId,
      leagueId: entity.leagueId,
      photoURL: entity.photoURL,
      timestamp: entity.timestamp,
      location: entity.location,
      note: entity.note,
      rating: entity.rating,
      restaurantName: entity.restaurantName,
    );
  }

  /// Creates a model from Firestore document data
  factory CheckInModel.fromFirestore(DocumentSnapshot<Json> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Document data is null for check-in ${doc.id}');
    }
    return CheckInModel.fromJson(data, doc.id);
  }

  /// Creates a model from JSON/Firestore data
  factory CheckInModel.fromJson(Json json, [String? id]) {
    // Handle Firestore Timestamp conversion
    DateTime timestamp;
    final timestampValue = json['timestamp'];
    if (timestampValue is Timestamp) {
      timestamp = timestampValue.toDate();
    } else if (timestampValue is String) {
      timestamp = DateTime.parse(timestampValue);
    } else if (timestampValue is int) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(timestampValue);
    } else {
      timestamp = DateTime.now();
    }

    // Parse location if present
    LocationData? location;
    final locationJson = json['location'] as Json?;
    if (locationJson != null) {
      location = LocationDataModel.fromJson(locationJson);
    }

    return CheckInModel(
      id: id ?? json['id'] as String,
      userId: json['userId'] as String,
      leagueId: json['leagueId'] as String,
      photoURL: json['photoURL'] as String,
      timestamp: timestamp,
      location: location,
      note: json['note'] as String?,
      rating: json['rating'] as int?,
      restaurantName: json['restaurantName'] as String?,
    );
  }

  /// Creates a new check-in model for initial Firestore storage
  ///
  /// Used when creating a new check-in to initialize its document.
  factory CheckInModel.newCheckIn({
    required String id,
    required String userId,
    required String leagueId,
    required String photoURL,
    LocationData? location,
    String? note,
    int? rating,
    String? restaurantName,
  }) {
    return CheckInModel(
      id: id,
      userId: userId,
      leagueId: leagueId,
      photoURL: photoURL,
      timestamp: DateTime.now(),
      location: location,
      note: note,
      rating: rating,
      restaurantName: restaurantName,
    );
  }

  /// Converts to JSON for Firestore storage
  ///
  /// Stores timestamp as Firestore Timestamp for proper date handling.
  Json toJson() {
    return {
      'id': id,
      'userId': userId,
      'leagueId': leagueId,
      'photoURL': photoURL,
      'timestamp': Timestamp.fromDate(timestamp),
      'location': location != null
          ? LocationDataModel.fromEntity(location!).toJson()
          : null,
      'note': note,
      'rating': rating,
      'restaurantName': restaurantName,
    };
  }

  /// Converts to JSON for Firestore update (excludes id and timestamp)
  ///
  /// Used when updating check-in data without overwriting immutable fields.
  Json toJsonForUpdate() {
    return {
      'photoURL': photoURL,
      'location': location != null
          ? LocationDataModel.fromEntity(location!).toJson()
          : null,
      'note': note,
      'rating': rating,
      'restaurantName': restaurantName,
    };
  }

  /// Converts to domain entity
  CheckInEntity toEntity() {
    return CheckInEntity(
      id: id,
      userId: userId,
      leagueId: leagueId,
      photoURL: photoURL,
      timestamp: timestamp,
      location: location is LocationDataModel
          ? (location as LocationDataModel).toEntity()
          : location,
      note: note,
      rating: rating,
      restaurantName: restaurantName,
    );
  }

  @override
  CheckInModel copyWith({
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
    return CheckInModel(
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
}
