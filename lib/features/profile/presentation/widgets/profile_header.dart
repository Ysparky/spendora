import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spendora/features/auth/domain/models/user_model.dart';
import 'package:spendora/features/profile/presentation/controllers/profile_image_controller.dart';
import 'package:spendora/features/profile/presentation/controllers/profile_state_controller.dart';

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
          _buildProfileAvatar(context, ref),
          const SizedBox(height: 8),
          _buildUserInfo(context, ref),
        ],
      ),
    );
  }

  /// Builds the profile avatar with edit functionality
  Widget _buildProfileAvatar(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _pickImage(context, ref),
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: user.photoUrl == null
                ? _buildDefaultAvatar(context)
                : _buildProfileImage(context, ref),
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
    );
  }

  /// Builds the default avatar icon when no photo is available
  Widget _buildDefaultAvatar(BuildContext context) {
    return Icon(
      Icons.person,
      size: 50,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  /// Builds the user profile image with caching
  Widget _buildProfileImage(BuildContext context, WidgetRef ref) {
    return ClipOval(
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
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  /// Builds the user information section with name and email
  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          user.name ?? 'Sin nombre',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: context.mounted
              ? () => _showEditNameDialog(context, ref, user.name)
              : null,
          child: const Text('Editar nombre'),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    if (!context.mounted || ref.read(profileStateProvider).isLoading) return;

    final imageController = ref.watch(profileImageControllerProvider.notifier);

    try {
      final source = await imageController.showImageSourcePicker(context);
      if (!context.mounted) return;

      // Check if user selected a source
      if (source == null) return;

      // Now process the image from selected source
      await _processSelectedImage(source, context, ref);
    } on Exception catch (e) {
      if (!context.mounted) return;
      imageController.handleException(
        context,
        'Error al abrir selector de imágenes: $e',
      );
    }
  }

  /// Processes and uploads the selected image
  Future<void> _processSelectedImage(
    ImageSource source,
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!context.mounted) return;
    final imageController = ref.watch(profileImageControllerProvider.notifier);

    try {
      final pickedFile = await imageController.pickImageFromSource(source);
      if (!context.mounted) return;

      if (pickedFile == null) {
        imageController.showFeedback(
          context,
          'No se seleccionó ninguna imagen',
        );
        return;
      }

      if (!context.mounted) return;
      print('uploading profile picture');
      await imageController.uploadProfilePicture(
        File(pickedFile.path),
        context,
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      imageController.handleException(
        context,
        'Error al seleccionar la imagen: $e',
      );
    }
  }

  /// Shows a dialog to edit the user's name
  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String? currentName,
  ) {
    if (!context.mounted) return;

    final nameController = TextEditingController(text: currentName);
    final imageController = ref.watch(profileImageControllerProvider.notifier);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          Consumer(
            builder: (dialogContext, ref, _) {
              final state = ref.watch(profileStateProvider);
              final isNameLoading = state.isLoading && state.action == 'name';

              return FilledButton(
                onPressed: state.isLoading
                    ? null
                    : () => imageController.updateDisplayName(
                          dialogContext,
                          nameController.text,
                        ),
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
