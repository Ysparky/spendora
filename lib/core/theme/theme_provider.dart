import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/core/storage/app_preferences.dart';
import 'package:spendora/core/theme/app_theme.dart';

part 'theme_provider.g.dart';

// We'll use Flutter's ThemeMode directly
// enum ThemeMode { system, light, dark }

@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Watch theme preference from shared preferences
    final themeModeAsync = ref.watch(themePreferenceProvider);

    return themeModeAsync.when(
      data: (themeMode) {
        // Convert string preference to ThemeMode
        switch (themeMode) {
          case 'dark':
            return ThemeMode.dark;
          case 'light':
            return ThemeMode.light;
          case 'system':
          default:
            return ThemeMode.system;
        }
      },
      loading: () => ThemeMode.system,
      error: (_, __) => ThemeMode.system,
    );
  }

  /// Set the theme mode and save to preferences
  Future<void> setThemeMode(ThemeMode mode) async {
    // Convert ThemeMode to string for storage
    String modeString;
    switch (mode) {
      case ThemeMode.dark:
        modeString = 'dark';
      case ThemeMode.light:
        modeString = 'light';
      case ThemeMode.system:
        modeString = 'system';
    }

    // Save to preferences
    await ref.read(themePreferenceProvider.notifier).setThemeMode(modeString);
  }

  ThemeData getTheme(BuildContext context) {
    switch (state) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        final platformBrightness = MediaQuery.platformBrightnessOf(context);
        return platformBrightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
    }
  }
}
