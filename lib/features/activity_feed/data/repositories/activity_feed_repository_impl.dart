import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../../check_ins/data/models/check_in_model.dart';
import '../../../check_ins/domain/entities/check_in_entity.dart';
import '../../../leagues/domain/repositories/league_repository.dart';
import '../../domain/entities/activity_feed_entry.dart';
import '../../domain/repositories/activity_feed_repository.dart';

/// Implementation of [ActivityFeedRepository] using Cloud Firestore
///
/// This repository combines check-in data with user and league information
/// to create enriched activity feed entries.
@LazySingleton(as: ActivityFeedRepository)
class ActivityFeedRepositoryImpl implements ActivityFeedRepository {
  final FirebaseFirestore _firestore;
  final UserRepository _userRepository;
  final LeagueRepository _leagueRepository;

  /// Collection reference for check-ins
  static const String _checkInsCollection = 'checkIns';

  /// Maximum leagues to query at once (Firestore limit)
  static const int _maxLeaguesPerQuery = 10;

  /// Cache for user display names and photos
  final Map<String, _UserCacheEntry> _userCache = {};

  /// Cache for league names
  final Map<String, String> _leagueNameCache = {};

  /// Cache duration for user data
  static const Duration _cacheDuration = Duration(minutes: 5);

  ActivityFeedRepositoryImpl(
    this._firestore,
    this._userRepository,
    this._leagueRepository,
  );

  /// Gets the check-ins collection reference
  CollectionReference<Json> get _checkInsRef =>
      _firestore.collection(_checkInsCollection);

