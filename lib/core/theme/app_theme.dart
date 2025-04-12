import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/theme/app_typography.dart';

/// Main theme configuration for the Spendora app
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        shadow: AppColors.shadow,
      ),

      // Typography - Use default text theme colors but apply our font family
      textTheme: TextTheme(
        displayLarge:
            AppTypography.displayLarge.copyWith(color: AppColors.onBackground),
        displayMedium:
            AppTypography.displayMedium.copyWith(color: AppColors.onBackground),
        displaySmall:
            AppTypography.displaySmall.copyWith(color: AppColors.onBackground),
        headlineLarge:
            AppTypography.headlineLarge.copyWith(color: AppColors.onBackground),
        headlineMedium: AppTypography.headlineMedium
            .copyWith(color: AppColors.onBackground),
        headlineSmall:
            AppTypography.headlineSmall.copyWith(color: AppColors.onBackground),
        titleLarge:
            AppTypography.titleLarge.copyWith(color: AppColors.onBackground),
        titleMedium: AppTypography.titleMedium.copyWith(color: Colors.black),
        titleSmall:
            AppTypography.titleSmall.copyWith(color: AppColors.onBackground),
        bodyLarge:
            AppTypography.bodyLarge.copyWith(color: AppColors.onBackground),
        bodyMedium:
            AppTypography.bodyMedium.copyWith(color: AppColors.onBackground),
        bodySmall:
            AppTypography.bodySmall.copyWith(color: AppColors.onSurfaceVariant),
        labelLarge:
            AppTypography.labelLarge.copyWith(color: AppColors.onBackground),
        labelMedium:
            AppTypography.labelMedium.copyWith(color: AppColors.onBackground),
        labelSmall: AppTypography.labelSmall
            .copyWith(color: AppColors.onSurfaceVariant),
      ),

      // Component themes
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.outline.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: TextStyle(color: AppColors.onSurfaceVariant),
        hintStyle:
            TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.7)),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: AppColors.onPrimary,
          backgroundColor: AppColors.primary,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: AppColors.onPrimary,
          backgroundColor: AppColors.primary,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: AppColors.primary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFD0BCFF), // Lighter purple for dark mode
        onPrimary: Color(0xFF381E72),
        primaryContainer: Color(0xFF4F378B),
        onPrimaryContainer: Color(0xFFEADDFF),
        secondary: Color(0xFFCCC2DC),
        onSecondary: Color(0xFF332D41),
        secondaryContainer: Color(0xFF4A4458),
        onSecondaryContainer: Color(0xFFE8DEF8),
        error: Color(0xFFF2B8B5),
        onError: Color(0xFF601410),
        errorContainer: Color(0xFF8C1D18),
        onErrorContainer: Color(0xFFF9DEDC),
        background: AppColors.darkBackground,
        onBackground: AppColors.onDarkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.onDarkSurface,
        surfaceVariant: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.onDarkSurfaceVariant,
        outline: Color(0xFF938F99),
        shadow: Color(0xFF000000),
      ),

      // Override specific component themes for dark mode
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.onDarkSurface,
        elevation: 0,
        centerTitle: true,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: Color(0xFFD0BCFF), // Lighter purple
        unselectedItemColor: AppColors.onDarkSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      cardTheme: CardTheme(
        color: AppColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF938F99), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0BCFF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFE6E1E5)),
        displayMedium: TextStyle(color: Color(0xFFE6E1E5)),
        displaySmall: TextStyle(color: Color(0xFFE6E1E5)),
        headlineLarge: TextStyle(color: Color(0xFFE6E1E5)),
        headlineMedium: TextStyle(color: Color(0xFFE6E1E5)),
        headlineSmall: TextStyle(color: Color(0xFFE6E1E5)),
        titleLarge: TextStyle(color: Color(0xFFE6E1E5)),
        titleMedium: TextStyle(color: Color(0xFFE6E1E5)),
        titleSmall: TextStyle(color: Color(0xFFE6E1E5)),
        bodyLarge: TextStyle(color: Color(0xFFE6E1E5)),
        bodyMedium: TextStyle(color: Color(0xFFE6E1E5)),
        bodySmall: TextStyle(color: Color(0xFFCAC4D0)),
        labelLarge: TextStyle(color: Color(0xFFE6E1E5)),
        labelMedium: TextStyle(color: Color(0xFFE6E1E5)),
        labelSmall: TextStyle(color: Color(0xFFCAC4D0)),
      ),
    );
  }

  // Cupertino (iOS) specific theme settings
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryContrastingColor: AppColors.onPrimary,
      textTheme: CupertinoTextThemeData(primaryColor: AppColors.primary),
    );
  }

  static CupertinoThemeData get cupertinoDarkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFFD0BCFF),
      primaryContrastingColor: Color(0xFF381E72),
      textTheme: CupertinoTextThemeData(primaryColor: Color(0xFFD0BCFF)),
    );
  }
}
