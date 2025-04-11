import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spendora/features/profile/presentation/controllers/user_profile_controller.dart';
import 'package:spendora/features/profile/presentation/widgets/settings_item.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('No se pudo cargar la información del perfil'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile header with image
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(context, ref),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: Icon(
                                Icons.camera_alt,
                                size: 15,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name ?? 'Sin nombre',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () =>
                          _showEditNameDialog(context, ref, user.name),
                      child: const Text('Editar nombre'),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              // Settings section
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
                onTap: () =>
                    _showCurrencyPicker(context, ref, user.currency ?? 'USD'),
              ),

              // Dark Mode
              SettingsItem(
                icon: Icons.dark_mode,
                title: 'Tema Oscuro',
                trailing: Switch(
                  value: user.darkMode ?? false,
                  onChanged: (value) {
                    ref
                        .read(userProfileControllerProvider.notifier)
                        .toggleDarkMode(darkMode: value);
                  },
                ),
              ),

              // Notifications
              SettingsItem(
                icon: Icons.notifications,
                title: 'Notificaciones',
                trailing: Switch(
                  value: user.notificationsEnabled ?? true,
                  onChanged: (value) {
                    ref
                        .read(userProfileControllerProvider.notifier)
                        .toggleNotifications(enabled: value);
                  },
                ),
              ),

              const Divider(height: 32),

              // Account section
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
                  onTap: () => _showChangePasswordDialog(context, ref),
                ),

              // Delete Account
              SettingsItem(
                icon: Icons.delete,
                title: 'Eliminar Cuenta',
                iconColor: Colors.red,
                onTap: () => _showDeleteAccountConfirmation(context, ref),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    // Show option to choose between camera and gallery
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(ImageSource.gallery, context, ref);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImage(ImageSource.camera, context, ref);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(
    ImageSource source,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        await ref
            .read(userProfileControllerProvider.notifier)
            .updateProfilePicture(File(pickedFile.path));
      }
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Firebase: $e')),
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String? currentName,
  ) {
    final nameController = TextEditingController(text: currentName);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ingresa tu nombre',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .updateDisplayName(nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
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
                onTap: () {
                  ref
                      .read(userProfileControllerProvider.notifier)
                      .updateCurrency(currency);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
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
            FilledButton(
              onPressed: () async {
                if (currentPasswordController.text.isEmpty ||
                    newPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todos los campos son obligatorios'),
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
                      content: Text('Contraseña actualizada exitosamente'),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error de autenticación: $e')),
                  );
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Guardar'),
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
          FilledButton(
            onPressed: () async {
              try {
                await ref
                    .read(userProfileControllerProvider.notifier)
                    .deleteAccount();

                if (!context.mounted) return;
                Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error de autenticación: $e')),
                );
              } on FirebaseException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error de Firebase: $e')),
                );
              } on Exception catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
