import '../entities/league_entity.dart';

/// Abstract repository for league CRUD operations in Firestore
///
/// This interface defines the contract for league management including
/// creation, updates, deletion, and member management with real-time updates.
abstract class LeagueRepository {
  /// Creates a new league in Firestore
  ///
  /// The league will be initialized with the creator as owner.
  /// A unique invite code is generated automatically.
  ///
  /// Throws [FirestoreException] on failure
  Future<LeagueEntity> createLeague({
    required String name,
    String? description,
    required String createdBy,
    LeagueSettings? settings,
  });

  /// Retrieves a league by its unique ID
  ///
  /// Returns the league entity if found, null if not found.
  /// Throws [FirestoreException] on failure
  Future<LeagueEntity?> getLeagueById(String leagueId);

  /// Retrieves a league by its invite code
  ///
  /// Returns the league entity if found, null if not found.
  /// Throws [FirestoreException] on failure
  Future<LeagueEntity?> getLeagueByInviteCode(String inviteCode);

  /// Updates an existing league's data
  ///
  /// Updates mutable fields (name, description, settings).
  /// Does not modify id, createdBy, inviteCode, or createdAt.
  ///
  /// Throws [FirestoreException] on failure
  Future<void> updateLeague(LeagueEntity league);

  /// Deletes a league from Firestore
  ///
  /// Throws [FirestoreException] on failure
  Future<void> deleteLeague(String leagueId);

  /// Gets all leagues for a specific user
  ///
  /// Returns leagues where the user is a member.
  /// Throws [FirestoreException] on failure
  Future<List<LeagueEntity>> getLeaguesForUser(String userId);

  /// Gets all public leagues
  ///
  /// Returns leagues where settings.isPublic is true.
  /// Throws [FirestoreException] on failure
  Future<List<LeagueEntity>> getPublicLeagues();

  /// Stream of league data changes for real-time updates
  ///
  /// Emits the current league data and subsequent changes.
  /// Emits null if the league doesn't exist.
  Stream<LeagueEntity?> watchLeague(String leagueId);

  /// Stream of leagues for a user with real-time updates
  ///
  /// Emits the current list of leagues and subsequent changes.
  Stream<List<LeagueEntity>> watchLeaguesForUser(String userId);

  /// Adds a new member to a league
  ///
  /// The member is added with the specified role (default: member).
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if league is full or user is already a member
  Future<void> addMember({
    required String leagueId,
    required String userId,
    LeagueMemberRole role = LeagueMemberRole.member,
  });

  /// Removes a member from a league
  ///
  /// Requires the [requesterId] to be an admin or owner of the league.
  /// A member can remove themselves (leave) without admin privileges.
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if user is not a member or is the owner
  /// Throws [PermissionException] if requester doesn't have permission
  Future<void> removeMember({
    required String leagueId,
    required String userId,
    required String requesterId,
  });

  /// Updates a member's role in a league
  ///
  /// Requires the [requesterId] to be the owner of the league.
  /// Only owners can promote/demote admins.
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if user is not a member or changing owner role
  /// Throws [PermissionException] if requester doesn't have permission
  Future<void> updateMemberRole({
    required String leagueId,
    required String userId,
    required LeagueMemberRole newRole,
    required String requesterId,
  });

  /// Updates a member's points in a league
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if user is not a member
  Future<void> updateMemberPoints({
    required String leagueId,
    required String userId,
    required int points,
  });

  /// Adds points to a member's total in a league
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if user is not a member
  Future<void> addMemberPoints({
    required String leagueId,
    required String userId,
    required int pointsToAdd,
  });

  /// Checks if a user is a member of a league
  ///
  /// Returns true if the user is a member, false otherwise.
  /// Throws [FirestoreException] on failure
  Future<bool> isMember({
    required String leagueId,
    required String userId,
  });

  /// Gets the leaderboard for a league
  ///
  /// Returns members sorted by points in descending order.
  /// Throws [FirestoreException] on failure
  Future<List<LeagueMember>> getLeaderboard(String leagueId);

  /// Regenerates the invite code for a league
  ///
  /// Requires the [requesterId] to be an admin or owner of the league.
  /// Returns the new invite code.
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [PermissionException] if requester doesn't have permission
  Future<String> regenerateInviteCode({
    required String leagueId,
    required String requesterId,
  });

  /// Transfers ownership of a league to another member
  ///
  /// Requires the [requesterId] to be the current owner of the league.
  /// The new owner must be an existing member of the league.
  /// The current owner becomes an admin after transfer.
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if new owner is not a member
  /// Throws [PermissionException] if requester is not the owner
  Future<void> transferOwnership({
    required String leagueId,
    required String newOwnerId,
    required String requesterId,
  });

  /// Updates league settings
  ///
  /// Requires the [requesterId] to be an admin or owner of the league.
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [PermissionException] if requester doesn't have permission
  Future<void> updateLeagueSettings({
    required String leagueId,
    required LeagueSettings settings,
    required String requesterId,
  });
}
