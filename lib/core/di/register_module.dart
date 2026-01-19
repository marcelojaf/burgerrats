import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

/// Module for registering third-party dependencies
///
/// This module registers Firebase services and other external dependencies
/// that cannot be annotated directly with @injectable.
@module
abstract class RegisterModule {
  /// Provides the Firebase Authentication instance
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  /// Provides the Cloud Firestore instance
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Provides the Firebase Storage instance
  @lazySingleton
  FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
}
