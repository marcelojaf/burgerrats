import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../errors/exceptions.dart';

/// Result of an invite code generation operation
class InviteCodeResult {
  /// The generated invite code
  final String code;

  /// Number of attempts needed to generate a unique code
  final int attemptsUsed;

  /// The length of the generated code
  final int codeLength;

  const InviteCodeResult({
    required this.code,
    required this.attemptsUsed,
    required this.codeLength,
  });

  @override
  String toString() =>
      'InviteCodeResult(code: $code, attempts: $attemptsUsed, length: $codeLength)';
}

/// Configuration options for invite code generation
class InviteCodeOptions {
  /// Minimum length of the generated code
  final int minLength;

  /// Maximum length of the generated code
  final int maxLength;

  /// Maximum number of attempts to generate a unique code
  final int maxAttempts;

  /// Whether to use only uppercase letters
  final bool uppercaseOnly;

  const InviteCodeOptions({
    this.minLength = 6,
    this.maxLength = 8,
    this.maxAttempts = 10,
    this.uppercaseOnly = true,
  });

  /// Default options: 6-8 characters, uppercase only
  static const InviteCodeOptions defaults = InviteCodeOptions();

  /// Options for shorter codes (6 characters)
  static const InviteCodeOptions short = InviteCodeOptions(
    minLength: 6,
    maxLength: 6,
  );

  /// Options for longer codes (8 characters)
  static const InviteCodeOptions long = InviteCodeOptions(
    minLength: 8,
    maxLength: 8,
  );
}

/// Service for generating unique, human-readable invite codes for leagues
///
/// This service provides cryptographically secure random code generation
/// with Firestore uniqueness validation.
///
/// Usage:
/// ```dart
/// final result = await inviteCodeGeneratorService.generateUniqueCode();
/// print('Generated code: ${result.code}');
/// ```
@lazySingleton
class InviteCodeGeneratorService {
  final FirebaseFirestore _firestore;

  /// Characters used for generating invite codes
  /// Excludes visually ambiguous characters: O, 0, I, 1, L
  static const String _codeCharacters = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  /// Collection name for leagues in Firestore
  static const String _leaguesCollection = 'leagues';

  InviteCodeGeneratorService(this._firestore);

  /// Generates a unique invite code with Firestore validation
  ///
  /// [options] - Configuration options for code generation
  ///
  /// Returns [InviteCodeResult] with the generated code and metadata.
  /// Throws [BusinessException] if unable to generate a unique code.
  Future<InviteCodeResult> generateUniqueCode({
    InviteCodeOptions options = InviteCodeOptions.defaults,
  }) async {
    final random = Random.secure();

    for (int attempt = 1; attempt <= options.maxAttempts; attempt++) {
      // Generate code with length between minLength and maxLength
      final length = options.minLength +
          random.nextInt(options.maxLength - options.minLength + 1);

      final code = _generateCode(random, length);

      // Check uniqueness in Firestore
      final isUnique = await _isCodeUnique(code);

      if (isUnique) {
        return InviteCodeResult(
          code: code,
          attemptsUsed: attempt,
          codeLength: length,
        );
      }
    }

    throw BusinessException(
      message:
          'Failed to generate unique invite code after ${options.maxAttempts} attempts',
      code: 'invite-code-generation-failed',
    );
  }

  /// Generates an invite code without uniqueness validation
  ///
  /// Use this method when you need a code but don't need to check
  /// for uniqueness (e.g., for testing or preview purposes).
  ///
  /// [length] - Length of the code (default: 8)
  ///
  /// Returns the generated code string.
  String generateCode({int length = 8}) {
    final random = Random.secure();
    return _generateCode(random, length);
  }

  /// Validates if a code matches the expected format
  ///
  /// [code] - The code to validate
  ///
  /// Returns true if the code is valid.
  bool isValidFormat(String code) {
    if (code.isEmpty || code.length < 6 || code.length > 8) {
      return false;
    }

    // Check that all characters are in the allowed set
    final upperCode = code.toUpperCase();
    return upperCode.split('').every((char) => _codeCharacters.contains(char));
  }

  /// Checks if a specific code is already in use
  ///
  /// [code] - The code to check
  ///
  /// Returns true if the code is available (not in use).
  /// Throws [FirestoreException] on database errors.
  Future<bool> isCodeAvailable(String code) async {
    return _isCodeUnique(code);
  }

  /// Normalizes a code for consistent comparison
  ///
  /// Converts to uppercase and removes any whitespace.
  String normalizeCode(String code) {
    return code.toUpperCase().replaceAll(RegExp(r'\s'), '');
  }

  /// Generates a random code of the specified length
  String _generateCode(Random random, int length) {
    return List.generate(
      length,
      (_) => _codeCharacters[random.nextInt(_codeCharacters.length)],
    ).join();
  }

  /// Checks if a code is unique in the Firestore leagues collection
  Future<bool> _isCodeUnique(String code) async {
    try {
      final querySnapshot = await _firestore
          .collection(_leaguesCollection)
          .where('inviteCode', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();

      return querySnapshot.docs.isEmpty;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to check invite code uniqueness: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
