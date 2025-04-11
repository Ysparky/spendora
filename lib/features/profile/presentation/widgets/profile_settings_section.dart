import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/features/auth/domain/models/user_model.dart';
import 'package:spendora/features/profile/presentation/controllers/profile_state_controller.dart';
import 'package:spendora/features/profile/presentation/controllers/user_profile_controller.dart';
import 'package:spendora/features/profile/presentation/widgets/settings_item.dart';

class ProfileSettingsSection extends ConsumerWidget {
  const ProfileSettingsSection({
    required this.user,
    required this.isLoading,
    required this.loadingAction,
    super.key,
  });

  final UserModel user;
  final bool isLoading;
  final String? loadingAction;

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
          subtitle: user.currency ?? 'USD',
          trailing: loadingAction == 'currency'
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          onTap: isLoading
              ? null
              : () => _showCurrencyPicker(
                    context,
                    ref,
                    user.currency ?? 'USD',
                  ),
        ),

        // Dark Mode
        SettingsItem(
          icon: Icons.dark_mode,
          title: 'Tema Oscuro',
          trailing: loadingAction == 'theme'
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Switch(
                  value: user.darkMode ?? false,
                  onChanged: isLoading
                      ? null
                      : (value) async {
                          // Set loading state
                          ref.read(profileLoadingProvider.notifier).state =
                              true;
                          ref.read(loadingActionProvider.notifier).state =
                              'theme';

                          try {
                            await ref
                                .read(userProfileControllerProvider.notifier)
                                .toggleDarkMode(darkMode: value);
                          } finally {
                            // Reset loading state
                            ref.read(profileLoadingProvider.notifier).state =
                                false;
                            ref.read(loadingActionProvider.notifier).state =
                                null;
                          }
                        },
                ),
        ),

        // Notifications
        SettingsItem(
          icon: Icons.notifications,
          title: 'Notificaciones',
          trailing: loadingAction == 'notifications'
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Switch(
                  value: user.notificationsEnabled ?? true,
                  onChanged: isLoading
                      ? null
                      : (value) async {
                          // Set loading state
                          ref.read(profileLoadingProvider.notifier).state =
                              true;
                          ref.read(loadingActionProvider.notifier).state =
                              'notifications';

                          try {
                            await ref
                                .read(
                                  userProfileControllerProvider.notifier,
                                )
                                .toggleNotifications(enabled: value);
                          } finally {
                            // Reset loading state
                            ref.read(profileLoadingProvider.notifier).state =
                                false;
                            ref.read(loadingActionProvider.notifier).state =
                                null;
                          }
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
  String currentCurrency,
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
              trailing: currency == currentCurrency
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                Navigator.pop(context);

                // Set loading state
                ref.read(profileLoadingProvider.notifier).state = true;
                ref.read(loadingActionProvider.notifier).state = 'currency';

                try {
                  await ref
                      .read(userProfileControllerProvider.notifier)
                      .updateCurrency(currency);
                } finally {
                  // Reset loading state
                  ref.read(profileLoadingProvider.notifier).state = false;
                  ref.read(loadingActionProvider.notifier).state = null;
                }
              },
            );
          },
        ),
      ),
    ),
  );
}
