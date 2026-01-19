
🔧 Tool: Task
Input: {
  "subagent_type": "Explore",
  "prompt": "Explore this Flutter codebase to understand:\n1. The overall project structure\n2. How check-ins are currently implemented (models, repositories, services)\n3. How leagues work in the system\n4. Any existing validation patterns used\n5. The dependency injection setup\n\nFocus on finding:\n- Check-in related files (models, repositories)\n- League related files\n- Validation patterns\n- How dates are handled for check-ins\n\nBe thorough and provide file paths with relevant code snippets.",
  "description": "Explore codebase structure"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats -type f -name \"*.dart\" | head -20",
  "description": "Find all Dart files in the project"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib -type d | sort",
  "description": "List all directories in lib folder"
}

🔧 Tool: Glob
Input: {
  "pattern": "**/*.dart",
  "path": "/Users/marcelo/dev/burgerrats/lib"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/domain/entities/check_in_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/data/models/check_in_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/data/repositories/check_in_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/domain/repositories/check_in_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/entities/league_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/models/league_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/repositories/league_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/repositories/league_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart",
  "limit": 100
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/failures.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/register_module.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/photo_capture_service.dart"
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
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/check_ins/data/models/check_in_model_test.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/models/league_model_test.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/utils/typedefs.dart"
}

🔧 Tool: Grep
Input: {
  "pattern": "validator|validation|valid",
  "glob": "**/*.dart",
  "path": "/Users/marcelo/dev/burgerrats/lib",
  "output_mode": "files_with_matches",
  "head_limit": 20
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/shared/extensions/string_extensions.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_handler.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_messages.dart"
}
I now have a comprehensive understanding of the codebase. The daily limit validation feature is already partially implemented in the check-in repository. Let me examine the current implementation and identify what needs to be enhanced to validate that users can only check-in once per day **per league**.

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/domain/repositories/check_in_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/data/repositories/check_in_repository_impl.dart"
}
Now I understand the current implementation. The existing code validates if a user can check-in today globally (across all leagues), but the requirement is to validate **once per day per league**. Let me also check the error messages to see what's already defined:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_messages.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}
Now let me also check if there are any existing tests for the check-in repository to understand the test patterns:

🔧 Tool: Glob
Input: {
  "pattern": "test/features/check_ins/**/*.dart"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add league-specific daily check-in validation methods to CheckInRepository interface",
      "status": "in_progress",
      "activeForm": "Adding league-specific daily validation methods to interface"
    },
    {
      "content": "Implement league-specific daily check-in validation in CheckInRepositoryImpl",
      "status": "pending",
      "activeForm": "Implementing league-specific daily check-in validation"
    },
    {
      "content": "Add unit tests for the new daily limit validator functionality",
      "status": "pending",
      "activeForm": "Adding unit tests for daily limit validator"
    },
    {
      "content": "Verify feature with Playwright test",
      "status": "pending",
      "activeForm": "Verifying feature with Playwright test"
    }
  ]
}
Now I'll implement the daily limit validator feature. The current implementation validates if a user can check-in today globally, but the requirement is to validate **once per day per league**. I need to:

1. Update the repository interface with league-specific validation methods
2. Implement the league-specific validation in the repository
3. Add unit tests

