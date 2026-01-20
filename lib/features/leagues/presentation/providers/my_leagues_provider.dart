import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/state/providers/auth_state_provider.dart';
import '../../domain/entities/league_entity.dart';
import 'join_league_provider.dart';

/// Stream provider for the current user's leagues
///
/// This provider automatically watches the authenticated user and
/// streams their leagues in real-time from Firestore.
///
/// Usage:
/// ```dart
/// final myLeagues = ref.watch(myLeaguesProvider);
/// myLeagues.when(
///   data: (leagues) => LeaguesList(leagues: leagues),
///   loading: () => LoadingIndicator(),
///   error: (e, st) => ErrorWidget(error: e),
/// );
/// ```
final myLeaguesProvider = StreamProvider<List<LeagueEntity>>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    // Return empty list if not authenticated
    return Stream.value([]);
  }

  final repository = ref.watch(leagueRepositoryProvider);
  return repository.watchLeaguesForUser(currentUser.uid);
});

/// Provider that returns the count of leagues the user is a member of
final myLeaguesCountProvider = Provider<int>((ref) {
  final leagues = ref.watch(myLeaguesProvider);
  return leagues.valueOrNull?.length ?? 0;
});

/// Provider that checks if the user has any leagues
final hasLeaguesProvider = Provider<bool>((ref) {
  final count = ref.watch(myLeaguesCountProvider);
  return count > 0;
});
