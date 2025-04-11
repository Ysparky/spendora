import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/router/app_router.dart';
import 'package:spendora/core/theme/app_theme.dart';
import 'package:spendora/features/auth/presentation/widgets/auth_error_listener.dart';
import 'package:spendora/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
    return MaterialApp.router(
      routerConfig: router,
      title: 'Spendora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // We'll make this configurable later
      builder: (context, child) {
        return AuthErrorListener(child: child ?? const SizedBox());
      },
    );
  }
}
