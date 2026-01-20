import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burgerrats/features/onboarding/data/services/onboarding_service.dart';

void main() {
  group('OnboardingService', () {
    late OnboardingService service;

    setUp(() {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      service = OnboardingService();
    });

    group('hasCompletedOnboarding', () {
      test(
        'should return false when onboarding has not been completed',
        () async {
          SharedPreferences.setMockInitialValues({});
          final result = await service.hasCompletedOnboarding();
          expect(result, false);
        },
      );

      test('should return true when onboarding has been completed', () async {
        SharedPreferences.setMockInitialValues({
          'has_completed_onboarding': true,
        });

        final newService = OnboardingService();
        final result = await newService.hasCompletedOnboarding();
        expect(result, true);
      });
    });

    group('completeOnboarding', () {
      test('should mark onboarding as completed', () async {
        SharedPreferences.setMockInitialValues({});

        await service.completeOnboarding();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('has_completed_onboarding'), true);
      });

      test(
        'should make hasCompletedOnboarding return true after completing',
        () async {
          SharedPreferences.setMockInitialValues({});

          // Initially false
          expect(await service.hasCompletedOnboarding(), false);

          // Complete onboarding
          await service.completeOnboarding();

          // Now should be true
          expect(await service.hasCompletedOnboarding(), true);
        },
      );
    });

    group('resetOnboarding', () {
      test('should reset onboarding status', () async {
        SharedPreferences.setMockInitialValues({
          'has_completed_onboarding': true,
        });

        // Should be true initially
        expect(await service.hasCompletedOnboarding(), true);

        // Reset
        await service.resetOnboarding();

        // Should be false after reset
        expect(await service.hasCompletedOnboarding(), false);
      });
    });

    group('persistence', () {
      test(
        'should persist onboarding status across service instances',
        () async {
          SharedPreferences.setMockInitialValues({});

          // Complete with first instance
          final service1 = OnboardingService();
          await service1.completeOnboarding();

          // Check with new instance
          final service2 = OnboardingService();
          expect(await service2.hasCompletedOnboarding(), true);
        },
      );
    });
  });
}
