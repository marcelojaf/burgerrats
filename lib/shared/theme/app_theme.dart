import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Main app theme configuration following Material Design 3.
///
/// Provides both light and dark themes with consistent styling
/// across all Material components. Uses the BurgerRats brand color
/// palette with warm-tinted surfaces and semantic color support.
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData get light => _buildTheme(Brightness.light);

  /// Dark theme
  static ThemeData get dark => _buildTheme(Brightness.dark);

  /// Builds a complete theme for the given brightness.
  static ThemeData _buildTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;
    final ColorScheme colorScheme =
        isLight ? AppColors.lightColorScheme : AppColors.darkColorScheme;
    final TextTheme textTheme =
        isLight ? AppTypography.lightTextTheme : AppTypography.darkTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      fontFamily: AppTypography.fontFamily,

      // Scaffold
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar theme
      appBarTheme: _buildAppBarTheme(colorScheme, textTheme, isLight),

      // Card theme
      cardTheme: _buildCardTheme(colorScheme, isLight),

      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme, textTheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme, textTheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme, textTheme),
      textButtonTheme: _buildTextButtonTheme(textTheme),
      floatingActionButtonTheme: _buildFabTheme(colorScheme),
      iconButtonTheme: _buildIconButtonTheme(colorScheme),

      // Input decoration theme
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme, textTheme, isLight),

      // Chip theme
      chipTheme: _buildChipTheme(colorScheme, textTheme, isLight),

      // List tile theme
      listTileTheme: _buildListTileTheme(colorScheme, textTheme),

      // Dialog theme
      dialogTheme: _buildDialogTheme(colorScheme, textTheme, isLight),

      // Bottom sheet theme
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme, isLight),

      // Snackbar theme
      snackBarTheme: _buildSnackBarTheme(colorScheme, textTheme),

      // Navigation themes
      navigationBarTheme: _buildNavigationBarTheme(colorScheme, textTheme, isLight),
      navigationRailTheme: _buildNavigationRailTheme(colorScheme, textTheme, isLight),

      // Tab bar theme
      tabBarTheme: _buildTabBarTheme(colorScheme, textTheme),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Form element themes
      switchTheme: _buildSwitchTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
      radioTheme: _buildRadioTheme(colorScheme),
      sliderTheme: _buildSliderTheme(colorScheme),

      // Progress indicator theme
      progressIndicatorTheme: _buildProgressIndicatorTheme(colorScheme),

      // Icon themes
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppSpacing.iconMd,
      ),
      primaryIconTheme: IconThemeData(
        color: colorScheme.onPrimary,
        size: AppSpacing.iconMd,
      ),

      // Badge theme for achievement and leaderboard badges
      badgeTheme: _buildBadgeTheme(colorScheme, textTheme),

      // Popup menu theme
      popupMenuTheme: _buildPopupMenuTheme(colorScheme, textTheme, isLight),

      // Dropdown menu theme
      dropdownMenuTheme: _buildDropdownMenuTheme(colorScheme, textTheme, isLight),

      // Date picker theme
      datePickerTheme: _buildDatePickerTheme(colorScheme, textTheme, isLight),

      // Time picker theme
      timePickerTheme: _buildTimePickerTheme(colorScheme, textTheme, isLight),

      // Search bar theme
      searchBarTheme: _buildSearchBarTheme(colorScheme, textTheme, isLight),

      // Segmented button theme
      segmentedButtonTheme: _buildSegmentedButtonTheme(colorScheme, textTheme),

      // Tooltip theme
      tooltipTheme: _buildTooltipTheme(colorScheme, textTheme),

      // Visual density
      visualDensity: VisualDensity.standard,

      // Splash factory for ink effects
      splashFactory: InkSparkle.splashFactory,

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ============================================================================
  // COMPONENT THEME BUILDERS
  // ============================================================================

  static AppBarTheme _buildAppBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: AppSpacing.elevation1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: colorScheme.surfaceTint,
      systemOverlayStyle: isLight
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: colorScheme.surface,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: colorScheme.surface,
            ),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: AppSpacing.iconMd,
      ),
      actionsIconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: AppSpacing.iconMd,
      ),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme colorScheme, bool isLight) {
    return CardThemeData(
      elevation: AppSpacing.elevation1,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      color: isLight
          ? AppColors.surfaceContainerLowLight
          : AppColors.surfaceContainerLowDark,
      surfaceTintColor: Colors.transparent,
      margin: AppSpacing.paddingSm,
      clipBehavior: Clip.antiAlias,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppSpacing.elevation1,
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        foregroundColor: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppSpacing.elevation1;
          }
          if (states.contains(WidgetState.hovered)) {
            return AppSpacing.elevation2;
          }
          return AppSpacing.elevation1;
        }),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.outline),
      ).copyWith(
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return BorderSide(color: colorScheme.primary, width: 2);
          }
          if (states.contains(WidgetState.focused)) {
            return BorderSide(color: colorScheme.primary, width: 2);
          }
          return BorderSide(color: colorScheme.outline);
        }),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(TextTheme textTheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: AppSpacing.buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static FloatingActionButtonThemeData _buildFabTheme(ColorScheme colorScheme) {
    return FloatingActionButtonThemeData(
      elevation: AppSpacing.elevation3,
      highlightElevation: AppSpacing.elevation4,
      focusElevation: AppSpacing.elevation3,
      hoverElevation: AppSpacing.elevation4,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      splashColor: colorScheme.primary.withValues(alpha: 0.12),
    );
  }

  static IconButtonThemeData _buildIconButtonTheme(ColorScheme colorScheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(AppSpacing.sm),
      ).copyWith(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight
          ? AppColors.surfaceContainerHighLight
          : AppColors.surfaceContainerHighDark,
      contentPadding: AppSpacing.paddingMd,
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSm,
        borderSide: BorderSide.none,
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      floatingLabelStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
      helperStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.error,
      ),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary;
        }
        if (states.contains(WidgetState.error)) {
          return colorScheme.error;
        }
        return colorScheme.onSurfaceVariant;
      }),
      suffixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary;
        }
        if (states.contains(WidgetState.error)) {
          return colorScheme.error;
        }
        return colorScheme.onSurfaceVariant;
      }),
    );
  }

  static ChipThemeData _buildChipTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      padding: AppSpacing.paddingHorizontalSm,
      labelStyle: textTheme.labelLarge,
      backgroundColor: isLight
          ? AppColors.surfaceContainerLight
          : AppColors.surfaceContainerDark,
      selectedColor: colorScheme.secondaryContainer,
      disabledColor: colorScheme.onSurface.withValues(alpha: 0.12),
      deleteIconColor: colorScheme.onSurfaceVariant,
      side: BorderSide.none,
      iconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: AppSpacing.iconSm,
      ),
    );
  }

  static ListTileThemeData _buildListTileTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListTileThemeData(
      contentPadding: AppSpacing.listItemPadding,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      titleTextStyle: textTheme.bodyLarge,
      subtitleTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      leadingAndTrailingTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      iconColor: colorScheme.onSurfaceVariant,
      selectedColor: colorScheme.primary,
      selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
    );
  }

  static DialogThemeData _buildDialogTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      elevation: AppSpacing.elevation3,
      backgroundColor: isLight
          ? AppColors.surfaceContainerHighLight
          : AppColors.surfaceContainerHighDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.bodyMedium,
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(
    ColorScheme colorScheme,
    bool isLight,
  ) {
    return BottomSheetThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      elevation: AppSpacing.elevation3,
      backgroundColor: isLight
          ? AppColors.surfaceContainerLowLight
          : AppColors.surfaceContainerLowDark,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      dragHandleSize: const Size(32, 4),
      modalElevation: AppSpacing.elevation3,
      modalBackgroundColor: isLight
          ? AppColors.surfaceContainerLowLight
          : AppColors.surfaceContainerLowDark,
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      elevation: AppSpacing.elevation2,
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      actionTextColor: colorScheme.inversePrimary,
      closeIconColor: colorScheme.onInverseSurface,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return NavigationBarThemeData(
      elevation: 0,
      height: 80,
      backgroundColor: isLight
          ? AppColors.surfaceContainerLight
          : AppColors.surfaceContainerDark,
      surfaceTintColor: Colors.transparent,
      indicatorColor: colorScheme.secondaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          );
        }
        return textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: colorScheme.onSecondaryContainer,
            size: AppSpacing.iconMd,
          );
        }
        return IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: AppSpacing.iconMd,
        );
      }),
    );
  }

  static NavigationRailThemeData _buildNavigationRailTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return NavigationRailThemeData(
      elevation: 0,
      backgroundColor: isLight
          ? AppColors.surfaceContainerLight
          : AppColors.surfaceContainerDark,
      indicatorColor: colorScheme.secondaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      selectedIconTheme: IconThemeData(
        color: colorScheme.onSecondaryContainer,
        size: AppSpacing.iconMd,
      ),
      unselectedIconTheme: IconThemeData(
        color: colorScheme.onSurfaceVariant,
        size: AppSpacing.iconMd,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static TabBarThemeData _buildTabBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: textTheme.titleSmall,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 3,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(3),
        ),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: colorScheme.outlineVariant,
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.primary.withValues(alpha: 0.08);
        }
        return Colors.transparent;
      }),
    );
  }

  static SwitchThemeData _buildSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return colorScheme.outline;
      }),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.38),
            width: 2,
          );
        }
        if (states.contains(WidgetState.selected)) {
          return BorderSide.none;
        }
        return BorderSide(
          color: colorScheme.onSurfaceVariant,
          width: 2,
        );
      }),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXs,
      ),
    );
  }

  static RadioThemeData _buildRadioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
    );
  }

  static SliderThemeData _buildSliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(alpha: 0.12),
      valueIndicatorColor: colorScheme.primary,
      valueIndicatorTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme(
    ColorScheme colorScheme,
  ) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
      refreshBackgroundColor: colorScheme.surfaceContainerHighest,
    );
  }

  static BadgeThemeData _buildBadgeTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return BadgeThemeData(
      backgroundColor: colorScheme.error,
      textColor: colorScheme.onError,
      textStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
    );
  }

  static PopupMenuThemeData _buildPopupMenuTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return PopupMenuThemeData(
      color: isLight
          ? AppColors.surfaceContainerLight
          : AppColors.surfaceContainerDark,
      surfaceTintColor: Colors.transparent,
      elevation: AppSpacing.elevation2,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      textStyle: textTheme.bodyMedium,
      labelTextStyle: WidgetStateProperty.all(textTheme.bodyMedium),
      iconColor: colorScheme.onSurfaceVariant,
    );
  }

  static DropdownMenuThemeData _buildDropdownMenuTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return DropdownMenuThemeData(
      textStyle: textTheme.bodyMedium,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? AppColors.surfaceContainerHighLight
            : AppColors.surfaceContainerHighDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          isLight
              ? AppColors.surfaceContainerLight
              : AppColors.surfaceContainerDark,
        ),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(AppSpacing.elevation2),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ),
    );
  }

  static DatePickerThemeData _buildDatePickerTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return DatePickerThemeData(
      backgroundColor: isLight
          ? AppColors.surfaceContainerHighLight
          : AppColors.surfaceContainerHighDark,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: colorScheme.primaryContainer,
      headerForegroundColor: colorScheme.onPrimaryContainer,
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.onSurface;
      }),
      todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
      todayForegroundColor: WidgetStateProperty.all(colorScheme.primary),
      todayBorder: BorderSide(color: colorScheme.primary),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXl,
      ),
    );
  }

  static TimePickerThemeData _buildTimePickerTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return TimePickerThemeData(
      backgroundColor: isLight
          ? AppColors.surfaceContainerHighLight
          : AppColors.surfaceContainerHighDark,
      dialBackgroundColor: isLight
          ? AppColors.surfaceContainerLight
          : AppColors.surfaceContainerDark,
      dialHandColor: colorScheme.primary,
      dialTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primaryContainer;
        }
        return isLight
            ? AppColors.surfaceContainerLight
            : AppColors.surfaceContainerDark;
      }),
      hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimaryContainer;
        }
        return colorScheme.onSurface;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXl,
      ),
    );
  }

  static SearchBarThemeData _buildSearchBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isLight,
  ) {
    return SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(
        isLight
            ? AppColors.surfaceContainerHighLight
            : AppColors.surfaceContainerHighDark,
      ),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      textStyle: WidgetStateProperty.all(textTheme.bodyLarge),
      hintStyle: WidgetStateProperty.all(
        textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  static SegmentedButtonThemeData _buildSegmentedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onSecondaryContainer;
          }
          return colorScheme.onSurface;
        }),
        side: WidgetStateProperty.all(
          BorderSide(color: colorScheme.outline),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static TooltipThemeData _buildTooltipTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      textStyle: textTheme.bodySmall?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      waitDuration: const Duration(milliseconds: 500),
    );
  }

  // ============================================================================
  // GRADIENT HELPERS - For Splash Screens & Achievement Badges
  // ============================================================================

  /// Splash screen gradient for light theme
  /// Use: DecoratedBox with this gradient for splash/onboarding backgrounds
  static LinearGradient get splashGradientLight => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryContainer,
          AppColors.surface,
        ],
      );

  /// Splash screen gradient for dark theme
  static LinearGradient get splashGradientDark => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.surfaceDark,
          AppColors.surfaceContainerDark,
        ],
      );

  /// Returns the appropriate splash gradient based on brightness
  static LinearGradient splashGradient(Brightness brightness) {
    return brightness == Brightness.light
        ? splashGradientLight
        : splashGradientDark;
  }

  /// Achievement badge gradient - Gold for 1st place
  static LinearGradient get achievementGoldGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFD54F), // Light gold
          AppColors.leaderboardGold,
          Color(0xFFFFB300), // Darker gold
        ],
      );

  /// Achievement badge gradient - Silver for 2nd place
  static LinearGradient get achievementSilverGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE8E8E8), // Light silver
          AppColors.leaderboardSilver,
          Color(0xFFA0A0A0), // Darker silver
        ],
      );

  /// Achievement badge gradient - Bronze for 3rd place
  static LinearGradient get achievementBronzeGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE6A86E), // Light bronze
          AppColors.leaderboardBronze,
          Color(0xFFB86B1B), // Darker bronze
        ],
      );

  /// Returns achievement badge gradient based on rank
  static LinearGradient achievementGradient(int rank) {
    switch (rank) {
      case 1:
        return achievementGoldGradient;
      case 2:
        return achievementSilverGradient;
      case 3:
        return achievementBronzeGradient;
      default:
        return const LinearGradient(
          colors: [
            AppColors.leaderboardDefault,
            AppColors.leaderboardDefault,
          ],
        );
    }
  }

  /// Hero section gradient for promotional areas
  static LinearGradient get heroGradient => AppColors.primaryGradient;

  /// Warm background gradient for special sections
  static LinearGradient get warmBackgroundGradient => AppColors.warmGradient;

  /// Card surface gradient for light theme
  static LinearGradient get cardGradientLight => AppColors.cardGradientLight;

  /// Card surface gradient for dark theme
  static LinearGradient get cardGradientDark => AppColors.cardGradientDark;

  /// Returns card gradient based on brightness
  static LinearGradient cardGradient(Brightness brightness) {
    return brightness == Brightness.light
        ? cardGradientLight
        : cardGradientDark;
  }

  // ============================================================================
  // SEMANTIC COLOR HELPERS
  // ============================================================================

  /// Returns a container decoration for success state
  static BoxDecoration successDecoration({bool isLight = true}) => BoxDecoration(
        color: AppColors.successContainer,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
        ),
      );

  /// Returns a container decoration for warning state
  static BoxDecoration warningDecoration({bool isLight = true}) => BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      );

  /// Returns a container decoration for error state
  static BoxDecoration errorDecoration({bool isLight = true}) => BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      );

  /// Returns a container decoration for info state
  static BoxDecoration infoDecoration({bool isLight = true}) => BoxDecoration(
        color: AppColors.infoContainer,
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      );

  // ============================================================================
  // ELEVATION HELPERS
  // ============================================================================

  /// Returns elevation with warm-tinted shadow for light theme
  static List<BoxShadow> elevatedShadow({
    double elevation = AppSpacing.elevation2,
    bool isLight = true,
  }) {
    final double blur = elevation * 2;
    final double spread = elevation * 0.5;
    final double opacity = isLight ? 0.1 : 0.3;

    return [
      BoxShadow(
        color: (isLight ? AppColors.tertiary : Colors.black).withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: spread,
        offset: Offset(0, elevation),
      ),
    ];
  }

  /// Returns primary-tinted glow for emphasis (like FABs, CTAs)
  static List<BoxShadow> primaryGlow({double intensity = 0.3}) {
    return [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: intensity),
        blurRadius: 20,
        spreadRadius: 2,
      ),
    ];
  }
}
