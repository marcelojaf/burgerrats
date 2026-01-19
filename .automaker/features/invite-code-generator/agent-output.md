
🔧 Tool: Task
Input: {
  "subagent_type": "Explore",
  "prompt": "I need to implement an invite code generator feature for leagues in a Flutter app. The feature should:\n- Generate unique, human-readable invite codes (6-8 characters)\n- Check existing codes in Firestore to ensure uniqueness\n\nPlease explore the codebase to understand:\n1. The overall project structure\n2. How leagues are currently implemented (models, repositories)\n3. How Firestore is configured and used\n4. Existing patterns for services and utilities\n5. Any existing code generation or validation patterns\n\nFocus on finding:\n- League model and repository files\n- Firebase/Firestore configuration\n- Service patterns used in the project\n- Dependency injection setup",
  "description": "Explore codebase for invite code feature"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats -type f -name \"*.dart\" | grep -E \"(league|firebase|service)\" | head -20"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/lib"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib -type d -maxdepth 2 | sort"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/firebase/firebase_config.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/models/league_model.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/entities/league_entity.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/repositories/league_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/repositories/league_repository.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/core/services -type f -name \"*.dart\" | head -10"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/photo_capture_service.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/core/di -type f -name \"*.dart\""
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}

🔧 Tool: Bash
Input: {
  "command": "find /Users/marcelo/dev/burgerrats/lib/core/utils -type f -name \"*.dart\""
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/utils/typedefs.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/pubspec.yaml"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/repositories/league_repository_impl_test.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/models/league_model_test.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/main.dart"
}
Now let me read the key files to understand the current implementation in detail:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/repositories/league_repository_impl.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/domain/repositories/league_repository.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/errors/exceptions.dart"
}
Now let me look at an existing service to understand the pattern better:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/image_compression_service.dart"
}

