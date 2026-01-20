import 'package:flutter/foundation.dart';

/// Configuration for streak grace period handling
@immutable
class StreakGracePeriod {
  /// Number of hours after midnight before the streak is considered broken
  final int gracePeriodHours;

  /// Whether the grace period is currently active (user is in grace window)
  final bool isInGracePeriod;

  /// When the grace period expires (if currently in grace period)
  final DateTime? gracePeriodExpiresAt;

  const StreakGracePeriod({
    this.gracePeriodHours = 4,
    this.isInGracePeriod = false,
    this.gracePeriodExpiresAt,
  });

  StreakGracePeriod copyWith({
    int? gracePeriodHours,
    bool? isInGracePeriod,
    DateTime? gracePeriodExpiresAt,
  }) {
    return StreakGracePeriod(
      gracePeriodHours: gracePeriodHours ?? this.gracePeriodHours,
      isInGracePeriod: isInGracePeriod ?? this.isInGracePeriod,
      gracePeriodExpiresAt: gracePeriodExpiresAt ?? this.gracePeriodExpiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreakGracePeriod &&
        other.gracePeriodHours == gracePeriodHours &&
        other.isInGracePeriod == isInGracePeriod &&
        other.gracePeriodExpiresAt == gracePeriodExpiresAt;
  }

  @override
  int get hashCode =>
      Object.hash(gracePeriodHours, isInGracePeriod, gracePeriodExpiresAt);

  @override
  String toString() {
    return 'StreakGracePeriod(gracePeriodHours: $gracePeriodHours, '
        'isInGracePeriod: $isInGracePeriod, gracePeriodExpiresAt: $gracePeriodExpiresAt)';
  }
}

/// Domain entity representing a user's check-in streak
///
/// Tracks consecutive daily check-ins including current streak,
/// longest streak ever achieved, and grace period status.
@immutable
class StreakEntity {
  /// Unique identifier for the streak record
  final String id;

  /// User ID this streak belongs to
  final String userId;

  /// Current consecutive check-in streak (days)
  final int currentStreak;

  /// Longest streak ever achieved (days)
  final int longestStreak;

  /// Date of the last check-in (used for streak calculation)
  final DateTime? lastCheckInDate;

  /// When the current streak started
  final DateTime? streakStartDate;

  /// When the longest streak was achieved
  final DateTime? longestStreakDate;

  /// Grace period configuration and status
  final StreakGracePeriod gracePeriod;

  /// Total number of check-ins ever made
  final int totalCheckIns;

  /// When the streak record was last updated
  final DateTime updatedAt;

  const StreakEntity({
    required this.id,
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCheckInDate,
    this.streakStartDate,
    this.longestStreakDate,
    this.gracePeriod = const StreakGracePeriod(),
    this.totalCheckIns = 0,
    required this.updatedAt,
  });

  /// Creates a new streak entity for a user with initial values
  factory StreakEntity.initial({
    required String id,
    required String userId,
  }) {
    return StreakEntity(
      id: id,
      userId: userId,
      currentStreak: 0,
      longestStreak: 0,
      lastCheckInDate: null,
      streakStartDate: null,
      longestStreakDate: null,
      gracePeriod: const StreakGracePeriod(),
      totalCheckIns: 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Whether the user has an active streak
  bool get hasActiveStreak => currentStreak > 0;

  /// Whether this is a new record (current equals longest)
  bool get isPersonalBest => currentStreak > 0 && currentStreak >= longestStreak;

  /// Whether the user has ever completed a streak
  bool get hasStreakHistory => longestStreak > 0;

  /// Whether the user needs to check in today to maintain streak
  bool get needsCheckInToday {
    if (lastCheckInDate == null) return true;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCheckIn = DateTime(
      lastCheckInDate!.year,
      lastCheckInDate!.month,
      lastCheckInDate!.day,
    );
    return !lastCheckIn.isAtSameMomentAs(today);
  }

  /// Creates a copy with updated fields
  StreakEntity copyWith({
    String? id,
    String? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCheckInDate,
    DateTime? streakStartDate,
    DateTime? longestStreakDate,
    StreakGracePeriod? gracePeriod,
    int? totalCheckIns,
    DateTime? updatedAt,
  }) {
    return StreakEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
      streakStartDate: streakStartDate ?? this.streakStartDate,
      longestStreakDate: longestStreakDate ?? this.longestStreakDate,
      gracePeriod: gracePeriod ?? this.gracePeriod,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreakEntity &&
        other.id == id &&
        other.userId == userId &&
        other.currentStreak == currentStreak &&
        other.longestStreak == longestStreak &&
        other.lastCheckInDate == lastCheckInDate &&
        other.streakStartDate == streakStartDate &&
        other.longestStreakDate == longestStreakDate &&
        other.gracePeriod == gracePeriod &&
        other.totalCheckIns == totalCheckIns &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        userId,
        currentStreak,
        longestStreak,
        lastCheckInDate,
        streakStartDate,
        longestStreakDate,
        gracePeriod,
        totalCheckIns,
        updatedAt,
      );

  @override
  String toString() {
    return 'StreakEntity(id: $id, userId: $userId, currentStreak: $currentStreak, '
        'longestStreak: $longestStreak, lastCheckInDate: $lastCheckInDate, '
        'streakStartDate: $streakStartDate, longestStreakDate: $longestStreakDate, '
        'gracePeriod: $gracePeriod, totalCheckIns: $totalCheckIns, updatedAt: $updatedAt)';
  }
}
