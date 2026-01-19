
🔧 Tool: Task
Input: {
  "description": "Explore codebase structure",
  "prompt": "Explore this Flutter codebase to understand:\n1. The project structure and organization\n2. Existing model patterns (look for any existing models)\n3. How Firestore serialization is handled\n4. Any existing patterns for data classes\n5. The dependency injection setup\n\nFocus on lib/ directory and look for patterns in models, data classes, and Firestore integration. Report back the findings with specific file paths and code patterns found.",
  "subagent_type": "Explore"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib -type f -name \"*.dart\" | head -30",
  "description": "List Dart files in lib directory"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib -type d | sort",
  "description": "List all directories in lib"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/**/*.dart",
  "path": "/Users/marcelo/dev/burgerrats"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/models/user_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/entities/user_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/firebase/firebase_config.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/register_module.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -name \"*_model.dart\" -o -name \"*_entity.dart\" | head -20",
  "description": "Find all model and entity files"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/utils/typedefs.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -path \"*/data/models*\" -type d",
  "description": "Find data models directories"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/home/data/models"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features/home -name \"*.dart\" -type f",
  "description": "Find all dart files in home feature"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/home/data/data.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/home/domain/domain.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/data.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/domain.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/repositories/auth_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/models/models.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_notifier.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/base_state.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -name \"*_repository*.dart\" | head -10",
  "description": "Find repository files"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart",
  "limit": 100
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -name \"*datasource*\" -o -name \"*data_source*\"",
  "description": "Find datasource files"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features/home/data/datasources -type f",
  "description": "List home datasource files"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/state.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/state/providers/auth_state_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/auth.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/auth/",
  "description": "List auth feature structure"
}
Now I have a comprehensive understanding of the codebase. Let me also check if there's already a league structure in place.

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/leagues/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/models/user_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/entities/user_entity.dart"
}
Let me check the existing leagues structure and the typedefs:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/leagues.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/utils/typedefs.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/leagues/",
  "description": "List leagues folder structure"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "pending",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "pending",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "pending",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "pending",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/leagues/domain/ /Users/marcelo/dev/burgerrats/lib/features/leagues/data/",
  "description": "List domain/data folders"
}
The domain and data folders are empty. Let me create the league model following the established patterns. I'll start with the domain entities:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "in_progress",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "pending",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "pending",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "pending",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "mkdir -p /Users/marcelo/dev/burgerrats/lib/features/leagues/domain/entities /Users/marcelo/dev/burgerrats/lib/features/leagues/data/models",
  "description": "Create entities and models folders"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/entities/league_entity.dart",
  "content": "import 'package:flutter/foundation.dart';\n\n/// Represents a member's role within a league\nenum LeagueMemberRole {\n  /// Regular member with basic privileges\n  member,\n\n  /// Administrator with management privileges\n  admin,\n\n  /// Owner/creator with full control\n  owner,\n}\n\n/// Settings for a league that control its behavior\n///\n/// Includes visibility, scoring rules, and membership limits.\n@immutable\nclass LeagueSettings {\n  /// Whether the league is publicly visible\n  final bool isPublic;\n\n  /// Maximum number of members allowed\n  final int maxMembers;\n\n  /// Points awarded per check-in\n  final int pointsPerCheckIn;\n\n  /// Points awarded per review\n  final int pointsPerReview;\n\n  /// Whether to allow members to invite others\n  final bool allowMemberInvites;\n\n  /// Whether to require approval for new members\n  final bool requireApproval;\n\n  const LeagueSettings({\n    this.isPublic = false,\n    this.maxMembers = 50,\n    this.pointsPerCheckIn = 10,\n    this.pointsPerReview = 5,\n    this.allowMemberInvites = true,\n    this.requireApproval = false,\n  });\n\n  /// Creates default settings for a new league\n  const LeagueSettings.defaults()\n      : isPublic = false,\n        maxMembers = 50,\n        pointsPerCheckIn = 10,\n        pointsPerReview = 5,\n        allowMemberInvites = true,\n        requireApproval = false;\n\n  /// Creates a copy with updated fields\n  LeagueSettings copyWith({\n    bool? isPublic,\n    int? maxMembers,\n    int? pointsPerCheckIn,\n    int? pointsPerReview,\n    bool? allowMemberInvites,\n    bool? requireApproval,\n  }) {\n    return LeagueSettings(\n      isPublic: isPublic ?? this.isPublic,\n      maxMembers: maxMembers ?? this.maxMembers,\n      pointsPerCheckIn: pointsPerCheckIn ?? this.pointsPerCheckIn,\n      pointsPerReview: pointsPerReview ?? this.pointsPerReview,\n      allowMemberInvites: allowMemberInvites ?? this.allowMemberInvites,\n      requireApproval: requireApproval ?? this.requireApproval,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is LeagueSettings &&\n        other.isPublic == isPublic &&\n        other.maxMembers == maxMembers &&\n        other.pointsPerCheckIn == pointsPerCheckIn &&\n        other.pointsPerReview == pointsPerReview &&\n        other.allowMemberInvites == allowMemberInvites &&\n        other.requireApproval == requireApproval;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        isPublic,\n        maxMembers,\n        pointsPerCheckIn,\n        pointsPerReview,\n        allowMemberInvites,\n        requireApproval,\n      );\n\n  @override\n  String toString() {\n    return 'LeagueSettings(isPublic: $isPublic, maxMembers: $maxMembers, '\n        'pointsPerCheckIn: $pointsPerCheckIn, pointsPerReview: $pointsPerReview, '\n        'allowMemberInvites: $allowMemberInvites, requireApproval: $requireApproval)';\n  }\n}\n\n/// Represents a member within a league\n///\n/// Contains the member's user reference, role, and league-specific stats.\n@immutable\nclass LeagueMember {\n  /// User ID of the member\n  final String userId;\n\n  /// Member's role in the league\n  final LeagueMemberRole role;\n\n  /// Points earned in this league\n  final int points;\n\n  /// When the user joined the league\n  final DateTime joinedAt;\n\n  const LeagueMember({\n    required this.userId,\n    required this.role,\n    this.points = 0,\n    required this.joinedAt,\n  });\n\n  /// Creates a new member with default values\n  factory LeagueMember.newMember({\n    required String userId,\n    LeagueMemberRole role = LeagueMemberRole.member,\n  }) {\n    return LeagueMember(\n      userId: userId,\n      role: role,\n      points: 0,\n      joinedAt: DateTime.now(),\n    );\n  }\n\n  /// Whether this member is an admin or owner\n  bool get isAdmin => role == LeagueMemberRole.admin || role == LeagueMemberRole.owner;\n\n  /// Whether this member is the owner\n  bool get isOwner => role == LeagueMemberRole.owner;\n\n  /// Creates a copy with updated fields\n  LeagueMember copyWith({\n    String? userId,\n    LeagueMemberRole? role,\n    int? points,\n    DateTime? joinedAt,\n  }) {\n    return LeagueMember(\n      userId: userId ?? this.userId,\n      role: role ?? this.role,\n      points: points ?? this.points,\n      joinedAt: joinedAt ?? this.joinedAt,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is LeagueMember &&\n        other.userId == userId &&\n        other.role == role &&\n        other.points == points &&\n        other.joinedAt == joinedAt;\n  }\n\n  @override\n  int get hashCode => Object.hash(userId, role, points, joinedAt);\n\n  @override\n  String toString() {\n    return 'LeagueMember(userId: $userId, role: $role, points: $points, joinedAt: $joinedAt)';\n  }\n}\n\n/// Domain entity representing a league in the BurgerRats app\n///\n/// Leagues are groups where users can compete and track their burger adventures.\n@immutable\nclass LeagueEntity {\n  /// Unique identifier for the league\n  final String id;\n\n  /// Display name of the league\n  final String name;\n\n  /// Description of the league\n  final String? description;\n\n  /// User ID of the league creator\n  final String createdBy;\n\n  /// List of league members\n  final List<LeagueMember> members;\n\n  /// Invite code for joining the league\n  final String inviteCode;\n\n  /// When the league was created\n  final DateTime createdAt;\n\n  /// League configuration settings\n  final LeagueSettings settings;\n\n  const LeagueEntity({\n    required this.id,\n    required this.name,\n    this.description,\n    required this.createdBy,\n    required this.members,\n    required this.inviteCode,\n    required this.createdAt,\n    this.settings = const LeagueSettings.defaults(),\n  });\n\n  /// Number of members in the league\n  int get memberCount => members.length;\n\n  /// Whether the league has reached its member limit\n  bool get isFull => memberCount >= settings.maxMembers;\n\n  /// Whether the league is open for new members\n  bool get canJoin => !isFull;\n\n  /// Gets a member by user ID\n  LeagueMember? getMember(String userId) {\n    try {\n      return members.firstWhere((m) => m.userId == userId);\n    } catch (_) {\n      return null;\n    }\n  }\n\n  /// Checks if a user is a member of this league\n  bool isMember(String userId) => getMember(userId) != null;\n\n  /// Checks if a user is an admin of this league\n  bool isAdmin(String userId) {\n    final member = getMember(userId);\n    return member?.isAdmin ?? false;\n  }\n\n  /// Checks if a user is the owner of this league\n  bool isOwner(String userId) => createdBy == userId;\n\n  /// Gets members sorted by points (descending)\n  List<LeagueMember> get leaderboard {\n    final sorted = List<LeagueMember>.from(members);\n    sorted.sort((a, b) => b.points.compareTo(a.points));\n    return sorted;\n  }\n\n  /// Creates a copy with updated fields\n  LeagueEntity copyWith({\n    String? id,\n    String? name,\n    String? description,\n    String? createdBy,\n    List<LeagueMember>? members,\n    String? inviteCode,\n    DateTime? createdAt,\n    LeagueSettings? settings,\n  }) {\n    return LeagueEntity(\n      id: id ?? this.id,\n      name: name ?? this.name,\n      description: description ?? this.description,\n      createdBy: createdBy ?? this.createdBy,\n      members: members ?? this.members,\n      inviteCode: inviteCode ?? this.inviteCode,\n      createdAt: createdAt ?? this.createdAt,\n      settings: settings ?? this.settings,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is LeagueEntity &&\n        other.id == id &&\n        other.name == name &&\n        other.description == description &&\n        other.createdBy == createdBy &&\n        listEquals(other.members, members) &&\n        other.inviteCode == inviteCode &&\n        other.createdAt == createdAt &&\n        other.settings == settings;\n  }\n\n  @override\n  int get hashCode => Object.hash(\n        id,\n        name,\n        description,\n        createdBy,\n        Object.hashAll(members),\n        inviteCode,\n        createdAt,\n        settings,\n      );\n\n  @override\n  String toString() {\n    return 'LeagueEntity(id: $id, name: $name, description: $description, '\n        'createdBy: $createdBy, memberCount: $memberCount, '\n        'inviteCode: $inviteCode, createdAt: $createdAt, settings: $settings)';\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "completed",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "in_progress",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "pending",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "pending",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