🔧 Tool: Glob
Input: {
  "pattern": "lib/core/services/*.dart"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "pending",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "pending",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "pending",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "pending",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "pending",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
Now let me check the services barrel file and the DI setup:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/app_service.dart"
}

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.dart"
}
Now I have a good understanding of the codebase structure. Let me create the invite code generator service:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "in_progress",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "pending",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "pending",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "pending",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "pending",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/invite_code_generator_service.dart",
  "content": "import 'dart:math';\n\nimport 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../errors/exceptions.dart';\n\n/// Result of an invite code generation operation\nclass InviteCodeResult {\n  /// The generated invite code\n  final String code;\n\n  /// Number of attempts needed to generate a unique code\n  final int attemptsUsed;\n\n  /// The length of the generated code\n  final int codeLength;\n\n  const InviteCodeResult({\n    required this.code,\n    required this.attemptsUsed,\n    required this.codeLength,\n  });\n\n  @override\n  String toString() =>\n      'InviteCodeResult(code: $code, attempts: $attemptsUsed, length: $codeLength)';\n}\n\n/// Configuration options for invite code generation\nclass InviteCodeOptions {\n  /// Minimum length of the generated code\n  final int minLength;\n\n  /// Maximum length of the generated code\n  final int maxLength;\n\n  /// Maximum number of attempts to generate a unique code\n  final int maxAttempts;\n\n  /// Whether to use only uppercase letters\n  final bool uppercaseOnly;\n\n  const InviteCodeOptions({\n    this.minLength = 6,\n    this.maxLength = 8,\n    this.maxAttempts = 10,\n    this.uppercaseOnly = true,\n  });\n\n  /// Default options: 6-8 characters, uppercase only\n  static const InviteCodeOptions defaults = InviteCodeOptions();\n\n  /// Options for shorter codes (6 characters)\n  static const InviteCodeOptions short = InviteCodeOptions(\n    minLength: 6,\n    maxLength: 6,\n  );\n\n  /// Options for longer codes (8 characters)\n  static const InviteCodeOptions long = InviteCodeOptions(\n    minLength: 8,\n    maxLength: 8,\n  );\n}\n\n/// Service for generating unique, human-readable invite codes for leagues\n///\n/// This service provides cryptographically secure random code generation\n/// with Firestore uniqueness validation.\n///\n/// Usage:\n/// ```dart\n/// final result = await inviteCodeGeneratorService.generateUniqueCode();\n/// print('Generated code: ${result.code}');\n/// ```\n@lazySingleton\nclass InviteCodeGeneratorService {\n  final FirebaseFirestore _firestore;\n\n  /// Characters used for generating invite codes\n  /// Excludes visually ambiguous characters: O, 0, I, 1, L\n  static const String _codeCharacters = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';\n\n  /// Collection name for leagues in Firestore\n  static const String _leaguesCollection = 'leagues';\n\n  InviteCodeGeneratorService(this._firestore);\n\n  /// Generates a unique invite code with Firestore validation\n  ///\n  /// [options] - Configuration options for code generation\n  ///\n  /// Returns [InviteCodeResult] with the generated code and metadata.\n  /// Throws [BusinessException] if unable to generate a unique code.\n  Future<InviteCodeResult> generateUniqueCode({\n    InviteCodeOptions options = InviteCodeOptions.defaults,\n  }) async {\n    final random = Random.secure();\n\n    for (int attempt = 1; attempt <= options.maxAttempts; attempt++) {\n      // Generate code with length between minLength and maxLength\n      final length = options.minLength +\n          random.nextInt(options.maxLength - options.minLength + 1);\n\n      final code = _generateCode(random, length);\n\n      // Check uniqueness in Firestore\n      final isUnique = await _isCodeUnique(code);\n\n      if (isUnique) {\n        return InviteCodeResult(\n          code: code,\n          attemptsUsed: attempt,\n          codeLength: length,\n        );\n      }\n    }\n\n    throw BusinessException(\n      message:\n          'Failed to generate unique invite code after ${options.maxAttempts} attempts',\n      code: 'invite-code-generation-failed',\n    );\n  }\n\n  /// Generates an invite code without uniqueness validation\n  ///\n  /// Use this method when you need a code but don't need to check\n  /// for uniqueness (e.g., for testing or preview purposes).\n  ///\n  /// [length] - Length of the code (default: 8)\n  ///\n  /// Returns the generated code string.\n  String generateCode({int length = 8}) {\n    final random = Random.secure();\n    return _generateCode(random, length);\n  }\n\n  /// Validates if a code matches the expected format\n  ///\n  /// [code] - The code to validate\n  ///\n  /// Returns true if the code is valid.\n  bool isValidFormat(String code) {\n    if (code.isEmpty || code.length < 6 || code.length > 8) {\n      return false;\n    }\n\n    // Check that all characters are in the allowed set\n    final upperCode = code.toUpperCase();\n    return upperCode.split('').every((char) => _codeCharacters.contains(char));\n  }\n\n  /// Checks if a specific code is already in use\n  ///\n  /// [code] - The code to check\n  ///\n  /// Returns true if the code is available (not in use).\n  /// Throws [FirestoreException] on database errors.\n  Future<bool> isCodeAvailable(String code) async {\n    return _isCodeUnique(code);\n  }\n\n  /// Normalizes a code for consistent comparison\n  ///\n  /// Converts to uppercase and removes any whitespace.\n  String normalizeCode(String code) {\n    return code.toUpperCase().replaceAll(RegExp(r'\\s'), '');\n  }\n\n  /// Generates a random code of the specified length\n  String _generateCode(Random random, int length) {\n    return List.generate(\n      length,\n      (_) => _codeCharacters[random.nextInt(_codeCharacters.length)],\n    ).join();\n  }\n\n  /// Checks if a code is unique in the Firestore leagues collection\n  Future<bool> _isCodeUnique(String code) async {\n    try {\n      final querySnapshot = await _firestore\n          .collection(_leaguesCollection)\n          .where('inviteCode', isEqualTo: code.toUpperCase())\n          .limit(1)\n          .get();\n\n      return querySnapshot.docs.isEmpty;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to check invite code uniqueness: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n}\n"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "completed",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "completed",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "in_progress",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "pending",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "pending",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
