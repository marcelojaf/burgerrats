import '../entities/check_in_entity.dart';

/// Abstract repository for check-in CRUD operations in Firestore
///
/// This interface defines the contract for check-in management.
/// Implementations handle persistence, daily limits validation, and real-time updates.
abstract class CheckInRepository {
  /// Creates a new check-in document in Firestore
  ///
  /// Throws [FirestoreException] on failure
  Future<void> createCheckIn(CheckInEntity checkIn);

  /// Retrieves a check-in by its unique ID
  ///
  /// Returns the check-in entity if found, null if not found.
  /// Throws [FirestoreException] on failure
  Future<CheckInEntity?> getCheckInById(String id);

  /// Updates an existing check-in's data
  ///
  /// Only updates mutable fields (note, rating, restaurantName).
  /// Does not modify id, userId, leagueId, or timestamp.
  ///
  /// Throws [FirestoreException] on failure
  Future<void> updateCheckIn(CheckInEntity checkIn);

  /// Deletes a check-in document from Firestore
  ///
  /// Throws [FirestoreException] on failure
  Future<void> deleteCheckIn(String id);

  /// Retrieves all check-ins for a specific user
  ///
  /// Returns check-ins sorted by timestamp (newest first).
  /// Supports pagination with [limit] and [startAfter].
  ///
  /// Throws [FirestoreException] on failure
  Future<List<CheckInEntity>> getCheckInsByUser(
    String userId, {
    int? limit,
    DateTime? startAfter,
  });

  /// Retrieves all check-ins for a specific league
  ///
  /// Returns check-ins sorted by timestamp (newest first).
  /// Supports pagination with [limit] and [startAfter].
  ///
  /// Throws [FirestoreException] on failure
  Future<List<CheckInEntity>> getCheckInsByLeague(
    String leagueId, {
    int? limit,
    DateTime? startAfter,
  });

  /// Retrieves check-ins for a user within a specific league
  ///
  /// Returns check-ins sorted by timestamp (newest first).
  /// Supports pagination with [limit] and [startAfter].
  ///
  /// Throws [FirestoreException] on failure
  Future<List<CheckInEntity>> getCheckInsByUserAndLeague(
    String userId,
    String leagueId, {
    int? limit,
    DateTime? startAfter,
  });

  /// Gets the count of check-ins a user has made today
  ///
  /// Used for validating daily check-in limits.
  ///
  /// Throws [FirestoreException] on failure
  Future<int> getUserDailyCheckInCount(String userId);

  /// Validates if a user can make a new check-in today
  ///
  /// Returns true if the user hasn't exceeded the daily limit (1 per day).
  ///
  /// Throws [FirestoreException] on failure
  Future<bool> canUserCheckInToday(String userId);

  /// Gets the count of check-ins a user has made today in a specific league
  ///
  /// Used for validating daily check-in limits per league.
  ///
  /// Throws [FirestoreException] on failure
  Future<int> getUserDailyCheckInCountForLeague(String userId, String leagueId);

  /// Validates if a user can make a new check-in today in a specific league
  ///
  /// Returns true if the user hasn't checked in today for this specific league.
  /// Each user is limited to one check-in per day per league.
  ///
  /// Throws [FirestoreException] on failure
  Future<bool> canUserCheckInTodayForLeague(String userId, String leagueId);

  /// Gets the user's check-in for today in a specific league, if it exists
  ///
  /// Returns the check-in entity if the user has already checked in today
  /// for this league, or null if they haven't.
  ///
  /// Throws [FirestoreException] on failure
  Future<CheckInEntity?> getUserTodayCheckInForLeague(
    String userId,
    String leagueId,
  );

  /// Gets check-ins for a user on a specific date
  ///
  /// Returns all check-ins made by the user on the given date.
  ///
  /// Throws [FirestoreException] on failure
  Future<List<CheckInEntity>> getUserCheckInsOnDate(
    String userId,
    DateTime date,
  );

  /// Stream of check-ins for a specific league (real-time updates)
  ///
  /// Emits the list of check-ins and subsequent changes.
  /// Check-ins are sorted by timestamp (newest first).
  /// Supports limiting the number of results.
  Stream<List<CheckInEntity>> watchLeagueCheckIns(
    String leagueId, {
    int? limit,
  });

  /// Stream of check-ins for a specific user (real-time updates)
  ///
  /// Emits the list of check-ins and subsequent changes.
  /// Check-ins are sorted by timestamp (newest first).
  /// Supports limiting the number of results.
  Stream<List<CheckInEntity>> watchUserCheckIns(
    String userId, {
    int? limit,
  });

  /// Stream of a single check-in (real-time updates)
  ///
  /// Emits the check-in data and subsequent changes.
  /// Emits null if the check-in doesn't exist.
  Stream<CheckInEntity?> watchCheckIn(String id);

  /// Gets the total count of check-ins in a league
  ///
  /// Throws [FirestoreException] on failure
  Future<int> getLeagueCheckInCount(String leagueId);

  /// Gets the total count of check-ins by a user
  ///
  /// Throws [FirestoreException] on failure
  Future<int> getUserCheckInCount(String userId);
}
