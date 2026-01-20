import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/repositories/streak_repository.dart';
import '../../domain/services/streak_tracker_service.dart';

/// Provider for the StreakRepository instance from GetIt
final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return getIt<StreakRepository>();
});

/// Provider for the StreakTrackerService instance from GetIt
final streakTrackerServiceProvider = Provider<StreakTrackerService>((ref) {
  return getIt<StreakTrackerService>();
});

/// Status enum for streak loading state
enum StreakStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State class for user streak data
class StreakState {
  final StreakStatus status;
  final StreakEntity? streak;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const StreakState({
    this.status = StreakStatus.initial,
    this.streak,
    this.errorMessage,
    this.lastUpdated,
  });

  const StreakState.initial()
      : status = StreakStatus.initial,
        streak = null,
        errorMessage = null,
        lastUpdated = null;

  bool get isLoading => status == StreakStatus.loading;
  bool get hasError => status == StreakStatus.error;
  bool get hasData => streak != null;

  /// Current streak count
  int get currentStreak => streak?.currentStreak ?? 0;

  /// Longest streak ever achieved
  int get longestStreak => streak?.longestStreak ?? 0;

  /// Whether the user has an active streak
  bool get hasActiveStreak => streak?.hasActiveStreak ?? false;

  /// Whether user is in grace period
  bool get isInGracePeriod => streak?.gracePeriod.isInGracePeriod ?? false;

  /// Grace period expiration time (if in grace period)
  DateTime? get gracePeriodExpiresAt => streak?.gracePeriod.gracePeriodExpiresAt;

  /// Whether user needs to check in today to maintain streak
  bool get needsCheckInToday => streak?.needsCheckInToday ?? true;

  /// Whether current streak is a personal best
  bool get isPersonalBest => streak?.isPersonalBest ?? false;