Let me start by updating the repository interface:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/domain/repositories/check_in_repository.dart",
  "old_string": "  /// Gets the count of check-ins a user has made today\n  ///\n  /// Used for validating daily check-in limits.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<int> getUserDailyCheckInCount(String userId);\n\n  /// Validates if a user can make a new check-in today\n  ///\n  /// Returns true if the user hasn't exceeded the daily limit (1 per day).\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<bool> canUserCheckInToday(String userId);",
  "new_string": "  /// Gets the count of check-ins a user has made today\n  ///\n  /// Used for validating daily check-in limits.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<int> getUserDailyCheckInCount(String userId);\n\n  /// Validates if a user can make a new check-in today\n  ///\n  /// Returns true if the user hasn't exceeded the daily limit (1 per day).\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<bool> canUserCheckInToday(String userId);\n\n  /// Gets the count of check-ins a user has made today in a specific league\n  ///\n  /// Used for validating daily check-in limits per league.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<int> getUserDailyCheckInCountForLeague(String userId, String leagueId);\n\n  /// Validates if a user can make a new check-in today in a specific league\n  ///\n  /// Returns true if the user hasn't checked in today for this specific league.\n  /// Each user is limited to one check-in per day per league.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<bool> canUserCheckInTodayForLeague(String userId, String leagueId);\n\n  /// Gets the user's check-in for today in a specific league, if it exists\n  ///\n  /// Returns the check-in entity if the user has already checked in today\n  /// for this league, or null if they haven't.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<CheckInEntity?> getUserTodayCheckInForLeague(\n    String userId,\n    String leagueId,\n  );"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add league-specific daily check-in validation methods to CheckInRepository interface",
      "status": "completed",
      "activeForm": "Adding league-specific daily validation methods to interface"
    },
    {
      "content": "Implement league-specific daily check-in validation in CheckInRepositoryImpl",
      "status": "in_progress",
      "activeForm": "Implementing league-specific daily check-in validation"
    },
    {
      "content": "Add unit tests for the new daily limit validator functionality",
      "status": "pending",
      "activeForm": "Adding unit tests for daily limit validator"
    },
    {
      "content": "Verify feature with Playwright test",
      "status": "pending",
      "activeForm": "Verifying feature with Playwright test"
    }
  ]
}
Now let me implement these methods in the repository implementation:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/data/repositories/check_in_repository_impl.dart",
  "old_string": "  @override\n  Future<bool> canUserCheckInToday(String userId) async {\n    final count = await getUserDailyCheckInCount(userId);\n    return count < _dailyCheckInLimit;\n  }",
  "new_string": "  @override\n  Future<bool> canUserCheckInToday(String userId) async {\n    final count = await getUserDailyCheckInCount(userId);\n    return count < _dailyCheckInLimit;\n  }\n\n  @override\n  Future<int> getUserDailyCheckInCountForLeague(\n    String userId,\n    String leagueId,\n  ) async {\n    try {\n      final startOfDay = _getStartOfToday();\n      final endOfDay = _getEndOfToday();\n\n      final snapshot = await _checkInsRef\n          .where('userId', isEqualTo: userId)\n          .where('leagueId', isEqualTo: leagueId)\n          .where(\n            'timestamp',\n            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),\n          )\n          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))\n          .count()\n          .get();\n\n      return snapshot.count ?? 0;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get daily check-in count for league: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Future<bool> canUserCheckInTodayForLeague(\n    String userId,\n    String leagueId,\n  ) async {\n    final count = await getUserDailyCheckInCountForLeague(userId, leagueId);\n    return count < _dailyCheckInLimit;\n  }\n\n  @override\n  Future<CheckInEntity?> getUserTodayCheckInForLeague(\n    String userId,\n    String leagueId,\n  ) async {\n    try {\n      final startOfDay = _getStartOfToday();\n      final endOfDay = _getEndOfToday();\n\n      final snapshot = await _checkInsRef\n          .where('userId', isEqualTo: userId)\n          .where('leagueId', isEqualTo: leagueId)\n          .where(\n            'timestamp',\n            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),\n          )\n          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))\n          .limit(1)\n          .get();\n\n      if (snapshot.docs.isEmpty) {\n        return null;\n      }\n\n      return CheckInModel.fromFirestore(snapshot.docs.first).toEntity();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get today\\'s check-in for league: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add league-specific daily check-in validation methods to CheckInRepository interface",
      "status": "completed",
      "activeForm": "Adding league-specific daily validation methods to interface"
    },
    {
      "content": "Implement league-specific daily check-in validation in CheckInRepositoryImpl",
      "status": "completed",
      "activeForm": "Implementing league-specific daily check-in validation"
    },
    {
      "content": "Add unit tests for the new daily limit validator functionality",
      "status": "in_progress",
      "activeForm": "Adding unit tests for daily limit validator"
    },
    {
      "content": "Verify feature with Playwright test",
      "status": "pending",
      "activeForm": "Verifying feature with Playwright test"
    }
  ]
}
Now let me check the existing test file to understand the test patterns:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/check_ins/data/models/check_in_model_test.dart"
}
Now let me check if there's an existing repository test directory:

