
🔧 Tool: Task
Input: {
  "description": "Explore codebase structure",
  "prompt": "Explore this Flutter codebase to understand:\n1. The overall project structure\n2. Existing patterns for repositories, models, and services\n3. How Firebase/Firestore is configured\n4. The existing User model if any\n5. Any existing repository implementations\n6. The dependency injection setup\n\nFocus on finding patterns that should be followed for implementing a UserRepository for Firestore CRUD operations.",
  "subagent_type": "Explore"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats -type f -name \"*.dart\" | head -30",
  "description": "Find Dart files in the project"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
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
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/entities/user_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/models/user_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/repositories/auth_repository_impl.dart"
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
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/utils/typedefs.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features -type f -name \"*.dart\" | grep -E \"(model|entity|repository)\" | head -20",
  "description": "Find model, entity, and repository files"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/*/data/models/*.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/*/domain/repositories/*.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features/leagues -type f -name \"*.dart\" 2>/dev/null",
  "description": "Find league feature files"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/features/check_ins -type f -name \"*.dart\" 2>/dev/null",
  "description": "Find check-ins feature files"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/",
  "description": "List feature directories"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/models/models.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/entities/entities.dart"
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
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/photo_capture_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/error_handler.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/core/",
  "description": "List core module directories"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/core.dart"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib/features/auth/",
  "description": "List auth feature subdirectories"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/auth/data/models/user_model_test.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/auth/domain/entities/user_entity_test.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/auth.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/features.dart"
}
Now I have a comprehensive understanding of the codebase. Let me create a task list and implement the UserRepository.

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "pending",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "pending",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "pending",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "pending",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "pending",
      "activeForm": "Creating and running verification test"
    }
  ]
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "in_progress",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "pending",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "pending",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "pending",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "pending",
      "activeForm": "Creating and running verification test"
    }
  ]
}
Let me read the existing auth repository interface and user entity to follow the patterns:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/auth_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/entities/user_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/models/user_model.dart"
}
Now let me check the existing repository barrel export and auth_repository_impl:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/repositories/auth_repository_impl.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/auth/**/repositories/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}
Now I have all the context I need. Let me create the abstract UserRepository interface first:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/repositories/user_repository.dart",
  "content": "import '../entities/user_entity.dart';\n\n/// Abstract repository for user CRUD operations in Firestore\n///\n/// This interface defines the contract for user profile management.\n/// Implementations handle persistence and sync with authentication.\nabstract class UserRepository {\n  /// Creates a new user document in Firestore\n  ///\n  /// Should be called after successful authentication to initialize\n  /// the user's profile document.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<void> createUser(UserEntity user);\n\n  /// Retrieves a user by their unique ID\n  ///\n  /// Returns the user entity if found, null if not found.\n  /// Throws [FirestoreException] on failure\n  Future<UserEntity?> getUserById(String uid);\n\n  /// Updates an existing user's profile data\n  ///\n  /// Only updates mutable fields (displayName, photoURL, statistics).\n  /// Does not modify uid or createdAt.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<void> updateUser(UserEntity user);\n\n  /// Deletes a user document from Firestore\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<void> deleteUser(String uid);\n\n  /// Checks if a user document exists in Firestore\n  ///\n  /// Returns true if the user document exists, false otherwise.\n  /// Throws [FirestoreException] on failure\n  Future<bool> userExists(String uid);\n\n  /// Stream of user data changes for real-time updates\n  ///\n  /// Emits the current user data and subsequent changes.\n  /// Emits null if the user document doesn't exist.\n  Stream<UserEntity?> watchUser(String uid);\n\n  /// Creates a user document if it doesn't exist, or returns existing\n  ///\n  /// This is useful for syncing authentication with Firestore on login.\n  /// If the document exists, returns the existing user data.\n  /// If not, creates a new document with the provided user data.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<UserEntity> createUserIfNotExists(UserEntity user);\n\n  /// Updates specific fields of a user document\n  ///\n  /// Use this for partial updates when you don't have the full user entity.\n  /// Only the provided fields will be updated.\n  ///\n  /// Throws [FirestoreException] on failure\n  Future<void> updateUserFields(String uid, Map<String, dynamic> fields);\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "completed",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "in_progress",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "pending",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "pending",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "pending",
      "activeForm": "Creating and running verification test"
    }
  ]
}
Now let me create the UserRepository implementation:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/repositories/user_repository_impl.dart",
  "content": "import 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../../../../core/errors/exceptions.dart';\nimport '../../../../core/utils/typedefs.dart';\nimport '../../domain/entities/user_entity.dart';\nimport '../../domain/repositories/user_repository.dart';\nimport '../models/user_model.dart';\n\n/// Implementation of [UserRepository] using Cloud Firestore\n///\n/// This class is registered as a lazy singleton with injectable,\n/// meaning it will be created when first accessed and reused thereafter.\n@LazySingleton(as: UserRepository)\nclass UserRepositoryImpl implements UserRepository {\n  final FirebaseFirestore _firestore;\n\n  /// Collection reference for users\n  static const String _usersCollection = 'users';\n\n  UserRepositoryImpl(this._firestore);\n\n  /// Gets the users collection reference\n  CollectionReference<Json> get _usersRef =>\n      _firestore.collection(_usersCollection);\n\n  /// Gets a document reference for a specific user\n  DocumentReference<Json> _userDoc(String uid) => _usersRef.doc(uid);\n\n  @override\n  Future<void> createUser(UserEntity user) async {\n    try {\n      final userModel = UserModel.fromEntity(user);\n      await _userDoc(user.uid).set(userModel.toJson());\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to create user: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Future<UserEntity?> getUserById(String uid) async {\n    try {\n      final doc = await _userDoc(uid).get();\n      if (!doc.exists || doc.data() == null) {\n        return null;\n      }\n      return UserModel.fromFirestore(doc).toEntity();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to get user: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Future<void> updateUser(UserEntity user) async {\n    try {\n      final userModel = UserModel.fromEntity(user);\n      await _userDoc(user.uid).update(userModel.toJsonForUpdate());\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to update user: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Future<void> deleteUser(String uid) async {\n    try {\n      await _userDoc(uid).delete();\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to delete user: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Future<bool> userExists(String uid) async {\n    try {\n      final doc = await _userDoc(uid).get();\n      return doc.exists;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to check user existence: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Stream<UserEntity?> watchUser(String uid) {\n    return _userDoc(uid).snapshots().map((doc) {\n      if (!doc.exists || doc.data() == null) {\n        return null;\n      }\n      return UserModel.fromFirestore(doc).toEntity();\n    }).handleError((error, stackTrace) {\n      if (error is FirebaseException) {\n        throw FirestoreException(\n          message: 'Failed to watch user: ${error.message}',\n          code: error.code,\n          originalError: error,\n          stackTrace: stackTrace,\n        );\n      }\n      throw error;\n    });\n  }\n\n  @override\n  Future<UserEntity> createUserIfNotExists(UserEntity user) async {\n    try {\n      final existingUser = await getUserById(user.uid);\n      if (existingUser != null) {\n        return existingUser;\n      }\n      await createUser(user);\n      return user;\n    } on FirestoreException {\n      rethrow;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to create or get user: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n\n  @override\n  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {\n    try {\n      await _userDoc(uid).update(fields);\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to update user fields: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "completed",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "completed",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "in_progress",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "pending",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "pending",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "pending",
      "activeForm": "Creating and running verification test"
    }
  ]
}
Now let me check the barrel files to add the exports:

🔧 Tool: Glob
Input: {
  "pattern": "lib/features/auth/**/*.dart"
}
Let me read the barrel files that need updates:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/domain.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/data.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/auth.dart"
}
Let me add the exports to the barrel files:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/domain/domain.dart",
  "old_string": "// Domain layer barrel export\nexport 'entities/entities.dart';\nexport 'repositories/auth_repository.dart';",
  "new_string": "// Domain layer barrel export\nexport 'entities/entities.dart';\nexport 'repositories/auth_repository.dart';\nexport 'repositories/user_repository.dart';"
}

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/auth/data/data.dart",
  "old_string": "// Data layer barrel export\nexport 'models/models.dart';\nexport 'repositories/auth_repository_impl.dart';",
  "new_string": "// Data layer barrel export\nexport 'models/models.dart';\nexport 'repositories/auth_repository_impl.dart';\nexport 'repositories/user_repository_impl.dart';"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "completed",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "completed",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "completed",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "in_progress",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "pending",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "pending",
      "activeForm": "Creating and running verification test"
    }
  ]
}
Now let me run the build_runner to regenerate the DI config:

🔧 Tool: Bash
Input: {
  "command": "flutter pub run build_runner build --delete-conflicting-outputs",
  "description": "Run build_runner to regenerate DI config",
  "timeout": 120000
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "completed",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "completed",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "completed",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "in_progress",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "pending",
      "activeForm": "Creating and running verification test"
    }
  ]
}
Let me verify the DI config was updated correctly and then run the Flutter analyze:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart"
}
The DI config was updated correctly - I can see `UserRepository` is now registered (lines 50-52). Now let me run Flutter analyze to verify everything compiles:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/features/auth/",
  "description": "Run Flutter analyze on auth feature"
}
Let me also verify the implementation compiles by running a broader analyze:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze",
  "description": "Run Flutter analyze on entire project",
  "timeout": 120000
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "completed",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "completed",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "completed",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "completed",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run Playwright verification test",
      "status": "in_progress",
      "activeForm": "Creating and running verification test"
    }
  ]
}
Now I need to verify the feature. This is a Flutter/Dart project (not a web app), so Playwright is not the appropriate testing tool. Instead, I should create a Flutter unit test to verify the UserRepository implementation. Let me check how tests are structured in this project:

🔧 Tool: Glob
Input: {
  "pattern": "test/features/auth/**/*.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/auth/data/models/user_model_test.dart"
}
Now let me create a verification test for the UserRepository. Since Playwright is for web testing and this is a Flutter project, I'll create a Flutter unit test for verification:

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/auth/data/repositories/user_repository_impl_verification_test.dart",
  "content": "import 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:fake_cloud_firestore/fake_cloud_firestore.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/features/auth/data/repositories/user_repository_impl.dart';\nimport 'package:burgerrats/features/auth/domain/entities/user_entity.dart';\nimport 'package:burgerrats/features/auth/domain/repositories/user_repository.dart';\nimport 'package:burgerrats/core/errors/exceptions.dart';\n\n/// Temporary verification test for UserRepository feature\n/// This test verifies the UserRepository implementation works correctly\nvoid main() {\n  late FakeFirebaseFirestore fakeFirestore;\n  late UserRepository userRepository;\n\n  setUp(() {\n    fakeFirestore = FakeFirebaseFirestore();\n    userRepository = UserRepositoryImpl(fakeFirestore);\n  });\n\n  group('UserRepository Verification Tests', () {\n    final testUser = UserEntity(\n      uid: 'test-user-123',\n      email: 'test@example.com',\n      displayName: 'Test User',\n      photoURL: 'https://example.com/photo.jpg',\n      createdAt: DateTime(2024, 1, 15),\n      statistics: const UserStatistics(\n        totalCheckIns: 5,\n        totalReviews: 3,\n        uniqueRestaurants: 4,\n        badgesEarned: 2,\n        leagueRank: 10,\n        leaguePoints: 100,\n      ),\n    );\n\n    test('createUser - should create user document in Firestore', () async {\n      await userRepository.createUser(testUser);\n\n      final doc = await fakeFirestore.collection('users').doc(testUser.uid).get();\n      expect(doc.exists, true);\n      expect(doc.data()?['email'], testUser.email);\n      expect(doc.data()?['displayName'], testUser.displayName);\n      expect(doc.data()?['photoURL'], testUser.photoURL);\n      expect(doc.data()?['statistics']['totalCheckIns'], 5);\n    });\n\n    test('getUserById - should return user when exists', () async {\n      await userRepository.createUser(testUser);\n\n      final result = await userRepository.getUserById(testUser.uid);\n\n      expect(result, isNotNull);\n      expect(result?.uid, testUser.uid);\n      expect(result?.email, testUser.email);\n      expect(result?.displayName, testUser.displayName);\n      expect(result?.statistics.totalCheckIns, 5);\n    });\n\n    test('getUserById - should return null when user does not exist', () async {\n      final result = await userRepository.getUserById('non-existent-uid');\n\n      expect(result, isNull);\n    });\n\n    test('updateUser - should update user fields', () async {\n      await userRepository.createUser(testUser);\n\n      final updatedUser = testUser.copyWith(\n        displayName: 'Updated Name',\n        photoURL: 'https://example.com/new-photo.jpg',\n      );\n      await userRepository.updateUser(updatedUser);\n\n      final result = await userRepository.getUserById(testUser.uid);\n      expect(result?.displayName, 'Updated Name');\n      expect(result?.photoURL, 'https://example.com/new-photo.jpg');\n    });\n\n    test('deleteUser - should remove user document', () async {\n      await userRepository.createUser(testUser);\n      expect(await userRepository.userExists(testUser.uid), true);\n\n      await userRepository.deleteUser(testUser.uid);\n\n      expect(await userRepository.userExists(testUser.uid), false);\n    });\n\n    test('userExists - should return true when user exists', () async {\n      await userRepository.createUser(testUser);\n\n      final exists = await userRepository.userExists(testUser.uid);\n\n      expect(exists, true);\n    });\n\n    test('userExists - should return false when user does not exist', () async {\n      final exists = await userRepository.userExists('non-existent-uid');\n\n      expect(exists, false);\n    });\n\n    test('createUserIfNotExists - should create new user when not exists', () async {\n      final result = await userRepository.createUserIfNotExists(testUser);\n\n      expect(result.uid, testUser.uid);\n      expect(result.email, testUser.email);\n      expect(await userRepository.userExists(testUser.uid), true);\n    });\n\n    test('createUserIfNotExists - should return existing user when exists', () async {\n      await userRepository.createUser(testUser);\n\n      final existingUser = testUser.copyWith(displayName: 'Different Name');\n      final result = await userRepository.createUserIfNotExists(existingUser);\n\n      // Should return the original user, not the one passed in\n      expect(result.displayName, testUser.displayName);\n    });\n\n    test('updateUserFields - should update only specified fields', () async {\n      await userRepository.createUser(testUser);\n\n      await userRepository.updateUserFields(testUser.uid, {\n        'displayName': 'Partial Update',\n      });\n\n      final result = await userRepository.getUserById(testUser.uid);\n      expect(result?.displayName, 'Partial Update');\n      // Other fields should remain unchanged\n      expect(result?.email, testUser.email);\n      expect(result?.photoURL, testUser.photoURL);\n    });\n\n    test('watchUser - should emit user data changes', () async {\n      await userRepository.createUser(testUser);\n\n      final stream = userRepository.watchUser(testUser.uid);\n\n      await expectLater(\n        stream.take(1),\n        emits(predicate<UserEntity?>((user) =>\n          user != null &&\n          user.uid == testUser.uid &&\n          user.email == testUser.email\n        )),\n      );\n    });\n\n    test('watchUser - should emit null for non-existent user', () async {\n      final stream = userRepository.watchUser('non-existent-uid');\n\n      await expectLater(\n        stream.take(1),\n        emits(isNull),\n      );\n    });\n\n    test('CRUD roundtrip - full lifecycle test', () async {\n      // Create\n      await userRepository.createUser(testUser);\n      var result = await userRepository.getUserById(testUser.uid);\n      expect(result?.email, testUser.email);\n\n      // Read\n      expect(await userRepository.userExists(testUser.uid), true);\n\n      // Update\n      final updatedUser = testUser.copyWith(\n        displayName: 'Roundtrip Updated',\n        statistics: const UserStatistics(\n          totalCheckIns: 10,\n          totalReviews: 5,\n        ),\n      );\n      await userRepository.updateUser(updatedUser);\n      result = await userRepository.getUserById(testUser.uid);\n      expect(result?.displayName, 'Roundtrip Updated');\n      expect(result?.statistics.totalCheckIns, 10);\n\n      // Delete\n      await userRepository.deleteUser(testUser.uid);\n      expect(await userRepository.userExists(testUser.uid), false);\n      result = await userRepository.getUserById(testUser.uid);\n      expect(result, isNull);\n    });\n  });\n}\n"
}
Now I need to check if the fake_cloud_firestore package is available. Let me check the pubspec.yaml:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}
I need to add the `fake_cloud_firestore` package to dev_dependencies:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml",
  "old_string": "dev_dependencies:\n  flutter_test:\n    sdk: flutter\n\n  # The \"flutter_lints\" package below contains a set of recommended lints to\n  # encourage good coding practices. The lint set provided by the package is\n  # activated in the `analysis_options.yaml` file located at the root of your\n  # package. See that file for information about deactivating specific lint\n  # rules and activating additional ones.\n  flutter_lints: ^6.0.0\n\n  # Code generation for injectable and riverpod\n  build_runner: ^2.4.15\n  injectable_generator: ^2.6.3\n  riverpod_generator: ^2.6.3\n  custom_lint: ^0.7.0\n  riverpod_lint: ^2.6.3",
  "new_string": "dev_dependencies:\n  flutter_test:\n    sdk: flutter\n\n  # The \"flutter_lints\" package below contains a set of recommended lints to\n  # encourage good coding practices. The lint set provided by the package is\n  # activated in the `analysis_options.yaml` file located at the root of your\n  # package. See that file for information about deactivating specific lint\n  # rules and activating additional ones.\n  flutter_lints: ^6.0.0\n\n  # Code generation for injectable and riverpod\n  build_runner: ^2.4.15\n  injectable_generator: ^2.6.3\n  riverpod_generator: ^2.6.3\n  custom_lint: ^0.7.0\n  riverpod_lint: ^2.6.3\n\n  # Testing - Fake Firestore for unit tests\n  fake_cloud_firestore: ^3.1.0"
}

