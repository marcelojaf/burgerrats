import 'package:flutter/foundation.dart';

/// User statistics for tracking activity and achievements
///
/// Tracks check-ins, reviews, achievements and league standings.
@immutable
class UserStatistics {
  /// Total number of burger check-ins
  final int totalCheckIns;

  /// Total number of reviews written
  final int totalReviews;

  /// Number of unique restaurants visited
  final int uniqueRestaurants;

  /// Number of badges/achievements earned
  final int badgesEarned;

  /// Current league rank (null if not in a league)
  final int? leagueRank;

  /// Points earned in current league season
  final int leaguePoints;

  const UserStatistics({
    this.totalCheckIns = 0,
    this.totalReviews = 0,
    this.uniqueRestaurants = 0,
    this.badgesEarned = 0,
    this.leagueRank,
    this.leaguePoints = 0,
  });

  /// Creates an empty statistics object for new users
  const UserStatistics.empty()
      : totalCheckIns = 0,
        totalReviews = 0,
        uniqueRestaurants = 0,
        badgesEarned = 0,
        leagueRank = null,
        leaguePoints = 0;

  /// Creates a copy with updated fields
  UserStatistics copyWith({
    int? totalCheckIns,
    int? totalReviews,
    int? uniqueRestaurants,
    int? badgesEarned,
    int? leagueRank,
    int? leaguePoints,
  }) {
    return UserStatistics(
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      totalReviews: totalReviews ?? this.totalReviews,
      uniqueRestaurants: uniqueRestaurants ?? this.uniqueRestaurants,
      badgesEarned: badgesEarned ?? this.badgesEarned,
      leagueRank: leagueRank ?? this.leagueRank,
      leaguePoints: leaguePoints ?? this.leaguePoints,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserStatistics &&
        other.totalCheckIns == totalCheckIns &&
        other.totalReviews == totalReviews &&
        other.uniqueRestaurants == uniqueRestaurants &&
        other.badgesEarned == badgesEarned &&
        other.leagueRank == leagueRank &&
        other.leaguePoints == leaguePoints;
  }

  @override
  int get hashCode => Object.hash(
        totalCheckIns,
        totalReviews,
        uniqueRestaurants,
        badgesEarned,
        leagueRank,
        leaguePoints,
      );

  @override
  String toString() {
    return 'UserStatistics(totalCheckIns: $totalCheckIns, totalReviews: $totalReviews, '
        'uniqueRestaurants: $uniqueRestaurants, badgesEarned: $badgesEarned, '
        'leagueRank: $leagueRank, leaguePoints: $leaguePoints)';
  }
}

/// Domain entity representing a user in the BurgerRats app
///
/// This is the core business entity for users, containing all user data
/// independent of any data source implementation details.
@immutable
class UserEntity {
  /// Unique identifier from Firebase Auth
  final String uid;

  /// User's email address
  final String email;

  /// User's display name (shown in app)
  final String? displayName;

  /// URL to user's profile photo
  final String? photoURL;

  /// Timestamp when the user account was created
  final DateTime createdAt;

  /// User's activity statistics
  final UserStatistics statistics;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    this.statistics = const UserStatistics.empty(),
  });

  /// Creates a copy with updated fields
  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    UserStatistics? statistics,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      statistics: statistics ?? this.statistics,
    );
  }

  /// Whether the user has a display name set
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Whether the user has a profile photo
  bool get hasProfilePhoto => photoURL != null && photoURL!.isNotEmpty;

  /// Returns the display name or email prefix as fallback
  String get displayNameOrEmail {
    if (hasDisplayName) return displayName!;
    final atIndex = email.indexOf('@');
    return atIndex > 0 ? email.substring(0, atIndex) : email;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.createdAt == createdAt &&
        other.statistics == statistics;
  }

  @override
  int get hashCode => Object.hash(
        uid,
        email,
        displayName,
        photoURL,
        createdAt,
        statistics,
      );

  @override
  String toString() {
    return 'UserEntity(uid: $uid, email: $email, displayName: $displayName, '
        'photoURL: $photoURL, createdAt: $createdAt, statistics: $statistics)';
  }
}
