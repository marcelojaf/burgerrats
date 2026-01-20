import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/repositories/streak_repository.dart';
import '../models/streak_model.dart';

/// Implementation of [StreakRepository] using Cloud Firestore
///
/// This class is registered as a lazy singleton with injectable,
/// meaning it will be created when first accessed and reused thereafter.
@LazySingleton(as: StreakRepository)
class StreakRepositoryImpl implements StreakRepository {
  final FirebaseFirestore _firestore;

  /// Collection reference for streaks
  static const String _streaksCollection = 'streaks';

  /// Default grace period in hours
  static const int _defaultGracePeriodHours = 4;

  StreakRepositoryImpl(this._firestore);

  /// Gets the streaks collection reference
  CollectionReference<Json> get _streaksRef =>
      _firestore.collection(_streaksCollection);

  /// Gets a document reference for a specific streak
  DocumentReference<Json> _streakDoc(String id) => _streaksRef.doc(id);

  /// Gets the start of a specific date
  DateTime _getStartOfDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the start of today
  DateTime _getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Gets yesterday's date
  DateTime _getYesterday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
  }

  @override
  Future<void> saveStreak(StreakEntity streak) async {
    try {
      final streakModel = StreakModel.fromEntity(streak);
      await _streakDoc(streak.id).set(streakModel.toJson());
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to save streak: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<StreakEntity?> getStreakByUserId(String userId) async {
    try {
      final snapshot = await _streaksRef
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return StreakModel.fromFirestore(snapshot.docs.first).toEntity();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get streak by user ID: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<StreakEntity?> getStreakById(String id) async {
    try {
      final doc = await _streakDoc(id).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return StreakModel.fromFirestore(doc).toEntity();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get streak: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> updateStreak(StreakEntity streak) async {
    try {
      final streakModel = StreakModel.fromEntity(streak);
      await _streakDoc(streak.id).update(streakModel.toJsonForUpdate());
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update streak: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteStreak(String id) async {
    try {
      await _streakDoc(id).delete();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to delete streak: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<StreakEntity?> watchUserStreak(String userId) {
    return _streaksRef
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }
      return StreakModel.fromFirestore(snapshot.docs.first).toEntity();
    }).handleError((error, stackTrace) {
      if (error is FirebaseException) {
        throw FirestoreException(
          message: 'Failed to watch user streak: ${error.message}',
          code: error.code,
          originalError: error,
          stackTrace: stackTrace,
        );
      }
      throw error;
    });
  }

  @override
  Future<List<StreakEntity>> getTopStreaks({int limit = 10}) async {
    try {
      final snapshot = await _streaksRef
          .where('currentStreak', isGreaterThan: 0)
          .orderBy('currentStreak', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => StreakModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get top streaks: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<StreakEntity>> getTopLongestStreaks({int limit = 10}) async {
    try {
      final snapshot = await _streaksRef
          .where('longestStreak', isGreaterThan: 0)
          .orderBy('longestStreak', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => StreakModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get top longest streaks: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<List<StreakEntity>> watchTopStreaks({int limit = 10}) {
    return _streaksRef
        .where('currentStreak', isGreaterThan: 0)
        .orderBy('currentStreak', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StreakModel.fromFirestore(doc).toEntity())
          .toList();
    }).handleError((error, stackTrace) {
      if (error is FirebaseException) {
        throw FirestoreException(
          message: 'Failed to watch top streaks: ${error.message}',
          code: error.code,
          originalError: error,
          stackTrace: stackTrace,
        );
      }
      throw error;
    });
  }

  @override
  Future<int> resetExpiredStreaks() async {
    try {
      final now = DateTime.now();
      int resetCount = 0;

      // Get all streaks that are potentially expired
      // (last check-in before yesterday and grace period is not active)
      final yesterday = _getYesterday();

      final snapshot = await _streaksRef
          .where('currentStreak', isGreaterThan: 0)
          .get();

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        final streak = StreakModel.fromFirestore(doc);

        if (streak.lastCheckInDate == null) continue;

        final lastCheckInDay = _getStartOfDate(streak.lastCheckInDate!);
        final gracePeriodHours = streak.gracePeriod.gracePeriodHours;

        // Calculate grace period expiration
        final gracePeriodExpires = DateTime(
          lastCheckInDay.year,
          lastCheckInDay.month,
          lastCheckInDay.day + 1,
          gracePeriodHours,
        );

        // If grace period has expired, reset the streak
        if (now.isAfter(gracePeriodExpires) && lastCheckInDay.isBefore(yesterday)) {
          final updatedStreak = streak.copyWith(
            currentStreak: 0,
            streakStartDate: null,
            gracePeriod: streak.gracePeriod.copyWith(
              isInGracePeriod: false,
              gracePeriodExpiresAt: null,
            ),
            updatedAt: now,
          );

          batch.update(doc.reference, StreakModel.fromEntity(updatedStreak).toJsonForUpdate());
          resetCount++;
        }
      }

      if (resetCount > 0) {
        await batch.commit();
      }

      return resetCount;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to reset expired streaks: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<StreakEntity>> getStreaksInGracePeriod() async {
    try {
      final snapshot = await _streaksRef
          .where('gracePeriod.isInGracePeriod', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => StreakModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get streaks in grace period: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> shouldResetStreak(String userId) async {
    try {
      final streak = await getStreakByUserId(userId);

      if (streak == null || streak.currentStreak == 0) {
        return false;
      }

      if (streak.lastCheckInDate == null) {
        return true;
      }

      final now = DateTime.now();
      final lastCheckInDay = _getStartOfDate(streak.lastCheckInDate!);
      final today = _getStartOfToday();

      // If already checked in today, no reset needed
      if (lastCheckInDay.isAtSameMomentAs(today)) {
        return false;
      }

      final yesterday = today.subtract(const Duration(days: 1));

      // If last check-in was yesterday, still within grace
      if (lastCheckInDay.isAtSameMomentAs(yesterday)) {
        // Check if grace period has expired
        final gracePeriodHours = streak.gracePeriod.gracePeriodHours;
        final gracePeriodExpires = DateTime(
          today.year,
          today.month,
          today.day,
          gracePeriodHours,
        );

        return now.isAfter(gracePeriodExpires);
      }

      // If last check-in was more than a day ago, streak should be reset
      return lastCheckInDay.isBefore(yesterday);
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to check if streak should reset: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
