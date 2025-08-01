import 'package:al_quran/design_system/foundations/colors/app_colors.dart';
import 'package:al_quran/design_system/foundations/typography/text_styles.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    background: AppColors.background,
    onBackground: AppColors.onBackground,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceVariant: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    error: Colors.red,
    onError: Colors.white,
    errorContainer: Colors.redAccent,
    onErrorContainer: Colors.white,
    scrim: AppColors.scrim,
    shadow: AppColors.shadow,
    inverseSurface: Colors.black12,
    onInverseSurface: Colors.white70,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.primary,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyles.displayLarge,
    displayMedium: TextStyles.displayMedium,
    displaySmall: TextStyles.displaySmall,
    headlineLarge: TextStyles.headlineLarge,
    headlineMedium: TextStyles.headlineMedium,
    headlineSmall: TextStyles.headlineSmall,
    titleLarge: TextStyles.titleLarge,
    titleMedium: TextStyles.titleMedium,
    titleSmall: TextStyles.titleSmall,
    bodyLarge: TextStyles.bodyLarge,
    bodyMedium: TextStyles.bodyMedium,
    bodySmall: TextStyles.bodySmall,
    labelLarge: TextStyles.labelLarge,
    labelMedium: TextStyles.labelMedium,
    labelSmall: TextStyles.labelSmall,
  ),
  fontFamily: 'Poppins',
  // appBarTheme: AppBarTheme(titleSpacing: 0),
  iconButtonTheme: IconButtonThemeData(style: ButtonStyle()),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface, // or any color you prefer
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.onSurface.withValues(alpha: 0.6),
    selectedLabelStyle: TextStyles.labelSmall,
    unselectedLabelStyle: TextStyles.labelSmall,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed, // or .shifting
  ),

  cardTheme: CardTheme(
    color: AppColors.surface,
    shadowColor: AppColors.shadow,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.all(8),
  ),
);
