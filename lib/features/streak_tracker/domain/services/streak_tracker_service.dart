import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../../check_ins/domain/entities/check_in_entity.dart';
import '../../../check_ins/domain/repositories/check_in_repository.dart';
import '../entities/streak_entity.dart';
import '../repositories/streak_repository.dart';

/// Service for calculating and managing user check-in streaks
///
/// Handles streak calculation logic including:
/// - Recording new check-ins and updating streaks
/// - Grace period handling
/// - Streak reset on missed days
/// - Historical streak tracking
@lazySingleton
class StreakTrackerService {
  final StreakRepository _streakRepository;
  final CheckInRepository _checkInRepository;
  final Uuid _uuid;

  /// Default grace period in hours (4 hours after midnight)
  static const int defaultGracePeriodHours = 4;

  StreakTrackerService(
    this._streakRepository,
    this._checkInRepository,
    this._uuid,
  );

  /// Records a check-in and updates the user's streak accordingly
  ///
  /// This should be called whenever a user makes a check-in.
  /// It will:
  /// 1. Get or create the user's streak record
  /// 2. Check if the streak should be reset (missed days)
  /// 3. Update the current streak count
  /// 4. Update the longest streak if applicable
  Future<StreakEntity> recordCheckIn(CheckInEntity checkIn) async {
    final userId = checkIn.userId;
    final checkInDate = checkIn.timestamp;

    // Get or create streak record
    StreakEntity streak = await _streakRepository.getStreakByUserId(userId) ??
        StreakEntity.initial(
          id: _uuid.v4(),
          userId: userId,
        );

    // Get the start of the check-in day and today
    final checkInDay = _getStartOfDate(checkInDate);
    final today = _getStartOfToday();

    // Check if already checked in today
    final lastCheckInDay = streak.lastCheckInDate != null
        ? _getStartOfDate(streak.lastCheckInDate!)
        : null;

    if (lastCheckInDay != null && lastCheckInDay.isAtSameMomentAs(checkInDay)) {
      // Already checked in today, just increment total and return
      streak = streak.copyWith(
        totalCheckIns: streak.totalCheckIns + 1,
        updatedAt: DateTime.now(),
      );
      await _streakRepository.saveStreak(streak);
      return streak;
    }

    // Calculate the new streak value
    int newStreak;
    DateTime? newStreakStartDate;

    if (lastCheckInDay == null) {
      // First check-in ever
      newStreak = 1;
      newStreakStartDate = checkInDay;
    } else {
      final yesterday = checkInDay.subtract(const Duration(days: 1));

      if (lastCheckInDay.isAtSameMomentAs(yesterday)) {
        // Consecutive day - extend the streak
        newStreak = streak.currentStreak + 1;
        newStreakStartDate = streak.streakStartDate ?? checkInDay;
      } else if (lastCheckInDay.isAtSameMomentAs(checkInDay)) {
        // Same day (shouldn't reach here due to earlier check)
        newStreak = streak.currentStreak;
        newStreakStartDate = streak.streakStartDate;
      } else {
        // Missed a day - check grace period
        final gracePeriodHours = streak.gracePeriod.gracePeriodHours;
        final now = DateTime.now();

        // Calculate when grace period expired
        final dayAfterLastCheckIn = lastCheckInDay.add(const Duration(days: 1));
        final gracePeriodExpires = DateTime(
          dayAfterLastCheckIn.year,
          dayAfterLastCheckIn.month,
          dayAfterLastCheckIn.day,
          gracePeriodHours,
        );

        // Check if we're within grace period
        if (checkInDay.isAtSameMomentAs(dayAfterLastCheckIn) &&
            now.isBefore(gracePeriodExpires)) {
          // Within grace period - extend streak
          newStreak = streak.currentStreak + 1;
          newStreakStartDate = streak.streakStartDate ?? checkInDay;
        } else {
          // Streak is broken - start fresh
          newStreak = 1;
          newStreakStartDate = checkInDay;
        }
      }
    }

    // Update longest streak if current exceeds it
    final newLongestStreak = newStreak > streak.longestStreak
        ? newStreak
        : streak.longestStreak;

    final newLongestStreakDate = newStreak > streak.longestStreak
        ? checkInDay
        : streak.longestStreakDate;

    // Clear grace period status since user has checked in
    final updatedGracePeriod = streak.gracePeriod.copyWith(
      isInGracePeriod: false,
      gracePeriodExpiresAt: null,
    );

    // Create updated streak
    streak = streak.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastCheckInDate: checkInDate,
      streakStartDate: newStreakStartDate,
      longestStreakDate: newLongestStreakDate,
      gracePeriod: updatedGracePeriod,
      totalCheckIns: streak.totalCheckIns + 1,
      updatedAt: DateTime.now(),
    );

