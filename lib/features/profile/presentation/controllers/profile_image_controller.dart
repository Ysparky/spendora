import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spendora/features/profile/presentation/controllers/profile_state_controller.dart';
import 'package:spendora/features/profile/presentation/controllers/user_profile_controller.dart';

part 'profile_image_controller.g.dart';

/// Controller for handling profile image operations
@Riverpod(keepAlive: true)
class ProfileImageController extends _$ProfileImageController {
  final _imagePicker = ImagePicker();

  @override
  FutureOr<void> build() {
    // No initial state needed
    return Future.value();
  }

  /// Shows a modal for selecting image source
  Future<ImageSource?> showImageSourcePicker(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
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
  }

  /// Picks an image from the specified source
  Future<XFile?> pickImageFromSource(ImageSource source) async {
    return _imagePicker.pickImage(
      source: source,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );
  }

  /// Uploads profile picture and updates the UI state
  Future<void> uploadProfilePicture(
    File imageFile,
    BuildContext context,
  ) async {
    // Set loading state
    ref.read(profileStateProvider.notifier).startLoading('profileImage');

    try {
      await ref
          .read(userProfileControllerProvider.notifier)
          .updateProfilePicture(imageFile);

      if (!context.mounted) return;
      showFeedback(context, 'Imagen de perfil actualizada');
    } on Exception catch (e) {
      handleException(context, 'Error al actualizar la imagen: $e');
    } finally {
      if (context.mounted) {
        // Always reset loading state
        ref.read(profileStateProvider.notifier).stopLoading();
      }
    }
  }

  /// Updates the user's display name
  Future<void> updateDisplayName(
    BuildContext context,
    String name,
  ) async {
    if (name.isEmpty) return;

    // Set loading state
    ref.read(profileStateProvider.notifier).startLoading('name');

    try {
      await ref
          .read(userProfileControllerProvider.notifier)
          .updateDisplayName(name);

      if (!context.mounted) return;
      Navigator.pop(context);
    } finally {
      // Reset loading state if still mounted
      if (context.mounted) {
        ref.read(profileStateProvider.notifier).stopLoading();
      }
    }
  }

  /// Displays a feedback message to the user
  void showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Handles exceptions and shows error messages
  void handleException(BuildContext context, String errorMessage) {
    if (!context.mounted) return;

    // Reset loading state if there's an error
    ref.read(profileStateProvider.notifier).stopLoading();

    showFeedback(context, errorMessage);
  }
}
