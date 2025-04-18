import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendora/features/transactions/data/providers/transaction_providers.dart';
import 'package:spendora/features/transactions/domain/models/transaction_model.dart';

part 'dashboard_controller.g.dart';

/// Controller for managing dashboard data
@riverpod
class DashboardController extends _$DashboardController {
  @override
  AsyncValue<void> build() {
    // Initial state is void
    return const AsyncData(null);
  }

  /// Get the current user ID
  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to perform this action');
    }
    return user.uid;
  }

  /// Get all transactions for the current user
  Stream<List<TransactionModel>> getTransactions() {
    final repository = ref.read(transactionRepositoryProvider);
    return repository.getTransactions(_userId);
  }

  /// Get transactions for the current week
  Stream<List<TransactionModel>> getWeekTransactions() {
    final repository = ref.read(transactionRepositoryProvider);
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek
        .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

    return repository.getTransactionsByDateRange(
      _userId,
      startOfWeek,
      endOfWeek,
    );
  }

  /// Get transactions for the current month
  Stream<List<TransactionModel>> getMonthTransactions() {
    final repository = ref.read(transactionRepositoryProvider);
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return repository.getTransactionsByDateRange(
      _userId,
      startOfMonth,
      endOfMonth,
    );
  }

  /// Get transactions for the current year
  Stream<List<TransactionModel>> getYearTransactions() {
    final repository = ref.read(transactionRepositoryProvider);
    final now = DateTime.now();
    final startOfYear = DateTime(now.year);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);

    return repository.getTransactionsByDateRange(
      _userId,
      startOfYear,
      endOfYear,
    );
  }

  /// Get most recent transactions (limited to a specific count)
  Stream<List<TransactionModel>> getRecentTransactions({int limit = 5}) {
    final stream = getTransactions();
    return stream.map((transactions) => transactions.take(limit).toList());
  }

  /// Calculate financial summary from transactions
  Map<String, double> calculateFinancialSummary(
    List<TransactionModel> transactions,
  ) {
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }

    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
    };
  }

  /// Calculate spending by category
  Map<String, double> calculateCategorySpending(
    List<TransactionModel> transactions,
  ) {
    final categorySpending = <String, double>{};

    // Only consider expenses for category spending
    final expenses = transactions
        .where((transaction) => transaction.type == TransactionType.expense);

    for (final transaction in expenses) {
      final category = transaction.category.toLowerCase();
      categorySpending[category] =
          (categorySpending[category] ?? 0) + transaction.amount;
    }

    return categorySpending;
  }
}
