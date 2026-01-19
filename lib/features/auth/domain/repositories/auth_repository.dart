import 'package:firebase_auth/firebase_auth.dart';

/// Abstract repository for authentication operations
///
/// This interface defines the contract for authentication functionality.
/// Implementations can be swapped for testing or different auth providers.
abstract class AuthRepository {
  /// Returns the currently authenticated user, or null if not logged in
  User? get currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Signs in a user with email and password
  ///
  /// Returns [UserCredential] on success
  /// Throws [FirebaseAuthException] on failure
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new user with email and password
  ///
  /// Returns [UserCredential] on success
  /// Throws [FirebaseAuthException] on failure
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs out the current user
  Future<void> signOut();

  /// Sends a password reset email
  Future<void> sendPasswordResetEmail({required String email});
}
