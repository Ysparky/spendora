import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:spendora/core/router/auth_notifier.dart';
import 'package:spendora/features/auth/presentation/screens/auth_screen.dart';
import 'package:spendora/features/auth/presentation/screens/login_screen.dart';
import 'package:spendora/features/auth/presentation/screens/register_screen.dart';
import 'package:spendora/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:spendora/features/profile/presentation/screens/profile_screen.dart';
import 'package:spendora/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:spendora/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:spendora/features/transactions/presentation/screens/transaction_detail_screen.dart';
import 'package:spendora/features/transactions/presentation/screens/transaction_list_screen.dart';
import 'package:spendora/features/budget/presentation/screens/budget_list_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
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
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionListScreen(),
      ),
      GoRoute(
        path: '/transactions/add',
        builder: (context, state) => const AddTransactionScreen(),
      ),
      GoRoute(
        path: '/transactions/details/:id',
        builder: (context, state) => TransactionDetailScreen(
          transactionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/transactions/edit/:id',
        builder: (context, state) => TransactionDetailScreen(
          transactionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: '/budgets',
        builder: (context, state) => const BudgetListScreen(),
      ),
      GoRoute(
        path: '/budgets/add',
        builder: (context, state) =>
            const BudgetListScreen(showAddBudgetForm: true),
      ),
    ],
  );
}