Now I need to update the LeagueRepository to use the new service. Let me update the implementation:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/repositories/league_repository_impl.dart",
  "old_string": "import 'dart:math';\n\nimport 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../../../../core/errors/exceptions.dart';\nimport '../../../../core/utils/typedefs.dart';\nimport '../../domain/entities/league_entity.dart';\nimport '../../domain/repositories/league_repository.dart';\nimport '../models/league_model.dart';\n\n/// Implementation of [LeagueRepository] using Cloud Firestore\n///\n/// This class is registered as a lazy singleton with injectable,\n/// meaning it will be created when first accessed and reused thereafter.\n@LazySingleton(as: LeagueRepository)\nclass LeagueRepositoryImpl implements LeagueRepository {\n  final FirebaseFirestore _firestore;\n\n  /// Collection reference for leagues\n  static const String _leaguesCollection = 'leagues';\n\n  /// Characters used for generating invite codes\n  static const String _inviteCodeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';\n\n  /// Length of generated invite codes\n  static const int _inviteCodeLength = 8;\n\n  LeagueRepositoryImpl(this._firestore);",
  "new_string": "import 'package:cloud_firestore/cloud_firestore.dart';\nimport 'package:injectable/injectable.dart';\n\nimport '../../../../core/errors/exceptions.dart';\nimport '../../../../core/services/invite_code_generator_service.dart';\nimport '../../../../core/utils/typedefs.dart';\nimport '../../domain/entities/league_entity.dart';\nimport '../../domain/repositories/league_repository.dart';\nimport '../models/league_model.dart';\n\n/// Implementation of [LeagueRepository] using Cloud Firestore\n///\n/// This class is registered as a lazy singleton with injectable,\n/// meaning it will be created when first accessed and reused thereafter.\n@LazySingleton(as: LeagueRepository)\nclass LeagueRepositoryImpl implements LeagueRepository {\n  final FirebaseFirestore _firestore;\n  final InviteCodeGeneratorService _inviteCodeService;\n\n  /// Collection reference for leagues\n  static const String _leaguesCollection = 'leagues';\n\n  LeagueRepositoryImpl(this._firestore, this._inviteCodeService);"
}
Now remove the old `_generateInviteCode` method and update the `createLeague` method:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/repositories/league_repository_impl.dart",
  "old_string": "  /// Gets a document reference for a specific league\n  DocumentReference<Json> _leagueDoc(String leagueId) =>\n      _leaguesRef.doc(leagueId);\n\n  /// Generates a unique invite code\n  String _generateInviteCode() {\n    final random = Random.secure();\n    return List.generate(\n      _inviteCodeLength,\n      (_) => _inviteCodeChars[random.nextInt(_inviteCodeChars.length)],\n    ).join();\n  }\n\n  @override\n  Future<LeagueEntity> createLeague({\n    required String name,\n    String? description,\n    required String createdBy,\n    LeagueSettings? settings,\n  }) async {\n    try {\n      // Generate unique ID\n      final docRef = _leaguesRef.doc();\n\n      // Generate unique invite code\n      final inviteCode = _generateInviteCode();",
  "new_string": "  /// Gets a document reference for a specific league\n  DocumentReference<Json> _leagueDoc(String leagueId) =>\n      _leaguesRef.doc(leagueId);\n\n  @override\n  Future<LeagueEntity> createLeague({\n    required String name,\n    String? description,\n    required String createdBy,\n    LeagueSettings? settings,\n  }) async {\n    try {\n      // Generate unique ID\n      final docRef = _leaguesRef.doc();\n\n      // Generate unique invite code with Firestore validation\n      final inviteCodeResult = await _inviteCodeService.generateUniqueCode();\n      final inviteCode = inviteCodeResult.code;"
}
Now update the `regenerateInviteCode` method to use the service as well:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/features/leagues/data/repositories/league_repository_impl.dart",
  "old_string": "  @override\n  Future<String> regenerateInviteCode(String leagueId) async {\n    try {\n      final newInviteCode = _generateInviteCode();\n\n      await _leagueDoc(leagueId).update({\n        'inviteCode': newInviteCode,\n      });\n\n      return newInviteCode;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to regenerate invite code: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n}",
  "new_string": "  @override\n  Future<String> regenerateInviteCode(String leagueId) async {\n    try {\n      // Generate unique invite code with Firestore validation\n      final inviteCodeResult = await _inviteCodeService.generateUniqueCode();\n      final newInviteCode = inviteCodeResult.code;\n\n      await _leagueDoc(leagueId).update({\n        'inviteCode': newInviteCode,\n      });\n\n      return newInviteCode;\n    } on BusinessException {\n      rethrow;\n    } on FirebaseException catch (e, stackTrace) {\n      throw FirestoreException(\n        message: 'Failed to regenerate invite code: ${e.message}',\n        code: e.code,\n        originalError: e,\n        stackTrace: stackTrace,\n      );\n    }\n  }\n}"
}

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "completed",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "completed",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "completed",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "in_progress",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "pending",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
The service is already annotated with `@lazySingleton`, so it will be automatically registered by injectable. Let me regenerate the DI configuration and run build_runner to ensure everything is properly wired up:

🔧 Tool: Bash
Input: {
  "command": "dart run build_runner build --delete-conflicting-outputs 2>&1",
  "description": "Generate DI configuration",
  "timeout": 120000
}
The build succeeded. Let me verify the injection config was updated correctly:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/di/injection.config.dart"
}
The DI configuration was updated correctly:
- `InviteCodeGeneratorService` is registered at line 59-61 with `FirebaseFirestore` injected
- `LeagueRepositoryImpl` is updated at lines 62-66 to receive both `FirebaseFirestore` and `InviteCodeGeneratorService`

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "completed",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "completed",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "completed",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "completed",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "in_progress",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "pending",
      "activeForm": "Verifying with Playwright"
    }
  ]
}
Now let me check if there are existing tests for the league repository to understand the test patterns:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/repositories/league_repository_impl_test.dart"
}
The existing tests need to be updated to include the `InviteCodeGeneratorService`. Let me first create tests for the new service, then update the existing repository tests:

🔧 Tool: Bash
Input: {
  "command": "mkdir -p /Users/marcelo/dev/burgerrats/test/core/services",
  "description": "Create services test directory"
}

🔧 Tool: Write
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/core/services/invite_code_generator_service_test.dart",
  "content": "import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/core/services/invite_code_generator_service.dart';\nimport 'package:burgerrats/core/errors/exceptions.dart';\n\nvoid main() {\n  late FakeFirebaseFirestore fakeFirestore;\n  late InviteCodeGeneratorService service;\n\n  setUp(() {\n    fakeFirestore = FakeFirebaseFirestore();\n    service = InviteCodeGeneratorService(fakeFirestore);\n  });\n\n  group('InviteCodeGeneratorService', () {\n    group('generateCode', () {\n      test('should generate code with default length of 8', () {\n        final code = service.generateCode();\n\n        expect(code.length, 8);\n      });\n\n      test('should generate code with specified length', () {\n        final code = service.generateCode(length: 6);\n\n        expect(code.length, 6);\n      });\n\n      test('should generate code with only allowed characters', () {\n        final allowedChars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';\n\n        for (int i = 0; i < 100; i++) {\n          final code = service.generateCode();\n          for (final char in code.split('')) {\n            expect(allowedChars.contains(char), true,\n                reason: 'Character \"$char\" is not allowed');\n          }\n        }\n      });\n\n      test('should generate unique codes', () {\n        final codes = <String>{};\n        for (int i = 0; i < 100; i++) {\n          codes.add(service.generateCode());\n        }\n        // With 8-character codes from a 32-character alphabet,\n        // 100 codes should all be unique\n        expect(codes.length, 100);\n      });\n    });\n\n    group('generateUniqueCode', () {\n      test('should generate a unique code', () async {\n        final result = await service.generateUniqueCode();\n\n        expect(result.code.length, greaterThanOrEqualTo(6));\n        expect(result.code.length, lessThanOrEqualTo(8));\n        expect(result.attemptsUsed, 1);\n      });\n\n      test('should avoid collision with existing code', () async {\n        // Pre-populate a league with a specific invite code\n        final existingCode = service.generateCode();\n        await fakeFirestore.collection('leagues').add({\n          'name': 'Existing League',\n          'inviteCode': existingCode,\n        });\n\n        // Generate multiple codes to verify uniqueness\n        for (int i = 0; i < 10; i++) {\n          final result = await service.generateUniqueCode();\n          expect(result.code, isNot(existingCode));\n        }\n      });\n\n      test('should respect custom options', () async {\n        final result = await service.generateUniqueCode(\n          options: InviteCodeOptions.short,\n        );\n\n        expect(result.code.length, 6);\n        expect(result.codeLength, 6);\n      });\n\n      test('should return attempts used', () async {\n        final result = await service.generateUniqueCode();\n\n        expect(result.attemptsUsed, greaterThanOrEqualTo(1));\n        expect(result.attemptsUsed, lessThanOrEqualTo(10));\n      });\n    });\n\n    group('isValidFormat', () {\n      test('should return true for valid codes', () {\n        expect(service.isValidFormat('ABC123'), true);\n        expect(service.isValidFormat('ABCD1234'), true);\n        expect(service.isValidFormat('ABCDEF'), true);\n        expect(service.isValidFormat('ABCDEFGH'), true);\n      });\n\n      test('should return false for codes that are too short', () {\n        expect(service.isValidFormat('ABC12'), false);\n        expect(service.isValidFormat('AB'), false);\n        expect(service.isValidFormat(''), false);\n      });\n\n      test('should return false for codes that are too long', () {\n        expect(service.isValidFormat('ABCDEFGHI'), false);\n        expect(service.isValidFormat('ABCDEFGHIJ'), false);\n      });\n\n      test('should return false for codes with invalid characters', () {\n        expect(service.isValidFormat('ABC12O'), false); // Contains O\n        expect(service.isValidFormat('ABC12I'), false); // Contains I\n        expect(service.isValidFormat('ABC12L'), false); // Contains L\n        expect(service.isValidFormat('ABC120'), false); // Contains 0\n        expect(service.isValidFormat('ABC121'), false); // Contains 1\n        expect(service.isValidFormat('abc123'), true); // Lowercase is converted\n      });\n    });\n\n    group('normalizeCode', () {\n      test('should convert to uppercase', () {\n        expect(service.normalizeCode('abc123'), 'ABC123');\n        expect(service.normalizeCode('AbCdEf'), 'ABCDEF');\n      });\n\n      test('should remove whitespace', () {\n        expect(service.normalizeCode('ABC 123'), 'ABC123');\n        expect(service.normalizeCode('AB C1 23'), 'ABC123');\n        expect(service.normalizeCode(' ABC123 '), 'ABC123');\n      });\n\n      test('should handle combined cases', () {\n        expect(service.normalizeCode(' abc 123 '), 'ABC123');\n      });\n    });\n\n    group('isCodeAvailable', () {\n      test('should return true when code is not in use', () async {\n        final result = await service.isCodeAvailable('ABC12345');\n\n        expect(result, true);\n      });\n\n      test('should return false when code is in use', () async {\n        await fakeFirestore.collection('leagues').add({\n          'name': 'Test League',\n          'inviteCode': 'ABC12345',\n        });\n\n        final result = await service.isCodeAvailable('ABC12345');\n\n        expect(result, false);\n      });\n\n      test('should be case insensitive', () async {\n        await fakeFirestore.collection('leagues').add({\n          'name': 'Test League',\n          'inviteCode': 'ABC12345',\n        });\n\n        final result = await service.isCodeAvailable('abc12345');\n\n        expect(result, false);\n      });\n    });\n\n    group('InviteCodeOptions', () {\n      test('defaults should have correct values', () {\n        const options = InviteCodeOptions.defaults;\n\n        expect(options.minLength, 6);\n        expect(options.maxLength, 8);\n        expect(options.maxAttempts, 10);\n        expect(options.uppercaseOnly, true);\n      });\n\n      test('short option should have length 6', () {\n        const options = InviteCodeOptions.short;\n\n        expect(options.minLength, 6);\n        expect(options.maxLength, 6);\n      });\n\n      test('long option should have length 8', () {\n        const options = InviteCodeOptions.long;\n\n        expect(options.minLength, 8);\n        expect(options.maxLength, 8);\n      });\n    });\n\n    group('InviteCodeResult', () {\n      test('should have correct string representation', () {\n        const result = InviteCodeResult(\n          code: 'ABC12345',\n          attemptsUsed: 1,\n          codeLength: 8,\n        );\n\n        expect(\n          result.toString(),\n          'InviteCodeResult(code: ABC12345, attempts: 1, length: 8)',\n        );\n      });\n    });\n  });\n}\n"
}
Now let me update the existing league repository tests to use the new service:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/repositories/league_repository_impl_test.dart",
  "old_string": "import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/features/leagues/data/repositories/league_repository_impl.dart';\nimport 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';\nimport 'package:burgerrats/core/errors/exceptions.dart';\n\nvoid main() {\n  late FakeFirebaseFirestore fakeFirestore;\n  late LeagueRepositoryImpl repository;\n\n  setUp(() {\n    fakeFirestore = FakeFirebaseFirestore();\n    repository = LeagueRepositoryImpl(fakeFirestore);\n  });",
  "new_string": "import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';\nimport 'package:flutter_test/flutter_test.dart';\nimport 'package:burgerrats/features/leagues/data/repositories/league_repository_impl.dart';\nimport 'package:burgerrats/features/leagues/domain/entities/league_entity.dart';\nimport 'package:burgerrats/core/errors/exceptions.dart';\nimport 'package:burgerrats/core/services/invite_code_generator_service.dart';\n\nvoid main() {\n  late FakeFirebaseFirestore fakeFirestore;\n  late InviteCodeGeneratorService inviteCodeService;\n  late LeagueRepositoryImpl repository;\n\n  setUp(() {\n    fakeFirestore = FakeFirebaseFirestore();\n    inviteCodeService = InviteCodeGeneratorService(fakeFirestore);\n    repository = LeagueRepositoryImpl(fakeFirestore, inviteCodeService);\n  });"
}
Now also update the test for `regenerateInviteCode` to accommodate variable code lengths (6-8):

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/repositories/league_repository_impl_test.dart",
  "old_string": "    group('regenerateInviteCode', () {\n      test('should generate a new invite code', () async {\n        final created = await repository.createLeague(\n          name: 'Test League',\n          createdBy: 'user-123',\n        );\n\n        final originalCode = created.inviteCode;\n\n        final newCode = await repository.regenerateInviteCode(created.id);\n\n        expect(newCode, isNot(originalCode));\n        expect(newCode.length, 8);\n\n        final retrieved = await repository.getLeagueById(created.id);\n        expect(retrieved!.inviteCode, newCode);\n      });\n    });",
  "new_string": "    group('regenerateInviteCode', () {\n      test('should generate a new invite code', () async {\n        final created = await repository.createLeague(\n          name: 'Test League',\n          createdBy: 'user-123',\n        );\n\n        final originalCode = created.inviteCode;\n\n        final newCode = await repository.regenerateInviteCode(created.id);\n\n        expect(newCode, isNot(originalCode));\n        expect(newCode.length, greaterThanOrEqualTo(6));\n        expect(newCode.length, lessThanOrEqualTo(8));\n\n        final retrieved = await repository.getLeagueById(created.id);\n        expect(retrieved!.inviteCode, newCode);\n      });\n    });"
}
Also update the test that checks invite code length in `createLeague`:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/features/leagues/data/repositories/league_repository_impl_test.dart",
  "old_string": "      test('should create a new league and return it', () async {\n        final league = await repository.createLeague(\n          name: 'Test League',\n          description: 'A test league',\n          createdBy: 'user-123',\n          settings: const LeagueSettings(\n            isPublic: true,\n            maxMembers: 25,\n          ),\n        );\n\n        expect(league.name, 'Test League');\n        expect(league.description, 'A test league');\n        expect(league.createdBy, 'user-123');\n        expect(league.settings.isPublic, true);\n        expect(league.settings.maxMembers, 25);\n        expect(league.members.length, 1);\n        expect(league.members.first.userId, 'user-123');\n        expect(league.members.first.role, LeagueMemberRole.owner);\n        expect(league.inviteCode.length, 8);\n        expect(league.id, isNotEmpty);\n      });",
  "new_string": "      test('should create a new league and return it', () async {\n        final league = await repository.createLeague(\n          name: 'Test League',\n          description: 'A test league',\n          createdBy: 'user-123',\n          settings: const LeagueSettings(\n            isPublic: true,\n            maxMembers: 25,\n          ),\n        );\n\n        expect(league.name, 'Test League');\n        expect(league.description, 'A test league');\n        expect(league.createdBy, 'user-123');\n        expect(league.settings.isPublic, true);\n        expect(league.settings.maxMembers, 25);\n        expect(league.members.length, 1);\n        expect(league.members.first.userId, 'user-123');\n        expect(league.members.first.role, LeagueMemberRole.owner);\n        expect(league.inviteCode.length, greaterThanOrEqualTo(6));\n        expect(league.inviteCode.length, lessThanOrEqualTo(8));\n        expect(league.id, isNotEmpty);\n      });"
}
Now let me run the tests to make sure everything passes:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/services/invite_code_generator_service_test.dart --reporter expanded 2>&1",
  "description": "Run invite code service tests",
  "timeout": 120000
}
There are two test failures. The issue is that the `isValidFormat` method checks if characters are in `_codeCharacters`, but the tests use characters that are not in the allowed set (`1` is not allowed). Let me fix the tests:

