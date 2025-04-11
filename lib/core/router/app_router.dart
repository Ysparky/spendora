import 'package:go_router/go_router.dart';

import 'package:spendora/features/auth/presentation/screens/auth_screen.dart';
import 'package:spendora/features/auth/presentation/screens/login_screen.dart';
import 'package:spendora/features/auth/presentation/screens/register_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
