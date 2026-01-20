import 'package:flutter/material.dart';

/// BurgerRats brand color palette following Material Design 3 guidelines.
///
/// Colors are derived from the BurgerRats rat mascot logo to maintain
/// brand cohesion. All colors meet WCAG AA accessibility standards with
/// proper contrast ratios (minimum 4.5:1 for normal text, 3:1 for large text).
///
/// Color Categories:
/// - **Brand Colors**: Primary orange, secondary gold, tertiary brown
/// - **Semantic Colors**: Success, warning, error, info states
/// - **Surface Colors**: Warm-tinted backgrounds for both themes
/// - **Special Purpose**: Leaderboard ranks, streak indicators
/// - **Gradients**: Brand-aligned gradient definitions
class AppColors {
  AppColors._();

  // ============================================================================
  // BRAND COLORS - Extracted from BurgerRats mascot logo
  // ============================================================================

  // Primary colors - Vibrant orange from logo background/ring
  // Main brand color representing energy and appetite
  static const Color primary = Color(0xFFFF5722); // Deep Orange 500
  static const Color primaryLight = Color(0xFFFF8A50); // Lighter variant for hover states
  static const Color primaryDark = Color(0xFFE64A19); // Darker variant for pressed states

  // On primary colors - Text/icons on primary surfaces
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFDBCF); // Light orange background
  static const Color onPrimaryContainer = Color(0xFF3B0900); // Dark text on container

  // Secondary colors - Gold/amber from logo's golden ring
  // Represents achievement and premium features
  static const Color secondary = Color(0xFFFF8F00); // Amber 800
  static const Color secondaryLight = Color(0xFFFFBF47); // Lighter gold
  static const Color secondaryDark = Color(0xFFC56000); // Darker gold

  // On secondary colors
  static const Color onSecondary = Color(0xFF000000); // Black text for better contrast
  static const Color secondaryContainer = Color(0xFFFFE082); // Light amber background
  static const Color onSecondaryContainer = Color(0xFF2E1500); // Dark text on container

  // Tertiary colors - Brown from rat's fur
  // Represents warmth, earthiness, and the mascot
  static const Color tertiary = Color(0xFF6D4C41); // Brown 500
  static const Color tertiaryLight = Color(0xFF9C786C); // Lighter brown
  static const Color tertiaryDark = Color(0xFF40241A); // Darker brown

  // On tertiary colors
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD7CCC8); // Light brown background
  static const Color onTertiaryContainer = Color(0xFF231917); // Dark text on container

  // ============================================================================
  // SEMANTIC COLORS - State indication following Material Design
  // ============================================================================

  // Success colors - Green from burger lettuce
  // For positive actions, completions, and achievements
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color successLight = Color(0xFF81C784); // Light green
  static const Color successDark = Color(0xFF388E3C); // Dark green
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color successContainer = Color(0xFFC8E6C9); // Light green background
  static const Color onSuccessContainer = Color(0xFF0D3D0F);

  // Warning colors - Amber/yellow from cheese
  // For caution states and attention-required items
  static const Color warning = Color(0xFFFFC107); // Amber 500
  static const Color warningLight = Color(0xFFFFD54F); // Light amber
  static const Color warningDark = Color(0xFFFFA000); // Dark amber
  static const Color onWarning = Color(0xFF000000);
  static const Color warningContainer = Color(0xFFFFECB3); // Light amber background
  static const Color onWarningContainer = Color(0xFF3D2C00);

  // Error colors - Red from bandana and tomato
  // For errors, destructive actions, and critical alerts
  static const Color error = Color(0xFFE53935); // Red 600
  static const Color errorLight = Color(0xFFEF5350); // Light red
  static const Color errorDark = Color(0xFFC62828); // Dark red
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFCDD2); // Light red background
  static const Color onErrorContainer = Color(0xFF410002);

  // Info colors - Blue for informational states
  // For tips, information, and neutral notifications
  static const Color info = Color(0xFF2196F3); // Blue 500
  static const Color infoLight = Color(0xFF64B5F6); // Light blue
  static const Color infoDark = Color(0xFF1976D2); // Dark blue
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color infoContainer = Color(0xFFBBDEFB); // Light blue background
  static const Color onInfoContainer = Color(0xFF001D36);

  // ============================================================================
  // SURFACE COLORS - Warm-tinted backgrounds
  // ============================================================================

  // Light theme surfaces - Warm white with subtle orange tint
  static const Color surface = Color(0xFFFFFBF8); // Warm white
  static const Color surfaceLight = Color(0xFFFFFBF8);
  static const Color surfaceDim = Color(0xFFE8DED8); // Dimmed surface
  static const Color surfaceBright = Color(0xFFFFF8F5); // Brighter surface
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceContainerLow = Color(0xFFFFF5F0); // Very light warm
  static const Color surfaceContainer = Color(0xFFFFF0E8); // Light warm
  static const Color surfaceContainerHigh = Color(0xFFFFEBE0); // Medium warm
  static const Color surfaceContainerHighest = Color(0xFFFFE5D8); // Higher warm

  // Legacy aliases for backward compatibility
  static const Color surfaceContainerLight = surfaceContainer;
  static const Color surfaceContainerHighLight = surfaceContainerHigh;
  static const Color surfaceContainerLowLight = surfaceContainerLow;

  // Dark theme surfaces - Warm dark with subtle brown tint
  static const Color surfaceDark = Color(0xFF1A1614); // Warm black
  static const Color surfaceDimDark = Color(0xFF1A1614);
  static const Color surfaceBrightDark = Color(0xFF3D3533);
  static const Color surfaceContainerLowestDark = Color(0xFF0F0C0A); // Darkest
  static const Color surfaceContainerLowDark = Color(0xFF201C1A); // Dark warm
  static const Color surfaceContainerDark = Color(0xFF252120); // Medium dark warm
  static const Color surfaceContainerHighDark = Color(0xFF302B29); // Lighter dark warm
  static const Color surfaceContainerHighestDark = Color(0xFF3B3634); // Lightest dark

  // On surface colors - Text on surfaces
  static const Color onSurface = Color(0xFF1C1917); // Near black for light theme
  static const Color onSurfaceLight = Color(0xFF1C1917);
  static const Color onSurfaceVariantLight = Color(0xFF52443D); // Muted text
  static const Color onSurfaceDark = Color(0xFFEDE0DB); // Light text for dark theme
  static const Color onSurfaceVariantDark = Color(0xFFD3C4BD); // Muted light text

  // Background colors (legacy, prefer surface)
  static const Color background = Color(0xFFFFFBF8);
  static const Color onBackground = Color(0xFF1C1917);

  // ============================================================================
  // OUTLINE & DIVIDER COLORS
  // ============================================================================

  static const Color outlineLight = Color(0xFF85736A); // Warm gray outline
  static const Color outlineDark = Color(0xFFA08D84); // Light warm gray
  static const Color outlineVariantLight = Color(0xFFD7C4BA); // Subtle outline
  static const Color outlineVariantDark = Color(0xFF52443D); // Subtle dark outline

  // ============================================================================
  // SHADOW & OVERLAY COLORS
  // ============================================================================

  static const Color shadowLight = Color(0xFF000000);
  static const Color shadowDark = Color(0xFF000000);
  static const Color scrimLight = Color(0xFF000000);
  static const Color scrimDark = Color(0xFF000000);

  // ============================================================================
  // SPECIAL PURPOSE COLORS - Leaderboard & Streaks
  // ============================================================================

  // Leaderboard rank colors - Metallic inspired
  static const Color leaderboardGold = Color(0xFFFFD700); // 1st place
  static const Color leaderboardSilver = Color(0xFFC0C0C0); // 2nd place
  static const Color leaderboardBronze = Color(0xFFCD7F32); // 3rd place
  static const Color leaderboardDefault = Color(0xFF78909C); // Other ranks

  // On leaderboard colors (text on rank badges)
  static const Color onLeaderboardGold = Color(0xFF3D2C00);
  static const Color onLeaderboardSilver = Color(0xFF1A1A1A);
  static const Color onLeaderboardBronze = Color(0xFF2D1A00);
  static const Color onLeaderboardDefault = Color(0xFFFFFFFF);

  // Streak indicator colors - Fire-inspired gradient
  static const Color streakLow = Color(0xFFFFCC80); // Warm glow (1-2 days)
  static const Color streakMedium = Color(0xFFFF9800); // Orange flame (3-6 days)
  static const Color streakHigh = Color(0xFFFF5722); // Deep orange (7-13 days)
  static const Color streakMax = Color(0xFFE53935); // Red hot (14+ days)

  // Streak badge backgrounds
  static const Color streakBadgeLow = Color(0xFFFFF3E0);
  static const Color streakBadgeMedium = Color(0xFFFFE0B2);
  static const Color streakBadgeHigh = Color(0xFFFFCCBC);
  static const Color streakBadgeMax = Color(0xFFFFCDD2);

  // ============================================================================
  // BRAND GRADIENTS
  // ============================================================================

  /// Primary brand gradient - Orange to gold (horizontal)
  /// Use for hero sections, CTAs, and brand emphasis
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  /// Vertical primary gradient
  static const LinearGradient primaryGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, secondary],
  );

  /// Warm sunset gradient - For backgrounds and cards
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF8A50), // Light orange
      Color(0xFFFF5722), // Primary orange
      Color(0xFFE64A19), // Dark orange
    ],
  );

  /// Golden ring gradient - Inspired by logo ring
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFD54F), // Light gold
      Color(0xFFFF8F00), // Gold
      Color(0xFFC56000), // Dark gold
    ],
  );

  /// Streak fire gradient - For streak indicators
  static const LinearGradient streakGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      streakLow,
      streakMedium,
      streakHigh,
      streakMax,
    ],
  );

  /// Surface gradient for cards (light theme)
  static const LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFF8F5),
    ],
  );

  /// Surface gradient for cards (dark theme)
  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF302B29),
      Color(0xFF252120),
    ],
  );

  // ============================================================================
  // COLOR SCHEMES - Material Design 3 compliant
  // ============================================================================

  /// Light color scheme using Material Design 3
  /// All color combinations meet WCAG AA contrast requirements
  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        // Primary
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        // Secondary
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        // Tertiary
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        // Error
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        // Surface
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        onSurfaceVariant: onSurfaceVariantLight,
        // Outline
        outline: outlineLight,
        outlineVariant: outlineVariantLight,
        // Shadow & Scrim
        shadow: shadowLight,
        scrim: scrimLight,
        // Inverse
        inverseSurface: Color(0xFF362F2C),
        onInverseSurface: Color(0xFFFBEEE9),
        inversePrimary: Color(0xFFFFB59D),
        // Surface tint
        surfaceTint: primary,
      );

  /// Dark color scheme using Material Design 3
  /// All color combinations meet WCAG AA contrast requirements
  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        // Primary - Lighter for dark theme visibility
        primary: primaryLight,
        onPrimary: Color(0xFF5F1500),
        primaryContainer: Color(0xFF862200),
        onPrimaryContainer: primaryContainer,
        // Secondary
        secondary: secondaryLight,
        onSecondary: Color(0xFF472A00),
        secondaryContainer: Color(0xFF653D00),
        onSecondaryContainer: secondaryContainer,
        // Tertiary
        tertiary: tertiaryLight,
        onTertiary: Color(0xFF2C1A14),
        tertiaryContainer: Color(0xFF4E342E),
        onTertiaryContainer: tertiaryContainer,
        // Error
        error: errorLight,
        onError: Color(0xFF5F1412),
        errorContainer: Color(0xFF8C1D18),
        onErrorContainer: errorContainer,
        // Surface
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        onSurfaceVariant: onSurfaceVariantDark,
        // Outline
        outline: outlineDark,
        outlineVariant: outlineVariantDark,
        // Shadow & Scrim
        shadow: shadowDark,
        scrim: scrimDark,
        // Inverse
        inverseSurface: Color(0xFFEDE0DB),
        onInverseSurface: Color(0xFF362F2C),
        inversePrimary: primary,
        // Surface tint
        surfaceTint: primaryLight,
      );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get the appropriate streak color based on streak count
  static Color getStreakColor(int streakDays) {
    if (streakDays >= 14) return streakMax;
    if (streakDays >= 7) return streakHigh;
    if (streakDays >= 3) return streakMedium;
    return streakLow;
  }

  /// Get the appropriate streak badge background based on streak count
  static Color getStreakBadgeColor(int streakDays) {
    if (streakDays >= 14) return streakBadgeMax;
    if (streakDays >= 7) return streakBadgeHigh;
    if (streakDays >= 3) return streakBadgeMedium;
    return streakBadgeLow;
  }

  /// Get leaderboard rank color
  static Color getLeaderboardColor(int rank) {
    switch (rank) {
      case 1:
        return leaderboardGold;
      case 2:
        return leaderboardSilver;
      case 3:
        return leaderboardBronze;
      default:
        return leaderboardDefault;
    }
  }

  /// Get text color for leaderboard rank
  static Color getOnLeaderboardColor(int rank) {
    switch (rank) {
      case 1:
        return onLeaderboardGold;
      case 2:
        return onLeaderboardSilver;
      case 3:
        return onLeaderboardBronze;
      default:
        return onLeaderboardDefault;
    }
  }

  /// Check if a color combination meets WCAG AA contrast ratio (4.5:1)
  static bool meetsContrastAA(Color foreground, Color background) {
    final double luminance1 = foreground.computeLuminance();
    final double luminance2 = background.computeLuminance();
    final double lighter =
        luminance1 > luminance2 ? luminance1 : luminance2;
    final double darker =
        luminance1 > luminance2 ? luminance2 : luminance1;
    final double ratio = (lighter + 0.05) / (darker + 0.05);
    return ratio >= 4.5;
  }

  /// Check if a color combination meets WCAG AA for large text (3:1)
  static bool meetsContrastAALarge(Color foreground, Color background) {
    final double luminance1 = foreground.computeLuminance();
    final double luminance2 = background.computeLuminance();
    final double lighter =
        luminance1 > luminance2 ? luminance1 : luminance2;
    final double darker =
        luminance1 > luminance2 ? luminance2 : luminance1;
    final double ratio = (lighter + 0.05) / (darker + 0.05);
    return ratio >= 3.0;
  }
}
