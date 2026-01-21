import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/invite_code_generator_service.dart';
import '../../../../core/services/sentry_performance_wrapper.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/league_entity.dart';
import '../../domain/repositories/league_repository.dart';
import '../models/league_model.dart';

/// Implementation of [LeagueRepository] using Cloud Firestore
///
/// This class is registered as a lazy singleton with injectable,
/// meaning it will be created when first accessed and reused thereafter.
@LazySingleton(as: LeagueRepository)
class LeagueRepositoryImpl implements LeagueRepository {
  final FirebaseFirestore _firestore;
  final InviteCodeGeneratorService _inviteCodeService;

  /// Collection reference for leagues
  static const String _leaguesCollection = 'leagues';

  LeagueRepositoryImpl(this._firestore, this._inviteCodeService);

  /// Gets the leagues collection reference
  CollectionReference<Json> get _leaguesRef =>
      _firestore.collection(_leaguesCollection);

  /// Gets a document reference for a specific league
  DocumentReference<Json> _leagueDoc(String leagueId) =>
      _leaguesRef.doc(leagueId);

  @override
  Future<LeagueEntity> createLeague({
    required String name,
    String? description,
    required String createdBy,
    LeagueSettings? settings,
  }) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'createLeague',
      collection: _leaguesCollection,
      action: () async {
        try {
          // Generate unique ID
          final docRef = _leaguesRef.doc();

          // Generate unique invite code with Firestore validation
          final inviteCodeResult = await _inviteCodeService.generateUniqueCode();
          final inviteCode = inviteCodeResult.code;

          // Create the league model
          final league = LeagueModel.newLeague(
            id: docRef.id,
            name: name,
            description: description,
            createdBy: createdBy,
            inviteCode: inviteCode,
            settings: settings,
          );

          // Save to Firestore
          await docRef.set(league.toJson());

          return league.toEntity();
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to create league: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
      extraData: {
        'createdBy': createdBy,
      },
    );
  }