    await _streakRepository.saveStreak(streak);
    return streak;
  }

  /// Gets the current streak status for a user
  ///
  /// This will:
  /// 1. Fetch the streak record
  /// 2. Check if the streak should be reset (missed days + grace period expired)
  /// 3. Update grace period status if needed
  /// 4. Return the current status
  Future<StreakEntity> getStreakStatus(String userId) async {
    StreakEntity? streak = await _streakRepository.getStreakByUserId(userId);

    if (streak == null) {
      // No streak record exists - create initial one
      streak = StreakEntity.initial(
        id: _uuid.v4(),
        userId: userId,
      );
      await _streakRepository.saveStreak(streak);
      return streak;
    }

    // Check if streak should be reset
    if (await _shouldResetStreak(streak)) {
      streak = streak.copyWith(
        currentStreak: 0,
        streakStartDate: null,
        gracePeriod: streak.gracePeriod.copyWith(
          isInGracePeriod: false,
          gracePeriodExpiresAt: null,
        ),
        updatedAt: DateTime.now(),
      );
      await _streakRepository.updateStreak(streak);
      return streak;
    }

    // Check if user is in grace period
    streak = await _updateGracePeriodStatus(streak);

    return streak;
  }

  /// Calculates streak from historical check-in data
  ///
  /// This method recalculates the streak based on actual check-in history.
  /// Useful for data recovery or verification.
  Future<StreakEntity> calculateStreakFromHistory(String userId) async {
    // Get all check-ins for the user, sorted by date descending
    final checkIns = await _checkInRepository.getCheckInsByUser(userId);

    if (checkIns.isEmpty) {
      return StreakEntity.initial(
        id: _uuid.v4(),
        userId: userId,
      );
    }

    // Group check-ins by date
    final checkInDates = <DateTime>{};
    for (final checkIn in checkIns) {
      checkInDates.add(_getStartOfDate(checkIn.timestamp));
    }

    // Sort dates ascending
    final sortedDates = checkInDates.toList()..sort();

    // Calculate current streak (counting back from today)
    final today = _getStartOfToday();
    int currentStreak = 0;
    DateTime? lastConsecutiveDate;
    DateTime? streakStartDate;

    // Start from today or the most recent check-in date
    DateTime? checkDate = sortedDates.lastOrNull;

    if (checkDate != null) {
      // Find the most recent consecutive streak
      for (int i = sortedDates.length - 1; i >= 0; i--) {
        final date = sortedDates[i];

        if (lastConsecutiveDate == null) {
          // First date in backward scan
          lastConsecutiveDate = date;
          currentStreak = 1;
          streakStartDate = date;
        } else {
          final expectedPreviousDay =
              lastConsecutiveDate.subtract(const Duration(days: 1));

          if (date.isAtSameMomentAs(expectedPreviousDay)) {
            // Consecutive day
            currentStreak++;
            streakStartDate = date;
            lastConsecutiveDate = date;
          } else {
            // Gap found - stop counting current streak
            break;
          }
        }
      }

      // Check if the streak is still active (checked in today or yesterday with grace)
      final yesterday = today.subtract(const Duration(days: 1));
      final mostRecentCheckIn = sortedDates.last;

      if (!mostRecentCheckIn.isAtSameMomentAs(today) &&
          !mostRecentCheckIn.isAtSameMomentAs(yesterday)) {
        // Streak has expired
        currentStreak = 0;
        streakStartDate = null;
      }
    }

    // Calculate longest streak
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? longestStreakDate;
    DateTime? tempStreakStart;

    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];

      if (i == 0) {
        tempStreak = 1;
        tempStreakStart = date;
      } else {
        final previousDate = sortedDates[i - 1];
        final expectedNextDay = previousDate.add(const Duration(days: 1));

        if (date.isAtSameMomentAs(expectedNextDay)) {
          tempStreak++;
        } else {
          // Gap found - check if this was the longest
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
            longestStreakDate = sortedDates[i - 1];
          }
          tempStreak = 1;
          tempStreakStart = date;
        }
      }
    }

    // Check final streak
    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
      longestStreakDate = sortedDates.last;
    }

    // Use current streak if it's the longest
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
      longestStreakDate = sortedDates.last;
    }

    // Get existing streak record or create new
    final existingStreak = await _streakRepository.getStreakByUserId(userId);
    final streakId = existingStreak?.id ?? _uuid.v4();

    final streak = StreakEntity(
      id: streakId,
      userId: userId,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastCheckInDate: sortedDates.lastOrNull,
      streakStartDate: streakStartDate,
      longestStreakDate: longestStreakDate,
      gracePeriod: const StreakGracePeriod(),
      totalCheckIns: checkIns.length,
      updatedAt: DateTime.now(),
    );

    await _streakRepository.saveStreak(streak);
    return streak;
  }

  /// Checks if the streak should be reset based on time elapsed
  Future<bool> _shouldResetStreak(StreakEntity streak) async {
    if (streak.currentStreak == 0) {
      return false;
    }

    if (streak.lastCheckInDate == null) {
      return true;
    }

    final now = DateTime.now();
    final lastCheckInDay = _getStartOfDate(streak.lastCheckInDate!);
    final today = _getStartOfToday();

    // Already checked in today
    if (lastCheckInDay.isAtSameMomentAs(today)) {
      return false;
    }

    final yesterday = today.subtract(const Duration(days: 1));

    // Checked in yesterday - may still be in grace period
    if (lastCheckInDay.isAtSameMomentAs(yesterday)) {
      final gracePeriodHours = streak.gracePeriod.gracePeriodHours;
      final gracePeriodExpires = DateTime(
        today.year,
        today.month,
        today.day,
        gracePeriodHours,
      );

      return now.isAfter(gracePeriodExpires);
    }

    // Missed more than one day - streak is broken
    return lastCheckInDay.isBefore(yesterday);
  }

  /// Updates the grace period status for a streak
  Future<StreakEntity> _updateGracePeriodStatus(StreakEntity streak) async {
    if (streak.currentStreak == 0 || streak.lastCheckInDate == null) {
      return streak;
    }

    final now = DateTime.now();
    final lastCheckInDay = _getStartOfDate(streak.lastCheckInDate!);
    final today = _getStartOfToday();

    // Already checked in today - no grace period needed
    if (lastCheckInDay.isAtSameMomentAs(today)) {
      if (streak.gracePeriod.isInGracePeriod) {
        final updated = streak.copyWith(
          gracePeriod: streak.gracePeriod.copyWith(
            isInGracePeriod: false,
            gracePeriodExpiresAt: null,
          ),
          updatedAt: DateTime.now(),
        );
        await _streakRepository.updateStreak(updated);
        return updated;
      }
      return streak;
    }

    final yesterday = today.subtract(const Duration(days: 1));

    // Checked in yesterday - may be in grace period
    if (lastCheckInDay.isAtSameMomentAs(yesterday)) {
      final gracePeriodHours = streak.gracePeriod.gracePeriodHours;
      final gracePeriodExpires = DateTime(
        today.year,
        today.month,
        today.day,
        gracePeriodHours,
      );

      if (now.isBefore(gracePeriodExpires)) {
        // User is in grace period
        if (!streak.gracePeriod.isInGracePeriod ||
            streak.gracePeriod.gracePeriodExpiresAt != gracePeriodExpires) {
          final updated = streak.copyWith(
            gracePeriod: streak.gracePeriod.copyWith(
              isInGracePeriod: true,
              gracePeriodExpiresAt: gracePeriodExpires,
            ),
            updatedAt: DateTime.now(),
          );
          await _streakRepository.updateStreak(updated);
          return updated;
        }
      }
    }

    return streak;
  }

  /// Gets the start of a specific date (midnight)
  DateTime _getStartOfDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the start of today (midnight)
  DateTime _getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
