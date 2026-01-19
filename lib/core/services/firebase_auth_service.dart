import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../errors/error_handler.dart';
import '../errors/error_messages.dart';
import '../errors/exceptions.dart';

/// Result of an authentication operation
class AuthResult {
  /// The authenticated user, if successful
  final User? user;

  /// Error message, if operation failed
  final String? errorMessage;

  /// Error code, if operation failed
  final String? errorCode;

  /// Whether the operation was successful
  bool get isSuccess => user != null && errorMessage == null;

  /// Whether the operation failed
  bool get isFailure => !isSuccess;

  const AuthResult._({
    this.user,
    this.errorMessage,
    this.errorCode,
  });

  /// Creates a successful result
  factory AuthResult.success(User user) => AuthResult._(user: user);

  /// Creates a failure result
  factory AuthResult.failure({
    required String message,
    String? code,
  }) =>
      AuthResult._(errorMessage: message, errorCode: code);
}

/// Service wrapper for Firebase Authentication
///
/// This service provides a clean interface for authentication operations
/// with proper error handling and Portuguese error messages.
///
/// Usage:
/// ```dart
/// final authService = getIt<FirebaseAuthService>();
///
/// // Sign in
/// final result = await authService.signInWithEmailAndPassword(
///   email: 'user@example.com',
///   password: 'password123',
/// );
///
/// if (result.isSuccess) {
///   print('Welcome, ${result.user!.email}');
/// } else {
///   print('Error: ${result.errorMessage}');
/// }
///
/// // Listen to auth state changes
/// authService.authStateChanges.listen((user) {
///   if (user != null) {
///     print('User is signed in');
///   } else {
///     print('User is signed out');
///   }
/// });
/// ```
@lazySingleton
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  /// Returns the currently authenticated user, or null if not logged in
  User? get currentUser => _firebaseAuth.currentUser;

  /// Returns true if a user is currently authenticated
  bool get isAuthenticated => currentUser != null;

  /// Returns the current user's ID, or null if not logged in
  String? get currentUserId => currentUser?.uid;

  /// Returns the current user's email, or null if not logged in
  String? get currentUserEmail => currentUser?.email;

  /// Stream of authentication state changes
  ///
  /// Emits a [User] when the user signs in, and null when they sign out.
  /// This stream is useful for listening to auth state in your UI.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Stream that emits when user token changes
  ///
  /// This is useful for detecting token refreshes or forced sign-outs.
  Stream<User?> get idTokenChanges => _firebaseAuth.idTokenChanges();

  /// Stream that emits on any user change (including profile updates)
  ///
  /// This includes auth state, token changes, and profile updates.
  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  /// Signs in a user with email and password
  ///
  /// Returns [AuthResult] with the user on success, or error details on failure.
  Future<AuthResult> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        return AuthResult.failure(
          message: ErrorMessages.unknownError,
          code: 'no-user-returned',
        );
      }

      return AuthResult.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      return AuthResult.failure(
        message: exception.message,
        code: exception.code,
      );
    }
  }

  /// Creates a new user with email and password
  ///
  /// Returns [AuthResult] with the new user on success, or error details on failure.
  Future<AuthResult> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        return AuthResult.failure(
          message: ErrorMessages.unknownError,
          code: 'no-user-returned',
        );
      }

      return AuthResult.success(credential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      return AuthResult.failure(
        message: exception.message,
        code: exception.code,
      );
    }
  }

  /// Signs out the current user
  ///
  /// Throws [AuthException] if sign out fails.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao sair da conta. Por favor, tente novamente.',
        code: 'sign-out-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sends a password reset email to the specified address
  ///
  /// Returns true on success, throws [AuthException] on failure.
  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      throw AuthException(
        message: exception.message,
        code: exception.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sends an email verification to the current user
  ///
  /// Returns true on success, throws [AuthException] if no user is signed in
  /// or if the operation fails.
  Future<bool> sendEmailVerification() async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException(
        message: 'Nenhum usuario logado para verificar o e-mail.',
        code: 'no-current-user',
      );
    }

    try {
      await user.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao enviar e-mail de verificacao. Tente novamente.',
        code: 'email-verification-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Reloads the current user's data from Firebase
  ///
  /// Useful to check if email has been verified after sending verification.
  Future<void> reloadUser() async {
    final user = currentUser;
    if (user == null) return;

    try {
      await user.reload();
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao atualizar dados do usuario.',
        code: 'reload-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Checks if the current user's email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Updates the current user's display name
  ///
  /// Throws [AuthException] if no user is signed in or update fails.
  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException(
        message: 'Nenhum usuario logado.',
        code: 'no-current-user',
      );
    }

    try {
      await user.updateDisplayName(displayName);
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao atualizar nome de exibicao.',
        code: 'update-display-name-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Updates the current user's photo URL
  ///
  /// Throws [AuthException] if no user is signed in or update fails.
  Future<void> updatePhotoURL(String photoURL) async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException(
        message: 'Nenhum usuario logado.',
        code: 'no-current-user',
      );
    }

    try {
      await user.updatePhotoURL(photoURL);
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao atualizar foto de perfil.',
        code: 'update-photo-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Deletes the current user's account
  ///
  /// WARNING: This action is irreversible. The user will need to re-authenticate
  /// if they haven't signed in recently.
  ///
  /// Throws [AuthException] if no user is signed in or deletion fails.
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException(
        message: 'Nenhum usuario logado.',
        code: 'no-current-user',
      );
    }

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao excluir conta. Tente fazer login novamente.',
        code: 'delete-account-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Re-authenticates the user with email and password
  ///
  /// This is required before sensitive operations like account deletion
  /// or password change if the user hasn't signed in recently.
  Future<AuthResult> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = currentUser;
    if (user == null) {
      return AuthResult.failure(
        message: 'Nenhum usuario logado.',
        code: 'no-current-user',
      );
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
      );
    } catch (e, stackTrace) {
      final exception = ErrorHandler.handleError(e, stackTrace);
      return AuthResult.failure(
        message: exception.message,
        code: exception.code,
      );
    }
  }

  /// Updates the current user's password
  ///
  /// Requires recent authentication. Call [reauthenticateWithEmailAndPassword]
  /// first if needed.
  ///
  /// Throws [AuthException] on failure.
  Future<void> updatePassword(String newPassword) async {
    final user = currentUser;
    if (user == null) {
      throw const AuthException(
        message: 'Nenhum usuario logado.',
        code: 'no-current-user',
      );
    }

    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: ErrorMessages.getMessageForCode(e.code),
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      throw AuthException(
        message: 'Erro ao atualizar senha.',
        code: 'update-password-failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
