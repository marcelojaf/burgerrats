I'll start by exploring the codebase to understand the existing structure, particularly focusing on how check-ins and leagues are implemented, before implementing the leaderboard calculator feature.

🔧 Tool: Task
Input: {
  "prompt": "Explore this Flutter codebase to understand:\n1. The overall project structure and architecture patterns used\n2. How check-ins are implemented (data models, repositories, providers)\n3. How leagues are implemented (data models, repositories, providers)\n4. Any existing leaderboard or ranking functionality\n5. The state management approach (looks like it uses providers)\n6. How real-time updates are handled (if at all)\n\nFocus on finding relevant files in:\n- lib/features/check_ins/\n- lib/features/leagues/ (if exists)\n- lib/features/leaderboard/ (if exists)\n- lib/core/\n- Any Firebase or backend integration files\n\nProvide a comprehensive summary of what you find, including file paths and key code patterns.",
  "description": "Explore codebase structure",
  "subagent_type": "Explore"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\" -type f -name \"*.dart\" | head -50",
  "description": "Find all Dart files to understand project structure"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la \"C:\\dev\\burgerrats\\lib\" ",
  "description": "List main lib directory contents"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\pubspec.yaml"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\features\" -type d | sort",
  "description": "List all feature directories"
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*.dart",
  "path": "C:\\dev\\burgerrats\\lib\\features\\check_ins"
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*.dart",
  "path": "C:\\dev\\burgerrats\\lib\\features"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\domain\\entities\\check_in_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\data\\models\\check_in_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\entities\\league_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\models\\league_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\data\\repositories\\check_in_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\presentation\\providers\\create_check_in_provider.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\" -type f -name \"*leaderboard*\" -o -name \"*ranking*\" 2>/dev/null",
  "description": "Search for leaderboard-related files"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\state\\providers\\auth_state_provider.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*provider*.dart",
  "path": "C:\\dev\\burgerrats\\lib\\features\\leagues"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\providers\\create_league_provider.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\providers\\join_league_provider.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*.dart",
  "path": "C:\\dev\\burgerrats\\lib\\features\\home"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\core\\di\\register_module.dart",
  "limit": 100
}

🔧 Tool: Glob
Input: {
  "pattern": "*repository*.dart",
  "path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\domain"
}

🔧 Tool: Glob
Input: {
  "pattern": "*repository*.dart",
  "path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\domain\\repositories\\check_in_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\repositories\\league_repository.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\home\\presentation\\pages\\home_page.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find \"C:\\dev\\burgerrats\\lib\\core\\services\" -name \"*.dart\" | head -20",
  "description": "List core services"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\main.dart",
  "limit": 80
}
Excellent! Now I have a comprehensive understanding of the codebase. Let me check the remaining context and create a task list for implementation.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "in_progress",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "pending",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "pending",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Add leaderboard calculation methods to league repository",
      "status": "pending",
      "activeForm": "Adding leaderboard calculation methods"
    },
    {
      "content": "Update check-in submission to trigger leaderboard refresh",
      "status": "pending",
      "activeForm": "Updating check-in submission flow"
    },
    {
      "content": "Create leaderboard presentation widgets/pages",
      "status": "pending",
      "activeForm": "Creating leaderboard UI components"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying implementation with Playwright"
    }
  ]
}
Let me examine the existing league entity and repository more closely to understand the current leaderboard implementation:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\entities\\league_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\data\\repositories\\league_repository_impl.dart"
}
Let me also check the check-in repository to understand how points are added when a check-in is created:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\data\\repositories\\check_in_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\check_ins\\presentation\\providers\\create_check_in_provider.dart"
}
Now I have a comprehensive understanding of the codebase. Let me check the existing leagues presentation layer to see how the league detail page is structured:

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/leagues/presentation/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\pages\\league_details_page.dart"
}
Now I understand the full picture. Let me update the todo list and proceed with implementation:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "completed",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "in_progress",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "pending",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Enhance LeagueEntity with proper ranking methods that handle ties",
      "status": "pending",
      "activeForm": "Enhancing LeagueEntity with tie handling"
    },
    {
      "content": "Update LeagueDetailsPage with real-time leaderboard display",
      "status": "pending",
      "activeForm": "Updating LeagueDetailsPage"
    },
    {
      "content": "Verify real-time updates work when check-ins are submitted",
      "status": "pending",
      "activeForm": "Verifying real-time updates"
    }
  ]
}
Based on my analysis:

**Current Implementation:**
1. `LeagueEntity` has a simple `leaderboard` getter that sorts members by points (descending)
2. `LeagueRepository` has `getLeaderboard()` that returns sorted `LeagueMember` list
3. Real-time updates via `watchLeague()` are already in place
4. Points are updated via `addMemberPoints()` when a check-in is submitted
5. `LeagueDetailsPage` exists but is using hardcoded placeholder data

**Gaps to Fill:**
1. Need a `LeaderboardEntry` entity that includes rank position and handles ties
2. Need a proper leaderboard provider for reactive state management
3. Need to update `LeagueDetailsPage` to use real data with real-time updates
4. Need proper tie handling in the ranking calculation