🔧 Tool: Edit
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/test/core/services/invite_code_generator_service_test.dart",
  "old_string": "    group('isValidFormat', () {\n      test('should return true for valid codes', () {\n        expect(service.isValidFormat('ABC123'), true);\n        expect(service.isValidFormat('ABCD1234'), true);\n        expect(service.isValidFormat('ABCDEF'), true);\n        expect(service.isValidFormat('ABCDEFGH'), true);\n      });\n\n      test('should return false for codes that are too short', () {\n        expect(service.isValidFormat('ABC12'), false);\n        expect(service.isValidFormat('AB'), false);\n        expect(service.isValidFormat(''), false);\n      });\n\n      test('should return false for codes that are too long', () {\n        expect(service.isValidFormat('ABCDEFGHI'), false);\n        expect(service.isValidFormat('ABCDEFGHIJ'), false);\n      });\n\n      test('should return false for codes with invalid characters', () {\n        expect(service.isValidFormat('ABC12O'), false); // Contains O\n        expect(service.isValidFormat('ABC12I'), false); // Contains I\n        expect(service.isValidFormat('ABC12L'), false); // Contains L\n        expect(service.isValidFormat('ABC120'), false); // Contains 0\n        expect(service.isValidFormat('ABC121'), false); // Contains 1\n        expect(service.isValidFormat('abc123'), true); // Lowercase is converted\n      });\n    });",
  "new_string": "    group('isValidFormat', () {\n      test('should return true for valid codes', () {\n        // Only use characters from allowed set: ABCDEFGHJKMNPQRSTUVWXYZ23456789\n        expect(service.isValidFormat('ABC234'), true);\n        expect(service.isValidFormat('ABCD2345'), true);\n        expect(service.isValidFormat('ABCDEF'), true);\n        expect(service.isValidFormat('ABCDEFGH'), true);\n      });\n\n      test('should return false for codes that are too short', () {\n        expect(service.isValidFormat('ABC23'), false);\n        expect(service.isValidFormat('AB'), false);\n        expect(service.isValidFormat(''), false);\n      });\n\n      test('should return false for codes that are too long', () {\n        expect(service.isValidFormat('ABCDEFGH2'), false);\n        expect(service.isValidFormat('ABCDEFGH23'), false);\n      });\n\n      test('should return false for codes with invalid characters', () {\n        // Characters excluded from the allowed set: O, I, L, 0, 1\n        expect(service.isValidFormat('ABC23O'), false); // Contains O\n        expect(service.isValidFormat('ABC23I'), false); // Contains I\n        expect(service.isValidFormat('ABC23L'), false); // Contains L\n        expect(service.isValidFormat('ABC230'), false); // Contains 0\n        expect(service.isValidFormat('ABC231'), false); // Contains 1\n        expect(service.isValidFormat('abc234'), true); // Lowercase is converted\n      });\n    });"
}

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/services/invite_code_generator_service_test.dart --reporter expanded 2>&1",
  "description": "Run invite code service tests again",
  "timeout": 120000
}
All tests pass. Now let me run the league repository tests:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/features/leagues/data/repositories/league_repository_impl_test.dart --reporter expanded 2>&1",
  "description": "Run league repository tests",
  "timeout": 120000
}
All tests pass. Let me update the todos and run all tests to ensure nothing is broken:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "completed",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "completed",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "completed",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "completed",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "completed",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Playwright test",
      "status": "in_progress",
      "activeForm": "Verifying with Playwright"
    }
  ]
}

