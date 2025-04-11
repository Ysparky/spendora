import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spendora/features/profile/presentation/controllers/profile_state_controller.dart';
import 'package:spendora/features/profile/presentation/controllers/user_profile_controller.dart';
import 'package:spendora/features/profile/presentation/widgets/settings_item.dart';

class ProfileAccountSection extends ConsumerWidget {
  const ProfileAccountSection({
    required this.isLoading,
    required this.loadingAction,
    super.key,
  });

  final bool isLoading;
  final String? loadingAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cuenta',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Change Password (only for email users)
        if (FirebaseAuth.instance.currentUser?.providerData.any(
              (info) => info.providerId == 'password',
            ) ??
            false)
          SettingsItem(
            icon: Icons.lock,
            title: 'Cambiar Contraseña',
            trailing: loadingAction == 'password'
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
            onTap: isLoading
                ? null
                : () => _showChangePasswordDialog(context, ref),
          ),

        // Delete Account
        SettingsItem(
          icon: Icons.delete,
          title: 'Eliminar Cuenta',
          iconColor: Colors.red,
          trailing: loadingAction == 'deleteAccount'
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.red,
                  ),
                )
              : null,
          onTap: isLoading
              ? null
              : () => _showDeleteAccountConfirmation(context, ref),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    var obscureCurrentPassword = true;
    var obscureNewPassword = true;
    var obscureConfirmPassword = true;

    showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cambiar contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureCurrentPassword = !obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                obscureText: obscureCurrentPassword,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNewPassword = !obscureNewPassword;
                      });
                    },
                  ),
                ),
                obscureText: obscureNewPassword,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva contraseña',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword = !obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: obscureConfirmPassword,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            Consumer(
              builder: (context, ref, _) {
                final isLoading = ref.watch(profileLoadingProvider);
                final loadingAction = ref.watch(loadingActionProvider);
                final isPasswordLoading =
                    isLoading && loadingAction == 'password';

                return FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (currentPasswordController.text.isEmpty ||
                              newPasswordController.text.isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Todos los campos son obligatorios'),
                              ),
                            );
                            return;
                          }

                          if (newPasswordController.text !=
                              confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Las contraseñas no coinciden'),
                              ),
                            );
                            return;
                          }

                          // Set loading state
                          ref.read(profileLoadingProvider.notifier).state =
                              true;
                          ref.read(loadingActionProvider.notifier).state =
                              'password';

                          try {
                            await ref
                                .read(userProfileControllerProvider.notifier)
                                .changePassword(
                                  currentPasswordController.text,
                                  newPasswordController.text,
                                );

                            if (!context.mounted) return;
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Contraseña actualizada exitosamente'),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error de autenticación: $e'),
                              ),
                            );
                          } on Exception catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            // Reset loading state if still mounted
                            if (context.mounted) {
                              ref.read(profileLoadingProvider.notifier).state =
                                  false;
                              ref.read(loadingActionProvider.notifier).state =
                                  null;
                            }
                          }
                        },
                  child: isPasswordLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Guardar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          '¿Estás seguro que deseas eliminar tu cuenta? '
          'Esta acción no se puede deshacer y perderás todos tus datos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          Consumer(
            builder: (context, ref, _) {
              final isLoading = ref.watch(profileLoadingProvider);
              final loadingAction = ref.watch(loadingActionProvider);
              final isDeleteLoading =
                  isLoading && loadingAction == 'deleteAccount';

              return FilledButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        Navigator.pop(context);

                        // Set loading state
                        ref.read(profileLoadingProvider.notifier).state = true;
                        ref.read(loadingActionProvider.notifier).state =
                            'deleteAccount';

                        try {
                          await ref
                              .read(userProfileControllerProvider.notifier)
                              .deleteAccount();
                        } on FirebaseAuthException catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error de autenticación: $e'),
                            ),
                          );
                        } on FirebaseException catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error de Firebase: $e')),
                          );
                        } on Exception catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        } finally {
                          // Reset loading state if still mounted
                          if (context.mounted) {
                            ref.read(profileLoadingProvider.notifier).state =
                                false;
                            ref.read(loadingActionProvider.notifier).state =
                                null;
                          }
                        }
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: isDeleteLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Eliminar'),
              );
            },
          ),
        ],
      ),
    );
  }
}
