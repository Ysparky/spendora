import 'package:flutter/material.dart';

/// Core color palette for the Spendora app
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryContainer = Color(0xFFEADDFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF21005E);

  // Secondary colors
  static const Color secondary = Color(0xFF625B71);
  static const Color secondaryContainer = Color(0xFFE8DEF8);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1E192B);

  // Accent colors for financial data
  static const Color expense = Color(0xFFB3261E); // Red for expenses
  static const Color income = Color(0xFF386A20); // Green for income
  static const Color neutral = Color(0xFF49454F); // Neutral for balance

  // Background colors - Light mode
  static const Color background = Color(0xFFF8F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE7E0EC);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  // Background colors - Dark mode
  static const Color darkBackground = Color(0xFF1C1B1F);
  static const Color darkSurface = Color(0xFF2E2C34);
  static const Color darkSurfaceVariant = Color(0xFF49454F);
  static const Color onDarkBackground = Color(0xFFE6E1E5);
  static const Color onDarkSurface = Color(0xFFE6E1E5);
  static const Color onDarkSurfaceVariant = Color(0xFFCAC4D0);

  // Error colors
  static const Color error = Color(0xFFB3261E);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // Outline and divider colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // Shadow color
  static const Color shadow = Color(0xFF000000);

  // Category colors
  static const Map<String, Color> categoryColors = {
    'food': Color(0xFFEF9A9A), // Soft red
    'transport': Color(0xFF90CAF9), // Soft blue
    'shopping': Color(0xFFFFCC80), // Soft orange
    'bills': Color(0xFFCE93D8), // Soft purple
    'entertainment': Color(0xFFA5D6A7), // Soft green
    'health': Color(0xFFF48FB1), // Soft pink
    'other': Color(0xFFB0BEC5), // Soft grey
  };
}
