import '../entities/streak_entity.dart';

/// Abstract repository for streak data management in Firestore
///
/// This interface defines the contract for streak tracking operations.
/// Implementations handle persistence and real-time updates.
abstract class StreakRepository {
  /// Creates or updates a streak record for a user
  ///
  /// If the user already has a streak record, it will be updated.
  /// Otherwise, a new record will be created.
  ///
  /// Throws [FirestoreException] on failure
  Future<void> saveStreak(StreakEntity streak);

  /// Retrieves the streak record for a specific user
  ///
  /// Returns the streak entity if found, null if the user has no streak record.
  ///
  /// Throws [FirestoreException] on failure
  Future<StreakEntity?> getStreakByUserId(String userId);

  /// Retrieves the streak record by its unique ID
  ///
  /// Returns the streak entity if found, null if not found.
  ///
  /// Throws [FirestoreException] on failure
  Future<StreakEntity?> getStreakById(String id);

  /// Updates an existing streak record
  ///
  /// Throws [FirestoreException] on failure
  Future<void> updateStreak(StreakEntity streak);

  /// Deletes a streak record
  ///
  /// Throws [FirestoreException] on failure
  Future<void> deleteStreak(String id);

  /// Stream of a user's streak data (real-time updates)
  ///
  /// Emits the streak data and subsequent changes.
  /// Emits null if the user has no streak record.
  Stream<StreakEntity?> watchUserStreak(String userId);

  /// Gets users with the highest current streaks (leaderboard)
  ///
  /// Returns a list of streak entities sorted by current streak (descending).
  /// Supports limiting the number of results.
  ///
  /// Throws [FirestoreException] on failure
  Future<List<StreakEntity>> getTopStreaks({int limit = 10});

  /// Gets users with the highest all-time streaks (leaderboard)
  ///
  /// Returns a list of streak entities sorted by longest streak (descending).
  /// Supports limiting the number of results.
  ///
  /// Throws [FirestoreException] on failure
  Future<List<StreakEntity>> getTopLongestStreaks({int limit = 10});

  /// Stream of top current streaks (real-time updates)
  ///
  /// Emits the list of streak leaders and subsequent changes.
  /// Supports limiting the number of results.
  Stream<List<StreakEntity>> watchTopStreaks({int limit = 10});

  /// Resets all users' current streaks that have expired
  ///
  /// This is typically called by a scheduled job to handle
  /// streak expirations for users who missed their grace period.
  ///
  /// Returns the number of streaks that were reset.
  ///
  /// Throws [FirestoreException] on failure
  Future<int> resetExpiredStreaks();

  /// Gets all streaks that are currently in grace period
  ///
  /// Returns streaks where the user hasn't checked in today
  /// but is still within the grace period window.
  ///
  /// Throws [FirestoreException] on failure
  Future<List<StreakEntity>> getStreaksInGracePeriod();

  /// Checks if a user's streak should be reset based on their last check-in
  ///
  /// Returns true if the streak should be reset (missed day + grace period expired).
  ///
  /// Throws [FirestoreException] on failure
  Future<bool> shouldResetStreak(String userId);
}