  @override
  Future<LeagueEntity?> getLeagueById(String leagueId) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'getLeagueById',
      collection: _leaguesCollection,
      documentId: leagueId,
      action: () async {
        try {
          final doc = await _leagueDoc(leagueId).get();
          if (!doc.exists || doc.data() == null) {
            return null;
          }
          return LeagueModel.fromFirestore(doc).toEntity();
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to get league: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }

  @override
  Future<LeagueEntity?> getLeagueByInviteCode(String inviteCode) async {
    return SentryPerformanceWrapper.traceFirestoreQuery(
      operation: 'getLeagueByInviteCode',
      collection: _leaguesCollection,
      queryDescription: 'Query by inviteCode',
      action: () async {
        try {
          final querySnapshot = await _leaguesRef
              .where('inviteCode', isEqualTo: inviteCode.toUpperCase())
              .limit(1)
              .get();

          if (querySnapshot.docs.isEmpty) {
            return null;
          }

          return LeagueModel.fromFirestore(querySnapshot.docs.first).toEntity();
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to get league by invite code: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }

  @override
  Future<void> updateLeague(LeagueEntity league) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'updateLeague',
      collection: _leaguesCollection,
      documentId: league.id,
      action: () async {
        try {
          final leagueModel = LeagueModel.fromEntity(league);
          await _leagueDoc(league.id).update(leagueModel.toJsonForUpdate());
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to update league: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }

  @override
  Future<void> deleteLeague(String leagueId) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'deleteLeague',
      collection: _leaguesCollection,
      documentId: leagueId,
      action: () async {
        try {
          await _leagueDoc(leagueId).delete();
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to delete league: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }

  @override
  Future<List<LeagueEntity>> getLeaguesForUser(String userId) async {
    return SentryPerformanceWrapper.traceFirestoreQuery(
      operation: 'getLeaguesForUser',
      collection: _leaguesCollection,
      queryDescription: 'Get all leagues filtered by user membership',
      action: () async {
        try {
          // Firestore can't deeply query array fields with nested objects,
          // so we query all leagues and filter client-side
          final allLeagues = await _leaguesRef.get();

          return allLeagues.docs
              .map((doc) => LeagueModel.fromFirestore(doc))
              .where((league) => league.isMember(userId))
              .map((league) => league.toEntity())
              .toList();
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to get leagues for user: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
      extraData: {
        'userId': userId,
      },
    );
  }

  @override
  Future<List<LeagueEntity>> getPublicLeagues() async {
    return SentryPerformanceWrapper.traceFirestoreQuery(
      operation: 'getPublicLeagues',
      collection: _leaguesCollection,
      queryDescription: 'Query public leagues',
      action: () async {
        try {
          final querySnapshot = await _leaguesRef
              .where('settings.isPublic', isEqualTo: true)
              .get();

          return querySnapshot.docs
              .map((doc) => LeagueModel.fromFirestore(doc).toEntity())
              .toList();
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to get public leagues: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }

  @override
  Stream<LeagueEntity?> watchLeague(String leagueId) {
    return _leagueDoc(leagueId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return LeagueModel.fromFirestore(doc).toEntity();
    }).handleErrorWithSentry(
      context: {'operation': 'watchLeague', 'leagueId': leagueId},
      onError: (error, stackTrace) {
        if (error is FirebaseException) {
          throw FirestoreException(
            message: 'Failed to watch league: ${error.message}',
            code: error.code,
            originalError: error,
            stackTrace: stackTrace,
          );
        }
        throw error;
      },
    );
  }

  @override
  Stream<List<LeagueEntity>> watchLeaguesForUser(String userId) {
    return _leaguesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => LeagueModel.fromFirestore(doc))
          .where((league) => league.isMember(userId))
          .map((league) => league.toEntity())
          .toList();
    }).handleErrorWithSentry(
      context: {'operation': 'watchLeaguesForUser', 'userId': userId},
      onError: (error, stackTrace) {
        if (error is FirebaseException) {
          throw FirestoreException(
            message: 'Failed to watch leagues for user: ${error.message}',
            code: error.code,
            originalError: error,
            stackTrace: stackTrace,
          );
        }
        throw error;
      },
    );
  }

  @override
  Future<void> addMember({
    required String leagueId,
    required String userId,
    LeagueMemberRole role = LeagueMemberRole.member,
  }) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'addMember',
      collection: _leaguesCollection,
      documentId: leagueId,
      action: () async {
        try {
          final league = await getLeagueById(leagueId);
          if (league == null) {
            throw const BusinessException(
              message: 'League not found',
              code: 'league-not-found',
            );
          }

          if (league.isMember(userId)) {
            throw const BusinessException(
              message: 'User is already a member of this league',
              code: 'already-member',
            );
          }

          if (league.isFull) {
            throw const BusinessException(
              message: 'League has reached maximum member capacity',
              code: 'league-full',
            );
          }

          final newMember = LeagueMemberModel.newMember(
            userId: userId,
            role: role,
          );

          final updatedMembers = [...league.members, newMember];
          final updatedLeague = league.copyWith(members: updatedMembers);

          await updateLeague(updatedLeague);
        } on FirestoreException {
          rethrow;
        } on BusinessException {
          rethrow;
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to add member: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
      extraData: {
        'userId': userId,
        'role': role.name,
      },
    );
  }

  @override
  Future<void> removeMember({
    required String leagueId,
    required String userId,
    required String requesterId,
  }) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'removeMember',
      collection: _leaguesCollection,
      documentId: leagueId,
      action: () async {
        try {
          final league = await getLeagueById(leagueId);
          if (league == null) {
            throw const BusinessException(
              message: 'League not found',
              code: 'league-not-found',
            );
          }

          final member = league.getMember(userId);
          if (member == null) {
            throw const BusinessException(
              message: 'User is not a member of this league',
              code: 'not-member',
            );
          }

          if (member.isOwner) {
            throw const BusinessException(
              message: 'Cannot remove the owner of the league',
              code: 'cannot-remove-owner',
            );
          }

          // Check permissions: either removing yourself (leaving) or admin removing a member
          final isRemovingSelf = requesterId == userId;
          final isRequesterAdmin = league.isAdmin(requesterId);

          if (!isRemovingSelf && !isRequesterAdmin) {
            throw const PermissionException(
              message: 'Only admins can remove other members',
              code: 'permission-denied',
              permissionType: 'admin',
            );
          }

          final updatedMembers =
              league.members.where((m) => m.userId != userId).toList();
          final updatedLeague = league.copyWith(members: updatedMembers);

          await updateLeague(updatedLeague);
        } on FirestoreException {
          rethrow;
        } on BusinessException {
          rethrow;
        } on PermissionException {
          rethrow;
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to remove member: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
      extraData: {
        'userId': userId,
        'requesterId': requesterId,
      },
    );
  }

  @override
  Future<void> updateMemberRole({
    required String leagueId,
    required String userId,
    required LeagueMemberRole newRole,
    required String requesterId,
  }) async {
    try {
      final league = await getLeagueById(leagueId);
      if (league == null) {
        throw const BusinessException(
          message: 'League not found',
          code: 'league-not-found',
        );
      }

      // Check permissions: only owner can promote/demote
      final isRequesterOwner = league.isOwner(requesterId);
      if (!isRequesterOwner) {
        throw const PermissionException(
          message: 'Only the owner can change member roles',
          code: 'permission-denied',
          permissionType: 'owner',
        );
      }

      final member = league.getMember(userId);
      if (member == null) {
        throw const BusinessException(
          message: 'User is not a member of this league',
          code: 'not-member',
        );
      }

      if (member.isOwner && newRole != LeagueMemberRole.owner) {
        throw const BusinessException(
          message: 'Cannot change the role of the league owner',
          code: 'cannot-change-owner-role',
        );
      }

      if (newRole == LeagueMemberRole.owner && !member.isOwner) {
        throw const BusinessException(
          message: 'Cannot promote member to owner. Use ownership transfer.',
          code: 'cannot-assign-owner',
        );
      }

      final updatedMembers = league.members.map((m) {
        if (m.userId == userId) {
          return m.copyWith(role: newRole);
        }
        return m;
      }).toList();

      final updatedLeague = league.copyWith(members: updatedMembers);
      await updateLeague(updatedLeague);
    } on FirestoreException {
      rethrow;
    } on BusinessException {
      rethrow;
    } on PermissionException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update member role: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> updateMemberPoints({
    required String leagueId,
    required String userId,
    required int points,
  }) async {
    try {
      final league = await getLeagueById(leagueId);
      if (league == null) {
        throw const BusinessException(
          message: 'League not found',
          code: 'league-not-found',
        );
      }

      final member = league.getMember(userId);
      if (member == null) {
        throw const BusinessException(
          message: 'User is not a member of this league',
          code: 'not-member',
        );
      }

      final updatedMembers = league.members.map((m) {
        if (m.userId == userId) {
          return m.copyWith(points: points);
        }
        return m;
      }).toList();

      final updatedLeague = league.copyWith(members: updatedMembers);
      await updateLeague(updatedLeague);
    } on FirestoreException {
      rethrow;
    } on BusinessException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update member points: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> addMemberPoints({
    required String leagueId,
    required String userId,
    required int pointsToAdd,
  }) async {
    try {
      final league = await getLeagueById(leagueId);
      if (league == null) {
        throw const BusinessException(
          message: 'League not found',
          code: 'league-not-found',
        );
      }

      final member = league.getMember(userId);
      if (member == null) {
        throw const BusinessException(
          message: 'User is not a member of this league',
          code: 'not-member',
        );
      }

      final newPoints = member.points + pointsToAdd;
      await updateMemberPoints(
        leagueId: leagueId,
        userId: userId,
        points: newPoints,
      );
    } on FirestoreException {
      rethrow;
    } on BusinessException {
      rethrow;
    }
  }

  @override
  Future<bool> isMember({
    required String leagueId,
    required String userId,
  }) async {
    try {
      final league = await getLeagueById(leagueId);
      if (league == null) {
        return false;
      }
      return league.isMember(userId);
    } on FirestoreException {
      rethrow;
    }
  }

  @override
  Future<List<LeagueMember>> getLeaderboard(String leagueId) async {
    try {
      final league = await getLeagueById(leagueId);
      if (league == null) {
        throw const BusinessException(
          message: 'League not found',
          code: 'league-not-found',
        );
      }
      return league.leaderboard;
    } on FirestoreException {
      rethrow;
    } on BusinessException {
      rethrow;
    }
  }

  @override
  Future<String> regenerateInviteCode({
    required String leagueId,
    required String requesterId,
  }) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'regenerateInviteCode',
      collection: _leaguesCollection,
      documentId: leagueId,
      action: () async {
        try {
          final league = await getLeagueById(leagueId);
          if (league == null) {
            throw const BusinessException(
              message: 'League not found',
              code: 'league-not-found',
            );
          }

          // Check permissions: only admins/owners can regenerate invite code
          final isRequesterAdmin = league.isAdmin(requesterId);
          if (!isRequesterAdmin) {
            throw const PermissionException(
              message: 'Only admins can regenerate the invite code',
              code: 'permission-denied',
              permissionType: 'admin',
            );
          }

          // Generate unique invite code with Firestore validation
          final inviteCodeResult = await _inviteCodeService.generateUniqueCode();
          final newInviteCode = inviteCodeResult.code;

          await _leagueDoc(leagueId).update({
            'inviteCode': newInviteCode,
          });

          return newInviteCode;
        } on BusinessException {
          rethrow;
        } on PermissionException {
          rethrow;
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to regenerate invite code: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
      extraData: {
        'requesterId': requesterId,
      },
    );
  }

  @override
  Future<void> transferOwnership({
    required String leagueId,
    required String newOwnerId,
    required String requesterId,
  }) async {
    return SentryPerformanceWrapper.traceFirestoreOperation(
      operation: 'transferOwnership',
      collection: _leaguesCollection,
      documentId: leagueId,
      action: () async {
        try {
          final league = await getLeagueById(leagueId);
          if (league == null) {
            throw const BusinessException(
              message: 'League not found',
              code: 'league-not-found',
            );
          }

          // Check permissions: only owner can transfer ownership
          final isRequesterOwner = league.isOwner(requesterId);
          if (!isRequesterOwner) {
            throw const PermissionException(
              message: 'Only the owner can transfer ownership',
              code: 'permission-denied',
              permissionType: 'owner',
            );
          }

          final newOwner = league.getMember(newOwnerId);
          if (newOwner == null) {
            throw const BusinessException(
              message: 'New owner must be a member of the league',
              code: 'not-member',
            );
          }

          if (newOwnerId == requesterId) {
            throw const BusinessException(
              message: 'You are already the owner',
              code: 'already-owner',
            );
          }

          // Update members: new owner becomes owner, old owner becomes admin
          final updatedMembers = league.members.map((m) {
            if (m.userId == newOwnerId) {
              return m.copyWith(role: LeagueMemberRole.owner);
            }
            if (m.userId == requesterId) {
              return m.copyWith(role: LeagueMemberRole.admin);
            }
            return m;
          }).toList();

          // Also update createdBy field to the new owner
          final updatedLeague = league.copyWith(
            members: updatedMembers,
            createdBy: newOwnerId,
          );
          await updateLeague(updatedLeague);
        } on FirestoreException {
          rethrow;
        } on BusinessException {
          rethrow;
        } on PermissionException {
          rethrow;
        } on FirebaseException catch (e, stackTrace) {
          throw FirestoreException(
            message: 'Failed to transfer ownership: ${e.message}',
            code: e.code,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
      },
      extraData: {
        'newOwnerId': newOwnerId,
        'requesterId': requesterId,
      },
    );
  }

  @override
  Future<void> updateLeagueSettings({
    required String leagueId,
    required LeagueSettings settings,
    required String requesterId,
  }) async {
    try {
      final league = await getLeagueById(leagueId);
      if (league == null) {
        throw const BusinessException(
          message: 'League not found',
          code: 'league-not-found',
        );
      }

      // Check permissions: only admins/owners can update settings
      final isRequesterAdmin = league.isAdmin(requesterId);
      if (!isRequesterAdmin) {
        throw const PermissionException(
          message: 'Only admins can update league settings',
          code: 'permission-denied',
          permissionType: 'admin',
        );
      }

      final updatedLeague = league.copyWith(settings: settings);
      await updateLeague(updatedLeague);
    } on FirestoreException {
      rethrow;
    } on BusinessException {
      rethrow;
    } on PermissionException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update league settings: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
