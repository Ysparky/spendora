import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spendora/features/profile/presentation/controllers/profile_state_controller.dart';
import 'package:spendora/features/profile/presentation/controllers/user_profile_controller.dart';
import 'package:spendora/features/profile/presentation/widgets/profile_account_section.dart';
import 'package:spendora/features/profile/presentation/widgets/profile_header.dart';
import 'package:spendora/features/profile/presentation/widgets/profile_settings_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileControllerProvider);
    final isLoading = ref.watch(profileLoadingProvider);
    final loadingAction = ref.watch(loadingActionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        // automaticallyImplyLeading: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: isLoading
                ? null
                : () {
                    FirebaseAuth.instance.signOut();
                  },
          ),
        ],
      ),
      // Show an overlay loading indicator when any action is in progress
      body: Stack(
        children: [
          userProfileAsync.when(
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
                  ProfileHeader(user: user),

                  const Divider(height: 32),

                  // Settings section
                  ProfileSettingsSection(
                    user: user,
                    isLoading: isLoading,
                    loadingAction: loadingAction,
                  ),

                  const Divider(height: 32),

                  // Account section
                  ProfileAccountSection(
                    isLoading: isLoading,
                    loadingAction: loadingAction,
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
          if (isLoading && loadingAction == null)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
