import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spendora/core/config/env_config.dart';
import 'package:spendora/core/router/app_router.dart';
import 'package:spendora/core/theme/app_theme.dart';
import 'package:spendora/core/theme/theme_provider.dart' as app_theme;
import 'package:spendora/features/auth/presentation/widgets/auth_error_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  await EnvConfig.init();

  // Initialize Firebase with options from environment
  await Firebase.initializeApp(options: EnvConfig.firebaseOptions);

  runApp(
    const ProviderScope(
      child: SpendoraApp(),
    ),
  );
}

class SpendoraApp extends ConsumerWidget {
  const SpendoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themePref = ref.watch(app_theme.themeNotifierProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Spendora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themePref,
      builder: (context, child) {
        return AuthErrorListener(child: child ?? const SizedBox());
      },
    );
  }
}
