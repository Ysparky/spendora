import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_preferences.g.dart';

/// Keys for app preferences
class AppPreferenceKeys {
  static const String themeMode = 'theme_mode';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String currency = 'currency';
}

/// Provider for shared preferences instance
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

/// Theme mode preferences provider
@Riverpod(keepAlive: true)
class ThemePreference extends _$ThemePreference {
  @override
  Future<String> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getString(AppPreferenceKeys.themeMode) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setString(AppPreferenceKeys.themeMode, mode);
    ref.invalidateSelf();
  }
}

/// Notifications preference provider
@Riverpod(keepAlive: true)
class NotificationsPreference extends _$NotificationsPreference {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getBool(AppPreferenceKeys.notificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled({bool enabled = false}) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setBool(AppPreferenceKeys.notificationsEnabled, enabled);
    ref.invalidateSelf();
  }
}

/// Currency preference provider
@Riverpod(keepAlive: true)
class CurrencyPreference extends _$CurrencyPreference {
  @override
  Future<String> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getString(AppPreferenceKeys.currency) ?? 'USD';
  }

  Future<void> setCurrency(String currency) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setString(AppPreferenceKeys.currency, currency);
    ref.invalidateSelf();
  }
}
