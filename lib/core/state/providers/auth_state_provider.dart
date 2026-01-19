import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';

/// Provides the Firebase Auth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Provides the AuthRepository instance from GetIt
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

/// Stream provider for authentication state changes
///
/// This provider exposes the Firebase auth state as a stream,
/// automatically updating when the user logs in or out.
///
/// Usage:
/// ```dart
/// final authState = ref.watch(authStateProvider);
/// authState.when(
///   data: (user) => user != null ? HomePage() : LoginPage(),
///   loading: () => SplashPage(),
///   error: (e, st) => ErrorPage(),
/// );
/// ```
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges();
});

/// Provider for the current user (nullable)
///
/// Returns the currently authenticated user or null if not logged in.
/// This is a synchronous snapshot - use [authStateProvider] for reactive updates.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});

/// Provider to check if user is authenticated
///
/// Returns true if there is a currently authenticated user.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Authentication state for UI
enum AuthStatus {
  /// Initial state, checking authentication
  initial,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,

  /// Authentication is in progress
  authenticating,

  /// Authentication failed
  error,
}

/// State class for authentication operations
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  const AuthState.authenticated(this.user)
      : status = AuthStatus.authenticated,
        errorMessage = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        errorMessage = null;

  const AuthState.authenticating()
      : status = AuthStatus.authenticating,
        user = null,
        errorMessage = null;

  const AuthState.error(this.errorMessage)
      : status = AuthStatus.error,
        user = null;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.authenticating;
  bool get hasError => status == AuthStatus.error;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user?.uid == user?.uid &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, user?.uid, errorMessage);
}

/// Notifier for authentication operations
///
/// Handles login, registration, logout, and password reset operations.
/// Integrates with Firebase Auth through the AuthRepository.
///
/// Usage:
/// ```dart
/// // In a widget
/// final authNotifier = ref.read(authNotifierProvider.notifier);
/// await authNotifier.signIn(email: email, password: password);
/// ```
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<User?>? _authSubscription;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _authSubscription = _repository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Signs in a user with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.authenticating();

    try {
      final credential = await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(credential.user);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      state = AuthState.error('Erro ao fazer login. Tente novamente.');
      return false;
    }
  }

  /// Creates a new user account
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthState.authenticating();

    try {
      final credential = await _repository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(credential.user);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      state = AuthState.error('Erro ao criar conta. Tente novamente.');
      return false;
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _repository.signOut();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('Erro ao sair. Tente novamente.');
    }
  }

  /// Sends a password reset email
  Future<bool> sendPasswordReset({required String email}) async {
    try {
      await _repository.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      state = AuthState.error('Erro ao enviar email. Tente novamente.');
      return false;
    }
  }

  /// Clears any error state
  void clearError() {
    if (state.hasError) {
      state = state.user != null
          ? AuthState.authenticated(state.user)
          : const AuthState.unauthenticated();
    }
  }

  /// Maps Firebase error codes to Portuguese messages
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuario nao encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-email':
        return 'Email invalido.';
      case 'user-disabled':
        return 'Conta desativada.';
      case 'email-already-in-use':
        return 'Email ja esta em uso.';
      case 'weak-password':
        return 'Senha muito fraca. Use pelo menos 6 caracteres.';
      case 'operation-not-allowed':
        return 'Operacao nao permitida.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'network-request-failed':
        return 'Erro de conexao. Verifique sua internet.';
      default:
        return 'Erro de autenticacao. Tente novamente.';
    }
  }
}

/// Provider for the AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthNotifier(repository);
  },
);
