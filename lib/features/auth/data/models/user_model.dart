import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';

/// Data model for UserStatistics with Firestore serialization
///
/// Extends the domain entity with JSON/Firestore conversion capabilities.
class UserStatisticsModel extends UserStatistics {
  const UserStatisticsModel({
    super.totalCheckIns,
    super.totalReviews,
    super.uniqueRestaurants,
    super.badgesEarned,
    super.leagueRank,
    super.leaguePoints,
  });

  /// Creates a model from a domain entity
  factory UserStatisticsModel.fromEntity(UserStatistics entity) {
    return UserStatisticsModel(
      totalCheckIns: entity.totalCheckIns,
      totalReviews: entity.totalReviews,
      uniqueRestaurants: entity.uniqueRestaurants,
      badgesEarned: entity.badgesEarned,
      leagueRank: entity.leagueRank,
      leaguePoints: entity.leaguePoints,
    );
  }

  /// Creates a model from JSON/Firestore data
  factory UserStatisticsModel.fromJson(Json json) {
    return UserStatisticsModel(
      totalCheckIns: json['totalCheckIns'] as int? ?? 0,
      totalReviews: json['totalReviews'] as int? ?? 0,
      uniqueRestaurants: json['uniqueRestaurants'] as int? ?? 0,
      badgesEarned: json['badgesEarned'] as int? ?? 0,
      leagueRank: json['leagueRank'] as int?,
      leaguePoints: json['leaguePoints'] as int? ?? 0,
    );
  }

  /// Creates an empty statistics model
  factory UserStatisticsModel.empty() {
    return const UserStatisticsModel();
  }

  /// Converts to JSON for Firestore storage
  Json toJson() {
    return {
      'totalCheckIns': totalCheckIns,
      'totalReviews': totalReviews,
      'uniqueRestaurants': uniqueRestaurants,
      'badgesEarned': badgesEarned,
      'leagueRank': leagueRank,
      'leaguePoints': leaguePoints,
    };
  }

  /// Converts to domain entity
  UserStatistics toEntity() {
    return UserStatistics(
      totalCheckIns: totalCheckIns,
      totalReviews: totalReviews,
      uniqueRestaurants: uniqueRestaurants,
      badgesEarned: badgesEarned,
      leagueRank: leagueRank,
      leaguePoints: leaguePoints,
    );
  }
}

/// Data model for User with Firestore serialization
///
/// Handles conversion between:
/// - Firebase Auth User objects
/// - Firestore documents
/// - Domain UserEntity
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.displayName,
    super.photoURL,
    required super.createdAt,
    super.statistics = const UserStatistics.empty(),
  });

  /// Creates a model from a domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      createdAt: entity.createdAt,
      statistics: entity.statistics,
    );
  }

  /// Creates a model from Firebase Auth User
  ///
  /// Note: This creates a user with empty statistics as Firebase Auth
  /// does not store statistics. Use [fromFirestore] for complete user data.
  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      statistics: const UserStatistics.empty(),
    );
  }

  /// Creates a model from Firestore document data
  factory UserModel.fromFirestore(DocumentSnapshot<Json> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Document data is null for user ${doc.id}');
    }
    return UserModel.fromJson(data, doc.id);
  }

  /// Creates a model from JSON/Firestore data
  factory UserModel.fromJson(Json json, [String? uid]) {
    // Handle Firestore Timestamp conversion
    DateTime createdAt;
    final createdAtValue = json['createdAt'];
    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      createdAt = DateTime.parse(createdAtValue);
    } else if (createdAtValue is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
    } else {
      createdAt = DateTime.now();
    }

    // Parse statistics if present
    UserStatistics statistics;
    final statsJson = json['statistics'] as Json?;
    if (statsJson != null) {
      statistics = UserStatisticsModel.fromJson(statsJson);
    } else {
      statistics = const UserStatistics.empty();
    }

    return UserModel(
      uid: uid ?? json['uid'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      createdAt: createdAt,
      statistics: statistics,
    );
  }

  /// Creates a new user model for initial Firestore storage
  ///
  /// Used when creating a new user account to initialize their document.
  factory UserModel.newUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      createdAt: DateTime.now(),
      statistics: const UserStatistics.empty(),
    );
  }

  /// Converts to JSON for Firestore storage
  ///
  /// Stores createdAt as Firestore Timestamp for proper date handling.
  Json toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'statistics': UserStatisticsModel.fromEntity(statistics).toJson(),
    };
  }

  /// Converts to JSON for Firestore update (excludes uid and createdAt)
  ///
  /// Used when updating user profile data without overwriting immutable fields.
  Json toJsonForUpdate() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'statistics': UserStatisticsModel.fromEntity(statistics).toJson(),
    };
  }

  /// Converts to domain entity
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      createdAt: createdAt,
      statistics: statistics,
    );
  }

  @override
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    UserStatistics? statistics,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      statistics: statistics ?? this.statistics,
    );
  }
}
