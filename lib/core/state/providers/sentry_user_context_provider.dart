import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../services/sentry_service.dart';
import 'auth_state_provider.dart';

/// Provider that manages Sentry user context based on authentication state
///
/// This provider automatically:
/// - Sets user context (ID, email, displayName) when user logs in
/// - Clears user context when user logs out
/// - Updates user context when user data changes
///
/// The provider should be watched in the app's root widget to ensure
/// it's active throughout the app lifecycle.
///
/// Usage:
/// ```dart
/// // In your root ConsumerWidget
/// @override
/// Widget build(BuildContext context, WidgetRef ref) {
///   // Watch to activate the provider
///   ref.watch(sentryUserContextProvider);
///   // ... rest of build
/// }
/// ```
final sentryUserContextProvider = Provider<void>((ref) {
  final sentryService = getIt<SentryService>();

  // Listen to auth state changes
  ref.listen<AsyncValue<User?>>(
    authStateProvider,
    (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            _setUserContext(sentryService, user);
          } else {
            _clearUserContext(sentryService);
          }
        },
        loading: () {
          // Do nothing while loading
        },
        error: (error, stackTrace) {
          // Clear user context on auth error
          _clearUserContext(sentryService);
        },
      );
    },
    fireImmediately: true,
  );
});

/// Sets the Sentry user context with the authenticated user's information
void _setUserContext(SentryService sentryService, User user) {
  sentryService.setUserContext(
    userId: user.uid,
    email: user.email,
    displayName: user.displayName,
    extras: {
      'email_verified': user.emailVerified,
      'provider_id': user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : 'unknown',
      'created_at': user.metadata.creationTime?.toIso8601String(),
      'last_sign_in': user.metadata.lastSignInTime?.toIso8601String(),
    },
  );

  if (kDebugMode) {
    debugPrint('Sentry: User context updated for ${user.uid}');
  }
}

/// Clears the Sentry user context
void _clearUserContext(SentryService sentryService) {
  sentryService.clearUserContext();

  if (kDebugMode) {
    debugPrint('Sentry: User context cleared');
  }
}
