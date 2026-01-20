import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:burgerrats/shared/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    group('Brand Colors', () {
      test('primary color is BurgerRats orange #FF5722', () {
        expect(AppColors.primary, equals(const Color(0xFFFF5722)));
      });

      test('secondary color is gold/amber #FF8F00', () {
        expect(AppColors.secondary, equals(const Color(0xFFFF8F00)));
      });

      test('tertiary color is brown #6D4C41', () {
        expect(AppColors.tertiary, equals(const Color(0xFF6D4C41)));
      });

      test('primary variants are defined', () {
        expect(AppColors.primaryLight, isNotNull);
        expect(AppColors.primaryDark, isNotNull);
        expect(AppColors.primaryContainer, isNotNull);
        expect(AppColors.onPrimaryContainer, isNotNull);
      });
    });

    group('Semantic Colors', () {
      test('success color is defined', () {
        expect(AppColors.success, equals(const Color(0xFF4CAF50)));
        expect(AppColors.onSuccess, equals(const Color(0xFFFFFFFF)));
      });

      test('warning color is defined', () {
        expect(AppColors.warning, equals(const Color(0xFFFFC107)));
        expect(AppColors.onWarning, equals(const Color(0xFF000000)));
      });

      test('error color is defined', () {
        expect(AppColors.error, equals(const Color(0xFFE53935)));
        expect(AppColors.onError, equals(const Color(0xFFFFFFFF)));
      });

      test('info color is defined', () {
        expect(AppColors.info, equals(const Color(0xFF2196F3)));
        expect(AppColors.onInfo, equals(const Color(0xFFFFFFFF)));
      });
    });

    group('Leaderboard Colors', () {
      test('getLeaderboardColor returns gold for rank 1', () {
        expect(
          AppColors.getLeaderboardColor(1),
          equals(AppColors.leaderboardGold),
        );
      });

      test('getLeaderboardColor returns silver for rank 2', () {
        expect(
          AppColors.getLeaderboardColor(2),
          equals(AppColors.leaderboardSilver),
        );
      });

      test('getLeaderboardColor returns bronze for rank 3', () {
        expect(
          AppColors.getLeaderboardColor(3),
          equals(AppColors.leaderboardBronze),
        );
      });

      test('getLeaderboardColor returns default for other ranks', () {
        expect(
          AppColors.getLeaderboardColor(4),
          equals(AppColors.leaderboardDefault),
        );
        expect(
          AppColors.getLeaderboardColor(100),
          equals(AppColors.leaderboardDefault),
        );
      });

      test('getOnLeaderboardColor returns correct text colors', () {
        expect(
          AppColors.getOnLeaderboardColor(1),
          equals(AppColors.onLeaderboardGold),
        );
        expect(
          AppColors.getOnLeaderboardColor(2),
          equals(AppColors.onLeaderboardSilver),
        );
        expect(
          AppColors.getOnLeaderboardColor(3),
          equals(AppColors.onLeaderboardBronze),
        );
        expect(
          AppColors.getOnLeaderboardColor(4),
          equals(AppColors.onLeaderboardDefault),
        );
      });
    });

    group('Streak Colors', () {
      test('getStreakColor returns streakLow for 1-2 days', () {
        expect(AppColors.getStreakColor(1), equals(AppColors.streakLow));
        expect(AppColors.getStreakColor(2), equals(AppColors.streakLow));
      });

      test('getStreakColor returns streakMedium for 3-6 days', () {
        expect(AppColors.getStreakColor(3), equals(AppColors.streakMedium));
        expect(AppColors.getStreakColor(6), equals(AppColors.streakMedium));
      });

      test('getStreakColor returns streakHigh for 7-13 days', () {
        expect(AppColors.getStreakColor(7), equals(AppColors.streakHigh));
        expect(AppColors.getStreakColor(13), equals(AppColors.streakHigh));
      });

      test('getStreakColor returns streakMax for 14+ days', () {
        expect(AppColors.getStreakColor(14), equals(AppColors.streakMax));
        expect(AppColors.getStreakColor(100), equals(AppColors.streakMax));
      });

      test('getStreakBadgeColor returns correct badge colors', () {
        expect(AppColors.getStreakBadgeColor(1), equals(AppColors.streakBadgeLow));
        expect(AppColors.getStreakBadgeColor(3), equals(AppColors.streakBadgeMedium));
        expect(AppColors.getStreakBadgeColor(7), equals(AppColors.streakBadgeHigh));
        expect(AppColors.getStreakBadgeColor(14), equals(AppColors.streakBadgeMax));
      });
    });

    group('Color Schemes', () {
      test('lightColorScheme is valid Material 3 color scheme', () {
        final scheme = AppColors.lightColorScheme;

        expect(scheme.brightness, equals(Brightness.light));
        expect(scheme.primary, equals(AppColors.primary));
        expect(scheme.secondary, equals(AppColors.secondary));
        expect(scheme.tertiary, equals(AppColors.tertiary));
        expect(scheme.error, equals(AppColors.error));
        expect(scheme.surface, equals(AppColors.surfaceLight));
      });

      test('darkColorScheme is valid Material 3 color scheme', () {
        final scheme = AppColors.darkColorScheme;

        expect(scheme.brightness, equals(Brightness.dark));
        expect(scheme.primary, equals(AppColors.primaryLight));
        expect(scheme.surface, equals(AppColors.surfaceDark));
      });
    });

    group('WCAG Accessibility', () {
      test('meetsContrastAA returns true for high contrast pairs', () {
        // White on dark should pass
        expect(
          AppColors.meetsContrastAA(
            const Color(0xFFFFFFFF),
            const Color(0xFF000000),
          ),
          isTrue,
        );
      });

      test('meetsContrastAA returns false for low contrast pairs', () {
        // Light gray on white should fail
        expect(
          AppColors.meetsContrastAA(
            const Color(0xFFCCCCCC),
            const Color(0xFFFFFFFF),
          ),
          isFalse,
        );
      });

      test('meetsContrastAALarge returns true for 3:1 contrast ratio', () {
        // White on dark should pass
        expect(
          AppColors.meetsContrastAALarge(
            const Color(0xFFFFFFFF),
            const Color(0xFF000000),
          ),
          isTrue,
        );
      });

      test('primary with onPrimary meets WCAG AA for large text', () {
        expect(
          AppColors.meetsContrastAALarge(
            AppColors.onPrimary,
            AppColors.primary,
          ),
          isTrue,
        );
      });

      test('error with onError meets WCAG AA for large text', () {
        expect(
          AppColors.meetsContrastAALarge(
            AppColors.onError,
            AppColors.error,
          ),
          isTrue,
        );
      });
    });

    group('Gradients', () {
      test('primaryGradient has correct colors', () {
        expect(AppColors.primaryGradient.colors.length, equals(2));
        expect(AppColors.primaryGradient.colors.first, equals(AppColors.primary));
        expect(AppColors.primaryGradient.colors.last, equals(AppColors.secondary));
      });

      test('warmGradient has three colors', () {
        expect(AppColors.warmGradient.colors.length, equals(3));
      });

      test('goldGradient has three colors', () {
        expect(AppColors.goldGradient.colors.length, equals(3));
      });

      test('streakGradient has four colors', () {
        expect(AppColors.streakGradient.colors.length, equals(4));
        expect(AppColors.streakGradient.colors, contains(AppColors.streakLow));
        expect(AppColors.streakGradient.colors, contains(AppColors.streakMax));
      });
    });

    group('Backward Compatibility', () {
      test('legacy surface aliases are preserved', () {
        expect(
          AppColors.surfaceContainerLight,
          equals(AppColors.surfaceContainer),
        );
        expect(
          AppColors.surfaceContainerHighLight,
          equals(AppColors.surfaceContainerHigh),
        );
        expect(
          AppColors.surfaceContainerLowLight,
          equals(AppColors.surfaceContainerLow),
        );
      });
    });
  });
}
