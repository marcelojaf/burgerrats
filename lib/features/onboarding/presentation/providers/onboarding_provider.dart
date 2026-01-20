import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/onboarding_service.dart';

/// Provider for the OnboardingService singleton
///
/// Used to access onboarding-related functionality like checking
/// if the user has completed onboarding or marking it as complete.
final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

/// Provider that checks if onboarding has been completed
///
/// Returns a `Future<bool>` indicating whether the user has already
/// completed the onboarding flow.
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return service.hasCompletedOnboarding();
});
