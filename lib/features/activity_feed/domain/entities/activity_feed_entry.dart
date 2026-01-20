import 'package:flutter/foundation.dart';

import '../../../check_ins/domain/entities/check_in_entity.dart';

/// Represents a single entry in the activity feed
///
/// Combines check-in data with user display information for feed rendering.
@immutable
class ActivityFeedEntry {
  /// The underlying check-in entity
  final CheckInEntity checkIn;

  /// Display name of the user who made the check-in
  final String userName;

  /// URL to the user's profile photo (nullable)
  final String? userPhotoURL;

  /// Name of the league this check-in belongs to
  final String leagueName;

  const ActivityFeedEntry({
    required this.checkIn,
    required this.userName,
    this.userPhotoURL,
    required this.leagueName,
  });

  /// Unique identifier (same as check-in id)
  String get id => checkIn.id;

  /// User ID of the person who made the check-in
  String get userId => checkIn.userId;

  /// League ID this check-in belongs to
  String get leagueId => checkIn.leagueId;

  /// URL to the check-in photo
  String get photoURL => checkIn.photoURL;

  /// When the check-in was created
  DateTime get timestamp => checkIn.timestamp;

  /// Optional rating (1-5 stars)
  int? get rating => checkIn.rating;

  /// Optional note or description
  String? get note => checkIn.note;

  /// Restaurant name if available
  String? get restaurantName => checkIn.displayRestaurantName;

  /// Whether the check-in has a rating
  bool get hasRating => checkIn.hasRating;

  /// Whether the check-in has a note
  bool get hasNote => checkIn.hasNote;

  /// Whether the user has a profile photo
  bool get hasUserPhoto => userPhotoURL != null && userPhotoURL!.isNotEmpty;

  /// Gets the user's initials from their name
  String get userInitials {
    final words = userName.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      return words[0].substring(0, words[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Creates a copy with updated fields
  ActivityFeedEntry copyWith({
    CheckInEntity? checkIn,
    String? userName,
    String? userPhotoURL,
    String? leagueName,
  }) {
    return ActivityFeedEntry(
      checkIn: checkIn ?? this.checkIn,
      userName: userName ?? this.userName,
      userPhotoURL: userPhotoURL ?? this.userPhotoURL,
      leagueName: leagueName ?? this.leagueName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityFeedEntry &&
        other.checkIn == checkIn &&
        other.userName == userName &&
        other.userPhotoURL == userPhotoURL &&
        other.leagueName == leagueName;
  }

  @override
  int get hashCode => Object.hash(checkIn, userName, userPhotoURL, leagueName);

  @override
  String toString() {
    return 'ActivityFeedEntry(checkIn: $checkIn, userName: $userName, '
        'userPhotoURL: $userPhotoURL, leagueName: $leagueName)';
  }
}
