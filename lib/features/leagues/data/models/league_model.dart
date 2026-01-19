import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/league_entity.dart';

/// Data model for LeagueSettings with Firestore serialization
///
/// Extends the domain entity with JSON/Firestore conversion capabilities.
class LeagueSettingsModel extends LeagueSettings {
  const LeagueSettingsModel({
    super.isPublic,
    super.maxMembers,
    super.pointsPerCheckIn,
    super.pointsPerReview,
    super.allowMemberInvites,
    super.requireApproval,
  });

  /// Creates a model from a domain entity
  factory LeagueSettingsModel.fromEntity(LeagueSettings entity) {
    return LeagueSettingsModel(
      isPublic: entity.isPublic,
      maxMembers: entity.maxMembers,
      pointsPerCheckIn: entity.pointsPerCheckIn,
      pointsPerReview: entity.pointsPerReview,
      allowMemberInvites: entity.allowMemberInvites,
      requireApproval: entity.requireApproval,
    );
  }

  /// Creates a model from JSON/Firestore data
  factory LeagueSettingsModel.fromJson(Json json) {
    return LeagueSettingsModel(
      isPublic: json['isPublic'] as bool? ?? false,
      maxMembers: json['maxMembers'] as int? ?? 50,
      pointsPerCheckIn: json['pointsPerCheckIn'] as int? ?? 10,
      pointsPerReview: json['pointsPerReview'] as int? ?? 5,
      allowMemberInvites: json['allowMemberInvites'] as bool? ?? true,
      requireApproval: json['requireApproval'] as bool? ?? false,
    );
  }

  /// Creates default settings model
  factory LeagueSettingsModel.defaults() {
    return const LeagueSettingsModel();
  }

  /// Converts to JSON for Firestore storage
  Json toJson() {
    return {
      'isPublic': isPublic,
      'maxMembers': maxMembers,
      'pointsPerCheckIn': pointsPerCheckIn,
      'pointsPerReview': pointsPerReview,
      'allowMemberInvites': allowMemberInvites,
      'requireApproval': requireApproval,
    };
  }

  /// Converts to domain entity
  LeagueSettings toEntity() {
    return LeagueSettings(
      isPublic: isPublic,
      maxMembers: maxMembers,
      pointsPerCheckIn: pointsPerCheckIn,
      pointsPerReview: pointsPerReview,
      allowMemberInvites: allowMemberInvites,
      requireApproval: requireApproval,
    );
  }
}

/// Data model for LeagueMember with Firestore serialization
///
/// Extends the domain entity with JSON/Firestore conversion capabilities.
class LeagueMemberModel extends LeagueMember {
  const LeagueMemberModel({
    required super.userId,
    required super.role,
    super.points,
    required super.joinedAt,
  });

  /// Creates a model from a domain entity
  factory LeagueMemberModel.fromEntity(LeagueMember entity) {
    return LeagueMemberModel(
      userId: entity.userId,
      role: entity.role,
      points: entity.points,
      joinedAt: entity.joinedAt,
    );
  }

  /// Creates a model from JSON/Firestore data
  factory LeagueMemberModel.fromJson(Json json) {
    // Parse role from string
    final roleString = json['role'] as String? ?? 'member';
    final role = LeagueMemberRole.values.firstWhere(
      (r) => r.name == roleString,
      orElse: () => LeagueMemberRole.member,
    );

    // Handle Firestore Timestamp conversion
    DateTime joinedAt;
    final joinedAtValue = json['joinedAt'];
    if (joinedAtValue is Timestamp) {
      joinedAt = joinedAtValue.toDate();
    } else if (joinedAtValue is String) {
      joinedAt = DateTime.parse(joinedAtValue);
    } else if (joinedAtValue is int) {
      joinedAt = DateTime.fromMillisecondsSinceEpoch(joinedAtValue);
    } else {
      joinedAt = DateTime.now();
    }

    return LeagueMemberModel(
      userId: json['userId'] as String,
      role: role,
      points: json['points'] as int? ?? 0,
      joinedAt: joinedAt,
    );
  }

  /// Creates a new member model with defaults
  factory LeagueMemberModel.newMember({
    required String userId,
    LeagueMemberRole role = LeagueMemberRole.member,
  }) {
    return LeagueMemberModel(
      userId: userId,
      role: role,
      points: 0,
      joinedAt: DateTime.now(),
    );
  }