Let me implement the solution:

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\entities\\leaderboard_entry.dart",
  "content": "import 'package:flutter/foundation.dart';\n\nimport 'league_entity.dart';\n\n/// Represents a leaderboard entry with ranking information\n///\n/// This entity wraps a [LeagueMember] with additional ranking metadata,\n/// including proper tie handling where members with equal points share the same rank.\n@immutable\nclass LeaderboardEntry {\n  /// The rank position (1-based, with ties sharing the same rank)\n  final int rank;\n\n  /// The underlying league member data\n  final LeagueMember member;\n\n  /// Whether this entry is tied with the previous entry\n  final bool isTied;\n\n  /// The number of check-ins (for secondary information display)\n  final int checkInCount;\n\n  const LeaderboardEntry({\n    required this.rank,\n    required this.member,\n    this.isTied = false,\n    this.checkInCount = 0,\n  });\n\n  /// User ID of the member\n  String get userId => member.userId;\n\n  /// Points of the member\n  int get points => member.points;\n\n  /// Role of the member in the league\n  LeagueMemberRole get role => member.role;\n\n  /// When the user joined the league\n  DateTime get joinedAt => member.joinedAt;\n\n  /// Creates a copy with updated fields\n  LeaderboardEntry copyWith({\n    int? rank,\n    LeagueMember? member,\n    bool? isTied,\n    int? checkInCount,\n  }) {\n    return LeaderboardEntry(\n      rank: rank ?? this.rank,\n      member: member ?? this.member,\n      isTied: isTied ?? this.isTied,\n      checkInCount: checkInCount ?? this.checkInCount,\n    );\n  }\n\n  @override\n  bool operator ==(Object other) {\n    if (identical(this, other)) return true;\n    return other is LeaderboardEntry &&\n        other.rank == rank &&\n        other.member == member &&\n        other.isTied == isTied &&\n        other.checkInCount == checkInCount;\n  }\n\n  @override\n  int get hashCode => Object.hash(rank, member, isTied, checkInCount);\n\n  @override\n  String toString() {\n    return 'LeaderboardEntry(rank: $rank, userId: $userId, points: $points, '\n        'isTied: $isTied, checkInCount: $checkInCount)';\n  }\n}\n\n/// Extension on LeagueEntity to provide leaderboard calculation with tie handling\nextension LeagueLeaderboardExtension on LeagueEntity {\n  /// Gets the leaderboard with proper ranking that handles ties\n  ///\n  /// Members with the same points share the same rank.\n  /// For example: 1st (100pts), 2nd (80pts), 2nd (80pts), 4th (60pts)\n  List<LeaderboardEntry> get rankedLeaderboard {\n    if (members.isEmpty) {\n      return [];\n    }\n\n    // Sort members by points (descending), then by join date (earlier first for tie-breaker display)\n    final sorted = List<LeagueMember>.from(members);\n    sorted.sort((a, b) {\n      final pointsComparison = b.points.compareTo(a.points);\n      if (pointsComparison != 0) return pointsComparison;\n      // Secondary sort by join date (earlier joiners first)\n      return a.joinedAt.compareTo(b.joinedAt);\n    });\n\n    final List<LeaderboardEntry> entries = [];\n    int currentRank = 1;\n\n    for (int i = 0; i < sorted.length; i++) {\n      final member = sorted[i];\n      final bool isTied = i > 0 && sorted[i - 1].points == member.points;\n\n      // If tied with previous, use same rank; otherwise use current position\n      if (!isTied && i > 0) {\n        currentRank = i + 1;\n      }\n\n      entries.add(LeaderboardEntry(\n        rank: currentRank,\n        member: member,\n        isTied: isTied,\n      ));\n    }\n\n    return entries;\n  }\n\n  /// Gets the rank of a specific user in the league\n  ///\n  /// Returns null if the user is not a member.\n  int? getUserRank(String userId) {\n    final entry = rankedLeaderboard.where((e) => e.userId == userId).firstOrNull;\n    return entry?.rank;\n  }\n\n  /// Gets the leaderboard entry for a specific user\n  ///\n  /// Returns null if the user is not a member.\n  LeaderboardEntry? getUserLeaderboardEntry(String userId) {\n    return rankedLeaderboard.where((e) => e.userId == userId).firstOrNull;\n  }\n\n  /// Gets the top N entries from the leaderboard\n  List<LeaderboardEntry> getTopEntries(int count) {\n    final ranked = rankedLeaderboard;\n    if (ranked.length <= count) {\n      return ranked;\n    }\n    return ranked.take(count).toList();\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "completed",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "completed",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "in_progress",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Enhance LeagueEntity with proper ranking methods that handle ties",
      "status": "completed",
      "activeForm": "Enhancing LeagueEntity with tie handling"
    },
    {
      "content": "Update LeagueDetailsPage with real-time leaderboard display",
      "status": "pending",
      "activeForm": "Updating LeagueDetailsPage"
    },
    {
      "content": "Verify real-time updates work when check-ins are submitted",
      "status": "pending",
      "activeForm": "Verifying real-time updates"
    }
  ]
}
Now let me create the LeaderboardProvider for real-time leaderboard state management:

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\providers\\leaderboard_provider.dart",
  "content": "import 'package:flutter_riverpod/flutter_riverpod.dart';\n\nimport '../../../../core/di/injection.dart';\nimport '../../domain/entities/league_entity.dart';\nimport '../../domain/entities/leaderboard_entry.dart';\nimport '../../domain/repositories/league_repository.dart';\n\n/// Provider for the LeagueRepository instance from GetIt\nfinal leaderboardLeagueRepositoryProvider = Provider<LeagueRepository>((ref) {\n  return getIt<LeagueRepository>();\n});\n\n/// State class for leaderboard data\nclass LeaderboardState {\n  final LeaderboardStatus status;\n  final LeagueEntity? league;\n  final List<LeaderboardEntry> entries;\n  final String? errorMessage;\n  final DateTime? lastUpdated;\n\n  const LeaderboardState({\n    this.status = LeaderboardStatus.initial,\n    this.league,\n    this.entries = const [],\n    this.errorMessage,\n    this.lastUpdated,\n  });\n\n  const LeaderboardState.initial()\n      : status = LeaderboardStatus.initial,\n        league = null,\n        entries = const [],\n        errorMessage = null,\n        lastUpdated = null;\n\n  bool get isLoading => status == LeaderboardStatus.loading;\n  bool get hasError => status == LeaderboardStatus.error;\n  bool get hasData => entries.isNotEmpty;\n\n  LeaderboardState copyWith({\n    LeaderboardStatus? status,\n    LeagueEntity? league,\n    List<LeaderboardEntry>? entries,\n    String? errorMessage,\n    DateTime? lastUpdated,\n    bool clearError = false,\n  }) {\n    return LeaderboardState(\n      status: status ?? this.status,\n      league: league ?? this.league,\n      entries: entries ?? this.entries,\n      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),\n      lastUpdated: lastUpdated ?? this.lastUpdated,\n    );\n  }\n}\n\n/// Status enum for leaderboard loading state\nenum LeaderboardStatus {\n  initial,\n  loading,\n  loaded,\n  error,\n}\n\n/// Stream provider that watches a league and provides real-time leaderboard updates\n///\n/// This is the primary way to get leaderboard data with real-time updates.\n/// When a check-in is submitted and points are updated, the leaderboard\n/// will automatically refresh.\nfinal leagueLeaderboardStreamProvider =\n    StreamProvider.family<List<LeaderboardEntry>, String>((ref, leagueId) {\n  final repository = ref.watch(leaderboardLeagueRepositoryProvider);\n\n  return repository.watchLeague(leagueId).map((league) {\n    if (league == null) {\n      return <LeaderboardEntry>[];\n    }\n    return league.rankedLeaderboard;\n  });\n});\n\n/// Stream provider that watches a league entity for real-time updates\nfinal leagueStreamProvider =\n    StreamProvider.family<LeagueEntity?, String>((ref, leagueId) {\n  final repository = ref.watch(leaderboardLeagueRepositoryProvider);\n  return repository.watchLeague(leagueId);\n});\n\n/// Provider that gets the current user's rank in a specific league\n///\n/// Returns null if the user is not a member or if the league doesn't exist.\nfinal userRankInLeagueProvider =\n    Provider.family<int?, ({String leagueId, String userId})>((ref, params) {\n  final leaderboardAsync =\n      ref.watch(leagueLeaderboardStreamProvider(params.leagueId));\n\n  return leaderboardAsync.whenOrNull(\n    data: (entries) {\n      final userEntry =\n          entries.where((e) => e.userId == params.userId).firstOrNull;\n      return userEntry?.rank;\n    },\n  );\n});\n\n/// Provider that gets a specific user's leaderboard entry in a league\nfinal userLeaderboardEntryProvider = Provider.family<LeaderboardEntry?,\n    ({String leagueId, String userId})>((ref, params) {\n  final leaderboardAsync =\n      ref.watch(leagueLeaderboardStreamProvider(params.leagueId));\n\n  return leaderboardAsync.whenOrNull(\n    data: (entries) {\n      return entries.where((e) => e.userId == params.userId).firstOrNull;\n    },\n  );\n});\n\n/// Provider that gets the top N entries from a league's leaderboard\nfinal topLeaderboardEntriesProvider =\n    Provider.family<List<LeaderboardEntry>, ({String leagueId, int count})>(\n        (ref, params) {\n  final leaderboardAsync =\n      ref.watch(leagueLeaderboardStreamProvider(params.leagueId));\n\n  return leaderboardAsync.whenOrNull(\n        data: (entries) {\n          if (entries.length <= params.count) {\n            return entries;\n          }\n          return entries.take(params.count).toList();\n        },\n      ) ??\n      [];\n});\n\n/// Provider that watches all leagues for a user and provides their rankings\nfinal userLeagueRankingsProvider =\n    StreamProvider.family<List<UserLeagueRanking>, String>((ref, userId) {\n  final repository = ref.watch(leaderboardLeagueRepositoryProvider);\n\n  return repository.watchLeaguesForUser(userId).map((leagues) {\n    return leagues.map((league) {\n      final entry = league.getUserLeaderboardEntry(userId);\n      return UserLeagueRanking(\n        league: league,\n        rank: entry?.rank,\n        points: entry?.points ?? 0,\n        totalMembers: league.memberCount,\n      );\n    }).toList()\n      ..sort((a, b) {\n        // Sort by rank (ascending), with null ranks at the end\n        if (a.rank == null && b.rank == null) return 0;\n        if (a.rank == null) return 1;\n        if (b.rank == null) return -1;\n        return a.rank!.compareTo(b.rank!);\n      });\n  });\n});\n\n/// Represents a user's ranking in a specific league\nclass UserLeagueRanking {\n  final LeagueEntity league;\n  final int? rank;\n  final int points;\n  final int totalMembers;\n\n  const UserLeagueRanking({\n    required this.league,\n    this.rank,\n    required this.points,\n    required this.totalMembers,\n  });\n\n  /// Formatted rank string (e.g., \"1st\", \"2nd\", \"3rd\")\n  String get formattedRank {\n    if (rank == null) return '-';\n    return _formatRank(rank!);\n  }\n\n  /// Position display (e.g., \"1/10\")\n  String get positionDisplay => '${rank ?? \"-\"}/$totalMembers';\n\n  static String _formatRank(int rank) {\n    if (rank >= 11 && rank <= 13) {\n      return '${rank}th';\n    }\n    return switch (rank % 10) {\n      1 => '${rank}st',\n      2 => '${rank}nd',\n      3 => '${rank}rd',\n      _ => '${rank}th',\n    };\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "completed",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "completed",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "completed",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Enhance LeagueEntity with proper ranking methods that handle ties",
      "status": "completed",
      "activeForm": "Enhancing LeagueEntity with tie handling"
    },
    {
      "content": "Update LeagueDetailsPage with real-time leaderboard display",
      "status": "in_progress",
      "activeForm": "Updating LeagueDetailsPage"
    },
    {
      "content": "Verify real-time updates work when check-ins are submitted",
      "status": "pending",
      "activeForm": "Verifying real-time updates"
    }
  ]
}
Now let me update the LeagueDetailsPage to use real data with real-time leaderboard updates:

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\pages\\league_details_page.dart",
  "content": "import 'package:flutter/material.dart';\nimport 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:share_plus/share_plus.dart';\n\nimport '../../../../core/di/injection.dart';\nimport '../../../../core/services/deep_link_service.dart';\nimport '../../domain/entities/leaderboard_entry.dart';\nimport '../providers/leaderboard_provider.dart';\n\n/// League details page showing league information and real-time leaderboard\nclass LeagueDetailsPage extends ConsumerWidget {\n  const LeagueDetailsPage({\n    super.key,\n    required this.leagueId,\n  });\n\n  final String leagueId;\n\n  void _shareLeagueInvite(BuildContext context) {\n    final deepLinkService = getIt<DeepLinkService>();\n    final link = deepLinkService.generateLeagueInviteLink(leagueId);\n\n    Share.share(\n      'Join my burger league on BurgerRats! $link',\n      subject: 'League Invitation',\n    );\n  }\n\n  @override\n  Widget build(BuildContext context, WidgetRef ref) {\n    final leagueAsync = ref.watch(leagueStreamProvider(leagueId));\n    final leaderboardAsync = ref.watch(leagueLeaderboardStreamProvider(leagueId));\n\n    return Scaffold(\n      appBar: AppBar(\n        title: leagueAsync.when(\n          data: (league) => Text(league?.name ?? 'League'),\n          loading: () => const Text('Loading...'),\n          error: (_, __) => const Text('League'),\n        ),\n        actions: [\n          IconButton(\n            icon: const Icon(Icons.share),\n            tooltip: 'Share League Invite',\n            onPressed: () => _shareLeagueInvite(context),\n          ),\n        ],\n      ),\n      body: leagueAsync.when(\n        data: (league) {\n          if (league == null) {\n            return const Center(\n              child: Text('League not found'),\n            );\n          }\n\n          return RefreshIndicator(\n            onRefresh: () async {\n              ref.invalidate(leagueStreamProvider(leagueId));\n            },\n            child: SingleChildScrollView(\n              physics: const AlwaysScrollableScrollPhysics(),\n              padding: const EdgeInsets.all(16),\n              child: Column(\n                crossAxisAlignment: CrossAxisAlignment.start,\n                children: [\n                  // League Info Card\n                  _LeagueInfoCard(\n                    name: league.name,\n                    description: league.description,\n                    memberCount: league.memberCount,\n                    inviteCode: league.inviteCode,\n                  ),\n                  const SizedBox(height: 24),\n\n                  // Leaderboard Section\n                  Row(\n                    children: [\n                      Text(\n                        'Leaderboard',\n                        style: Theme.of(context).textTheme.titleLarge,\n                      ),\n                      const Spacer(),\n                      leaderboardAsync.when(\n                        data: (entries) => Text(\n                          '${entries.length} members',\n                          style: Theme.of(context).textTheme.bodySmall?.copyWith(\n                                color: Theme.of(context).colorScheme.outline,\n                              ),\n                        ),\n                        loading: () => const SizedBox.shrink(),\n                        error: (_, __) => const SizedBox.shrink(),\n                      ),\n                    ],\n                  ),\n                  const SizedBox(height: 12),\n\n                  // Leaderboard List\n                  leaderboardAsync.when(\n                    data: (entries) {\n                      if (entries.isEmpty) {\n                        return const _EmptyLeaderboard();\n                      }\n                      return _LeaderboardList(entries: entries);\n                    },\n                    loading: () => const _LeaderboardLoading(),\n                    error: (error, _) => _LeaderboardError(\n                      message: error.toString(),\n                      onRetry: () => ref.invalidate(\n                        leagueLeaderboardStreamProvider(leagueId),\n                      ),\n                    ),\n                  ),\n                ],\n              ),\n            ),\n          );\n        },\n        loading: () => const Center(child: CircularProgressIndicator()),\n        error: (error, _) => Center(\n          child: Column(\n            mainAxisAlignment: MainAxisAlignment.center,\n            children: [\n              Text('Error: $error'),\n              const SizedBox(height: 16),\n              ElevatedButton(\n                onPressed: () => ref.invalidate(leagueStreamProvider(leagueId)),\n                child: const Text('Retry'),\n              ),\n            ],\n          ),\n        ),\n      ),\n    );\n  }\n}\n\n/// Card displaying league information\nclass _LeagueInfoCard extends StatelessWidget {\n  const _LeagueInfoCard({\n    required this.name,\n    this.description,\n    required this.memberCount,\n    required this.inviteCode,\n  });\n\n  final String name;\n  final String? description;\n  final int memberCount;\n  final String inviteCode;\n\n  @override\n  Widget build(BuildContext context) {\n    return Card(\n      child: Padding(\n        padding: const EdgeInsets.all(16),\n        child: Column(\n          crossAxisAlignment: CrossAxisAlignment.start,\n          children: [\n            Text(\n              name,\n              style: Theme.of(context).textTheme.headlineSmall,\n            ),\n            if (description != null && description!.isNotEmpty) ...[\n              const SizedBox(height: 8),\n              Text(\n                description!,\n                style: Theme.of(context).textTheme.bodyLarge,\n              ),\n            ],\n            const SizedBox(height: 16),\n            Row(\n              children: [\n                const Icon(Icons.people, size: 20),\n                const SizedBox(width: 8),\n                Text('$memberCount members'),\n                const Spacer(),\n                Container(\n                  padding: const EdgeInsets.symmetric(\n                    horizontal: 12,\n                    vertical: 4,\n                  ),\n                  decoration: BoxDecoration(\n                    color: Theme.of(context).colorScheme.surfaceContainerHighest,\n                    borderRadius: BorderRadius.circular(16),\n                  ),\n                  child: Row(\n                    mainAxisSize: MainAxisSize.min,\n                    children: [\n                      Icon(\n                        Icons.tag,\n                        size: 16,\n                        color: Theme.of(context).colorScheme.primary,\n                      ),\n                      const SizedBox(width: 4),\n                      Text(\n                        inviteCode,\n                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(\n                              fontWeight: FontWeight.bold,\n                              letterSpacing: 1.2,\n                            ),\n                      ),\n                    ],\n                  ),\n                ),\n              ],\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n\n/// Widget displaying the leaderboard list\nclass _LeaderboardList extends StatelessWidget {\n  const _LeaderboardList({required this.entries});\n\n  final List<LeaderboardEntry> entries;\n\n  @override\n  Widget build(BuildContext context) {\n    return Card(\n      clipBehavior: Clip.antiAlias,\n      child: ListView.separated(\n        shrinkWrap: true,\n        physics: const NeverScrollableScrollPhysics(),\n        itemCount: entries.length,\n        separatorBuilder: (_, __) => const Divider(height: 1),\n        itemBuilder: (context, index) {\n          final entry = entries[index];\n          return _LeaderboardTile(\n            entry: entry,\n            isTop3: entry.rank <= 3,\n          );\n        },\n      ),\n    );\n  }\n}\n\n/// Individual leaderboard entry tile\nclass _LeaderboardTile extends StatelessWidget {\n  const _LeaderboardTile({\n    required this.entry,\n    this.isTop3 = false,\n  });\n\n  final LeaderboardEntry entry;\n  final bool isTop3;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = Theme.of(context);\n\n    return ListTile(\n      leading: _RankBadge(\n        rank: entry.rank,\n        isTied: entry.isTied,\n      ),\n      title: Text(\n        'User ${entry.userId.substring(0, 8)}...',\n        style: theme.textTheme.bodyLarge?.copyWith(\n          fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,\n        ),\n      ),\n      subtitle: entry.isTied\n          ? Text(\n              'Tied',\n              style: theme.textTheme.bodySmall?.copyWith(\n                color: theme.colorScheme.outline,\n              ),\n            )\n          : null,\n      trailing: _PointsBadge(points: entry.points),\n    );\n  }\n}\n\n/// Badge displaying the rank with special styling for top 3\nclass _RankBadge extends StatelessWidget {\n  const _RankBadge({\n    required this.rank,\n    this.isTied = false,\n  });\n\n  final int rank;\n  final bool isTied;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = Theme.of(context);\n\n    // Special medals for top 3\n    if (rank <= 3) {\n      final (color, icon) = switch (rank) {\n        1 => (const Color(0xFFFFD700), Icons.emoji_events), // Gold\n        2 => (const Color(0xFFC0C0C0), Icons.emoji_events), // Silver\n        3 => (const Color(0xFFCD7F32), Icons.emoji_events), // Bronze\n        _ => (theme.colorScheme.surfaceContainerHighest, Icons.circle),\n      };\n\n      return CircleAvatar(\n        backgroundColor: color.withValues(alpha: 0.2),\n        child: Icon(\n          icon,\n          color: color,\n          size: 24,\n        ),\n      );\n    }\n\n    // Regular rank badge\n    return CircleAvatar(\n      backgroundColor: theme.colorScheme.surfaceContainerHighest,\n      child: Text(\n        '$rank',\n        style: theme.textTheme.bodyLarge?.copyWith(\n          fontWeight: FontWeight.bold,\n        ),\n      ),\n    );\n  }\n}\n\n/// Badge displaying points\nclass _PointsBadge extends StatelessWidget {\n  const _PointsBadge({required this.points});\n\n  final int points;\n\n  @override\n  Widget build(BuildContext context) {\n    final theme = Theme.of(context);\n\n    return Container(\n      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),\n      decoration: BoxDecoration(\n        color: theme.colorScheme.primaryContainer,\n        borderRadius: BorderRadius.circular(16),\n      ),\n      child: Text(\n        '$points pts',\n        style: theme.textTheme.bodyMedium?.copyWith(\n          color: theme.colorScheme.onPrimaryContainer,\n          fontWeight: FontWeight.bold,\n        ),\n      ),\n    );\n  }\n}\n\n/// Empty state for leaderboard\nclass _EmptyLeaderboard extends StatelessWidget {\n  const _EmptyLeaderboard();\n\n  @override\n  Widget build(BuildContext context) {\n    return Card(\n      child: Padding(\n        padding: const EdgeInsets.all(32),\n        child: Column(\n          children: [\n            Icon(\n              Icons.leaderboard_outlined,\n              size: 64,\n              color: Theme.of(context).colorScheme.outline,\n            ),\n            const SizedBox(height: 16),\n            Text(\n              'No rankings yet',\n              style: Theme.of(context).textTheme.titleMedium,\n            ),\n            const SizedBox(height: 8),\n            Text(\n              'Be the first to check in and earn points!',\n              style: Theme.of(context).textTheme.bodyMedium?.copyWith(\n                    color: Theme.of(context).colorScheme.outline,\n                  ),\n              textAlign: TextAlign.center,\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n\n/// Loading state for leaderboard\nclass _LeaderboardLoading extends StatelessWidget {\n  const _LeaderboardLoading();\n\n  @override\n  Widget build(BuildContext context) {\n    return Card(\n      child: Padding(\n        padding: const EdgeInsets.all(32),\n        child: Column(\n          children: [\n            const CircularProgressIndicator(),\n            const SizedBox(height: 16),\n            Text(\n              'Loading leaderboard...',\n              style: Theme.of(context).textTheme.bodyMedium,\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n\n/// Error state for leaderboard\nclass _LeaderboardError extends StatelessWidget {\n  const _LeaderboardError({\n    required this.message,\n    required this.onRetry,\n  });\n\n  final String message;\n  final VoidCallback onRetry;\n\n  @override\n  Widget build(BuildContext context) {\n    return Card(\n      child: Padding(\n        padding: const EdgeInsets.all(32),\n        child: Column(\n          children: [\n            Icon(\n              Icons.error_outline,\n              size: 64,\n              color: Theme.of(context).colorScheme.error,\n            ),\n            const SizedBox(height: 16),\n            Text(\n              'Failed to load leaderboard',\n              style: Theme.of(context).textTheme.titleMedium,\n            ),\n            const SizedBox(height: 8),\n            Text(\n              message,\n              style: Theme.of(context).textTheme.bodySmall?.copyWith(\n                    color: Theme.of(context).colorScheme.outline,\n                  ),\n              textAlign: TextAlign.center,\n            ),\n            const SizedBox(height: 16),\n            ElevatedButton.icon(\n              onPressed: onRetry,\n              icon: const Icon(Icons.refresh),\n              label: const Text('Retry'),\n            ),\n          ],\n        ),\n      ),\n    );\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "completed",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "completed",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "completed",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Enhance LeagueEntity with proper ranking methods that handle ties",
      "status": "completed",
      "activeForm": "Enhancing LeagueEntity with tie handling"
    },
    {
      "content": "Update LeagueDetailsPage with real-time leaderboard display",
      "status": "completed",
      "activeForm": "Updating LeagueDetailsPage"
    },
    {
      "content": "Export new files in barrel exports",
      "status": "in_progress",
      "activeForm": "Exporting new files"
    },
    {
      "content": "Create unit tests for leaderboard calculation",
      "status": "pending",
      "activeForm": "Creating unit tests"
    },
    {
      "content": "Verify Flutter build compiles successfully",
      "status": "pending",
      "activeForm": "Verifying Flutter build"
    }
  ]
}
Now let me check the barrel exports to ensure the new files are properly exported:

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/leagues/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\entities\\entities.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\presentation.dart"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\entities\\entities.dart",
  "old_string": "// Leagues domain entities barrel export\n\nexport 'league_entity.dart';",
  "new_string": "// Leagues domain entities barrel export\n\nexport 'league_entity.dart';\nexport 'leaderboard_entry.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\presentation\\presentation.dart",
  "old_string": "export 'pages/create_league_page.dart';\nexport 'pages/join_league_page.dart';\nexport 'pages/league_details_page.dart';\nexport 'pages/leagues_page.dart';\nexport 'providers/create_league_provider.dart';\nexport 'providers/join_league_provider.dart';",
  "new_string": "export 'pages/create_league_page.dart';\nexport 'pages/join_league_page.dart';\nexport 'pages/league_details_page.dart';\nexport 'pages/leagues_page.dart';\nexport 'providers/create_league_provider.dart';\nexport 'providers/join_league_provider.dart';\nexport 'providers/leaderboard_provider.dart';"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "completed",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "completed",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "completed",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Enhance LeagueEntity with proper ranking methods that handle ties",
      "status": "completed",
      "activeForm": "Enhancing LeagueEntity with tie handling"
    },
    {
      "content": "Update LeagueDetailsPage with real-time leaderboard display",
      "status": "completed",
      "activeForm": "Updating LeagueDetailsPage"
    },
    {
      "content": "Export new files in barrel exports",
      "status": "completed",
      "activeForm": "Exporting new files"
    },
    {
      "content": "Create unit tests for leaderboard calculation",
      "status": "in_progress",
      "activeForm": "Creating unit tests"
    },
    {
      "content": "Verify Flutter build compiles successfully",
      "status": "pending",
      "activeForm": "Verifying Flutter build"
    }
  ]
}
Now let me create unit tests for the leaderboard calculation:

🔧 Tool: Glob
Input: {
  "pattern": "test/features/leagues/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\test\\features\\leagues\\data\\repositories\\league_repository_impl_test.dart"
}
Now let me create a dedicated test file for the leaderboard ranking functionality with tie handling:

🔧 Tool: Write
Input: {
  "file_path": "C:\\dev\\burgerrats\\test\\features\\leagues\\domain\\entities\\leaderboard_entry_test.dart",
  "content": "import 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';\nimport 'package:burgerrats/features/leagues/domain/entities/leaderboard_entry.dart';\n\nvoid main() {\n  group('LeaderboardEntry', () {\n    test('should have correct properties from member', () {\n      final member = LeagueMember(\n        userId: 'user-123',\n        role: LeagueMemberRole.member,\n        points: 100,\n        joinedAt: DateTime(2024, 1, 1),\n      );\n\n      final entry = LeaderboardEntry(\n        rank: 1,\n        member: member,\n        isTied: false,\n        checkInCount: 10,\n      );\n\n      expect(entry.rank, 1);\n      expect(entry.userId, 'user-123');\n      expect(entry.points, 100);\n      expect(entry.role, LeagueMemberRole.member);\n      expect(entry.joinedAt, DateTime(2024, 1, 1));\n      expect(entry.isTied, false);\n      expect(entry.checkInCount, 10);\n    });\n\n    test('copyWith should create a copy with updated fields', () {\n      final member = LeagueMember(\n        userId: 'user-123',\n        role: LeagueMemberRole.member,\n        points: 100,\n        joinedAt: DateTime(2024, 1, 1),\n      );\n\n      final entry = LeaderboardEntry(\n        rank: 1,\n        member: member,\n        isTied: false,\n        checkInCount: 10,\n      );\n\n      final updated = entry.copyWith(rank: 2, isTied: true);\n\n      expect(updated.rank, 2);\n      expect(updated.isTied, true);\n      expect(updated.userId, 'user-123'); // unchanged\n      expect(updated.points, 100); // unchanged\n    });\n\n    test('equality should work correctly', () {\n      final member = LeagueMember(\n        userId: 'user-123',\n        role: LeagueMemberRole.member,\n        points: 100,\n        joinedAt: DateTime(2024, 1, 1),\n      );\n\n      final entry1 = LeaderboardEntry(\n        rank: 1,\n        member: member,\n        isTied: false,\n        checkInCount: 10,\n      );\n\n      final entry2 = LeaderboardEntry(\n        rank: 1,\n        member: member,\n        isTied: false,\n        checkInCount: 10,\n      );\n\n      expect(entry1, entry2);\n      expect(entry1.hashCode, entry2.hashCode);\n    });\n  });\n\n  group('LeagueLeaderboardExtension', () {\n    LeagueEntity createLeagueWithMembers(List<LeagueMember> members) {\n      return LeagueEntity(\n        id: 'league-1',\n        name: 'Test League',\n        createdBy: members.isNotEmpty ? members.first.userId : 'owner',\n        members: members,\n        inviteCode: 'TEST1234',\n        createdAt: DateTime(2024, 1, 1),\n      );\n    }\n\n    group('rankedLeaderboard', () {\n      test('should return empty list for league with no members', () {\n        final league = createLeagueWithMembers([]);\n\n        expect(league.rankedLeaderboard, isEmpty);\n      });\n\n      test('should rank single member as first', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n        ]);\n\n        final leaderboard = league.rankedLeaderboard;\n\n        expect(leaderboard.length, 1);\n        expect(leaderboard[0].rank, 1);\n        expect(leaderboard[0].userId, 'user-1');\n        expect(leaderboard[0].isTied, false);\n      });\n\n      test('should sort members by points descending', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 50,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 150,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n          LeagueMember(\n            userId: 'user-3',\n            role: LeagueMemberRole.member,\n            points: 75,\n            joinedAt: DateTime(2024, 1, 3),\n          ),\n        ]);\n\n        final leaderboard = league.rankedLeaderboard;\n\n        expect(leaderboard[0].userId, 'user-2');\n        expect(leaderboard[0].points, 150);\n        expect(leaderboard[0].rank, 1);\n\n        expect(leaderboard[1].userId, 'user-3');\n        expect(leaderboard[1].points, 75);\n        expect(leaderboard[1].rank, 2);\n\n        expect(leaderboard[2].userId, 'user-1');\n        expect(leaderboard[2].points, 50);\n        expect(leaderboard[2].rank, 3);\n      });\n\n      test('should handle ties - members with same points share same rank', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n          LeagueMember(\n            userId: 'user-3',\n            role: LeagueMemberRole.member,\n            points: 50,\n            joinedAt: DateTime(2024, 1, 3),\n          ),\n        ]);\n\n        final leaderboard = league.rankedLeaderboard;\n\n        // user-1 and user-2 should both be rank 1 (tied)\n        expect(leaderboard[0].rank, 1);\n        expect(leaderboard[0].isTied, false); // First entry is not marked as tied\n        expect(leaderboard[1].rank, 1);\n        expect(leaderboard[1].isTied, true); // Second entry is tied with first\n\n        // user-3 should be rank 3 (skipping rank 2)\n        expect(leaderboard[2].rank, 3);\n        expect(leaderboard[2].isTied, false);\n      });\n\n      test('should handle multiple ties correctly', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n          LeagueMember(\n            userId: 'user-3',\n            role: LeagueMemberRole.member,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 3),\n          ),\n          LeagueMember(\n            userId: 'user-4',\n            role: LeagueMemberRole.member,\n            points: 50,\n            joinedAt: DateTime(2024, 1, 4),\n          ),\n          LeagueMember(\n            userId: 'user-5',\n            role: LeagueMemberRole.member,\n            points: 50,\n            joinedAt: DateTime(2024, 1, 5),\n          ),\n        ]);\n\n        final leaderboard = league.rankedLeaderboard;\n\n        // First three should all be rank 1\n        expect(leaderboard[0].rank, 1);\n        expect(leaderboard[0].isTied, false);\n        expect(leaderboard[1].rank, 1);\n        expect(leaderboard[1].isTied, true);\n        expect(leaderboard[2].rank, 1);\n        expect(leaderboard[2].isTied, true);\n\n        // Fourth and fifth should be rank 4 (tied)\n        expect(leaderboard[3].rank, 4);\n        expect(leaderboard[3].isTied, false);\n        expect(leaderboard[4].rank, 4);\n        expect(leaderboard[4].isTied, true);\n      });\n\n      test('should use join date as secondary sort for ties (earlier first)', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-late',\n            role: LeagueMemberRole.member,\n            points: 100,\n            joinedAt: DateTime(2024, 3, 1),\n          ),\n          LeagueMember(\n            userId: 'user-early',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-mid',\n            role: LeagueMemberRole.member,\n            points: 100,\n            joinedAt: DateTime(2024, 2, 1),\n          ),\n        ]);\n\n        final leaderboard = league.rankedLeaderboard;\n\n        // All have same points, so sorted by join date (earlier first)\n        expect(leaderboard[0].userId, 'user-early');\n        expect(leaderboard[1].userId, 'user-mid');\n        expect(leaderboard[2].userId, 'user-late');\n\n        // All share rank 1 (tied)\n        expect(leaderboard[0].rank, 1);\n        expect(leaderboard[1].rank, 1);\n        expect(leaderboard[2].rank, 1);\n      });\n\n      test('should handle zero points correctly', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 0,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 0,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n        ]);\n\n        final leaderboard = league.rankedLeaderboard;\n\n        expect(leaderboard[0].rank, 1);\n        expect(leaderboard[1].rank, 1);\n        expect(leaderboard[1].isTied, true);\n      });\n    });\n\n    group('getUserRank', () {\n      test('should return correct rank for user', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 50,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n        ]);\n\n        expect(league.getUserRank('user-1'), 1);\n        expect(league.getUserRank('user-2'), 2);\n      });\n\n      test('should return null for non-member', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n        ]);\n\n        expect(league.getUserRank('non-existent'), isNull);\n      });\n\n      test('should return correct rank for tied users', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n        ]);\n\n        // Both tied users should have rank 1\n        expect(league.getUserRank('user-1'), 1);\n        expect(league.getUserRank('user-2'), 1);\n      });\n    });\n\n    group('getUserLeaderboardEntry', () {\n      test('should return full entry for user', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n        ]);\n\n        final entry = league.getUserLeaderboardEntry('user-1');\n\n        expect(entry, isNotNull);\n        expect(entry!.rank, 1);\n        expect(entry.userId, 'user-1');\n        expect(entry.points, 100);\n      });\n\n      test('should return null for non-member', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n        ]);\n\n        expect(league.getUserLeaderboardEntry('non-existent'), isNull);\n      });\n    });\n\n    group('getTopEntries', () {\n      test('should return top N entries', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 80,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n          LeagueMember(\n            userId: 'user-3',\n            role: LeagueMemberRole.member,\n            points: 60,\n            joinedAt: DateTime(2024, 1, 3),\n          ),\n          LeagueMember(\n            userId: 'user-4',\n            role: LeagueMemberRole.member,\n            points: 40,\n            joinedAt: DateTime(2024, 1, 4),\n          ),\n        ]);\n\n        final top2 = league.getTopEntries(2);\n\n        expect(top2.length, 2);\n        expect(top2[0].userId, 'user-1');\n        expect(top2[1].userId, 'user-2');\n      });\n\n      test('should return all entries if count exceeds member count', () {\n        final league = createLeagueWithMembers([\n          LeagueMember(\n            userId: 'user-1',\n            role: LeagueMemberRole.owner,\n            points: 100,\n            joinedAt: DateTime(2024, 1, 1),\n          ),\n          LeagueMember(\n            userId: 'user-2',\n            role: LeagueMemberRole.member,\n            points: 80,\n            joinedAt: DateTime(2024, 1, 2),\n          ),\n        ]);\n\n        final top10 = league.getTopEntries(10);\n\n        expect(top10.length, 2);\n      });\n    });\n  });\n}\n"
}
Now let's run the tests to verify our implementation:

🔧 Tool: Bash
Input: {
  "command": "cd C:/dev/burgerrats && flutter test test/features/leagues/domain/entities/leaderboard_entry_test.dart --reporter=compact 2>&1",
  "description": "Run leaderboard entry tests",
  "timeout": 120000
}

🔧 Tool: Bash
Input: {
  "command": "cd C:/dev/burgerrats && cmd //c \"flutter test test/features/leagues/domain/entities/leaderboard_entry_test.dart --reporter=compact\" 2>&1",
  "description": "Run leaderboard entry tests on Windows",
  "timeout": 120000
}

🔧 Tool: Bash
Input: {
  "command": "where flutter 2>&1 || which flutter 2>&1 || echo \"Flutter not in PATH\"",
  "description": "Find Flutter location"
}
Flutter is not in the PATH. Let me verify the code compiles by checking for syntax errors using Dart analyzer. First, let me check if the analysis passes:

🔧 Tool: Bash
Input: {
  "command": "ls -la /c/Users/marce/flutter 2>/dev/null || ls -la /c/dev/flutter 2>/dev/null || echo \"Checking common locations...\"",
  "description": "Find Flutter SDK location"
}
Since Flutter is not accessible in this environment, let me verify the code correctness by checking the syntax and imports manually. Let me also verify there are no issues with the code:

🔧 Tool: Read
Input: {
  "file_path": "C:\\dev\\burgerrats\\lib\\features\\leagues\\domain\\entities\\leaderboard_entry.dart"
}
The code looks correct. Let me update the todo list and complete the summary:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Analyze existing leaderboard implementation and identify gaps",
      "status": "completed",
      "activeForm": "Analyzing existing leaderboard implementation"
    },
    {
      "content": "Create LeaderboardEntry entity with ranking and tie handling",
      "status": "completed",
      "activeForm": "Creating LeaderboardEntry entity"
    },
    {
      "content": "Create LeaderboardProvider for real-time leaderboard state",
      "status": "completed",
      "activeForm": "Creating LeaderboardProvider"
    },
    {
      "content": "Enhance LeagueEntity with proper ranking methods that handle ties",
      "status": "completed",
      "activeForm": "Enhancing LeagueEntity with tie handling"
    },
    {
      "content": "Update LeagueDetailsPage with real-time leaderboard display",
      "status": "completed",
      "activeForm": "Updating LeagueDetailsPage"
    },
    {
      "content": "Export new files in barrel exports",
      "status": "completed",
      "activeForm": "Exporting new files"
    },
    {
      "content": "Create unit tests for leaderboard calculation",
      "status": "completed",
      "activeForm": "Creating unit tests"
    }
  ]
}
Since Playwright is primarily for web testing and this is a Flutter mobile app, the standard verification approach would be to run Flutter tests. However, since Flutter is not available in the PATH, let me provide a comprehensive summary of the implementation:

<summary>
## Summary: Leaderboard Calculator Feature

### Changes Implemented
1. **Created LeaderboardEntry Entity** (`lib/features/leagues/domain/entities/leaderboard_entry.dart`)
   - New entity class that wraps `LeagueMember` with ranking metadata
   - Includes `rank`, `isTied`, and `checkInCount` properties
   - Added `LeagueLeaderboardExtension` on `LeagueEntity` for ranking calculations

2. **Implemented Tie Handling Algorithm**
   - Members with equal points share the same rank (e.g., 1st, 1st, 3rd)
   - Secondary sort by join date (earlier joiners appear first in ties)
   - `isTied` flag marks entries tied with the previous entry

3. **Created Leaderboard Provider** (`lib/features/leagues/presentation/providers/leaderboard_provider.dart`)
   - `leagueLeaderboardStreamProvider`: Real-time leaderboard updates via Firestore streams
   - `leagueStreamProvider`: Real-time league data
   - `userRankInLeagueProvider`: Get a user's rank in a specific league
   - `userLeagueRankingsProvider`: Get user's rankings across all their leagues
   - `UserLeagueRanking`: Helper class with formatted rank display (1st, 2nd, 3rd, etc.)

4. **Updated LeagueDetailsPage** (`lib/features/leagues/presentation/pages/league_details_page.dart`)
   - Changed from `StatelessWidget` to `ConsumerWidget` for Riverpod integration
   - Real-time leaderboard display using stream providers
   - Medal badges for top 3 (gold, silver, bronze)
   - Points badge for each member
   - Tie indicator showing when members share the same rank
   - Loading, empty, and error states
   - Pull-to-refresh functionality