Now let me create the LeagueModel with Firestore serialization:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/models/league_model.dart",
  "content": "import 'package:cloud_firestore/cloud_firestore.dart';\n\nimport '../../../../core/utils/typedefs.dart';\nimport '../../domain/entities/league_entity.dart';\n\n/// Data model for LeagueSettings with Firestore serialization\n///\n/// Extends the domain entity with JSON/Firestore conversion capabilities.\nclass LeagueSettingsModel extends LeagueSettings {\n  const LeagueSettingsModel({\n    super.isPublic,\n    super.maxMembers,\n    super.pointsPerCheckIn,\n    super.pointsPerReview,\n    super.allowMemberInvites,\n    super.requireApproval,\n  });\n\n  /// Creates a model from a domain entity\n  factory LeagueSettingsModel.fromEntity(LeagueSettings entity) {\n    return LeagueSettingsModel(\n      isPublic: entity.isPublic,\n      maxMembers: entity.maxMembers,\n      pointsPerCheckIn: entity.pointsPerCheckIn,\n      pointsPerReview: entity.pointsPerReview,\n      allowMemberInvites: entity.allowMemberInvites,\n      requireApproval: entity.requireApproval,\n    );\n  }\n\n  /// Creates a model from JSON/Firestore data\n  factory LeagueSettingsModel.fromJson(Json json) {\n    return LeagueSettingsModel(\n      isPublic: json['isPublic'] as bool? ?? false,\n      maxMembers: json['maxMembers'] as int? ?? 50,\n      pointsPerCheckIn: json['pointsPerCheckIn'] as int? ?? 10,\n      pointsPerReview: json['pointsPerReview'] as int? ?? 5,\n      allowMemberInvites: json['allowMemberInvites'] as bool? ?? true,\n      requireApproval: json['requireApproval'] as bool? ?? false,\n    );\n  }\n\n  /// Creates default settings model\n  factory LeagueSettingsModel.defaults() {\n    return const LeagueSettingsModel();\n  }\n\n  /// Converts to JSON for Firestore storage\n  Json toJson() {\n    return {\n      'isPublic': isPublic,\n      'maxMembers': maxMembers,\n      'pointsPerCheckIn': pointsPerCheckIn,\n      'pointsPerReview': pointsPerReview,\n      'allowMemberInvites': allowMemberInvites,\n      'requireApproval': requireApproval,\n    };\n  }\n\n  /// Converts to domain entity\n  LeagueSettings toEntity() {\n    return LeagueSettings(\n      isPublic: isPublic,\n      maxMembers: maxMembers,\n      pointsPerCheckIn: pointsPerCheckIn,\n      pointsPerReview: pointsPerReview,\n      allowMemberInvites: allowMemberInvites,\n      requireApproval: requireApproval,\n    );\n  }\n}\n\n/// Data model for LeagueMember with Firestore serialization\n///\n/// Extends the domain entity with JSON/Firestore conversion capabilities.\nclass LeagueMemberModel extends LeagueMember {\n  const LeagueMemberModel({\n    required super.userId,\n    required super.role,\n    super.points,\n    required super.joinedAt,\n  });\n\n  /// Creates a model from a domain entity\n  factory LeagueMemberModel.fromEntity(LeagueMember entity) {\n    return LeagueMemberModel(\n      userId: entity.userId,\n      role: entity.role,\n      points: entity.points,\n      joinedAt: entity.joinedAt,\n    );\n  }\n\n  /// Creates a model from JSON/Firestore data\n  factory LeagueMemberModel.fromJson(Json json) {\n    // Parse role from string\n    final roleString = json['role'] as String? ?? 'member';\n    final role = LeagueMemberRole.values.firstWhere(\n      (r) => r.name == roleString,\n      orElse: () => LeagueMemberRole.member,\n    );\n\n    // Handle Firestore Timestamp conversion\n    DateTime joinedAt;\n    final joinedAtValue = json['joinedAt'];\n    if (joinedAtValue is Timestamp) {\n      joinedAt = joinedAtValue.toDate();\n    } else if (joinedAtValue is String) {\n      joinedAt = DateTime.parse(joinedAtValue);\n    } else if (joinedAtValue is int) {\n      joinedAt = DateTime.fromMillisecondsSinceEpoch(joinedAtValue);\n    } else {\n      joinedAt = DateTime.now();\n    }\n\n    return LeagueMemberModel(\n      userId: json['userId'] as String,\n      role: role,\n      points: json['points'] as int? ?? 0,\n      joinedAt: joinedAt,\n    );\n  }\n\n  /// Creates a new member model with defaults\n  factory LeagueMemberModel.newMember({\n    required String userId,\n    LeagueMemberRole role = LeagueMemberRole.member,\n  }) {\n    return LeagueMemberModel(\n      userId: userId,\n      role: role,\n      points: 0,\n      joinedAt: DateTime.now(),\n    );\n  }\n\n  /// Converts to JSON for Firestore storage\n  Json toJson() {\n    return {\n      'userId': userId,\n      'role': role.name,\n      'points': points,\n      'joinedAt': Timestamp.fromDate(joinedAt),\n    };\n  }\n\n  /// Converts to domain entity\n  LeagueMember toEntity() {\n    return LeagueMember(\n      userId: userId,\n      role: role,\n      points: points,\n      joinedAt: joinedAt,\n    );\n  }\n}\n\n/// Data model for League with Firestore serialization\n///\n/// Handles conversion between:\n/// - Firestore documents\n/// - Domain LeagueEntity\nclass LeagueModel extends LeagueEntity {\n  const LeagueModel({\n    required super.id,\n    required super.name,\n    super.description,\n    required super.createdBy,\n    required super.members,\n    required super.inviteCode,\n    required super.createdAt,\n    super.settings,\n  });\n\n  /// Creates a model from a domain entity\n  factory LeagueModel.fromEntity(LeagueEntity entity) {\n    return LeagueModel(\n      id: entity.id,\n      name: entity.name,\n      description: entity.description,\n      createdBy: entity.createdBy,\n      members: entity.members,\n      inviteCode: entity.inviteCode,\n      createdAt: entity.createdAt,\n      settings: entity.settings,\n    );\n  }\n\n  /// Creates a model from Firestore document data\n  factory LeagueModel.fromFirestore(DocumentSnapshot<Json> doc) {\n    final data = doc.data();\n    if (data == null) {\n      throw StateError('Document data is null for league ${doc.id}');\n    }\n    return LeagueModel.fromJson(data, doc.id);\n  }\n\n  /// Creates a model from JSON/Firestore data\n  factory LeagueModel.fromJson(Json json, [String? id]) {\n    // Handle Firestore Timestamp conversion\n    DateTime createdAt;\n    final createdAtValue = json['createdAt'];\n    if (createdAtValue is Timestamp) {\n      createdAt = createdAtValue.toDate();\n    } else if (createdAtValue is String) {\n      createdAt = DateTime.parse(createdAtValue);\n    } else if (createdAtValue is int) {\n      createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtValue);\n    } else {\n      createdAt = DateTime.now();\n    }\n\n    // Parse members list\n    final membersList = <LeagueMember>[];\n    final membersJson = json['members'] as List<dynamic>?;\n    if (membersJson != null) {\n      for (final memberJson in membersJson) {\n        if (memberJson is Map<String, dynamic>) {\n          membersList.add(LeagueMemberModel.fromJson(memberJson));\n        }\n      }\n    }\n\n    // Parse settings\n    LeagueSettings settings;\n    final settingsJson = json['settings'] as Json?;\n    if (settingsJson != null) {\n      settings = LeagueSettingsModel.fromJson(settingsJson);\n    } else {\n      settings = const LeagueSettings.defaults();\n    }\n\n    return LeagueModel(\n      id: id ?? json['id'] as String,\n      name: json['name'] as String,\n      description: json['description'] as String?,\n      createdBy: json['createdBy'] as String,\n      members: membersList,\n      inviteCode: json['inviteCode'] as String,\n      createdAt: createdAt,\n      settings: settings,\n    );\n  }\n\n  /// Creates a new league model for initial Firestore storage\n  ///\n  /// Used when creating a new league to initialize its document.\n  factory LeagueModel.newLeague({\n    required String id,\n    required String name,\n    String? description,\n    required String createdBy,\n    required String inviteCode,\n    LeagueSettings? settings,\n  }) {\n    final ownerMember = LeagueMemberModel.newMember(\n      userId: createdBy,\n      role: LeagueMemberRole.owner,\n    );\n\n    return LeagueModel(\n      id: id,\n      name: name,\n      description: description,\n      createdBy: createdBy,\n      members: [ownerMember],\n      inviteCode: inviteCode,\n      createdAt: DateTime.now(),\n      settings: settings ?? const LeagueSettings.defaults(),\n    );\n  }\n\n  /// Converts to JSON for Firestore storage\n  ///\n  /// Stores createdAt as Firestore Timestamp for proper date handling.\n  Json toJson() {\n    return {\n      'id': id,\n      'name': name,\n      'description': description,\n      'createdBy': createdBy,\n      'members': members\n          .map((m) => LeagueMemberModel.fromEntity(m).toJson())\n          .toList(),\n      'inviteCode': inviteCode,\n      'createdAt': Timestamp.fromDate(createdAt),\n      'settings': LeagueSettingsModel.fromEntity(settings).toJson(),\n    };\n  }\n\n  /// Converts to JSON for Firestore update (excludes id and createdAt)\n  ///\n  /// Used when updating league data without overwriting immutable fields.\n  Json toJsonForUpdate() {\n    return {\n      'name': name,\n      'description': description,\n      'members': members\n          .map((m) => LeagueMemberModel.fromEntity(m).toJson())\n          .toList(),\n      'settings': LeagueSettingsModel.fromEntity(settings).toJson(),\n    };\n  }\n\n  /// Converts to domain entity\n  LeagueEntity toEntity() {\n    return LeagueEntity(\n      id: id,\n      name: name,\n      description: description,\n      createdBy: createdBy,\n      members: members.map((m) {\n        if (m is LeagueMemberModel) {\n          return m.toEntity();\n        }\n        return m;\n      }).toList(),\n      inviteCode: inviteCode,\n      createdAt: createdAt,\n      settings: settings is LeagueSettingsModel\n          ? (settings as LeagueSettingsModel).toEntity()\n          : settings,\n    );\n  }\n\n  @override\n  LeagueModel copyWith({\n    String? id,\n    String? name,\n    String? description,\n    String? createdBy,\n    List<LeagueMember>? members,\n    String? inviteCode,\n    DateTime? createdAt,\n    LeagueSettings? settings,\n  }) {\n    return LeagueModel(\n      id: id ?? this.id,\n      name: name ?? this.name,\n      description: description ?? this.description,\n      createdBy: createdBy ?? this.createdBy,\n      members: members ?? this.members,\n      inviteCode: inviteCode ?? this.inviteCode,\n      createdAt: createdAt ?? this.createdAt,\n      settings: settings ?? this.settings,\n    );\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "completed",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "in_progress",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