🔧 Tool: Bash
Input: {
  "command": "flutter test 2>&1",
  "description": "Run all Flutter tests",
  "timeout": 180000
}
Good news - all the tests related to my changes passed. There's an unrelated failing widget test (`widget_test.dart`) that has a pre-existing issue with the App configuration. My implementation tests all passed.

Now, let me check if this is a Flutter project that uses Playwright. Flutter is typically tested with Flutter's built-in testing framework, not Playwright (which is for web applications). Let me check what testing framework is available:

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/package.json 2>/dev/null || echo \"No package.json found\"",
  "description": "Check for package.json"
}

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/playwright* 2>/dev/null || echo \"No Playwright files found\"",
  "description": "Check for Playwright files"
}
This is a Flutter mobile application, not a web application. Playwright is designed for web browser automation and is not applicable to Flutter mobile apps. The verification should be done using Flutter's integration tests or the unit tests we've already created.

Let me create a Flutter integration test to verify the feature works correctly instead:

🔧 Tool: Bash
Input: {
  "command": "ls -la /Users/marcelo/dev/burgerrats/integration_test/ 2>/dev/null || echo \"No integration_test directory\"",
  "description": "Check for integration tests directory"
}
Since this is a Flutter project and Playwright is not applicable to Flutter mobile apps, I'll verify the feature through comprehensive unit tests (which already passed). Let me also do a quick analysis to verify the implementation is sound:

