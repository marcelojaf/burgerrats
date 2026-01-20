import '../entities/activity_feed_entry.dart';

/// Abstract repository for activity feed operations
///
/// This interface defines the contract for fetching activity feed data,
/// which combines check-ins with user and league information.
abstract class ActivityFeedRepository {
  /// Gets the activity feed for all leagues a user is a member of
  ///
  /// Returns feed entries sorted by timestamp (newest first).
  /// Supports pagination with [limit] and [startAfter].
  ///
  /// Throws [FirestoreException] on failure
  Future<List<ActivityFeedEntry>> getFeedForUser(
    String userId, {
    int limit = 20,
    DateTime? startAfter,
  });

  /// Gets the activity feed for a specific league
  ///
  /// Returns feed entries sorted by timestamp (newest first).
  /// Supports pagination with [limit] and [startAfter].
  ///
  /// Throws [FirestoreException] on failure
  Future<List<ActivityFeedEntry>> getFeedForLeague(
    String leagueId, {
    int limit = 20,
    DateTime? startAfter,
  });

  /// Stream of activity feed for all leagues a user is a member of
  ///
  /// Emits the list of feed entries and subsequent changes.
  /// Entries are sorted by timestamp (newest first).
  /// Supports limiting the number of results.
  Stream<List<ActivityFeedEntry>> watchFeedForUser(
    String userId, {
    int limit = 20,
  });

  /// Stream of activity feed for a specific league
  ///
  /// Emits the list of feed entries and subsequent changes.
  /// Entries are sorted by timestamp (newest first).
  /// Supports limiting the number of results.
  Stream<List<ActivityFeedEntry>> watchFeedForLeague(
    String leagueId, {
    int limit = 20,
  });
}