🔧 Tool: Glob
Input: {
  "pattern": "test/features/check_ins/data/repositories/**/*.dart"
}
Let me check if there are any repository tests in the codebase to understand the patterns used:

🔧 Tool: Glob
Input: {
  "pattern": "test/**/*repository*test*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/repositories/league_repository_impl_test.dart"
}
Now I understand the test patterns. I'll create a test file for the check-in repository focusing on the daily limit validation functionality:

🔧 Tool: Bash
Input: {
  "command": "mkdir -p /Users/marcelo/dev/burgerrats/test/features/check_ins/data/repositories",
  "description": "Create test directories"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/check_ins/data/repositories/check_in_repository_impl_test.dart",
  "content": "import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/features/check_ins/data/repositories/check_in_repository_impl.dart';\nimport 'package:burgerrats/features/check_ins/data/models/check_in_model.dart';\n\nvoid main() {\n  late FakeFirebaseFirestore fakeFirestore;\n  late CheckInRepositoryImpl repository;\n\n  setUp(() {\n    fakeFirestore = FakeFirebaseFirestore();\n    repository = CheckInRepositoryImpl(fakeFirestore);\n  });\n\n  group('CheckInRepositoryImpl', () {\n    group('createCheckIn', () {\n      test('should create a new check-in', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final retrieved = await repository.getCheckInById('checkin-1');\n        expect(retrieved, isNotNull);\n        expect(retrieved!.id, 'checkin-1');\n        expect(retrieved.userId, 'user-123');\n        expect(retrieved.leagueId, 'league-456');\n      });\n    });\n\n    group('getCheckInById', () {\n      test('should return check-in when it exists', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final retrieved = await repository.getCheckInById('checkin-1');\n\n        expect(retrieved, isNotNull);\n        expect(retrieved!.id, 'checkin-1');\n      });\n\n      test('should return null when check-in does not exist', () async {\n        final retrieved = await repository.getCheckInById('non-existent');\n\n        expect(retrieved, isNull);\n      });\n    });\n\n    group('getUserDailyCheckInCount', () {\n      test('should return 0 when user has no check-ins today', () async {\n        final count = await repository.getUserDailyCheckInCount('user-123');\n\n        expect(count, 0);\n      });\n\n      test('should count only todays check-ins', () async {\n        // Create a check-in for today\n        final todayCheckIn = CheckInModel.newCheckIn(\n          id: 'checkin-today',\n          userId: 'user-123',\n          leagueId: 'league-1',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(todayCheckIn);\n\n        final count = await repository.getUserDailyCheckInCount('user-123');\n\n        expect(count, 1);\n      });\n\n      test('should count multiple check-ins for same user today', () async {\n        final checkIn1 = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-1',\n          photoURL: 'https://example.com/photo1.jpg',\n        );\n\n        final checkIn2 = CheckInModel.newCheckIn(\n          id: 'checkin-2',\n          userId: 'user-123',\n          leagueId: 'league-2',\n          photoURL: 'https://example.com/photo2.jpg',\n        );\n\n        await repository.createCheckIn(checkIn1);\n        await repository.createCheckIn(checkIn2);\n\n        final count = await repository.getUserDailyCheckInCount('user-123');\n\n        expect(count, 2);\n      });\n    });\n\n    group('canUserCheckInToday', () {\n      test('should return true when user has no check-ins today', () async {\n        final canCheckIn = await repository.canUserCheckInToday('user-123');\n\n        expect(canCheckIn, true);\n      });\n\n      test('should return false when user has already checked in today', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-1',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final canCheckIn = await repository.canUserCheckInToday('user-123');\n\n        expect(canCheckIn, false);\n      });\n    });\n\n    group('getUserDailyCheckInCountForLeague', () {\n      test('should return 0 when user has no check-ins today for league',\n          () async {\n        final count = await repository.getUserDailyCheckInCountForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(count, 0);\n      });\n\n      test('should return 1 when user has one check-in today for league',\n          () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final count = await repository.getUserDailyCheckInCountForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(count, 1);\n      });\n\n      test('should not count check-ins from other leagues', () async {\n        final checkInLeague1 = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-1',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        final checkInLeague2 = CheckInModel.newCheckIn(\n          id: 'checkin-2',\n          userId: 'user-123',\n          leagueId: 'league-2',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkInLeague1);\n        await repository.createCheckIn(checkInLeague2);\n\n        final countLeague1 = await repository.getUserDailyCheckInCountForLeague(\n          'user-123',\n          'league-1',\n        );\n\n        final countLeague2 = await repository.getUserDailyCheckInCountForLeague(\n          'user-123',\n          'league-2',\n        );\n\n        expect(countLeague1, 1);\n        expect(countLeague2, 1);\n      });\n\n      test('should not count check-ins from other users', () async {\n        final checkInUser1 = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        final checkInUser2 = CheckInModel.newCheckIn(\n          id: 'checkin-2',\n          userId: 'user-456',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkInUser1);\n        await repository.createCheckIn(checkInUser2);\n\n        final countUser1 = await repository.getUserDailyCheckInCountForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        final countUser2 = await repository.getUserDailyCheckInCountForLeague(\n          'user-456',\n          'league-456',\n        );\n\n        expect(countUser1, 1);\n        expect(countUser2, 1);\n      });\n    });\n\n    group('canUserCheckInTodayForLeague', () {\n      test('should return true when user has no check-ins today for league',\n          () async {\n        final canCheckIn = await repository.canUserCheckInTodayForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(canCheckIn, true);\n      });\n\n      test(\n          'should return false when user has already checked in today for league',\n          () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final canCheckIn = await repository.canUserCheckInTodayForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(canCheckIn, false);\n      });\n\n      test(\n          'should return true when user has checked in today but for different league',\n          () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-1',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final canCheckInLeague1 = await repository.canUserCheckInTodayForLeague(\n          'user-123',\n          'league-1',\n        );\n\n        final canCheckInLeague2 = await repository.canUserCheckInTodayForLeague(\n          'user-123',\n          'league-2',\n        );\n\n        expect(canCheckInLeague1, false);\n        expect(canCheckInLeague2, true);\n      });\n\n      test('should allow different users to check in to same league', () async {\n        final checkInUser1 = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkInUser1);\n\n        final canCheckInUser1 = await repository.canUserCheckInTodayForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        final canCheckInUser2 = await repository.canUserCheckInTodayForLeague(\n          'user-456',\n          'league-456',\n        );\n\n        expect(canCheckInUser1, false);\n        expect(canCheckInUser2, true);\n      });\n    });\n\n    group('getUserTodayCheckInForLeague', () {\n      test('should return null when user has no check-in today for league',\n          () async {\n        final checkIn = await repository.getUserTodayCheckInForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(checkIn, isNull);\n      });\n\n      test('should return check-in when user has checked in today for league',\n          () async {\n        final created = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n          note: 'Great burger!',\n          rating: 5,\n        );\n\n        await repository.createCheckIn(created);\n\n        final retrieved = await repository.getUserTodayCheckInForLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(retrieved, isNotNull);\n        expect(retrieved!.id, 'checkin-1');\n        expect(retrieved.userId, 'user-123');\n        expect(retrieved.leagueId, 'league-456');\n        expect(retrieved.note, 'Great burger!');\n        expect(retrieved.rating, 5);\n      });\n\n      test('should not return check-in from different league', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-1',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final retrieved = await repository.getUserTodayCheckInForLeague(\n          'user-123',\n          'league-2',\n        );\n\n        expect(retrieved, isNull);\n      });\n\n      test('should not return check-in from different user', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final retrieved = await repository.getUserTodayCheckInForLeague(\n          'user-456',\n          'league-456',\n        );\n\n        expect(retrieved, isNull);\n      });\n    });\n\n    group('getCheckInsByUserAndLeague', () {\n      test('should return check-ins for user and league', () async {\n        final checkIn1 = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo1.jpg',\n        );\n\n        final checkIn2 = CheckInModel.newCheckIn(\n          id: 'checkin-2',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo2.jpg',\n        );\n\n        final checkIn3 = CheckInModel.newCheckIn(\n          id: 'checkin-3',\n          userId: 'user-123',\n          leagueId: 'league-other',\n          photoURL: 'https://example.com/photo3.jpg',\n        );\n\n        await repository.createCheckIn(checkIn1);\n        await repository.createCheckIn(checkIn2);\n        await repository.createCheckIn(checkIn3);\n\n        final checkIns = await repository.getCheckInsByUserAndLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(checkIns.length, 2);\n        expect(checkIns.every((c) => c.leagueId == 'league-456'), true);\n      });\n\n      test('should return empty list when no check-ins exist', () async {\n        final checkIns = await repository.getCheckInsByUserAndLeague(\n          'user-123',\n          'league-456',\n        );\n\n        expect(checkIns, isEmpty);\n      });\n    });\n\n    group('updateCheckIn', () {\n      test('should update check-in note and rating', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        final updated = checkIn.copyWith(\n          note: 'Updated note',\n          rating: 4,\n        );\n\n        await repository.updateCheckIn(updated);\n\n        final retrieved = await repository.getCheckInById('checkin-1');\n\n        expect(retrieved!.note, 'Updated note');\n        expect(retrieved.rating, 4);\n      });\n    });\n\n    group('deleteCheckIn', () {\n      test('should delete check-in', () async {\n        final checkIn = CheckInModel.newCheckIn(\n          id: 'checkin-1',\n          userId: 'user-123',\n          leagueId: 'league-456',\n          photoURL: 'https://example.com/photo.jpg',\n        );\n\n        await repository.createCheckIn(checkIn);\n\n        await repository.deleteCheckIn('checkin-1');\n\n        final retrieved = await repository.getCheckInById('checkin-1');\n\n        expect(retrieved, isNull);\n      });\n    });\n  });\n}\n"
}
Now let's run the tests to make sure they pass:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/features/check_ins/data/repositories/check_in_repository_impl_test.dart --reporter expanded 2>&1",
  "description": "Run check-in repository tests",
  "timeout": 120000
}
All 24 tests pass. Let me update the todos and check if the project is a Flutter app (which would use Flutter's built-in testing or integration tests rather than Playwright):

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add league-specific daily check-in validation methods to CheckInRepository interface",
      "status": "completed",
      "activeForm": "Adding league-specific daily validation methods to interface"
    },
    {
      "content": "Implement league-specific daily check-in validation in CheckInRepositoryImpl",
      "status": "completed",
      "activeForm": "Implementing league-specific daily check-in validation"
    },
    {
      "content": "Add unit tests for the new daily limit validator functionality",
      "status": "completed",
      "activeForm": "Adding unit tests for daily limit validator"
    },
    {
      "content": "Verify feature with integration test",
      "status": "in_progress",
      "activeForm": "Verifying feature with integration test"
    }
  ]
}
This is a Flutter project, not a web project with Playwright. However, the task requires verification. Let me check if there's any existing test setup:

🔧 Tool: Glob
Input: {
  "pattern": "**/playwright*"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/test-results/ 2>/dev/null || echo \"No test-results directory\"",
  "description": "Check for test-results directory"
}
This is a Flutter mobile app project, not a web app, so Playwright wouldn't be the right tool. However, I noticed the task mentioned Playwright verification. Let me check if there's a web component:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}
This is a pure Flutter mobile application, not a web app, so Playwright testing isn't applicable. The appropriate testing approach for Flutter is:
1. Unit tests (which we've already added)
2. Widget tests
3. Integration tests with Flutter's integration_test package

The unit tests we created comprehensively test the daily limit validator functionality. Since this is a Flutter project without Playwright, let me run all the existing tests to ensure the feature works correctly with the rest of the codebase:

🔧 Tool: Bash
Input: {
  "command": "flutter test 2>&1 | head -100",
  "description": "Run all Flutter tests",
  "timeout": 180000
}
The tests are passing. There's an existing failing test in the leagues repository due to a different issue (the LeagueRepositoryImpl constructor changed to require an inviteCodeService parameter), but that's pre-existing and not related to my changes. 

Let me verify that my implementation compiles correctly and run just my new tests again:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/features/check_ins/ 2>&1",
  "description": "Analyze check-ins code",
  "timeout": 120000
}
Let me also run the check-in related tests to confirm they all pass:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/features/check_ins/ --reporter compact 2>&1",
  "description": "Run check-in tests",
  "timeout": 120000
}
All 57 check-in related tests pass. Let me update the todos to mark completion:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Add league-specific daily check-in validation methods to CheckInRepository interface",
      "status": "completed",
      "activeForm": "Adding league-specific daily validation methods to interface"
    },
    {
      "content": "Implement league-specific daily check-in validation in CheckInRepositoryImpl",
      "status": "completed",
      "activeForm": "Implementing league-specific daily check-in validation"
    },
    {
      "content": "Add unit tests for the new daily limit validator functionality",
      "status": "completed",
      "activeForm": "Adding unit tests for daily limit validator"
    },
    {
      "content": "Verify feature with unit tests (Flutter project - Playwright not applicable)",
      "status": "completed",
      "activeForm": "Verifying feature with unit tests"
    }
  ]
}
Let me verify the final implementation by reading the updated files:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/check_ins/domain/repositories/check_in_repository.dart"
}
<summary>
## Summary: Daily Limit Validator - Validate Once Per Day Per League

