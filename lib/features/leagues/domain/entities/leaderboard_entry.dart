import 'package:flutter/foundation.dart';

import 'league_entity.dart';

/// Represents a leaderboard entry with ranking information
///
/// This entity wraps a [LeagueMember] with additional ranking metadata,
/// including proper tie handling where members with equal points share the same rank.
@immutable
class LeaderboardEntry {
  /// The rank position (1-based, with ties sharing the same rank)
  final int rank;

  /// The underlying league member data
  final LeagueMember member;

  /// Whether this entry is tied with the previous entry
  final bool isTied;

  /// The number of check-ins (for secondary information display)
  final int checkInCount;

  const LeaderboardEntry({
    required this.rank,
    required this.member,
    this.isTied = false,
    this.checkInCount = 0,
  });

  /// User ID of the member
  String get userId => member.userId;

  /// Points of the member
  int get points => member.points;

  /// Role of the member in the league
  LeagueMemberRole get role => member.role;

  /// When the user joined the league
  DateTime get joinedAt => member.joinedAt;

  /// Creates a copy with updated fields
  LeaderboardEntry copyWith({
    int? rank,
    LeagueMember? member,
    bool? isTied,
    int? checkInCount,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      member: member ?? this.member,
      isTied: isTied ?? this.isTied,
      checkInCount: checkInCount ?? this.checkInCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardEntry &&
        other.rank == rank &&
        other.member == member &&
        other.isTied == isTied &&
        other.checkInCount == checkInCount;
  }

  @override
  int get hashCode => Object.hash(rank, member, isTied, checkInCount);

  @override
  String toString() {
    return 'LeaderboardEntry(rank: $rank, userId: $userId, points: $points, '
        'isTied: $isTied, checkInCount: $checkInCount)';
  }
}

/// Extension on LeagueEntity to provide leaderboard calculation with tie handling
extension LeagueLeaderboardExtension on LeagueEntity {
  /// Gets the leaderboard with proper ranking that handles ties
  ///
  /// Members with the same points share the same rank.
  /// For example: 1st (100pts), 2nd (80pts), 2nd (80pts), 4th (60pts)
  List<LeaderboardEntry> get rankedLeaderboard {
    if (members.isEmpty) {
      return [];
    }

    // Sort members by points (descending), then by join date (earlier first for tie-breaker display)
    final sorted = List<LeagueMember>.from(members);
    sorted.sort((a, b) {
      final pointsComparison = b.points.compareTo(a.points);
      if (pointsComparison != 0) return pointsComparison;
      // Secondary sort by join date (earlier joiners first)
      return a.joinedAt.compareTo(b.joinedAt);
    });

    final List<LeaderboardEntry> entries = [];
    int currentRank = 1;

    for (int i = 0; i < sorted.length; i++) {
      final member = sorted[i];
      final bool isTied = i > 0 && sorted[i - 1].points == member.points;

      // If tied with previous, use same rank; otherwise use current position
      if (!isTied && i > 0) {
        currentRank = i + 1;
      }

      entries.add(LeaderboardEntry(
        rank: currentRank,
        member: member,
        isTied: isTied,
      ));
    }

    return entries;
  }

  /// Gets the rank of a specific user in the league
  ///
  /// Returns null if the user is not a member.
  int? getUserRank(String userId) {
    final entry = rankedLeaderboard.where((e) => e.userId == userId).firstOrNull;
    return entry?.rank;
  }

  /// Gets the leaderboard entry for a specific user
  ///
  /// Returns null if the user is not a member.
  LeaderboardEntry? getUserLeaderboardEntry(String userId) {
    return rankedLeaderboard.where((e) => e.userId == userId).firstOrNull;
  }

  /// Gets the top N entries from the leaderboard
  List<LeaderboardEntry> getTopEntries(int count) {
    final ranked = rankedLeaderboard;
    if (ranked.length <= count) {
      return ranked;
    }
    return ranked.take(count).toList();
  }
}