  @override
  Future<List<ActivityFeedEntry>> getFeedForUser(
    String userId, {
    int limit = 20,
    DateTime? startAfter,
  }) async {
    try {
      // First, get all leagues the user is a member of
      final leagues = await _leagueRepository.getLeaguesForUser(userId);

      if (leagues.isEmpty) {
        return [];
      }

      // Cache league names
      for (final league in leagues) {
        _leagueNameCache[league.id] = league.name;
      }

      // Take only first 10 leagues (Firestore whereIn limit)
      // Sort by createdAt descending to prioritize recent leagues
      final sortedLeagues = List.of(leagues)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final leagueIds = sortedLeagues
          .take(_maxLeaguesPerQuery)
          .map((l) => l.id)
          .toList();

      // Query check-ins from user's leagues
      Query<Json> query = _checkInsRef
          .where('leagueId', whereIn: leagueIds)
          .orderBy('timestamp', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final checkIns = snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();

      // Enrich check-ins with user and league data
      return _enrichCheckIns(checkIns);
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get activity feed: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<List<ActivityFeedEntry>> getFeedForLeague(
    String leagueId, {
    int limit = 20,
    DateTime? startAfter,
  }) async {
    try {
      // Get league info for caching
      final league = await _leagueRepository.getLeagueById(leagueId);
      if (league != null) {
        _leagueNameCache[leagueId] = league.name;
      }

      Query<Json> query = _checkInsRef
          .where('leagueId', isEqualTo: leagueId)
          .orderBy('timestamp', descending: true);

      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final checkIns = snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();

      return _enrichCheckIns(checkIns);
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get league activity feed: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<List<ActivityFeedEntry>> watchFeedForUser(
    String userId, {
    int limit = 20,
  }) {
    // Watch leagues for user first, then watch check-ins from those leagues
    return _leagueRepository
        .watchLeaguesForUser(userId)
        .asyncExpand((leagues) {
      if (leagues.isEmpty) {
        return Stream.value(<ActivityFeedEntry>[]);
      }

      // Cache league names
      for (final league in leagues) {
        _leagueNameCache[league.id] = league.name;
      }

      // Take only first 10 leagues (Firestore whereIn limit)
      // Sort by createdAt descending to prioritize recent leagues
      final sortedLeagues = List.of(leagues)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final leagueIds = sortedLeagues
          .take(_maxLeaguesPerQuery)
          .map((l) => l.id)
          .toList();

      return _watchCheckInsForLeagues(leagueIds, limit);
    }).handleErrorWithSentry(
      context: {'operation': 'watchFeed', 'userId': userId},
      onError: (error, stackTrace) {
        if (error is FirebaseException) {
          throw FirestoreException(
            message: 'Failed to watch activity feed: ${error.message}',
            code: error.code,
            originalError: error,
            stackTrace: stackTrace,
          );
        }
        throw error;
      },
    );
  }

  Stream<List<ActivityFeedEntry>> _watchCheckInsForLeagues(
    List<String> leagueIds,
    int limit,
  ) {
    return _checkInsRef
        .where('leagueId', whereIn: leagueIds)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      final checkIns = snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
      return _enrichCheckIns(checkIns);
    });
  }

  @override
  Stream<List<ActivityFeedEntry>> watchFeedForLeague(
    String leagueId, {
    int limit = 20,
  }) {
    // First fetch league info to cache the name
    _leagueRepository.getLeagueById(leagueId).then((league) {
      if (league != null) {
        _leagueNameCache[leagueId] = league.name;
      }
    });

    return _checkInsRef
        .where('leagueId', isEqualTo: leagueId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      final checkIns = snapshot.docs
          .map((doc) => CheckInModel.fromFirestore(doc).toEntity())
          .toList();
      return _enrichCheckIns(checkIns);
    }).handleErrorWithSentry(
      context: {'operation': 'watchFeedForLeague', 'leagueId': leagueId},
      onError: (error, stackTrace) {
        if (error is FirebaseException) {
          throw FirestoreException(
            message: 'Failed to watch league activity feed: ${error.message}',
            code: error.code,
            originalError: error,
            stackTrace: stackTrace,
          );
        }
        throw error;
      },
    );
  }

  /// Enriches check-ins with user and league data
  Future<List<ActivityFeedEntry>> _enrichCheckIns(
    List<CheckInEntity> checkIns,
  ) async {
    if (checkIns.isEmpty) {
      return [];
    }

    final entries = <ActivityFeedEntry>[];

    for (final checkIn in checkIns) {
      final userInfo = await _getUserInfo(checkIn.userId);
      final leagueName = await _getLeagueName(checkIn.leagueId);

      entries.add(ActivityFeedEntry(
        checkIn: checkIn,
        userName: userInfo.displayName,
        userPhotoURL: userInfo.photoURL,
        leagueName: leagueName,
      ));
    }

    return entries;
  }

  /// Gets user display info from cache or fetches from repository
  Future<_UserCacheEntry> _getUserInfo(String userId) async {
    final cached = _userCache[userId];
    if (cached != null && !cached.isExpired) {
      return cached;
    }

    try {
      final user = await _userRepository.getUserById(userId);
      final entry = _UserCacheEntry(
        displayName: user?.displayNameOrEmail ?? 'Usuario',
        photoURL: user?.photoURL,
        fetchedAt: DateTime.now(),
      );
      _userCache[userId] = entry;
      return entry;
    } catch (_) {
      // Return fallback on error
      return _UserCacheEntry(
        displayName: 'Usuario',
        photoURL: null,
        fetchedAt: DateTime.now(),
      );
    }
  }

  /// Gets league name from cache or fetches from repository
  Future<String> _getLeagueName(String leagueId) async {
    final cached = _leagueNameCache[leagueId];
    if (cached != null) {
      return cached;
    }

    try {
      final league = await _leagueRepository.getLeagueById(leagueId);
      final name = league?.name ?? 'Liga';
      _leagueNameCache[leagueId] = name;
      return name;
    } catch (_) {
      return 'Liga';
    }
  }
}

/// Cache entry for user display information
class _UserCacheEntry {
  final String displayName;
  final String? photoURL;
  final DateTime fetchedAt;

  _UserCacheEntry({
    required this.displayName,
    this.photoURL,
    required this.fetchedAt,
  });

  bool get isExpired =>
      DateTime.now().difference(fetchedAt) >
      ActivityFeedRepositoryImpl._cacheDuration;
}
