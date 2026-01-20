import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/state/providers/auth_state_provider.dart';
import '../../../check_ins/domain/repositories/check_in_repository.dart';
import '../../../leagues/presentation/providers/my_leagues_provider.dart';
import '../../../streak_tracker/presentation/providers/streak_provider.dart';

/// Provider for the CheckInRepository instance from GetIt
final profileCheckInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return getIt<CheckInRepository>();
});

/// Data class representing the user profile information
class UserProfileData {
  /// User's unique identifier
  final String uid;

  /// User's email address
  final String email;

  /// User's display name
  final String? displayName;

  /// URL to user's profile photo
  final String? photoURL;

  /// Total number of check-ins made by the user
  final int totalCheckIns;

  /// Current streak (consecutive days)
  final int currentStreak;

  /// Number of leagues the user has joined
  final int leaguesJoined;

  const UserProfileData({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.totalCheckIns,
    required this.currentStreak,
    required this.leaguesJoined,
  });

  /// Returns the display name or email prefix as fallback
  String get displayNameOrEmail {
    if (displayName != null && displayName!.isNotEmpty) {
      return displayName!;
    }
    final atIndex = email.indexOf('@');
    return atIndex > 0 ? email.substring(0, atIndex) : email;
  }

  /// Whether the user has a profile photo
  bool get hasProfilePhoto => photoURL != null && photoURL!.isNotEmpty;

  /// Whether the user has an active streak
  bool get hasActiveStreak => currentStreak > 0;

  /// Creates an empty profile data instance
  factory UserProfileData.empty() {
    return const UserProfileData(
      uid: '',
      email: '',
      displayName: null,
      photoURL: null,
      totalCheckIns: 0,
      currentStreak: 0,
      leaguesJoined: 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileData &&
        other.uid == uid &&
        other.email == email &&
        other.displayName == displayName &&
        other.photoURL == photoURL &&
        other.totalCheckIns == totalCheckIns &&
        other.currentStreak == currentStreak &&
        other.leaguesJoined == leaguesJoined;
  }

  @override
  int get hashCode => Object.hash(
        uid,
        email,
        displayName,
        photoURL,
        totalCheckIns,
        currentStreak,
        leaguesJoined,
      );
}

/// Provider that aggregates all user profile data
///
/// Combines data from Firebase Auth, streak tracker, and leagues
/// to provide a complete picture of the user's profile.
///
/// Usage:
/// ```dart
/// final profileAsync = ref.watch(userProfileProvider);
/// profileAsync.when(
///   data: (profile) => ProfileView(profile: profile),
///   loading: () => LoadingIndicator(),
///   error: (e, st) => ErrorWidget(error: e),
/// );
/// ```
final userProfileProvider = FutureProvider<UserProfileData>((ref) async {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return UserProfileData.empty();
  }

  // Get leagues count
  final leaguesCount = ref.watch(myLeaguesCountProvider);

  // Get streak data
  final streakAsync = ref.watch(userStreakStreamProvider(currentUser.uid));
  final streak = streakAsync.valueOrNull;

  // Get total check-ins from repository
  final checkInRepository = ref.watch(profileCheckInRepositoryProvider);
  final totalCheckIns = await checkInRepository.getUserCheckInCount(currentUser.uid);

  return UserProfileData(
    uid: currentUser.uid,
    email: currentUser.email ?? '',
    displayName: currentUser.displayName,
    photoURL: currentUser.photoURL,
    totalCheckIns: totalCheckIns,
    currentStreak: streak?.currentStreak ?? 0,
    leaguesJoined: leaguesCount,
  );
});

/// Provider that returns basic user info synchronously
///
/// This is useful for UI elements that just need name/email/photo
/// without waiting for statistics to load.
final userBasicInfoProvider = Provider<UserProfileData?>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) {
    return null;
  }

  final leaguesCount = ref.watch(myLeaguesCountProvider);
  final streakAsync = ref.watch(userStreakStreamProvider(currentUser.uid));
  final streak = streakAsync.valueOrNull;

  return UserProfileData(
    uid: currentUser.uid,
    email: currentUser.email ?? '',
    displayName: currentUser.displayName,
    photoURL: currentUser.photoURL,
    totalCheckIns: streak?.totalCheckIns ?? 0,
    currentStreak: streak?.currentStreak ?? 0,
    leaguesJoined: leaguesCount,
  );
});

/// Provider to check if profile is loading
final isProfileLoadingProvider = Provider<bool>((ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.isLoading;
});
