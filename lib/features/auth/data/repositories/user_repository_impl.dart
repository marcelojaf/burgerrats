import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

/// Implementation of [UserRepository] using Cloud Firestore
///
/// This class is registered as a lazy singleton with injectable,
/// meaning it will be created when first accessed and reused thereafter.
@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  /// Collection reference for users
  static const String _usersCollection = 'users';

  UserRepositoryImpl(this._firestore);

  /// Gets the users collection reference
  CollectionReference<Json> get _usersRef =>
      _firestore.collection(_usersCollection);

  /// Gets a document reference for a specific user
  DocumentReference<Json> _userDoc(String uid) => _usersRef.doc(uid);

  @override
  Future<void> createUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _userDoc(user.uid).set(userModel.toJson());
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to create user: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<UserEntity?> getUserById(String uid) async {
    try {
      final doc = await _userDoc(uid).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromFirestore(doc).toEntity();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to get user: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _userDoc(user.uid).update(userModel.toJsonForUpdate());
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update user: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> deleteUser(String uid) async {
    try {
      await _userDoc(uid).delete();
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to delete user: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _userDoc(uid).get();
      return doc.exists;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to check user existence: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Stream<UserEntity?> watchUser(String uid) {
    return _userDoc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromFirestore(doc).toEntity();
    }).handleError((error, stackTrace) {
      if (error is FirebaseException) {
        throw FirestoreException(
          message: 'Failed to watch user: ${error.message}',
          code: error.code,
          originalError: error,
          stackTrace: stackTrace,
        );
      }
      throw error;
    });
  }

  @override
  Future<UserEntity> createUserIfNotExists(UserEntity user) async {
    try {
      final existingUser = await getUserById(user.uid);
      if (existingUser != null) {
        return existingUser;
      }
      await createUser(user);
      return user;
    } on FirestoreException {
      rethrow;
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to create or get user: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    try {
      await _userDoc(uid).update(fields);
    } on FirebaseException catch (e, stackTrace) {
      throw FirestoreException(
        message: 'Failed to update user fields: ${e.message}',
        code: e.code,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
