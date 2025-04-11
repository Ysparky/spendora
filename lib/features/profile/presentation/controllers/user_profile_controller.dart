import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spendora/core/services/image_optimization_service.dart';
import 'package:spendora/features/auth/data/repositories/user_repository.dart';
import 'package:spendora/features/auth/domain/models/user_model.dart';

part 'user_profile_controller.g.dart';

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  Future<UserModel?> build() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    return ref.watch(userRepositoryProvider).getUser(currentUser.uid);
  }

  Future<void> updateDisplayName(String name) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Update Firebase Auth profile
    await currentUser.updateDisplayName(name);

    // Get the current user data
    final userData =
        await ref.read(userRepositoryProvider).getUser(currentUser.uid);
    if (userData == null) return;

    // Update Firestore with the new name
    final updatedUser = userData.copyWith(name: name);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);

    // Reload the user to reflect changes
    await currentUser.reload();

    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> updateProfilePicture(File imageFile) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      // Optimize image before uploading
      final optimizedImageFile =
          await ImageOptimizationService.optimizeProfileImage(imageFile);

      // Get storage reference
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${currentUser.uid}.jpg');

      // Get optimized metadata
      final metadata = ImageOptimizationService.getProfileImageMetadata();

      // Upload optimized image with metadata
      await storageRef.putFile(optimizedImageFile, metadata);
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firebase Auth profile
      await currentUser.updatePhotoURL(downloadUrl);

      // Get the current user data
      final userData =
          await ref.read(userRepositoryProvider).getUser(currentUser.uid);
      if (userData == null) return;

      // Update Firestore with the new photo URL
      final updatedUser = userData.copyWith(photoUrl: downloadUrl);
      await ref.read(userRepositoryProvider).updateUser(updatedUser);

      // Reload the user to reflect changes
      await currentUser.reload();

      // Refresh state
      ref.invalidateSelf();
    } on FirebaseException catch (e) {
      // Handle errors (in a real app, this would use proper error handling)
      print('Error updating profile picture: $e');
    } on Exception catch (e) {
      print('Unexpected error updating profile picture: $e');
    }
  }

  Future<void> updateCurrency(String currency) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Get the current user data
    final userData =
        await ref.read(userRepositoryProvider).getUser(currentUser.uid);
    if (userData == null) return;

    // Update Firestore with the new currency preference
    final updatedUser = userData.copyWith(currency: currency);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);

    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> toggleDarkMode({required bool darkMode}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Get the current user data
    final userData =
        await ref.read(userRepositoryProvider).getUser(currentUser.uid);
    if (userData == null) return;

    // Update Firestore with the dark mode preference
    final updatedUser = userData.copyWith(darkMode: darkMode);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);

    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> toggleNotifications({required bool enabled}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Get the current user data
    final userData =
        await ref.read(userRepositoryProvider).getUser(currentUser.uid);
    if (userData == null) return;

    // Update Firestore with the notifications preference
    final updatedUser = userData.copyWith(notificationsEnabled: enabled);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);

    // Refresh state
    ref.invalidateSelf();
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    try {
      // Re-authenticate the user before changing password
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: currentPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);

      // Change the password
      await currentUser.updatePassword(newPassword);

      // Refresh state
      ref.invalidateSelf();
    } on FirebaseAuthException catch (e) {
      // Handle errors (in a real app, this would use proper error handling)
      print('Error changing password: $e');
      rethrow;
    } on Exception catch (e) {
      print('Unexpected error changing password: $e');
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      // Delete from Firestore first
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .delete();

      // Delete the user account from Firebase Auth
      await currentUser.delete();

      // No need to invalidate state since the user will be signed out
    } on FirebaseAuthException catch (e) {
      // Handle errors (in a real app, this would use proper error handling)
      print('Error deleting account: $e');
      rethrow;
    } on FirebaseException catch (e) {
      print('Firestore error deleting account: $e');
      rethrow;
    } on Exception catch (e) {
      print('Unexpected error deleting account: $e');
      rethrow;
    }
  }
}
