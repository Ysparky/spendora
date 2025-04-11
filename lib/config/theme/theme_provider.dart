import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/config/theme/app_theme.dart';

part 'theme_provider.g.dart';

enum ThemeMode { system, light, dark }

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _themePreferenceKey = 'theme_mode';

  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    // TODO: Implement persistence with SharedPreferences
  }

  ThemeData getTheme(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    switch (state) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        return platformBrightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
    }
  }
}
