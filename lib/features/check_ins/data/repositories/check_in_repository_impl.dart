import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/check_in_entity.dart';
import '../../domain/repositories/check_in_repository.dart';
import '../models/check_in_model.dart';

/// Implementation of [CheckInRepository] using Cloud Firestore
///
/// This class is registered as a lazy singleton with injectable,
/// meaning it will be created when first accessed and reused thereafter.
@LazySingleton(as: CheckInRepository)
class CheckInRepositoryImpl implements CheckInRepository {
  final FirebaseFirestore _firestore;

  /// Collection reference for check-ins
  static const String _checkInsCollection = 'checkIns';

  /// Daily check-in limit per user
  static const int _dailyCheckInLimit = 1;

  CheckInRepositoryImpl(this._firestore);

  /// Gets the check-ins collection reference
  CollectionReference<Json> get _checkInsRef =>
      _firestore.collection(_checkInsCollection);

  /// Gets a document reference for a specific check-in
  DocumentReference<Json> _checkInDoc(String id) => _checkInsRef.doc(id);

  /// Gets the start of today in UTC
  DateTime _getStartOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Gets the end of today in UTC
  DateTime _getEndOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  }

  /// Gets the start of a specific date
  DateTime _getStartOfDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the end of a specific date
  DateTime _getEndOfDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  @override
  Future<void> createCheckIn(CheckInEntity checkIn) async {
    try {
      final checkInModel = CheckInModel.fromEntity(checkIn);
      await _checkInDoc(checkIn.id).set(checkInModel.toJson());
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to create check-in: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<CheckInEntity?> getCheckInById(String id) async {
    try {
      final doc = await _checkInDoc(id).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return CheckInModel.fromFirestore(doc).toEntity();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get check-in: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> updateCheckIn(CheckInEntity checkIn) async {
    try {
      final checkInModel = CheckInModel.fromEntity(checkIn);
      await _checkInDoc(checkIn.id).update(checkInModel.toJsonForUpdate());
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update check-in: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteCheckIn(String id) async {
    try {
      await _checkInDoc(id).delete();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to delete check-in: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<CheckInEntity>> getCheckInsByUser(
    String userId, {
    int? limit,
    DateTime? startAfter,
  }) async {
    try {
      Query<Json> query = _checkInsRef
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get user check-ins: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<CheckInEntity>> getCheckInsByLeague(
    String leagueId, {
    int? limit,
    DateTime? startAfter,
  }) async {
    try {
      Query<Json> query = _checkInsRef
          .where('leagueId', isEqualTo: leagueId)
          .orderBy('timestamp', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get league check-ins: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<CheckInEntity>> getCheckInsByUserAndLeague(
    String userId,
    String leagueId, {
    int? limit,
    DateTime? startAfter,
  }) async {
    try {
      Query<Json> query = _checkInsRef
          .where('userId', isEqualTo: userId)
          .where('leagueId', isEqualTo: leagueId)
          .orderBy('timestamp', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get user league check-ins: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<int> getUserDailyCheckInCount(String userId) async {
    try {
      final startOfDay = _getStartOfToday();
      final endOfDay = _getEndOfToday();

      final snapshot = await _checkInsRef
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .count()
          .get();

      return snapshot.count ?? 0;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get daily check-in count: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> canUserCheckInToday(String userId) async {
    final count = await getUserDailyCheckInCount(userId);
    return count < _dailyCheckInLimit;
  }

  @override
  Future<int> getUserDailyCheckInCountForLeague(
    String userId,
    String leagueId,
  ) async {
    try {
      final startOfDay = _getStartOfToday();
      final endOfDay = _getEndOfToday();

      final snapshot = await _checkInsRef
          .where('userId', isEqualTo: userId)
          .where('leagueId', isEqualTo: leagueId)
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .count()
          .get();

      return snapshot.count ?? 0;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get daily check-in count for league: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> canUserCheckInTodayForLeague(
    String userId,
    String leagueId,
  ) async {
    final count = await getUserDailyCheckInCountForLeague(userId, leagueId);
    return count < _dailyCheckInLimit;
  }

  @override
  Future<CheckInEntity?> getUserTodayCheckInForLeague(
    String userId,
    String leagueId,
  ) async {
    try {
      final startOfDay = _getStartOfToday();
      final endOfDay = _getEndOfToday();

      final snapshot = await _checkInsRef
          .where('userId', isEqualTo: userId)
          .where('leagueId', isEqualTo: leagueId)
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return CheckInModel.fromFirestore(snapshot.docs.first).toEntity();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get today\'s check-in for league: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<CheckInEntity>> getUserCheckInsOnDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final startOfDate = _getStartOfDate(date);
      final endOfDate = _getEndOfDate(date);

      final snapshot = await _checkInsRef
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDate))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDate))
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get check-ins on date: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<List<CheckInEntity>> watchLeagueCheckIns(
    String leagueId, {
    int? limit,
  }) {
    Query<Json> query = _checkInsRef
        .where('leagueId', isEqualTo: leagueId)
        .orderBy('timestamp', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
    }).handleError((error, stackTrace) {
      if (error is FirebaseException) {
        throw FirestoreException(
          message: 'Failed to watch league check-ins: ${error.message}',
          code: error.code,
          originalError: error,
          stackTrace: stackTrace,
        );
      }
      throw error;
    });
  }

  @override
  Stream<List<CheckInEntity>> watchUserCheckIns(
    String userId, {
    int? limit,
  }) {
    Query<Json> query = _checkInsRef
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
    }).handleError((error, stackTrace) {
      if (error is FirebaseException) {
        throw FirestoreException(
          message: 'Failed to watch user check-ins: ${error.message}',
          code: error.code,
          originalError: error,
          stackTrace: stackTrace,
        );
      }
      throw error;
    });
  }

  @override
  Stream<CheckInEntity?> watchCheckIn(String id) {
    return _checkInDoc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return CheckInModel.fromFirestore(doc).toEntity();
    }).handleError((error, stackTrace) {
      if (error is FirebaseException) {
        throw FirestoreException(
          message: 'Failed to watch check-in: ${error.message}',
          code: error.code,
          originalError: error,
          stackTrace: stackTrace,
        );
      }
      throw error;
    });
  }

  @override
  Future<int> getLeagueCheckInCount(String leagueId) async {
    try {
      final snapshot = await _checkInsRef
          .where('leagueId', isEqualTo: leagueId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get league check-in count: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<int> getUserCheckInCount(String userId) async {
    try {
      final snapshot = await _checkInsRef
          .where('userId', isEqualTo: userId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get user check-in count: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