🔧 Tool: Bash
Input: {
  "command": "flutter pub get",
  "description": "Get Flutter dependencies",
  "timeout": 120000
}
Now let me run the verification tests:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/features/auth/data/repositories/user_repository_impl_verification_test.dart",
  "description": "Run UserRepository verification tests",
  "timeout": 120000
}
All 13 tests passed. Now let me delete the verification test file as instructed:

🔧 Tool: Bash
Input: {
  "command": "rm /Users/marcelo/dev/burgerrats/test/features/auth/data/repositories/user_repository_impl_verification_test.dart",
  "description": "Delete verification test file"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create abstract UserRepository interface in domain layer",
      "status": "completed",
      "activeForm": "Creating abstract UserRepository interface"
    },
    {
      "content": "Create UserRepository implementation with Firestore CRUD",
      "status": "completed",
      "activeForm": "Creating UserRepository implementation"
    },
    {
      "content": "Export UserRepository in barrel files",
      "status": "completed",
      "activeForm": "Exporting UserRepository in barrel files"
    },
    {
      "content": "Run build_runner to regenerate DI config",
      "status": "completed",
      "activeForm": "Running build_runner"
    },
    {
      "content": "Verify implementation compiles without errors",
      "status": "completed",
      "activeForm": "Verifying implementation"
    },
    {
      "content": "Create and run verification test",
      "status": "completed",
      "activeForm": "Creating and running verification test"
    }
  ]
}
<summary>
## Summary: User Repository for Firestore CRUD Operations