5. **Real-Time Updates**
   - Leaderboard automatically refreshes when check-ins are submitted
   - Uses existing `watchLeague()` stream from `LeagueRepository`
   - Points are added via `addMemberPoints()` in `CreateCheckInNotifier.submitCheckIn()`

### Files Modified
- `lib/features/leagues/domain/entities/entities.dart` (added export)
- `lib/features/leagues/presentation/presentation.dart` (added export)
- `lib/features/leagues/presentation/pages/league_details_page.dart` (complete rewrite)

### Files Created
- `lib/features/leagues/domain/entities/leaderboard_entry.dart`
- `lib/features/leagues/presentation/providers/leaderboard_provider.dart`
- `test/features/leagues/domain/entities/leaderboard_entry_test.dart`

### Notes for Developer
- **Flutter Not in PATH**: Tests could not be run automatically. Please run `flutter test test/features/leagues/domain/entities/leaderboard_entry_test.dart` manually to verify the tie handling logic.
- **Real-Time Flow**: When a user submits a check-in, the flow is:
  1. Check-in created in Firestore
  2. Points added via `addMemberPoints()` in the league document
  3. Firestore triggers `watchLeague()` stream update
  4. `leagueLeaderboardStreamProvider` automatically recalculates rankings
  5. UI rebuilds with new leaderboard
- **Tie Handling**: Example ranking - if 3 users have 100pts and 2 have 50pts: 1st, 1st, 1st, 4th, 4th
- **User Display**: Currently shows truncated user IDs (`User abc12345...`). In a real implementation, you may want to fetch user display names from a users collection.

### Verification Status
- Unit tests created for leaderboard calculation with comprehensive tie handling scenarios
- Flutter not available in PATH - manual test execution required: `flutter test test/features/leagues/domain/entities/leaderboard_entry_test.dart`
- Playwright verification not applicable for Flutter mobile app (Playwright is for web testing)
</summary>