### Changes Implemented
- Added 3 new methods to the `CheckInRepository` interface for league-specific daily validation:
  - `getUserDailyCheckInCountForLeague(userId, leagueId)` - Returns count of check-ins a user has made today for a specific league
  - `canUserCheckInTodayForLeague(userId, leagueId)` - Returns true if user hasn't checked in today for the specific league
  - `getUserTodayCheckInForLeague(userId, leagueId)` - Returns the user's check-in for today in a specific league, or null

- Implemented all 3 methods in `CheckInRepositoryImpl` with:
  - Firestore queries filtered by userId, leagueId, and date range (start of day to end of day)
  - Proper error handling with `FirestoreException`
  - Efficient count queries using Firestore's `.count()` aggregation

- Added comprehensive unit tests (24 new tests) covering:
  - Creating and retrieving check-ins
  - Daily check-in count validation globally and per league
  - Validation that users can check-in to different leagues on the same day
  - Validation that different users can check-in to the same league
  - Edge cases for user/league isolation

### Files Modified
- `lib/features/check_ins/domain/repositories/check_in_repository.dart` - Added 3 new method signatures (lines 83-107)
- `lib/features/check_ins/data/repositories/check_in_repository_impl.dart` - Implemented 3 new methods (lines 248-314)

### Files Created
- `test/features/check_ins/data/repositories/check_in_repository_impl_test.dart` - New test file with 24 tests

### Verification Status
- All 57 check-in related tests pass (33 existing + 24 new)
- Flutter analyzer reports no issues in the check-ins feature code
- This is a Flutter mobile project, not a web app, so Playwright testing is not applicable. Unit tests with `fake_cloud_firestore` provide comprehensive verification of the feature.

### Notes for Developer
- The existing global daily limit methods (`getUserDailyCheckInCount`, `canUserCheckInToday`) are preserved for backward compatibility
- Use the new `canUserCheckInTodayForLeague(userId, leagueId)` method before allowing a user to submit a check-in
- The implementation uses efficient Firestore count queries to minimize data transfer
- Error messages for "already checked in" are already defined in `ErrorMessages.alreadyCheckedInToday` (Portuguese: "Você já fez check-in hoje nesta liga.")
</summary>