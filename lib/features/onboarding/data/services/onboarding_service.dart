import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing onboarding state and first-launch detection
///
/// Uses SharedPreferences to persist whether the user has completed
/// the onboarding flow. This ensures onboarding is only shown once
/// on the user's first app launch.
class OnboardingService {
  OnboardingService();

  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';

  SharedPreferences? _prefs;

  /// Initialize the service by loading SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Check if the user has completed onboarding
  ///
  /// Returns true if onboarding was completed, false otherwise.
  /// Returns false if SharedPreferences is not initialized.
  Future<bool> hasCompletedOnboarding() async {
    await init();
    return _prefs?.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  /// Mark onboarding as completed
  ///
  /// This should be called when the user finishes or skips onboarding.
  Future<void> completeOnboarding() async {
    await init();
    await _prefs?.setBool(_hasCompletedOnboardingKey, true);
  }

  /// Reset onboarding status (useful for testing or settings)
  ///
  /// After calling this, the user will see onboarding again on next app launch.
  Future<void> resetOnboarding() async {
    await init();
    await _prefs?.remove(_hasCompletedOnboardingKey);
  }
}