  StreakState copyWith({
    StreakStatus? status,
    StreakEntity? streak,
    String? errorMessage,
    DateTime? lastUpdated,
    bool clearError = false,
  }) {
    return StreakState(
      status: status ?? this.status,
      streak: streak ?? this.streak,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Stream provider that watches a user's streak with real-time updates
///
/// This is the primary way to get streak data with real-time updates.
final userStreakStreamProvider =
    StreamProvider.family<StreakEntity?, String>((ref, userId) {
  final repository = ref.watch(streakRepositoryProvider);
  return repository.watchUserStreak(userId);
});

/// Provider that fetches and updates streak status for a user
///
/// This provider ensures the streak is up-to-date, checking for expired
/// grace periods and resetting streaks if necessary.
final streakStatusProvider =
    FutureProvider.family<StreakEntity, String>((ref, userId) async {
  final service = ref.watch(streakTrackerServiceProvider);
  return service.getStreakStatus(userId);
});

/// StateNotifier for managing streak state with actions
class StreakNotifier extends StateNotifier<StreakState> {
  final StreakTrackerService _streakService;
  final StreakRepository _streakRepository;

  StreakNotifier(this._streakService, this._streakRepository)
      : super(const StreakState.initial());

  /// Loads the current streak status for a user
  Future<void> loadStreak(String userId) async {
    state = state.copyWith(status: StreakStatus.loading, clearError: true);

    try {
      final streak = await _streakService.getStreakStatus(userId);
      state = state.copyWith(
        status: StreakStatus.loaded,
        streak: streak,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        status: StreakStatus.error,
        errorMessage: ErrorHandler.getUserMessage(e),
      );
    }
  }

  /// Refreshes the streak from historical check-in data
  ///
  /// Useful for data recovery or verification.
  Future<void> recalculateStreak(String userId) async {
    state = state.copyWith(status: StreakStatus.loading, clearError: true);

    try {
      final streak = await _streakService.calculateStreakFromHistory(userId);
      state = state.copyWith(
        status: StreakStatus.loaded,
        streak: streak,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        status: StreakStatus.error,
        errorMessage: ErrorHandler.getUserMessage(e),
      );
    }
  }

  /// Updates the streak state directly (for real-time updates)
  void updateStreak(StreakEntity streak) {
    state = state.copyWith(
      status: StreakStatus.loaded,
      streak: streak,
      lastUpdated: DateTime.now(),
    );
  }

  /// Clears the current error state
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for the StreakNotifier
final streakNotifierProvider =
    StateNotifierProvider.family<StreakNotifier, StreakState, String>(
        (ref, userId) {
  final service = ref.watch(streakTrackerServiceProvider);
  final repository = ref.watch(streakRepositoryProvider);

  final notifier = StreakNotifier(service, repository);

  // Auto-load streak when provider is first accessed
  notifier.loadStreak(userId);

  return notifier;
});

/// Stream provider that watches top streaks leaderboard
final topStreaksProvider =
    StreamProvider.family<List<StreakEntity>, int>((ref, limit) {
  final repository = ref.watch(streakRepositoryProvider);
  return repository.watchTopStreaks(limit: limit);
});

/// Future provider to get top all-time longest streaks
final topLongestStreaksProvider =
    FutureProvider.family<List<StreakEntity>, int>((ref, limit) async {
  final repository = ref.watch(streakRepositoryProvider);
  return repository.getTopLongestStreaks(limit: limit);
});

/// Provider that computes streak statistics for a user
final streakStatsProvider =
    Provider.family<StreakStats, String>((ref, userId) {
  final streakAsync = ref.watch(userStreakStreamProvider(userId));

  return streakAsync.when(
    data: (streak) => StreakStats.fromStreak(streak),
    loading: () => StreakStats.empty(),
    error: (_, _) => StreakStats.empty(),
  );
});

/// Data class for streak statistics
class StreakStats {
  final int currentStreak;
  final int longestStreak;
  final int totalCheckIns;
  final bool hasActiveStreak;
  final bool isInGracePeriod;
  final DateTime? lastCheckInDate;
  final DateTime? streakStartDate;

  const StreakStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalCheckIns,
    required this.hasActiveStreak,
    required this.isInGracePeriod,
    this.lastCheckInDate,
    this.streakStartDate,
  });

  factory StreakStats.fromStreak(StreakEntity? streak) {
    if (streak == null) return StreakStats.empty();

    return StreakStats(
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      totalCheckIns: streak.totalCheckIns,
      hasActiveStreak: streak.hasActiveStreak,
      isInGracePeriod: streak.gracePeriod.isInGracePeriod,
      lastCheckInDate: streak.lastCheckInDate,
      streakStartDate: streak.streakStartDate,
    );
  }

  factory StreakStats.empty() {
    return const StreakStats(
      currentStreak: 0,
      longestStreak: 0,
      totalCheckIns: 0,
      hasActiveStreak: false,
      isInGracePeriod: false,
    );
  }

  /// Streak consistency percentage (current vs longest)
  double get consistencyPercentage {
    if (longestStreak == 0) return 0.0;
    return (currentStreak / longestStreak).clamp(0.0, 1.0);
  }

  /// Average check-ins per week based on streak
  double get averageCheckInsPerWeek {
    if (currentStreak == 0 || streakStartDate == null) return 0.0;
    final daysSinceStart =
        DateTime.now().difference(streakStartDate!).inDays + 1;
    final weeks = daysSinceStart / 7.0;
    if (weeks <= 0) return 0.0;
    return currentStreak / weeks;
  }

  /// Formatted streak string (e.g., "7 days")
  String get formattedCurrentStreak {
    if (currentStreak == 0) return 'No streak';
    if (currentStreak == 1) return '1 day';
    return '$currentStreak days';
  }

  /// Formatted longest streak string
  String get formattedLongestStreak {
    if (longestStreak == 0) return 'No record';
    if (longestStreak == 1) return '1 day';
    return '$longestStreak days';
  }
}
