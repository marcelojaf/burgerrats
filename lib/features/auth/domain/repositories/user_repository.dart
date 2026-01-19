import '../entities/user_entity.dart';

/// Abstract repository for user CRUD operations in Firestore
///
/// This interface defines the contract for user profile management.
/// Implementations handle persistence and sync with authentication.
abstract class UserRepository {
  /// Creates a new user document in Firestore
  ///
  /// Should be called after successful authentication to initialize
  /// the user's profile document.
  ///
  /// Throws [FirestoreException] on failure
  Future<void> createUser(UserEntity user);

  /// Retrieves a user by their unique ID
  ///
  /// Returns the user entity if found, null if not found.
  /// Throws [FirestoreException] on failure
  Future<UserEntity?> getUserById(String uid);

  /// Updates an existing user's profile data
  ///
  /// Only updates mutable fields (displayName, photoURL, statistics).
  /// Does not modify uid or createdAt.
  ///
  /// Throws [FirestoreException] on failure
  Future<void> updateUser(UserEntity user);

  /// Deletes a user document from Firestore
  ///
  /// Throws [FirestoreException] on failure
  Future<void> deleteUser(String uid);

  /// Checks if a user document exists in Firestore
  ///
  /// Returns true if the user document exists, false otherwise.
  /// Throws [FirestoreException] on failure
  Future<bool> userExists(String uid);

  /// Stream of user data changes for real-time updates
  ///
  /// Emits the current user data and subsequent changes.
  /// Emits null if the user document doesn't exist.
  Stream<UserEntity?> watchUser(String uid);

  /// Creates a user document if it doesn't exist, or returns existing
  ///
  /// This is useful for syncing authentication with Firestore on login.
  /// If the document exists, returns the existing user data.
  /// If not, creates a new document with the provided user data.
  ///
  /// Throws [FirestoreException] on failure
  Future<UserEntity> createUserIfNotExists(UserEntity user);

  /// Updates specific fields of a user document
  ///
  /// Use this for partial updates when you don't have the full user entity.
  /// Only the provided fields will be updated.
  ///
  /// Throws [FirestoreException] on failure
  Future<void> updateUserFields(String uid, Map<String, dynamic> fields);
}
