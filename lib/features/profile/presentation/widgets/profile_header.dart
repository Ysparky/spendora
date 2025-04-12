import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spendora/features/auth/domain/models/user_model.dart';
import 'package:spendora/features/profile/presentation/controllers/profile_state_controller.dart';
import 'package:spendora/features/profile/presentation/controllers/user_profile_controller.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(context, ref),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: user.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.photoUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            memCacheWidth: 200, // For high-DPI screens
                            memCacheHeight: 200,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
            onPressed: () => _showEditNameDialog(context, ref, user.name),
            child: const Text('Editar nombre'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    if (ref.read(profileStateProvider).isLoading) return;

    try {
      final result = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Tomar foto'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galería'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      // Check if context is still mounted and if user selected a source
      if (!context.mounted || result == null) return;

      // Now call _getImage with the selected source
      await _getImage(result, context, ref);
    } on Exception catch (e) {
      // Handle any exceptions from the modal bottom sheet
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir selector de imágenes: $e')),
      );
    }
  }

  Future<void> _getImage(
    ImageSource source,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        try {
          // Set loading state
          ref.read(profileStateProvider.notifier).startLoading('profileImage');

          await ref
              .read(userProfileControllerProvider.notifier)
              .updateProfilePicture(File(pickedFile.path));

          if (!context.mounted) return;

          // Reset loading state
          ref.read(profileStateProvider.notifier).stopLoading();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imagen de perfil actualizada')),
          );
        } on Exception catch (e) {
          if (!context.mounted) return;

          // Reset loading state
          ref.read(profileStateProvider.notifier).stopLoading();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar la imagen: $e')),
          );
        }
      } else {
        // No image was selected, reset state
        print('No se seleccionó ninguna imagen');

        // Check if context is still mounted before showing SnackBar
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ninguna imagen')),
        );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;

      // Reset loading state
      ref.read(profileStateProvider.notifier).stopLoading();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar la imagen: $e')),
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
          Consumer(
            builder: (context, ref, _) {
              final isLoading = ref.watch(profileStateProvider).isLoading;
              final loadingAction = ref.watch(profileStateProvider).action;
              final isNameLoading = isLoading && loadingAction == 'name';

              return FilledButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (nameController.text.isNotEmpty) {
                          // Set loading state
                          ref
                              .read(profileStateProvider.notifier)
                              .startLoading('name');

                          try {
                            await ref
                                .read(userProfileControllerProvider.notifier)
                                .updateDisplayName(nameController.text);

                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } finally {
                            // Reset loading state
                            if (context.mounted) {
                              ref
                                  .read(profileStateProvider.notifier)
                                  .stopLoading();
                            }
                          }
                        }
                      },
                child: isNameLoading
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
    );
  }
}
