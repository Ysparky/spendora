import 'package:flutter/material.dart' hide ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/storage/app_preferences.dart';
import 'package:spendora/core/theme/theme_provider.dart' as app_theme;
import 'package:spendora/features/auth/domain/models/user_model.dart';
import 'package:spendora/features/profile/presentation/widgets/settings_item.dart';

class ProfileSettingsSection extends ConsumerWidget {
  const ProfileSettingsSection({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ajustes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Currency
        SettingsItem(
          icon: Icons.attach_money,
          title: 'Moneda',
          subtitle: ref.watch(currencyPreferenceProvider).when(
                data: (currency) => currency,
                loading: () => 'USD',
                error: (_, __) => 'USD',
              ),
          onTap: () => _showCurrencyPicker(context, ref),
        ),

        // Dark Mode
        SettingsItem(
          icon: Icons.dark_mode,
          title: 'Tema Oscuro',
          trailing: Consumer(
            builder: (context, ref, child) {
              final themePreference = ref.watch(themePreferenceProvider);

              return themePreference.when(
                data: (themeMode) {
                  final isDarkMode = themeMode == 'dark';

                  return Switch(
                    value: isDarkMode,
                    onChanged: (value) async {
                      // Save to shared preferences
                      await ref
                          .read(themePreferenceProvider.notifier)
                          .setThemeMode(value ? 'dark' : 'light');

                      // Just invalidate the provider after setting preference
                      ref.invalidate(app_theme.themeNotifierProvider);
                    },
                  );
                },
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const Icon(Icons.error),
              );
            },
          ),
        ),

        // Notifications
        SettingsItem(
          icon: Icons.notifications,
          title: 'Notificaciones',
          trailing: Consumer(
            builder: (context, ref, child) {
              final notificationsPreference =
                  ref.watch(notificationsPreferenceProvider);

              return notificationsPreference.when(
                data: (enabled) {
                  return Switch(
                    value: enabled,
                    onChanged: (value) async {
                      // Save to shared preferences
                      await ref
                          .read(notificationsPreferenceProvider.notifier)
                          .setNotificationsEnabled(enabled: value);
                    },
                  );
                },
                loading: () => const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, __) => const Icon(Icons.error),
              );
            },
          ),
        ),
      ],
    );
  }
}

void _showCurrencyPicker(
  BuildContext context,
  WidgetRef ref,
) {
  final currencies = ['USD', 'EUR', 'GBP', 'MXN', 'COP', 'ARS', 'CLP'];

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Seleccionar moneda'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            final currency = currencies[index];
            return ListTile(
              title: Text(currency),
              trailing: currency ==
                      ref.watch(currencyPreferenceProvider).when(
                            data: (currency) => currency,
                            loading: () => 'USD',
                            error: (_, __) => 'USD',
                          )
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                Navigator.pop(context);
                // Save currency to preferences
                await ref
                    .read(currencyPreferenceProvider.notifier)
                    .setCurrency(currency);
              },
            );
          },
        ),
      ),
    ),
  );
}
