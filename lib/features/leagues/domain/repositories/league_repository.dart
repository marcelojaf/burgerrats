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
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if user is not a member or is the owner
  Future<void> removeMember({
    required String leagueId,
    required String userId,
  });

  /// Updates a member's role in a league
  ///
  /// Throws [FirestoreException] on failure
  /// Throws [BusinessException] if user is not a member or changing owner role
  Future<void> updateMemberRole({
    required String leagueId,
    required String userId,
    required LeagueMemberRole newRole,
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
  /// Only admins/owners should be able to do this.
  /// Returns the new invite code.
  /// Throws [FirestoreException] on failure
  Future<String> regenerateInviteCode(String leagueId);
}