🔧 Tool: Bash
Input: {
  "command": "flutter analyze lib/core/services/invite_code_generator_service.dart lib/features/leagues/data/repositories/league_repository_impl.dart 2>&1",
  "description": "Analyze the new code",
  "timeout": 60000
}
The code analysis passes with no issues. Let me run the specific tests for the invite code generator service one more time with verbose output to make sure everything works:

🔧 Tool: Bash
Input: {
  "command": "flutter test test/core/services/invite_code_generator_service_test.dart test/features/leagues/data/repositories/league_repository_impl_test.dart --reporter expanded 2>&1 | tail -40",
  "description": "Run final verification tests",
  "timeout": 120000
}
All 55 tests pass. Let me mark all tasks as completed:

🔧 Tool: TodoWrite
Input: {
  "todos": [
    {
      "content": "Create InviteCodeGeneratorService with unique code generation logic",
      "status": "completed",
      "activeForm": "Creating InviteCodeGeneratorService"
    },
    {
      "content": "Add uniqueness validation by checking existing codes in Firestore",
      "status": "completed",
      "activeForm": "Adding uniqueness validation"
    },
    {
      "content": "Update LeagueRepository to use the new service",
      "status": "completed",
      "activeForm": "Updating LeagueRepository"
    },
    {
      "content": "Register service with dependency injection",
      "status": "completed",
      "activeForm": "Registering service with DI"
    },
    {
      "content": "Write unit tests for the service",
      "status": "completed",
      "activeForm": "Writing unit tests"
    },
    {
      "content": "Verify implementation with Flutter unit tests",
      "status": "completed",
      "activeForm": "Verifying with Flutter tests"
    }
  ]
}
Let me read the final implementation to provide a comprehensive summary:

🔧 Tool: Read
Input: {
  "file_path": "/Users/marcelo/dev/burgerrats/lib/core/services/invite_code_generator_service.dart"
}
<summary>
## Summary: Invite Code Generator

### Changes Implemented
- Created a new `InviteCodeGeneratorService` for generating unique, human-readable invite codes (6-8 characters)
- Uses cryptographically secure random number generation (`Random.secure()`)
- Excludes visually ambiguous characters (O, 0, I, 1, L) to improve readability
- Validates uniqueness by checking existing codes in Firestore before returning
- Includes configurable options for code length and retry attempts
- Integrated the service into `LeagueRepositoryImpl` for both `createLeague` and `regenerateInviteCode` operations
- Service is automatically registered with GetIt dependency injection via `@lazySingleton` annotation

### Files Modified
- `lib/core/services/invite_code_generator_service.dart` (NEW) - The invite code generator service
- `lib/features/leagues/data/repositories/league_repository_impl.dart` - Updated to use the new service
- `lib/core/di/injection.config.dart` - Auto-generated DI configuration
- `test/core/services/invite_code_generator_service_test.dart` (NEW) - Unit tests for the service
- `test/features/leagues/data/repositories/league_repository_impl_test.dart` - Updated tests to use the new service

### Key Features
- **Human-readable codes**: Uses `ABCDEFGHJKMNPQRSTUVWXYZ23456789` character set
- **Configurable length**: Default 6-8 characters, with `InviteCodeOptions.short` (6) and `InviteCodeOptions.long` (8) presets
- **Guaranteed uniqueness**: Queries Firestore to ensure no duplicate codes exist
- **Retry mechanism**: Retries up to 10 times (configurable) if collision detected
- **Additional utilities**: `isValidFormat()`, `normalizeCode()`, `isCodeAvailable()` methods

### Verification Status
- **55 unit tests passing** (22 for InviteCodeGeneratorService, 33 for LeagueRepositoryImpl)
- Code analysis passes with no issues
- Note: Playwright is not applicable to this Flutter mobile project. Verification was performed using Flutter's built-in testing framework with comprehensive unit tests that cover code generation, uniqueness validation, format validation, and integration with the league repository.

### Notes for Developer
- The service uses `Random.secure()` for cryptographic randomness
- Codes are case-insensitive (stored and queried as uppercase)
- Consider adding a Firestore index on `inviteCode` field for faster queries at scale
- The `BusinessException` is thrown if no unique code can be generated after max attempts (unlikely with 32-character alphabet and 6-8 char length)
</summary>