  /// Converts to JSON for Firestore storage
  Json toJson() {
    return {
      'userId': userId,
      'role': role.name,
      'points': points,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }

  /// Converts to domain entity
  LeagueMember toEntity() {
    return LeagueMember(
      userId: userId,
      role: role,
      points: points,
      joinedAt: joinedAt,
    );
  }
}

/// Data model for League with Firestore serialization
///
/// Handles conversion between:
/// - Firestore documents
/// - Domain LeagueEntity
class LeagueModel extends LeagueEntity {
  const LeagueModel({
    required super.id,
    required super.name,
    super.description,
    required super.createdBy,
    required super.members,
    required super.inviteCode,
    required super.createdAt,
    super.settings,
  });

  /// Creates a model from a domain entity
  factory LeagueModel.fromEntity(LeagueEntity entity) {
    return LeagueModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdBy: entity.createdBy,
      members: entity.members,
      inviteCode: entity.inviteCode,
      createdAt: entity.createdAt,
      settings: entity.settings,
    );
  }

  /// Creates a model from Firestore document data
  factory LeagueModel.fromFirestore(DocumentSnapshot<Json> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Document data is null for league ${doc.id}');
    }
    return LeagueModel.fromJson(data, doc.id);
  }

  /// Creates a model from JSON/Firestore data
  factory LeagueModel.fromJson(Json json, [String? id]) {
    // Handle Firestore Timestamp conversion
    DateTime createdAt;
    final createdAtValue = json['createdAt'];
    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      createdAt = DateTime.parse(createdAtValue);
    } else if (createdAtValue is int) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);
    } else {
      createdAt = DateTime.now();
    }

    // Parse members list
    final membersList = <LeagueMember>[];
    final membersJson = json['members'] as List<dynamic>?;
    if (membersJson != null) {
      for (final memberJson in membersJson) {
        if (memberJson is Map<String, dynamic>) {
          membersList.add(LeagueMemberModel.fromJson(memberJson));
        }
      }
    }

    // Parse settings
    LeagueSettings settings;
    final settingsJson = json['settings'] as Json?;
    if (settingsJson != null) {
      settings = LeagueSettingsModel.fromJson(settingsJson);
    } else {
      settings = const LeagueSettings.defaults();
    }

    return LeagueModel(
      id: id ?? json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String,
      members: membersList,
      inviteCode: json['inviteCode'] as String,
      createdAt: createdAt,
      settings: settings,
    );
  }

  /// Creates a new league model for initial Firestore storage
  ///
  /// Used when creating a new league to initialize its document.
  factory LeagueModel.newLeague({
    required String id,
    required String name,
    String? description,
    required String createdBy,
    required String inviteCode,
    LeagueSettings? settings,
  }) {
    final ownerMember = LeagueMemberModel.newMember(
      userId: createdBy,
      role: LeagueMemberRole.owner,
    );

    return LeagueModel(
      id: id,
      name: name,
      description: description,
      createdBy: createdBy,
      members: [ownerMember],
      inviteCode: inviteCode,
      createdAt: DateTime.now(),
      settings: settings ?? const LeagueSettings.defaults(),
    );
  }

  /// Converts to JSON for Firestore storage
  ///
  /// Stores createdAt as Firestore Timestamp for proper date handling.
  Json toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'members': members
          .map((m) => LeagueMemberModel.fromEntity(m).toJson())
          .toList(),
      'inviteCode': inviteCode,
      'createdAt': Timestamp.fromDate(createdAt),
      'settings': LeagueSettingsModel.fromEntity(settings).toJson(),
    };
  }

  /// Converts to JSON for Firestore update (excludes id and createdAt)
  ///
  /// Used when updating league data without overwriting immutable fields.
  Json toJsonForUpdate() {
    return {
      'name': name,
      'description': description,
      'members': members
          .map((m) => LeagueMemberModel.fromEntity(m).toJson())
          .toList(),
      'settings': LeagueSettingsModel.fromEntity(settings).toJson(),
    };
  }

  /// Converts to domain entity
  LeagueEntity toEntity() {
    return LeagueEntity(
      id: id,
      name: name,
      description: description,
      createdBy: createdBy,
      members: members.map((m) {
        if (m is LeagueMemberModel) {
          return m.toEntity();
        }
        return m;
      }).toList(),
      inviteCode: inviteCode,
      createdAt: createdAt,
      settings: settings is LeagueSettingsModel
          ? (settings as LeagueSettingsModel).toEntity()
          : settings,
    );
  }

  @override
  LeagueModel copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    List<LeagueMember>? members,
    String? inviteCode,
    DateTime? createdAt,
    LeagueSettings? settings,
  }) {
    return LeagueModel(
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
}