Now let me create the barrel exports:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/entities/entities.dart",
  "content": "// Leagues domain entities barrel export\n\nexport 'league_entity.dart';\n"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/domain.dart",
  "content": "// Leagues domain layer barrel export\n\nexport 'entities/entities.dart';\n"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/models/models.dart",
  "content": "// Leagues data models barrel export\n\nexport 'league_model.dart';\n"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/data.dart",
  "content": "// Leagues data layer barrel export\n\nexport 'models/models.dart';\n"
}
Now update the main leagues barrel export:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/leagues.dart"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/leagues.dart",
  "old_string": "// Leagues feature barrel export\n\nexport 'presentation/presentation.dart';",
  "new_string": "// Leagues feature barrel export\n\nexport 'data/data.dart';\nexport 'domain/domain.dart';\nexport 'presentation/presentation.dart';"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "completed",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "completed",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Run flutter analyze to verify code",
      "status": "in_progress",
      "activeForm": "Running flutter analyze"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
Let me run Flutter analyze to verify the code compiles correctly:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/features/leagues/ 2>&1",
  "description": "Run flutter analyze on leagues",
  "timeout": 120000
}
The code compiles correctly. Now let me also run a broader analysis to ensure nothing is broken:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/ 2>&1 | head -50",
  "description": "Run flutter analyze on lib",
  "timeout": 180000
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "completed",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "completed",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Run flutter analyze to verify code",
      "status": "completed",
      "activeForm": "Running flutter analyze"
    },
    {
      "content": "Create unit test for league models",
      "status": "in_progress",
      "activeForm": "Creating unit test for league models"
    }
  ]
}
Now let me create a unit test to verify the implementation. Since this is a Flutter project and the task mentions Playwright, but Playwright is typically for web/mobile E2E testing, let me first check if there's an existing test infrastructure:

🔧 Tool: Glob
Input: {
  "pattern": "test/**/*.dart"
}

🔧 Tool: Bash
Input: {
  "command": "cat /Users/marcelo/dev/burgerrats/pubspec.yaml | grep -A5 \"dev_dependencies\"",
  "description": "Check dev dependencies"
}
Let me check an existing test to follow the pattern:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/auth/data/models/user_model_test.dart"
}
Now let me create a comprehensive test for the league models following the same pattern:

🔧 Tool: Bash
Input: {
  "command": "mkdir -p /Users/marcelo/dev/burgerrats/test/features/leagues/data/models /Users/marcelo/dev/burgerrats/test/features/leagues/domain/entities",
  "description": "Create test directories"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/models/league_model_test.dart",
  "content": "import 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/features/leagues/data/models/league_model.dart';\nimport 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';\n\nvoid main() {\n  group('LeagueSettingsModel', () {\n    test('should create from JSON', () {\n      final json = {\n        'isPublic': true,\n        'maxMembers': 100,\n        'pointsPerCheckIn': 20,\n        'pointsPerReview': 10,\n        'allowMemberInvites': false,\n        'requireApproval': true,\n      };\n\n      final settings = LeagueSettingsModel.fromJson(json);\n\n      expect(settings.isPublic, true);\n      expect(settings.maxMembers, 100);\n      expect(settings.pointsPerCheckIn, 20);\n      expect(settings.pointsPerReview, 10);\n      expect(settings.allowMemberInvites, false);\n      expect(settings.requireApproval, true);\n    });\n\n    test('should handle missing JSON fields with defaults', () {\n      final json = <String, dynamic>{};\n\n      final settings = LeagueSettingsModel.fromJson(json);\n\n      expect(settings.isPublic, false);\n      expect(settings.maxMembers, 50);\n      expect(settings.pointsPerCheckIn, 10);\n      expect(settings.pointsPerReview, 5);\n      expect(settings.allowMemberInvites, true);\n      expect(settings.requireApproval, false);\n    });\n\n    test('should convert to JSON', () {\n      const settings = LeagueSettingsModel(\n        isPublic: true,\n        maxMembers: 100,\n        pointsPerCheckIn: 20,\n        pointsPerReview: 10,\n        allowMemberInvites: false,\n        requireApproval: true,\n      );\n\n      final json = settings.toJson();\n\n      expect(json['isPublic'], true);\n      expect(json['maxMembers'], 100);\n      expect(json['pointsPerCheckIn'], 20);\n      expect(json['pointsPerReview'], 10);\n      expect(json['allowMemberInvites'], false);\n      expect(json['requireApproval'], true);\n    });\n\n    test('should create from entity', () {\n      const entity = LeagueSettings(\n        isPublic: true,\n        maxMembers: 75,\n      );\n\n      final model = LeagueSettingsModel.fromEntity(entity);\n\n      expect(model.isPublic, true);\n      expect(model.maxMembers, 75);\n    });\n\n    test('should convert to entity', () {\n      const model = LeagueSettingsModel(\n        isPublic: true,\n        maxMembers: 75,\n      );\n\n      final entity = model.toEntity();\n\n      expect(entity.isPublic, true);\n      expect(entity.maxMembers, 75);\n      expect(entity, isA<LeagueSettings>());\n    });\n\n    test('should create default settings', () {\n      final settings = LeagueSettingsModel.defaults();\n\n      expect(settings.isPublic, false);\n      expect(settings.maxMembers, 50);\n      expect(settings.pointsPerCheckIn, 10);\n      expect(settings.pointsPerReview, 5);\n      expect(settings.allowMemberInvites, true);\n      expect(settings.requireApproval, false);\n    });\n  });\n\n  group('LeagueMemberModel', () {\n    final joinedAt = DateTime(2024, 1, 15);\n    final timestamp = Timestamp.fromDate(joinedAt);\n\n    test('should create from JSON with Timestamp', () {\n      final json = {\n        'userId': 'user-123',\n        'role': 'admin',\n        'points': 150,\n        'joinedAt': timestamp,\n      };\n\n      final member = LeagueMemberModel.fromJson(json);\n\n      expect(member.userId, 'user-123');\n      expect(member.role, LeagueMemberRole.admin);\n      expect(member.points, 150);\n      expect(member.joinedAt, joinedAt);\n    });\n\n    test('should create from JSON with ISO string date', () {\n      final json = {\n        'userId': 'user-123',\n        'role': 'member',\n        'points': 50,\n        'joinedAt': '2024-01-15T00:00:00.000',\n      };\n\n      final member = LeagueMemberModel.fromJson(json);\n\n      expect(member.userId, 'user-123');\n      expect(member.role, LeagueMemberRole.member);\n      expect(member.joinedAt.year, 2024);\n      expect(member.joinedAt.month, 1);\n      expect(member.joinedAt.day, 15);\n    });\n\n    test('should create from JSON with milliseconds timestamp', () {\n      final millis = joinedAt.millisecondsSinceEpoch;\n      final json = {\n        'userId': 'user-123',\n        'role': 'owner',\n        'points': 200,\n        'joinedAt': millis,\n      };\n\n      final member = LeagueMemberModel.fromJson(json);\n\n      expect(member.userId, 'user-123');\n      expect(member.role, LeagueMemberRole.owner);\n      expect(member.joinedAt, joinedAt);\n    });\n\n    test('should handle missing optional fields', () {\n      final json = {\n        'userId': 'user-123',\n        'joinedAt': timestamp,\n      };\n\n      final member = LeagueMemberModel.fromJson(json);\n\n      expect(member.userId, 'user-123');\n      expect(member.role, LeagueMemberRole.member);\n      expect(member.points, 0);\n    });\n\n    test('should handle invalid role with default', () {\n      final json = {\n        'userId': 'user-123',\n        'role': 'invalid_role',\n        'joinedAt': timestamp,\n      };\n\n      final member = LeagueMemberModel.fromJson(json);\n\n      expect(member.role, LeagueMemberRole.member);\n    });\n\n    test('should convert to JSON', () {\n      final member = LeagueMemberModel(\n        userId: 'user-123',\n        role: LeagueMemberRole.admin,\n        points: 150,\n        joinedAt: joinedAt,\n      );\n\n      final json = member.toJson();\n\n      expect(json['userId'], 'user-123');\n      expect(json['role'], 'admin');\n      expect(json['points'], 150);\n      expect(json['joinedAt'], isA<Timestamp>());\n      expect((json['joinedAt'] as Timestamp).toDate(), joinedAt);\n    });\n\n    test('should create from entity', () {\n      final entity = LeagueMember(\n        userId: 'user-123',\n        role: LeagueMemberRole.admin,\n        points: 150,\n        joinedAt: joinedAt,\n      );\n\n      final model = LeagueMemberModel.fromEntity(entity);\n\n      expect(model.userId, 'user-123');\n      expect(model.role, LeagueMemberRole.admin);\n      expect(model.points, 150);\n      expect(model.joinedAt, joinedAt);\n    });\n\n    test('should convert to entity', () {\n      final model = LeagueMemberModel(\n        userId: 'user-123',\n        role: LeagueMemberRole.admin,\n        points: 150,\n        joinedAt: joinedAt,\n      );\n\n      final entity = model.toEntity();\n\n      expect(entity.userId, 'user-123');\n      expect(entity.role, LeagueMemberRole.admin);\n      expect(entity.points, 150);\n      expect(entity.joinedAt, joinedAt);\n      expect(entity, isA<LeagueMember>());\n    });\n\n    test('should create new member with defaults', () {\n      final member = LeagueMemberModel.newMember(\n        userId: 'new-user',\n        role: LeagueMemberRole.owner,\n      );\n\n      expect(member.userId, 'new-user');\n      expect(member.role, LeagueMemberRole.owner);\n      expect(member.points, 0);\n      expect(member.joinedAt, isNotNull);\n    });\n  });\n\n  group('LeagueModel', () {\n    final createdAt = DateTime(2024, 1, 15);\n    final timestamp = Timestamp.fromDate(createdAt);\n    final memberJoinedAt = DateTime(2024, 1, 16);\n    final memberTimestamp = Timestamp.fromDate(memberJoinedAt);\n\n    test('should create from JSON with Timestamp', () {\n      final json = {\n        'id': 'league-123',\n        'name': 'Burger Masters',\n        'description': 'The ultimate burger league',\n        'createdBy': 'creator-uid',\n        'inviteCode': 'ABC123',\n        'createdAt': timestamp,\n        'members': [\n          {\n            'userId': 'user-1',\n            'role': 'owner',\n            'points': 100,\n            'joinedAt': memberTimestamp,\n          },\n          {\n            'userId': 'user-2',\n            'role': 'member',\n            'points': 50,\n            'joinedAt': memberTimestamp,\n          },\n        ],\n        'settings': {\n          'isPublic': true,\n          'maxMembers': 100,\n          'pointsPerCheckIn': 15,\n          'pointsPerReview': 8,\n          'allowMemberInvites': true,\n          'requireApproval': false,\n        },\n      };\n\n      final league = LeagueModel.fromJson(json);\n\n      expect(league.id, 'league-123');\n      expect(league.name, 'Burger Masters');\n      expect(league.description, 'The ultimate burger league');\n      expect(league.createdBy, 'creator-uid');\n      expect(league.inviteCode, 'ABC123');\n      expect(league.createdAt, createdAt);\n      expect(league.members.length, 2);\n      expect(league.members[0].userId, 'user-1');\n      expect(league.members[0].role, LeagueMemberRole.owner);\n      expect(league.members[1].userId, 'user-2');\n      expect(league.members[1].role, LeagueMemberRole.member);\n      expect(league.settings.isPublic, true);\n      expect(league.settings.maxMembers, 100);\n    });\n\n    test('should create from JSON with id parameter', () {\n      final json = {\n        'name': 'Burger Masters',\n        'createdBy': 'creator-uid',\n        'inviteCode': 'ABC123',\n        'createdAt': timestamp,\n        'members': <dynamic>[],\n      };\n\n      final league = LeagueModel.fromJson(json, 'provided-id');\n\n      expect(league.id, 'provided-id');\n      expect(league.name, 'Burger Masters');\n    });\n\n    test('should handle missing optional fields', () {\n      final json = {\n        'id': 'league-123',\n        'name': 'Burger Masters',\n        'createdBy': 'creator-uid',\n        'inviteCode': 'ABC123',\n        'createdAt': timestamp,\n      };\n\n      final league = LeagueModel.fromJson(json);\n\n      expect(league.description, null);\n      expect(league.members, isEmpty);\n      expect(league.settings, isA<LeagueSettings>());\n      expect(league.settings.maxMembers, 50); // default\n    });\n\n    test('should handle ISO string date', () {\n      final json = {\n        'id': 'league-123',\n        'name': 'Burger Masters',\n        'createdBy': 'creator-uid',\n        'inviteCode': 'ABC123',\n        'createdAt': '2024-01-15T00:00:00.000',\n        'members': <dynamic>[],\n      };\n\n      final league = LeagueModel.fromJson(json);\n\n      expect(league.createdAt.year, 2024);\n      expect(league.createdAt.month, 1);\n      expect(league.createdAt.day, 15);\n    });\n\n    test('should handle milliseconds timestamp', () {\n      final millis = createdAt.millisecondsSinceEpoch;\n      final json = {\n        'id': 'league-123',\n        'name': 'Burger Masters',\n        'createdBy': 'creator-uid',\n        'inviteCode': 'ABC123',\n        'createdAt': millis,\n        'members': <dynamic>[],\n      };\n\n      final league = LeagueModel.fromJson(json);\n\n      expect(league.createdAt, createdAt);\n    });\n\n    test('should convert to JSON', () {\n      final league = LeagueModel(\n        id: 'league-123',\n        name: 'Burger Masters',\n        description: 'The ultimate burger league',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMemberModel(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: memberJoinedAt,\n          ),\n        ],\n        settings: const LeagueSettingsModel(\n          isPublic: true,\n          maxMembers: 100,\n        ),\n      );\n\n      final json = league.toJson();\n\n      expect(json['id'], 'league-123');\n      expect(json['name'], 'Burger Masters');\n      expect(json['description'], 'The ultimate burger league');\n      expect(json['createdBy'], 'creator-uid');\n      expect(json['inviteCode'], 'ABC123');\n      expect(json['createdAt'], isA<Timestamp>());\n      expect((json['createdAt'] as Timestamp).toDate(), createdAt);\n      expect(json['members'], isA<List>());\n      expect((json['members'] as List).length, 1);\n      expect(json['settings'], isA<Map>());\n      expect(json['settings']['isPublic'], true);\n      expect(json['settings']['maxMembers'], 100);\n    });\n\n    test('should convert to JSON for update (excludes id, createdBy, inviteCode, createdAt)', () {\n      final league = LeagueModel(\n        id: 'league-123',\n        name: 'Burger Masters',\n        description: 'Updated description',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMemberModel(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: memberJoinedAt,\n          ),\n        ],\n        settings: const LeagueSettingsModel(\n          isPublic: true,\n          maxMembers: 100,\n        ),\n      );\n\n      final json = league.toJsonForUpdate();\n\n      expect(json.containsKey('id'), false);\n      expect(json.containsKey('createdBy'), false);\n      expect(json.containsKey('inviteCode'), false);\n      expect(json.containsKey('createdAt'), false);\n      expect(json['name'], 'Burger Masters');\n      expect(json['description'], 'Updated description');\n      expect(json['members'], isA<List>());\n      expect(json['settings'], isA<Map>());\n    });\n\n    test('should create new league', () {\n      final league = LeagueModel.newLeague(\n        id: 'new-league',\n        name: 'New League',\n        description: 'A new league',\n        createdBy: 'creator-uid',\n        inviteCode: 'NEW123',\n        settings: const LeagueSettings(\n          isPublic: true,\n          maxMembers: 25,\n        ),\n      );\n\n      expect(league.id, 'new-league');\n      expect(league.name, 'New League');\n      expect(league.description, 'A new league');\n      expect(league.createdBy, 'creator-uid');\n      expect(league.inviteCode, 'NEW123');\n      expect(league.members.length, 1);\n      expect(league.members[0].userId, 'creator-uid');\n      expect(league.members[0].role, LeagueMemberRole.owner);\n      expect(league.members[0].points, 0);\n      expect(league.settings.isPublic, true);\n      expect(league.settings.maxMembers, 25);\n    });\n\n    test('should create from entity', () {\n      final entity = LeagueEntity(\n        id: 'league-123',\n        name: 'Burger Masters',\n        description: 'The ultimate burger league',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: memberJoinedAt,\n          ),\n        ],\n        settings: const LeagueSettings(\n          isPublic: true,\n          maxMembers: 100,\n        ),\n      );\n\n      final model = LeagueModel.fromEntity(entity);\n\n      expect(model.id, 'league-123');\n      expect(model.name, 'Burger Masters');\n      expect(model.description, 'The ultimate burger league');\n      expect(model.createdBy, 'creator-uid');\n      expect(model.inviteCode, 'ABC123');\n      expect(model.createdAt, createdAt);\n      expect(model.members.length, 1);\n      expect(model.settings.isPublic, true);\n    });\n\n    test('should convert to entity', () {\n      final model = LeagueModel(\n        id: 'league-123',\n        name: 'Burger Masters',\n        description: 'The ultimate burger league',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMemberModel(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: memberJoinedAt,\n          ),\n        ],\n        settings: const LeagueSettingsModel(\n          isPublic: true,\n          maxMembers: 100,\n        ),\n      );\n\n      final entity = model.toEntity();\n\n      expect(entity.id, 'league-123');\n      expect(entity.name, 'Burger Masters');\n      expect(entity.description, 'The ultimate burger league');\n      expect(entity.createdBy, 'creator-uid');\n      expect(entity.inviteCode, 'ABC123');\n      expect(entity.createdAt, createdAt);\n      expect(entity.members.length, 1);\n      expect(entity.settings.isPublic, true);\n      expect(entity, isA<LeagueEntity>());\n    });\n\n    test('copyWith should create a copy with updated fields', () {\n      final league = LeagueModel(\n        id: 'league-123',\n        name: 'Burger Masters',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: const [],\n      );\n\n      final updatedLeague = league.copyWith(\n        name: 'Updated Name',\n        description: 'New description',\n      );\n\n      expect(updatedLeague.id, 'league-123');\n      expect(updatedLeague.name, 'Updated Name');\n      expect(updatedLeague.description, 'New description');\n      expect(updatedLeague.createdBy, 'creator-uid');\n      expect(updatedLeague, isA<LeagueModel>());\n    });\n\n    test('should roundtrip through JSON', () {\n      final original = LeagueModel(\n        id: 'league-123',\n        name: 'Burger Masters',\n        description: 'The ultimate burger league',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMemberModel(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: memberJoinedAt,\n          ),\n          LeagueMemberModel(\n            userId: 'user-2',\n            role: LeagueMemberRole.admin,\n            points: 75,\n            joinedAt: memberJoinedAt,\n          ),\n          LeagueMemberModel(\n            userId: 'user-3',\n            role: LeagueMemberRole.member,\n            points: 50,\n            joinedAt: memberJoinedAt,\n          ),\n        ],\n        settings: const LeagueSettingsModel(\n          isPublic: true,\n          maxMembers: 100,\n          pointsPerCheckIn: 15,\n          pointsPerReview: 8,\n          allowMemberInvites: false,\n          requireApproval: true,\n        ),\n      );\n\n      final json = original.toJson();\n      final restored = LeagueModel.fromJson(json);\n\n      expect(restored.id, original.id);\n      expect(restored.name, original.name);\n      expect(restored.description, original.description);\n      expect(restored.createdBy, original.createdBy);\n      expect(restored.inviteCode, original.inviteCode);\n      expect(restored.createdAt, original.createdAt);\n      expect(restored.members.length, original.members.length);\n      expect(restored.members[0].userId, original.members[0].userId);\n      expect(restored.members[0].role, original.members[0].role);\n      expect(restored.members[0].points, original.members[0].points);\n      expect(restored.settings.isPublic, original.settings.isPublic);\n      expect(restored.settings.maxMembers, original.settings.maxMembers);\n      expect(restored.settings.pointsPerCheckIn, original.settings.pointsPerCheckIn);\n      expect(restored.settings.requireApproval, original.settings.requireApproval);\n    });\n  });\n\n  group('LeagueEntity helper methods', () {\n    final createdAt = DateTime(2024, 1, 15);\n    final joinedAt = DateTime(2024, 1, 16);\n\n    test('memberCount should return number of members', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt),\n        ],\n      );\n\n      expect(league.memberCount, 3);\n    });\n\n    test('isFull should return true when at max capacity', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, joinedAt: joinedAt),\n        ],\n        settings: const LeagueSettings(maxMembers: 2),\n      );\n\n      expect(league.isFull, true);\n      expect(league.canJoin, false);\n    });\n\n    test('isFull should return false when under capacity', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n        ],\n        settings: const LeagueSettings(maxMembers: 50),\n      );\n\n      expect(league.isFull, false);\n      expect(league.canJoin, true);\n    });\n\n    test('getMember should return member if found', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, points: 100, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, points: 50, joinedAt: joinedAt),\n        ],\n      );\n\n      final member = league.getMember('user-2');\n\n      expect(member, isNotNull);\n      expect(member!.userId, 'user-2');\n      expect(member.points, 50);\n    });\n\n    test('getMember should return null if not found', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n        ],\n      );\n\n      final member = league.getMember('non-existent');\n\n      expect(member, isNull);\n    });\n\n    test('isMember should return true for members', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n        ],\n      );\n\n      expect(league.isMember('user-1'), true);\n      expect(league.isMember('user-2'), false);\n    });\n\n    test('isAdmin should return true for admin and owner roles', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'user-1',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt),\n        ],\n      );\n\n      expect(league.isAdmin('user-1'), true);\n      expect(league.isAdmin('user-2'), true);\n      expect(league.isAdmin('user-3'), false);\n      expect(league.isAdmin('non-existent'), false);\n    });\n\n    test('isOwner should return true only for creator', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator-uid',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'creator-uid', role: LeagueMemberRole.owner, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt),\n        ],\n      );\n\n      expect(league.isOwner('creator-uid'), true);\n      expect(league.isOwner('user-2'), false);\n    });\n\n    test('leaderboard should return members sorted by points descending', () {\n      final league = LeagueEntity(\n        id: 'league-123',\n        name: 'Test League',\n        createdBy: 'creator',\n        inviteCode: 'ABC123',\n        createdAt: createdAt,\n        members: [\n          LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, points: 50, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-2', role: LeagueMemberRole.member, points: 150, joinedAt: joinedAt),\n          LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, points: 75, joinedAt: joinedAt),\n        ],\n      );\n\n      final leaderboard = league.leaderboard;\n\n      expect(leaderboard[0].userId, 'user-2');\n      expect(leaderboard[0].points, 150);\n      expect(leaderboard[1].userId, 'user-3');\n      expect(leaderboard[1].points, 75);\n      expect(leaderboard[2].userId, 'user-1');\n      expect(leaderboard[2].points, 50);\n    });\n  });\n\n  group('LeagueMember helper methods', () {\n    final joinedAt = DateTime(2024, 1, 15);\n\n    test('isAdmin should return true for admin and owner roles', () {\n      final owner = LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt);\n      final admin = LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt);\n      final member = LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt);\n\n      expect(owner.isAdmin, true);\n      expect(admin.isAdmin, true);\n      expect(member.isAdmin, false);\n    });\n\n    test('isOwner should return true only for owner role', () {\n      final owner = LeagueMember(userId: 'user-1', role: LeagueMemberRole.owner, joinedAt: joinedAt);\n      final admin = LeagueMember(userId: 'user-2', role: LeagueMemberRole.admin, joinedAt: joinedAt);\n      final member = LeagueMember(userId: 'user-3', role: LeagueMemberRole.member, joinedAt: joinedAt);\n\n      expect(owner.isOwner, true);\n      expect(admin.isOwner, false);\n      expect(member.isOwner, false);\n    });\n\n    test('newMember factory should create member with defaults', () {\n      final member = LeagueMember.newMember(userId: 'new-user');\n\n      expect(member.userId, 'new-user');\n      expect(member.role, LeagueMemberRole.member);\n      expect(member.points, 0);\n      expect(member.joinedAt, isNotNull);\n    });\n\n    test('newMember factory should accept custom role', () {\n      final member = LeagueMember.newMember(userId: 'new-admin', role: LeagueMemberRole.admin);\n\n      expect(member.userId, 'new-admin');\n      expect(member.role, LeagueMemberRole.admin);\n    });\n  });\n}\n"
}
Now let me run the tests to verify the implementation:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/features/leagues/data/models/league_model_test.dart 2>&1",
  "description": "Run league model tests",
  "timeout": 180000
}
All 40 tests pass. Let me update the todos and mark everything as complete:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create LeagueSettings entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueSettings entity"
    },
    {
      "content": "Create LeagueMember entity (nested value object)",
      "status": "completed",
      "activeForm": "Creating LeagueMember entity"
    },
    {
      "content": "Create LeagueEntity domain entity",
      "status": "completed",
      "activeForm": "Creating LeagueEntity domain entity"
    },
    {
      "content": "Create LeagueSettingsModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueSettingsModel"
    },
    {
      "content": "Create LeagueMemberModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueMemberModel"
    },
    {
      "content": "Create LeagueModel with Firestore serialization",
      "status": "completed",
      "activeForm": "Creating LeagueModel"
    },
    {
      "content": "Update barrel exports for leagues feature",
      "status": "completed",
      "activeForm": "Updating barrel exports"
    },
    {
      "content": "Run flutter analyze to verify code",
      "status": "completed",
      "activeForm": "Running flutter analyze"
    },
    {
      "content": "Create unit test for league models",
      "status": "completed",
      "activeForm": "Creating unit test for league models"
    }
  ]
}
The implementation is complete. The task mentioned Playwright testing, but this is a Flutter project where Flutter's test framework is appropriate for unit testing the models. The comprehensive unit tests I created (40 tests passing) verify all the functionality.

