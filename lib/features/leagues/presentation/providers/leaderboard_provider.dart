import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/repositories/league_repository.dart';

/// Provider for the LeagueRepository instance from GetIt
final leaderboardLeagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return getIt<LeagueRepository>();
});

/// State class for leaderboard data
class LeaderboardState {
  final LeaderboardStatus status;
  final LeagueEntity? league;
  final List<LeaderboardEntry> entries;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.league,
    this.entries = const [],
    this.errorMessage,
    this.lastUpdated,
  });

  const LeaderboardState.initial()
      : status = LeaderboardStatus.initial,
        league = null,
        entries = const [],
        errorMessage = null,
        lastUpdated = null;

  bool get isLoading => status == LeaderboardStatus.loading;
  bool get hasError => status == LeaderboardStatus.error;
  bool get hasData => entries.isNotEmpty;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    LeagueEntity? league,
    List<LeaderboardEntry>? entries,
    String? errorMessage,
    DateTime? lastUpdated,
    bool clearError = false,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      league: league ?? this.league,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Status enum for leaderboard loading state
enum LeaderboardStatus {
  initial,
  loading,
  loaded,
  error,
}

/// Stream provider that watches a league and provides real-time leaderboard updates
///
/// This is the primary way to get leaderboard data with real-time updates.
/// When a check-in is submitted and points are updated, the leaderboard
/// will automatically refresh.
final leagueLeaderboardStreamProvider =
    StreamProvider.family<List<LeaderboardEntry>, String>((ref, leagueId) {
  final repository = ref.watch(leaderboardLeagueRepositoryProvider);

  return repository.watchLeague(leagueId).map((league) {
    if (league == null) {
      return <LeaderboardEntry>[];
    }
    return league.rankedLeaderboard;
  });
});

/// Stream provider that watches a league entity for real-time updates
final leagueStreamProvider =
    StreamProvider.family<LeagueEntity?, String>((ref, leagueId) {
  final repository = ref.watch(leaderboardLeagueRepositoryProvider);
  return repository.watchLeague(leagueId);
});

/// Provider that gets the current user's rank in a specific league
///
/// Returns null if the user is not a member or if the league doesn't exist.
final userRankInLeagueProvider =
    Provider.family<int?, ({String leagueId, String userId})>((ref, params) {
  final leaderboardAsync =
      ref.watch(leagueLeaderboardStreamProvider(params.leagueId));

  return leaderboardAsync.whenOrNull(
    data: (entries) {
      final userEntry =
          entries.where((e) => e.userId == params.userId).firstOrNull;
      return userEntry?.rank;
    },
  );
});

/// Provider that gets a specific user's leaderboard entry in a league
final userLeaderboardEntryProvider = Provider.family<LeaderboardEntry?,
    ({String leagueId, String userId})>((ref, params) {
  final leaderboardAsync =
      ref.watch(leagueLeaderboardStreamProvider(params.leagueId));

  return leaderboardAsync.whenOrNull(
    data: (entries) {
      return entries.where((e) => e.userId == params.userId).firstOrNull;
    },
  );
});

/// Provider that gets the top N entries from a league's leaderboard
final topLeaderboardEntriesProvider =
    Provider.family<List<LeaderboardEntry>, ({String leagueId, int count})>(
        (ref, params) {
  final leaderboardAsync =
      ref.watch(leagueLeaderboardStreamProvider(params.leagueId));

  return leaderboardAsync.whenOrNull(
        data: (entries) {
          if (entries.length <= params.count) {
            return entries;
          }
          return entries.take(params.count).toList();
        },
      ) ??
      [];
});

/// Provider that watches all leagues for a user and provides their rankings
final userLeagueRankingsProvider =
    StreamProvider.family<List<UserLeagueRanking>, String>((ref, userId) {
  final repository = ref.watch(leaderboardLeagueRepositoryProvider);

  return repository.watchLeaguesForUser(userId).map((leagues) {
    return leagues.map((league) {
      final entry = league.getUserLeaderboardEntry(userId);
      return UserLeagueRanking(
        league: league,
        rank: entry?.rank,
        points: entry?.points ?? 0,
        totalMembers: league.memberCount,
      );
    }).toList()
      ..sort((a, b) {
        // Sort by rank (ascending), with null ranks at the end
        if (a.rank == null && b.rank == null) return 0;
        if (a.rank == null) return 1;
        if (b.rank == null) return -1;
        return a.rank!.compareTo(b.rank!);
      });
  });
});

/// Represents a user's ranking in a specific league
class UserLeagueRanking {
  final LeagueEntity league;
  final int? rank;
  final int points;
  final int totalMembers;

  const UserLeagueRanking({
    required this.league,
    this.rank,
    required this.points,
    required this.totalMembers,
  });

  /// Formatted rank string (e.g., "1st", "2nd", "3rd")
  String get formattedRank {
    if (rank == null) return '-';
    return _formatRank(rank!);
  }

  /// Position display (e.g., "1/10")
  String get positionDisplay => '${rank ?? "-"}/$totalMembers';

  static String _formatRank(int rank) {
    if (rank >= 11 && rank <= 13) {
      return '${rank}th';
    }
    return switch (rank % 10) {
      1 => '${rank}st',
      2 => '${rank}nd',
      3 => '${rank}rd',
      _ => '${rank}th',
    };
  }
}
