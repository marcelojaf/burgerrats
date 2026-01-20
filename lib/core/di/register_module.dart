import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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

  /// Provides the Firebase Messaging instance for push notifications
  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  /// Provides the Google Sign-In instance
  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn();

  /// Provides the UUID generator instance
  @lazySingleton
  Uuid get uuid => const Uuid();

  /// Provides the SharedPreferences instance
  /// This is a preResolved singleton that must be initialized before DI
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();
}
