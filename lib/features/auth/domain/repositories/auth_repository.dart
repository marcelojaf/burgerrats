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

  /// Sends an email verification to the current user
  Future<void> sendEmailVerification();

  /// Reloads the current user to get updated data (e.g., email verification status)
  Future<void> reloadUser();

  /// Returns true if the current user's email is verified
  bool get isEmailVerified;

  /// Updates the display name of the current user
  Future<void> updateDisplayName(String displayName);

  /// Updates the profile photo URL of the current user
  Future<void> updatePhotoURL(String photoURL);

  /// Signs in a user with Google
  ///
  /// Returns [UserCredential] on success
  /// Throws [FirebaseAuthException] on failure
  /// Returns null if user cancels the sign-in flow
  Future<UserCredential?> signInWithGoogle();
}
