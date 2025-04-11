import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spendora/firebase_options.dart';
import 'package:spendora/config/theme/app_theme.dart';
import 'package:spendora/presentation/screens/theme_showcase.dart';

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
    return MaterialApp(
      title: 'Spendora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // We'll make this configurable later
      home: const ThemeShowcase(),
    );
  }
}
