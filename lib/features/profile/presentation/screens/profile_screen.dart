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
    final state = ref.watch(profileStateProvider);
    final isLoading = state.isLoading;
    final loadingAction = state.action;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed:
                    isLoading ? null : () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
          // Show content
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
                  ProfileHeader(user: user),

                  const Divider(height: 32),

                  // Settings section
                  ProfileSettingsSection(user: user),

                  const Divider(height: 32),

                  // Account section
                  const ProfileAccountSection(),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),

        // Modal loading overlay with barrier (covers entire screen)
        if (isLoading &&
            (loadingAction == null || loadingAction == 'profileImage'))
          Positioned.fill(
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black.withOpacity(0.5),
            ),
          ),

        // Loading indicator over the barrier
        if (isLoading &&
            (loadingAction == null || loadingAction == 'profileImage'))
          const Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
