import 'package:flutter/foundation.dart';

/// Represents a member's role within a league
enum LeagueMemberRole {
  /// Regular member with basic privileges
  member,

  /// Administrator with management privileges
  admin,

  /// Owner/creator with full control
  owner,
}

/// Settings for a league that control its behavior
///
/// Includes visibility, scoring rules, and membership limits.
@immutable
class LeagueSettings {
  /// Whether the league is publicly visible
  final bool isPublic;

  /// Maximum number of members allowed
  final int maxMembers;

  /// Points awarded per check-in
  final int pointsPerCheckIn;

  /// Points awarded per review
  final int pointsPerReview;

  /// Whether to allow members to invite others
  final bool allowMemberInvites;

  /// Whether to require approval for new members
  final bool requireApproval;

  const LeagueSettings({
    this.isPublic = false,
    this.maxMembers = 50,
    this.pointsPerCheckIn = 10,
    this.pointsPerReview = 5,
    this.allowMemberInvites = true,
    this.requireApproval = false,
  });

  /// Creates default settings for a new league
  const LeagueSettings.defaults()
      : isPublic = false,
        maxMembers = 50,
        pointsPerCheckIn = 10,
        pointsPerReview = 5,
        allowMemberInvites = true,
        requireApproval = false;

  /// Creates a copy with updated fields
  LeagueSettings copyWith({
    bool? isPublic,
    int? maxMembers,
    int? pointsPerCheckIn,
    int? pointsPerReview,
    bool? allowMemberInvites,
    bool? requireApproval,
  }) {
    return LeagueSettings(
      isPublic: isPublic ?? this.isPublic,
      maxMembers: maxMembers ?? this.maxMembers,
      pointsPerCheckIn: pointsPerCheckIn ?? this.pointsPerCheckIn,
      pointsPerReview: pointsPerReview ?? this.pointsPerReview,
      allowMemberInvites: allowMemberInvites ?? this.allowMemberInvites,
      requireApproval: requireApproval ?? this.requireApproval,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeagueSettings &&
        other.isPublic == isPublic &&
        other.maxMembers == maxMembers &&
        other.pointsPerCheckIn == pointsPerCheckIn &&
        other.pointsPerReview == pointsPerReview &&
        other.allowMemberInvites == allowMemberInvites &&
        other.requireApproval == requireApproval;
  }

  @override
  int get hashCode => Object.hash(
        isPublic,
        maxMembers,
        pointsPerCheckIn,
        pointsPerReview,
        allowMemberInvites,
        requireApproval,
      );

  @override
  String toString() {
    return 'LeagueSettings(isPublic: $isPublic, maxMembers: $maxMembers, '
        'pointsPerCheckIn: $pointsPerCheckIn, pointsPerReview: $pointsPerReview, '
        'allowMemberInvites: $allowMemberInvites, requireApproval: $requireApproval)';
  }
}

/// Represents a member within a league
///
/// Contains the member's user reference, role, and league-specific stats.
@immutable
class LeagueMember {
  /// User ID of the member
  final String userId;

  /// Member's role in the league
  final LeagueMemberRole role;

  /// Points earned in this league
  final int points;

  /// When the user joined the league
  final DateTime joinedAt;

  const LeagueMember({
    required this.userId,
    required this.role,
    this.points = 0,
    required this.joinedAt,
  });

  /// Creates a new member with default values
  factory LeagueMember.newMember({
    required String userId,
    LeagueMemberRole role = LeagueMemberRole.member,
  }) {
    return LeagueMember(
      userId: userId,
      role: role,
      points: 0,
      joinedAt: DateTime.now(),
    );
  }

  /// Whether this member is an admin or owner
  bool get isAdmin => role == LeagueMemberRole.admin || role == LeagueMemberRole.owner;

  /// Whether this member is the owner
  bool get isOwner => role == LeagueMemberRole.owner;

  /// Creates a copy with updated fields
  LeagueMember copyWith({
    String? userId,
    LeagueMemberRole? role,
    int? points,
    DateTime? joinedAt,
  }) {
    return LeagueMember(
      userId: userId ?? this.userId,
      role: role ?? this.role,
      points: points ?? this.points,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeagueMember &&
        other.userId == userId &&
        other.role == role &&
        other.points == points &&
        other.joinedAt == joinedAt;
  }

  @override
  int get hashCode => Object.hash(userId, role, points, joinedAt);

  @override
  String toString() {
    return 'LeagueMember(userId: $userId, role: $role, points: $points, joinedAt: $joinedAt)';
  }
}

/// Domain entity representing a league in the BurgerRats app
///
/// Leagues are groups where users can compete and track their burger adventures.
@immutable
class LeagueEntity {
  /// Unique identifier for the league
  final String id;

  /// Display name of the league
  final String name;

  /// Description of the league
  final String? description;

  /// User ID of the league creator
  final String createdBy;

  /// List of league members
  final List<LeagueMember> members;

  /// Invite code for joining the league
  final String inviteCode;

  /// When the league was created
  final DateTime createdAt;

  /// League configuration settings
  final LeagueSettings settings;

  const LeagueEntity({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    required this.members,
    required this.inviteCode,
    required this.createdAt,
    this.settings = const LeagueSettings.defaults(),
  });

  /// Number of members in the league
  int get memberCount => members.length;

  /// Whether the league has reached its member limit
  bool get isFull => memberCount >= settings.maxMembers;

  /// Whether the league is open for new members
  bool get canJoin => !isFull;

  /// Gets a member by user ID
  LeagueMember? getMember(String userId) {
    try {
      return members.firstWhere((m) => m.userId == userId);
    } catch (_) {
      return null;
    }
  }

  /// Checks if a user is a member of this league
  bool isMember(String userId) => getMember(userId) != null;

  /// Checks if a user is an admin of this league
  bool isAdmin(String userId) {
    final member = getMember(userId);
    return member?.isAdmin ?? false;
  }

  /// Checks if a user is the owner of this league
  bool isOwner(String userId) => createdBy == userId;

  /// Gets members sorted by points (descending)
  List<LeagueMember> get leaderboard {
    final sorted = List<LeagueMember>.from(members);
    sorted.sort((a, b) => b.points.compareTo(a.points));
    return sorted;
  }

  /// Creates a copy with updated fields
  LeagueEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    List<LeagueMember>? members,
    String? inviteCode,
    DateTime? createdAt,
    LeagueSettings? settings,
  }) {
    return LeagueEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeagueEntity &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdBy == createdBy &&
        listEquals(other.members, members) &&
        other.inviteCode == inviteCode &&
        other.createdAt == createdAt &&
        other.settings == settings;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        createdBy,
        Object.hashAll(members),
        inviteCode,
        createdAt,
        settings,
      );

  @override
  String toString() {
    return 'LeagueEntity(id: $id, name: $name, description: $description, '
        'createdBy: $createdBy, memberCount: $memberCount, '
        'inviteCode: $inviteCode, createdAt: $createdAt, settings: $settings)';
  }
}
