import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:spendora/features/auth/presentation/screens/auth_screen.dart';
import 'package:spendora/features/auth/presentation/screens/login_screen.dart';
import 'package:spendora/features/auth/presentation/screens/register_screen.dart';
import 'package:spendora/features/dashboard/presentation/screens/dashboard_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    // If not authenticated and not on auth route, redirect to auth
    if (!isAuthenticated && !isAuthRoute) {
      return '/';
    }

    // If authenticated and on auth route, redirect to dashboard
    if (isAuthenticated && isAuthRoute) {
      return '/dashboard';
    }

    return null;
  },
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
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
