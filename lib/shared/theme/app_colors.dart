import 'package:flutter/material.dart';

/// App color palette following Material Design 3 guidelines.
///
/// Uses a warm color scheme suitable for a food/burger themed app
/// with proper contrast ratios for accessibility.
class AppColors {
  AppColors._();

  // Primary colors - Warm orange/amber for burger theme
  static const Color primary = Color(0xFFE65100);
  static const Color primaryLight = Color(0xFFE65100);
  static const Color primaryDark = Color(0xFFFFB74D);

  // On primary colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFDBCE);
  static const Color onPrimaryContainer = Color(0xFF370E00);

  // Secondary colors - Complementary green
  static const Color secondary = Color(0xFF2E7D32);
  static const Color secondaryLight = Color(0xFF2E7D32);
  static const Color secondaryDark = Color(0xFF81C784);

  // On secondary colors
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFA5D6A7);
  static const Color onSecondaryContainer = Color(0xFF002106);

  // Tertiary colors - Accent
  static const Color tertiary = Color(0xFF6D4C41);
  static const Color tertiaryLight = Color(0xFF6D4C41);
  static const Color tertiaryDark = Color(0xFFBCAAA4);

  // On tertiary colors
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD7CCC8);
  static const Color onTertiaryContainer = Color(0xFF231917);

  // Error colors
  static const Color error = Color(0xFFB00020);
  static const Color errorLight = Color(0xFFB00020);
  static const Color errorDark = Color(0xFFCF6679);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFCD8DF);
  static const Color onErrorContainer = Color(0xFF370B1E);

  // Surface colors for light theme
  static const Color surface = Color(0xFFFFFBFE);
  static const Color surfaceLight = Color(0xFFFFFBFE);
  static const Color surfaceContainerLight = Color(0xFFF3EDF7);
  static const Color surfaceContainerHighLight = Color(0xFFECE6F0);
  static const Color surfaceContainerLowLight = Color(0xFFF7F2FA);

  // Surface colors for dark theme
  static const Color surfaceDark = Color(0xFF1C1B1F);
  static const Color surfaceContainerDark = Color(0xFF211F26);
  static const Color surfaceContainerHighDark = Color(0xFF2B2930);
  static const Color surfaceContainerLowDark = Color(0xFF1D1B20);

  // On surface colors
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);

  // Background colors (kept for backwards compatibility)
  static const Color background = Color(0xFFFFFBFE);
  static const Color onBackground = Color(0xFF1C1B1F);

  // Outline colors
  static const Color outlineLight = Color(0xFF79747E);
  static const Color outlineDark = Color(0xFF938F99);
  static const Color outlineVariantLight = Color(0xFFCAC4D0);
  static const Color outlineVariantDark = Color(0xFF49454F);

  // Shadow colors
  static const Color shadowLight = Color(0xFF000000);
  static const Color shadowDark = Color(0xFF000000);

  // Scrim
  static const Color scrimLight = Color(0xFF000000);
  static const Color scrimDark = Color(0xFF000000);

  /// Light color scheme using Material Design 3
  static ColorScheme get lightColorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primaryLight,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondaryLight,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiaryLight,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: errorLight,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surfaceLight,
        onSurface: onSurfaceLight,
        onSurfaceVariant: onSurfaceVariantLight,
        outline: outlineLight,
        outlineVariant: outlineVariantLight,
        shadow: shadowLight,
        scrim: scrimLight,
        inverseSurface: Color(0xFF313033),
        onInverseSurface: Color(0xFFF4EFF4),
        inversePrimary: Color(0xFFFFB59C),
        surfaceTint: primaryLight,
      );

  /// Dark color scheme using Material Design 3
  static ColorScheme get darkColorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: Color(0xFF000000),
        primaryContainer: Color(0xFF862200),
        onPrimaryContainer: primaryContainer,
        secondary: secondaryDark,
        onSecondary: Color(0xFF000000),
        secondaryContainer: Color(0xFF1B5E20),
        onSecondaryContainer: secondaryContainer,
        tertiary: tertiaryDark,
        onTertiary: Color(0xFF000000),
        tertiaryContainer: Color(0xFF4E342E),
        onTertiaryContainer: tertiaryContainer,
        error: errorDark,
        onError: Color(0xFF000000),
        errorContainer: Color(0xFF8C0032),
        onErrorContainer: errorContainer,
        surface: surfaceDark,
        onSurface: onSurfaceDark,
        onSurfaceVariant: onSurfaceVariantDark,
        outline: outlineDark,
        outlineVariant: outlineVariantDark,
        shadow: shadowDark,
        scrim: scrimDark,
        inverseSurface: Color(0xFFE6E1E5),
        onInverseSurface: Color(0xFF313033),
        inversePrimary: Color(0xFFE65100),
        surfaceTint: primaryDark,
      );
}
