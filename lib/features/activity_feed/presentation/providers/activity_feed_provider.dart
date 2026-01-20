import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../domain/entities/activity_feed_entry.dart';
import '../../domain/repositories/activity_feed_repository.dart';

/// Provides the ActivityFeedRepository instance from GetIt
final activityFeedRepositoryProvider = Provider<ActivityFeedRepository>((ref) {
  return getIt<ActivityFeedRepository>();
});

/// Stream provider for the activity feed of the current user
///
/// This provider automatically watches the authenticated user and
/// streams their activity feed (check-ins from all their leagues) in real-time.
///
/// Usage:
/// ```dart
/// final feed = ref.watch(activityFeedProvider);
/// feed.when(
///   data: (entries) => ActivityFeedList(entries: entries),
///   loading: () => LoadingIndicator(),
///   error: (e, st) => ErrorWidget(error: e),
/// );
/// ```
final activityFeedProvider = StreamProvider<List<ActivityFeedEntry>>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    // Return empty list if not authenticated
    return Stream.value([]);
  }

  final repository = ref.watch(activityFeedRepositoryProvider);
  return repository.watchFeedForUser(currentUser.uid, limit: 50);
});

/// Provider that returns the count of activity feed entries
final activityFeedCountProvider = Provider<int>((ref) {
  final feed = ref.watch(activityFeedProvider);
  return feed.valueOrNull?.length ?? 0;
});

/// Provider that checks if the feed has any entries
final hasFeedEntriesProvider = Provider<bool>((ref) {
  final count = ref.watch(activityFeedCountProvider);
  return count > 0;
});

/// State for pagination of activity feed
class ActivityFeedPaginationState {
  final List<ActivityFeedEntry> entries;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const ActivityFeedPaginationState({
    this.entries = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
  });

  ActivityFeedPaginationState copyWith({
    List<ActivityFeedEntry>? entries,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return ActivityFeedPaginationState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  bool get hasError => errorMessage != null;
  bool get isEmpty => entries.isEmpty && !isLoading;
}

/// Notifier for paginated activity feed with infinite scroll support
class ActivityFeedPaginationNotifier
    extends StateNotifier<ActivityFeedPaginationState> {
  final ActivityFeedRepository _repository;
  final String? _userId;

  static const int _pageSize = 20;

  ActivityFeedPaginationNotifier(this._repository, this._userId)
      : super(const ActivityFeedPaginationState()) {
    if (_userId != null) {
      loadInitial();
    }
  }

  /// Loads the initial batch of feed entries
  Future<void> loadInitial() async {
    if (_userId == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final entries = await _repository.getFeedForUser(
        _userId,
        limit: _pageSize,
      );

      state = state.copyWith(
        entries: entries,
        isLoading: false,
        hasMore: entries.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao carregar o feed. Tente novamente.',
      );
    }
  }

  /// Loads more entries for infinite scroll
  Future<void> loadMore() async {
    if (_userId == null ||
        state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final lastEntry = state.entries.isNotEmpty ? state.entries.last : null;

      final entries = await _repository.getFeedForUser(
        _userId,
        limit: _pageSize,
        startAfter: lastEntry?.timestamp,
      );

      state = state.copyWith(
        entries: [...state.entries, ...entries],
        isLoadingMore: false,
        hasMore: entries.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Erro ao carregar mais itens.',
      );
    }
  }

  /// Refreshes the feed from the beginning
  Future<void> refresh() async {
    state = const ActivityFeedPaginationState();
    await loadInitial();
  }
}

/// Provider for paginated activity feed with infinite scroll
final activityFeedPaginationProvider = StateNotifierProvider.autoDispose<
    ActivityFeedPaginationNotifier, ActivityFeedPaginationState>((ref) {
  final repository = ref.watch(activityFeedRepositoryProvider);
  final currentUser = ref.watch(currentUserProvider);

  return ActivityFeedPaginationNotifier(repository, currentUser?.uid);
});
