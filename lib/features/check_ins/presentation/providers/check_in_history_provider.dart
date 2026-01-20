import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../leagues/domain/entities/league_entity.dart';
import '../../../leagues/domain/repositories/league_repository.dart';
import '../../domain/entities/check_in_entity.dart';
import '../../domain/repositories/check_in_repository.dart';

/// Filter state for check-in history
class CheckInHistoryFilter {
  /// Selected league ID for filtering (null = all leagues)
  final String? leagueId;

  /// Start date for date range filter (null = no start limit)
  final DateTime? startDate;

  /// End date for date range filter (null = no end limit)
  final DateTime? endDate;

  const CheckInHistoryFilter({
    this.leagueId,
    this.startDate,
    this.endDate,
  });

  const CheckInHistoryFilter.initial()
      : leagueId = null,
        startDate = null,
        endDate = null;

  /// Whether any filters are active
  bool get hasActiveFilters =>
      leagueId != null || startDate != null || endDate != null;

  /// Creates a copy with updated fields
  CheckInHistoryFilter copyWith({
    String? leagueId,
    DateTime? startDate,
    DateTime? endDate,
    bool clearLeagueId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return CheckInHistoryFilter(
      leagueId: clearLeagueId ? null : (leagueId ?? this.leagueId),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CheckInHistoryFilter &&
        other.leagueId == leagueId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => Object.hash(leagueId, startDate, endDate);
}

/// Provider for the CheckInRepository instance
final checkInHistoryRepositoryProvider = Provider<CheckInRepository>((ref) {
  return getIt<CheckInRepository>();
});

/// Provider for the LeagueRepository instance (for league name lookup)
final checkInHistoryLeagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return getIt<LeagueRepository>();
});

/// Stream provider for check-in history with real-time updates and filtering
///
/// This provider automatically watches the authenticated user and
/// streams their check-ins with applied filters.
final checkInHistoryProvider = StreamProvider<List<CheckInEntity>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final filter = ref.watch(checkInHistoryFilterNotifierProvider);

  if (currentUser == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(checkInHistoryRepositoryProvider);

  // Use filtered stream if any filters are active, otherwise use simple watch
  if (filter.hasActiveFilters) {
    return repository.watchUserCheckInsFiltered(
      currentUser.uid,
      leagueId: filter.leagueId,
      startDate: filter.startDate,
      endDate: filter.endDate,
    );
  } else {
    return repository.watchUserCheckIns(currentUser.uid);
  }
});

/// Provider for user's leagues (for the filter dropdown)
final userLeaguesForFilterProvider = StreamProvider<List<LeagueEntity>>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(checkInHistoryLeagueRepositoryProvider);
  return repository.watchLeaguesForUser(currentUser.uid);
});

/// Provider to get a league by ID (for displaying league name on check-in cards)
final leagueByIdProvider =
    FutureProvider.family<LeagueEntity?, String>((ref, leagueId) async {
  final repository = ref.watch(checkInHistoryLeagueRepositoryProvider);
  return repository.getLeagueById(leagueId);
});

/// Provider that returns the count of check-ins for the current filter
final checkInHistoryCountProvider = Provider<int>((ref) {
  final checkIns = ref.watch(checkInHistoryProvider);
  return checkIns.valueOrNull?.length ?? 0;
});

/// Notifier for managing check-in history filter state with convenience methods
class CheckInHistoryFilterNotifier extends StateNotifier<CheckInHistoryFilter> {
  CheckInHistoryFilterNotifier() : super(const CheckInHistoryFilter.initial());

  /// Sets the league filter
  void setLeagueFilter(String? leagueId) {
    state = state.copyWith(
      leagueId: leagueId,
      clearLeagueId: leagueId == null,
    );
  }

  /// Sets the start date filter
  void setStartDate(DateTime? date) {
    state = state.copyWith(
      startDate: date,
      clearStartDate: date == null,
    );
  }

  /// Sets the end date filter
  void setEndDate(DateTime? date) {
    state = state.copyWith(
      endDate: date,
      clearEndDate: date == null,
    );
  }

  /// Sets both start and end date for a date range
  void setDateRange(DateTime? start, DateTime? end) {
    state = CheckInHistoryFilter(
      leagueId: state.leagueId,
      startDate: start,
      endDate: end,
    );
  }

  /// Clears all filters
  void clearAllFilters() {
    state = const CheckInHistoryFilter.initial();
  }

  /// Clears only the date range filters
  void clearDateRange() {
    state = state.copyWith(
      clearStartDate: true,
      clearEndDate: true,
    );
  }
}

/// Provider for the filter notifier (for modifying filters)
final checkInHistoryFilterNotifierProvider =
    StateNotifierProvider<CheckInHistoryFilterNotifier, CheckInHistoryFilter>(
  (ref) => CheckInHistoryFilterNotifier(),
);
