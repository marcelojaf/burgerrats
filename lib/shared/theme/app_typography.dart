import 'package:flutter/material.dart';

/// App typography following Material Design 3 type scale.
///
/// Uses Roboto as the primary font family, which has excellent
/// support for Portuguese characters including accented letters
/// (á, é, í, ó, ú, ã, õ, ç, â, ê, ô).
class AppTypography {
  AppTypography._();

  // Base font family - Roboto has great Portuguese character support
  static const String fontFamily = 'Roboto';

  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  /// Creates a TextTheme for the given brightness.
  static TextTheme textTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? const Color(0xFF1C1B1F)
        : const Color(0xFFE6E1E5);

    return TextTheme(
      // Display styles - Large, prominent text
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 57,
        fontWeight: regular,
        letterSpacing: -0.25,
        height: 1.12,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 45,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.16,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.22,
        color: textColor,
      ),

      // Headline styles - Section headers
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.25,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.29,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.33,
        color: textColor,
      ),

      // Title styles - Smaller headers
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: regular,
        letterSpacing: 0,
        height: 1.27,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: medium,
        letterSpacing: 0.15,
        height: 1.5,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.43,
        color: textColor,
      ),

      // Body styles - Main content text
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: regular,
        letterSpacing: 0.5,
        height: 1.5,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: regular,
        letterSpacing: 0.25,
        height: 1.43,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: regular,
        letterSpacing: 0.4,
        height: 1.33,
        color: textColor,
      ),

      // Label styles - UI elements like buttons
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: medium,
        letterSpacing: 0.1,
        height: 1.43,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: medium,
        letterSpacing: 0.5,
        height: 1.33,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: medium,
        letterSpacing: 0.5,
        height: 1.45,
        color: textColor,
      ),
    );
  }

  /// Light theme text theme
  static TextTheme get lightTextTheme => textTheme(Brightness.light);

  /// Dark theme text theme
  static TextTheme get darkTextTheme => textTheme(Brightness.dark);
}
