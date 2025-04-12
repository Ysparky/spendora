// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'50d46e3f8d9f32715d0f3efabdce724e4b2593b4';

/// Provider for shared preferences instance
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = FutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = FutureProviderRef<SharedPreferences>;
String _$themePreferenceHash() => r'6d2aee95451c68bd58468ac2e7b1554424fdb344';

/// Theme mode preferences provider
///
/// Copied from [ThemePreference].
@ProviderFor(ThemePreference)
final themePreferenceProvider =
    AsyncNotifierProvider<ThemePreference, String>.internal(
  ThemePreference.new,
  name: r'themePreferenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themePreferenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemePreference = AsyncNotifier<String>;
String _$notificationsPreferenceHash() =>
    r'9b608c47ae65ed7a6a58de6093454d94afb42276';

/// Notifications preference provider
///
/// Copied from [NotificationsPreference].
@ProviderFor(NotificationsPreference)
final notificationsPreferenceProvider =
    AsyncNotifierProvider<NotificationsPreference, bool>.internal(
  NotificationsPreference.new,
  name: r'notificationsPreferenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsPreferenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsPreference = AsyncNotifier<bool>;
String _$currencyPreferenceHash() =>
    r'555431f3feee635da1efa5970ba4dfd7ab1b1420';

/// Currency preference provider
///
/// Copied from [CurrencyPreference].
@ProviderFor(CurrencyPreference)
final currencyPreferenceProvider =
    AsyncNotifierProvider<CurrencyPreference, String>.internal(
  CurrencyPreference.new,
  name: r'currencyPreferenceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currencyPreferenceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrencyPreference = AsyncNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