### Changes Implemented
- Created abstract `UserRepository` interface in domain layer with complete CRUD operations contract
- Implemented `UserRepositoryImpl` with Cloud Firestore backend supporting:
  - `createUser()` - Create user documents in Firestore
  - `getUserById()` - Retrieve user by UID
  - `updateUser()` - Update user profile (excludes immutable fields)
  - `deleteUser()` - Remove user document
  - `userExists()` - Check if user document exists
  - `watchUser()` - Real-time stream of user data changes
  - `createUserIfNotExists()` - Sync auth with Firestore on login
  - `updateUserFields()` - Partial field updates
- Proper error handling converting `FirebaseException` to `FirestoreException`
- Registered as `@LazySingleton` with dependency injection (GetIt + Injectable)
- Integrated with existing `UserModel`/`UserEntity` pattern for serialization

### Files Modified
- `lib/features/auth/domain/repositories/user_repository.dart` (new)
- `lib/features/auth/data/repositories/user_repository_impl.dart` (new)
- `lib/features/auth/domain/domain.dart` (added export)
- `lib/features/auth/data/data.dart` (added export)
- `lib/core/di/injection.config.dart` (auto-regenerated)
- `pubspec.yaml` (added fake_cloud_firestore for testing)

### Notes for Developer
- The repository uses the `users` collection in Firestore with document ID = Firebase Auth UID
- Use `toJsonForUpdate()` for updates to avoid overwriting `uid` and `createdAt`
- Access via DI: `getIt<UserRepository>()` or inject via constructor
- The `watchUser()` stream is useful for reactive UI updates
- Error handling converts all Firebase errors to `FirestoreException` for consistent error boundaries

### Verification Status
- Created comprehensive Flutter unit test with `fake_cloud_firestore` package
- All 13 test cases passed covering:
  - Create, Read, Update, Delete operations
  - User existence check
  - Stream-based user watching
  - Create-if-not-exists pattern
  - Partial field updates
  - Full CRUD roundtrip lifecycle
- Test file deleted after successful verification as requested
</summary>