<summary>
## Summary: Define league model with Firestore serialization

### Changes Implemented
- Created `LeagueEntity` domain entity with id, name, description, createdBy, members, inviteCode, createdAt, and settings
- Created `LeagueSettings` value object for league configuration (visibility, member limits, scoring rules)
- Created `LeagueMember` value object for member data (userId, role, points, joinedAt)
- Created `LeagueMemberRole` enum (member, admin, owner)
- Created `LeagueModel` with full Firestore serialization support:
  - `fromJson()` / `toJson()` for Firestore data conversion
  - `fromFirestore()` for DocumentSnapshot parsing
  - `toJsonForUpdate()` for partial updates
  - `fromEntity()` / `toEntity()` for domain layer conversion
  - `newLeague()` factory for creating new leagues
  - Handles multiple timestamp formats (Firestore Timestamp, ISO string, milliseconds)
- Created `LeagueMemberModel` with Firestore serialization
- Created `LeagueSettingsModel` with Firestore serialization
- Added helper methods on entities (memberCount, isFull, canJoin, getMember, isMember, isAdmin, isOwner, leaderboard)
- Updated barrel exports for the leagues feature

### Files Modified
- `lib/features/leagues/domain/entities/league_entity.dart` (new)
- `lib/features/leagues/domain/entities/entities.dart` (new)
- `lib/features/leagues/domain/domain.dart` (new)
- `lib/features/leagues/data/models/league_model.dart` (new)
- `lib/features/leagues/data/models/models.dart` (new)
- `lib/features/leagues/data/data.dart` (new)
- `lib/features/leagues/leagues.dart` (updated barrel export)
- `test/features/leagues/data/models/league_model_test.dart` (new)

### Verification Status
- Flutter analyze passes with no issues
- 40 unit tests created and all passing, covering:
  - JSON serialization/deserialization for all models
  - Multiple timestamp format handling (Firestore Timestamp, ISO string, milliseconds)
  - Default value handling for missing JSON fields
  - Entity-Model conversion roundtrips
  - Helper methods (memberCount, isFull, getMember, leaderboard, etc.)
  - Edge cases (invalid roles, null members, empty settings)

### Notes for Developer
- The implementation follows the existing Model-Entity pattern from `UserModel`/`UserEntity`
- League members are stored as an embedded array in the league document (good for small leagues)
- For large leagues with many members, consider using a subcollection instead
- The `inviteCode` field should be generated when creating a league (not implemented - left for league creation feature)
- The test file is a permanent addition to the test suite (comprehensive unit tests, not a Playwright E2E test since this is a Flutter project)
</summary>